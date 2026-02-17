"use client";

import { motion } from "framer-motion";

export default function Hero() {
  return (
    <section className="relative pt-24 pb-12 overflow-hidden bg-gradient-to-b from-primary/5 to-transparent">
      <div className="absolute top-0 left-1/2 -translate-x-1/2 w-full h-full -z-10">
        <div className="absolute top-0 left-1/4 w-64 h-64 bg-primary/10 rounded-full blur-[100px]" />
        <div className="absolute top-0 right-1/4 w-64 h-64 bg-secondary/10 rounded-full blur-[100px]" />
      </div>

      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 text-center">
        <motion.div
          initial={{ opacity: 0, y: 10 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.5 }}
        >
          <h1 className="text-4xl md:text-5xl font-extrabold tracking-tight mb-4">
            VELLIXAO <span className="text-primary">Repository</span>
          </h1>
          <p className="text-lg text-foreground/60 max-w-2xl mx-auto">
            Find and download the best game mods and scripts. Professional quality, tested, and updated.
          </p>
        </motion.div>
      </div>
    </section>
  );
}
