"use client";

import React from "react";
import { motion } from "framer-motion";
import { portfolioData } from "@/data/portfolio";
import { Globe, ArrowUpRight } from "lucide-react";

export const OtherLinksTab = () => {
  return (
    <div className="py-10 max-w-4xl">
      <div className="mb-12">
        <h2 className="text-4xl font-bold text-white mb-4">My Ecosystem</h2>
        <p className="text-accent/60">Other platforms and services within the VELLIXAO network.</p>
      </div>

      <div className="space-y-6">
        {portfolioData.otherWebsites.map((web, index) => (
          <motion.a
            key={index}
            href={web.url}
            target="_blank"
            rel="noopener noreferrer"
            initial={{ opacity: 0, x: -20 }}
            animate={{ opacity: 1, x: 0 }}
            transition={{ delay: index * 0.1 }}
            className="flex items-center justify-between p-8 rounded-2xl bg-primary/5 border border-primary/10 hover:border-primary/40 hover:bg-primary/10 transition-all duration-300 group"
          >
            <div className="flex items-center gap-6">
              <div className="p-4 rounded-xl bg-primary/10 text-primary group-hover:scale-110 transition-transform">
                <Globe size={28} />
              </div>
              <div>
                <h3 className="text-2xl font-bold text-white mb-1">{web.name}</h3>
                <p className="text-accent/50">{web.desc}</p>
              </div>
            </div>
            <div className="p-3 rounded-full border border-primary/20 text-primary opacity-0 group-hover:opacity-100 transition-all transform translate-x-4 group-hover:translate-x-0">
              <ArrowUpRight size={24} />
            </div>
          </motion.a>
        ))}
      </div>
    </div>
  );
};
