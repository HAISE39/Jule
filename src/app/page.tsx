"use client";

import { motion } from "framer-motion";
import { BypassInput } from "@/components/BypassInput";
import { SupportedSites } from "@/components/SupportedSites";
import { Shield, Zap, Lock } from "lucide-react";

function Hero() {
  return (
    <section className="pt-24 pb-16 px-4 text-center relative overflow-hidden">
      {/* Background blobs */}
      <div className="absolute top-0 left-1/2 -translate-x-1/2 w-full h-full -z-10 overflow-hidden pointer-events-none">
        <div className="absolute top-[-10%] left-[-10%] w-[40%] h-[40%] bg-primary/10 blur-[120px] rounded-full"></div>
        <div className="absolute bottom-[-10%] right-[-10%] w-[40%] h-[40%] bg-secondary/10 blur-[120px] rounded-full"></div>
      </div>

      <motion.div
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ duration: 0.6 }}
      >
        <h1 className="text-5xl md:text-7xl font-extrabold mb-6 tracking-tight">
          <span className="text-foreground">Bypass with </span>
          <span className="text-primary text-glow">VELLTOOLS</span>
        </h1>
        <p className="text-lg md:text-xl text-foreground/60 max-w-2xl mx-auto mb-10">
          The ultimate tool to bypass Linkvertise, Lootlabs, and many other shortlink providers.
          Fast, secure, and always free.
        </p>
      </motion.div>

      <motion.div
        initial={{ opacity: 0, scale: 0.95 }}
        animate={{ opacity: 1, scale: 1 }}
        transition={{ delay: 0.2, duration: 0.4 }}
      >
        <BypassInput />
      </motion.div>

      <motion.div
        initial={{ opacity: 0 }}
        animate={{ opacity: 1 }}
        transition={{ delay: 0.8 }}
        className="mt-16 grid grid-cols-1 md:grid-cols-3 gap-8 max-w-4xl mx-auto"
      >
        <div className="flex flex-col items-center p-6 bg-card/50 rounded-2xl border border-border">
          <div className="w-12 h-12 bg-primary/20 rounded-full flex items-center justify-center text-primary mb-4">
            <Zap size={24} />
          </div>
          <h3 className="font-bold mb-2">Instant Bypass</h3>
          <p className="text-sm text-foreground/40 text-center">No more waiting for timers. Get to your destination immediately.</p>
        </div>
        <div className="flex flex-col items-center p-6 bg-card/50 rounded-2xl border border-border">
          <div className="w-12 h-12 bg-primary/20 rounded-full flex items-center justify-center text-primary mb-4">
            <Shield size={24} />
          </div>
          <h3 className="font-bold mb-2">Secure</h3>
          <p className="text-sm text-foreground/40 text-center">Privacy-focused redirection that keeps you safe from trackers.</p>
        </div>
        <div className="flex flex-col items-center p-6 bg-card/50 rounded-2xl border border-border">
          <div className="w-12 h-12 bg-primary/20 rounded-full flex items-center justify-center text-primary mb-4">
            <Lock size={24} />
          </div>
          <h3 className="font-bold mb-2">Reliable</h3>
          <p className="text-sm text-foreground/40 text-center">Powered by bypass.city technology for the highest success rate.</p>
        </div>
      </motion.div>
    </section>
  );
}

export default function Home() {
  return (
    <div className="flex flex-col min-h-screen">
      <Hero />
      <SupportedSites />
    </div>
  );
}
