"use client";

import Link from "next/link";
import { motion } from "framer-motion";

export default function Navbar() {
  return (
    <nav className="fixed top-0 w-full z-50 border-b border-border-custom bg-background/80 backdrop-blur-md">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="flex items-center justify-between h-16">
          <div className="flex items-center">
            <Link href="/" className="flex items-center space-x-2">
              <motion.div
                initial={{ rotate: -10 }}
                animate={{ rotate: 0 }}
                className="w-8 h-8 bg-primary rounded-lg flex items-center justify-center font-bold text-background"
              >
                V
              </motion.div>
              <span className="text-xl font-bold tracking-wider text-primary">VELLIXAO</span>
            </Link>
          </div>
          <div className="hidden md:block">
            <div className="ml-10 flex items-baseline space-x-8">
              <Link href="#" className="hover:text-primary transition-colors px-3 py-2 rounded-md text-sm font-medium">Home</Link>
              <Link href="#products" className="hover:text-primary transition-colors px-3 py-2 rounded-md text-sm font-medium">Products</Link>
              <Link href="https://wa.me/6285706400133" target="_blank" className="hover:text-primary transition-colors px-3 py-2 rounded-md text-sm font-medium">Contact</Link>
            </div>
          </div>
          <div className="md:hidden">
             {/* Mobile menu button could go here if needed */}
          </div>
        </div>
      </div>
    </nav>
  );
}
