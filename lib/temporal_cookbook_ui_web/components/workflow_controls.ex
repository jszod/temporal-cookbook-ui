defmodule TemporalCookbookUiWeb.Components.WorkflowControls do
  @moduledoc """
  LiveComponent for workflow input controls (provider selection, prompt input, parameters).

  This component handles the UI for selecting LLM providers, entering prompts,
  and adjusting parameters. It maps provider names to model strings before
  sending workflow input to Temporal.
  """
  use TemporalCookbookUiWeb, :live_component

  alias TemporalCookbookUi.LLM.Provider

  @impl true
  def mount(socket) do
    {:ok,
     socket
     |> assign(:provider, "ollama")
     |> assign(:prompt, "")
     |> assign(:temperature, 0.7)
     |> assign(:max_tokens, 500)}
  end

  @impl true
  def update(assigns, socket) do
    {:ok, assign(socket, assigns)}
  end

  @impl true
  def handle_event("change_provider", %{"provider" => provider}, socket) do
    {:noreply, assign(socket, :provider, provider)}
  end

  def handle_event("change_prompt", %{"prompt" => prompt}, socket) do
    {:noreply, assign(socket, :prompt, prompt)}
  end

  def handle_event("change_temperature", %{"temperature" => temp_str}, socket) do
    temperature =
      case Float.parse(temp_str) do
        {temp, _} when temp >= 0.0 and temp <= 2.0 -> temp
        _ -> socket.assigns.temperature
      end

    {:noreply, assign(socket, :temperature, temperature)}
  end

  def handle_event("change_max_tokens", %{"max_tokens" => tokens_str}, socket) do
    max_tokens =
      case Integer.parse(tokens_str) do
        {tokens, _} when tokens > 0 -> tokens
        _ -> socket.assigns.max_tokens
      end

    {:noreply, assign(socket, :max_tokens, max_tokens)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="bg-white rounded-lg shadow p-6">
      <h2 class="text-xl font-semibold text-gray-900 mb-4">Workflow Controls</h2>

      <form phx-change="validate" phx-target={@myself}>
        <!-- Provider Selection -->
        <div class="mb-4">
          <label for="provider" class="block text-sm font-medium text-gray-700 mb-2">
            Provider
          </label>
          <select
            id="provider"
            name="provider"
            phx-change="change_provider"
            phx-target={@myself}
            class="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-blue-500 focus:border-blue-500"
          >
            <%= for provider <- Provider.available_providers() do %>
              <option value={provider} selected={@provider == provider}>
                {String.capitalize(provider)}
              </option>
            <% end %>
          </select>
        </div>
        
    <!-- Prompt Input -->
        <div class="mb-4">
          <label for="prompt" class="block text-sm font-medium text-gray-700 mb-2">
            Prompt
          </label>
          <textarea
            id="prompt"
            name="prompt"
            rows="4"
            phx-change="change_prompt"
            phx-target={@myself}
            placeholder="Enter your prompt here..."
            class="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-blue-500 focus:border-blue-500"
          >{@prompt}</textarea>
        </div>
        
    <!-- Temperature Slider -->
        <div class="mb-4">
          <label for="temperature" class="block text-sm font-medium text-gray-700 mb-2">
            Temperature: <span class="font-normal text-gray-600">{@temperature}</span>
          </label>
          <input
            type="range"
            id="temperature"
            name="temperature"
            min="0.0"
            max="2.0"
            step="0.1"
            value={@temperature}
            phx-change="change_temperature"
            phx-target={@myself}
            class="w-full"
          />
          <div class="flex justify-between text-xs text-gray-500 mt-1">
            <span>0.0</span>
            <span>1.0</span>
            <span>2.0</span>
          </div>
        </div>
        
    <!-- Max Tokens Input -->
        <div class="mb-6">
          <label for="max_tokens" class="block text-sm font-medium text-gray-700 mb-2">
            Max Tokens
          </label>
          <input
            type="number"
            id="max_tokens"
            name="max_tokens"
            min="1"
            max="4000"
            value={@max_tokens}
            phx-change="change_max_tokens"
            phx-target={@myself}
            class="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-blue-500 focus:border-blue-500"
          />
        </div>
        
    <!-- Run Workflow Button -->
        <button
          type="button"
          phx-click="start_workflow"
          phx-value-provider={@provider}
          phx-value-prompt={@prompt}
          phx-value-temperature={@temperature}
          phx-value-max_tokens={@max_tokens}
          disabled={@prompt == ""}
          class="w-full px-4 py-2 bg-blue-600 text-white rounded hover:bg-blue-700 disabled:bg-gray-400 disabled:cursor-not-allowed"
        >
          Run Workflow
        </button>
      </form>
    </div>
    """
  end

  @doc """
  Maps provider name to model string for workflow input.
  This is called by the parent LiveView when starting a workflow.
  """
  def model_for_provider(provider) do
    TemporalCookbookUi.LLM.Provider.model_for_provider(provider)
  end
end
