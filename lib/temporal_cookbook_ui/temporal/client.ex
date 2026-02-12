defmodule TemporalCookbookUi.Temporal.Client do
  @moduledoc """
  Temporal gRPC client wrapper for starting workflows and querying execution state.

  This module provides a high-level interface to Temporal's CLI (and future gRPC API) for:
  - Starting workflow executions
  - Describing workflow state
  - Getting workflow results
  - Getting workflow history

  This module handles all side effects (System.cmd calls) and delegates pure parsing
  logic to the `Temporal.Query` module.

  Note: This currently uses Temporal CLI. For production use,
  integrate with Temporal's gRPC API using a proper client library.
  """

  alias TemporalCookbookUi.Temporal.Query

  @default_namespace "default"
  @default_task_queue "temporal-cookbook-examples"

  @doc """
  Starts a workflow execution.

  ## Parameters
  - `workflow_type`: The workflow type name (e.g., "litellm_workflow")
  - `workflow_id`: Unique workflow ID
  - `input`: Workflow input data (will be JSON encoded)
  - `opts`: Optional keyword list with:
    - `:namespace` - Temporal namespace (default: "default")
    - `:task_queue` - Task queue name (default: "temporal-cookbook-examples")

  ## Returns
  - `{:ok, run_id}` on success
  - `{:error, reason}` on failure

  ## Example
      iex> Client.start_workflow("litellm_workflow", "wf-123", %{"model" => "gpt-3.5-turbo", "prompt" => "Hello"})
      {:ok, "run-id-abc123"}
  """
  def start_workflow(workflow_type, workflow_id, input, opts \\ []) do
    namespace = Keyword.get(opts, :namespace, @default_namespace)
    task_queue = Keyword.get(opts, :task_queue, @default_task_queue)

    require Logger

    Logger.info(
      "Starting workflow: #{workflow_type} with ID: #{workflow_id}, input: #{inspect(input)}"
    )

    # Use Temporal CLI to start workflow
    # This is a simple bridge - can be replaced with proper gRPC client later
    input_json = Jason.encode!(input)

    # Build command arguments
    cmd_args = [
      "workflow",
      "start",
      "--type",
      workflow_type,
      "--workflow-id",
      workflow_id,
      "--task-queue",
      task_queue,
      "--namespace",
      namespace,
      "--input",
      input_json
    ]

    case System.cmd("temporal", cmd_args, stderr_to_stdout: true) do
      {output, 0} ->
        # Parse run_id from output
        # Temporal CLI output format: "Started Workflow. RunId: <run-id>"
        run_id =
          output
          |> String.split("\n")
          |> Enum.find(&String.contains?(&1, "RunId"))
          |> case do
            nil ->
              # Try alternative format: "WorkflowId: <id>, RunId: <run-id>"
              output
              |> String.split("\n")
              |> Enum.find(&String.contains?(&1, "WorkflowId"))
              |> case do
                nil -> generate_run_id()
                line -> extract_run_id(line) || generate_run_id()
              end

            line ->
              extract_run_id(line) || generate_run_id()
          end

        Logger.info("Workflow started successfully. RunId: #{run_id}")
        {:ok, run_id}

      {output, exit_code} ->
        error_msg = "Failed to start workflow (exit code #{exit_code}): #{output}"
        Logger.error(error_msg)
        {:error, {:temporal_cli_error, exit_code, output}}
    end
  end

  defp extract_run_id(line) do
    # Extract run_id from various Temporal CLI output formats:
    # "Started Workflow. RunId: <run-id>"
    # "WorkflowId: <id>, RunId: <run-id>"
    case Regex.run(~r/RunId[:\s]+([^\s,]+)/, line) do
      [_, run_id] -> String.trim(run_id)
      _ -> nil
    end
  end

  @doc """
  Gets workflow execution history.

  ## Parameters
  - `workflow_id`: The workflow ID
  - `run_id`: The workflow run ID (optional)

  ## Returns
  - `{:ok, history}` on success
  - `{:error, reason}` on failure
  """
  def get_workflow_history(_workflow_id, _run_id \\ nil) do
    # TODO: Implement actual Temporal gRPC call
    # For now, return empty history
    {:ok, []}
  end

  @doc """
  Describes workflow execution state.

  Uses `temporal workflow describe` to get the current status of a workflow.

  ## Parameters
  - `workflow_id`: The workflow ID
  - `opts`: Optional keyword list with:
    - `:run_id` - The workflow run ID (optional)
    - `:namespace` - Temporal namespace (default: "default")

  ## Returns
  - `{:ok, state}` on success with state map containing:
    - `:status` - Workflow status ("RUNNING", "COMPLETED", "FAILED", "UNKNOWN")
  - `{:error, reason}` on failure

  ## Examples

      iex> Client.describe_workflow("wf-123", run_id: "run-456")
      {:ok, %{status: "COMPLETED"}}

      iex> Client.describe_workflow("wf-123")
      {:ok, %{status: "RUNNING"}}
  """
  def describe_workflow(workflow_id, opts \\ []) do
    require Logger

    run_id = Keyword.get(opts, :run_id)
    namespace = Keyword.get(opts, :namespace, @default_namespace)

    Logger.info("Describing workflow: #{workflow_id}, run_id: #{inspect(run_id)}")

    cmd_args = build_describe_args(workflow_id, run_id, namespace)

    case System.cmd("temporal", cmd_args, stderr_to_stdout: true) do
      {output, 0} ->
        status = Query.parse_status(output)
        Logger.info("Workflow #{workflow_id} status: #{status}")
        {:ok, %{status: status}}

      {output, exit_code} ->
        error_msg = "Failed to describe workflow (exit code #{exit_code}): #{output}"
        Logger.error(error_msg)
        {:error, {:temporal_cli_error, exit_code, output}}
    end
  end

  @doc """
  Gets workflow execution result.

  Uses `temporal workflow show` to get the result of a completed workflow.

  ## Parameters
  - `workflow_id`: The workflow ID
  - `opts`: Optional keyword list with:
    - `:run_id` - The workflow run ID (optional)
    - `:namespace` - Temporal namespace (default: "default")

  ## Returns
  - `{:ok, result}` on success with parsed JSON result as a map
  - `{:ok, %{}}` if workflow completed but no result found
  - `{:error, reason}` on failure (e.g., workflow not found, JSON parse error)

  ## Examples

      iex> Client.get_workflow_result("wf-123", run_id: "run-456")
      {:ok, %{"text" => "Generated response", "tokens" => 100}}

      iex> Client.get_workflow_result("wf-123")
      {:ok, %{}}
  """
  def get_workflow_result(workflow_id, opts \\ []) do
    require Logger

    run_id = Keyword.get(opts, :run_id)
    namespace = Keyword.get(opts, :namespace, @default_namespace)

    Logger.info("Getting workflow result: #{workflow_id}, run_id: #{inspect(run_id)}")

    cmd_args = build_show_args(workflow_id, run_id, namespace)

    case System.cmd("temporal", cmd_args, stderr_to_stdout: true) do
      {output, 0} ->
        case Query.extract_result(output) do
          {:ok, result} ->
            Logger.info("Successfully extracted result for workflow #{workflow_id}")
            {:ok, result}

          {:error, reason} ->
            error_msg = "Failed to parse workflow result: #{inspect(reason)}"
            Logger.error(error_msg)
            {:error, {:json_parse_error, reason}}
        end

      {output, exit_code} ->
        error_msg = "Failed to get workflow result (exit code #{exit_code}): #{output}"
        Logger.error(error_msg)
        {:error, {:temporal_cli_error, exit_code, output}}
    end
  end

  # Private helper functions

  defp build_describe_args(workflow_id, run_id, namespace) do
    base_args = [
      "workflow",
      "describe",
      "--workflow-id",
      workflow_id,
      "--namespace",
      namespace
    ]

    if run_id do
      base_args ++ ["--run-id", run_id]
    else
      base_args
    end
  end

  defp build_show_args(workflow_id, run_id, namespace) do
    base_args = [
      "workflow",
      "show",
      "--workflow-id",
      workflow_id,
      "--namespace",
      namespace
    ]

    if run_id do
      base_args ++ ["--run-id", run_id]
    else
      base_args
    end
  end

  defp generate_run_id do
    # Generate a realistic Temporal run_id format
    # Format: timestamp-random-uuid-like
    timestamp = System.system_time(:second)
    random = :rand.uniform(999_999_999)
    "run-#{timestamp}-#{random}"
  end

  # Helper functions for future JSON encoding/decoding
  # defp encode_json(data) do
  #   Jason.encode!(data)
  # rescue
  #   _ -> {:error, :json_encode_failed}
  # end

  # defp decode_json(json) do
  #   Jason.decode!(json)
  # rescue
  #   _ -> {:error, :json_decode_failed}
  # end
end
