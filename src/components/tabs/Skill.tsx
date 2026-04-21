"use client";

import React from "react";
import { motion } from "framer-motion";
import { portfolioData } from "@/data/portfolio";
import { Code2, Brackets, Terminal, Zap } from "lucide-react";

export const SkillTab = () => {
  const container = {
    hidden: { opacity: 0 },
    show: {
      opacity: 1,
      transition: {
        staggerChildren: 0.1
      }
    }
  };

  const item = {
    hidden: { opacity: 0, x: -20 },
    show: { opacity: 1, x: 0 }
  };

  return (
    <div className="max-w-4xl py-10">
      <div className="mb-12">
        <h2 className="text-4xl font-bold text-white mb-4 flex items-center gap-3">
          <Code2 className="text-primary" />
          Technical Arsenal
        </h2>
        <p className="text-accent/60 max-w-xl">
          A collection of tools and technologies I use to bring ideas to life. From frontend artistry to backend logic and modding expertise.
        </p>
      </div>

      <motion.div
        variants={container}
        initial="hidden"
        animate="show"
        className="grid md:grid-cols-2 gap-8"
      >
        {portfolioData.skills.map((skill, index) => (
          <motion.div
            key={index}
            variants={item}
            className="group p-6 rounded-2xl bg-primary/5 border border-primary/10 hover:border-primary/30 transition-all duration-300"
          >
            <div className="flex justify-between items-end mb-4">
              <div>
                <span className="text-xs text-primary font-mono uppercase tracking-widest">{skill.category}</span>
                <h3 className="text-xl font-bold text-white group-hover:text-primary transition-colors">{skill.name}</h3>
              </div>
              <span className="text-2xl font-black text-primary/40 group-hover:text-primary/100 transition-colors">{skill.level}%</span>
            </div>

            <div className="h-2 w-full bg-primary/10 rounded-full overflow-hidden">
              <motion.div
                initial={{ width: 0 }}
                animate={{ width: `${skill.level}%` }}
                transition={{ duration: 1, delay: 0.5 + index * 0.1 }}
                className="h-full bg-gradient-to-r from-secondary to-primary shadow-[0_0_10px_rgba(187,134,252,0.5)]"
              />
            </div>
          </motion.div>
        ))}
      </motion.div>

      <div className="mt-16 grid grid-cols-1 md:grid-cols-3 gap-6">
        {[
          { icon: Brackets, title: "Clean Code", desc: "Maintainable and efficient code architecture." },
          { icon: Terminal, title: "Automation", desc: "Streamlining workflows with custom scripts." },
          { icon: Zap, title: "Performance", desc: "Optimizing for speed and responsiveness." }
        ].map((feat, i) => (
          <div key={i} className="p-6 rounded-xl border border-primary/5 bg-primary/2 hover:bg-primary/5 transition-colors">
            <feat.icon className="text-primary mb-4" size={24} />
            <h4 className="text-white font-bold mb-2">{feat.title}</h4>
            <p className="text-sm text-accent/50 leading-relaxed">{feat.desc}</p>
          </div>
        ))}
      </div>
    </div>
  );
};
