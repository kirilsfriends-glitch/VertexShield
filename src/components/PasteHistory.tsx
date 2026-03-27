import { useEffect, useState } from "react";
import { db, auth, query, collection, where, onSnapshot, Timestamp } from "../firebase";
import { formatDistanceToNow } from "date-fns";
import { Link } from "react-router-dom";
import { FileText, Clock, ExternalLink, Eye } from "lucide-react";
import { motion, AnimatePresence } from "motion/react";
import { handleFirestoreError, OperationType } from "../App";

interface Paste {
  id: string;
  title: string;
  createdAt: Timestamp;
  isPublic: boolean;
  language: string;
}

export default function PasteHistory() {
  const [pastes, setPastes] = useState<Paste[]>([]);
  const [loading, setLoading] = useState(true);

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
            className="group bg-zinc-900/50 hover:bg-zinc-800/50 border border-zinc-800 hover:border-zinc-700 rounded-xl p-4 transition-all duration-300"
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
                <Link
                  to={`/paste/${paste.id}`}
                  className="p-2 hover:bg-zinc-700 rounded-lg text-zinc-400 hover:text-white transition-all"
                  title="View Paste"
                >
                  <Eye className="h-4 w-4" />
                </Link>
                <a
                  href={`/scripts/hosted/${paste.id}${paste.language === 'lua' ? '.lua' : ''}`}
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
    </div>
  );
}
