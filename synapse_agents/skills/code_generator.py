"""
Synapse Skill - Code Generator

Generates, edits, or analyzes code files.
Writes generated code to disk and returns the file path + content.
"""

from __future__ import annotations

import os
from pathlib import Path
from typing import Any

from skills.base_skill import BaseSkill


class CodeGeneratorSkill(BaseSkill):
    """Generate or edit code files on disk."""

    @property
    def name(self) -> str:
        return "code_generator"

    @property
    def description(self) -> str:
        return (
            "Generates code files based on specifications. "
            "Can create new files, append to existing files, or replace content. "
            "Supports any programming language."
        )

    def input_schema(self) -> dict[str, Any]:
        return {
            "file_path": {
                "type": "string",
                "required": True,
                "description": "Absolute or relative path for the output file",
            },
            "code": {
                "type": "string",
                "required": True,
                "description": "The code content to write",
            },
            "mode": {
                "type": "string",
                "required": False,
                "default": "write",
                "description": "Write mode: 'write' (overwrite), 'append', or 'insert'",
                "enum": ["write", "append", "insert"],
            },
            "insert_line": {
                "type": "integer",
                "required": False,
                "description": "Line number for insert mode (0-indexed)",
            },
            "language": {
                "type": "string",
                "required": False,
                "description": "Programming language hint (for logging/metadata)",
            },
        }

    def validate_input(self, input_data: dict[str, Any]) -> tuple[bool, str]:
        if "file_path" not in input_data:
            return False, "Missing required field: file_path"
        if "code" not in input_data:
            return False, "Missing required field: code"

        mode = input_data.get("mode", "write")
        if mode not in ("write", "append", "insert"):
            return False, f"Invalid mode: {mode}. Must be 'write', 'append', or 'insert'"

        if mode == "insert" and "insert_line" not in input_data:
            return False, "insert_line is required when mode is 'insert'"

        return True, ""

    async def execute(self, input_data: dict[str, Any]) -> dict[str, Any]:
        file_path = Path(input_data["file_path"]).resolve()
        code = input_data["code"]
        mode = input_data.get("mode", "write")
        language = input_data.get("language", self._detect_language(file_path))

        # Ensure parent directory exists
        file_path.parent.mkdir(parents=True, exist_ok=True)

        if mode == "write":
            file_path.write_text(code, encoding="utf-8")
            action = "created" if not file_path.exists() else "overwritten"

        elif mode == "append":
            with open(file_path, "a", encoding="utf-8") as f:
                f.write(code)
            action = "appended"

        elif mode == "insert":
            insert_line = input_data["insert_line"]
            if file_path.exists():
                lines = file_path.read_text(encoding="utf-8").splitlines(keepends=True)
            else:
                lines = []
            code_lines = code.splitlines(keepends=True)
            # Ensure the last line has a newline
            if code_lines and not code_lines[-1].endswith("\n"):
                code_lines[-1] += "\n"
            lines[insert_line:insert_line] = code_lines
            file_path.write_text("".join(lines), encoding="utf-8")
            action = "inserted"

        return {
            "file_path": str(file_path),
            "action": action,
            "language": language,
            "lines_written": len(code.splitlines()),
            "bytes_written": len(code.encode("utf-8")),
        }

    def get_examples(self) -> list[dict[str, Any]]:
        return [
            {
                "description": "Create a Python hello world",
                "input": {
                    "file_path": "hello.py",
                    "code": 'print("Hello, Synapse!")\n',
                    "mode": "write",
                    "language": "python",
                },
            },
            {
                "description": "Append a function to an existing file",
                "input": {
                    "file_path": "utils.py",
                    "code": '\ndef add(a, b):\n    return a + b\n',
                    "mode": "append",
                },
            },
        ]

    @staticmethod
    def _detect_language(file_path: Path) -> str:
        """Best-effort language detection from file extension."""
        ext_map = {
            ".py": "python", ".js": "javascript", ".ts": "typescript",
            ".dart": "dart", ".go": "go", ".rs": "rust", ".java": "java",
            ".cpp": "cpp", ".c": "c", ".rb": "ruby", ".php": "php",
            ".html": "html", ".css": "css", ".sql": "sql", ".sh": "bash",
            ".yaml": "yaml", ".yml": "yaml", ".json": "json", ".md": "markdown",
        }
        return ext_map.get(file_path.suffix.lower(), "unknown")
