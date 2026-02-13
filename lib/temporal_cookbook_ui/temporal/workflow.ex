defmodule TemporalCookbookUi.Temporal.Workflow do
  @moduledoc """
  Data structures and functional core for Temporal workflows.

  This module contains:
  - Data structures (structs, typespecs) for workflow entities
  - Functions for building and transforming workflow data

  This follows the OTP layered architecture pattern where functions
  that operate on a data structure are grouped with that data structure.
  """

  alias TemporalCookbookUi.LLM.Provider

  # ===== DATA LAYER =====
  # Struct definitions would go here when needed
  # defstruct [:pattern_id, :workflow_id, :input]

  # ===== FUNCTIONAL CORE =====
  # Functions that operate on workflow data structures

  @doc """
  Builds a workflow request from pattern ID and user parameters.

  This function transforms user input (from form params) into a structured
  workflow request that can be sent to the Temporal client.

  ## Parameters
  - `pattern_id`: The ID of the pattern being executed
  - `params`: A map of user-provided parameters (e.g., from form submission)
    - `"provider"`: LLM provider name (e.g., "ollama", "openai")
    - `"prompt"`: The prompt text for the LLM
    - `"temperature"`: Temperature parameter (optional, parsed as float)
    - `"max_tokens"`: Max tokens parameter (optional, parsed as integer)

  ## Returns
  A map with:
  - `:pattern_id`: The pattern ID
  - `:workflow_id`: A generated unique workflow ID
  - `:input`: A map of workflow input parameters (model, prompt, temperature, max_tokens)

  ## Examples

      iex> params = %{"provider" => "ollama", "prompt" => "Hello", "temperature" => "0.7"}
      iex> request = TemporalCookbookUi.Temporal.Workflow.build_request("1", params)
      iex> request.pattern_id
      "1"
      iex> String.starts_with?(request.workflow_id, "1-")
      true
      iex> request.input["model"]
      "ollama/gemma3:latest"
      iex> request.input["prompt"]
      "Hello"
      iex> request.input["temperature"]
      0.7
  """
  def build_request(pattern_id, params) when is_binary(pattern_id) and is_map(params) do
    # Map provider to model string using provider config
    provider = Map.get(params, "provider", "ollama")
    model = Provider.model_for_provider(provider)
    prompt = Map.get(params, "prompt", "")
    temperature = parse_float(params["temperature"])
    max_tokens = parse_integer(params["max_tokens"])

    # Build workflow input matching Python workflow expectations
    workflow_input =
      %{
        "model" => model,
        "prompt" => prompt,
        "temperature" => temperature,
        "max_tokens" => max_tokens
      }
      |> Enum.reject(fn {_k, v} -> is_nil(v) end)
      |> Map.new()

    %{
      pattern_id: pattern_id,
      workflow_id: generate_id(pattern_id),
      input: workflow_input
    }
  end

  @doc """
  Generates a unique workflow ID.

  The ID format is: `{prefix}-{timestamp}-{random}`

  ## Parameters
  - `prefix`: Optional prefix for the workflow ID (default: "litellm")

  ## Returns
  A unique workflow ID string.

  ## Examples

      iex> id = TemporalCookbookUi.Temporal.Workflow.generate_id()
      iex> String.starts_with?(id, "litellm-")
      true

      iex> id = TemporalCookbookUi.Temporal.Workflow.generate_id("custom")
      iex> String.starts_with?(id, "custom-")
      true
  """
  def generate_id(prefix \\ "litellm") do
    "#{prefix}-#{System.system_time(:second)}-#{:rand.uniform(9999)}"
  end

  # ===== PRIVATE HELPERS =====

  # Parse float from string, returning nil for invalid input
  defp parse_float(nil), do: nil

  defp parse_float(str) when is_binary(str) do
    case Float.parse(str) do
      {float, _} -> float
      :error -> nil
    end
  end

  defp parse_float(float) when is_float(float), do: float
  defp parse_float(_), do: nil

  # Parse integer from string, returning nil for invalid input
  defp parse_integer(nil), do: nil

  defp parse_integer(str) when is_binary(str) do
    case Integer.parse(str) do
      {int, _} -> int
      :error -> nil
    end
  end

  defp parse_integer(int) when is_integer(int), do: int
  defp parse_integer(_), do: nil
end
