"use client";

import React from "react";
import { motion } from "framer-motion";
import { portfolioData } from "@/data/portfolio";
import { ExternalLink, Tag, ShieldCheck, Download } from "lucide-react";
import { cn } from "@/lib/utils";

export const ProdukTab = () => {
  return (
    <div className="py-10">
      <div className="mb-12">
        <h2 className="text-4xl font-bold text-white mb-4">Selected Products</h2>
        <p className="text-accent/60">Tools, mods, and applications developed by VELLIXAO.</p>
      </div>

      <div className="grid md:grid-cols-2 lg:grid-cols-3 gap-8">
        {portfolioData.products.map((product, index) => (
          <motion.div
            key={product.id}
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ delay: index * 0.1 }}
            className="group relative flex flex-col p-6 rounded-2xl bg-[#111] border border-primary/10 hover:border-primary/40 transition-all duration-500 overflow-hidden"
          >
            {/* Background glow on hover */}
            <div className="absolute inset-0 bg-primary/5 opacity-0 group-hover:opacity-100 transition-opacity duration-500" />

            <div className="relative z-10 flex flex-col h-full">
              <div className="flex justify-between items-start mb-6">
                <div className={cn(
                  "px-3 py-1 rounded-full text-[10px] font-bold uppercase tracking-wider",
                  product.version === "VIP"
                    ? "bg-amber-500/10 text-amber-500 border border-amber-500/20"
                    : "bg-blue-500/10 text-blue-500 border border-blue-500/20"
                )}>
                  {product.version}
                </div>
                <Tag size={18} className="text-primary/40 group-hover:text-primary transition-colors" />
              </div>

              <h3 className="text-2xl font-bold text-white mb-3 group-hover:text-primary transition-colors">
                {product.title}
              </h3>

              <p className="text-accent/60 text-sm leading-relaxed mb-8 flex-1">
                {product.description}
              </p>

              <div className="flex items-center gap-4 text-xs text-accent/40 mb-6 font-mono">
                <div className="flex items-center gap-1">
                  <ShieldCheck size={14} className="text-green-500/50" />
                  <span>Verified</span>
                </div>
                <span>•</span>
                <span>{product.category}</span>
                <span>•</span>
                <span>{product.type}</span>
              </div>

              <a
                href={product.link}
                target="_blank"
                rel="noopener noreferrer"
                className={cn(
                  "flex items-center justify-center gap-2 w-full py-3 rounded-xl font-bold transition-all duration-300",
                  product.version === "VIP"
                    ? "bg-amber-500 text-black hover:bg-amber-400"
                    : "bg-primary text-background hover:bg-accent"
                )}
              >
                {product.version === "VIP" ? "Order on WhatsApp" : "Download Now"}
                {product.version === "VIP" ? <ExternalLink size={16} /> : <Download size={16} />}
              </a>
            </div>
          </motion.div>
        ))}
      </div>
    </div>
  );
};
