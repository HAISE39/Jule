"use client";

import React, { useState } from "react";
import { Sidebar } from "./Sidebar";
import { Menu, X } from "lucide-react";
import { cn } from "@/lib/utils";

interface LayoutProps {
  children: React.ReactNode;
  activeTab: string;
  setActiveTab: (tab: string) => void;
}

export const Layout: React.FC<LayoutProps> = ({ children, activeTab, setActiveTab }) => {
  const [isMobileMenuOpen, setIsMobileMenuOpen] = useState(false);

  return (
    <div className="min-h-screen bg-[#0A0A0A] text-foreground selection:bg-primary/30">
      {/* Grid Background Effect */}
      <div className="fixed inset-0 z-0 opacity-[0.03] pointer-events-none"
           style={{ backgroundImage: 'radial-gradient(circle, #BB86FC 1px, transparent 1px)', backgroundSize: '40px 40px' }} />

      {/* Mobile Nav */}
      <header className="md:hidden fixed top-0 left-0 right-0 h-16 bg-[#0A0A0A]/80 backdrop-blur-md border-b border-primary/20 z-[60] flex items-center justify-between px-6">
        <h1 className="text-xl font-bold text-primary glow-text">VELLIXAO</h1>
        <button
          onClick={() => setIsMobileMenuOpen(!isMobileMenuOpen)}
          className="text-primary p-2"
        >
          {isMobileMenuOpen ? <X /> : <Menu />}
        </button>
      </header>

      {/* Mobile Menu Overlay */}
      <div className={cn(
        "fixed inset-0 bg-[#0A0A0A] z-[55] transition-transform duration-500 md:hidden",
        isMobileMenuOpen ? "translate-y-0" : "-translate-y-full"
      )}>
        <nav className="flex flex-col items-center justify-center h-full gap-8">
          {["home", "skill", "produk", "other", "contact"].map((id) => (
            <button
              key={id}
              onClick={() => {
                setActiveTab(id);
                setIsMobileMenuOpen(false);
              }}
              className={cn(
                "text-2xl font-bold uppercase tracking-[0.2em]",
                activeTab === id ? "text-primary glow-text" : "text-accent/40"
              )}
            >
              {id === 'other' ? 'Web Lain' : id}
            </button>
          ))}
        </nav>
      </div>

      <Sidebar activeTab={activeTab} setActiveTab={setActiveTab} />

      <main className={cn(
        "relative z-10 transition-all duration-500 md:pl-64 min-h-screen",
        isMobileMenuOpen && "blur-sm"
      )}>
        <div className="container mx-auto px-6 py-20 md:py-10">
          {children}
        </div>
      </main>

      {/* Ambient background glows */}
      <div className="fixed top-[-10%] right-[-10%] w-[500px] h-[500px] bg-primary/5 rounded-full blur-[120px] pointer-events-none" />
      <div className="fixed bottom-[-10%] left-[-10%] w-[500px] h-[500px] bg-secondary/5 rounded-full blur-[120px] pointer-events-none" />
    </div>
  );
};
