import { regexObjects } from "@/lib/bypass-config";
import { motion } from "framer-motion";

export function SupportedSites() {
  // Sort and remove duplicates based on name
  const sites = Array.from(new Set(regexObjects.map(s => s.name)))
    .sort()
    .map(name => regexObjects.find(s => s.name === name)!);

  return (
    <section className="py-16 px-4 max-w-6xl mx-auto">
      <div className="text-center mb-12">
        <h2 className="text-3xl font-bold text-foreground mb-4">Supported Sites</h2>
        <p className="text-foreground/60">We support a wide range of shortlink providers.</p>
      </div>
      <div className="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-4">
        {sites.map((site, index) => (
          <motion.div
            key={site.name}
            initial={{ opacity: 0, y: 20 }}
            whileInView={{ opacity: 1, y: 0 }}
            viewport={{ once: true }}
            transition={{ delay: index * 0.05 }}
            className="bg-card border border-border p-4 rounded-xl hover:border-primary/50 transition-colors group cursor-default"
          >
            <span className="text-foreground/80 group-hover:text-primary transition-colors capitalize">
              {site.name.replace("_", " ")}
            </span>
          </motion.div>
        ))}
      </div>
    </section>
  );
}
