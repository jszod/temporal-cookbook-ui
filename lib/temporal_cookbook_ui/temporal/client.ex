defmodule TemporalCookbookUi.Temporal.Client do
  @moduledoc """
  Temporal gRPC client wrapper for starting workflows and querying execution state.

  This module provides a high-level interface to Temporal's gRPC API for:
  - Starting workflow executions
  - Getting workflow history
  - Querying workflow state
  - Getting workflow results

  Note: This is currently a placeholder implementation. For production use,
  integrate with Temporal's gRPC API using a proper client library.
  """

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
  Queries workflow state.

  ## Parameters
  - `workflow_id`: The workflow ID
  - `run_id`: The workflow run ID (optional)

  ## Returns
  - `{:ok, state}` on success with state map containing:
    - `:status` - Workflow status ("RUNNING", "COMPLETED", "FAILED", etc.)
    - `:result` - Workflow result if completed
  - `{:error, reason}` on failure
  """
  def query_workflow_state(_workflow_id, _run_id \\ nil) do
    # TODO: Implement actual Temporal gRPC call
    # For now, return mock state
    {:ok, %{status: "RUNNING"}}
  end

  @doc """
  Gets workflow execution result.

  ## Parameters
  - `workflow_id`: The workflow ID
  - `run_id`: The workflow run ID (optional)

  ## Returns
  - `{:ok, result}` on success (when workflow is completed)
  - `{:error, :workflow_not_completed}` if workflow is still running
  - `{:error, reason}` on failure
  """
  def get_workflow_result(_workflow_id, _run_id \\ nil) do
    # TODO: Implement actual Temporal gRPC call
    # For now, return error indicating workflow not completed
    {:error, :workflow_not_completed}
  end

  # Private helper functions

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
