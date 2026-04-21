"use client";

import React from "react";
import { motion } from "framer-motion";
import { portfolioData } from "@/data/portfolio";
import { Send, Github, MessageCircle, Mail, Phone } from "lucide-react";

export const ContactTab = () => {
  return (
    <div className="py-10 max-w-5xl">
      <div className="mb-12">
        <h2 className="text-4xl font-bold text-white mb-4">Get In Touch</h2>
        <p className="text-accent/60">Have a project in mind or want to collaborate? Reach out through any of these platforms.</p>
      </div>

      <div className="grid md:grid-cols-2 gap-12">
        <div className="space-y-8">
          <div className="grid grid-cols-1 gap-4">
            {[
              { icon: Phone, label: "WhatsApp", value: "Chat on WhatsApp", link: portfolioData.contact.whatsapp, color: "hover:text-green-500" },
              { icon: MessageCircle, label: "Telegram", value: "@vellixao", link: portfolioData.contact.telegram, color: "hover:text-blue-400" },
              { icon: Github, label: "GitHub", value: "github.com/vellixao", link: portfolioData.contact.github, color: "hover:text-white" },
              { icon: Mail, label: "Email", value: portfolioData.contact.email, link: `mailto:${portfolioData.contact.email}`, color: "hover:text-primary" }
            ].map((contact, i) => (
              <motion.a
                key={i}
                href={contact.link}
                target="_blank"
                rel="noopener noreferrer"
                initial={{ opacity: 0, y: 10 }}
                animate={{ opacity: 1, y: 0 }}
                transition={{ delay: i * 0.1 }}
                className={`flex items-center gap-4 p-5 rounded-xl bg-primary/5 border border-primary/10 transition-all duration-300 group ${contact.color}`}
              >
                <div className="p-3 rounded-lg bg-primary/10 transition-colors group-hover:bg-primary/20">
                  <contact.icon size={20} />
                </div>
                <div>
                  <p className="text-[10px] uppercase tracking-widest text-accent/40">{contact.label}</p>
                  <p className="font-bold">{contact.value}</p>
                </div>
              </motion.a>
            ))}
          </div>
        </div>

        <motion.div
          initial={{ opacity: 0, scale: 0.95 }}
          animate={{ opacity: 1, scale: 1 }}
          className="p-8 rounded-3xl bg-gradient-to-br from-primary/10 to-secondary/5 border border-primary/20 relative overflow-hidden"
        >
          <div className="absolute top-0 right-0 p-4 opacity-10">
            <Send size={120} className="-rotate-12" />
          </div>

          <h3 className="text-2xl font-bold text-white mb-6">Quick Message</h3>
          <form className="space-y-4 relative z-10" onSubmit={(e) => e.preventDefault()}>
            <div className="space-y-2">
              <label className="text-xs text-accent/60 uppercase tracking-tighter">Your Name</label>
              <input type="text" className="w-full bg-black/40 border border-primary/20 rounded-xl px-4 py-3 focus:outline-none focus:border-primary transition-colors" placeholder="John Doe" />
            </div>
            <div className="space-y-2">
              <label className="text-xs text-accent/60 uppercase tracking-tighter">Email Address</label>
              <input type="email" className="w-full bg-black/40 border border-primary/20 rounded-xl px-4 py-3 focus:outline-none focus:border-primary transition-colors" placeholder="john@example.com" />
            </div>
            <div className="space-y-2">
              <label className="text-xs text-accent/60 uppercase tracking-tighter">Message</label>
              <textarea rows={4} className="w-full bg-black/40 border border-primary/20 rounded-xl px-4 py-3 focus:outline-none focus:border-primary transition-colors resize-none" placeholder="Tell me about your project..." />
            </div>
            <button className="w-full py-4 bg-primary text-black font-bold rounded-xl hover:shadow-[0_0_20px_rgba(187,134,252,0.3)] transition-all">
              Send Transmission
            </button>
          </form>
        </motion.div>
      </div>
    </div>
  );
};
