"use client";

import { useState } from "react";
import { Layout } from "@/components/Layout";
import { HomeTab } from "@/components/tabs/Home";
import { SkillTab } from "@/components/tabs/Skill";
import { ProdukTab } from "@/components/tabs/Produk";
import { OtherLinksTab } from "@/components/tabs/OtherLinks";
import { ContactTab } from "@/components/tabs/Contact";
import { AnimatePresence, motion } from "framer-motion";

export default function Page() {
  const [activeTab, setActiveTab] = useState("home");

  const renderTab = () => {
    switch (activeTab) {
      case "home":
        return <HomeTab />;
      case "skill":
        return <SkillTab />;
      case "produk":
        return <ProdukTab />;
      case "other":
        return <OtherLinksTab />;
      case "contact":
        return <ContactTab />;
      default:
        return <HomeTab />;
    }
  };

  return (
    <Layout activeTab={activeTab} setActiveTab={setActiveTab}>
      <AnimatePresence mode="wait">
        <motion.div
          key={activeTab}
          initial={{ opacity: 0, y: 10, scale: 0.98 }}
          animate={{ opacity: 1, y: 0, scale: 1 }}
          exit={{ opacity: 0, y: -10, scale: 0.98 }}
          transition={{ duration: 0.4, ease: "easeInOut" }}
          className="w-full"
        >
          {renderTab()}
        </motion.div>
      </AnimatePresence>
    </Layout>
  );
}
