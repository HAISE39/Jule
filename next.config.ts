import type { NextConfig } from "next";

const nextConfig: NextConfig = {
  images: {
    remotePatterns: [
      { hostname: "images.unsplash.com" },
      { hostname: "media.giphy.com" },
      { hostname: "media.tenor.com" },
    ],
  },
};

export default nextConfig;
