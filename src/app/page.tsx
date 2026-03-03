'use client';

import { useState, useEffect } from 'react';
import { motion, AnimatePresence } from 'framer-motion';
import { Plus, Trash2, Database, Code } from 'lucide-react';

interface ValueItem {
  id: string;
  name: string;
  value: string;
}

export default function Dashboard() {
  const [items, setItems] = useState<ValueItem[]>([]);
  const [name, setName] = useState('');
  const [value, setValue] = useState('');
  const [isLoading, setIsLoading] = useState(true);

  useEffect(() => {
    fetchItems();
  }, []);

  const fetchItems = async () => {
    setIsLoading(true);
    try {
      const res = await fetch('/api/values', {
        headers: { 'x-api-key': 'vtools-secret-key' }
      });
      const data = await res.json();
      setItems(data);
    } catch (err) {
      console.error(err);
    } finally {
      setIsLoading(false);
    }
  };

  const addItem = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!name || !value) return;

    try {
      const res = await fetch('/api/values', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'x-api-key': 'vtools-secret-key'
        },
        body: JSON.stringify({ name, value }),
      });
      if (res.ok) {
        setName('');
        setValue('');
        fetchItems();
      }
    } catch (err) {
      console.error(err);
    }
  };

  const deleteItem = async (id: string) => {
    try {
      const res = await fetch('/api/values', {
        method: 'DELETE',
        headers: {
          'Content-Type': 'application/json',
          'x-api-key': 'vtools-secret-key'
        },
        body: JSON.stringify({ id }),
      });
      if (res.ok) {
        fetchItems();
      }
    } catch (err) {
      console.error(err);
    }
  };

  return (
    <div className="min-h-screen bg-[#0A0A0A] text-white p-6 font-sans">
      <div className="max-w-4xl mx-auto space-y-8">
        {/* Header */}
        <header className="flex items-center justify-between">
          <motion.div
            initial={{ opacity: 0, x: -20 }}
            animate={{ opacity: 1, x: 0 }}
            className="flex items-center space-x-3"
          >
            <div className="w-12 h-12 bg-[#BB86FC] rounded-xl flex items-center justify-center shadow-[0_0_20px_rgba(187,134,252,0.3)]">
              <Database className="text-[#0A0A0A] w-6 h-6" />
            </div>
            <div>
              <h1 className="text-2xl font-bold tracking-tight">VellTools Dashboard</h1>
              <p className="text-gray-400 text-sm">Manage GameGuardian Values</p>
            </div>
          </motion.div>

          <motion.div
            initial={{ opacity: 0, scale: 0.9 }}
            animate={{ opacity: 1, scale: 1 }}
            className="hidden md:flex items-center space-x-2 bg-[#1A1A1A] px-4 py-2 rounded-lg border border-[#333]"
          >
            <div className="w-2 h-2 rounded-full bg-green-500 animate-pulse" />
            <span className="text-xs font-mono text-gray-400">API ACTIVE</span>
          </motion.div>
        </header>

        {/* Input Form */}
        <motion.section
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.1 }}
          className="bg-[#111111] border border-[#222] p-6 rounded-2xl shadow-xl"
        >
          <form onSubmit={addItem} className="grid grid-cols-1 md:grid-cols-3 gap-4">
            <div className="space-y-2">
              <label className="text-xs uppercase tracking-wider text-gray-500 font-semibold ml-1">Label Name</label>
              <input
                type="text"
                value={name}
                onChange={(e) => setName(e.target.value)}
                placeholder="e.g. AOT, Money, Exp"
                className="w-full bg-[#0A0A0A] border border-[#333] rounded-xl px-4 py-3 focus:outline-none focus:border-[#BB86FC] transition-colors"
              />
            </div>
            <div className="space-y-2">
              <label className="text-xs uppercase tracking-wider text-gray-500 font-semibold ml-1">Value / Address</label>
              <input
                type="text"
                value={value}
                onChange={(e) => setValue(e.target.value)}
                placeholder="e.g. 10404, 0x12345"
                className="w-full bg-[#0A0A0A] border border-[#333] rounded-xl px-4 py-3 focus:outline-none focus:border-[#BB86FC] transition-colors"
              />
            </div>
            <div className="flex items-end">
              <button
                type="submit"
                className="w-full bg-[#BB86FC] hover:bg-[#D0BCFF] text-[#0A0A0A] font-bold py-3 rounded-xl flex items-center justify-center space-x-2 transition-all transform hover:scale-[1.02] active:scale-[0.98]"
              >
                <Plus className="w-5 h-5" />
                <span>Add New Entry</span>
              </button>
            </div>
          </form>
        </motion.section>

        {/* List Table */}
        <section className="space-y-4">
          <div className="flex items-center justify-between px-2">
            <h2 className="text-lg font-semibold flex items-center space-x-2">
              <Code className="w-5 h-5 text-[#BB86FC]" />
              <span>Current Configs</span>
            </h2>
            <span className="text-xs text-gray-500">{items.length} items total</span>
          </div>

          <div className="bg-[#111111] border border-[#222] rounded-2xl overflow-hidden">
            {isLoading ? (
              <div className="p-12 text-center text-gray-500">
                <div className="animate-spin w-8 h-8 border-2 border-[#BB86FC] border-t-transparent rounded-full mx-auto mb-4" />
                Loading items...
              </div>
            ) : items.length === 0 ? (
              <div className="p-12 text-center text-gray-500">
                No configurations added yet.
              </div>
            ) : (
              <div className="divide-y divide-[#222]">
                <AnimatePresence mode="popLayout">
                  {items.map((item) => (
                    <motion.div
                      key={item.id}
                      initial={{ opacity: 0 }}
                      animate={{ opacity: 1 }}
                      exit={{ opacity: 0, x: -20 }}
                      className="p-4 flex items-center justify-between hover:bg-[#161616] transition-colors group"
                    >
                      <div className="flex items-center space-x-4">
                        <div className="w-10 h-10 bg-[#1A1A1A] rounded-lg flex items-center justify-center text-[#BB86FC] group-hover:bg-[#BB86FC]/10 transition-colors">
                          {item.name.charAt(0).toUpperCase()}
                        </div>
                        <div>
                          <p className="font-semibold text-gray-100">{item.name}</p>
                          <p className="text-xs font-mono text-gray-500">{item.value}</p>
                        </div>
                      </div>
                      <button
                        onClick={() => deleteItem(item.id)}
                        className="p-2 text-gray-600 hover:text-red-400 hover:bg-red-400/10 rounded-lg transition-all"
                      >
                        <Trash2 className="w-5 h-5" />
                      </button>
                    </motion.div>
                  ))}
                </AnimatePresence>
              </div>
            )}
          </div>
        </section>

        {/* Footer info */}
        <footer className="pt-8 border-t border-[#222] flex flex-col md:flex-row justify-between items-center text-gray-500 text-xs gap-4">
          <div className="flex items-center space-x-4">
            <span className="hover:text-white transition-colors cursor-pointer">API Documentation</span>
            <span className="hover:text-white transition-colors cursor-pointer">Script Template</span>
          </div>
          <p>© 2024 VellTools Modding. Powered by Next.js & GG.</p>
        </footer>
      </div>
    </div>
  );
}
