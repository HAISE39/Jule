import { getTokens, createToken, deleteToken, updateToken } from "./actions";
import TokenDashboard from "./TokenDashboard";
import { cookies } from "next/headers";
import { redirect } from "next/navigation";

export default async function DashboardPage() {
  const cookieStore = await cookies();
  const auth = cookieStore.get("dashboard_auth");
  const PASSWORD = process.env.DASHBOARD_PASSWORD || "admin123";

  if (!auth || auth.value !== PASSWORD) {
    return (
      <div className="min-h-screen bg-[#0A0A0A] text-white flex items-center justify-center p-4">
        <form action={async (fd) => {
          'use server';
          const pw = fd.get("password");
          if (pw === (process.env.DASHBOARD_PASSWORD || "admin123")) {
            const cookieStore = await cookies();
            cookieStore.set("dashboard_auth", pw as string, { httpOnly: true, secure: process.env.NODE_ENV === "production" });
          }
          redirect("/dashboard");
        }} className="bg-[#1A1A1A] p-8 rounded-xl border border-[#333] w-full max-w-md">
          <h1 className="text-2xl font-bold mb-6 text-[#BB86FC]">Dashboard Login</h1>
          <input
            type="password"
            name="password"
            placeholder="Enter Password"
            className="w-full bg-[#2A2A2A] border border-[#333] rounded-lg p-3 mb-4 outline-none focus:border-[#BB86FC]"
          />
          <button className="w-full bg-[#BB86FC] text-black font-bold py-3 rounded-lg hover:bg-[#D0BCFF]">
            Login
          </button>
        </form>
      </div>
    );
  }

  const tokens = await getTokens();

  return (
    <TokenDashboard
      tokens={tokens}
      createAction={createToken}
      deleteAction={deleteToken}
      updateAction={updateToken}
    />
  );
}
