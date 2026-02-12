defmodule TemporalCookbookUiWeb.PatternDetailLive do
  use TemporalCookbookUiWeb, :live_view

  alias TemporalCookbookUiWeb.Components.WorkflowControls
  alias TemporalCookbookUi.Temporal.Client
  alias TemporalCookbookUi.Temporal.Workflow
  alias TemporalCookbookUi.Patterns.Pattern

  # Construct
  def mount(%{"pattern_id" => pattern_id}, _session, socket) do
    pattern = Pattern.get_by_id(pattern_id)
    {:ok, assign(socket, pattern: pattern)}
  end

  # ===== REDUCERS =====
  # Reducers transform state based on events.
  # They should be thin and delegate to converters for data transformation.
  def handle_event("start_workflow", params, socket) do
    # Build workflow request using functional core (Workflow module)
    workflow_request = Workflow.build_request(socket.assigns.pattern.id, params)

    # Execute workflow via boundary layer (side effect)
    case Client.start_workflow(
           socket.assigns.pattern.workflow_type,
           workflow_request.workflow_id,
           workflow_request.input
         ) do
      {:ok, run_id} ->
        # Navigate to execution view (converter)
        {:noreply, navigate_to_execution(socket, workflow_request, run_id)}

      {:error, reason} ->
        # Show error to user (converter)
        {:noreply, show_error(socket, reason)}
    end
  end

  # ===== CONVERTERS =====
  # Converters transform data for presentation or navigation.
  # They are pure functions (no side effects) that format data.

  defp navigate_to_execution(socket, workflow_request, run_id) do
    # Navigate to execution view with workflow_id and run_id
    pattern_id = workflow_request.pattern_id
    workflow_id = workflow_request.workflow_id

    push_navigate(
      socket,
      to: ~p"/patterns/#{pattern_id}/executions/#{workflow_id}?run_id=#{run_id}"
    )
  end

  defp show_error(socket, reason) do
    # Show error to user via flash message and socket assign
    socket
    |> put_flash(:error, "Failed to start workflow: #{inspect(reason)}")
    |> assign(:error, reason)
  end

  # ===== RENDER (Final Converter) =====
  # The render function is the final converter that formats all data for display.
  def render(assigns) do
    ~H"""
    <div class="mx-auto max-w-7xl px-4 sm:px-6 lg:px-8">
      <div class="py-8">
        <.link navigate={~p"/"} class="text-blue-600 hover:text-blue-800 mb-4 inline-block">
          ← Back to Catalog
        </.link>

        <h1 class="text-3xl font-bold text-gray-900 mt-4">{@pattern.name}</h1>
        <p class="mt-2 text-gray-600">{@pattern.description}</p>

        <span class="mt-4 inline-block px-3 py-1 text-sm font-medium text-blue-700 bg-blue-100 rounded-full">
          {@pattern.complexity}
        </span>
      </div>

      <div class="grid grid-cols-1 lg:grid-cols-2 gap-6 mt-6">
        <!-- Left Panel: Pattern Details -->
        <div class="bg-white rounded-lg shadow p-6">
          <h2 class="text-xl font-semibold text-gray-900 mb-4">Pattern Details</h2>

          <div class="flex flex-wrap gap-2 mb-4">
            <%= for tag <- @pattern.tags || [] do %>
              <span class="px-2 py-1 text-xs font-medium text-indigo-700 bg-indigo-100 rounded-full">
                {tag}
              </span>
            <% end %>
          </div>

          <%= if @pattern.use_cases && @pattern.use_cases != [] do %>
            <h3 class="text-sm font-semibold text-gray-700 mb-2">Use Cases</h3>
            <ul class="list-disc list-inside space-y-1">
              <%= for use_case <- @pattern.use_cases do %>
                <li class="text-gray-600 text-sm">{use_case}</li>
              <% end %>
            </ul>
          <% end %>
        </div>
        
    <!-- Right Panel: Workflow Controls -->
        <%= if @pattern.status == :available do %>
          <.live_component module={WorkflowControls} id="workflow-controls" />
        <% else %>
          <div class="bg-white rounded-lg shadow p-6">
            <h2 class="text-xl font-semibold text-gray-900 mb-4">Workflow Controls</h2>
            <p class="text-gray-600">Workflow controls for this pattern coming soon.</p>
          </div>
        <% end %>
      </div>
    </div>
    """
  end
end
