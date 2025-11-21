import "./globals.css";
import { ReactNode } from "react";

export const metadata = {
  title: "Diarlies",
  description: "AI-assisted diaries that listen, learn, and reflect."
};

export default function RootLayout({ children }: { children: ReactNode }) {
  return (
    <html lang="en">
      <body>{children}</body>
    </html>
  );
}
