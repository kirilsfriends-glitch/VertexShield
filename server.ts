import express from "express";
import { createServer as createViteServer } from "vite";
import path from "path";
import { fileURLToPath } from "url";
import fs from "fs";
import { initializeApp, credential } from "firebase-admin";
import { getApps, getApp } from "firebase-admin/app";
import { getFirestore } from "firebase-admin/firestore";

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

// Initialize Firebase Admin
const configPath = path.join(__dirname, "firebase-applet-config.json");
let db: any;

async function startServer() {
  const app = express();
  const PORT = 3000;

  // Initialize Firebase Admin
  if (fs.existsSync(configPath)) {
    try {
      const firebaseConfig = JSON.parse(fs.readFileSync(configPath, "utf-8"));
      console.log("Initializing Firebase Admin...");
      
      if (getApps().length === 0) {
        initializeApp({
          credential: credential.applicationDefault(),
          projectId: firebaseConfig.projectId,
        });
      }

      const dbId = firebaseConfig.firestoreDatabaseId;
      console.log("Targeting Firestore Database ID:", dbId || "(default)");
      
      const firebaseApp = getApp();
      
      const tryInitDb = async (id?: string) => {
        const firestore = id && id !== "(default)" ? getFirestore(firebaseApp, id) : getFirestore(firebaseApp);
        try {
          await firestore.listCollections();
          console.log(`Successfully connected to Firestore Admin (${id || "default"})`);
          return firestore;
        } catch (err: any) {
          console.error(`Firestore Admin connection failed for ${id || "default"}:`, err.message);
          throw err;
        }
      };

      try {
        db = await tryInitDb(dbId);
      } catch (err) {
        if (dbId && dbId !== "(default)") {
          console.log("Attempting fallback to default database...");
          try {
            db = await tryInitDb();
          } catch (fallbackErr) {
            console.error("All Firestore connection attempts failed.");
            db = getFirestore(firebaseApp);
          }
        } else {
          db = getFirestore(firebaseApp);
        }
      }
    } catch (error) {
      console.error("Error initializing Firebase Admin:", error);
    }
  } else {
    console.warn("Firebase config not found, admin SDK not initialized.");
  }

  app.use(express.json());

  // API Endpoint for raw content (New structure)
  app.get("/scripts/hosted/:pasteIdWithExt", async (req, res) => {
    const { pasteIdWithExt } = req.params;
    
    // Strip .lua or other extensions if present
    const pasteId = pasteIdWithExt.split('.')[0];
    
    if (!db) {
      console.error("Firestore database not initialized");
      return res.status(500).send("Database connection error");
    }
    
    // Get client IP
    let clientIp = req.headers["x-forwarded-for"] || req.socket.remoteAddress;
    if (Array.isArray(clientIp)) clientIp = clientIp[0];
    if (typeof clientIp === 'string' && clientIp.includes(',')) {
      clientIp = clientIp.split(',')[0].trim();
    }

    const clientFingerprint = req.headers["x-device-fingerprint"];

    try {
      const pasteDoc = await db.collection("pastes").doc(pasteId).get();
      if (!pasteDoc.exists) {
        return res.status(404).send("Paste not found");
      }

      const paste = pasteDoc.data();
      if (!paste) return res.status(404).send("Paste data not found");
      
      // Verification logic
      const ipMatches = paste.creatorIp === clientIp;
      const fingerprintMatches = paste.creatorFingerprint === clientFingerprint;

      if (!paste.isPublic && !ipMatches && !fingerprintMatches) {
        const currentUrl = `${req.protocol}://${req.get('host')}${req.originalUrl}`;
        return res.send(currentUrl); 
      }

      // If verified or public, return the content
      // Use obfuscated content if it exists and was requested (or just default to it if it's there)
      const content = paste.obfuscatedContent || paste.content;
      
      res.setHeader("Content-Type", "text/plain");
      res.send(content);
    } catch (error) {
      console.error("Error fetching paste:", error);
      res.status(500).send("Internal server error");
    }
  });

  // Vite middleware for development
  if (process.env.NODE_ENV !== "production") {
    const vite = await createViteServer({
      server: { middlewareMode: true },
      appType: "spa",
    });
    app.use(vite.middlewares);
  } else {
    const distPath = path.join(process.cwd(), 'dist');
    app.use(express.static(distPath));
    app.get('*', (req, res) => {
      res.sendFile(path.join(distPath, 'index.html'));
    });
  }

  app.listen(PORT, "0.0.0.0", () => {
    console.log(`Server running on http://localhost:${PORT}`);
  });
}

startServer();
