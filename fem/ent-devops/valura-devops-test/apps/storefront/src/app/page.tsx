import { log } from "@repo/logger";
import { Link } from "@repo/ui/link";
import { CounterButton } from "@repo/ui/counter-button";
import { Button } from "@repo/ui/button";

export const metadata = {
  title: "Store | Kitchen Sink",
};

export default function Store() {
  log("Hey! This is the Store page.");

  return (
    <div className="min-h-screen flex flex-col items-center justify-center gap-6 max-w-full mx-auto px-4 text-center">
      <h1 className="text-5xl font-bold m-0">
        Store <br />
        <span className="inline-block bg-gradient-to-r from-blue-500 to-red-500 bg-clip-text text-transparent">Kitchen Sink</span>
      </h1>
      <CounterButton />
      <p className="description">
        Built With{" "}
        <Link href="https://turborepo.com" newTab>
          Turborepo
        </Link>
        {" & "}
        <Link href="https://nextjs.org/" newTab>
          Next.js
        </Link>
      </p>
    </div>
  );
}
