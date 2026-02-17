"use client";

import { motion } from "framer-motion";

export default function Hero() {
  return (
    <section className="relative pt-32 pb-20 overflow-hidden">
      <div className="absolute top-0 left-1/2 -translate-x-1/2 w-full h-full -z-10">
        <div className="absolute top-0 left-1/4 w-64 h-64 bg-primary/20 rounded-full blur-[100px]" />
        <div className="absolute bottom-0 right-1/4 w-96 h-96 bg-secondary/10 rounded-full blur-[120px]" />
      </div>

      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 text-center">
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.6 }}
        >
          <h1 className="text-5xl md:text-7xl font-extrabold tracking-tight mb-6">
            Elevate Your <span className="text-primary">Gaming</span> Experience
          </h1>
          <p className="text-xl text-foreground/60 max-w-2xl mx-auto mb-10">
            Premium scripts and mods for your favorite games. Professional, secure, and always up-to-date. Join VELLIXAO today.
          </p>
          <div className="flex flex-col sm:flex-row items-center justify-center gap-4">
            <a
              href="#products"
              className="px-8 py-3 bg-primary text-background font-bold rounded-full hover:bg-accent transition-all transform hover:scale-105"
            >
              Explore Products
            </a>
            <a
              href="https://wa.me/6285706400133"
              target="_blank"
              className="px-8 py-3 border border-primary text-primary font-bold rounded-full hover:bg-primary/10 transition-all transform hover:scale-105"
            >
              Contact Developer
            </a>
          </div>
        </motion.div>
      </div>
    </section>
  );
}
