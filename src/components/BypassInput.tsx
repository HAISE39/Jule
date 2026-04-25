"use client";

import { useState } from "react";
import { Search, ArrowRight, Loader2, Copy, ExternalLink, RefreshCw, AlertCircle, Zap } from "lucide-react";
import { matchLink } from "@/lib/bypass-config";
import { motion, AnimatePresence } from "framer-motion";

export function BypassInput() {
  const [url, setUrl] = useState("");
  const [error, setError] = useState("");
  const [loading, setLoading] = useState(false);
  const [result, setResult] = useState<string | null>(null);
  const [showFallback, setShowFallback] = useState(false);

  const handleBypass = async (e: React.FormEvent) => {
    e.preventDefault();
    setError("");
    setResult(null);
    setShowFallback(false);

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
        if (data.fallback) {
            setShowFallback(true);
        }
      }
    } catch (err) {
      setError("An error occurred. Please try again later.");
    } finally {
      setLoading(false);
    }
  };

  const handleManualBypass = () => {
    // This replicates the original userscript logic as a fallback
    const bypassUrl = `https://bypass.city/bypass?bypass=${encodeURIComponent(url)}&userscript=true`;
    window.open(bypassUrl, "_blank");
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
    setShowFallback(false);
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
              <motion.div
                initial={{ opacity: 0, y: -10 }}
                animate={{ opacity: 1, y: 0 }}
                className="mt-4 p-4 rounded-xl bg-red-500/10 border border-red-500/20 text-center"
              >
                <div className="flex items-center justify-center gap-2 text-red-400 text-sm font-medium mb-2">
                    <AlertCircle size={16} />
                    {error}
                </div>

                {showFallback && (
                    <button
                        onClick={handleManualBypass}
                        className="text-xs bg-red-500/20 hover:bg-red-500/30 text-red-400 py-2 px-4 rounded-lg transition-all flex items-center gap-2 mx-auto"
                    >
                        Try Alternative Bypass
                        <ExternalLink size={14} />
                    </button>
                )}
              </motion.div>
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
