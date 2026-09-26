"""
Synapse Agent Service - Pydantic Models

Defines the data structures for skill execution requests,
responses, and registry entries.
"""

from __future__ import annotations

from datetime import datetime
from enum import Enum
from typing import Any, Optional

from pydantic import BaseModel, Field


class TaskStatus(str, Enum):
    """Status of a skill execution task."""
    PENDING = "pending"
    RUNNING = "running"
    COMPLETE = "complete"
    FAILED = "failed"


class SkillInfo(BaseModel):
    """Information about a registered skill."""
    name: str = Field(..., description="Unique skill identifier")
    description: str = Field(..., description="What this skill does")
    input_schema: dict[str, Any] = Field(
        default_factory=dict,
        description="JSON schema for the skill's expected input"
    )
    examples: list[dict[str, Any]] = Field(
        default_factory=list,
        description="Example inputs for this skill"
    )


class SkillExecutionRequest(BaseModel):
    """Request to execute a specific skill."""
    task_id: str = Field(..., description="Unique task ID from the orchestrator")
    skill_name: str = Field(..., description="Name of the skill to execute")
    input_data: dict[str, Any] = Field(
        default_factory=dict,
        description="Input parameters for the skill"
    )
    timeout_seconds: int = Field(
        default=120,
        description="Maximum execution time in seconds"
    )


class SkillExecutionResponse(BaseModel):
    """Response from a skill execution."""
    task_id: str
    skill_name: str
    status: TaskStatus
    output: dict[str, Any] = Field(default_factory=dict)
    error: Optional[str] = None
    execution_time_ms: int = 0
    completed_at: datetime = Field(default_factory=datetime.utcnow)


class HealthResponse(BaseModel):
    """Health check response."""
    status: str = "healthy"
    service: str = "synapse-agents"
    version: str = "0.1.0"
    registered_skills: int = 0
    uptime_seconds: float = 0.0
