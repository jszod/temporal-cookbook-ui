defmodule TemporalCookbookUiWeb.PatternDetailLive do
  use TemporalCookbookUiWeb, :live_view

  # Construct
  def mount(%{"pattern_id" => pattern_id}, _session, socket) do
    pattern = get_pattern_by_id(pattern_id)
    {:ok, assign(socket, pattern: pattern)}
  end

  # Reducers
  def handle_event("start_workflow", _params, socket) do
    pattern_id = socket.assigns.pattern.id
    # Generate mock workflow ID for Feature 001
    workflow_id = "mock-wf-#{:rand.uniform(9999)}"

    {:noreply, push_navigate(socket, to: ~p"/patterns/#{pattern_id}/executions/#{workflow_id}")}
  end

  # Convertor
  def render(assigns) do
    ~H"""
    <div class="mx-auto max-w-7xl px-4 sm:px-6 lg:px-8">
      <div class="py-8">
        <.link navigate={~p"/"} class="text-blue-600 hover:text-blue-800 mb-4 inline-block">
          ← Back to Catalog
        </.link>

        <h1 class="text-3xl font-bold text-gray-900 mt-4">{@pattern.name}</h1>
        <p class="mt-2 text-gray-600">{@pattern.description}</p>

        <%= if Map.has_key?(@pattern, :complexity) do %>
          <span class="mt-4 inline-block px-3 py-1 text-sm font-medium text-blue-700 bg-blue-100 rounded-full">
            {Map.get(@pattern, :complexity)}
          </span>
        <% end %>
      </div>

      <div class="bg-white rounded-lg shadow p-6 mt-6">
        <h2 class="text-xl font-semibold text-gray-900 mb-4">Pattern Details</h2>
        <p class="text-gray-600">This is a placeholder for pattern-specific content.</p>

        <div class="mt-6">
          <button
            phx-click="start_workflow"
            class="px-4 py-2 bg-blue-600 text-white rounded hover:bg-blue-700"
          >
            Start Workflow
          </button>
        </div>
      </div>
    </div>
    """
  end

  # Data Access
  defp get_pattern_by_id(id) do
    # Mock data - will be replaced with actual data later
    patterns = [
      %{
        id: "1",
        name: "Hello World Litellm",
        description: "Use Litellm to provide AI capabilities within your Temporal workflows.",
        complexity: "Easy"
      },
      %{id: "2", name: "Pattern B", description: "Description for Pattern B"},
      %{id: "3", name: "Pattern C", description: "Description for Pattern C"}
    ]

    Enum.find(patterns, fn p -> p.id == id end) ||
      %{
        id: id,
        name: "Unknown Pattern",
        description: "Pattern not found"
      }
  end
end
