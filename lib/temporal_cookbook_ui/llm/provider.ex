defmodule TemporalCookbookUi.Llm.Provider do
  @moduledoc """
   Provider configuration for mapping provider names to LiteLLM model strings.

  This module handles the mapping between UI provider selection and the actual
  model strings used by LiteLLM.
  """
  @provider_models %{
    "openai" => "gpt-3.5-turbo",
    "ollama" => "ollama/gemma3:latest"
  }

  @doc """
  Returns the model string for a given provider.

  Returns `nil` if the provider is not found or if the input is not a string.
  """
  def model_for_provider(provider) when is_binary(provider) do
    Map.get(@provider_models, String.downcase(provider))
  end

  def model_for_provider(_), do: nil

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

  Returns `false` if the provider is not found or if the input is not a string.
  """
  def valid_provider?(provider) when is_binary(provider) do
    Map.has_key?(@provider_models, String.downcase(provider))
  end

  def valid_provider?(_), do: false
end
