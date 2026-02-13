defmodule TemporalCookbookUi.Patterns.Pattern do
  @moduledoc """
  Data and Functional Core for a pattern domain.
  """

  # ===== DATA LAYER =====
  defstruct [
    :id,
    :name,
    :description,
    :complexity,
    :tags,
    :workflow_type,
    :status,
    :use_cases
  ]

  # Static pattern data
  defp patterns do
    [
      %__MODULE__{
        id: "litellm",
        name: "LiteLLM Completion",
        description:
          "Use LiteLLM to provide AI capabilities within your Temporal workflows. " <>
            "Swap between OpenAI, Anthropic, Groq, and local Ollama models without changing workflow code.",
        complexity: "Easy",
        tags: ["LLM", "Multi-Provider", "Activity"],
        workflow_type: "litellm_workflow",
        status: :available,
        use_cases: [
          "Compare responses across LLM providers",
          "Build provider-agnostic AI pipelines",
          "Prototype LLM-powered features with durable execution"
        ]
      },
      %__MODULE__{
        id: "tool-calling",
        name: "Tool Calling Agent",
        description:
          "Implement an AI agent that can invoke external tools and APIs as Temporal activities. " <>
            "The agent decides which tools to call based on the prompt, executes them durably, and synthesizes results.",
        complexity: "Medium",
        tags: ["Agent", "Tool Use", "LLM", "Activity"],
        workflow_type: "tool_calling_workflow",
        status: :available,
        use_cases: [
          "Build LLM agents that call real APIs",
          "Automate multi-step research tasks",
          "Create self-directing workflows with tool orchestration"
        ]
      },
      %__MODULE__{
        id: "structured-outputs",
        name: "Structured Outputs",
        description:
          "Force LLM responses into validated JSON schemas using Temporal activities. " <>
            "Guarantees type-safe, structured data from any LLM provider.",
        complexity: "Medium",
        tags: ["Structured Data", "JSON Schema", "Validation", "LLM"],
        workflow_type: "structured_outputs_workflow",
        status: :coming_soon,
        use_cases: [
          "Extract structured data from unstructured text",
          "Generate validated configuration from natural language",
          "Build type-safe LLM pipelines"
        ]
      },
      %__MODULE__{
        id: "retry-policy",
        name: "Retry Policy",
        description:
          "Demonstrate Temporal's built-in retry policies for handling transient LLM failures. " <>
            "Visualize retry attempts, backoff intervals, and eventual success or failure.",
        complexity: "Easy",
        tags: ["Retry", "Fault Tolerance", "Resilience"],
        workflow_type: "retry_policy_workflow",
        status: :coming_soon,
        use_cases: [
          "Handle LLM rate limits and transient errors",
          "Understand Temporal retry semantics",
          "Build resilient AI pipelines"
        ]
      },
      %__MODULE__{
        id: "durable-agent",
        name: "Durable Agent",
        description:
          "A long-running AI agent that survives process restarts, network failures, and server crashes. " <>
            "Uses Temporal signals and queries to interact with an agent mid-execution.",
        complexity: "Hard",
        tags: ["Agent", "Signals", "Queries", "Long-Running"],
        workflow_type: "durable_agent_workflow",
        status: :coming_soon,
        use_cases: [
          "Build agents that run for hours or days",
          "Interact with running workflows via signals",
          "Implement human-in-the-loop AI pipelines"
        ]
      },
      %__MODULE__{
        id: "deep-research",
        name: "Deep Research",
        description:
          "Orchestrate a multi-step research pipeline that searches the web, synthesizes findings, " <>
            "and produces a structured report — all as durable Temporal activities.",
        complexity: "Hard",
        tags: ["Research", "Multi-Step", "Web Search", "Agent"],
        workflow_type: "deep_research_workflow",
        status: :coming_soon,
        use_cases: [
          "Automate competitive research and market analysis",
          "Generate comprehensive reports from a single prompt",
          "Orchestrate parallel web searches with LLM synthesis"
        ]
      }
    ]
  end

  # ===== FUNCTIONAL CORE =====
  def list_all do
    patterns()
  end

  def get_by_id(id) do
    patterns()
    |> Enum.find(fn pattern -> pattern.id == id end) ||
      default_pattern(id)
  end

  defp default_pattern(id) do
    %__MODULE__{
      id: id,
      name: "Unknown Pattern",
      description: "Pattern not found",
      complexity: "Unknown",
      tags: [],
      workflow_type: nil,
      status: :coming_soon,
      use_cases: []
    }
  end
end
