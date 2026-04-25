"use client";

import { useState } from "react";
import { Search, ArrowRight, Loader2 } from "lucide-react";
import { matchLink } from "@/lib/bypass-config";
import { motion } from "framer-motion";

export function BypassInput() {
  const [url, setUrl] = useState("");
  const [error, setError] = useState("");
  const [loading, setLoading] = useState(false);

  const handleBypass = async (e: React.FormEvent) => {
    e.preventDefault();
    setError("");

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

    // Simulate a bit of processing for effect
    await new Promise(resolve => setTimeout(resolve, 800));

    // Determine redirect base based on ping-like logic (simplified for client)
    const redirectBase = "https://bypass.city";
    const bypassUrl = new URL(`${redirectBase}/bypass`);
    bypassUrl.searchParams.set("bypass", url);
    bypassUrl.searchParams.set("userscript", "true");

    window.location.href = bypassUrl.href;
  };

  return (
    <div className="w-full max-w-2xl mx-auto px-4">
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
    </div>
  );
}
