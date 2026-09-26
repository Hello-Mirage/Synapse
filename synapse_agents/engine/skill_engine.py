"""
Synapse Agent Service - Skill Execution Engine

Orchestrates skill execution: receives tasks, routes to the correct skill,
manages timeouts, and returns structured results.
"""

from __future__ import annotations

import asyncio
import logging
from typing import Any

from engine.models import SkillExecutionRequest, SkillExecutionResponse, TaskStatus
from engine.skill_registry import SkillRegistry

logger = logging.getLogger("synapse.engine")


class SkillEngine:
    """Core engine that routes execution requests to registered skills.

    Handles:
    - Task routing based on skill_name
    - Timeout enforcement
    - Error wrapping
    - Concurrent execution tracking
    """

    def __init__(self, registry: SkillRegistry) -> None:
        self._registry = registry
        self._active_tasks: dict[str, asyncio.Task] = {}

    async def execute(self, request: SkillExecutionRequest) -> SkillExecutionResponse:
        """Execute a skill based on the incoming request.

        Args:
            request: The execution request with skill name and input data.

        Returns:
            SkillExecutionResponse with status, output, or error.
        """
        task_id = request.task_id
        skill_name = request.skill_name

        logger.info(f"[{task_id}] Executing skill: {skill_name}")

        # Check if skill exists
        skill = self._registry.get_skill(skill_name)
        if skill is None:
            available = ", ".join(self._registry.skill_names)
            logger.warning(f"[{task_id}] Skill not found: {skill_name}")
            return SkillExecutionResponse(
                task_id=task_id,
                skill_name=skill_name,
                status=TaskStatus.FAILED,
                error=(
                    f"Skill '{skill_name}' not found. "
                    f"Available skills: {available}"
                ),
            )

        # Execute with timeout
        try:
            coro = skill.run(task_id, request.input_data)
            result = await asyncio.wait_for(
                coro, timeout=request.timeout_seconds
            )
            logger.info(
                f"[{task_id}] Skill '{skill_name}' completed "
                f"in {result.execution_time_ms}ms "
                f"with status: {result.status}"
            )
            return result

        except asyncio.TimeoutError:
            logger.error(
                f"[{task_id}] Skill '{skill_name}' timed out "
                f"after {request.timeout_seconds}s"
            )
            return SkillExecutionResponse(
                task_id=task_id,
                skill_name=skill_name,
                status=TaskStatus.FAILED,
                error=f"Execution timed out after {request.timeout_seconds} seconds",
            )
        except Exception as e:
            logger.error(f"[{task_id}] Unexpected error in '{skill_name}': {e}")
            return SkillExecutionResponse(
                task_id=task_id,
                skill_name=skill_name,
                status=TaskStatus.FAILED,
                error=f"Unexpected error: {type(e).__name__}: {str(e)}",
            )

    async def execute_batch(
        self, requests: list[SkillExecutionRequest]
    ) -> list[SkillExecutionResponse]:
        """Execute multiple skill requests concurrently.

        Args:
            requests: List of execution requests.

        Returns:
            List of responses in the same order as requests.
        """
        tasks = [self.execute(req) for req in requests]
        return await asyncio.gather(*tasks)

    @property
    def registry(self) -> SkillRegistry:
        """Access the skill registry."""
        return self._registry
