defmodule TemporalCookbookUiWeb.PatternDetailLive do
  use TemporalCookbookUiWeb, :live_view

  alias TemporalCookbookUiWeb.Components.WorkflowControls
  alias TemporalCookbookUi.Temporal.Client
  alias TemporalCookbookUi.Llm.Provider
  alias TemporalCookbookUiWeb.Live.Helpers

  # Construct
  def mount(%{"pattern_id" => pattern_id}, _session, socket) do
    pattern = get_pattern_by_id(pattern_id)
    {:ok, assign(socket, pattern: pattern)}
  end

  # ===== REDUCERS =====
  # Reducers transform state based on events.
  # They should be thin and delegate to converters for data transformation.
  def handle_event("start_workflow", params, socket) do
    # Build workflow request using converter
    workflow_request = build_workflow_request(socket.assigns.pattern.id, params)

    # Execute workflow via boundary layer (side effect)
    case Client.start_workflow(
           "litellm_workflow",
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

  defp build_workflow_request(pattern_id, params) do
    # Map provider to model string using provider config
    provider = Map.get(params, "provider", "ollama")
    model = Provider.model_for_provider(provider)
    prompt = Map.get(params, "prompt", "")
    temperature = Helpers.parse_float(params["temperature"])
    max_tokens = Helpers.parse_integer(params["max_tokens"])

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
      workflow_id: generate_workflow_id(),
      input: workflow_input
    }
  end

  defp generate_workflow_id do
    # Generate unique workflow ID
    "litellm-#{System.system_time(:second)}-#{:rand.uniform(9999)}"
  end

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

        <%= if Map.has_key?(@pattern, :complexity) do %>
          <span class="mt-4 inline-block px-3 py-1 text-sm font-medium text-blue-700 bg-blue-100 rounded-full">
            {Map.get(@pattern, :complexity)}
          </span>
        <% end %>
      </div>

      <div class="grid grid-cols-1 lg:grid-cols-2 gap-6 mt-6">
        <!-- Left Panel: Pattern Details -->
        <div class="bg-white rounded-lg shadow p-6">
          <h2 class="text-xl font-semibold text-gray-900 mb-4">Pattern Details</h2>
          <p class="text-gray-600">This is a placeholder for pattern-specific content.</p>
        </div>
        
    <!-- Right Panel: Workflow Controls -->
        <%= if @pattern.id == "1" do %>
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
