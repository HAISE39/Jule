"use client";

import { useState, useEffect, useRef } from "react";
import { Search, ArrowRight, Loader2, Copy, ExternalLink, RefreshCw, AlertCircle, Zap, Hourglass, CheckCircle2, AlertTriangle } from "lucide-react";
import { matchLink } from "@/lib/bypass-config";
import { motion, AnimatePresence } from "framer-motion";

type BypassStatus = "IDLE" | "WAITING" | "ACTIVE" | "COMPLETED" | "ERROR" | "DELAYED";

interface StatusConfig {
  title: string;
  text: string;
  color: string;
  icon: React.ReactNode;
}

export function BypassInput() {
  const [url, setUrl] = useState("");
  const [error, setError] = useState("");
  const [loading, setLoading] = useState(false);
  const [result, setResult] = useState<string | null>(null);
  const [showFallback, setShowFallback] = useState(false);
  const [status, setStatus] = useState<BypassStatus>("IDLE");
  const [statusText, setStatusText] = useState("");

  const pollInterval = useRef<NodeJS.Timeout | null>(null);

  const statusConfigs: Record<BypassStatus, StatusConfig> = {
    IDLE: { title: "", text: "", color: "", icon: null },
    WAITING: {
      title: "Waiting",
      text: "Your request is waiting to be processed.",
      color: "text-yellow-400",
      icon: <Hourglass className="animate-pulse" />
    },
    ACTIVE: {
      title: "Processing",
      text: "This link will take slightly longer due to complex bypass process. Please wait...",
      color: "text-primary",
      icon: <Loader2 className="animate-spin" />
    },
    COMPLETED: {
      title: "Completed",
      text: "Your request has been completed.",
      color: "text-green-400",
      icon: <CheckCircle2 />
    },
    ERROR: {
      title: "Error",
      text: "Your request has encountered an error.",
      color: "text-red-400",
      icon: <AlertCircle />
    },
    DELAYED: {
      title: "Delayed",
      text: "Request failed but we will shortly retry. Just wait a few seconds...",
      color: "text-yellow-500",
      icon: <RefreshCw className="animate-spin" />
    }
  };

  const startPolling = (id: string) => {
    if (pollInterval.current) clearInterval(pollInterval.current);

    pollInterval.current = setInterval(async () => {
      try {
        const response = await fetch(`/api/bypass/long-lived/${id}`);
        const data = await response.json();

        if (data.status) {
          setStatus(data.status as BypassStatus);
          if (data.status === "COMPLETED" && data.result) {
            setResult(data.result);
            setLoading(false);
            if (pollInterval.current) clearInterval(pollInterval.current);
          } else if (data.status === "ERROR") {
            setError(data.errorMessage || "An error occurred during bypass.");
            setLoading(false);
            if (pollInterval.current) clearInterval(pollInterval.current);
          }
        }
      } catch (err) {
        console.error("Polling error:", err);
      }
    }, 3000);
  };

  useEffect(() => {
    return () => {
      if (pollInterval.current) clearInterval(pollInterval.current);
    };
  }, []);

  const handleBypass = async (e: React.FormEvent) => {
    e.preventDefault();
    setError("");
    setResult(null);
    setShowFallback(false);
    setStatus("IDLE");

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
    setStatus("WAITING");

    try {
      const response = await fetch(`/api/bypass?url=${encodeURIComponent(url)}`);
      const data = await response.json();

      if (response.ok) {
        if (data.isLongLivedToken && data.data) {
          startPolling(data.data);
        } else if (data.data) {
          setResult(data.data);
          setStatus("COMPLETED");
          setLoading(false);
        } else if (data.destination) {
           setResult(data.destination);
           setStatus("COMPLETED");
           setLoading(false);
        }
      } else {
        setError(data.message || data.error || "Failed to bypass link.");
        setStatus("ERROR");
        setLoading(false);
        if (response.status === 403 || response.status === 502) {
            setShowFallback(true);
        }
      }
    } catch (err) {
      setError("An error occurred. Please try again later.");
      setStatus("ERROR");
      setLoading(false);
    }
  };

  const handleManualBypass = () => {
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
    setStatus("IDLE");
    if (pollInterval.current) clearInterval(pollInterval.current);
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

            {status !== "IDLE" && status !== "COMPLETED" && (
                <motion.div
                    initial={{ opacity: 0, height: 0 }}
                    animate={{ opacity: 1, height: "auto" }}
                    className="mt-4 p-4 rounded-xl bg-card border border-border overflow-hidden"
                >
                    <div className="flex items-center justify-between mb-2">
                        <span className={`font-bold flex items-center gap-2 ${statusConfigs[status].color}`}>
                            {statusConfigs[status].icon}
                            {statusConfigs[status].title}
                        </span>
                        {loading && <span className="text-[10px] text-foreground/40 uppercase tracking-widest animate-pulse">Live Status</span>}
                    </div>
                    <p className="text-sm text-foreground/60">{statusConfigs[status].text}</p>

                    {status === "ACTIVE" && (
                         <div className="mt-3 w-full bg-background rounded-full h-1 overflow-hidden">
                            <motion.div
                                className="bg-primary h-full"
                                animate={{ x: ["-100%", "100%"] }}
                                transition={{ repeat: Infinity, duration: 1.5, ease: "linear" }}
                            />
                         </div>
                    )}
                </motion.div>
            )}

            {error && (
              <motion.div
                initial={{ opacity: 0, y: -10 }}
                animate={{ opacity: 1, y: 0 }}
                className="mt-4 p-4 rounded-xl bg-red-500/10 border border-red-500/20 text-center"
              >
                <div className="flex items-center justify-center gap-2 text-red-400 text-sm font-medium mb-2">
                    <AlertTriangle size={16} />
                    {error}
                </div>

                {showFallback && (
                    <button
                        onClick={handleManualBypass}
                        className="text-xs bg-red-500/20 hover:bg-red-500/30 text-red-400 py-2 px-4 rounded-lg transition-all flex items-center gap-2 mx-auto"
                    >
                        Try Manual Bypass on Bypass.city
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
