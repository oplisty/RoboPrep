"use client";

import dynamic from "next/dynamic";
import { loader } from "@monaco-editor/react";

import { Skeleton } from "@/components/ui/skeleton";

// The default loader pulls Monaco from cdn.jsdelivr.net, which the site CSP
// (script-src 'self') blocks — the editor never mounted in production. Serve
// the pinned monaco-editor runtime same-origin from public/monaco instead
// (populated by scripts/copy_monaco.py).
loader.config({ paths: { vs: "/monaco/vs" } });

const MonacoEditor = dynamic(() => import("@monaco-editor/react"), {
  ssr: false,
  loading: () => <Skeleton className="h-[30rem] w-full rounded-none" />,
});

export function CodeEditor({
  value,
  onChange,
  readOnly = false,
}: {
  value: string;
  onChange?: (value: string) => void;
  readOnly?: boolean;
}) {
  return (
    <div className="bg-ink border-line overflow-hidden rounded-sm border">
      <MonacoEditor
        height="30rem"
        language="python"
        theme="vs-dark"
        value={value}
        onChange={(nextValue) => onChange?.(nextValue ?? "")}
        options={{
          automaticLayout: true,
          minimap: { enabled: false },
          fontSize: 13,
          lineNumbers: "on",
          scrollBeyondLastLine: false,
          tabSize: 4,
          insertSpaces: true,
          readOnly,
          padding: { top: 14, bottom: 14 },
        }}
      />
    </div>
  );
}
