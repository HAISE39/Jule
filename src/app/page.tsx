"use client";

import { useChat } from "@ai-sdk/react";
import {
  Send,
  Bot,
  User,
  Paperclip,
  Smile,
  MoreHorizontal,
  RefreshCw,
  Copy,
  ThumbsUp
} from "lucide-react";
import { motion } from "framer-motion";
import { useEffect, useRef } from "react";
import { cn } from "@/lib/utils";

export default function ChatPage() {
  const { messages, input, handleInputChange, handleSubmit, isLoading } = useChat();
  const messagesEndRef = useRef<HTMLDivElement>(null);

  const scrollToBottom = () => {
    messagesEndRef.current?.scrollIntoView({ behavior: "smooth" });
  };

  useEffect(() => {
    scrollToBottom();

    // Save to local history when a new message from assistant arrives
    if (messages.length > 0 && !isLoading) {
      const lastMessage = messages[messages.length - 1];
      if (lastMessage.role === 'assistant') {
        const firstUserMessage = messages.find(m => m.role === 'user');
        if (firstUserMessage) {
          const history = JSON.parse(localStorage.getItem('vt_chat_history') || '[]');
          const currentChatId = messages[0].id;

          const existingChatIndex = history.findIndex((c: {id: string, title: string}) => c.id === currentChatId);
          const chatTitle = firstUserMessage.content.slice(0, 30) + (firstUserMessage.content.length > 30 ? '...' : '');

          if (existingChatIndex === -1) {
            history.unshift({ id: currentChatId, title: chatTitle });
            if (history.length > 10) history.pop();
          }

          localStorage.setItem('vt_chat_history', JSON.stringify(history));
          window.dispatchEvent(new Event('vt_history_updated'));
        }
      }
    }
  }, [messages, isLoading]);

  return (
    <div className="flex flex-col h-full max-w-5xl mx-auto w-full px-4 sm:px-6">
      {/* Header Area */}
      <header className="py-4 flex items-center justify-between border-b border-white/5">
        <div className="flex items-center gap-3">
          <div className="w-10 h-10 rounded-full bg-primary/10 border border-primary/20 flex items-center justify-center">
            <Bot size={20} className="text-primary" />
          </div>
          <div>
            <div className="flex items-center gap-2">
              <h1 className="text-sm font-bold text-white uppercase tracking-wider">VELLTOOLS AI</h1>
              <span className="flex h-2 w-2 rounded-full bg-emerald-500 animate-pulse" />
            </div>
            <p className="text-[11px] text-white/40 font-medium">Powered by GLM-5 Cloud</p>
          </div>
        </div>
        <div className="flex items-center gap-2">
          <button className="p-2 rounded-lg hover:bg-white/5 text-white/50 hover:text-white transition-all">
            <RefreshCw size={18} />
          </button>
          <button className="p-2 rounded-lg hover:bg-white/5 text-white/50 hover:text-white transition-all">
            <MoreHorizontal size={18} />
          </button>
        </div>
      </header>

      {/* Messages Area */}
      <div className="flex-1 overflow-y-auto py-8 space-y-8 no-scrollbar">
        {messages.length === 0 ? (
          <div className="h-full flex flex-col items-center justify-center text-center space-y-6">
            <div className="w-16 h-16 rounded-3xl bg-primary/5 border border-primary/10 flex items-center justify-center mb-2">
              <Bot size={32} className="text-primary" />
            </div>
            <div className="space-y-2">
              <h2 className="text-2xl font-bold text-white tracking-tight">How can I help you today?</h2>
              <p className="text-white/40 max-w-sm mx-auto text-sm leading-relaxed">
                VELLTOOLS is your professional AI assistant. I can help with coding, writing, research, and more.
              </p>
            </div>
            <div className="grid grid-cols-1 sm:grid-cols-2 gap-3 w-full max-w-2xl mt-8">
              {[
                "Write a Python script for web scraping",
                "Explain quantum computing in simple terms",
                "Draft a professional email for a project proposal",
                "Help me brainstorm names for my new startup"
              ].map((suggestion, i) => (
                <button
                  key={i}
                  onClick={() => handleInputChange({ target: { value: suggestion } } as React.ChangeEvent<HTMLInputElement>)}
                  className="p-4 rounded-xl bg-white/5 border border-white/5 text-left text-xs font-medium text-white/70 hover:bg-white/10 hover:border-primary/30 hover:text-white transition-all group"
                >
                  {suggestion}
                </button>
              ))}
            </div>
          </div>
        ) : (
          <div className="space-y-8">
            {messages.map((message) => (
              <motion.div
                key={message.id}
                initial={{ opacity: 0, y: 10 }}
                animate={{ opacity: 1, y: 0 }}
                transition={{ duration: 0.3, delay: 0.1 }}
                className={cn(
                  "flex gap-4 md:gap-6",
                  message.role === "user" ? "flex-row-reverse" : "flex-row"
                )}
              >
                <div className={cn(
                  "w-8 h-8 rounded-lg shrink-0 flex items-center justify-center border",
                  message.role === "user"
                    ? "bg-[#1A1A1A] border-white/10"
                    : "bg-primary/10 border-primary/20"
                )}>
                  {message.role === "user" ? (
                    <User size={16} className="text-white/70" />
                  ) : (
                    <Bot size={16} className="text-primary" />
                  )}
                </div>

                <div className={cn(
                  "flex flex-col gap-2 max-w-[85%]",
                  message.role === "user" ? "items-end" : "items-start"
                )}>
                  <div className={cn(
                    "px-4 py-3 rounded-2xl text-sm leading-relaxed",
                    message.role === "user"
                      ? "bg-primary text-black font-medium"
                      : "bg-[#161616] border border-white/5 text-white/90"
                  )}>
                    {message.content}
                  </div>

                  {message.role === "assistant" && (
                    <div className="flex items-center gap-2 pl-1">
                      <button className="p-1 rounded hover:bg-white/5 text-white/30 hover:text-white transition-all">
                        <Copy size={12} />
                      </button>
                      <button className="p-1 rounded hover:bg-white/5 text-white/30 hover:text-white transition-all">
                        <ThumbsUp size={12} />
                      </button>
                    </div>
                  )}
                </div>
              </motion.div>
            ))}
            {isLoading && (
              <motion.div
                initial={{ opacity: 0 }}
                animate={{ opacity: 1 }}
                className="flex gap-4 md:gap-6"
              >
                <div className="w-8 h-8 rounded-lg bg-primary/10 border border-primary/20 flex items-center justify-center">
                  <Bot size={16} className="text-primary" />
                </div>
                <div className="flex items-center gap-1.5 px-4 py-3 rounded-2xl bg-[#161616] border border-white/5">
                  <span className="w-1.5 h-1.5 bg-primary/50 rounded-full animate-bounce [animation-delay:-0.3s]" />
                  <span className="w-1.5 h-1.5 bg-primary/50 rounded-full animate-bounce [animation-delay:-0.15s]" />
                  <span className="w-1.5 h-1.5 bg-primary/50 rounded-full animate-bounce" />
                </div>
              </motion.div>
            )}
            <div ref={messagesEndRef} />
          </div>
        )}
      </div>

      {/* Input Area */}
      <footer className="pb-8 pt-4">
        <form
          onSubmit={handleSubmit}
          className="relative max-w-4xl mx-auto"
        >
          <div className="relative flex items-center bg-[#1A1A1A] border border-white/10 rounded-2xl overflow-hidden focus-within:border-primary/50 transition-all shadow-2xl">
            <button type="button" className="p-4 text-white/30 hover:text-primary transition-colors">
              <Paperclip size={20} />
            </button>
            <input
              value={input}
              onChange={handleInputChange}
              placeholder="Ask VELLTOOLS anything..."
              className="flex-1 bg-transparent border-none focus:ring-0 py-4 text-sm text-white placeholder:text-white/20"
            />
            <div className="flex items-center gap-2 pr-3">
              <button type="button" className="hidden sm:block p-2 text-white/30 hover:text-white transition-colors">
                <Smile size={20} />
              </button>
              <button
                type="submit"
                disabled={!input.trim() || isLoading}
                className={cn(
                  "p-2.5 rounded-xl transition-all",
                  input.trim() && !isLoading
                    ? "bg-primary text-black hover:scale-105 active:scale-95 shadow-[0_0_15px_rgba(187,134,252,0.3)]"
                    : "bg-white/5 text-white/20 grayscale pointer-events-none"
                )}
              >
                <Send size={18} />
              </button>
            </div>
          </div>
          <p className="mt-3 text-center text-[10px] text-white/20 font-medium uppercase tracking-[0.2em]">
            VELLTOOLS AI can make mistakes. Check important info.
          </p>
        </form>
      </footer>
    </div>
  );
}
