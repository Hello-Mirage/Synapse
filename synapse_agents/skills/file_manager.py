"""
Synapse Skill - File Manager

Performs file system operations: read, list, delete, copy, move.
"""

from __future__ import annotations

import os
import shutil
from pathlib import Path
from typing import Any

from skills.base_skill import BaseSkill


class FileManagerSkill(BaseSkill):
    """File system operations: read, list, delete, copy, move."""

    @property
    def name(self) -> str:
        return "file_manager"

    @property
    def description(self) -> str:
        return (
            "Performs file system operations including reading files, "
            "listing directories, deleting files, copying, and moving files."
        )

    def input_schema(self) -> dict[str, Any]:
        return {
            "operation": {
                "type": "string",
                "required": True,
                "description": "Operation to perform",
                "enum": ["read", "list", "delete", "copy", "move", "exists", "mkdir"],
            },
            "path": {
                "type": "string",
                "required": True,
                "description": "Target file or directory path",
            },
            "destination": {
                "type": "string",
                "required": False,
                "description": "Destination path (for copy/move operations)",
            },
            "recursive": {
                "type": "boolean",
                "required": False,
                "default": False,
                "description": "Whether to operate recursively (for list/delete/mkdir)",
            },
            "pattern": {
                "type": "string",
                "required": False,
                "description": "Glob pattern for filtering (for list operation)",
            },
        }

    def validate_input(self, input_data: dict[str, Any]) -> tuple[bool, str]:
        if "operation" not in input_data:
            return False, "Missing required field: operation"
        if "path" not in input_data:
            return False, "Missing required field: path"

        op = input_data["operation"]
        valid_ops = {"read", "list", "delete", "copy", "move", "exists", "mkdir"}
        if op not in valid_ops:
            return False, f"Invalid operation: {op}. Must be one of {valid_ops}"

        if op in ("copy", "move") and "destination" not in input_data:
            return False, f"'destination' is required for '{op}' operation"

        return True, ""

    async def execute(self, input_data: dict[str, Any]) -> dict[str, Any]:
        op = input_data["operation"]
        path = Path(input_data["path"]).resolve()
        recursive = input_data.get("recursive", False)

        if op == "read":
            return self._read(path)
        elif op == "list":
            pattern = input_data.get("pattern", "*")
            return self._list(path, pattern, recursive)
        elif op == "delete":
            return self._delete(path, recursive)
        elif op == "copy":
            dest = Path(input_data["destination"]).resolve()
            return self._copy(path, dest)
        elif op == "move":
            dest = Path(input_data["destination"]).resolve()
            return self._move(path, dest)
        elif op == "exists":
            return self._exists(path)
        elif op == "mkdir":
            return self._mkdir(path, recursive)

        return {"error": f"Unknown operation: {op}"}

    def _read(self, path: Path) -> dict[str, Any]:
        if not path.exists():
            raise FileNotFoundError(f"File not found: {path}")
        if not path.is_file():
            raise ValueError(f"Not a file: {path}")

        content = path.read_text(encoding="utf-8")
        return {
            "content": content,
            "size_bytes": path.stat().st_size,
            "lines": len(content.splitlines()),
            "path": str(path),
        }

    def _list(self, path: Path, pattern: str, recursive: bool) -> dict[str, Any]:
        if not path.exists():
            raise FileNotFoundError(f"Directory not found: {path}")
        if not path.is_dir():
            raise ValueError(f"Not a directory: {path}")

        if recursive:
            entries = list(path.rglob(pattern))
        else:
            entries = list(path.glob(pattern))

        items = []
        for entry in entries[:500]:  # Cap at 500 entries
            items.append({
                "name": entry.name,
                "path": str(entry),
                "is_dir": entry.is_dir(),
                "size_bytes": entry.stat().st_size if entry.is_file() else None,
            })

        return {
            "path": str(path),
            "total_entries": len(entries),
            "entries": items,
        }

    def _delete(self, path: Path, recursive: bool) -> dict[str, Any]:
        if not path.exists():
            return {"deleted": False, "reason": "Path does not exist"}

        if path.is_file():
            path.unlink()
        elif path.is_dir():
            if recursive:
                shutil.rmtree(path)
            else:
                path.rmdir()  # Only works if empty

        return {"deleted": True, "path": str(path)}

    def _copy(self, src: Path, dest: Path) -> dict[str, Any]:
        if not src.exists():
            raise FileNotFoundError(f"Source not found: {src}")

        dest.parent.mkdir(parents=True, exist_ok=True)
        if src.is_file():
            shutil.copy2(src, dest)
        else:
            shutil.copytree(src, dest, dirs_exist_ok=True)

        return {"copied": True, "source": str(src), "destination": str(dest)}

    def _move(self, src: Path, dest: Path) -> dict[str, Any]:
        if not src.exists():
            raise FileNotFoundError(f"Source not found: {src}")

        dest.parent.mkdir(parents=True, exist_ok=True)
        shutil.move(str(src), str(dest))
        return {"moved": True, "source": str(src), "destination": str(dest)}

    def _exists(self, path: Path) -> dict[str, Any]:
        return {
            "exists": path.exists(),
            "is_file": path.is_file() if path.exists() else False,
            "is_dir": path.is_dir() if path.exists() else False,
            "path": str(path),
        }

    def _mkdir(self, path: Path, recursive: bool) -> dict[str, Any]:
        if recursive:
            path.mkdir(parents=True, exist_ok=True)
        else:
            path.mkdir(exist_ok=True)
        return {"created": True, "path": str(path)}

    def get_examples(self) -> list[dict[str, Any]]:
        return [
            {
                "description": "Read a file",
                "input": {"operation": "read", "path": "main.py"},
            },
            {
                "description": "List all Python files recursively",
                "input": {"operation": "list", "path": ".", "pattern": "*.py", "recursive": True},
            },
        ]
