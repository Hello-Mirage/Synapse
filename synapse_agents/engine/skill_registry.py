"""
Synapse Agent Service - Skill Registry

Auto-discovers and registers all skill classes from the skills/ directory.
Skills are loaded by scanning for subclasses of BaseSkill.
"""

from __future__ import annotations

import importlib
import inspect
import logging
import pkgutil
from pathlib import Path
from typing import Optional

from engine.models import SkillInfo
from skills.base_skill import BaseSkill

logger = logging.getLogger("synapse.registry")


class SkillRegistry:
    """Discovers, validates, and stores all available skills.

    Skills are auto-discovered from the `skills` package at startup.
    Each skill must subclass `BaseSkill` and implement all required methods.
    """

    def __init__(self) -> None:
        self._skills: dict[str, BaseSkill] = {}

    def discover_and_register(self) -> None:
        """Scan the skills package and register all valid skill classes."""
        import skills as skills_pkg

        skills_dir = Path(skills_pkg.__file__).parent
        logger.info(f"Discovering skills in: {skills_dir}")

        for module_info in pkgutil.iter_modules([str(skills_dir)]):
            if module_info.name.startswith("_") or module_info.name == "base_skill":
                continue

            try:
                module = importlib.import_module(f"skills.{module_info.name}")
                self._register_from_module(module)
            except Exception as e:
                logger.error(f"Failed to import skill module '{module_info.name}': {e}")

        logger.info(
            f"Registered {len(self._skills)} skills: "
            f"{', '.join(sorted(self._skills.keys()))}"
        )

    def _register_from_module(self, module) -> None:
        """Find and register all BaseSkill subclasses in a module."""
        for attr_name, attr_value in inspect.getmembers(module, inspect.isclass):
            if (
                issubclass(attr_value, BaseSkill)
                and attr_value is not BaseSkill
                and not inspect.isabstract(attr_value)
            ):
                try:
                    instance = attr_value()
                    self._skills[instance.name] = instance
                    logger.info(
                        f"  ✓ Registered skill: {instance.name} "
                        f"({attr_value.__name__})"
                    )
                except Exception as e:
                    logger.error(
                        f"  ✗ Failed to instantiate {attr_value.__name__}: {e}"
                    )

    def get_skill(self, name: str) -> Optional[BaseSkill]:
        """Get a registered skill by name."""
        return self._skills.get(name)

    def list_skills(self) -> list[SkillInfo]:
        """Return info for all registered skills."""
        return [skill.get_info() for skill in self._skills.values()]

    def has_skill(self, name: str) -> bool:
        """Check if a skill is registered."""
        return name in self._skills

    @property
    def count(self) -> int:
        """Number of registered skills."""
        return len(self._skills)

    @property
    def skill_names(self) -> list[str]:
        """List of all registered skill names."""
        return list(self._skills.keys())
