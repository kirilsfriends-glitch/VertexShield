import React, { useState, useEffect, useRef, useCallback, FormEvent, ChangeEvent, createContext, useContext } from 'react';
import { 
  BrowserRouter as Router, 
  Routes, 
  Route, 
  Navigate, 
  useNavigate,
  Link
} from 'react-router-dom';
import { 
  Shield, 
  Lock, 
  History as HistoryIcon, 
  Users, 
  LogOut, 
  Terminal, 
  CheckCircle2,
  XCircle,
  Ban,
  Download,
  FileCode,
  Plus,
  Zap,
  Copy,
  Key,
  Eye,
  EyeOff,
  AlertCircle,
  Code2,
  Cpu,
  Settings,
  User as UserIcon,
  Crown,
  Search,
  MoreVertical,
  ShieldAlert,
  Loader2
} from 'lucide-react';
import { motion, AnimatePresence } from 'motion/react';
import { clsx, type ClassValue } from 'clsx';
import { twMerge } from 'tailwind-merge';
import { obfuscate } from './services/obfuscator';
import { auth, db, handleFirestoreError, OperationType } from './firebase';
import { 
  onAuthStateChanged, 
  signInWithPopup,
  GoogleAuthProvider,
  signOut, 
  User as FirebaseUser 
} from 'firebase/auth';
import { doc, getDoc, getDocs, setDoc, collection, query, where, orderBy, onSnapshot, addDoc, serverTimestamp, updateDoc, deleteDoc, limit } from 'firebase/firestore';

// --- Utility ---
function cn(...inputs: ClassValue[]) {
  return twMerge(clsx(inputs));
}

// --- Types ---
interface UserProfile {
  uid: string;
  email: string;
  role: 'admin' | 'moderator' | 'user';
  isBanned: boolean;
  isPremium: boolean;
  username: string;
  createdAt: any;
}

interface ObfuscationRecord {
  id: string;
  userId: string;
  sourceCode: string;
  obfuscatedCode: string;
  timestamp: any;
  name: string;
  language: string;
  level: string;
}

// --- Auth Context ---
interface AuthContextType {
  user: FirebaseUser | null;
  profile: UserProfile | null;
  loading: boolean;
  loginWithGoogle: () => Promise<void>;
  logout: () => Promise<void>;
}

const AuthContext = createContext<AuthContextType | undefined>(undefined);

export const AuthProvider: React.FC<{ children: React.ReactNode }> = ({ children }) => {
  const [user, setUser] = useState<FirebaseUser | null>(null);
  const [profile, setProfile] = useState<UserProfile | null>(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const unsubscribe = onAuthStateChanged(auth, async (firebaseUser) => {
      setUser(firebaseUser);
      if (firebaseUser) {
        try {
          const userDoc = await getDoc(doc(db, 'users', firebaseUser.uid));
          if (userDoc.exists()) {
            setProfile(userDoc.data() as UserProfile);
          } else {
            // Create profile if it doesn't exist
            const userData: UserProfile = {
              uid: firebaseUser.uid,
              email: firebaseUser.email || '',
              username: firebaseUser.displayName || firebaseUser.email?.split('@')[0] || 'User',
              role: firebaseUser.email === 'kirilsfriends@gmail.com' ? 'admin' : 'user',
              isBanned: false,
              isPremium: firebaseUser.email === 'kirilsfriends@gmail.com',
              createdAt: serverTimestamp()
            };
            await setDoc(doc(db, 'users', firebaseUser.uid), userData);
            setProfile(userData);
          }
        } catch (err) {
          console.error("Error fetching profile:", err);
          setProfile(null);
        }
      } else {
        setProfile(null);
      }
      setLoading(false);
    });
    return unsubscribe;
  }, []);

  const loginWithGoogle = async () => {
    setLoading(true);
    try {
      const provider = new GoogleAuthProvider();
      await signInWithPopup(auth, provider);
    } catch (error: any) {
      console.error('Login error:', error);
      throw error;
    } finally {
      setLoading(false);
    }
  };

  const logout = async () => {
    await signOut(auth);
  };

  return (
    <AuthContext.Provider value={{ user, profile, loading, loginWithGoogle, logout }}>
      {children}
    </AuthContext.Provider>
  );
};

export const useAuth = () => {
  const context = useContext(AuthContext);
  if (!context) throw new Error('useAuth must be used within AuthProvider');
  return context;
};

// --- Components ---

const Button = ({ className, variant = 'primary', ...props }: any) => {
  const variants = {
    primary: 'bg-emerald-500 hover:bg-emerald-600 text-white shadow-lg shadow-emerald-500/20',
    secondary: 'bg-zinc-800 hover:bg-zinc-700 text-zinc-100 border border-zinc-700',
    danger: 'bg-red-500 hover:bg-red-600 text-white shadow-lg shadow-red-500/20',
    ghost: 'hover:bg-zinc-800 text-zinc-400 hover:text-zinc-100',
  };
  return (
    <button 
      className={cn(
        'px-4 py-2 rounded-xl font-medium transition-all active:scale-95 disabled:opacity-50 disabled:pointer-events-none flex items-center justify-center gap-2',
        variants[variant as keyof typeof variants],
        className
      )} 
      {...props} 
    />
  );
};

const Input = ({ className, ...props }: any) => (
  <input 
    className={cn(
      'w-full bg-zinc-900/50 border border-zinc-800 rounded-xl px-4 py-3 text-zinc-100 focus:outline-none focus:ring-2 focus:ring-emerald-500/50 focus:border-emerald-500 transition-all placeholder:text-zinc-600',
      className
    )} 
    {...props} 
  />
);

const Card = ({ children, className }: any) => (
  <div className={cn('bg-zinc-900/50 border border-zinc-800 rounded-2xl p-6 backdrop-blur-xl', className)}>
    {children}
  </div>
);

// --- Pages ---

const LoginPage = () => {
  const { loginWithGoogle, user, profile, loading } = useAuth();
  const [authLoading, setAuthLoading] = useState(false);
  const [error, setError] = useState('');
  const navigate = useNavigate();

  useEffect(() => {
    if (user && profile) {
      if (profile.isBanned) return;
      navigate('/');
    }
  }, [user, profile, navigate]);

  const handleGoogleLogin = async () => {
    setError('');
    setAuthLoading(true);
    try {
      await loginWithGoogle();
    } catch (err: any) {
      console.error(err);
      if (err.code === 'auth/operation-not-allowed') {
        setError('Auth Provider Disabled: Please enable "Google" in your Firebase Console (Authentication > Sign-in method).');
      } else {
        setError('Authentication failed. Please try again.');
      }
    } finally {
      setAuthLoading(false);
    }
  };

  if (loading) return null;

  return (
    <div className="min-h-screen flex items-center justify-center p-4 bg-[#020202] overflow-hidden relative">
      <div className="absolute inset-0 opacity-20 pointer-events-none overflow-hidden">
        <div className="absolute top-0 left-0 w-full h-full bg-[radial-gradient(circle_at_50%_50%,rgba(16,185,129,0.1),transparent_50%)]" />
      </div>
      
      <motion.div initial={{ opacity: 0, scale: 0.9 }} animate={{ opacity: 1, scale: 1 }} className="w-full max-w-md relative z-10">
        <div className="text-center mb-8">
          <div className="inline-flex items-center justify-center w-20 h-20 rounded-3xl bg-emerald-500/10 border border-emerald-500/20 mb-6 backdrop-blur-sm">
            <Cpu className="w-10 h-10 text-emerald-500" />
          </div>
          <h1 className="text-4xl font-black text-white tracking-tighter uppercase italic">VertexShield</h1>
          <p className="text-zinc-500 mt-2 font-mono text-xs tracking-widest uppercase">Elite Code Protection Suite</p>
        </div>

        <Card className="border-emerald-500/10 shadow-2xl shadow-emerald-500/5">
          <div className="space-y-6">
            <div className="text-center mb-4">
              <h2 className="text-xl font-bold text-white">Welcome Back</h2>
              <p className="text-zinc-500 text-sm">Authenticate with Google to continue</p>
            </div>

            {error && (
              <div className="p-3 rounded-xl bg-red-500/10 border border-red-500/20 text-red-500 text-xs flex items-center gap-2">
                <AlertCircle className="w-4 h-4" />
                {error}
              </div>
            )}

            <Button 
              onClick={handleGoogleLogin} 
              disabled={authLoading}
              className="w-full h-12 bg-white text-black hover:bg-zinc-200 shadow-none border-none"
            >
              {authLoading ? (
                <Loader2 className="w-5 h-5 animate-spin" />
              ) : (
                <div className="flex items-center justify-center gap-3">
                  <svg className="w-5 h-5" viewBox="0 0 24 24">
                    <path
                      fill="currentColor"
                      d="M22.56 12.25c0-.78-.07-1.53-.2-2.25H12v4.26h5.92c-.26 1.37-1.04 2.53-2.21 3.31v2.77h3.57c2.08-1.92 3.28-4.74 3.28-8.09z"
                    />
                    <path
                      fill="currentColor"
                      d="M12 23c2.97 0 5.46-.98 7.28-2.66l-3.57-2.77c-.98.66-2.23 1.06-3.71 1.06-2.86 0-5.29-1.93-6.16-4.53H2.18v2.84C3.99 20.53 7.7 23 12 23z"
                    />
                    <path
                      fill="currentColor"
                      d="M5.84 14.09c-.22-.66-.35-1.36-.35-2.09s.13-1.43.35-2.09V7.07H2.18C1.43 8.55 1 10.22 1 12s.43 3.45 1.18 4.93l2.85-2.22.81-.62z"
                    />
                    <path
                      fill="currentColor"
                      d="M12 5.38c1.62 0 3.06.56 4.21 1.64l3.15-3.15C17.45 2.09 14.97 1 12 1 7.7 1 3.99 3.47 2.18 7.07l3.66 2.84c.87-2.6 3.3-4.53 6.16-4.53z"
                    />
                  </svg>
                  Continue with Google
                </div>
              )}
            </Button>

            <p className="text-center text-[10px] text-zinc-600 uppercase tracking-widest">
              Secure authentication via Google Cloud
            </p>
          </div>
        </Card>
      </motion.div>
    </div>
  );
};

const ObfuscatorPage = () => {
  const { profile } = useAuth();
  const [code, setCode] = useState('');
  const [obfuscated, setObfuscated] = useState('');
  const [loading, setLoading] = useState(false);
  const [name, setName] = useState('Untitled Project');
  const [watermark, setWatermark] = useState('VertexShield');
  const [language, setLanguage] = useState<'javascript' | 'lua' | 'python'>('javascript');
  const [level, setLevel] = useState<'free' | 'premium'>('free');
  const [logs, setLogs] = useState<string[]>([]);
  const logEndRef = useRef<HTMLDivElement>(null);
  const fileInputRef = useRef<HTMLInputElement>(null);

  const addLog = (msg: string) => {
    setLogs(prev => [...prev, `[${new Date().toLocaleTimeString()}] ${msg}`]);
  };

  useEffect(() => {
    logEndRef.current?.scrollIntoView({ behavior: 'smooth' });
  }, [logs]);

  const handleObfuscate = async () => {
    if (!code || !profile) return;
    if (level === 'premium' && !profile.isPremium) {
      addLog("ERROR: Premium tier required for this feature.");
      return;
    }

    setLoading(true);
    setLogs([]);
    setObfuscated('');
    
    addLog(`Initializing VertexShield ${language.toUpperCase()} Engine...`);
    await new Promise(r => setTimeout(r, 500));
    addLog("Parsing source code AST...");
    await new Promise(r => setTimeout(r, 400));
    addLog(`Generating ${level === 'premium' ? 'Advanced' : 'Basic'} bytecode...`);
    await new Promise(r => setTimeout(r, 600));
    addLog(`Applying watermark: ${watermark}`);
    
    try {
      const result = obfuscate(code, language, level, watermark);
      setObfuscated(result.code);
      addLog("Obfuscation successful! Saving to history...");
      
      await addDoc(collection(db, 'obfuscations'), {
        userId: profile.uid,
        sourceCode: code,
        obfuscatedCode: result.code,
        timestamp: serverTimestamp(),
        name: name || 'Untitled Project',
        language,
        level
      });
      addLog("Project saved.");
    } catch (err) {
      addLog("CRITICAL ERROR: Obfuscation failed.");
      handleFirestoreError(err, OperationType.WRITE, 'obfuscations');
    } finally {
      setLoading(false);
    }
  };

  const handleFileUpload = useCallback((e: ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files?.[0];
    if (!file) return;
    const reader = new FileReader();
    reader.onload = (ev) => {
      const content = ev.target?.result as string;
      if (content) {
        setCode(content);
        setName(file.name.split('.')[0]);
        const ext = file.name.split('.').pop()?.toLowerCase();
        if (ext === 'lua') setLanguage('lua');
        else if (ext === 'py') setLanguage('python');
        else setLanguage('javascript');
      }
    };
    reader.readAsText(file);
  }, []);

  const downloadCode = (content: string, filename: string) => {
    const ext = language === 'javascript' ? 'js' : language === 'lua' ? 'lua' : 'py';
    const blob = new Blob([content], { type: 'text/plain' });
    const url = URL.createObjectURL(blob);
    const a = document.createElement('a');
    a.href = url;
    a.download = filename.includes('.') ? filename : `${filename}.${ext}`;
    a.click();
    URL.revokeObjectURL(url);
  };

  return (
    <div className="space-y-6">
      <div className="flex flex-col md:flex-row md:items-center justify-between gap-4">
        <div>
          <h1 className="text-2xl font-bold text-white">Obfuscator</h1>
          <p className="text-zinc-500">Secure your code with multi-language VM-level protection</p>
        </div>
        <div className="flex items-center gap-3">
          <input type="file" className="hidden" ref={fileInputRef} onChange={handleFileUpload} />
          <Button variant="secondary" onClick={() => fileInputRef.current?.click()}>
            <Plus className="w-4 h-4" /> Import File
          </Button>
          <Button onClick={handleObfuscate} disabled={loading || !code}>
            <Zap className="w-4 h-4 fill-current" /> {loading ? 'Processing...' : 'Obfuscate'}
          </Button>
        </div>
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
        <div className="space-y-4">
          <Card className="p-0 overflow-hidden flex flex-col h-[600px]">
            <div className="px-4 py-3 border-b border-zinc-800 bg-zinc-900/80 flex items-center justify-between">
              <div className="flex items-center gap-2">
                <FileCode className="w-4 h-4 text-emerald-500" />
                <span className="text-sm font-medium text-zinc-300">Source Code</span>
              </div>
              <div className="flex items-center gap-2">
                <select 
                  className="bg-zinc-800 text-[10px] text-zinc-300 border-none rounded px-2 py-1 focus:outline-none"
                  value={language}
                  onChange={(e: any) => setLanguage(e.target.value)}
                >
                  <option value="javascript">JavaScript</option>
                  <option value="lua">Lua</option>
                  <option value="python">Python</option>
                </select>
                <input 
                  className="bg-transparent border-none text-xs text-zinc-500 focus:outline-none text-right w-32"
                  value={name}
                  onChange={(e) => setName(e.target.value)}
                />
              </div>
            </div>
            <textarea 
              className="flex-1 bg-transparent p-4 text-zinc-300 font-mono text-sm resize-none focus:outline-none"
              placeholder={`Paste your ${language} code here...`}
              value={code}
              onChange={(e) => setCode(e.target.value)}
            />
          </Card>
        </div>

        <div className="space-y-4">
          <Card className="p-0 overflow-hidden flex flex-col h-[600px]">
            <div className="px-4 py-3 border-b border-zinc-800 bg-zinc-900/80 flex items-center justify-between">
              <div className="flex items-center gap-2">
                <Terminal className="w-4 h-4 text-emerald-500" />
                <span className="text-sm font-medium text-zinc-300">Obfuscated Output</span>
              </div>
              <div className="flex items-center gap-2">
                <div className="flex bg-zinc-800 rounded p-0.5">
                  <button onClick={() => setLevel('free')} className={cn("px-2 py-0.5 rounded text-[10px] font-bold", level === 'free' ? "bg-zinc-700 text-white" : "text-zinc-500")}>FREE</button>
                  <button onClick={() => setLevel('premium')} className={cn("px-2 py-0.5 rounded text-[10px] font-bold flex items-center gap-1", level === 'premium' ? "bg-emerald-500 text-white" : "text-zinc-500", !profile?.isPremium && "opacity-50 cursor-not-allowed")}>PREMIUM {!profile?.isPremium && <Lock className="w-2 h-2" />}</button>
                </div>
                {obfuscated && (
                  <Button variant="ghost" className="h-8 px-2 text-xs" onClick={() => downloadCode(obfuscated, `obf_${name}`)}>
                    <Download className="w-3 h-3" /> Download
                  </Button>
                )}
              </div>
            </div>
            <div className="flex-1 bg-zinc-950 p-4 font-mono text-sm overflow-auto">
              {obfuscated ? (
                <pre className="text-emerald-500/90 whitespace-pre-wrap">{obfuscated}</pre>
              ) : loading ? (
                <div className="h-full flex flex-col gap-2">
                  {logs.map((log, i) => <div key={i} className="text-emerald-500/70 text-xs">{log}</div>)}
                  <div ref={logEndRef} />
                </div>
              ) : (
                <div className="h-full flex items-center justify-center text-zinc-600 italic">Output will appear here</div>
              )}
            </div>
          </Card>
        </div>
      </div>
    </div>
  );
};

const HistoryPage = () => {
  const { profile } = useAuth();
  const [records, setRecords] = useState<ObfuscationRecord[]>([]);
  const [selected, setSelected] = useState<ObfuscationRecord | null>(null);

  useEffect(() => {
    if (!profile) return;
    const q = query(collection(db, 'obfuscations'), where('userId', '==', profile.uid), orderBy('timestamp', 'desc'));
    const unsubscribe = onSnapshot(q, (snapshot) => {
      setRecords(snapshot.docs.map(doc => ({ id: doc.id, ...doc.data() } as ObfuscationRecord)));
    }, (err) => handleFirestoreError(err, OperationType.LIST, 'obfuscations'));
    return unsubscribe;
  }, [profile]);

  return (
    <div className="space-y-6">
      <h1 className="text-2xl font-bold text-white">History</h1>
      <div className="grid grid-cols-1 xl:grid-cols-3 gap-6">
        <div className="xl:col-span-1 space-y-3">
          {records.map(record => (
            <button key={record.id} onClick={() => setSelected(record)} className={cn("w-full text-left p-4 rounded-xl border transition-all", selected?.id === record.id ? "bg-emerald-500/10 border-emerald-500/50" : "bg-zinc-900/50 border-zinc-800")}>
              <div className="flex items-center justify-between mb-1">
                <span className="font-medium text-zinc-200 truncate">{record.name}</span>
                <span className="text-[10px] text-zinc-500 uppercase font-bold">{record.timestamp?.toDate().toLocaleDateString()}</span>
              </div>
            </button>
          ))}
        </div>
        <div className="xl:col-span-2">
          {selected && (
            <Card className="p-0 overflow-hidden">
              <div className="px-4 py-3 border-b border-zinc-800 bg-zinc-900/80 flex items-center justify-between">
                <span className="text-sm font-medium text-zinc-300">Obfuscated Code</span>
              </div>
              <pre className="p-4 bg-zinc-950 font-mono text-xs text-zinc-400 overflow-auto max-h-[500px]">{selected.obfuscatedCode}</pre>
            </Card>
          )}
        </div>
      </div>
    </div>
  );
};

const AdminPage = () => {
  const { profile } = useAuth();
  const [users, setUsers] = useState<UserProfile[]>([]);
  const [search, setSearch] = useState('');

  useEffect(() => {
    if (!profile || (profile.role !== 'admin' && profile.role !== 'moderator')) return;
    const unsubscribe = onSnapshot(collection(db, 'users'), (snapshot) => {
      setUsers(snapshot.docs.map(doc => doc.data() as UserProfile));
    });
    return unsubscribe;
  }, [profile]);

  const toggleBan = async (user: UserProfile) => {
    if (user.role === 'admin') return; // Cannot ban admin
    if (profile?.role === 'moderator' && user.role === 'moderator') return; // Mod cannot ban mod
    await updateDoc(doc(db, 'users', user.uid), { isBanned: !user.isBanned });
  };

  const togglePremium = async (user: UserProfile) => {
    if (profile?.role !== 'admin') return;
    await updateDoc(doc(db, 'users', user.uid), { isPremium: !user.isPremium });
  };

  const setRole = async (user: UserProfile, role: 'admin' | 'moderator' | 'user') => {
    if (profile?.role !== 'admin') return;
    await updateDoc(doc(db, 'users', user.uid), { role });
  };

  const filteredUsers = users.filter(u => u.username.toLowerCase().includes(search.toLowerCase()) || u.email.toLowerCase().includes(search.toLowerCase()));

  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between">
        <h1 className="text-2xl font-bold text-white">User Management</h1>
        <div className="relative w-64">
          <Search className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-zinc-500" />
          <input 
            className="w-full bg-zinc-900 border border-zinc-800 rounded-lg pl-10 pr-4 py-2 text-sm text-zinc-300 focus:outline-none focus:border-emerald-500"
            placeholder="Search users..."
            value={search}
            onChange={(e) => setSearch(e.target.value)}
          />
        </div>
      </div>

      <Card className="p-0 overflow-hidden">
        <table className="w-full text-left border-collapse">
          <thead>
            <tr className="bg-zinc-900/50 border-b border-zinc-800">
              <th className="px-6 py-4 text-xs font-bold text-zinc-500 uppercase tracking-widest">User</th>
              <th className="px-6 py-4 text-xs font-bold text-zinc-500 uppercase tracking-widest">Role</th>
              <th className="px-6 py-4 text-xs font-bold text-zinc-500 uppercase tracking-widest">Status</th>
              <th className="px-6 py-4 text-xs font-bold text-zinc-500 uppercase tracking-widest">Premium</th>
              <th className="px-6 py-4 text-xs font-bold text-zinc-500 uppercase tracking-widest">Actions</th>
            </tr>
          </thead>
          <tbody className="divide-y divide-zinc-800">
            {filteredUsers.map(u => (
              <tr key={u.uid} className="hover:bg-zinc-800/30 transition-colors">
                <td className="px-6 py-4">
                  <div className="flex items-center gap-3">
                    <div className="w-8 h-8 rounded-full bg-zinc-800 flex items-center justify-center">
                      <UserIcon className="w-4 h-4 text-zinc-500" />
                    </div>
                    <div>
                      <div className="text-sm font-medium text-zinc-200">{u.username}</div>
                      <div className="text-[10px] text-zinc-500">{u.email}</div>
                    </div>
                  </div>
                </td>
                <td className="px-6 py-4">
                  {profile?.role === 'admin' ? (
                    <select 
                      className="bg-zinc-900 text-xs text-zinc-300 border border-zinc-800 rounded px-2 py-1"
                      value={u.role}
                      onChange={(e) => setRole(u, e.target.value as any)}
                    >
                      <option value="user">User</option>
                      <option value="moderator">Moderator</option>
                      <option value="admin">Admin</option>
                    </select>
                  ) : (
                    <span className="text-xs text-zinc-400 uppercase font-bold">{u.role}</span>
                  )}
                </td>
                <td className="px-6 py-4">
                  <span className={cn("px-2 py-1 rounded-full text-[10px] font-bold uppercase", u.isBanned ? "bg-red-500/10 text-red-500" : "bg-emerald-500/10 text-emerald-500")}>
                    {u.isBanned ? 'Banned' : 'Active'}
                  </span>
                </td>
                <td className="px-6 py-4">
                  <button onClick={() => togglePremium(u)} disabled={profile?.role !== 'admin'} className={cn("w-10 h-5 rounded-full relative transition-colors", u.isPremium ? "bg-emerald-500" : "bg-zinc-700")}>
                    <div className={cn("absolute top-1 w-3 h-3 rounded-full bg-white transition-all", u.isPremium ? "left-6" : "left-1")} />
                  </button>
                </td>
                <td className="px-6 py-4">
                  <Button variant="danger" className="h-8 px-3 text-xs" onClick={() => toggleBan(u)} disabled={u.role === 'admin' || (profile?.role === 'moderator' && u.role === 'moderator')}>
                    {u.isBanned ? 'Unban' : 'Ban'}
                  </Button>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </Card>
    </div>
  );
};

const Layout = ({ children }: { children: React.ReactNode }) => {
  const { profile, logout } = useAuth();
  const navigate = useNavigate();

  if (profile?.isBanned) {
    return (
      <div className="min-h-screen flex items-center justify-center bg-[#020202] p-4">
        <Card className="max-w-md text-center">
          <ShieldAlert className="w-16 h-16 text-red-500 mx-auto mb-4" />
          <h1 className="text-2xl font-bold text-white mb-2">Access Restricted</h1>
          <p className="text-zinc-500 mb-6">Your account has been restricted by the administration.</p>
          <Button variant="secondary" onClick={logout} className="w-full">Sign Out</Button>
        </Card>
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-[#020202] text-zinc-300 flex">
      <aside className="w-64 border-r border-zinc-800 flex flex-col bg-zinc-950/50 backdrop-blur-xl fixed h-full z-20">
        <div className="p-6 flex items-center gap-3 border-b border-zinc-800">
          <div className="w-10 h-10 rounded-xl bg-emerald-500/10 flex items-center justify-center border border-emerald-500/20">
            <Cpu className="w-6 h-6 text-emerald-500" />
          </div>
          <span className="text-xl font-black text-white tracking-tighter uppercase italic">Vertex</span>
        </div>
        <nav className="flex-1 p-4 space-y-2">
          <Link to="/" className="flex items-center gap-3 px-4 py-3 rounded-xl hover:bg-zinc-900 transition-colors">
            <Shield className="w-5 h-5 text-emerald-500" />
            <span className="font-medium">Obfuscator</span>
          </Link>
          <Link to="/history" className="flex items-center gap-3 px-4 py-3 rounded-xl hover:bg-zinc-900 transition-colors">
            <HistoryIcon className="w-5 h-5 text-zinc-500" />
            <span className="font-medium">History</span>
          </Link>
          {(profile?.role === 'admin' || profile?.role === 'moderator') && (
            <Link to="/admin" className="flex items-center gap-3 px-4 py-3 rounded-xl hover:bg-zinc-900 transition-colors">
              <Users className="w-5 h-5 text-amber-500" />
              <span className="font-medium">Users</span>
            </Link>
          )}
        </nav>
        <div className="p-4 border-t border-zinc-800 space-y-4">
          <div className="flex items-center gap-3 px-4 py-2">
            <div className="w-8 h-8 rounded-full bg-zinc-800 flex items-center justify-center">
              <UserIcon className="w-4 h-4 text-zinc-500" />
            </div>
            <div className="flex-1 min-w-0">
              <div className="text-sm font-bold text-white truncate">{profile?.username}</div>
              <div className="text-[10px] text-zinc-500 uppercase font-black tracking-widest flex items-center gap-1">
                {profile?.role} {profile?.isPremium && <Crown className="w-2 h-2 text-amber-500" />}
              </div>
            </div>
          </div>
          <button onClick={logout} className="w-full flex items-center gap-3 px-4 py-3 rounded-xl hover:bg-red-500/10 hover:text-red-500 transition-all group">
            <LogOut className="w-5 h-5 text-zinc-500 group-hover:text-red-500" />
            <span className="font-medium">Sign Out</span>
          </button>
        </div>
      </aside>
      <main className="flex-1 ml-64 p-8">
        {children}
      </main>
    </div>
  );
};

const App = () => {
  return (
    <AuthProvider>
      <Router>
        <Routes>
          <Route path="/login" element={<LoginPage />} />
          <Route path="/" element={<ProtectedRoute><Layout><ObfuscatorPage /></Layout></ProtectedRoute>} />
          <Route path="/history" element={<ProtectedRoute><Layout><HistoryPage /></Layout></ProtectedRoute>} />
          <Route path="/admin" element={<ProtectedRoute><Layout><AdminPage /></Layout></ProtectedRoute>} />
          <Route path="*" element={<Navigate to="/" />} />
        </Routes>
      </Router>
    </AuthProvider>
  );
};

const ProtectedRoute = ({ children }: { children: React.ReactNode }) => {
  const { user, profile, loading } = useAuth();
  if (loading) return null;
  if (!user || !profile) return <Navigate to="/login" />;
  return <>{children}</>;
};

export default App;
