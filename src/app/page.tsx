"use client";

import { useState, useMemo } from "react";
import Navbar from "@/components/Navbar";
import Hero from "@/components/Hero";
import ModCard from "@/components/ModCard";
import Footer from "@/components/Footer";
import { MODS_DATA, ModCategory } from "@/data/mods";
import { Search, Filter } from "lucide-react";

const CATEGORIES: (ModCategory | "All")[] = ["All", "RPG", "FPS", "Farm", "Action", "Utility"];

export default function Home() {
  const [searchQuery, setSearchQuery] = useState("");
  const [selectedCategory, setSelectedCategory] = useState<(ModCategory | "All")>("All");

  const filteredMods = useMemo(() => {
    return MODS_DATA.filter((mod) => {
      const matchesSearch = mod.title.toLowerCase().includes(searchQuery.toLowerCase()) ||
                            mod.features.some(f => f.toLowerCase().includes(searchQuery.toLowerCase()));
      const matchesCategory = selectedCategory === "All" || mod.category === selectedCategory;
      return matchesSearch && matchesCategory;
    });
  }, [searchQuery, selectedCategory]);

  return (
    <main className="min-h-screen">
      <Navbar />
      <Hero />

      <section id="products" className="py-12 bg-background relative">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">

          {/* Search and Filter UI */}
          <div className="mb-12 space-y-6">
            <div className="flex flex-col md:flex-row gap-4 items-center justify-between">
              <div className="relative w-full md:max-w-md">
                <Search className="absolute left-4 top-1/2 -translate-y-1/2 text-foreground/40 w-5 h-5" />
                <input
                  type="text"
                  placeholder="Search mods or features..."
                  className="w-full pl-12 pr-4 py-3 bg-card-bg border border-border-custom rounded-xl focus:outline-none focus:border-primary transition-colors text-white"
                  value={searchQuery}
                  onChange={(e) => setSearchQuery(e.target.value)}
                />
              </div>

              <div className="flex items-center gap-2 overflow-x-auto pb-2 w-full md:w-auto scrollbar-hide">
                <Filter className="text-primary w-5 h-5 flex-shrink-0 mr-2" />
                {CATEGORIES.map((cat) => (
                  <button
                    key={cat}
                    onClick={() => setSelectedCategory(cat)}
                    className={`px-4 py-2 rounded-full text-sm font-medium whitespace-nowrap transition-all ${
                      selectedCategory === cat
                        ? "bg-primary text-background"
                        : "bg-card-bg border border-border-custom text-foreground/60 hover:border-primary/50"
                    }`}
                  >
                    {cat}
                  </button>
                ))}
              </div>
            </div>
          </div>

          <div className="text-center mb-10">
            <h2 className="text-3xl font-bold mb-2">
              {selectedCategory === "All" ? "All Products" : `${selectedCategory} Collection`}
            </h2>
            <p className="text-foreground/60">
              {filteredMods.length} {filteredMods.length === 1 ? "product" : "products"} found
            </p>
          </div>

          {filteredMods.length > 0 ? (
            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
              {filteredMods.map((mod) => (
                <ModCard
                  key={mod.id}
                  {...mod}
                />
              ))}
            </div>
          ) : (
            <div className="py-20 text-center">
              <div className="inline-flex items-center justify-center w-16 h-16 rounded-full bg-primary/10 text-primary mb-4">
                <Search size={32} />
              </div>
              <h3 className="text-xl font-bold mb-2">No results found</h3>
              <p className="text-foreground/60">Try adjusting your search or filter to find what you&apos;re looking for.</p>
              <button
                onClick={() => {setSearchQuery(""); setSelectedCategory("All");}}
                className="mt-6 text-primary hover:underline"
              >
                Clear all filters
              </button>
            </div>
          )}
        </div>
      </section>

      <section className="py-20 bg-primary/5">
        <div className="max-w-4xl mx-auto px-4 text-center">
          <h2 className="text-3xl font-bold mb-6">Need a Custom Script?</h2>
          <p className="text-lg text-foreground/70 mb-8">
            Kami menerima pesanan script atau mod custom sesuai kebutuhan Anda. Hubungi developer kami untuk konsultasi lebih lanjut.
          </p>
          <a
            href="https://wa.me/6285706400133"
            target="_blank"
            className="inline-flex items-center justify-center px-10 py-4 bg-primary text-background font-bold rounded-full hover:bg-accent transition-all shadow-xl shadow-primary/20"
          >
            Hubungi WhatsApp
          </a>
        </div>
      </section>

      <Footer />
    </main>
  );
}
