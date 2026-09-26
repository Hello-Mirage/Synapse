"""
Synapse Agent Service — FastAPI Application

The Python agent service that receives skill execution requests from
the Serverpod backend, routes them to the appropriate skill, and
returns structured results.

Endpoints:
    POST /execute          — Execute a single skill
    POST /execute/batch    — Execute multiple skills concurrently
    GET  /skills           — List all registered skills
    GET  /skills/{name}    — Get info for a specific skill
    GET  /health           — Health check
"""

from __future__ import annotations

import logging
import time
from contextlib import asynccontextmanager

from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware

from engine.models import (
    HealthResponse,
    SkillExecutionRequest,
    SkillExecutionResponse,
    SkillInfo,
)
from engine.skill_engine import SkillEngine
from engine.skill_registry import SkillRegistry

# ---------------------------------------------------------------------------
# Logging
# ---------------------------------------------------------------------------
logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s │ %(name)-20s │ %(levelname)-7s │ %(message)s",
    datefmt="%H:%M:%S",
)
logger = logging.getLogger("synapse.main")

# ---------------------------------------------------------------------------
# Globals
# ---------------------------------------------------------------------------
_start_time: float = 0.0
_engine: SkillEngine | None = None


# ---------------------------------------------------------------------------
# Lifespan
# ---------------------------------------------------------------------------
@asynccontextmanager
async def lifespan(app: FastAPI):
    """Startup / shutdown lifecycle."""
    global _start_time, _engine

    _start_time = time.time()

    # Discover and register all skills
    registry = SkillRegistry()
    registry.discover_and_register()

    _engine = SkillEngine(registry)

    logger.info(
        f"🧠 Synapse Agent Service started — "
        f"{registry.count} skills registered"
    )
    logger.info(f"   Skills: {', '.join(registry.skill_names)}")

    yield  # ── app is running ──

    logger.info("Synapse Agent Service shutting down")


# ---------------------------------------------------------------------------
# App
# ---------------------------------------------------------------------------
app = FastAPI(
    title="Synapse Agent Service",
    description=(
        "AI-powered skill execution engine for the Synapse orchestration platform. "
        "Receives tasks from the Serverpod backend and executes them using "
        "registered Python skills."
    ),
    version="0.1.0",
    lifespan=lifespan,
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Restrict in production
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


# ---------------------------------------------------------------------------
# Routes
# ---------------------------------------------------------------------------
@app.post("/execute", response_model=SkillExecutionResponse)
async def execute_skill(request: SkillExecutionRequest):
    """Execute a single skill with the given input."""
    if _engine is None:
        raise HTTPException(status_code=503, detail="Engine not initialized")
    return await _engine.execute(request)


@app.post("/execute/batch", response_model=list[SkillExecutionResponse])
async def execute_batch(requests: list[SkillExecutionRequest]):
    """Execute multiple skills concurrently."""
    if _engine is None:
        raise HTTPException(status_code=503, detail="Engine not initialized")
    return await _engine.execute_batch(requests)


@app.get("/skills", response_model=list[SkillInfo])
async def list_skills():
    """List all registered skills with their schemas."""
    if _engine is None:
        raise HTTPException(status_code=503, detail="Engine not initialized")
    return _engine.registry.list_skills()


@app.get("/skills/{skill_name}", response_model=SkillInfo)
async def get_skill(skill_name: str):
    """Get detailed info for a specific skill."""
    if _engine is None:
        raise HTTPException(status_code=503, detail="Engine not initialized")

    skill = _engine.registry.get_skill(skill_name)
    if skill is None:
        raise HTTPException(
            status_code=404,
            detail=f"Skill '{skill_name}' not found. "
            f"Available: {_engine.registry.skill_names}",
        )
    return skill.get_info()


@app.get("/health", response_model=HealthResponse)
async def health_check():
    """Health check with uptime and skill count."""
    return HealthResponse(
        registered_skills=_engine.registry.count if _engine else 0,
        uptime_seconds=round(time.time() - _start_time, 2) if _start_time else 0,
    )


# ---------------------------------------------------------------------------
# Entry point
# ---------------------------------------------------------------------------
if __name__ == "__main__":
    import uvicorn

    uvicorn.run(
        "main:app",
        host="0.0.0.0",
        port=8090,
        reload=True,
        log_level="info",
    )
