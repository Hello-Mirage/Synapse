"""
Synapse Skill - Shell Executor

Executes shell commands in a subprocess with timeout and output capture.
"""

from __future__ import annotations

import asyncio
import os
import platform
from typing import Any

from skills.base_skill import BaseSkill


class ShellExecutorSkill(BaseSkill):
    """Execute shell commands with output capture and timeout."""

    # Commands that are never allowed for safety
    BLOCKED_COMMANDS = {
        "rm -rf /", "del /s /q C:\\", "format",
        "mkfs", "dd if=/dev/zero", ":(){ :|:& };:",
    }

    @property
    def name(self) -> str:
        return "shell_executor"

    @property
    def description(self) -> str:
        return (
            "Executes shell commands in a subprocess. "
            "Captures stdout, stderr, and exit code. "
            "Supports timeouts and working directory configuration."
        )

    def input_schema(self) -> dict[str, Any]:
        return {
            "command": {
                "type": "string",
                "required": True,
                "description": "The shell command to execute",
            },
            "working_directory": {
                "type": "string",
                "required": False,
                "description": "Working directory for the command (defaults to cwd)",
            },
            "timeout_seconds": {
                "type": "integer",
                "required": False,
                "default": 60,
                "description": "Maximum execution time in seconds",
            },
            "environment": {
                "type": "object",
                "required": False,
                "description": "Additional environment variables",
            },
        }

    def validate_input(self, input_data: dict[str, Any]) -> tuple[bool, str]:
        if "command" not in input_data:
            return False, "Missing required field: command"

        command = input_data["command"].strip()
        if not command:
            return False, "Command cannot be empty"

        # Safety check
        for blocked in self.BLOCKED_COMMANDS:
            if blocked in command.lower():
                return False, f"Blocked dangerous command pattern: {blocked}"

        return True, ""

    async def execute(self, input_data: dict[str, Any]) -> dict[str, Any]:
        command = input_data["command"]
        cwd = input_data.get("working_directory", os.getcwd())
        timeout = input_data.get("timeout_seconds", 60)
        extra_env = input_data.get("environment", {})

        # Build environment
        env = os.environ.copy()
        env.update(extra_env)

        # Determine shell
        is_windows = platform.system() == "Windows"

        try:
            if is_windows:
                proc = await asyncio.create_subprocess_shell(
                    command,
                    stdout=asyncio.subprocess.PIPE,
                    stderr=asyncio.subprocess.PIPE,
                    cwd=cwd,
                    env=env,
                )
            else:
                proc = await asyncio.create_subprocess_exec(
                    "/bin/bash", "-c", command,
                    stdout=asyncio.subprocess.PIPE,
                    stderr=asyncio.subprocess.PIPE,
                    cwd=cwd,
                    env=env,
                )

            stdout, stderr = await asyncio.wait_for(
                proc.communicate(), timeout=timeout
            )

            stdout_text = stdout.decode("utf-8", errors="replace").strip()
            stderr_text = stderr.decode("utf-8", errors="replace").strip()

            # Truncate very long output
            max_output = 50_000
            truncated = False
            if len(stdout_text) > max_output:
                stdout_text = stdout_text[:max_output] + "\n... [truncated]"
                truncated = True

            return {
                "exit_code": proc.returncode,
                "stdout": stdout_text,
                "stderr": stderr_text,
                "success": proc.returncode == 0,
                "truncated": truncated,
                "command": command,
            }

        except asyncio.TimeoutError:
            proc.kill()
            return {
                "exit_code": -1,
                "stdout": "",
                "stderr": f"Command timed out after {timeout} seconds",
                "success": False,
                "truncated": False,
                "command": command,
            }

    def get_examples(self) -> list[dict[str, Any]]:
        return [
            {
                "description": "List files in current directory",
                "input": {"command": "ls -la", "timeout_seconds": 10},
            },
            {
                "description": "Run a Python script",
                "input": {
                    "command": "python main.py",
                    "working_directory": "/path/to/project",
                },
            },
        ]
