defmodule TemporalCookbookUiWeb.ExecutionViewLive do
  use TemporalCookbookUiWeb, :live_view

  alias TemporalCookbookUi.Temporal.Client

  # ===== CONSTRUCTOR =====
  # Constructors initialize state from params and session.
  def mount(params, _session, socket) do
    pattern_id = params["pattern_id"]
    workflow_id = params["workflow_id"]

    # Extract run_id from URI query params (converter)
    run_id = extract_run_id(socket)

    # Initialize socket with default state
    socket =
      assign(socket,
        pattern_id: pattern_id,
        workflow_id: workflow_id,
        run_id: run_id,
        status: "RUNNING",
        result: nil,
        error: nil,
        loading: true
      )

    # Start polling if connected
    if connected?(socket) do
      schedule_poll()
    end

    {:ok, socket}
  end

  # ===== REDUCERS =====
  # Reducers transform state based on events.
  # They should be thin and delegate to converters for data transformation.
  def handle_info(:poll_workflow, socket) do
    # Fetch workflow status using converter
    case fetch_workflow_status(socket) do
      {:ok, :completed, result} ->
        # Workflow completed, mark as completed (converter)
        {:noreply, mark_completed(socket, result)}

      {:ok, :failed} ->
        # Workflow failed, mark as failed (converter)
        {:noreply, mark_failed(socket)}

      {:ok, :running} ->
        # Still running, continue polling
        schedule_poll()
        {:noreply, assign(socket, status: "RUNNING")}

      {:ok, :unknown} ->
        # Unknown status, continue polling
        schedule_poll()
        {:noreply, socket}
    end
  end

  # ===== CONVERTERS =====
  # Converters transform data for presentation or state updates.
  # They are pure functions (no side effects) that format data.

  defp extract_run_id(socket) do
    # Extract run_id from URI query params
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

  defp fetch_workflow_status(socket) do
    # Fetch workflow status from boundary layer
    workflow_id = socket.assigns.workflow_id
    run_id = socket.assigns.run_id

    opts = if run_id, do: [run_id: run_id], else: []

    case Client.describe_workflow(workflow_id, opts) do
      {:ok, %{status: "COMPLETED"}} ->
        # Workflow completed, fetch result
        result = fetch_result(workflow_id, opts)
        {:ok, :completed, result}

      {:ok, %{status: "FAILED"}} ->
        {:ok, :failed}

      {:ok, %{status: "RUNNING"}} ->
        {:ok, :running}

      {:ok, %{status: _}} ->
        {:ok, :unknown}

      {:error, _reason} ->
        # Error describing workflow, assume still running
        {:ok, :running}
    end
  end

  defp fetch_result(workflow_id, opts) do
    # Fetch workflow result from boundary layer
    case Client.get_workflow_result(workflow_id, opts) do
      {:ok, result} -> result
      {:error, _reason} -> %{}
    end
  end

  defp mark_completed(socket, result) do
    # Mark workflow as completed and update socket state
    assign(socket,
      status: "COMPLETED",
      result: result,
      loading: false
    )
  end

  defp mark_failed(socket) do
    # Mark workflow as failed and update socket state
    assign(socket,
      status: "FAILED",
      error: "Workflow execution failed",
      loading: false
    )
  end

  defp schedule_poll do
    # Schedule next poll (side effect, but isolated)
    Process.send_after(self(), :poll_workflow, 2000)
  end

  # ===== RENDER (Final Converter) =====
  # The render function is the final converter that formats all data for display.
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
end
