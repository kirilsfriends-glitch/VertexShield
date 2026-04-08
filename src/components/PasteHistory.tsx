import { useEffect, useState } from "react";
import { db, auth, query, collection, where, onSnapshot, Timestamp } from "../firebase";
import { formatDistanceToNow } from "date-fns";
import { Link } from "react-router-dom";
import { FileText, Clock, ExternalLink, Eye, Code, X, Copy, Check, Terminal } from "lucide-react";
import { motion, AnimatePresence } from "motion/react";
import { handleFirestoreError, OperationType } from "../App";
import { Prism as SyntaxHighlighter } from "react-syntax-highlighter";
import { vscDarkPlus } from "react-syntax-highlighter/dist/esm/styles/prism";
import { toast } from "sonner";

interface Paste {
  id: string;
  title: string;
  content: string;
  obfuscatedContent: string;
  createdAt: Timestamp;
  isPublic: boolean;
  language: string;
}

export default function PasteHistory() {
  const [pastes, setPastes] = useState<Paste[]>([]);
  const [loading, setLoading] = useState(true);
  const [selectedPaste, setSelectedPaste] = useState<Paste | null>(null);
  const [modalTab, setModalTab] = useState<"original" | "obfuscated" | "loadstring">("original");
  const [copied, setCopied] = useState(false);

  useEffect(() => {
    if (!auth.currentUser) return;

    const path = "pastes";
    const q = query(
      collection(db, path),
      where("creatorId", "==", auth.currentUser.uid)
    );

    const unsubscribe = onSnapshot(q, (snapshot) => {
      const pasteList = snapshot.docs.map((doc) => ({
        id: doc.id,
        ...doc.data(),
      })) as Paste[];
      
      setPastes(pasteList.sort((a, b) => b.createdAt.toMillis() - a.createdAt.toMillis()));
      setLoading(false);
    }, (error) => {
      handleFirestoreError(error, OperationType.LIST, path);
    });

    return () => unsubscribe();
  }, []);

  const handleCopy = (content: string) => {
    navigator.clipboard.writeText(content);
    setCopied(true);
    toast.success("Copied to clipboard");
    setTimeout(() => setCopied(false), 2000);
  };

  const getLoadstring = (paste: Paste) => {
    const url = `${window.location.origin}/script/${paste.id}${paste.language === 'lua' ? '.lua' : ''}`;
    return `loadstring(game:HttpGet("${url}"))()`;
  };

  if (loading) {
    return (
      <div className="flex justify-center items-center h-48">
        <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-primary"></div>
      </div>
    );
  }

  if (pastes.length === 0) {
    return (
      <div className="text-center py-12 bg-zinc-900/50 rounded-xl border border-zinc-800">
        <FileText className="mx-auto h-12 w-12 text-zinc-700 mb-4" />
        <h3 className="text-lg font-medium text-zinc-300">No pastes yet</h3>
        <p className="text-zinc-500 mt-2">Create your first secure paste to see it here.</p>
      </div>
    );
  }

  return (
    <div className="grid gap-4">
      <AnimatePresence mode="popLayout">
        {pastes.map((paste, index) => (
          <motion.div
            key={paste.id}
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ delay: index * 0.05 }}
            onClick={() => {
              setModalTab("original");
              setSelectedPaste(paste);
            }}
            className="group bg-zinc-900/50 hover:bg-zinc-800/50 border border-zinc-800 hover:border-zinc-700 rounded-xl p-4 transition-all duration-300 cursor-pointer"
          >
            <div className="flex items-center justify-between">
              <div className="flex items-center gap-4">
                <div className="p-2 bg-zinc-800 rounded-lg group-hover:bg-zinc-700 transition-colors">
                  <FileText className="h-5 w-5 text-zinc-400 group-hover:text-primary transition-colors" />
                </div>
                <div>
                  <h4 className="font-medium text-zinc-200 group-hover:text-white transition-colors">
                    {paste.title || "Untitled Paste"}
                  </h4>
                  <div className="flex items-center gap-3 mt-1 text-xs text-zinc-500">
                    <span className="flex items-center gap-1">
                      <Clock className="h-3 w-3" />
                      {formatDistanceToNow(paste.createdAt.toDate(), { addSuffix: true })}
                    </span>
                    <span className="px-1.5 py-0.5 bg-zinc-800 rounded text-zinc-400 uppercase tracking-wider">
                      {paste.language || "text"}
                    </span>
                    {paste.isPublic ? (
                      <span className="text-emerald-500">Public</span>
                    ) : (
                      <span className="text-amber-500">Private</span>
                    )}
                  </div>
                </div>
              </div>
              
              <div className="flex items-center gap-2 opacity-0 group-hover:opacity-100 transition-opacity">
                <button
                  onClick={() => {
                    setModalTab("original");
                    setSelectedPaste(paste);
                  }}
                  className="flex items-center gap-2 px-3 py-1.5 bg-primary/10 hover:bg-primary/20 text-primary rounded-lg transition-all text-xs font-bold"
                >
                  <Code className="h-4 w-4" />
                  <span>View Details</span>
                </button>
                <Link
                  to={`/paste/${paste.id}`}
                  onClick={(e) => e.stopPropagation()}
                  className="p-2 hover:bg-zinc-700 rounded-lg text-zinc-400 hover:text-white transition-all"
                  title="View Script Page"
                >
                  <Eye className="h-4 w-4" />
                </Link>
                <a
                  href={`/script/${paste.id}${paste.language === 'lua' ? '.lua' : ''}?raw=true`}
                  onClick={(e) => e.stopPropagation()}
                  target="_blank"
                  rel="noopener noreferrer"
                  className="p-2 hover:bg-zinc-700 rounded-lg text-zinc-400 hover:text-white transition-all"
                  title="Raw Link"
                >
                  <ExternalLink className="h-4 w-4" />
                </a>
              </div>
            </div>
          </motion.div>
        ))}
      </AnimatePresence>

      {/* Source Modal */}
      <AnimatePresence>
        {selectedPaste && (
          <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/80 backdrop-blur-sm">
            <motion.div
              initial={{ opacity: 0, scale: 0.95 }}
              animate={{ opacity: 1, scale: 1 }}
              exit={{ opacity: 0, scale: 0.95 }}
              className="bg-zinc-900 border border-zinc-800 rounded-2xl w-full max-w-4xl max-h-[80vh] flex flex-col shadow-2xl"
            >
              <div className="p-4 border-b border-zinc-800 flex items-center justify-between bg-zinc-900/50">
                <div className="flex items-center gap-3">
                  <div className="p-2 bg-primary/10 rounded-lg">
                    <Code className="h-5 w-5 text-primary" />
                  </div>
                  <div>
                    <h3 className="font-bold text-white">{selectedPaste.title}</h3>
                    <p className="text-xs text-zinc-500 uppercase tracking-widest">{selectedPaste.language}</p>
                  </div>
                </div>
                <button
                  onClick={() => setSelectedPaste(null)}
                  className="p-2 hover:bg-zinc-800 rounded-lg text-zinc-400 hover:text-white transition-all"
                >
                  <X className="h-5 w-5" />
                </button>
              </div>

              <div className="flex border-b border-zinc-800 bg-zinc-900/30">
                <button
                  onClick={() => setModalTab("original")}
                  className={`px-6 py-3 text-sm font-medium transition-all border-b-2 ${modalTab === "original" ? "border-primary text-primary bg-primary/5" : "border-transparent text-zinc-500 hover:text-zinc-300"}`}
                >
                  Original Source
                </button>
                <button
                  onClick={() => setModalTab("obfuscated")}
                  className={`px-6 py-3 text-sm font-medium transition-all border-b-2 ${modalTab === "obfuscated" ? "border-primary text-primary bg-primary/5" : "border-transparent text-zinc-500 hover:text-zinc-300"}`}
                >
                  Obfuscated
                </button>
                <button
                  onClick={() => setModalTab("loadstring")}
                  className={`px-6 py-3 text-sm font-medium transition-all border-b-2 ${modalTab === "loadstring" ? "border-primary text-primary bg-primary/5" : "border-transparent text-zinc-500 hover:text-zinc-300"}`}
                >
                  Loadstring
                </button>
              </div>

              <div className="flex-1 overflow-auto p-0 bg-black/50 relative group">
                <div className="absolute top-4 right-4 z-10 opacity-0 group-hover:opacity-100 transition-opacity">
                  <button
                    onClick={() => {
                      const content = modalTab === "original" ? selectedPaste.content : 
                                     modalTab === "obfuscated" ? selectedPaste.obfuscatedContent : 
                                     getLoadstring(selectedPaste);
                      handleCopy(content);
                    }}
                    className="flex items-center gap-2 px-3 py-1.5 bg-zinc-900/80 hover:bg-zinc-800 border border-zinc-700 rounded-lg text-zinc-400 hover:text-white transition-all backdrop-blur-sm text-xs font-bold"
                  >
                    {copied ? <Check className="h-3 w-3 text-emerald-500" /> : <Copy className="h-3 w-3" />}
                    <span>{copied ? "Copied" : "Copy"}</span>
                  </button>
                </div>

                {modalTab === "loadstring" ? (
                  <div className="p-8 flex flex-col items-center justify-center h-full gap-6">
                    <div className="p-4 bg-primary/10 rounded-full">
                      <Terminal className="h-12 w-12 text-primary" />
                    </div>
                    <div className="w-full max-w-2xl bg-black border border-zinc-800 rounded-xl p-4">
                      <code className="text-sm text-primary font-mono break-all block text-left">
                        {getLoadstring(selectedPaste)}
                      </code>
                    </div>
                    <button
                      onClick={() => handleCopy(getLoadstring(selectedPaste))}
                      className="px-8 py-3 bg-primary text-black font-bold rounded-xl hover:bg-primary/90 transition-all shadow-lg shadow-primary/20 flex items-center gap-2"
                    >
                      <Copy className="h-5 w-5" />
                      <span>Copy Loadstring</span>
                    </button>
                  </div>
                ) : (
                  <SyntaxHighlighter
                    language={selectedPaste.language}
                    style={vscDarkPlus}
                    customStyle={{
                      margin: 0,
                      padding: '2rem',
                      fontSize: '0.875rem',
                      backgroundColor: 'transparent',
                      lineHeight: '1.6'
                    }}
                    showLineNumbers
                  >
                    {modalTab === "original" ? selectedPaste.content : selectedPaste.obfuscatedContent}
                  </SyntaxHighlighter>
                )}
              </div>

              <div className="p-4 border-t border-zinc-800 flex justify-between items-center bg-zinc-900/50">
                <p className="text-xs text-zinc-500 font-mono">
                  ID: {selectedPaste.id}
                </p>
                <button
                  onClick={() => setSelectedPaste(null)}
                  className="px-6 py-2 bg-zinc-800 hover:bg-zinc-700 text-white rounded-lg transition-all text-sm font-bold"
                >
                  Close
                </button>
              </div>
            </motion.div>
          </div>
        )}
      </AnimatePresence>
    </div>
  );
}
