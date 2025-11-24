defmodule TemporalCookbookUiWeb.PatternCatalogLive do
  use TemporalCookbookUiWeb, :live_view

  # Construct
  def mount(_params, _session, socket) do
    {:ok, assign(socket, patterns: mock_patterns())}
  end

  # Reducers

  # Convertor
  def render(assigns) do
    ~H"""
    <div class="mx-auto max-w-7xl px-4 sm:px-6 lg:px-8">
      <div class="py-8">
        <h1 class="text-3xl font-bold text-gray-900">Temporal AI Cookbook Patterns</h1>
        <p class="mt-2 text-gray-600">Explore interactive examples of Temporal workflow patterns</p>
      </div>

      <div class="grid grid-cols-1 gap-6 sm:grid-cols-2 lg:grid-cols-3">
        <%= for pattern <- @patterns do %>
          <.link navigate={~p"/patterns/#{pattern.id}"} class="block">
            <div class="bg-white rounded-lg shadow p-6 hover:shadow-lg transition-shadow cursor-pointer">
              <h2 class="text-xl font-semibold text-gray-900">{pattern.name}</h2>
              <p class="mt-2 text-gray-600">{pattern.description}</p>
              <%= if Map.has_key?(pattern, :complexity) do %>
                <span class="mt-4 inline-block px-3 py-1 text-sm font-medium text-blue-700 bg-blue-100 rounded-full">
                  {pattern.complexity}
                </span>
              <% end %>
            </div>
          </.link>
        <% end %>
      </div>
    </div>
    """
  end

  defp mock_patterns do
    [
      %{
        id: 1,
        name: "Hello World Litellm",
        description: "Use Litellm to provide AI capabilities within your Temporal workflows.",
        complexity: "Easy"
      },
      %{id: 2, name: "Pattern B", description: "Description for Pattern B"},
      %{id: 3, name: "Pattern C", description: "Description for Pattern C"}
    ]
  end
end
