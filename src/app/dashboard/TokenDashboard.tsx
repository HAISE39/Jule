"use client";

import { useState } from "react";
import { Plus, Trash2, Edit2, Check, X, LogOut } from "lucide-react";
import { Token } from "./actions";

export default function TokenDashboard({
  tokens,
  createAction,
  deleteAction,
  updateAction
}: {
  tokens: Token[],
  createAction: (fd: FormData) => Promise<void>,
  deleteAction: (id: string) => Promise<void>,
  updateAction: (id: string, fd: FormData) => Promise<void>
}) {
  const [editingId, setEditingId] = useState<string | null>(null);

  return (
    <div className="min-h-screen bg-[#0A0A0A] text-white p-8">
      <div className="max-w-6xl mx-auto">
        <header className="mb-12 flex justify-between items-center">
          <div>
            <h1 className="text-4xl font-bold text-[#BB86FC]">Token Management</h1>
            <p className="text-gray-400 mt-2">Manage your script access tokens</p>
          </div>
        </header>

        <section className="bg-[#1A1A1A] rounded-xl p-6 mb-12 border border-[#333]">
          <h2 className="text-xl font-semibold mb-6 flex items-center gap-2">
            <Plus size={20} className="text-[#BB86FC]" /> Create New Token
          </h2>
          <form action={createAction} className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-5 gap-4 items-end">
            <div className="space-y-2">
              <label className="text-sm text-gray-400">Token String</label>
              <input name="token" required className="w-full bg-[#2A2A2A] border border-[#333] rounded-lg p-2 focus:border-[#BB86FC] outline-none" placeholder="e.g. SCRIPT-123" />
            </div>
            <div className="space-y-2">
              <label className="text-sm text-gray-400">Type</label>
              <select name="type" className="w-full bg-[#2A2A2A] border border-[#333] rounded-lg p-2 focus:border-[#BB86FC] outline-none">
                <option value="permanent">Permanent</option>
                <option value="expired">Expired</option>
              </select>
            </div>
            <div className="space-y-2">
              <label className="text-sm text-gray-400">Expiry Date</label>
              <input type="date" name="expirationDate" className="w-full bg-[#2A2A2A] border border-[#333] rounded-lg p-2 focus:border-[#BB86FC] outline-none" />
            </div>
            <div className="space-y-2">
              <label className="text-sm text-gray-400">Max Usage</label>
              <input type="number" name="maxUsage" required min="1" defaultValue="1" className="w-full bg-[#2A2A2A] border border-[#333] rounded-lg p-2 focus:border-[#BB86FC] outline-none" />
            </div>
            <button type="submit" className="bg-[#BB86FC] text-black font-bold py-2 px-6 rounded-lg hover:bg-[#D0BCFF] transition-colors">
              Create Token
            </button>
          </form>
        </section>

        <section className="grid gap-4">
          <h2 className="text-xl font-semibold mb-2">Existing Tokens</h2>
          <div className="overflow-x-auto">
            <table className="w-full text-left border-collapse">
              <thead>
                <tr className="border-b border-[#333] text-gray-400 text-sm">
                  <th className="pb-4 px-4 font-medium">Token</th>
                  <th className="pb-4 px-4 font-medium">Type</th>
                  <th className="pb-4 px-4 font-medium">Expiry</th>
                  <th className="pb-4 px-4 font-medium">Usage</th>
                  <th className="pb-4 px-4 font-medium">Actions</th>
                </tr>
              </thead>
              <tbody>
                {tokens.map((token) => (
                  <tr key={token.id} className="border-b border-[#222] hover:bg-[#151515] transition-colors group">
                    {editingId === token.id ? (
                      <td colSpan={5} className="py-4 px-4">
                        <form
                          action={async (fd) => {
                            await updateAction(token.id, fd);
                            setEditingId(null);
                          }}
                          className="grid grid-cols-1 md:grid-cols-5 gap-4 items-end"
                        >
                          <input name="token" defaultValue={token.token} className="bg-[#2A2A2A] border border-[#333] rounded p-1 text-sm outline-none focus:border-[#BB86FC]" />
                          <select name="type" defaultValue={token.type} className="bg-[#2A2A2A] border border-[#333] rounded p-1 text-sm outline-none">
                            <option value="permanent">Permanent</option>
                            <option value="expired">Expired</option>
                          </select>
                          <input type="date" name="expirationDate" defaultValue={token.expirationDate || ""} className="bg-[#2A2A2A] border border-[#333] rounded p-1 text-sm outline-none" />
                          <div className="flex items-center gap-2">
                            <input type="number" name="currentUsage" defaultValue={token.currentUsage} className="w-16 bg-[#2A2A2A] border border-[#333] rounded p-1 text-sm outline-none" />
                            <span>/</span>
                            <input type="number" name="maxUsage" defaultValue={token.maxUsage} className="w-16 bg-[#2A2A2A] border border-[#333] rounded p-1 text-sm outline-none" />
                          </div>
                          <div className="flex gap-2">
                            <button type="submit" className="p-2 bg-green-900/30 text-green-400 rounded hover:bg-green-900/50">
                              <Check size={18} />
                            </button>
                            <button type="button" onClick={() => setEditingId(null)} className="p-2 bg-gray-800 text-gray-400 rounded hover:bg-gray-700">
                              <X size={18} />
                            </button>
                          </div>
                        </form>
                      </td>
                    ) : (
                      <>
                        <td className="py-4 px-4 font-mono text-[#BB86FC]">{token.token}</td>
                        <td className="py-4 px-4 uppercase text-xs">
                          <span className={`px-2 py-1 rounded ${token.type === 'permanent' ? 'bg-green-900/30 text-green-400' : 'bg-orange-900/30 text-orange-400'}`}>
                            {token.type}
                          </span>
                        </td>
                        <td className="py-4 px-4 text-gray-300">{token.expirationDate || 'Never'}</td>
                        <td className="py-4 px-4 text-gray-300">
                          {token.currentUsage} / {token.maxUsage}
                        </td>
                        <td className="py-4 px-4 flex gap-2">
                          <button
                            onClick={() => setEditingId(token.id)}
                            className="p-2 hover:bg-[#BB86FC]/10 text-[#BB86FC] rounded-lg transition-colors"
                          >
                            <Edit2 size={18} />
                          </button>
                          <form action={async () => {
                            if (confirm("Are you sure?")) await deleteAction(token.id);
                          }}>
                            <button className="p-2 hover:bg-red-900/20 text-red-400 rounded-lg transition-colors">
                              <Trash2 size={18} />
                            </button>
                          </form>
                        </td>
                      </>
                    )}
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </section>
      </div>
    </div>
  );
}
