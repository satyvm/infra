"use client";

import { useState } from "react";

export function CounterButton() {
  const [count, setCount] = useState(0);

  return (
    <div className="bg-black/5 rounded-lg p-6 font-medium">
      <p className="mb-6">
        This component is from{" "}
        <code className="px-1 py-0.5 bg-black/10 rounded">
          ui
        </code>
      </p>
      <div>
        <button
          onClick={() => {
            setCount((c) => c + 1);
          }}
          className="bg-black text-white border-none py-2 px-4 rounded inline-block cursor-pointer hover:bg-gray-800 transition-colors"
          type="button"
        >
          Count: {count}
        </button>
      </div>
    </div>
  );
}
