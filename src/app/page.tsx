import Navbar from "@/components/Navbar";
import Hero from "@/components/Hero";
import ModCard from "@/components/ModCard";
import Footer from "@/components/Footer";

const DUMMY_MODS = [
  {
    title: "Aurcus Online Mod Menu",
    image: "https://images.unsplash.com/photo-1542751371-adc38448a05e?q=80&w=2070&auto=format&fit=crop",
    type: "Mod" as const,
    version: "VIP" as const,
    features: [
      "Open Bag anywhere",
      "Refresh Skill (No Cooldown)",
      "High Damage Multiplier",
      "Anti-Ban Protection"
    ],
    whatsappUrl: "https://wa.me/6285706400133"
  },
  {
    title: "Aurcus Online Script",
    image: "https://images.unsplash.com/photo-1614027164847-1b2809eb7b9c?q=80&w=1964&auto=format&fit=crop",
    type: "Script" as const,
    version: "Free" as const,
    features: [
      "Auto Questing",
      "Basic Stats Viewer",
      "Simple UI",
      "Safe to use"
    ],
    downloadUrl: "https://www.mediafire.com/file/wtvi355p17u01kv/Aurcus_Online_1.1.apk/file"
  },
  {
    title: "Generic Android Injector",
    image: "https://images.unsplash.com/photo-1550745165-9bc0b252726f?q=80&w=2070&auto=format&fit=crop",
    type: "Mod" as const,
    version: "VIP" as const,
    features: [
      "Universal Memory Search",
      "Direct Proc/Mem Access",
      "Floating Menu UI",
      "Lua Script Execution"
    ],
    whatsappUrl: "https://wa.me/6285706400133"
  },
  {
    title: "Mobile Game Utility",
    image: "https://images.unsplash.com/photo-1511512578047-dfb367046420?q=80&w=2071&auto=format&fit=crop",
    type: "Script" as const,
    version: "Free" as const,
    features: [
      "Device Info Tracker",
      "Lag Fixer",
      "Ping Booster",
      "Ad Blocker"
    ],
    downloadUrl: "https://www.mediafire.com/file/wtvi355p17u01kv/Aurcus_Online_1.1.apk/file"
  }
];

export default function Home() {
  return (
    <main className="min-h-screen">
      <Navbar />
      <Hero />

      <section id="products" className="py-24 bg-background relative">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="text-center mb-16">
            <h2 className="text-3xl md:text-4xl font-bold mb-4">Our Premium <span className="text-primary">Collection</span></h2>
            <p className="text-foreground/60">Choose from our selection of high-quality mods and scripts.</p>
          </div>

          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
            {DUMMY_MODS.map((mod, index) => (
              <ModCard
                key={index}
                {...mod}
              />
            ))}
          </div>
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
