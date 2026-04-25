import type { Metadata } from "next";
import { Poppins } from "next/font/google";
import "./globals.css";

const poppins = Poppins({
  subsets: ["latin"],
  weight: ["400", "600", "700"],
  variable: "--font-poppins",
});

export const metadata: Metadata = {
  title: "VELLTOOLS Bypass",
  description: "Bypass short links with ease",
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="en">
      <body className={`${poppins.variable} antialiased`}>
        <div className="aurora-bg" />
        <div className="evade-orb evade-orb-1" />
        <div className="evade-orb evade-orb-2" />
        {children}
      </body>
    </html>
  );
}
