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
  FileText
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
  Timestamp,
  onSnapshot
} from "./firebase";
import { getDeviceFingerprint, getClientIp } from "./utils/fingerprint";
import { obfuscateCode } from "./utils/obfuscator";
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

const CreatePaste = () => {
  const [title, setTitle] = useState("");
  const [content, setContent] = useState("");
  const [language, setLanguage] = useState("javascript");
  const [isPublic, setIsPublic] = useState(false);
  const [shouldObfuscate, setShouldObfuscate] = useState(true);
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
      const obfuscated = (shouldObfuscate && (language === 'javascript' || language === 'typescript')) ? obfuscateCode(content) : content;

      const docRef = await addDoc(collection(db, path), {
        title: title || "Untitled Paste",
        content,
        obfuscatedContent: obfuscated,
        creatorId: auth.currentUser.uid,
        creatorIp: ip,
        creatorFingerprint: fingerprint,
        createdAt: Timestamp.now(),
        isPublic,
        language
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

              {(language === 'javascript' || language === 'typescript') && (
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
  const [viewMode, setViewMode] = useState<"original" | "obfuscated">("original");
  const [hasAccess, setHasAccess] = useState(false);
  const [copied, setCopied] = useState(false);

  useEffect(() => {
    if (!id) return;

    const path = `pastes/${id}`;
    const unsubscribe = onSnapshot(doc(db, "pastes", id), (docSnap) => {
      if (docSnap.exists()) {
        const data = docSnap.data();
        setPaste(data);
        
        // Check access
        const fingerprint = getDeviceFingerprint();
        const isOwner = auth.currentUser?.uid === data.creatorId;
        const fingerprintMatches = data.creatorFingerprint === fingerprint;
        
        setHasAccess(isOwner || fingerprintMatches);
      }
      setLoading(false);
    }, (error) => {
      handleFirestoreError(error, OperationType.GET, path);
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

  if (loading) {
    return (
      <div className="flex flex-col justify-center items-center h-screen gap-4">
        <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-primary"></div>
        <p className="text-zinc-500 animate-pulse">Decrypting VertexShield paste...</p>
      </div>
    );
  }

  if (!paste) {
    return (
      <div className="flex flex-col justify-center items-center h-screen gap-6 px-4">
        <div className="p-4 bg-red-500/10 rounded-full">
          <Lock className="h-12 w-12 text-red-500" />
        </div>
        <h1 className="text-2xl font-bold text-white">Paste Not Found</h1>
        <p className="text-zinc-500 text-center max-w-md">The paste you are looking for does not exist or has been deleted.</p>
        <Link to="/" className="px-6 py-2 bg-zinc-800 text-white rounded-lg hover:bg-zinc-700 transition-all">Go Home</Link>
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

        {!hasAccess && viewMode === "original" ? (
          <div className="bg-zinc-900/80 border border-zinc-800 rounded-2xl p-12 flex flex-col items-center text-center gap-6 backdrop-blur-sm">
            <div className="p-4 bg-amber-500/10 rounded-full">
              <Lock className="h-12 w-12 text-amber-500" />
            </div>
            <div className="space-y-2">
              <h2 className="text-xl font-bold text-white">Source Code Protected</h2>
              <p className="text-zinc-500 max-w-md">Original source code is only visible to the creator or from the authorized device. You can still view the obfuscated version.</p>
            </div>
            <button 
              onClick={() => setViewMode("obfuscated")}
              className="px-6 py-2 bg-primary text-black font-bold rounded-lg hover:bg-primary/90 transition-all"
            >
              View Obfuscated Version
            </button>
          </div>
        ) : (
          <div className="relative group">
            <div className="absolute top-4 right-4 z-10 flex items-center gap-2 opacity-0 group-hover:opacity-100 transition-opacity">
              <button 
                onClick={handleCopy}
                className="p-2 bg-zinc-900/80 hover:bg-zinc-800 border border-zinc-700 rounded-lg text-zinc-400 hover:text-white transition-all backdrop-blur-sm"
              >
                {copied ? <Check className="h-4 w-4 text-emerald-500" /> : <Copy className="h-4 w-4" />}
              </button>
              <button 
                onClick={handleDownload}
                className="p-2 bg-zinc-900/80 hover:bg-zinc-800 border border-zinc-700 rounded-lg text-zinc-400 hover:text-white transition-all backdrop-blur-sm"
              >
                <Download className="h-4 w-4" />
              </button>
            </div>
            <div className="rounded-2xl overflow-hidden border border-zinc-800">
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
          </div>
        )}

        <div className="flex flex-col sm:flex-row items-center justify-between gap-4 p-6 bg-zinc-900/30 border border-zinc-800 rounded-2xl">
          <div className="flex items-center gap-4">
            <div className="p-2 bg-zinc-800 rounded-lg">
              <Terminal className="h-5 w-5 text-zinc-400" />
            </div>
            <div>
              <p className="text-xs text-zinc-500 uppercase tracking-widest font-bold">API Endpoint</p>
              <code className="text-sm text-primary break-all">
                {window.location.origin}/scripts/hosted/{id}{paste.language === 'lua' ? '.lua' : ''}
              </code>
            </div>
          </div>
          <a 
            href={`/scripts/hosted/${id}${paste.language === 'lua' ? '.lua' : ''}`}
            target="_blank"
            rel="noopener noreferrer"
            className="flex items-center gap-2 px-4 py-2 bg-zinc-800 hover:bg-zinc-700 text-white text-sm font-medium rounded-lg transition-all"
          >
            <span>Test API</span>
            <ExternalLink className="h-4 w-4" />
          </a>
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
    const unsubscribe = auth.onAuthStateChanged(() => {
      setIsAuthReady(true);
    });
    
    // Simulate pleasant loading
    const timer = setTimeout(() => setIsReady(true), 1000);
    
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
