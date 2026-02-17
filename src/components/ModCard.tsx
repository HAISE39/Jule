"use client";

import { motion } from "framer-motion";
import { Check, Download, MessageCircle, ShieldCheck } from "lucide-react";
import Image from "next/image";

interface ModCardProps {
  title: string;
  image: string;
  type: "Mod" | "Script";
  version: "VIP" | "Free";
  features: string[];
  downloadUrl?: string;
  whatsappUrl?: string;
}

export default function ModCard({
  title,
  image,
  type,
  version,
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
      <div className="absolute top-4 left-4 z-10 flex gap-2">
        <span className="px-3 py-1 bg-black/50 backdrop-blur-md border border-white/10 rounded-full text-[10px] font-bold uppercase tracking-wider text-white">
          {type}
        </span>
        <span className={`px-3 py-1 rounded-full text-[10px] font-bold uppercase tracking-wider ${
          isVip ? "bg-primary text-background" : "bg-green-500 text-white"
        }`}>
          {version}
        </span>
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
      </div>

      {/* Content */}
      <div className="p-6">
        <h3 className="text-xl font-bold mb-4 text-white group-hover:text-primary transition-colors">{title}</h3>

        <ul className="space-y-2 mb-6">
          {features.map((feature, index) => (
            <li key={index} className="flex items-center text-sm text-foreground/70">
              <Check className="w-4 h-4 text-primary mr-2 flex-shrink-0" />
              {feature}
            </li>
          ))}
        </ul>

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
    </motion.div>
  );
}
