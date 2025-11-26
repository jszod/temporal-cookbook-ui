defmodule TemporalCookbookUi.Temporal.ProviderConfig do
  @moduledoc """
  Provider configuration for mapping provider names to LiteLLM model strings.

  This module handles the mapping between UI provider selection and the actual
  model strings used by LiteLLM. The mapping is kept in the Elixir/Phoenix layer
  to maintain separation of concerns - the Python worker receives model strings
  directly and doesn't need to know about "providers".
  """

  @provider_models %{
    "openai" => "gpt-3.5-turbo",
    "ollama" => "ollama/gemma3:latest"
  }

  @doc """
  Returns the default model string for a given provider.

  ## Examples

      iex> ProviderConfig.model_for_provider("openai")
      "gpt-3.5-turbo"

      iex> ProviderConfig.model_for_provider("anthropic")
      "claude-3-sonnet-20240229"
  """
  def model_for_provider(provider) when is_binary(provider) do
    Map.get(@provider_models, String.downcase(provider))
  end

  def model_for_provider(_) do
    nil
  end

  @doc """
  Returns a list of all available provider names.
  """
  def available_providers do
    Map.keys(@provider_models)
  end

  @doc """
  Returns all provider-to-model mappings.
  """
  def all_providers do
    @provider_models
  end

  @doc """
  Validates that a provider name is supported.
  """
  def valid_provider?(provider) when is_binary(provider) do
    Map.has_key?(@provider_models, String.downcase(provider))
  end

  def valid_provider?(_) do
    false
  end
end
