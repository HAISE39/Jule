export type ModType = "Mod" | "Script";
export type ModVersion = "VIP" | "Free";
export type ModCategory = "RPG" | "FPS" | "Farm" | "Utility" | "Action";

export interface ModItem {
  id: string;
  title: string;
  image: string;
  type: ModType;
  version: ModVersion;
  category: ModCategory;
  features: string[];
  downloadUrl?: string;
  whatsappUrl?: string;
}

export const MODS_DATA: ModItem[] = [
  {
    id: "1",
    title: "Aurcus Online Mod Menu",
    image: "https://images.unsplash.com/photo-1542751371-adc38448a05e?q=80&w=2070&auto=format&fit=crop",
    type: "Mod",
    version: "VIP",
    category: "RPG",
    features: ["Open Bag anywhere", "Refresh Skill", "High Damage", "Anti-Ban", "No Skill Cooldown", "Inventory Expansion"],
    whatsappUrl: "https://wa.me/6285706400133"
  },
  {
    id: "2",
    title: "Aurcus Online Script",
    image: "https://images.unsplash.com/photo-1555680202-c86f0e12f086?q=80&w=2070&auto=format&fit=crop",
    type: "Script",
    version: "Free",
    category: "RPG",
    features: ["Auto Questing", "Basic Stats Viewer", "Simple UI", "Auto HP/MP Potion"],
    downloadUrl: "https://www.mediafire.com/file/wtvi355p17u01kv/Aurcus_Online_1.1.apk/file"
  },
  {
    id: "3",
    title: "Modern Combat FPS Mod",
    image: "https://images.unsplash.com/photo-1552820728-8b83bb6b773f?q=80&w=2070&auto=format&fit=crop",
    type: "Mod",
    version: "VIP",
    category: "FPS",
    features: ["Aimbot", "Wallhack", "No Recoil", "Unlimited Ammo", "Speed Hack", "Anti-Kick"],
    whatsappUrl: "https://wa.me/6285706400133"
  },
  {
    id: "4",
    title: "Stardew Valley Farm Script",
    image: "https://images.unsplash.com/photo-1592150621344-82d43b7da03c?q=80&w=2070&auto=format&fit=crop",
    type: "Script",
    version: "Free",
    category: "Farm",
    features: ["Instant Harvest", "Unlimited Energy", "Auto Water", "Time Freeze"],
    downloadUrl: "https://www.mediafire.com/file/wtvi355p17u01kv/Aurcus_Online_1.1.apk/file"
  },
  {
    id: "5",
    title: "Generic Android Injector",
    image: "https://images.unsplash.com/photo-1550745165-9bc0b252726f?q=80&w=2070&auto=format&fit=crop",
    type: "Mod",
    version: "VIP",
    category: "Utility",
    features: ["Universal Memory Search", "Direct Proc/Mem Access", "Lua Execution", "No Root Required"],
    whatsappUrl: "https://wa.me/6285706400133"
  },
  {
    id: "6",
    title: "Speed Booster Script",
    image: "https://images.unsplash.com/photo-1511512578047-dfb367046420?q=80&w=2071&auto=format&fit=crop",
    type: "Script",
    version: "Free",
    category: "Utility",
    features: ["Lag Fixer", "Ping Booster", "Device Optimization", "Cache Cleaner"],
    downloadUrl: "https://www.mediafire.com/file/wtvi355p17u01kv/Aurcus_Online_1.1.apk/file"
  },
  {
    id: "7",
    title: "Genshin Impact Script",
    image: "https://images.unsplash.com/photo-1511512578047-dfb367046420?q=80&w=2071&auto=format&fit=crop",
    type: "Script",
    version: "VIP",
    category: "RPG",
    features: ["Auto Farm Materials", "God Mode", "Unlimited Stamina", "Insta Kill Mob"],
    whatsappUrl: "https://wa.me/6285706400133"
  },
  {
    id: "8",
    title: "PUBG Mobile Mod Menu",
    image: "https://images.unsplash.com/photo-1593305841991-05c297ba4575?q=80&w=1957&auto=format&fit=crop",
    type: "Mod",
    version: "VIP",
    category: "FPS",
    features: ["Esp Lines", "Less Recoil", "Magic Bullet", "Headshot 90%", "Speed Car"],
    whatsappUrl: "https://wa.me/6285706400133"
  },
  {
    id: "9",
    title: "Harvest Moon Scripts",
    image: "https://images.unsplash.com/photo-1523348837708-15d4a09cfac2?q=80&w=2070&auto=format&fit=crop",
    type: "Script",
    version: "Free",
    category: "Farm",
    features: ["Max Gold", "Animal Friendship Max", "Unlimited Tool Power", "Weather Controller"],
    downloadUrl: "https://www.mediafire.com/file/wtvi355p17u01kv/Aurcus_Online_1.1.apk/file"
  },
  {
    id: "10",
    title: "Call of Duty Mobile Mod",
    image: "https://images.unsplash.com/photo-1518709268805-4e9042af9f23?q=80&w=1968&auto=format&fit=crop",
    type: "Mod",
    version: "VIP",
    category: "FPS",
    features: ["Wallhack", "Auto Aim", "No Spread", "Fast Reload"],
    whatsappUrl: "https://wa.me/6285706400133"
  },
  {
    id: "11",
    title: "Mobile Legends Script",
    image: "https://images.unsplash.com/photo-1542751110-97427bbecf20?q=80&w=2084&auto=format&fit=crop",
    type: "Script",
    version: "Free",
    category: "Action",
    features: ["Drone View", "Skin Unlocker", "Recall Animation", "Map Hack (Safe)"],
    downloadUrl: "https://www.mediafire.com/file/wtvi355p17u01kv/Aurcus_Online_1.1.apk/file"
  },
  {
    id: "12",
    title: "Grand Theft Auto Mod",
    image: "https://images.unsplash.com/photo-1581091226825-a6a2a5aee158?q=80&w=2070&auto=format&fit=crop",
    type: "Mod",
    version: "VIP",
    category: "Action",
    features: ["God Mode", "Unlimited Cash", "All Cars Unlocked", "Teleportation"],
    whatsappUrl: "https://wa.me/6285706400133"
  }
];
