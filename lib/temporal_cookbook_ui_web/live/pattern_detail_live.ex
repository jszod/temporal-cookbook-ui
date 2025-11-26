defmodule TemporalCookbookUiWeb.PatternDetailLive do
  use TemporalCookbookUiWeb, :live_view

  alias TemporalCookbookUiWeb.Components.WorkflowControls
  alias TemporalCookbookUi.Temporal.Client
  alias TemporalCookbookUi.Temporal.ProviderConfig

  # Construct
  def mount(%{"pattern_id" => pattern_id}, _session, socket) do
    pattern = get_pattern_by_id(pattern_id)
    {:ok, assign(socket, pattern: pattern)}
  end

  # Reducers
  def handle_event("start_workflow", params, socket) do
    pattern_id = socket.assigns.pattern.id

    # Map provider to model string using provider config
    provider = Map.get(params, "provider", "ollama")
    model = ProviderConfig.model_for_provider(provider)
    prompt = Map.get(params, "prompt", "")
    temperature = parse_float(params["temperature"])
    max_tokens = parse_integer(params["max_tokens"])

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

    # Generate unique workflow ID
    workflow_id = "litellm-#{System.system_time(:second)}-#{:rand.uniform(9999)}"

    # Start workflow via Temporal client
    case Client.start_workflow("litellm_workflow", workflow_id, workflow_input) do
      {:ok, run_id} ->
        # Navigate to execution view with workflow_id and run_id
        {:noreply,
         push_navigate(
           socket,
           to: ~p"/patterns/#{pattern_id}/executions/#{workflow_id}?run_id=#{run_id}"
         )}

      {:error, reason} ->
        # Show error to user
        {:noreply,
         socket
         |> put_flash(:error, "Failed to start workflow: #{inspect(reason)}")
         |> assign(:error, reason)}
    end
  end

  # Helper functions
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
