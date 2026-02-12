# temporal-cookbook-ui

Web-based front end for running, visualizing, and interacting with examples from the official Temporal.io Cookbook

## Getting Started

### Prerequisites
- Elixir 1.16+ and Phoenix
- Python 3.12+ with `uv` package manager
- Temporal Dev Server (for local development)

### Environment Setup

1. **Copy environment template:**
   ```bash
   cp .env.example .env
   ```

2. **Configure API Keys:**
   Edit `.env` and add your LLM provider API keys:
   - `OPENAI_API_KEY` - For OpenAI models (get at https://platform.openai.com/api-keys)
   - `ANTHROPIC_API_KEY` - For Anthropic models (get at https://console.anthropic.com/)
   - `GROQ_API_KEY` - For Groq models (get at https://console.groq.com/keys)
   - `OLLAMA_API_BASE` - For local Ollama (e.g., `http://127.0.0.1:11434` or `http://localhost:11434`)

   **Note:** 
   - You only need to set keys for providers you want to use
   - For Ollama, set `OLLAMA_API_BASE` to match where your Ollama server is running
   - If `OLLAMA_API_BASE` is not set, LiteLLM defaults to `http://localhost:11434`

3. **Load environment variables:**
   ```bash
   # Before running the Python worker, load the .env file:
   source .env
   # Or use a tool like direnv (https://direnv.net/) for automatic loading
   ```

### Running the Application

**Important:** You need all three services running for workflows to execute:
1. Temporal Dev Server (workflow orchestration)
2. Phoenix Server (web UI)
3. Python Worker (executes workflows)

**Step 1: Start Temporal Dev Server** (in first terminal):
   ```bash
   temporal server start-dev
   ```
   This starts Temporal at `localhost:7233` and the Temporal UI at `http://localhost:8233`

**Step 2: Start Python Worker** (in second terminal):
   ```bash
   source .env  # Load API keys (OPENAI_API_KEY and/or OLLAMA_API_BASE)
   cd python
   uv run python workers/main.py
   ```
   The worker will connect to Temporal at `localhost:7233` and listen on task queue `temporal-cookbook-examples`.
   
   **⚠️ Without the worker running, workflows will start but never execute!**
   
   **Verify worker is running:**
   - You should see: "Connected to Temporal server" and "Worker running..."
   - Check worker status: `temporal task-queue describe --task-queue temporal-cookbook-examples`
   - You should see your worker in the "Pollers" section

**Step 3: Start Phoenix Server** (in third terminal):
   ```bash
   mix phx.server
   ```
   Visit http://localhost:4000
   
   You can now start workflows from the UI, and they will execute if the worker is running.

## Development

See `docs/development-workflow.md` for development practices and workflow.

## Documentation

- **PRD**: `docs/temporal-cookbook-ui-prd.md` - Product requirements and specifications
- **Development Guide**: `docs/development-workflow.md` - Daily development practices
- **Session Notes**: `docs/sessions/` - Session-by-session development tracking

## Project Structure

[Document your project structure here as it evolves]

---

*This project was bootstrapped with [Claude Code Workflow Template](https://github.com/jszod/claude-code-workflow-template)*
