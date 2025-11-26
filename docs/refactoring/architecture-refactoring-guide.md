# Architecture Refactoring Guide

**Created**: 2025-11-26
**Branch**: `feature/2-litellm-pattern`
**Status**: Planning Phase

## Overview

This document provides a comprehensive guide for refactoring the Temporal Cookbook UI codebase to follow:
1. **OTP Layered Architecture** (from "Designing Elixir Systems with OTP")
2. **Phoenix LiveView CRC Pattern** (from "Programming Phoenix LiveView")

## Current State Assessment

### Issues Identified

1. **Domain Model Confusion**
   - `temporal/provider_config.ex` mixes LLM concerns with Temporal orchestration
   - Business logic embedded directly in LiveView modules
   - No clear separation between functional core and boundary layers

2. **LiveView Pattern Violations**
   - Reducers doing too much (mixing data transformation, business logic, side effects)
   - Business logic (CLI parsing, data extraction) in LiveView modules
   - Direct system calls in presentation layer

3. **Missing Architectural Layers**
   - No functional core for pure business logic
   - No clear context boundaries between domains
   - Tight coupling between presentation and infrastructure

## Target Architecture

### OTP Layered Architecture ("Do Fun Things with Big, Loud Worker-Bees")

```
lib/temporal_cookbook_ui/
├── Data Structures (D)
│   ├── cookbook/
│   │   └── pattern.ex          # Pattern struct
│   ├── temporal/
│   │   ├── workflow.ex         # Workflow metadata struct
│   │   └── execution.ex        # Execution result struct
│   └── llm/
│       └── provider.ex         # Provider configuration struct
│
├── Functional Core (F)
│   ├── cookbook/
│   │   └── pattern_selector.ex # Pure pattern selection logic
│   ├── temporal/
│   │   └── query.ex            # Pure CLI output parsing
│   └── llm/
│       └── model_selector.ex   # Pure provider mapping logic
│
├── Boundaries (B)
│   ├── cookbook.ex             # Cookbook context API
│   ├── temporal/
│   │   └── client.ex           # Temporal CLI boundary
│   └── llm.ex                  # LLM context API
│
└── Web Layer
    └── live/
        ├── pattern_detail_live.ex    # CRC: Construct, Reduce, Convert
        └── execution_view_live.ex    # CRC: Construct, Reduce, Convert
```

### Phoenix LiveView CRC Pattern

```elixir
# CONSTRUCTOR: Initialize state from params
def mount(params, _session, socket) do
  initial_state = build_initial_state(params)
  {:ok, assign(socket, initial_state)}
end

# REDUCERS: Transform state based on events
def handle_event(event, params, socket) do
  new_state = transform_state(socket.assigns, event, params)
  {:noreply, assign(socket, new_state)}
end

# CONVERTERS: Format data for rendering
defp build_view_model(assigns) do
  %{
    display_field: format_field(assigns.raw_field),
    computed_value: calculate_value(assigns)
  }
end

def render(assigns) do
  view_model = build_view_model(assigns)
  ~H""" <%= view_model.display_field %> """
end
```

## Refactoring Phases

### Phase 1: Domain Separation (High Priority)

**Goal**: Separate LLM concerns from Temporal domain

**Changes**:
1. Create `lib/temporal_cookbook_ui/llm/` directory
2. Move `temporal/provider_config.ex` → `llm/provider.ex`
3. Update all imports across the codebase
4. Add tests for `LLM.Provider` module

**Estimated Effort**: 2-3 hours

### Phase 2: Extract Functional Core (High Priority)

**Goal**: Move pure business logic out of LiveView and boundary modules

**Changes**:
1. Create `lib/temporal_cookbook_ui/temporal/query.ex` for CLI parsing
2. Extract pure functions from `execution_view_live.ex`:
   - `parse_workflow_status/1`
   - `extract_result_from_cli_output/1`
3. Extract workflow building logic from `pattern_detail_live.ex`
4. Add comprehensive unit tests for all pure functions

**Estimated Effort**: 3-4 hours

### Phase 3: Refactor Boundary Layer (Medium Priority)

**Goal**: Create clean API boundaries for Temporal interactions

**Changes**:
1. Update `Temporal.Client` to use `Temporal.Query`
2. Extract workflow-related functions to proper methods:
   - `describe_workflow/2`
   - `get_workflow_result/2`
3. Return structured data instead of raw CLI output
4. Add error handling and logging

**Estimated Effort**: 2-3 hours

### Phase 4: LiveView CRC Refactoring (Medium Priority)

**Goal**: Apply CRC pattern consistently across LiveView modules

**Changes**:
1. Refactor `pattern_detail_live.ex`:
   - Simplify `handle_event("start_workflow")` reducer
   - Extract helper functions to private converters
   - Create context module for workflow orchestration
2. Refactor `execution_view_live.ex`:
   - Remove business logic from reducers
   - Use `Temporal.Client` boundary layer
   - Simplify polling logic
3. Extract reusable view helpers to separate module

**Estimated Effort**: 4-5 hours

### Phase 5: Context Layer (Low Priority)

**Goal**: Create Phoenix contexts for domain boundaries

**Changes**:
1. Create `lib/temporal_cookbook_ui/cookbook.ex` context
2. Create `lib/temporal_cookbook_ui/llm.ex` context
3. Move appropriate logic from LiveViews to contexts
4. Update tests to use context APIs

**Estimated Effort**: 3-4 hours

## Detailed Refactoring Plans

### Phase 1: Domain Separation

#### Step 1.1: Create LLM Domain Structure

**Files to Create**:
- `lib/temporal_cookbook_ui/llm/provider.ex`

**Code**:
```elixir
defmodule TemporalCookbookUi.LLM.Provider do
  @moduledoc """
  Provider configuration for LLM models.

  This module handles mapping between UI provider selection and LiteLLM model strings.
  Separated from Temporal domain as this is LLM-specific business logic.

  ## Examples

      iex> Provider.model_for_provider("openai")
      "gpt-3.5-turbo"

      iex> Provider.available_providers()
      ["openai", "ollama"]
  """

  @provider_models %{
    "openai" => "gpt-3.5-turbo",
    "ollama" => "ollama/gemma3:latest"
  }

  @doc """
  Returns the default model string for a given provider.
  """
  def model_for_provider(provider) when is_binary(provider) do
    Map.get(@provider_models, String.downcase(provider))
  end

  def model_for_provider(_), do: nil

  @doc """
  Returns a list of all available provider names.
  """
  def available_providers do
    Map.keys(@provider_models)
  end

  @doc """
  Returns all provider-to-model mappings.
  """
  def all_providers do
    @provider_models
  end

  @doc """
  Validates that a provider name is supported.
  """
  def valid_provider?(provider) when is_binary(provider) do
    Map.has_key?(@provider_models, String.downcase(provider))
  end

  def valid_provider?(_), do: false
end
```

#### Step 1.2: Update Imports

**Files to Update**:
- `lib/temporal_cookbook_ui_web/live/pattern_detail_live.ex`
- `lib/temporal_cookbook_ui_web/components/workflow_controls.ex`

**Changes**:
```elixir
# BEFORE
alias TemporalCookbookUi.Temporal.ProviderConfig

# AFTER
alias TemporalCookbookUi.LLM.Provider
```

#### Step 1.3: Delete Old File

**Files to Delete**:
- `lib/temporal_cookbook_ui/temporal/provider_config.ex`

#### Step 1.4: Add Tests

**File to Create**:
- `test/temporal_cookbook_ui/llm/provider_test.exs`

**Code**:
```elixir
defmodule TemporalCookbookUi.LLM.ProviderTest do
  use ExUnit.Case, async: true

  alias TemporalCookbookUi.LLM.Provider

  describe "model_for_provider/1" do
    test "returns model for valid provider" do
      assert Provider.model_for_provider("openai") == "gpt-3.5-turbo"
      assert Provider.model_for_provider("ollama") == "ollama/gemma3:latest"
    end

    test "returns nil for invalid provider" do
      assert Provider.model_for_provider("invalid") == nil
    end

    test "handles case insensitively" do
      assert Provider.model_for_provider("OpenAI") == "gpt-3.5-turbo"
      assert Provider.model_for_provider("OLLAMA") == "ollama/gemma3:latest"
    end
  end

  describe "available_providers/0" do
    test "returns list of provider names" do
      providers = Provider.available_providers()
      assert "openai" in providers
      assert "ollama" in providers
    end
  end

  describe "valid_provider?/1" do
    test "returns true for valid providers" do
      assert Provider.valid_provider?("openai")
      assert Provider.valid_provider?("ollama")
    end

    test "returns false for invalid providers" do
      refute Provider.valid_provider?("invalid")
      refute Provider.valid_provider?(nil)
      refute Provider.valid_provider?(123)
    end
  end
end
```

### Phase 2: Extract Functional Core

#### Step 2.1: Create Temporal Query Module

**File to Create**:
- `lib/temporal_cookbook_ui/temporal/query.ex`

**Code**:
```elixir
defmodule TemporalCookbookUi.Temporal.Query do
  @moduledoc """
  Functional core for querying and parsing Temporal workflow data.

  This module contains pure functions for transforming Temporal CLI output
  into structured data. All functions are side-effect free and easily testable.
  """

  @doc """
  Parses workflow status from Temporal CLI describe output.

  ## Examples

      iex> Query.parse_status("Status: COMPLETED")
      "COMPLETED"

      iex> Query.parse_status("Some other output")
      "UNKNOWN"
  """
  def parse_status(cli_output) when is_binary(cli_output) do
    cond do
      String.contains?(cli_output, "Status: COMPLETED") or
      String.contains?(cli_output, "COMPLETED") ->
        "COMPLETED"

      String.contains?(cli_output, "Status: FAILED") or
      String.contains?(cli_output, "FAILED") ->
        "FAILED"

      String.contains?(cli_output, "Status: RUNNING") or
      String.contains?(cli_output, "RUNNING") ->
        "RUNNING"

      true ->
        "UNKNOWN"
    end
  end

  @doc """
  Extracts JSON result from Temporal CLI show output.

  ## Examples

      iex> Query.extract_result("Result: {\\"text\\": \\"hello\\"}")
      {:ok, %{"text" => "hello"}}

      iex> Query.extract_result("No result")
      {:ok, %{}}
  """
  def extract_result(cli_output) when is_binary(cli_output) do
    case find_json_in_output(cli_output) do
      nil -> {:ok, %{}}
      json_str -> Jason.decode(json_str)
    end
  end

  # Private helper functions

  defp find_json_in_output(output) do
    # Try to find "Result: {...}" pattern first
    case Regex.run(~r/Result[:\s]+(\{.*\})/s, output) do
      [_, json_str] -> json_str
      _ -> find_any_json(output)
    end
  end

  defp find_any_json(output) do
    case Regex.run(~r/\{[\s\S]*\}/, output) do
      [json_str] -> json_str
      _ -> nil
    end
  end
end
```

#### Step 2.2: Update Temporal Client

**File to Update**:
- `lib/temporal_cookbook_ui/temporal/client.ex`

**Changes**:
```elixir
defmodule TemporalCookbookUi.Temporal.Client do
  @moduledoc """
  Temporal gRPC client wrapper for starting workflows and querying execution state.

  This module provides a high-level boundary interface to Temporal's CLI,
  delegating parsing logic to the Temporal.Query module.
  """

  alias TemporalCookbookUi.Temporal.Query

  # ... existing start_workflow/4 remains unchanged ...

  @doc """
  Describes a workflow execution, returning status and metadata.

  ## Parameters
  - `workflow_id`: The workflow ID
  - `run_id`: The workflow run ID (optional)

  ## Returns
  - `{:ok, %{status: string, raw_output: string}}` on success
  - `{:error, reason}` on failure
  """
  def describe_workflow(workflow_id, run_id \\ nil) do
    cmd_args = build_describe_args(workflow_id, run_id)

    case System.cmd("temporal", cmd_args, stderr_to_stdout: true) do
      {output, 0} ->
        {:ok, %{
          status: Query.parse_status(output),
          raw_output: output
        }}

      {output, exit_code} ->
        {:error, {:temporal_cli_error, exit_code, output}}
    end
  end

  @doc """
  Gets workflow execution result.

  ## Parameters
  - `workflow_id`: The workflow ID
  - `run_id`: The workflow run ID (optional)

  ## Returns
  - `{:ok, result_map}` on success
  - `{:error, reason}` on failure
  """
  def get_workflow_result(workflow_id, run_id \\ nil) do
    cmd_args = build_show_args(workflow_id, run_id)

    case System.cmd("temporal", cmd_args, stderr_to_stdout: true) do
      {output, 0} -> Query.extract_result(output)
      {_, _} -> {:error, :workflow_not_completed}
    end
  end

  # Private helper functions

  defp build_describe_args(workflow_id, nil) do
    ["workflow", "describe", "--workflow-id", workflow_id]
  end

  defp build_describe_args(workflow_id, run_id) do
    ["workflow", "describe", "--workflow-id", workflow_id, "--run-id", run_id]
  end

  defp build_show_args(workflow_id, nil) do
    ["workflow", "show", "--workflow-id", workflow_id]
  end

  defp build_show_args(workflow_id, run_id) do
    ["workflow", "show", "--workflow-id", workflow_id, "--run-id", run_id]
  end
end
```

#### Step 2.3: Add Tests for Query Module

**File to Create**:
- `test/temporal_cookbook_ui/temporal/query_test.exs`

**Code**:
```elixir
defmodule TemporalCookbookUi.Temporal.QueryTest do
  use ExUnit.Case, async: true

  alias TemporalCookbookUi.Temporal.Query

  describe "parse_status/1" do
    test "parses COMPLETED status" do
      assert Query.parse_status("Status: COMPLETED") == "COMPLETED"
      assert Query.parse_status("Some text COMPLETED more text") == "COMPLETED"
    end

    test "parses FAILED status" do
      assert Query.parse_status("Status: FAILED") == "FAILED"
      assert Query.parse_status("FAILED with error") == "FAILED"
    end

    test "parses RUNNING status" do
      assert Query.parse_status("Status: RUNNING") == "RUNNING"
      assert Query.parse_status("Currently RUNNING") == "RUNNING"
    end

    test "returns UNKNOWN for unrecognized status" do
      assert Query.parse_status("Some random text") == "UNKNOWN"
      assert Query.parse_status("") == "UNKNOWN"
    end
  end

  describe "extract_result/1" do
    test "extracts JSON from Result: pattern" do
      output = ~s(Result: {"text": "hello", "tokens": 10})
      assert Query.extract_result(output) == {:ok, %{"text" => "hello", "tokens" => 10}}
    end

    test "extracts JSON from any location" do
      output = ~s(Some text {"text": "hello"} more text)
      assert Query.extract_result(output) == {:ok, %{"text" => "hello"}}
    end

    test "returns empty map when no JSON found" do
      output = "No JSON here"
      assert Query.extract_result(output) == {:ok, %{}}
    end

    test "handles invalid JSON gracefully" do
      output = "Result: {invalid json}"
      assert {:error, _} = Query.extract_result(output)
    end
  end
end
```

### Phase 3: Refactor Boundary Layer

**See detailed implementation above in Step 2.2**

Key changes:
- Move all `System.cmd` calls to `Client` module
- Use `Query` module for parsing
- Return structured data
- Add proper error handling

### Phase 4: LiveView CRC Refactoring

#### Step 4.1: Refactor PatternDetailLive

**File to Update**:
- `lib/temporal_cookbook_ui_web/live/pattern_detail_live.ex`

**Key Changes**:
```elixir
defmodule TemporalCookbookUiWeb.PatternDetailLive do
  use TemporalCookbookUiWeb, :live_view

  alias TemporalCookbookUiWeb.Components.WorkflowControls
  alias TemporalCookbookUi.Temporal.Client
  alias TemporalCookbookUi.LLM.Provider

  # ===== CONSTRUCTOR =====
  def mount(%{"pattern_id" => pattern_id}, _session, socket) do
    pattern = get_pattern_by_id(pattern_id)
    {:ok, assign(socket, pattern: pattern)}
  end

  # ===== REDUCERS =====
  def handle_event("start_workflow", params, socket) do
    # Build workflow request (converter)
    workflow_request = build_workflow_request(socket.assigns.pattern.id, params)

    # Execute workflow (boundary call)
    case Client.start_workflow(
      "litellm_workflow",
      workflow_request.workflow_id,
      workflow_request.input
    ) do
      {:ok, run_id} ->
        {:noreply, navigate_to_execution(socket, workflow_request, run_id)}

      {:error, reason} ->
        {:noreply, show_error(socket, reason)}
    end
  end

  # ===== CONVERTERS (Private) =====

  defp build_workflow_request(pattern_id, params) do
    %{
      pattern_id: pattern_id,
      workflow_id: generate_workflow_id(),
      input: %{
        "model" => Provider.model_for_provider(params["provider"] || "ollama"),
        "prompt" => params["prompt"] || "",
        "temperature" => parse_float(params["temperature"]),
        "max_tokens" => parse_integer(params["max_tokens"])
      }
      |> Enum.reject(fn {_k, v} -> is_nil(v) end)
      |> Map.new()
    }
  end

  defp generate_workflow_id do
    "litellm-#{System.system_time(:second)}-#{:rand.uniform(9999)}"
  end

  defp navigate_to_execution(socket, workflow_request, run_id) do
    pattern_id = socket.assigns.pattern.id
    workflow_id = workflow_request.workflow_id

    push_navigate(
      socket,
      to: ~p"/patterns/#{pattern_id}/executions/#{workflow_id}?run_id=#{run_id}"
    )
  end

  defp show_error(socket, reason) do
    socket
    |> put_flash(:error, "Failed to start workflow: #{inspect(reason)}")
    |> assign(:error, reason)
  end

  # Helper functions (could move to shared module)
  defp parse_float(nil), do: nil
  defp parse_float(str) when is_binary(str) do
    case Float.parse(str) do
      {float, _} -> float
      :error -> nil
    end
  end
  defp parse_float(float) when is_float(float), do: float
  defp parse_float(_), do: nil

  defp parse_integer(nil), do: nil
  defp parse_integer(str) when is_binary(str) do
    case Integer.parse(str) do
      {int, _} -> int
      :error -> nil
    end
  end
  defp parse_integer(int) when is_integer(int), do: int
  defp parse_integer(_), do: nil

  # ===== RENDER (Converter) =====
  def render(assigns) do
    ~H"""
    <!-- Existing render code unchanged -->
    """
  end

  # Data Access
  defp get_pattern_by_id(id) do
    # Existing implementation unchanged
  end
end
```

#### Step 4.2: Refactor ExecutionViewLive

**File to Update**:
- `lib/temporal_cookbook_ui_web/live/execution_view_live.ex`

**Key Changes**:
```elixir
defmodule TemporalCookbookUiWeb.ExecutionViewLive do
  use TemporalCookbookUiWeb, :live_view

  alias TemporalCookbookUi.Temporal.Client

  # ===== CONSTRUCTOR =====
  def mount(params, _session, socket) do
    socket =
      socket
      |> assign(:pattern_id, params["pattern_id"])
      |> assign(:workflow_id, params["workflow_id"])
      |> assign(:run_id, extract_run_id(params))
      |> assign(:status, "RUNNING")
      |> assign(:result, nil)
      |> assign(:error, nil)
      |> assign(:loading, true)

    if connected?(socket), do: schedule_poll()

    {:ok, socket}
  end

  # ===== REDUCERS =====
  def handle_info(:poll_workflow, socket) do
    case fetch_workflow_status(socket) do
      {:ok, :completed, result} ->
        {:noreply, mark_completed(socket, result)}

      {:ok, :failed} ->
        {:noreply, mark_failed(socket)}

      {:ok, :running} ->
        schedule_poll()
        {:noreply, socket}

      {:ok, :unknown} ->
        schedule_poll()
        {:noreply, socket}
    end
  end

  # ===== CONVERTERS (Private) =====

  defp extract_run_id(params) do
    # Extract from query params or return nil
    case Map.get(params, "run_id") do
      nil -> nil
      run_id when is_binary(run_id) -> run_id
      _ -> nil
    end
  end

  defp fetch_workflow_status(socket) do
    workflow_id = socket.assigns.workflow_id
    run_id = socket.assigns.run_id

    case Client.describe_workflow(workflow_id, run_id) do
      {:ok, %{status: "COMPLETED"}} ->
        result = fetch_result(workflow_id, run_id)
        {:ok, :completed, result}

      {:ok, %{status: "FAILED"}} ->
        {:ok, :failed}

      {:ok, %{status: "RUNNING"}} ->
        {:ok, :running}

      {:ok, %{status: _}} ->
        {:ok, :unknown}

      {:error, _} ->
        {:ok, :running}  # Assume still running on error
    end
  end

  defp fetch_result(workflow_id, run_id) do
    case Client.get_workflow_result(workflow_id, run_id) do
      {:ok, result} -> result
      _ -> nil
    end
  end

  defp mark_completed(socket, result) do
    assign(socket,
      status: "COMPLETED",
      result: result,
      loading: false
    )
  end

  defp mark_failed(socket) do
    assign(socket,
      status: "FAILED",
      error: "Workflow execution failed",
      loading: false
    )
  end

  defp schedule_poll do
    Process.send_after(self(), :poll_workflow, 2000)
  end

  # ===== RENDER (Converter) =====
  def render(assigns) do
    ~H"""
    <!-- Existing render code unchanged -->
    """
  end
end
```

### Phase 5: Context Layer

**File to Create**:
- `lib/temporal_cookbook_ui/llm.ex`

**Code**:
```elixir
defmodule TemporalCookbookUi.LLM do
  @moduledoc """
  The LLM context - boundary API for LLM provider operations.
  """

  alias TemporalCookbookUi.LLM.Provider

  @doc """
  Gets the model string for a provider name.
  """
  defdelegate model_for_provider(provider), to: Provider

  @doc """
  Lists all available provider names.
  """
  defdelegate available_providers(), to: Provider

  @doc """
  Validates a provider name.
  """
  defdelegate valid_provider?(provider), to: Provider
end
```

## Testing Strategy

### Unit Tests (Functional Core)
- `LLM.Provider` - All pure functions
- `Temporal.Query` - All parsing functions
- Helper functions in LiveViews

### Integration Tests (Boundary Layer)
- `Temporal.Client` - CLI interactions (consider mocking)
- Context modules - API surface

### Feature Tests (LiveView)
- User workflows end-to-end
- Navigation flows
- Error handling

## Migration Checklist

- [ ] Phase 1: Domain Separation
  - [ ] Create `LLM.Provider` module
  - [ ] Update all imports
  - [ ] Delete old `ProviderConfig` module
  - [ ] Add unit tests
  - [ ] Run full test suite

- [ ] Phase 2: Extract Functional Core
  - [ ] Create `Temporal.Query` module
  - [ ] Update `Temporal.Client` to use `Query`
  - [ ] Add unit tests for `Query`
  - [ ] Run full test suite

- [ ] Phase 3: Refactor Boundary Layer
  - [ ] Add new `Client` methods
  - [ ] Update return types to structured data
  - [ ] Add integration tests
  - [ ] Run full test suite

- [ ] Phase 4: LiveView CRC Refactoring
  - [ ] Refactor `PatternDetailLive`
  - [ ] Refactor `ExecutionViewLive`
  - [ ] Add LiveView tests
  - [ ] Manual testing of UI flows

- [ ] Phase 5: Context Layer
  - [ ] Create `LLM` context
  - [ ] Update LiveView imports to use contexts
  - [ ] Add context tests
  - [ ] Final integration testing

## Success Criteria

1. **All tests passing** after each phase
2. **No regression** in functionality
3. **Improved code organization** - clear separation of concerns
4. **Better testability** - pure functions isolated from side effects
5. **Documentation** - all modules have clear moduledocs
6. **Performance** - no degradation in UI responsiveness

## References

- **OTP Patterns**: `/Users/joeszodfridt/src/ai/apps/elixir-expert-mcp/knowledge/otp-patterns/`
- **Programming Phoenix LiveView**: CRC pattern (Constructors, Reducers, Converters)
- **Designing Elixir Systems with OTP**: Layered architecture (Data, Functions, Tests, Boundaries, Lifecycle, Workers)

## Notes

- This refactoring can be done incrementally - each phase is independently valuable
- Feature 2 (LiteLLM Pattern) functionality remains unchanged throughout
- Focus on one phase at a time to minimize risk
- Each phase should include tests and be merged separately if desired
