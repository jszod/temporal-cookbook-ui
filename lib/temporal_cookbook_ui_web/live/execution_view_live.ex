defmodule TemporalCookbookUiWeb.ExecutionViewLive do
  use TemporalCookbookUiWeb, :live_view

  alias TemporalCookbookUi.Temporal.Client

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
    # Poll workflow status using Client boundary layer
    workflow_id = socket.assigns.workflow_id
    run_id = socket.assigns.run_id

    opts = if run_id, do: [run_id: run_id], else: []

    case Client.describe_workflow(workflow_id, opts) do
      {:ok, %{status: "COMPLETED"}} ->
        # Workflow completed, fetch result
        case Client.get_workflow_result(workflow_id, opts) do
          {:ok, result} ->
            # Workflow completed with result, stop polling
            {:noreply,
             assign(socket,
               status: "COMPLETED",
               result: result,
               loading: false
             )}

          {:error, _reason} ->
            # Workflow completed but couldn't get result, stop polling anyway
            {:noreply,
             assign(socket,
               status: "COMPLETED",
               result: %{},
               loading: false
             )}
        end

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

      {:error, _reason} ->
        # Error describing workflow, continue polling (workflow might not be ready yet)
        schedule_poll()
        {:noreply, assign(socket, status: "RUNNING")}
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
end
