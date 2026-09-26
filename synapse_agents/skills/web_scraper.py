"""
Synapse Skill - Web Scraper

Scrapes web pages and extracts text, links, or structured data.
"""

from __future__ import annotations

from typing import Any
from urllib.parse import urljoin, urlparse

import httpx
from bs4 import BeautifulSoup

from skills.base_skill import BaseSkill


class WebScraperSkill(BaseSkill):
    """Scrape web pages for text, links, and structured data."""

    @property
    def name(self) -> str:
        return "web_scraper"

    @property
    def description(self) -> str:
        return (
            "Fetches web pages and extracts content. "
            "Can extract plain text, all links, specific elements by CSS selector, "
            "or structured data from tables."
        )

    def input_schema(self) -> dict[str, Any]:
        return {
            "url": {
                "type": "string",
                "required": True,
                "description": "URL to scrape",
            },
            "extract_mode": {
                "type": "string",
                "required": False,
                "default": "text",
                "description": "What to extract",
                "enum": ["text", "links", "selector", "tables", "html"],
            },
            "css_selector": {
                "type": "string",
                "required": False,
                "description": "CSS selector (required when extract_mode is 'selector')",
            },
            "headers": {
                "type": "object",
                "required": False,
                "description": "Custom HTTP headers",
            },
            "max_length": {
                "type": "integer",
                "required": False,
                "default": 50000,
                "description": "Maximum character length of extracted content",
            },
        }

    def validate_input(self, input_data: dict[str, Any]) -> tuple[bool, str]:
        if "url" not in input_data:
            return False, "Missing required field: url"

        url = input_data["url"]
        parsed = urlparse(url)
        if parsed.scheme not in ("http", "https"):
            return False, f"Invalid URL scheme: {parsed.scheme}. Use http or https."

        mode = input_data.get("extract_mode", "text")
        if mode == "selector" and "css_selector" not in input_data:
            return False, "css_selector is required when extract_mode is 'selector'"

        return True, ""

    async def execute(self, input_data: dict[str, Any]) -> dict[str, Any]:
        url = input_data["url"]
        mode = input_data.get("extract_mode", "text")
        max_length = input_data.get("max_length", 50000)
        custom_headers = input_data.get("headers", {})

        headers = {
            "User-Agent": "Synapse-Agent/0.1 (AI Orchestration Platform)",
            **custom_headers,
        }

        async with httpx.AsyncClient(follow_redirects=True, timeout=30.0) as client:
            response = await client.get(url, headers=headers)
            response.raise_for_status()

        soup = BeautifulSoup(response.text, "lxml")
        base_result = {
            "url": str(response.url),
            "status_code": response.status_code,
        }

        if mode == "text":
            # Remove script and style elements
            for tag in soup(["script", "style", "nav", "footer"]):
                tag.decompose()
            text = soup.get_text(separator="\n", strip=True)
            if len(text) > max_length:
                text = text[:max_length] + "\n... [truncated]"
            return {**base_result, "text": text, "length": len(text)}

        elif mode == "links":
            links = []
            for a in soup.find_all("a", href=True):
                abs_url = urljoin(url, a["href"])
                links.append({
                    "text": a.get_text(strip=True),
                    "url": abs_url,
                })
            return {**base_result, "links": links[:200], "total_links": len(links)}

        elif mode == "selector":
            selector = input_data["css_selector"]
            elements = soup.select(selector)
            results = []
            for el in elements[:100]:
                results.append({
                    "tag": el.name,
                    "text": el.get_text(strip=True)[:1000],
                    "html": str(el)[:2000],
                    "attributes": dict(el.attrs),
                })
            return {**base_result, "elements": results, "count": len(elements)}

        elif mode == "tables":
            tables = []
            for table in soup.find_all("table")[:10]:
                rows = []
                for tr in table.find_all("tr"):
                    cells = [td.get_text(strip=True) for td in tr.find_all(["td", "th"])]
                    rows.append(cells)
                tables.append({"rows": rows, "row_count": len(rows)})
            return {**base_result, "tables": tables, "table_count": len(tables)}

        elif mode == "html":
            html = str(soup)
            if len(html) > max_length:
                html = html[:max_length] + "<!-- truncated -->"
            return {**base_result, "html": html, "length": len(html)}

        return {**base_result, "error": f"Unknown mode: {mode}"}

    def get_examples(self) -> list[dict[str, Any]]:
        return [
            {
                "description": "Extract text from a webpage",
                "input": {"url": "https://example.com", "extract_mode": "text"},
            },
            {
                "description": "Get all links from a page",
                "input": {"url": "https://example.com", "extract_mode": "links"},
            },
            {
                "description": "Extract elements by CSS selector",
                "input": {
                    "url": "https://example.com",
                    "extract_mode": "selector",
                    "css_selector": "h2.title",
                },
            },
        ]
