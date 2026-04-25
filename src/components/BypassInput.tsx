"use client";

import { useState } from "react";
import { Search, ArrowRight, Loader2, Copy, ExternalLink, RefreshCw } from "lucide-react";
import { matchLink } from "@/lib/bypass-config";
import { motion, AnimatePresence } from "framer-motion";

export function BypassInput() {
  const [url, setUrl] = useState("");
  const [error, setError] = useState("");
  const [loading, setLoading] = useState(false);
  const [result, setResult] = useState<string | null>(null);

  const handleBypass = async (e: React.FormEvent) => {
    e.preventDefault();
    setError("");
    setResult(null);

    if (!url) {
      setError("Please enter a URL");
      return;
    }

    const match = matchLink(url);
    if (!match.match) {
      setError("Unsupported URL. Please check the supported sites below.");
      return;
    }

    setLoading(true);

    try {
      const response = await fetch(`/api/bypass?url=${encodeURIComponent(url)}`);
      const data = await response.json();

      if (data.success && data.destination) {
        setResult(data.destination);
      } else {
        setError(data.error || "Failed to bypass link. Please try again.");
      }
    } catch (err) {
      setError("An error occurred. Please try again later.");
    } finally {
      setLoading(false);
    }
  };

  const copyToClipboard = () => {
    if (result) {
      navigator.clipboard.writeText(result);
    }
  };

  const reset = () => {
    setUrl("");
    setResult(null);
    setError("");
  };

  return (
    <div className="w-full max-w-2xl mx-auto px-4">
      <AnimatePresence mode="wait">
        {!result ? (
          <motion.div
            key="input-form"
            initial={{ opacity: 0, y: 10 }}
            animate={{ opacity: 1, y: 0 }}
            exit={{ opacity: 0, y: -10 }}
          >
            <form onSubmit={handleBypass} className="relative group">
              <div className="absolute -inset-1 bg-gradient-to-r from-primary to-secondary rounded-2xl blur opacity-25 group-hover:opacity-50 transition duration-1000 group-hover:duration-200"></div>
              <div className="relative flex items-center bg-card border border-border rounded-xl overflow-hidden focus-within:ring-2 ring-primary/50 transition-all">
                <div className="pl-4 text-foreground/40">
                  <Search size={20} />
                </div>
                <input
                  type="url"
                  value={url}
                  onChange={(e) => setUrl(e.target.value)}
                  placeholder="Paste your shortlink here..."
                  className="w-full bg-transparent border-none focus:ring-0 text-foreground py-4 px-4 outline-none placeholder:text-foreground/20"
                />
                <button
                  type="submit"
                  disabled={loading}
                  className="bg-primary hover:bg-accent text-background font-bold py-4 px-6 transition-colors flex items-center space-x-2 disabled:opacity-50"
                >
                  {loading ? (
                    <Loader2 className="animate-spin" size={20} />
                  ) : (
                    <>
                      <span>Bypass</span>
                      <ArrowRight size={20} />
                    </>
                  )}
                </button>
              </div>
            </form>
            {error && (
              <motion.p
                initial={{ opacity: 0, y: -10 }}
                animate={{ opacity: 1, y: 0 }}
                className="text-red-400 text-sm mt-4 text-center"
              >
                {error}
              </motion.p>
            )}
          </motion.div>
        ) : (
          <motion.div
            key="result-display"
            initial={{ opacity: 0, scale: 0.95 }}
            animate={{ opacity: 1, scale: 1 }}
            exit={{ opacity: 0, scale: 0.95 }}
            className="bg-card border border-border p-6 rounded-2xl glow relative overflow-hidden"
          >
            <div className="absolute top-0 right-0 p-4">
               <button
                onClick={reset}
                className="text-foreground/40 hover:text-primary transition-colors"
                title="Bypass another link"
               >
                 <RefreshCw size={20} />
               </button>
            </div>
            <h3 className="text-xl font-bold text-primary mb-4 flex items-center gap-2">
              <Zap size={20} className="fill-primary" />
              Bypass Successful!
            </h3>
            <div className="bg-background/50 border border-border rounded-lg p-4 mb-6 break-all font-mono text-sm">
              {result}
            </div>
            <div className="flex flex-col sm:flex-row gap-3">
              <button
                onClick={copyToClipboard}
                className="flex-1 bg-secondary hover:bg-secondary/80 text-white font-bold py-3 px-6 rounded-xl flex items-center justify-center gap-2 transition-all"
              >
                <Copy size={18} />
                Copy Link
              </button>
              <a
                href={result}
                target="_blank"
                rel="noopener noreferrer"
                className="flex-1 bg-primary hover:bg-accent text-background font-bold py-3 px-6 rounded-xl flex items-center justify-center gap-2 transition-all"
              >
                <ExternalLink size={18} />
                Open Link
              </a>
            </div>
          </motion.div>
        )}
      </AnimatePresence>
    </div>
  );
}

function Zap({ size, className }: { size: number, className: string }) {
    return (
        <svg
            xmlns="http://www.w3.org/2000/svg"
            width={size}
            height={size}
            viewBox="0 0 24 24"
            fill="none"
            stroke="currentColor"
            strokeWidth="2"
            strokeLinecap="round"
            strokeLinejoin="round"
            className={className}
        >
            <path d="M4 14.71 12 2l1.6 9h6.4L12 22l-1.6-9H4z"/>
        </svg>
    )
}
