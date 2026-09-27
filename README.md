# Synapse - AI Orchestration Platform

Synapse is a multi-service orchestration platform that leverages Google's Gemini AI to dynamically understand user intentions, convert them into executable skill tasks, and dispatch them to Python-based background agents.

## Architecture

Synapse is composed of three main components:

1. **Flutter Dashboard (synapse_flutter)**
   - A beautiful, glassmorphic UI where users can input instructions and track the status of their orchestration tasks in real-time.
2. **Serverpod Backend (synapse_server)**
   - A high-performance Dart backend that handles API routing, tracks task execution states in a PostgreSQL database, interfaces with the Gemini API, and dispatches tasks to the agent service.
3. **Python Agent Service (synapse_agents)**
   - A FastAPI service that dynamically discovers and registers "Skills" (plugins). It executes the tasks dispatched by the Serverpod backend.

### Included Skills
The Python agent comes with 5 built-in skills out of the box:
- `code_generator`: Generate, edit, append, or insert code in any language.
- `file_manager`: Perform file system operations (read, list, copy, move, delete).
- `shell_executor`: Safely execute shell commands with timeout limits.
- `web_scraper`: Fetch webpages and extract text, links, or CSS-selected elements.
- `api_caller`: Make REST API requests with full control over headers and payloads.

## Getting Started

### Prerequisites
- [Flutter / Dart](https://docs.flutter.dev/get-started/install)
- [Python 3.10+](https://www.python.org/downloads/)
- [Docker](https://www.docker.com/) (Required for Serverpod PostgreSQL database)
- [Git](https://git-scm.com/)

### 1. Set Up Your API Key
You will need a Google Gemini API Key. Get one from [Google AI Studio](https://aistudio.google.com/apikey).
Open `synapse/synapse_server/config/passwords.yaml` and add your key under the `development` block:
```yaml
development:
  # ... other config ...
  geminiApiKey: 'YOUR_GEMINI_API_KEY_HERE'
```

### 2. Start the Python Agent Service
Open a terminal in the `synapse_agents` directory:
```bash
cd synapse_agents
pip install -r requirements.txt
python -m uvicorn main:app --host 0.0.0.0 --port 8090
```

### 3. Start the Serverpod Backend & Flutter App
Open a new terminal in the `synapse` directory:
```bash
cd synapse
serverpod start
```
*Note: In Serverpod 4, `serverpod start` automatically handles the local Postgres database, compiles the server, and serves the Flutter web app on `http://localhost:8082`.*

## How It Works

1. **Prompt**: The user types a command in the Flutter dashboard (e.g., "Scrape https://example.com for links").
2. **Orchestration**: The Serverpod backend sends the prompt to Gemini with system instructions to pick the best skill.
3. **Parsing**: Gemini returns a structured JSON payload defining the target skill (`web_scraper`) and the exact input parameters.
4. **Execution**: Serverpod dispatches the job to the Python FastAPI server.
5. **Completion**: The agent runs the skill, and the output is instantly reflected in the Flutter UI.

## Adding New Skills
Adding a new capability to the agent service is as easy as creating a new file in `synapse_agents/skills/`. The service automatically discovers and registers any class that extends `BaseSkill`.

```python
from skills.base_skill import BaseSkill

class MyCustomSkill(BaseSkill):
    @property
    def name(self) -> str:
        return "my_custom_skill"

    @property
    def description(self) -> str:
        return "Does something awesome."

    def input_schema(self) -> dict:
        return {
            "my_param": {"type": "string", "required": True}
        }
    
    def validate_input(self, input_data: dict) -> tuple[bool, str]:
        return True, ""

    async def execute(self, input_data: dict) -> dict:
        return {"result": f"Processed {input_data['my_param']}"}
```
*Once you restart the Python service, Gemini will automatically become aware of your new skill and can use it in future tasks.*
