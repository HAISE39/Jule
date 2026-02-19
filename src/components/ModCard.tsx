"use client";

import { motion } from "framer-motion";
import { Check, Download, MessageCircle, ShieldCheck, Tag } from "lucide-react";
import Image from "next/image";
import { ModCategory } from "@/data/mods";

interface ModCardProps {
  title: string;
  image: string;
  type: "Mod" | "Script";
  version: "VIP" | "Free";
  category: ModCategory;
  features: string[];
  downloadUrl?: string;
  whatsappUrl?: string;
}

export default function ModCard({
  title,
  image,
  type,
  version,
  category,
  features,
  downloadUrl,
  whatsappUrl = "https://wa.me/6285706400133",
}: ModCardProps) {
  const isVip = version === "VIP";

  return (
    <motion.div
      whileHover={{ y: -5 }}
      initial={{ opacity: 0, scale: 0.95 }}
      whileInView={{ opacity: 1, scale: 1 }}
      viewport={{ once: true }}
      className="relative group bg-card-bg border border-border-custom rounded-2xl overflow-hidden shadow-2xl transition-all hover:border-primary/50"
    >
      {/* Type & Version Badge */}
      <div className="absolute top-4 left-4 z-10 flex flex-col gap-2">
        <div className="flex gap-2">
          <span className="px-3 py-1 bg-black/50 backdrop-blur-md border border-white/10 rounded-full text-[10px] font-bold uppercase tracking-wider text-white">
            {type}
          </span>
          <span className={`px-3 py-1 rounded-full text-[10px] font-bold uppercase tracking-wider ${
            isVip ? "bg-primary text-background" : "bg-green-500 text-white"
          }`}>
            {version}
          </span>
        </div>
        <div className="flex">
          <span className="px-3 py-1 bg-secondary/80 backdrop-blur-md rounded-full text-[10px] font-bold uppercase tracking-wider text-white flex items-center gap-1">
            <Tag size={10} />
            {category}
          </span>
        </div>
      </div>

      {/* Image Container */}
      <div className="relative h-48 w-full bg-gradient-to-br from-primary/20 to-secondary/20 flex items-center justify-center overflow-hidden">
        {image ? (
          <Image
            src={image}
            alt={title}
            fill
            className="object-cover transition-transform group-hover:scale-110 duration-500"
            sizes="(max-width: 768px) 100vw, (max-width: 1200px) 50vw, 33vw"
          />
        ) : (
          <div className="text-primary/40 flex flex-col items-center">
             <ShieldCheck size={48} />
             <span className="text-[10px] mt-2 opacity-50">VELLIXAO PREVIEW</span>
          </div>
        )}
        <div className="absolute inset-0 bg-gradient-to-t from-card-bg via-transparent to-transparent opacity-60" />
      </div>

      {/* Content */}
      <div className="p-6">
        <h3 className="text-xl font-bold mb-4 text-white group-hover:text-primary transition-colors min-h-[3.5rem] flex items-center">{title}</h3>

        <ul className="space-y-2 mb-6 h-32 overflow-y-auto pr-2 scrollbar-thin">
          {features.map((feature, index) => (
            <li key={index} className="flex items-start text-sm text-foreground/70">
              <Check className="w-4 h-4 text-primary mr-2 mt-0.5 flex-shrink-0" />
              <span>{feature}</span>
            </li>
          ))}
        </ul>

        <div className="pt-4 border-t border-border-custom">
          {isVip ? (
            <a
              href={whatsappUrl}
              target="_blank"
              className="flex items-center justify-center w-full py-3 bg-primary text-background font-bold rounded-xl hover:bg-accent transition-colors gap-2"
            >
              <MessageCircle size={18} />
              Contact for VIP
            </a>
          ) : (
            <a
              href={downloadUrl}
              target="_blank"
              className="flex items-center justify-center w-full py-3 border border-primary text-primary font-bold rounded-xl hover:bg-primary hover:text-background transition-all gap-2"
            >
              <Download size={18} />
              Download Now
            </a>
          )}
        </div>
      </div>
    </motion.div>
  );
}
