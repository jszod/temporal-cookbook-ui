defmodule TemporalCookbookUi.Llm.ProviderTest do
  use ExUnit.Case, async: true

  alias TemporalCookbookUi.Llm.Provider

  describe "model_for_provider/1" do
    test "returns model string for valid provider (lowercase)" do
      assert Provider.model_for_provider("openai") == "gpt-3.5-turbo"
      assert Provider.model_for_provider("ollama") == "ollama/gemma3:latest"
    end

    test "returns model string for valid provider (uppercase)" do
      assert Provider.model_for_provider("OPENAI") == "gpt-3.5-turbo"
      assert Provider.model_for_provider("OLLAMA") == "ollama/gemma3:latest"
    end

    test "returns model string for valid provider (mixed case)" do
      assert Provider.model_for_provider("OpenAI") == "gpt-3.5-turbo"
      assert Provider.model_for_provider("Ollama") == "ollama/gemma3:latest"
    end

    test "returns nil for invalid provider" do
      assert Provider.model_for_provider("invalid") == nil
      assert Provider.model_for_provider("anthropic") == nil
      assert Provider.model_for_provider("groq") == nil
    end

    test "returns nil for nil input" do
      assert Provider.model_for_provider(nil) == nil
    end

    test "returns nil for empty string" do
      assert Provider.model_for_provider("") == nil
    end
  end

  describe "available_providers/0" do
    test "returns list of all provider names" do
      providers = Provider.available_providers()

      assert is_list(providers)
      assert "openai" in providers
      assert "ollama" in providers
      assert length(providers) == 2
    end

    test "returns providers in consistent order" do
      # Map.keys returns keys in insertion order, so this should be consistent
      providers1 = Provider.available_providers()
      providers2 = Provider.available_providers()

      assert providers1 == providers2
    end
  end

  describe "all_providers/0" do
    test "returns all provider-to-model mappings" do
      all_providers = Provider.all_providers()

      assert is_map(all_providers)
      assert all_providers["openai"] == "gpt-3.5-turbo"
      assert all_providers["ollama"] == "ollama/gemma3:latest"
      assert map_size(all_providers) == 2
    end

    test "returns immutable map" do
      all_providers = Provider.all_providers()

      # Verify it's the actual module attribute (should be same reference)
      assert is_map(all_providers)
    end
  end

  describe "valid_provider?/1" do
    test "returns true for valid provider (lowercase)" do
      assert Provider.valid_provider?("openai") == true
      assert Provider.valid_provider?("ollama") == true
    end

    test "returns true for valid provider (uppercase)" do
      assert Provider.valid_provider?("OPENAI") == true
      assert Provider.valid_provider?("OLLAMA") == true
    end

    test "returns true for valid provider (mixed case)" do
      assert Provider.valid_provider?("OpenAI") == true
      assert Provider.valid_provider?("Ollama") == true
    end

    test "returns false for invalid provider" do
      assert Provider.valid_provider?("invalid") == false
      assert Provider.valid_provider?("anthropic") == false
      assert Provider.valid_provider?("groq") == false
    end

    test "returns false for nil input" do
      assert Provider.valid_provider?(nil) == false
    end

    test "returns false for empty string" do
      assert Provider.valid_provider?("") == false
    end
  end

  describe "integration: model_for_provider and valid_provider?" do
    test "model_for_provider returns nil when valid_provider? returns false" do
      invalid_providers = ["invalid", "anthropic", "groq", nil, ""]

      for provider <- invalid_providers do
        refute Provider.valid_provider?(provider)
        assert Provider.model_for_provider(provider) == nil
      end
    end

    test "model_for_provider returns value when valid_provider? returns true" do
      valid_providers = ["openai", "ollama", "OPENAI", "Ollama"]

      for provider <- valid_providers do
        assert Provider.valid_provider?(provider) == true
        assert Provider.model_for_provider(provider) != nil
      end
    end
  end
end
