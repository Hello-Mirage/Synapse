"""
Synapse Agent Service - Base Skill

Abstract base class that all skills must inherit from.
Provides a standard interface for skill discovery, validation, and execution.
"""

from __future__ import annotations

import time
from abc import ABC, abstractmethod
from typing import Any

from engine.models import SkillExecutionResponse, SkillInfo, TaskStatus


class BaseSkill(ABC):
    """Abstract base class for all Synapse skills.

    Every skill must define:
    - name: Unique identifier (snake_case)
    - description: Human-readable description
    - execute(): The core logic
    - validate_input(): Input validation
    - input_schema(): JSON schema for expected inputs
    """

    @property
    @abstractmethod
    def name(self) -> str:
        """Unique skill identifier (snake_case)."""
        ...

    @property
    @abstractmethod
    def description(self) -> str:
        """Human-readable description of what this skill does."""
        ...

    @abstractmethod
    def input_schema(self) -> dict[str, Any]:
        """Return a JSON-like schema describing expected input fields.

        Example:
            {
                "url": {"type": "string", "required": True, "description": "URL to fetch"},
                "method": {"type": "string", "required": False, "default": "GET"}
            }
        """
        ...

    @abstractmethod
    def validate_input(self, input_data: dict[str, Any]) -> tuple[bool, str]:
        """Validate input data before execution.

        Returns:
            (is_valid, error_message) - error_message is empty string if valid
        """
        ...

    @abstractmethod
    async def execute(self, input_data: dict[str, Any]) -> dict[str, Any]:
        """Execute the skill with the given input.

        Args:
            input_data: Validated input parameters

        Returns:
            Dictionary containing the execution result

        Raises:
            Exception: Any error during execution (will be caught by the engine)
        """
        ...

    def get_info(self) -> SkillInfo:
        """Get metadata about this skill for the registry."""
        return SkillInfo(
            name=self.name,
            description=self.description,
            input_schema=self.input_schema(),
            examples=self.get_examples(),
        )

    def get_examples(self) -> list[dict[str, Any]]:
        """Optional: Return example inputs for this skill."""
        return []

    async def run(self, task_id: str, input_data: dict[str, Any]) -> SkillExecutionResponse:
        """Full execution pipeline: validate → execute → wrap response.

        This is the method called by the SkillEngine.
        """
        start_time = time.perf_counter()

        # Validate
        is_valid, error_msg = self.validate_input(input_data)
        if not is_valid:
            return SkillExecutionResponse(
                task_id=task_id,
                skill_name=self.name,
                status=TaskStatus.FAILED,
                error=f"Input validation failed: {error_msg}",
                execution_time_ms=int((time.perf_counter() - start_time) * 1000),
            )

        # Execute
        try:
            result = await self.execute(input_data)
            elapsed_ms = int((time.perf_counter() - start_time) * 1000)
            return SkillExecutionResponse(
                task_id=task_id,
                skill_name=self.name,
                status=TaskStatus.COMPLETE,
                output=result,
                execution_time_ms=elapsed_ms,
            )
        except Exception as e:
            elapsed_ms = int((time.perf_counter() - start_time) * 1000)
            return SkillExecutionResponse(
                task_id=task_id,
                skill_name=self.name,
                status=TaskStatus.FAILED,
                error=f"{type(e).__name__}: {str(e)}",
                execution_time_ms=elapsed_ms,
            )
