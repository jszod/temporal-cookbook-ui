defmodule TemporalCookbookUiWeb.ExecutionViewLive do
  use TemporalCookbookUiWeb, :live_view

  # Construct
  def mount(%{"pattern_id" => pattern_id, "workflow_id" => workflow_id}, _session, socket) do
    {:ok,
     assign(socket,
       pattern_id: pattern_id,
       workflow_id: workflow_id
     )}
  end

  # Reducers

  # Convertor
  def render(assigns) do
    ~H"""
    <div class="mx-auto max-w-7xl px-4 sm:px-6 lg:px-8 py-8">
      <.link navigate={~p"/patterns/#{@pattern_id}"} class="text-blue-600 hover:text-blue-800">
        ← Back to Pattern
      </.link>

      <div class="mt-6 bg-white rounded-lg shadow p-8 text-center">
        <h1 class="text-2xl font-bold text-gray-900">Workflow Execution</h1>
        <p class="mt-2 text-gray-600">Workflow ID: {@workflow_id}</p>

        <div class="mt-8 p-6 bg-gray-50 rounded">
          <p class="text-gray-700">
            Execution view coming soon! This will show:
          </p>
          <ul class="mt-4 text-left max-w-md mx-auto space-y-2 text-gray-600">
            <li>• Real-time workflow status</li>
            <li>• AI-specific metrics (tokens, cost, latency)</li>
            <li>• LLM response preview</li>
            <li>• Link to detailed Temporal UI</li>
          </ul>
        </div>

        <div class="mt-6 text-sm text-gray-500">
          <p>Full implementation: Features 2-7</p>
        </div>
      </div>
    </div>
    """
  end
end
