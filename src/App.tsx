import { useState, useEffect, useRef } from "react";
import { BrowserRouter as Router, Routes, Route, Link, useNavigate, useParams } from "react-router-dom";
import { motion, AnimatePresence } from "motion/react";
import { 
  Plus, 
  History, 
  LogIn, 
  LogOut, 
  Shield, 
  Code, 
  FileCode, 
  Copy, 
  Check, 
  Download, 
  Eye, 
  Lock, 
  Globe, 
  Upload,
  Terminal,
  Cpu,
  Fingerprint,
  Zap,
  ExternalLink,
  ChevronRight,
  FileText,
  ShieldCheck,
  Bug,
  Radar,
  Activity,
  SlidersHorizontal
} from "lucide-react";
import { 
  auth, 
  db, 
  googleProvider, 
  signInWithPopup, 
  signOut, 
  collection, 
  addDoc, 
  doc, 
  getDoc, 
  setDoc,
  Timestamp,
  onSnapshot
} from "./firebase";
import { getDeviceFingerprint, getClientIp } from "./utils/fingerprint";
import { obfuscateCode, type LuaProtectionOptions } from "./utils/obfuscator";
import { PrismLight as SyntaxHighlighter } from "react-syntax-highlighter";
import { vscDarkPlus } from "react-syntax-highlighter/dist/esm/styles/prism";
import { lua, javascript, typescript, python, css, markup as html } from "react-syntax-highlighter/dist/esm/languages/prism";

// Register Languages
SyntaxHighlighter.registerLanguage('lua', lua);
SyntaxHighlighter.registerLanguage('javascript', javascript);
SyntaxHighlighter.registerLanguage('typescript', typescript);
SyntaxHighlighter.registerLanguage('python', python);
SyntaxHighlighter.registerLanguage('css', css);
SyntaxHighlighter.registerLanguage('html', html);

import { Toaster, toast } from "sonner";
import { clsx, type ClassValue } from "clsx";
import { twMerge } from "tailwind-merge";
import PasteHistory from "./components/PasteHistory";
import React from "react";

function cn(...inputs: ClassValue[]) {
  return twMerge(clsx(inputs));
}

// --- Error Handling ---

export enum OperationType {
  CREATE = 'create',
  UPDATE = 'update',
  DELETE = 'delete',
  LIST = 'list',
  GET = 'get',
  WRITE = 'write',
}

export interface FirestoreErrorInfo {
  error: string;
  operationType: OperationType;
  path: string | null;
  authInfo: {
    userId: string | undefined;
    email: string | null | undefined;
    emailVerified: boolean | undefined;
    isAnonymous: boolean | undefined;
    tenantId: string | null | undefined;
    providerInfo: {
      providerId: string;
      displayName: string | null;
      email: string | null;
      photoUrl: string | null;
    }[];
  }
}

export function handleFirestoreError(error: unknown, operationType: OperationType, path: string | null) {
  const errInfo: FirestoreErrorInfo = {
    error: error instanceof Error ? error.message : String(error),
    authInfo: {
      userId: auth.currentUser?.uid,
      email: auth.currentUser?.email,
      emailVerified: auth.currentUser?.emailVerified,
      isAnonymous: auth.currentUser?.isAnonymous,
      tenantId: auth.currentUser?.tenantId,
      providerInfo: auth.currentUser?.providerData.map(provider => ({
        providerId: provider.providerId,
        displayName: provider.displayName,
        email: provider.email,
        photoUrl: provider.photoURL
      })) || []
    },
    operationType,
    path
  }
  console.error('Firestore Error: ', JSON.stringify(errInfo));
  throw new Error(JSON.stringify(errInfo));
}

class ErrorBoundary extends React.Component<{ children: React.ReactNode }, { hasError: boolean, errorInfo: string | null }> {
  constructor(props: { children: React.ReactNode }) {
    super(props);
    this.state = { hasError: false, errorInfo: null };
  }

  static getDerivedStateFromError(error: any) {
    return { hasError: true, errorInfo: error.message };
  }

  render() {
    if (this.state.hasError) {
      let displayMessage = "Something went wrong.";
      try {
        const parsed = JSON.parse(this.state.errorInfo || "");
        if (parsed.error) displayMessage = `Firestore Error: ${parsed.error} (${parsed.operationType} on ${parsed.path})`;
      } catch (e) {
        displayMessage = this.state.errorInfo || displayMessage;
      }

      return (
        <div className="min-h-screen bg-black flex items-center justify-center p-4">
          <div className="max-w-md w-full bg-zinc-900 border border-zinc-800 p-8 rounded-2xl text-center space-y-6">
            <div className="p-4 bg-red-500/10 rounded-full w-fit mx-auto">
              <Shield className="h-12 w-12 text-red-500" />
            </div>
            <h1 className="text-2xl font-bold text-white">Application Error</h1>
            <p className="text-zinc-500 text-sm">{displayMessage}</p>
            <button 
              onClick={() => window.location.reload()}
              className="w-full py-3 bg-primary text-black font-bold rounded-xl hover:bg-primary/90 transition-all"
            >
              Reload Application
            </button>
          </div>
        </div>
      );
    }

    return this.props.children;
  }
}

// --- Components ---

const Navbar = () => {
  const [user, setUser] = useState(auth.currentUser);

  useEffect(() => {
    return auth.onAuthStateChanged((u) => setUser(u));
  }, []);

  const handleLogin = async () => {
    try {
      await signInWithPopup(auth, googleProvider);
      toast.success("Successfully logged in!");
    } catch (error) {
      toast.error("Failed to login");
    }
  };

  const handleLogout = async () => {
    try {
      await signOut(auth);
      toast.success("Logged out");
    } catch (error) {
      toast.error("Failed to logout");
    }
  };

  return (
    <nav className="fixed top-0 left-0 right-0 z-50 border-b border-zinc-800 bg-black/50 backdrop-blur-xl">
      <div className="max-w-7xl mx-auto px-4 h-16 flex items-center justify-between">
        <Link to="/" className="flex items-center gap-2 group">
          <div className="p-2 bg-primary/10 rounded-lg group-hover:bg-primary/20 transition-colors">
            <Shield className="h-6 w-6 text-primary" />
          </div>
          <span className="text-xl font-bold tracking-tighter text-white">VERTEX<span className="text-primary">SHIELD</span></span>
        </Link>

        <div className="flex items-center gap-6">
          <Link to="/" className="text-sm font-medium text-zinc-400 hover:text-white transition-colors">Create</Link>
          {user && (
            <Link to="/history" className="text-sm font-medium text-zinc-400 hover:text-white transition-colors">History</Link>
          )}
          
          <div className="h-4 w-px bg-zinc-800" />

          {user ? (
            <div className="flex items-center gap-4">
              <div className="flex items-center gap-2">
                <img src={user.photoURL || ""} alt="" className="h-8 w-8 rounded-full border border-zinc-800" referrerPolicy="no-referrer" />
                <span className="text-sm font-medium text-zinc-300 hidden sm:block">{user.displayName}</span>
              </div>
              <button onClick={handleLogout} className="p-2 hover:bg-zinc-800 rounded-lg text-zinc-400 hover:text-white transition-all">
                <LogOut className="h-5 w-5" />
              </button>
            </div>
          ) : (
            <button 
              onClick={handleLogin}
              className="flex items-center gap-2 px-4 py-2 bg-white text-black rounded-lg font-medium hover:bg-zinc-200 transition-all"
            >
              <LogIn className="h-4 w-4" />
              <span>Login</span>
            </button>
          )}
        </div>
      </div>
    </nav>
  );
};

const DEFAULT_LUA_PROTECTION: LuaProtectionOptions = {
  level: "hardened",
  antiDump: true,
  antiHook: true,
  envLogging: false,
  envLogConsole: false,
  webhookUrl: "",
  responseMode: "silent",
  watchdog: false,
};

const ProtToggle = ({
  checked,
  onChange,
  label,
  hint,
  icon,
}: {
  checked: boolean;
  onChange: (v: boolean) => void;
  label: string;
  hint: string;
  icon: React.ReactNode;
}) => (
  <label className="flex items-start gap-3 p-3 rounded-xl border border-zinc-800 bg-black/40 cursor-pointer group hover:border-zinc-700 transition-colors">
    <input type="checkbox" checked={checked} onChange={(e) => onChange(e.target.checked)} className="hidden" />
    <div
      className={cn(
        "mt-0.5 w-9 h-5 rounded-full transition-all relative shrink-0",
        checked ? "bg-primary" : "bg-zinc-800",
      )}
    >
      <div
        className={cn(
          "absolute top-0.5 left-0.5 w-4 h-4 bg-white rounded-full transition-all",
          checked ? "translate-x-4" : "translate-x-0",
        )}
      />
    </div>
    <div className="min-w-0">
      <div className="flex items-center gap-1.5 text-sm font-medium text-zinc-200">
        {icon}
        <span>{label}</span>
      </div>
      <p className="text-xs text-zinc-500 mt-0.5 leading-relaxed">{hint}</p>
    </div>
  </label>
);

const CreatePaste = () => {
  const [title, setTitle] = useState("");
  const [content, setContent] = useState("");
  const [language, setLanguage] = useState("javascript");
  const [isPublic, setIsPublic] = useState(false);
  const [shouldObfuscate, setShouldObfuscate] = useState(true);
  const [protection, setProtection] = useState<LuaProtectionOptions>(DEFAULT_LUA_PROTECTION);
  const [showProtection, setShowProtection] = useState(false);
  const setProt = <K extends keyof LuaProtectionOptions>(key: K, value: LuaProtectionOptions[K]) =>
    setProtection((prev) => ({ ...prev, [key]: value }));
  const [isSubmitting, setIsSubmitting] = useState(false);
  const fileInputRef = useRef<HTMLInputElement>(null);
  const navigate = useNavigate();

  const handleFileUpload = (e: React.ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files?.[0];
    if (file) {
      const reader = new FileReader();
      reader.onload = (event) => {
        setContent(event.target?.result as string);
        setTitle(file.name);
        // Try to guess language from extension
        const ext = file.name.split('.').pop();
        if (ext === 'js') setLanguage('javascript');
        if (ext === 'ts') setLanguage('typescript');
        if (ext === 'py') setLanguage('python');
        if (ext === 'css') setLanguage('css');
        if (ext === 'html') setLanguage('html');
        if (ext === 'lua') setLanguage('lua');
      };
      reader.readAsText(file);
    }
  };

  const handleSubmit = async () => {
    if (!content.trim()) {
      toast.error("Please enter some content");
      return;
    }

    if (!auth.currentUser) {
      toast.error("Please login to create a paste");
      return;
    }

    setIsSubmitting(true);
    const path = "pastes";
    try {
      const ip = await getClientIp();
      const fingerprint = getDeviceFingerprint();
      const obfuscated = (shouldObfuscate && (language === 'javascript' || language === 'typescript' || language === 'lua')) ? obfuscateCode(content, language, protection) : content;

      const docRef = await addDoc(collection(db, path), {
        title: title || "Untitled Paste",
        content,
        obfuscatedContent: obfuscated,
        creatorId: auth.currentUser.uid,
        creatorIp: ip,
        creatorFingerprint: fingerprint,
        createdAt: Timestamp.now(),
        isPublic,
        language,
        protectionOptions: language === 'lua' && shouldObfuscate ? {
          level: protection.level ?? 'hardened',
          antiDump: protection.antiDump !== false,
          antiHook: protection.antiHook !== false,
          envLogging: !!protection.envLogging,
          envLogConsole: !!protection.envLogConsole,
          webhookUrl: protection.webhookUrl || '',
          responseMode: protection.responseMode ?? 'silent',
          watchdog: !!protection.watchdog
        } : null
      });

      toast.success("Paste created successfully!");
      navigate(`/paste/${docRef.id}`);
    } catch (error) {
      handleFirestoreError(error, OperationType.WRITE, path);
    } finally {
      setIsSubmitting(false);
    }
  };

  return (
    <div className="max-w-4xl mx-auto pt-24 pb-12 px-4">
      <motion.div 
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        className="space-y-8"
      >
        <div className="flex flex-col gap-2">
          <h1 className="text-4xl font-bold tracking-tight text-white">Create VertexShield Paste</h1>
          <p className="text-zinc-500">Your code is protected with device and IP verification.</p>
        </div>

        <div className="grid gap-6 bg-zinc-900/50 border border-zinc-800 p-6 rounded-2xl">
          <div className="grid sm:grid-cols-2 gap-4">
            <div className="space-y-2">
              <label className="text-sm font-medium text-zinc-400">Title</label>
              <input 
                type="text" 
                value={title}
                onChange={(e) => setTitle(e.target.value)}
                placeholder="My Awesome Script"
                className="w-full bg-black border border-zinc-800 rounded-xl px-4 py-2.5 text-white focus:outline-none focus:ring-2 focus:ring-primary/50 transition-all"
              />
            </div>
            <div className="space-y-2">
              <label className="text-sm font-medium text-zinc-400">Language</label>
              <select 
                value={language}
                onChange={(e) => setLanguage(e.target.value)}
                className="w-full bg-black border border-zinc-800 rounded-xl px-4 py-2.5 text-white focus:outline-none focus:ring-2 focus:ring-primary/50 transition-all appearance-none"
              >
                <option value="javascript">JavaScript</option>
                <option value="typescript">TypeScript</option>
                <option value="lua">Lua</option>
                <option value="python">Python</option>
                <option value="css">CSS</option>
                <option value="html">HTML</option>
                <option value="text">Plain Text</option>
              </select>
            </div>
          </div>

          <div className="space-y-2">
            <div className="flex items-center justify-between">
              <label className="text-sm font-medium text-zinc-400">Content</label>
              <button 
                onClick={() => fileInputRef.current?.click()}
                className="flex items-center gap-2 text-xs text-primary hover:text-primary/80 transition-colors"
              >
                <Upload className="h-3 w-3" />
                Upload File
              </button>
              <input 
                type="file" 
                ref={fileInputRef} 
                onChange={handleFileUpload} 
                className="hidden" 
              />
            </div>
            <textarea 
              value={content}
              onChange={(e) => setContent(e.target.value)}
              placeholder="Paste your code here..."
              className="w-full h-80 bg-black border border-zinc-800 rounded-xl px-4 py-4 text-white font-mono text-sm focus:outline-none focus:ring-2 focus:ring-primary/50 transition-all resize-none"
            />
          </div>

          <div className="flex flex-col sm:flex-row items-center justify-between gap-4 pt-4 border-t border-zinc-800">
            <div className="flex items-center gap-6">
              <label className="flex items-center gap-2 cursor-pointer group">
                <div className={cn(
                  "w-10 h-6 rounded-full transition-all relative",
                  isPublic ? "bg-primary" : "bg-zinc-800"
                )}>
                  <div className={cn(
                    "absolute top-1 left-1 w-4 h-4 bg-white rounded-full transition-all",
                    isPublic ? "translate-x-4" : "translate-x-0"
                  )} />
                </div>
                <input 
                  type="checkbox" 
                  checked={isPublic}
                  onChange={(e) => setIsPublic(e.target.checked)}
                  className="hidden"
                />
                <span className="text-sm font-medium text-zinc-400 group-hover:text-zinc-200 transition-colors">
                  {isPublic ? "Public Access" : "Private (Only Me)"}
                </span>
              </label>

              {(language === 'javascript' || language === 'typescript' || language === 'lua') && (
                <label className="flex items-center gap-2 cursor-pointer group">
                  <div className={cn(
                    "w-10 h-6 rounded-full transition-all relative",
                    shouldObfuscate ? "bg-primary" : "bg-zinc-800"
                  )}>
                    <div className={cn(
                      "absolute top-1 left-1 w-4 h-4 bg-white rounded-full transition-all",
                      shouldObfuscate ? "translate-x-4" : "translate-x-0"
                    )} />
                  </div>
                  <input 
                    type="checkbox" 
                    checked={shouldObfuscate}
                    onChange={(e) => setShouldObfuscate(e.target.checked)}
                    className="hidden"
                  />
                  <span className="text-sm font-medium text-zinc-400 group-hover:text-zinc-200 transition-colors">
                    Obfuscate Code
                  </span>
                </label>
              )}
            </div>

            <button 
              onClick={handleSubmit}
              disabled={isSubmitting}
              className="w-full sm:w-auto flex items-center justify-center gap-2 px-8 py-3 bg-primary text-black font-bold rounded-xl hover:bg-primary/90 disabled:opacity-50 disabled:cursor-not-allowed transition-all shadow-lg shadow-primary/20"
            >
              {isSubmitting ? (
                <div className="h-5 w-5 border-2 border-black/30 border-t-black animate-spin rounded-full" />
              ) : (
                <>
                  <Plus className="h-5 w-5" />
                  <span>Create Paste</span>
                </>
              )}
            </button>
          </div>

          {language === 'lua' && shouldObfuscate && (
            <div className="pt-4 border-t border-zinc-800 space-y-4">
              <button
                type="button"
                onClick={() => setShowProtection((v) => !v)}
                className="w-full flex items-center justify-between gap-3 text-left group"
              >
                <span className="flex items-center gap-2">
                  <SlidersHorizontal className="h-4 w-4 text-primary" />
                  <span className="text-sm font-semibold text-zinc-200">VertexShield Protection v4</span>
                  <span className="text-[10px] uppercase tracking-widest px-2 py-0.5 rounded-full bg-primary/10 text-primary border border-primary/20">
                    {protection.level}
                  </span>
                </span>
                <span className="text-xs text-zinc-500 group-hover:text-zinc-300 transition-colors">
                  {showProtection ? "Hide" : "Tune"}
                </span>
              </button>

              {showProtection && (
                <div className="space-y-4">
                  <div className="grid sm:grid-cols-2 gap-4">
                    <div className="space-y-2">
                      <label className="text-xs font-medium text-zinc-500 uppercase tracking-wider">Protection level</label>
                      <select
                        value={protection.level}
                        onChange={(e) => setProt("level", e.target.value as LuaProtectionOptions["level"])}
                        className="w-full bg-black border border-zinc-800 rounded-xl px-4 py-2.5 text-white text-sm focus:outline-none focus:ring-2 focus:ring-primary/50 transition-all appearance-none"
                      >
                        <option value="standard">Standard — checksums, hooked primitive scan</option>
                        <option value="hardened">Hardened — + trace hook, stack &amp; clock checks</option>
                        <option value="paranoid">Paranoid — + dump/hook API &amp; env divergence scan</option>
                      </select>
                    </div>
                    <div className="space-y-2">
                      <label className="text-xs font-medium text-zinc-500 uppercase tracking-wider">On detection</label>
                      <select
                        value={protection.responseMode}
                        onChange={(e) => setProt("responseMode", e.target.value as LuaProtectionOptions["responseMode"])}
                        className="w-full bg-black border border-zinc-800 rounded-xl px-4 py-2.5 text-white text-sm focus:outline-none focus:ring-2 focus:ring-primary/50 transition-all appearance-none"
                      >
                        <option value="silent">Silent — stop without running the payload</option>
                        <option value="error">Decoy error — fail like a normal bug</option>
                        <option value="corrupt">Corrupt — run a broken decoy chunk</option>
                        <option value="hang">Hang — lock the thread</option>
                        <option value="report">Report only — keep running, log the flags</option>
                      </select>
                    </div>
                  </div>

                  <div className="grid sm:grid-cols-2 gap-3">
                    <ProtToggle
                      checked={protection.antiDump !== false}
                      onChange={(v) => setProt("antiDump", v)}
                      label="Anti-dump"
                      hint="Payload + plaintext checksums, debug hook detection, stack depth and clock sanity, loaded chunk identity check, source wiped right after load()."
                      icon={<ShieldCheck className="h-3.5 w-3.5 text-primary" />}
                    />
                    <ProtToggle
                      checked={protection.antiHook !== false}
                      onChange={(v) => setProt("antiHook", v)}
                      label="Anti-hook"
                      hint="Verifies the primitives the loader needs are still native closures, so string.char / loadstring interception is caught before anything is decrypted."
                      icon={<Bug className="h-3.5 w-3.5 text-primary" />}
                    />
                    <ProtToggle
                      checked={!!protection.watchdog}
                      onChange={(v) => setProt("watchdog", v)}
                      label="Runtime watchdog"
                      hint="Re-verifies the environment on a task.spawn loop so hooks installed after startup are caught too."
                      icon={<Radar className="h-3.5 w-3.5 text-primary" />}
                    />
                    <ProtToggle
                      checked={!!protection.envLogging}
                      onChange={(v) => setProt("envLogging", v)}
                      label="Environment logging"
                      hint="Snapshots the runtime (executor name, API surface, place/job id, triggered flags) and reports it. Technical data only — no personal data."
                      icon={<Activity className="h-3.5 w-3.5 text-primary" />}
                    />
                  </div>

                  {protection.envLogging && (
                    <div className="grid sm:grid-cols-2 gap-3">
                      <div className="space-y-2">
                        <label className="text-xs font-medium text-zinc-500 uppercase tracking-wider">Report webhook (optional)</label>
                        <input
                          type="url"
                          value={protection.webhookUrl || ""}
                          onChange={(e) => setProt("webhookUrl", e.target.value)}
                          placeholder="https://your-endpoint/hook"
                          className="w-full bg-black border border-zinc-800 rounded-xl px-4 py-2.5 text-white text-sm font-mono focus:outline-none focus:ring-2 focus:ring-primary/50 transition-all"
                        />
                      </div>
                      <ProtToggle
                        checked={!!protection.envLogConsole}
                        onChange={(v) => setProt("envLogConsole", v)}
                        label="Echo to executor console"
                        hint="Prints a one line summary locally so you can verify protection is live while testing."
                        icon={<Activity className="h-3.5 w-3.5 text-primary" />}
                      />
                    </div>
                  )}

                  <p className="text-xs text-zinc-600 leading-relaxed">
                    Paranoid mode scans for decompiler and hook-framework globals. Most Roblox executors expose those
                    APIs to every script, so treat a trip there as suspicious rather than malicious. Start on Hardened
                    and raise it once you know your audience.
                  </p>
                </div>
              )}
            </div>
          )}
        </div>

        <div className="grid sm:grid-cols-3 gap-6">
          <div className="p-6 bg-zinc-900/30 border border-zinc-800/50 rounded-2xl flex flex-col gap-3">
            <div className="p-2 bg-blue-500/10 rounded-lg w-fit">
              <Cpu className="h-5 w-5 text-blue-500" />
            </div>
            <h3 className="font-bold text-white">Device Check</h3>
            <p className="text-sm text-zinc-500">Only the device that created the paste can access the original source code.</p>
          </div>
          <div className="p-6 bg-zinc-900/30 border border-zinc-800/50 rounded-2xl flex flex-col gap-3">
            <div className="p-2 bg-purple-500/10 rounded-lg w-fit">
              <Globe className="h-5 w-5 text-purple-500" />
            </div>
            <h3 className="font-bold text-white">IP Verification</h3>
            <p className="text-sm text-zinc-500">Access is restricted to the original IP address for maximum security.</p>
          </div>
          <div className="p-6 bg-zinc-900/30 border border-zinc-800/50 rounded-2xl flex flex-col gap-3">
            <div className="p-2 bg-amber-500/10 rounded-lg w-fit">
              <Zap className="h-5 w-5 text-amber-500" />
            </div>
            <h3 className="font-bold text-white">API Access</h3>
            <p className="text-sm text-zinc-500">Fetch raw content via our secure API with built-in verification headers.</p>
          </div>
        </div>
      </motion.div>
    </div>
  );
};

const ViewPaste = () => {
  const { id } = useParams();
  const [paste, setPaste] = useState<any>(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const [viewMode, setViewMode] = useState<"original" | "obfuscated">("original");
  const [hasAccess, setHasAccess] = useState(false);
  const [copied, setCopied] = useState(false);
  const [copiedLoadstring, setCopiedLoadstring] = useState(false);

  useEffect(() => {
    if (!id) return;

    const path = `pastes/${id}`;
    const unsubscribe = onSnapshot(doc(db, "pastes", id), (docSnap) => {
      if (docSnap.exists()) {
        const data = docSnap.data();
        if (!paste && data.obfuscatedContent) {
          setViewMode("obfuscated");
        }
        setPaste(data);
        
        // Check access
        const fingerprint = getDeviceFingerprint();
        const isOwner = auth.currentUser?.uid === data.creatorId;
        const fingerprintMatches = data.creatorFingerprint === fingerprint;
        
        setHasAccess(isOwner || fingerprintMatches);
        setError(null);
      } else {
        setError("Paste not found");
      }
      setLoading(false);
    }, (err) => {
      console.error("Firestore error:", err);
      setError("Access Denied: This paste is private or you lack permissions.");
      setLoading(false);
    });

    return () => unsubscribe();
  }, [id]);

  const handleCopy = () => {
    const content = viewMode === "original" ? paste.content : paste.obfuscatedContent;
    navigator.clipboard.writeText(content);
    setCopied(true);
    toast.success("Copied to clipboard");
    setTimeout(() => setCopied(false), 2000);
  };

  const handleDownload = () => {
    const content = viewMode === "original" ? paste.content : paste.obfuscatedContent;
    const blob = new Blob([content], { type: "text/plain" });
    const url = URL.createObjectURL(blob);
    const a = document.createElement("a");
    a.href = url;
    a.download = `${paste.title || "paste"}_${viewMode}.txt`;
    a.click();
    URL.revokeObjectURL(url);
  };

  const handleCopyLoadstring = () => {
    const url = `${window.location.origin}/script/${id}${paste.language === 'lua' ? '.lua' : ''}`;
    const loadstring = `loadstring(game:HttpGet("${url}"))()`;
    navigator.clipboard.writeText(loadstring);
    setCopiedLoadstring(true);
    toast.success("Loadstring copied!");
    setTimeout(() => setCopiedLoadstring(false), 2000);
  };

  if (loading) {
    return (
      <div className="flex flex-col justify-center items-center h-screen gap-4">
        <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-primary"></div>
        <p className="text-zinc-500 animate-pulse">Decrypting VertexShield paste...</p>
      </div>
    );
  }

  if (error || !paste) {
    return (
      <div className="flex flex-col justify-center items-center h-screen gap-6 px-4 bg-black">
        <div className="p-6 bg-red-500/10 border border-red-500/20 rounded-full animate-pulse">
          <Lock className="h-12 w-12 text-red-500" />
        </div>
        <div className="text-center space-y-2">
          <h1 className="text-2xl font-mono font-bold text-white tracking-tighter uppercase">
            {error === "Paste not found" ? "404: Resource Missing" : "403: Access Restricted"}
          </h1>
          <p className="text-zinc-500 font-mono text-sm max-w-md">
            {error || "The requested resource could not be located on VertexShield servers."}
          </p>
        </div>
        <div className="flex gap-4 mt-4">
          <Link to="/" className="px-6 py-2 bg-zinc-900 border border-zinc-800 text-zinc-400 font-mono text-xs rounded-lg hover:bg-zinc-800 hover:text-white transition-all uppercase tracking-widest">
            Return Home
          </Link>
          {error?.includes("Access Denied") && !auth.currentUser && (
            <button 
              onClick={() => signInWithPopup(auth, googleProvider)}
              className="px-6 py-2 bg-primary text-black font-mono font-bold text-xs rounded-lg hover:bg-primary/90 transition-all uppercase tracking-widest"
            >
              Login to Verify
            </button>
          )}
        </div>
      </div>
    );
  }

  const currentContent = viewMode === "original" ? paste.content : paste.obfuscatedContent;

  return (
    <div className="max-w-6xl mx-auto pt-24 pb-12 px-4">
      <motion.div 
        initial={{ opacity: 0 }}
        animate={{ opacity: 1 }}
        className="space-y-6"
      >
        <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4">
          <div className="flex items-center gap-4">
            <div className="p-3 bg-zinc-900 border border-zinc-800 rounded-xl">
              <FileCode className="h-6 w-6 text-primary" />
            </div>
            <div>
              <h1 className="text-2xl font-bold text-white">{paste.title || "Untitled Paste"}</h1>
              <div className="flex items-center gap-3 mt-1 text-sm text-zinc-500">
                <span className="flex items-center gap-1">
                  <Fingerprint className="h-3 w-3" />
                  {hasAccess ? "Verified Access" : "Public View"}
                </span>
                <span className="h-1 w-1 bg-zinc-700 rounded-full" />
                <span className="uppercase tracking-wider text-xs">{paste.language}</span>
                {paste.protectionOptions?.level && (
                  <>
                    <span className="h-1 w-1 bg-zinc-700 rounded-full" />
                    <span className="flex items-center gap-1 uppercase tracking-wider text-xs text-primary">
                      <ShieldCheck className="h-3 w-3" />
                      {paste.protectionOptions.level} protection
                    </span>
                  </>
                )}
              </div>
            </div>
          </div>

          <div className="flex items-center gap-2">
            <div className="bg-zinc-900 border border-zinc-800 p-1 rounded-xl flex">
              <button 
                onClick={() => setViewMode("original")}
                className={cn(
                  "px-4 py-1.5 rounded-lg text-sm font-medium transition-all",
                  viewMode === "original" ? "bg-zinc-800 text-white" : "text-zinc-500 hover:text-zinc-300"
                )}
              >
                Original
              </button>
              <button 
                onClick={() => setViewMode("obfuscated")}
                className={cn(
                  "px-4 py-1.5 rounded-lg text-sm font-medium transition-all",
                  viewMode === "obfuscated" ? "bg-zinc-800 text-white" : "text-zinc-500 hover:text-zinc-300"
                )}
              >
                Obfuscated
              </button>
            </div>
          </div>
        </div>

        <div className="bg-zinc-900/80 border border-zinc-800 rounded-2xl p-12 flex flex-col items-center text-center gap-6 backdrop-blur-sm">
          <div className="p-4 bg-primary/10 rounded-full">
            <Terminal className="h-12 w-12 text-primary" />
          </div>
          <div className="space-y-2">
            <h2 className="text-xl font-bold text-white">Script Ready</h2>
            <p className="text-zinc-500 max-w-md">Use the loadstring below to execute this script in your executor.</p>
          </div>
          
          <div className="w-full max-w-2xl bg-black border border-zinc-800 rounded-xl p-4 relative group">
            <code className="text-sm text-primary font-mono break-all block pr-12 text-left">
              loadstring(game:HttpGet(`${window.location.origin}/script/${id}${paste.language === 'lua' ? '.lua' : ''}`))()
            </code>
            <button 
              onClick={handleCopyLoadstring}
              className="absolute top-3 right-3 p-2 bg-zinc-900 hover:bg-zinc-800 border border-zinc-700 rounded-lg text-zinc-400 hover:text-white transition-all"
            >
              {copiedLoadstring ? <Check className="h-4 w-4 text-emerald-500" /> : <Copy className="h-4 w-4" />}
            </button>
          </div>

          <div className="flex gap-4">
            <button 
              onClick={handleCopyLoadstring}
              className="px-6 py-2 bg-primary text-black font-bold rounded-lg hover:bg-primary/90 transition-all flex items-center gap-2"
            >
              <Copy className="h-4 w-4" />
              <span>Copy Loadstring</span>
            </button>
            <a 
              href={`/script/${id}${paste.language === 'lua' ? '.lua' : ''}?raw=true`}
              target="_blank"
              rel="noopener noreferrer"
              className="px-6 py-2 bg-zinc-800 text-white font-bold rounded-lg hover:bg-zinc-700 transition-all flex items-center gap-2"
            >
              <ExternalLink className="h-4 w-4" />
              <span>Raw Script</span>
            </a>
          </div>
        </div>

        {/* Code View Section */}
        <div className="space-y-4">
          <div className="flex items-center justify-between">
            <h3 className="text-lg font-bold text-white flex items-center gap-2">
              <Code className="h-5 w-5 text-primary" />
              <span>Source Preview</span>
            </h3>
          </div>

          {!hasAccess && viewMode === "original" ? (
            <div className="bg-zinc-900/50 border border-zinc-800 rounded-2xl p-8 flex flex-col items-center text-center gap-4">
              <Lock className="h-8 w-8 text-amber-500" />
              <div className="space-y-1">
                <p className="text-white font-medium">Original Source Protected</p>
                <p className="text-sm text-zinc-500">You can only view the obfuscated version of this script.</p>
              </div>
              <button 
                onClick={() => setViewMode("obfuscated")}
                className="text-primary hover:underline text-sm font-bold"
              >
                Switch to Obfuscated View
              </button>
            </div>
          ) : (
            <div className="relative group rounded-2xl overflow-hidden border border-zinc-800">
              <div className="absolute top-4 right-4 z-10 flex items-center gap-2 opacity-0 group-hover:opacity-100 transition-opacity">
                <button 
                  onClick={handleCopy}
                  className="p-2 bg-zinc-900/80 hover:bg-zinc-800 border border-zinc-700 rounded-lg text-zinc-400 hover:text-white transition-all backdrop-blur-sm"
                >
                  {copied ? <Check className="h-4 w-4 text-emerald-500" /> : <Copy className="h-4 w-4" />}
                </button>
              </div>
              <SyntaxHighlighter 
                language={paste.language} 
                style={vscDarkPlus}
                customStyle={{
                  margin: 0,
                  padding: '2rem',
                  fontSize: '0.875rem',
                  backgroundColor: '#09090b',
                  lineHeight: '1.5'
                }}
                showLineNumbers
              >
                {currentContent}
              </SyntaxHighlighter>
            </div>
          )}
        </div>

        <div className="grid sm:grid-cols-3 gap-6">
          <div className="p-6 bg-zinc-900/30 border border-zinc-800/50 rounded-2xl flex flex-col gap-3">
            <div className="p-2 bg-blue-500/10 rounded-lg w-fit">
              <Cpu className="h-5 w-5 text-blue-500" />
            </div>
            <h3 className="font-bold text-white">Executor Ready</h3>
            <p className="text-sm text-zinc-500">Optimized for Synapse, Sentinel, and other major executors.</p>
          </div>
          <div className="p-6 bg-zinc-900/30 border border-zinc-800/50 rounded-2xl flex flex-col gap-3">
            <div className="p-2 bg-purple-500/10 rounded-lg w-fit">
              <Globe className="h-5 w-5 text-purple-500" />
            </div>
            <h3 className="font-bold text-white">Global CDN</h3>
            <p className="text-sm text-zinc-500">Fast delivery worldwide with built-in anti-tamper protection.</p>
          </div>
          <div className="p-6 bg-zinc-900/30 border border-zinc-800/50 rounded-2xl flex flex-col gap-3">
            <div className="p-2 bg-amber-500/10 rounded-lg w-fit">
              <Zap className="h-5 w-5 text-amber-500" />
            </div>
            <h3 className="font-bold text-white">Auto-Update</h3>
            <p className="text-sm text-zinc-500">Links are permanent. Update your code and the loadstring stays the same.</p>
          </div>
        </div>
      </motion.div>
    </div>
  );
};

const HistoryPage = () => {
  return (
    <div className="max-w-4xl mx-auto pt-24 pb-12 px-4">
      <motion.div 
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        className="space-y-8"
      >
        <div className="flex flex-col gap-2">
          <h1 className="text-4xl font-bold tracking-tight text-white">Your Pastes</h1>
          <p className="text-zinc-500">Manage and view your secure code snippets.</p>
        </div>

        <PasteHistory />
      </motion.div>
    </div>
  );
};

// --- Main App ---

export default function App() {
  const [isReady, setIsReady] = useState(false);
  const [isAuthReady, setIsAuthReady] = useState(false);

  useEffect(() => {
    const unsubscribe = auth.onAuthStateChanged(async (user) => {
      if (user) {
        // Create user profile if it doesn't exist
        try {
          const userDoc = await getDoc(doc(db, "users", user.uid));
          if (!userDoc.exists()) {
            await setDoc(doc(db, "users", user.uid), {
              displayName: user.displayName || "Anonymous User",
              email: user.email || "",
              photoURL: user.photoURL || "",
              role: "user",
              createdAt: Timestamp.now()
            });
          }
        } catch (error) {
          console.error("Error creating user profile:", error);
        }
      }
      setIsAuthReady(true);
    });
    
    // Test Firestore connection
    const testConnection = async () => {
      try {
        const { getDocFromServer } = await import("firebase/firestore");
        await getDocFromServer(doc(db, 'pastes', 'connection-test'));
      } catch (error: any) {
        if (error.message.includes('the client is offline') || error.code === 'permission-denied') {
          console.warn("Firestore connection test failed:", error.message);
        }
      }
    };
    testConnection();
    
    // Simulate pleasant loading and ensure we don't get stuck
    const timer = setTimeout(() => {
      setIsReady(true);
      setIsAuthReady(true); // Fallback if auth listener hangs
    }, 2000);
    
    return () => {
      unsubscribe();
      clearTimeout(timer);
    };
  }, []);

  if (!isReady || !isAuthReady) {
    return (
      <div className="h-screen w-full bg-black flex items-center justify-center">
        <motion.div
          initial={{ scale: 0.8, opacity: 0 }}
          animate={{ scale: 1, opacity: 1 }}
          className="flex flex-col items-center gap-6"
        >
          <div className="relative">
            <Shield className="h-16 w-16 text-primary animate-pulse" />
            <motion.div 
              animate={{ rotate: 360 }}
              transition={{ duration: 2, repeat: Infinity, ease: "linear" }}
              className="absolute -inset-4 border-2 border-primary/20 border-t-primary rounded-full"
            />
          </div>
          <div className="flex flex-col items-center gap-2">
            <h2 className="text-2xl font-bold tracking-tighter text-white">VERTEX<span className="text-primary">SHIELD</span></h2>
            <div className="flex gap-1">
              {[0, 1, 2].map((i) => (
                <motion.div
                  key={i}
                  animate={{ opacity: [0.2, 1, 0.2] }}
                  transition={{ duration: 1, repeat: Infinity, delay: i * 0.2 }}
                  className="w-1.5 h-1.5 bg-primary rounded-full"
                />
              ))}
            </div>
          </div>
        </motion.div>
      </div>
    );
  }

  return (
    <ErrorBoundary>
      <Router>
        <div className="min-h-screen bg-black text-zinc-300 selection:bg-primary/30 selection:text-primary">
          <Navbar />
          
          <main className="relative">
            {/* Background effects */}
            <div className="fixed inset-0 pointer-events-none overflow-hidden">
              <div className="absolute top-[-10%] left-[-10%] w-[40%] h-[40%] bg-primary/5 blur-[120px] rounded-full" />
              <div className="absolute bottom-[-10%] right-[-10%] w-[40%] h-[40%] bg-blue-500/5 blur-[120px] rounded-full" />
            </div>

            <Routes>
              <Route path="/" element={<CreatePaste />} />
              <Route path="/history" element={<HistoryPage />} />
              <Route path="/paste/:id" element={<ViewPaste />} />
            </Routes>
          </main>

          <Toaster position="bottom-right" theme="dark" />
        </div>
      </Router>
    </ErrorBoundary>
  );
}
