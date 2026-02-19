export default function Footer() {
  return (
    <footer className="border-t border-border-custom bg-background/50 py-12">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="flex flex-col md:flex-row justify-between items-center gap-6">
          <div className="flex items-center space-x-2">
            <div className="w-8 h-8 bg-primary rounded-lg flex items-center justify-center font-bold text-background">
              V
            </div>
            <span className="text-xl font-bold tracking-wider text-primary">VELLIXAO</span>
          </div>

          <div className="text-foreground/40 text-sm">
            © {new Date().getFullYear()} VELLIXAO. All rights reserved. Professional Modding Solutions.
          </div>

          <div className="flex space-x-6">
            <a href="https://wa.me/6285706400133" className="text-foreground/60 hover:text-primary transition-colors">WhatsApp</a>
            <a href="#" className="text-foreground/60 hover:text-primary transition-colors">Telegram</a>
            <a href="#" className="text-foreground/60 hover:text-primary transition-colors">Discord</a>
          </div>
        </div>
      </div>
    </footer>
  );
}
