"use client";

import React, { useEffect, useRef } from "react";
import anime from "animejs";
import { portfolioData } from "@/data/portfolio";
import { Terminal, Cpu, Sparkles } from "lucide-react";

export const HomeTab = () => {
  const containerRef = useRef<HTMLDivElement>(null);
  const textRef = useRef<HTMLHeadingElement>(null);

  useEffect(() => {
    if (textRef.current) {
      // Anime.js text animation
      const textWrapper = textRef.current;
      textWrapper.innerHTML = textWrapper.textContent!.replace(/\S/g, "<span class='letter inline-block'>$&</span>");

      anime.timeline({ loop: false })
        .add({
          targets: '.letter',
          translateY: [40, 0],
          translateZ: 0,
          opacity: [0, 1],
          easing: "easeOutExpo",
          duration: 1200,
          delay: (el: any, i: number) => 500 + 30 * i
        })
        .add({
          targets: '.hero-desc',
          opacity: [0, 1],
          translateY: [20, 0],
          easing: "easeOutExpo",
          duration: 800,
          offset: '-=800'
        });
    }

    // Background shapes animation
    anime({
      targets: '.bg-shape',
      translateX: () => anime.random(-20, 20),
      translateY: () => anime.random(-20, 20),
      rotate: () => anime.random(-10, 10),
      duration: 3000,
      direction: 'alternate',
      loop: true,
      easing: 'easeInOutQuad'
    });
  }, []);

  return (
    <div ref={containerRef} className="relative min-h-[80vh] flex flex-col justify-center overflow-hidden">
      {/* Decorative Anime Elements */}
      <div className="absolute top-0 right-0 w-64 h-64 border-t-2 border-r-2 border-primary/20 bg-primary/5 -mr-10 -mt-10 rotate-12 bg-shape" />
      <div className="absolute bottom-0 left-0 w-48 h-48 border-b-2 border-l-2 border-secondary/20 bg-secondary/5 -ml-10 -mb-10 -rotate-12 bg-shape" />

      <div className="relative z-10 max-w-3xl">
        <div className="inline-flex items-center gap-2 px-3 py-1 rounded-full bg-primary/10 border border-primary/20 text-primary text-xs font-mono mb-6 animate-float">
          <Terminal size={14} />
          <span>System.init("VELLIXAO")</span>
        </div>

        <h1 ref={textRef} className="text-6xl md:text-8xl font-black text-white leading-tight tracking-tighter mb-6">
          {portfolioData.profile.name}
        </h1>

        <p className="hero-desc text-xl md:text-2xl text-accent/70 font-light max-w-2xl leading-relaxed mb-10">
          {portfolioData.profile.bio}
        </p>

        <div className="hero-desc flex flex-wrap gap-4">
          <button className="px-8 py-4 bg-primary text-background font-bold rounded-full hover:shadow-[0_0_20px_rgba(187,134,252,0.5)] transition-all duration-300 transform hover:-translate-y-1 active:scale-95">
            View My Works
          </button>
          <button className="px-8 py-4 bg-transparent border border-primary/30 text-primary font-bold rounded-full hover:bg-primary/5 transition-all duration-300">
            Contact Me
          </button>
        </div>

        <div className="hero-desc mt-16 grid grid-cols-3 gap-8">
          {[
            { icon: Cpu, label: "Efficiency", value: "99.9%" },
            { icon: Sparkles, label: "Creativity", value: "Infinity" },
            { icon: Cpu, label: "Focus", value: "Deep" }
          ].map((item, i) => (
            <div key={i} className="flex flex-col gap-1">
              <div className="flex items-center gap-2 text-primary/60">
                <item.icon size={16} />
                <span className="text-[10px] uppercase tracking-widest">{item.label}</span>
              </div>
              <span className="text-xl font-mono text-white">{item.value}</span>
            </div>
          ))}
        </div>
      </div>

      {/* Code Snippet Decoration */}
      <div className="absolute right-0 bottom-0 opacity-10 font-mono text-xs text-primary hidden lg:block select-none pointer-events-none">
        <pre>{`
function initializeProfile() {
  const dev = new Programmer("VELLIXAO");
  dev.addSkill("React", "TypeScript", "Lua");
  dev.setAesthetic("Anime", "Dark", "Purple");
  return dev.deploy();
}
        `}</pre>
      </div>
    </div>
  );
};
