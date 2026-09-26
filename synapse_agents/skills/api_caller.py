"""
Synapse Skill - API Caller

Makes HTTP API calls to external services with full request/response control.
"""

from __future__ import annotations

import json
from typing import Any
from urllib.parse import urlparse

import httpx

from skills.base_skill import BaseSkill


class APICallerSkill(BaseSkill):
    """Make HTTP API calls to external services."""

    ALLOWED_METHODS = {"GET", "POST", "PUT", "PATCH", "DELETE", "HEAD", "OPTIONS"}

    @property
    def name(self) -> str:
        return "api_caller"

    @property
    def description(self) -> str:
        return (
            "Makes HTTP requests to external APIs. "
            "Supports all HTTP methods, custom headers, query parameters, "
            "JSON/form body, and authentication headers."
        )

    def input_schema(self) -> dict[str, Any]:
        return {
            "url": {
                "type": "string",
                "required": True,
                "description": "The API endpoint URL",
            },
            "method": {
                "type": "string",
                "required": False,
                "default": "GET",
                "description": "HTTP method",
                "enum": list(self.ALLOWED_METHODS),
            },
            "headers": {
                "type": "object",
                "required": False,
                "description": "HTTP headers as key-value pairs",
            },
            "query_params": {
                "type": "object",
                "required": False,
                "description": "URL query parameters as key-value pairs",
            },
            "body": {
                "type": "object",
                "required": False,
                "description": "Request body (sent as JSON)",
            },
            "form_data": {
                "type": "object",
                "required": False,
                "description": "Form data (sent as application/x-www-form-urlencoded)",
            },
            "timeout_seconds": {
                "type": "integer",
                "required": False,
                "default": 30,
                "description": "Request timeout in seconds",
            },
            "follow_redirects": {
                "type": "boolean",
                "required": False,
                "default": True,
                "description": "Whether to follow HTTP redirects",
            },
        }

    def validate_input(self, input_data: dict[str, Any]) -> tuple[bool, str]:
        if "url" not in input_data:
            return False, "Missing required field: url"

        url = input_data["url"]
        parsed = urlparse(url)
        if parsed.scheme not in ("http", "https"):
            return False, f"Invalid URL scheme: {parsed.scheme}. Use http or https."

        method = input_data.get("method", "GET").upper()
        if method not in self.ALLOWED_METHODS:
            return False, f"Invalid HTTP method: {method}"

        # Can't send both body and form_data
        if "body" in input_data and "form_data" in input_data:
            return False, "Cannot specify both 'body' and 'form_data'"

        return True, ""

    async def execute(self, input_data: dict[str, Any]) -> dict[str, Any]:
        url = input_data["url"]
        method = input_data.get("method", "GET").upper()
        headers = input_data.get("headers", {})
        query_params = input_data.get("query_params", {})
        timeout = input_data.get("timeout_seconds", 30)
        follow_redirects = input_data.get("follow_redirects", True)

        # Build request kwargs
        request_kwargs: dict[str, Any] = {
            "method": method,
            "url": url,
            "headers": headers,
            "params": query_params,
            "timeout": float(timeout),
            "follow_redirects": follow_redirects,
        }

        if "body" in input_data:
            request_kwargs["json"] = input_data["body"]
        elif "form_data" in input_data:
            request_kwargs["data"] = input_data["form_data"]

        async with httpx.AsyncClient() as client:
            response = await client.request(**request_kwargs)

        # Parse response body
        content_type = response.headers.get("content-type", "")
        if "application/json" in content_type:
            try:
                response_body = response.json()
            except json.JSONDecodeError:
                response_body = response.text
        else:
            response_body = response.text[:50000]  # Cap text responses

        return {
            "status_code": response.status_code,
            "headers": dict(response.headers),
            "body": response_body,
            "url": str(response.url),
            "method": method,
            "success": 200 <= response.status_code < 300,
            "content_type": content_type,
        }

    def get_examples(self) -> list[dict[str, Any]]:
        return [
            {
                "description": "Simple GET request",
                "input": {"url": "https://httpbin.org/get", "method": "GET"},
            },
            {
                "description": "POST with JSON body",
                "input": {
                    "url": "https://httpbin.org/post",
                    "method": "POST",
                    "headers": {"Content-Type": "application/json"},
                    "body": {"key": "value", "number": 42},
                },
            },
            {
                "description": "GET with query parameters and auth",
                "input": {
                    "url": "https://api.example.com/data",
                    "method": "GET",
                    "headers": {"Authorization": "Bearer <token>"},
                    "query_params": {"page": "1", "limit": "10"},
                },
            },
        ]
