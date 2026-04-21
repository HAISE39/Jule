"use client";

import React from "react";
import { cn } from "@/lib/utils";
import {
  Home,
  Code2,
  Package,
  ExternalLink,
  MessageSquare,
  ChevronRight
} from "lucide-react";

interface SidebarProps {
  activeTab: string;
  setActiveTab: (tab: string) => void;
}

const menuItems = [
  { id: "home", label: "Home", icon: Home },
  { id: "skill", label: "Skill", icon: Code2 },
  { id: "produk", label: "Produk", icon: Package },
  { id: "other", label: "Web Lain", icon: ExternalLink },
  { id: "contact", label: "Contact", icon: MessageSquare },
];

export const Sidebar: React.FC<SidebarProps> = ({ activeTab, setActiveTab }) => {
  return (
    <aside className="fixed left-0 top-0 h-screen w-64 bg-[#0A0A0A] border-r border-primary/20 z-50 hidden md:flex flex-col p-6">
      <div className="mb-10">
        <h1 className="text-2xl font-bold text-primary glow-text tracking-wider">
          VELLIXAO
        </h1>
        <p className="text-xs text-accent/60 mt-1 uppercase tracking-[0.2em]">
          Programmer / Modder
        </p>
      </div>

      <nav className="flex-1 space-y-2">
        {menuItems.map((item) => (
          <button
            key={item.id}
            onClick={() => setActiveTab(item.id)}
            className={cn(
              "w-full flex items-center justify-between px-4 py-3 rounded-lg transition-all duration-300 group",
              activeTab === item.id
                ? "bg-primary/10 text-primary border border-primary/30"
                : "text-accent/60 hover:text-primary hover:bg-primary/5"
            )}
          >
            <div className="flex items-center gap-3">
              <item.icon className={cn(
                "w-5 h-5 transition-transform duration-300",
                activeTab === item.id ? "scale-110" : "group-hover:scale-110"
              )} />
              <span className="font-medium">{item.label}</span>
            </div>
            {activeTab === item.id && (
              <ChevronRight className="w-4 h-4 animate-pulse" />
            )}
          </button>
        ))}
      </nav>

      <div className="mt-auto pt-6 border-t border-primary/10">
        <div className="p-4 rounded-xl bg-gradient-to-br from-secondary/20 to-primary/5 border border-primary/20">
          <p className="text-[10px] text-accent/40 uppercase tracking-widest mb-1">Status</p>
          <div className="flex items-center gap-2 text-xs text-accent">
            <div className="w-2 h-2 rounded-full bg-green-500 animate-pulse" />
            Available for Projects
          </div>
        </div>
      </div>
    </aside>
  );
};
