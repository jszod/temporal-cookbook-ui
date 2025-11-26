defmodule TemporalCookbookUiWeb.ExecutionViewLive do
  use TemporalCookbookUiWeb, :live_view

  # Construct
  def mount(params, _session, socket) do
    pattern_id = params["pattern_id"]
    workflow_id = params["workflow_id"]

    # Get run_id from query params (passed in URL like ?run_id=xxx)
    run_id = get_run_id_from_uri(socket)

    if connected?(socket) do
      # Start polling for workflow status
      schedule_poll()
    end

    {:ok,
     assign(socket,
       pattern_id: pattern_id,
       workflow_id: workflow_id,
       run_id: run_id,
       status: "RUNNING",
       result: nil,
       error: nil,
       loading: true
     )}
  end

  defp get_run_id_from_uri(socket) do
    # Get run_id from URI query params
    case get_in(socket.assigns, [:uri, :query]) do
      nil ->
        nil

      query_string when is_binary(query_string) ->
        query_string
        |> URI.decode_query()
        |> Map.get("run_id")

      _ ->
        nil
    end
  end

  # Reducers
  def handle_info(:poll_workflow, socket) do
    # Poll workflow status
    case get_workflow_status(socket.assigns.workflow_id, socket.assigns.run_id) do
      {:ok, %{status: "COMPLETED", result: result}} ->
        # Workflow completed, stop polling
        {:noreply,
         assign(socket,
           status: "COMPLETED",
           result: result,
           loading: false
         )}

      {:ok, %{status: "FAILED"}} ->
        # Workflow failed, stop polling
        {:noreply,
         assign(socket,
           status: "FAILED",
           error: "Workflow execution failed",
           loading: false
         )}

      {:ok, %{status: "RUNNING"}} ->
        # Still running, poll again
        schedule_poll()
        {:noreply, assign(socket, status: "RUNNING")}

      {:ok, %{status: status}} ->
        # Unknown status, continue polling
        schedule_poll()
        {:noreply, assign(socket, status: status)}
    end
  end

  # Convertor
  def render(assigns) do
    ~H"""
    <div class="mx-auto max-w-7xl px-4 sm:px-6 lg:px-8 py-8">
      <.link navigate={~p"/patterns/#{@pattern_id}"} class="text-blue-600 hover:text-blue-800">
        ← Back to Pattern
      </.link>

      <div class="mt-6 bg-white rounded-lg shadow p-8">
        <div class="flex items-center justify-between mb-6">
          <div>
            <h1 class="text-2xl font-bold text-gray-900">Workflow Execution</h1>
            <p class="mt-2 text-gray-600">Workflow ID: {@workflow_id}</p>
            <%= if @run_id do %>
              <p class="text-sm text-gray-500">Run ID: {@run_id}</p>
            <% end %>
          </div>
          <div>
            <%= case @status do %>
              <% "RUNNING" -> %>
                <span class="px-3 py-1 text-sm font-medium text-yellow-800 bg-yellow-100 rounded-full">
                  Running
                </span>
              <% "COMPLETED" -> %>
                <span class="px-3 py-1 text-sm font-medium text-green-800 bg-green-100 rounded-full">
                  Completed
                </span>
              <% "FAILED" -> %>
                <span class="px-3 py-1 text-sm font-medium text-red-800 bg-red-100 rounded-full">
                  Failed
                </span>
              <% _ -> %>
                <span class="px-3 py-1 text-sm font-medium text-gray-800 bg-gray-100 rounded-full">
                  Unknown
                </span>
            <% end %>
          </div>
        </div>

        <%= if @loading and @status == "RUNNING" do %>
          <div class="mt-8 p-6 bg-blue-50 rounded-lg border border-blue-200">
            <div class="flex items-center">
              <svg
                class="animate-spin h-5 w-5 text-blue-600 mr-3"
                xmlns="http://www.w3.org/2000/svg"
                fill="none"
                viewBox="0 0 24 24"
              >
                <circle
                  class="opacity-25"
                  cx="12"
                  cy="12"
                  r="10"
                  stroke="currentColor"
                  stroke-width="4"
                >
                </circle>
                <path
                  class="opacity-75"
                  fill="currentColor"
                  d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"
                >
                </path>
              </svg>
              <p class="text-blue-800 font-medium">Workflow is running...</p>
            </div>
            <p class="mt-2 text-sm text-blue-600">Polling for status updates</p>
          </div>
        <% end %>

        <%= if @status == "COMPLETED" and @result do %>
          <div class="mt-8 space-y-6">
            <!-- LLM Response -->
            <div>
              <h2 class="text-lg font-semibold text-gray-900 mb-3">LLM Response</h2>
              <div class="p-4 bg-gray-50 rounded-lg border">
                <p class="text-gray-800 whitespace-pre-wrap">
                  {@result["text"] || "No response text"}
                </p>
              </div>
            </div>
            
    <!-- Metrics -->
            <div>
              <h2 class="text-lg font-semibold text-gray-900 mb-3">Metrics</h2>
              <div class="grid grid-cols-2 md:grid-cols-4 gap-4">
                <%= if @result["model"] do %>
                  <div class="p-3 bg-gray-50 rounded">
                    <p class="text-xs text-gray-500">Model</p>
                    <p class="text-sm font-medium text-gray-900">{@result["model"]}</p>
                  </div>
                <% end %>
                <%= if @result["total_tokens"] do %>
                  <div class="p-3 bg-gray-50 rounded">
                    <p class="text-xs text-gray-500">Total Tokens</p>
                    <p class="text-sm font-medium text-gray-900">{@result["total_tokens"]}</p>
                  </div>
                <% end %>
                <%= if @result["prompt_tokens"] do %>
                  <div class="p-3 bg-gray-50 rounded">
                    <p class="text-xs text-gray-500">Prompt Tokens</p>
                    <p class="text-sm font-medium text-gray-900">{@result["prompt_tokens"]}</p>
                  </div>
                <% end %>
                <%= if @result["completion_tokens"] do %>
                  <div class="p-3 bg-gray-50 rounded">
                    <p class="text-xs text-gray-500">Completion Tokens</p>
                    <p class="text-sm font-medium text-gray-900">{@result["completion_tokens"]}</p>
                  </div>
                <% end %>
                <%= if @result["latency_ms"] do %>
                  <div class="p-3 bg-gray-50 rounded">
                    <p class="text-xs text-gray-500">Latency</p>
                    <p class="text-sm font-medium text-gray-900">
                      {Float.round(@result["latency_ms"], 0)} ms
                    </p>
                  </div>
                <% end %>
              </div>
            </div>
          </div>
        <% end %>

        <%= if @status == "FAILED" do %>
          <div class="mt-8 p-6 bg-red-50 rounded-lg border border-red-200">
            <h2 class="text-lg font-semibold text-red-900 mb-2">Workflow Failed</h2>
            <p class="text-red-800">{@error || "Unknown error"}</p>
          </div>
        <% end %>
        
    <!-- Temporal UI Link -->
        <div class="mt-8 pt-6 border-t">
          <a
            href={"http://localhost:8233/namespaces/default/workflows/#{@workflow_id}"}
            target="_blank"
            class="text-blue-600 hover:text-blue-800 text-sm"
          >
            View in Temporal UI →
          </a>
        </div>
        
    <!-- Run Again Button -->
        <div class="mt-6">
          <.link
            navigate={~p"/patterns/#{@pattern_id}"}
            class="inline-block px-4 py-2 bg-blue-600 text-white rounded hover:bg-blue-700"
          >
            Run Again
          </.link>
        </div>
      </div>
    </div>
    """
  end

  # Helper functions
  defp schedule_poll do
    # Poll every 2 seconds
    Process.send_after(self(), :poll_workflow, 2000)
  end

  defp get_workflow_status(workflow_id, run_id) do
    # Use Temporal CLI to get workflow status
    # temporal workflow describe --workflow-id <id>
    cmd_args = [
      "workflow",
      "describe",
      "--workflow-id",
      workflow_id
    ]

    cmd_args = if run_id, do: cmd_args ++ ["--run-id", run_id], else: cmd_args

    case System.cmd("temporal", cmd_args, stderr_to_stdout: true) do
      {output, 0} ->
        # Parse status from output
        status = parse_workflow_status(output)

        # If completed, try to get result
        result =
          if status == "COMPLETED" do
            case get_workflow_result(workflow_id, run_id) do
              {:ok, r} -> r
              _ -> nil
            end
          else
            nil
          end

        {:ok, %{status: status, result: result}}

      {_output, _exit_code} ->
        # If describe fails, workflow might not exist or be accessible
        # Default to running state
        {:ok, %{status: "RUNNING", result: nil}}
    end
  end

  defp parse_workflow_status(output) do
    cond do
      String.contains?(output, "Status: COMPLETED") or String.contains?(output, "COMPLETED") ->
        "COMPLETED"

      String.contains?(output, "Status: FAILED") or String.contains?(output, "FAILED") ->
        "FAILED"

      String.contains?(output, "Status: RUNNING") or String.contains?(output, "RUNNING") ->
        "RUNNING"

      true ->
        # Default to running if we can't parse
        "RUNNING"
    end
  end

  defp get_workflow_result(workflow_id, run_id) do
    # Use Temporal CLI to get workflow result
    # temporal workflow show --workflow-id <id> --run-id <run-id>
    cmd_args = [
      "workflow",
      "show",
      "--workflow-id",
      workflow_id
    ]

    cmd_args = if run_id, do: cmd_args ++ ["--run-id", run_id], else: cmd_args

    case System.cmd("temporal", cmd_args, stderr_to_stdout: true) do
      {output, 0} ->
        # Try to extract result from output
        # Temporal CLI shows result in various formats
        result = extract_result_from_cli_output(output)
        {:ok, result}

      {_output, _exit_code} ->
        {:error, :workflow_not_completed}
    end
  end

  defp extract_result_from_cli_output(output) do
    # Try to find JSON result in output
    # Look for patterns like "Result: {...}" or JSON blocks
    case Regex.run(~r/Result[:\s]+(\{.*\})/s, output) do
      [_, json_str] ->
        case Jason.decode(json_str) do
          {:ok, result} -> result
          _ -> %{}
        end

      _ ->
        # Try to find any JSON object in output
        case Regex.run(~r/\{[\s\S]*\}/, output) do
          [json_str] ->
            case Jason.decode(json_str) do
              {:ok, result} -> result
              _ -> %{}
            end

          _ ->
            %{}
        end
    end
  end
end
