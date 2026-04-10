import express from "express";
import path from "path";
import { fileURLToPath } from "url";
import fs from "fs";

// Global error handlers for better diagnostics on Vercel
process.on("unhandledRejection", (reason, promise) => {
  console.error("Unhandled Rejection at:", promise, "reason:", reason);
});

process.on("uncaughtException", (err) => {
  console.error("Uncaught Exception:", err);
});

// ✅ ИСПРАВЛЕНО: правильные импорты для firebase-admin v10+
import { initializeApp, cert, getApps, getApp } from "firebase-admin/app";
import { getFirestore } from "firebase-admin/firestore";

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

let db: any;

async function initFirebase() {
  if (db) return db;

  try {
    console.log("Initializing Firebase Admin...");

    if (getApps().length === 0) {
      const configPath = path.join(process.cwd(), "firebase-applet-config.json");
      let firebaseConfig: any = null;
      
      if (fs.existsSync(configPath)) {
        try {
          firebaseConfig = JSON.parse(fs.readFileSync(configPath, "utf-8"));
        } catch (e) {
          console.error("Error parsing firebase-applet-config.json:", e);
        }
      }

      // 1. Try Service Account from Env Var (Vercel/Production)
      if (process.env.FIREBASE_SERVICE_ACCOUNT) {
        try {
          const serviceAccount = JSON.parse(process.env.FIREBASE_SERVICE_ACCOUNT);
          initializeApp({
            credential: cert(serviceAccount),
            projectId: serviceAccount.project_id || firebaseConfig?.projectId,
          });
          console.log("Firebase Admin initialized from FIREBASE_SERVICE_ACCOUNT env var.");
        } catch (e) {
          console.error("Failed to parse FIREBASE_SERVICE_ACCOUNT env var:", e);
        }
      } 
      
      // 2. Try Service Account from config file (if it contains private_key)
      if (getApps().length === 0 && firebaseConfig?.private_key) {
        try {
          initializeApp({
            credential: cert(firebaseConfig),
            projectId: firebaseConfig.project_id || firebaseConfig.projectId,
          });
          console.log("Firebase Admin initialized from service account in config file.");
        } catch (e) {
          console.error("Failed to initialize from service account in config file:", e);
        }
      }

      // 3. Fallback to Project ID (works in Cloud Run / Local with ADC)
      if (getApps().length === 0) {
        const projectId = firebaseConfig?.projectId || process.env.GOOGLE_CLOUD_PROJECT;
        if (projectId) {
          initializeApp({ projectId });
          console.log(`Firebase Admin initialized with Project ID: ${projectId}`);
        } else {
          initializeApp();
          console.log("Firebase Admin initialized with default credentials.");
        }
      }

      if (getApps().length === 0) {
        console.error("No Firebase credentials or Project ID found for initialization.");
        return null;
      }
    }

    const firebaseApp = getApp();
    const configPath = path.join(process.cwd(), "firebase-applet-config.json");
    const firebaseConfig = fs.existsSync(configPath) ? JSON.parse(fs.readFileSync(configPath, "utf-8")) : null;

    const dbId = process.env.FIRESTORE_DATABASE_ID || firebaseConfig?.firestoreDatabaseId;
    
    // Use named database if provided, otherwise default
    const firestoreDb = (dbId && dbId !== "(default)")
      ? getFirestore(firebaseApp, dbId)
      : getFirestore(firebaseApp);

    // Set db immediately to avoid blocking server startup
    db = firestoreDb;
    
    // Test connection asynchronously
    firestoreDb.collection("pastes").limit(1).get()
      .then(() => console.log(`Firestore Admin successfully connected to ${dbId || "(default)"}`))
      .catch((error: any) => {
        console.warn(`Initial Firestore connection test failed for ${dbId || "(default)"}:`, error.message);
        // We don't throw here to avoid crashing the server
      });
    
    return db;
  } catch (error) {
    console.error("Error initializing Firebase Admin:", error);
    return null;
  }
}

async function startServer() {
  const app = express();
  const PORT = 3000;

  await initFirebase();

  app.use(express.json());

  const scriptHandler = async (req: any, res: any) => {
    const { pasteIdWithExt } = req.params;
    const pasteId = pasteIdWithExt.split(".")[0];
    const userAgent = req.headers["user-agent"] || "";
    const isRoblox = userAgent.includes("Roblox") || 
                     userAgent.includes("RobloxApp") || 
                     userAgent.includes("Synapse") || 
                     userAgent.includes("Sentinel") || 
                     userAgent.includes("Krnl") ||
                     userAgent.includes("Fluxus") ||
                     userAgent.includes("Electron");

    if (!db) {
      await initFirebase();
      if (!db) {
        console.error("Firestore database not initialized");
        return res.status(500).send("Database connection error");
      }
    }

    // Set CORS early for all script requests
    res.setHeader("Access-Control-Allow-Origin", "*");
    res.setHeader("Access-Control-Allow-Methods", "GET, OPTIONS");
    res.setHeader("Access-Control-Allow-Headers", "Content-Type, x-device-fingerprint");
    res.setHeader("Content-Type", "text/plain; charset=utf-8");
    res.setHeader("X-Content-Type-Options", "nosniff");
    res.setHeader("Cache-Control", "no-store, no-cache, must-revalidate, proxy-revalidate");
    res.setHeader("Pragma", "no-cache");
    res.setHeader("Expires", "0");

    if (req.method === "OPTIONS") {
      return res.sendStatus(200);
    }

    const accept = req.headers["accept"] || "";
    const isBrowser = accept.includes("text/html");
    const hasLuaExt = pasteIdWithExt.endsWith(".lua");

    // If it has .lua extension OR is NOT a browser, serve raw
    // If it's a browser and NOT explicitly asking for raw, redirect to UI
    if (isBrowser && !req.query.raw && !hasLuaExt) {
      return res.redirect(`/paste/${pasteId}`);
    }

    let clientIp = req.headers["x-forwarded-for"] || req.socket.remoteAddress;
    if (Array.isArray(clientIp)) clientIp = clientIp[0];
    if (typeof clientIp === "string" && clientIp.includes(",")) {
      clientIp = clientIp.split(",")[0].trim();
    }

    const clientFingerprint = req.headers["x-device-fingerprint"];

    try {
      const pasteDoc = await db.collection("pastes").doc(pasteId).get();
      if (!pasteDoc.exists) {
        return res.status(404).send("-- VertexShield: Paste not found");
      }

      const paste = pasteDoc.data();
      if (!paste) return res.status(404).send("-- VertexShield: Paste data not found");

      const ipMatches = paste.creatorIp === clientIp;
      const fingerprintMatches = paste.creatorFingerprint === clientFingerprint;

      // For Roblox, we allow access if it's public OR if it's from a Roblox agent
      // We are more lenient with Roblox to ensure scripts actually run
      if (!paste.isPublic && !isRoblox && !ipMatches && !fingerprintMatches) {
        const currentUrl = `${req.protocol}://${req.get("host")}/paste/${pasteId}`;
        return res.send(`-- VertexShield: Access Denied. This is a private paste.\n-- View at: ${currentUrl}`);
      }

      const content = paste.obfuscatedContent || paste.content;
      return res.send(content);
    } catch (error: any) {
      console.error("Error fetching paste:", error);
      return res.status(500).send(`Internal server error: ${error.message || "Unknown error"}`);
    }
  };

  app.get("/script/:pasteIdWithExt", scriptHandler);

  // Health check
  app.get("/api/health", (req, res) => {
    res.json({ status: "ok", env: process.env.NODE_ENV });
  });

  if (process.env.NODE_ENV !== "production") {
    const { createServer: createViteServer } = await import("vite");
    const vite = await createViteServer({
      server: { middlewareMode: true },
      appType: "spa",
    });
    app.use(vite.middlewares);
  }

  return app;
}

const appPromise = startServer().catch((err) => {
  console.error("Failed to start server:", err);
  throw err;
});

if (process.env.NODE_ENV !== "production") {
  appPromise.then((app) => {
    app.listen(3000, "0.0.0.0", () => {
      console.log(`Server running on http://localhost:3000`);
    });
  });
}

export default async (req: any, res: any) => {
  try {
    const app = await appPromise;
    return app(req, res);
  } catch (err) {
    console.error("Error in Vercel handler:", err);
    res.status(500).send("Internal Server Error during startup");
  }
};
