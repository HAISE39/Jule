"use client";

import React, { useState } from "react";
import {
  MessageSquare,
  Settings,
  Plus,
  User,
  PanelLeftClose,
  PanelLeftOpen,
  LayoutGrid
} from "lucide-react";
import { motion } from "framer-motion";
import { cn } from "@/lib/utils";

export default function Sidebar() {
  const [isOpen, setIsOpen] = useState(true);

  return (
    <>
      <button
        onClick={() => setIsOpen(true)}
        className={cn(
          "fixed top-4 left-4 z-40 p-2 rounded-lg bg-[#1A1A1A] border border-white/10 text-white/70 hover:text-white transition-all",
          isOpen ? "opacity-0 pointer-events-none" : "opacity-100"
        )}
      >
        <PanelLeftOpen size={20} />
      </button>

      <motion.aside
        initial={false}
        animate={{ width: isOpen ? 280 : 0, opacity: isOpen ? 1 : 0 }}
        className={cn(
          "relative h-screen bg-[#0F0F0F] border-r border-white/5 flex flex-col overflow-hidden",
          !isOpen && "border-none"
        )}
      >
        <div className="p-4 flex items-center justify-between">
          <div className="flex items-center gap-3">
            <div className="w-8 h-8 rounded-lg bg-primary flex items-center justify-center">
              <span className="text-black font-bold text-xs">VT</span>
            </div>
            <span className="font-bold text-lg tracking-tight text-white">VELLTOOLS</span>
          </div>
          <button
            onClick={() => setIsOpen(false)}
            className="p-1.5 rounded-md hover:bg-white/5 text-white/50 hover:text-white transition-colors"
          >
            <PanelLeftClose size={18} />
          </button>
        </div>

        <div className="px-3 py-2">
          <button className="w-full flex items-center gap-3 px-3 py-2.5 rounded-xl bg-white/5 hover:bg-white/10 text-sm font-medium transition-all group">
            <Plus size={18} className="text-primary group-hover:scale-110 transition-transform" />
            <span>New Chat</span>
          </button>
        </div>

        <div className="flex-1 overflow-y-auto px-3 py-4 space-y-1">
          <div className="px-3 py-2 text-[10px] font-bold text-white/30 uppercase tracking-widest">Recent Chats</div>
          <div className="space-y-1">
            {[1, 2, 3].map((i) => (
              <button key={i} className="w-full flex items-center gap-3 px-3 py-2.5 rounded-lg hover:bg-white/5 text-sm text-white/70 hover:text-white transition-all group text-left">
                <MessageSquare size={16} className="shrink-0 text-white/30 group-hover:text-primary" />
                <span className="truncate">Sample Chat History {i}</span>
              </button>
            ))}
          </div>
        </div>

        <div className="p-3 border-t border-white/5 space-y-1">
          <button className="w-full flex items-center gap-3 px-3 py-2.5 rounded-lg hover:bg-white/5 text-sm text-white/70 hover:text-white transition-all">
            <LayoutGrid size={18} />
            <span>Dashboard</span>
          </button>
          <button className="w-full flex items-center gap-3 px-3 py-2.5 rounded-lg hover:bg-white/5 text-sm text-white/70 hover:text-white transition-all">
            <Settings size={18} />
            <span>Settings</span>
          </button>
          <div className="mt-2 p-2 rounded-xl bg-gradient-to-br from-primary/10 to-secondary/10 border border-primary/20 flex items-center gap-3">
            <div className="w-8 h-8 rounded-full bg-primary/20 flex items-center justify-center">
              <User size={16} className="text-primary" />
            </div>
            <div className="flex-1 min-w-0">
              <div className="text-xs font-semibold text-white truncate">User Account</div>
              <div className="text-[10px] text-primary font-medium uppercase">Premium Plan</div>
            </div>
          </div>
        </div>
      </motion.aside>
    </>
  );
}
