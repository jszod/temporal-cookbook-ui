defmodule TemporalCookbookUi.Temporal.WorkflowTest do
  use ExUnit.Case
  doctest TemporalCookbookUi.Temporal.Workflow

  alias TemporalCookbookUi.Temporal.Workflow

  describe "build_request/2" do
    test "builds workflow request with all parameters" do
      params = %{
        "provider" => "ollama",
        "prompt" => "Hello, world!",
        "temperature" => "0.7",
        "max_tokens" => "100"
      }

      request = Workflow.build_request("1", params)

      assert request.pattern_id == "1"
      assert is_binary(request.workflow_id)
      assert String.starts_with?(request.workflow_id, "litellm-")
      assert request.input["model"] == "ollama/gemma3:latest"
      assert request.input["prompt"] == "Hello, world!"
      assert request.input["temperature"] == 0.7
      assert request.input["max_tokens"] == 100
    end

    test "builds workflow request with minimal parameters" do
      params = %{
        "provider" => "openai",
        "prompt" => "Test prompt"
      }

      request = Workflow.build_request("2", params)

      assert request.pattern_id == "2"
      assert is_binary(request.workflow_id)
      assert request.input["model"] == "gpt-3.5-turbo"
      assert request.input["prompt"] == "Test prompt"
      assert not Map.has_key?(request.input, "temperature")
      assert not Map.has_key?(request.input, "max_tokens")
    end

    test "defaults to ollama provider when not specified" do
      params = %{"prompt" => "Test"}

      request = Workflow.build_request("1", params)

      assert request.input["model"] == "ollama/gemma3:latest"
    end

    test "handles empty prompt" do
      params = %{"provider" => "ollama", "prompt" => ""}

      request = Workflow.build_request("1", params)

      assert request.input["prompt"] == ""
    end

    test "parses temperature as float" do
      params = %{
        "provider" => "ollama",
        "prompt" => "Test",
        "temperature" => "0.5"
      }

      request = Workflow.build_request("1", params)

      assert request.input["temperature"] == 0.5
    end

    test "parses max_tokens as integer" do
      params = %{
        "provider" => "ollama",
        "prompt" => "Test",
        "max_tokens" => "500"
      }

      request = Workflow.build_request("1", params)

      assert request.input["max_tokens"] == 500
    end

    test "excludes nil values from input" do
      params = %{
        "provider" => "ollama",
        "prompt" => "Test",
        "temperature" => "invalid",
        "max_tokens" => "not-a-number"
      }

      request = Workflow.build_request("1", params)

      assert request.input["model"] == "ollama/gemma3:latest"
      assert request.input["prompt"] == "Test"
      assert not Map.has_key?(request.input, "temperature")
      assert not Map.has_key?(request.input, "max_tokens")
    end

    test "handles unknown provider gracefully" do
      params = %{
        "provider" => "unknown-provider",
        "prompt" => "Test"
      }

      request = Workflow.build_request("1", params)

      assert request.input["model"] == nil
      assert request.input["prompt"] == "Test"
      # Model is nil but still included in map - that's fine, the workflow will handle it
    end
  end

  describe "generate_id/1" do
    test "generates unique workflow IDs with default prefix" do
      id1 = Workflow.generate_id()
      id2 = Workflow.generate_id()

      assert String.starts_with?(id1, "litellm-")
      assert String.starts_with?(id2, "litellm-")
      assert id1 != id2
    end

    test "generates IDs with custom prefix" do
      id = Workflow.generate_id("custom-prefix")

      assert String.starts_with?(id, "custom-prefix-")
    end

    test "generates IDs with correct format" do
      id = Workflow.generate_id("test")

      # Format: prefix-timestamp-random
      parts = String.split(id, "-")
      assert length(parts) >= 3
      assert List.first(parts) == "test"
      assert String.to_integer(Enum.at(parts, 1)) > 0  # timestamp
      assert String.to_integer(Enum.at(parts, 2)) > 0  # random number
    end

    test "generates different IDs on each call" do
      ids = for _ <- 1..10, do: Workflow.generate_id()
      unique_ids = Enum.uniq(ids)

      # All IDs should be unique (very high probability)
      assert length(unique_ids) == 10
    end
  end
end
