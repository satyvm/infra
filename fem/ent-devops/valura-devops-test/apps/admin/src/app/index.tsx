import { CounterButton } from "@repo/ui/counter-button";
import { Link } from "@repo/ui/link";

function App() {
  return (
    <div className="min-h-screen flex flex-col items-center justify-center gap-6 max-w-full mx-auto px-4 text-center">
      <h1 className="text-5xl font-bold m-0">
        Admin <br />
        <span className="inline-block bg-gradient-to-r from-blue-500 to-red-500 bg-clip-text text-transparent">Kitchen Sink</span>
      </h1>
      <CounterButton />
      <p className="text-gray-400 font-medium">
        Built With{" "}
        <Link href="https://turborepo.com" newTab>
          Turborepo
        </Link>
        {" & "}
        <Link href="https://vitejs.dev/" newTab>
          Vite
        </Link>
      </p>
    </div>
  );
}

export default App;
