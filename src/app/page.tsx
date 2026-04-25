"use client";

import { useState } from "react";
import { motion, AnimatePresence } from "framer-motion";
import { Link2, ArrowRight, Loader2, CheckCircle2, AlertCircle, Copy, ExternalLink, RefreshCcw } from "lucide-react";
import { startBypass, BypassStatus } from "@/lib/bypass";
import { clsx, type ClassValue } from "clsx";
import { twMerge } from "tailwind-merge";

function cn(...inputs: ClassValue[]) {
  return twMerge(clsx(inputs));
}

export default function Home() {
  const [url, setUrl] = useState("");
  const [status, setStatus] = useState<BypassStatus | null>(null);
  const [loading, setLoading] = useState(false);

  const handleBypass = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!url) return;

    setLoading(true);
    setStatus({ message: "Identifying link provider...", type: "info" });

    await startBypass(url, (update) => {
      setStatus(update);
      if (update.type === 'success' || update.type === 'error') {
        setLoading(false);
      }
    });
  };

  const handleCopy = () => {
    if (status?.destination) {
      navigator.clipboard.writeText(status.destination);
    } else if (status?.content) {
      navigator.clipboard.writeText(status.content);
    }
  };

  const reset = () => {
    setUrl("");
    setStatus(null);
    setLoading(false);
  };

  return (
    <main className="min-h-screen flex flex-col items-center justify-center p-4">
      <div className="w-full mx-auto max-w-xl">
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          className="text-center mb-8"
        >
          <h1 className="text-5xl font-bold glow-text mb-2 tracking-tight">
            VELL<span className="text-primary">TOOLS</span>
          </h1>
          <p className="text-gray-400 text-sm">by skipped.lol & vellixao</p>
        </motion.div>

        <AnimatePresence mode="wait">
          {!status || (status.type === 'info' && loading) ? (
            <motion.div
              key="input"
              initial={{ opacity: 0, scale: 0.95 }}
              animate={{ opacity: 1, scale: 1 }}
              exit={{ opacity: 0, scale: 1.05 }}
              className="bg-black/40 backdrop-blur-xl border border-white/10 rounded-2xl p-8 glow-border"
            >
              <form onSubmit={handleBypass} className="space-y-4">
                <div className="relative">
                  <div className="absolute inset-y-0 left-4 flex items-center pointer-events-none text-gray-500">
                    <Link2 size={20} />
                  </div>
                  <input
                    type="text"
                    value={url}
                    onChange={(e) => setUrl(e.target.value)}
                    placeholder="Paste your short link here..."
                    className="w-full bg-white/5 border border-white/10 rounded-xl py-4 pl-12 pr-4 text-white placeholder:text-gray-600 focus:outline-none focus:ring-2 focus:ring-primary/50 transition-all"
                  />
                </div>

                <button
                  type="submit"
                  disabled={loading || !url}
                  className="w-full bg-gradient-to-r from-primary to-secondary text-white font-semibold py-4 rounded-xl flex items-center justify-center gap-2 hover:opacity-90 disabled:opacity-50 transition-all group"
                >
                  {loading ? (
                    <Loader2 className="animate-spin" size={20} />
                  ) : (
                    <>
                      Bypass Now
                      <ArrowRight size={20} className="group-hover:translate-x-1 transition-transform" />
                    </>
                  )}
                </button>
              </form>

              {status && (
                <motion.p
                  initial={{ opacity: 0 }}
                  animate={{ opacity: 1 }}
                  className="mt-4 text-center text-sm text-primary animate-pulse"
                >
                  {status.message}
                </motion.p>
              )}
            </motion.div>
          ) : (
            <motion.div
              key="result"
              initial={{ opacity: 0, scale: 0.95 }}
              animate={{ opacity: 1, scale: 1 }}
              exit={{ opacity: 0, scale: 1.05 }}
              className="bg-black/40 backdrop-blur-xl border border-white/10 rounded-2xl p-8 glow-border"
            >
              <div className="text-center space-y-6">
                <div className="flex justify-center">
                  {status.type === 'success' ? (
                    <CheckCircle2 size={64} className="text-green-400" />
                  ) : (
                    <AlertCircle size={64} className="text-red-400" />
                  )}
                </div>

                <div className="space-y-2">
                  <h2 className="text-2xl font-bold">
                    {status.type === 'success' ? 'Bypass Successful!' : 'Bypass Failed'}
                  </h2>
                  <p className="text-gray-400">{status.message}</p>
                </div>

                {status.destination && (
                  <div className="bg-white/5 border border-white/10 rounded-xl p-4 break-all text-sm font-mono text-gray-300">
                    {status.destination}
                  </div>
                )}

                {status.content && (
                  <div className="bg-white/5 border border-white/10 rounded-xl p-4 whitespace-pre-wrap text-left text-sm text-gray-300">
                    {status.content}
                  </div>
                )}

                <div className="grid grid-cols-2 gap-4">
                  <button
                    onClick={handleCopy}
                    className="bg-white/5 hover:bg-white/10 border border-white/10 text-white font-semibold py-3 rounded-xl flex items-center justify-center gap-2 transition-all"
                  >
                    <Copy size={18} />
                    Copy
                  </button>
                  {status.destination ? (
                    <a
                      href={status.destination}
                      target="_blank"
                      rel="noopener noreferrer"
                      className="bg-primary text-black font-bold py-3 rounded-xl flex items-center justify-center gap-2 transition-all hover:opacity-90"
                    >
                      <ExternalLink size={18} />
                      Open
                    </a>
                  ) : (
                    <button
                      onClick={reset}
                      className="bg-primary text-black font-bold py-3 rounded-xl flex items-center justify-center gap-2 transition-all hover:opacity-90"
                    >
                      <RefreshCcw size={18} />
                      Try Again
                    </button>
                  )}
                </div>

                {status.type === 'success' && (
                  <button
                    onClick={reset}
                    className="text-sm text-gray-500 hover:text-white transition-colors"
                  >
                    Bypass another link
                  </button>
                )}
              </div>
            </motion.div>
          )}
        </AnimatePresence>
      </div>
    </main>
  );
}
