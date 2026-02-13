defmodule TemporalCookbookUi.Patterns.PatternTest do
  use ExUnit.Case, async: true

  alias TemporalCookbookUi.Patterns.Pattern

  describe "list_all/0" do
    test "returns list of all patterns" do
      patterns = Pattern.list_all()

      assert is_list(patterns)
      assert length(patterns) == 6
    end

    test "returns patterns with correct structure" do
      patterns = Pattern.list_all()

      for pattern <- patterns do
        assert %Pattern{} = pattern
        assert is_binary(pattern.id)
        assert is_binary(pattern.name)
        assert is_binary(pattern.description)
        assert pattern.complexity in ["Easy", "Medium", "Hard"]
        assert is_list(pattern.tags)
        assert is_binary(pattern.workflow_type)
        assert pattern.status in [:available, :coming_soon]
        assert is_list(pattern.use_cases)
      end
    end

    test "returns patterns in consistent order" do
      patterns1 = Pattern.list_all()
      patterns2 = Pattern.list_all()

      assert patterns1 == patterns2
    end

    test "includes all 6 expected patterns" do
      patterns = Pattern.list_all()
      pattern_ids = Enum.map(patterns, & &1.id)

      assert "litellm" in pattern_ids
      assert "tool-calling" in pattern_ids
      assert "structured-outputs" in pattern_ids
      assert "retry-policy" in pattern_ids
      assert "durable-agent" in pattern_ids
      assert "deep-research" in pattern_ids
    end

    test "litellm and tool-calling are the available patterns" do
      patterns = Pattern.list_all()
      available = Enum.filter(patterns, &(&1.status == :available))
      available_ids = Enum.map(available, & &1.id)

      assert length(available) == 2
      assert "litellm" in available_ids
      assert "tool-calling" in available_ids
    end
  end

  describe "get_by_id/1" do
    test "returns litellm pattern" do
      pattern = Pattern.get_by_id("litellm")

      assert %Pattern{} = pattern
      assert pattern.id == "litellm"
      assert pattern.name == "LiteLLM Completion"
      assert pattern.complexity == "Easy"
      assert pattern.status == :available
      assert pattern.workflow_type == "litellm_workflow"
      assert is_list(pattern.tags)
      assert is_list(pattern.use_cases)
      assert length(pattern.use_cases) > 0
    end

    test "returns tool-calling pattern" do
      pattern = Pattern.get_by_id("tool-calling")

      assert %Pattern{} = pattern
      assert pattern.id == "tool-calling"
      assert pattern.name == "Tool Calling Agent"
      assert pattern.complexity == "Medium"
      assert pattern.status == :available
      assert pattern.workflow_type == "tool_calling_workflow"
    end

    test "returns structured-outputs pattern" do
      pattern = Pattern.get_by_id("structured-outputs")

      assert %Pattern{} = pattern
      assert pattern.id == "structured-outputs"
      assert pattern.complexity == "Medium"
      assert pattern.status == :coming_soon
    end

    test "returns retry-policy pattern" do
      pattern = Pattern.get_by_id("retry-policy")

      assert %Pattern{} = pattern
      assert pattern.id == "retry-policy"
      assert pattern.complexity == "Easy"
      assert pattern.status == :coming_soon
    end

    test "returns durable-agent pattern" do
      pattern = Pattern.get_by_id("durable-agent")

      assert %Pattern{} = pattern
      assert pattern.id == "durable-agent"
      assert pattern.complexity == "Hard"
      assert pattern.status == :coming_soon
    end

    test "returns deep-research pattern" do
      pattern = Pattern.get_by_id("deep-research")

      assert %Pattern{} = pattern
      assert pattern.id == "deep-research"
      assert pattern.complexity == "Hard"
      assert pattern.status == :coming_soon
    end

    test "returns default pattern for unknown string ID" do
      pattern = Pattern.get_by_id("unknown-id")

      assert %Pattern{} = pattern
      assert pattern.id == "unknown-id"
      assert pattern.name == "Unknown Pattern"
      assert pattern.description == "Pattern not found"
      assert pattern.complexity == "Unknown"
    end

    test "returns default pattern for nil ID" do
      pattern = Pattern.get_by_id(nil)

      assert %Pattern{} = pattern
      assert pattern.id == nil
      assert pattern.name == "Unknown Pattern"
    end

    test "returns default pattern for integer ID (IDs are strings)" do
      pattern = Pattern.get_by_id(1)

      assert %Pattern{} = pattern
      assert pattern.id == 1
      assert pattern.name == "Unknown Pattern"
    end
  end

  describe "integration: list_all and get_by_id" do
    test "all patterns from list_all can be retrieved by get_by_id" do
      all_patterns = Pattern.list_all()

      for pattern <- all_patterns do
        retrieved = Pattern.get_by_id(pattern.id)
        assert retrieved.id == pattern.id
        assert retrieved.name == pattern.name
        assert retrieved.description == pattern.description
        assert retrieved.complexity == pattern.complexity
        assert retrieved.tags == pattern.tags
        assert retrieved.workflow_type == pattern.workflow_type
        assert retrieved.status == pattern.status
        assert retrieved.use_cases == pattern.use_cases
      end
    end

    test "get_by_id returns same pattern as list_all for litellm" do
      all_patterns = Pattern.list_all()
      pattern_from_list = Enum.find(all_patterns, &(&1.id == "litellm"))
      pattern_by_id = Pattern.get_by_id("litellm")

      assert pattern_from_list == pattern_by_id
    end
  end

  describe "struct definition" do
    test "Pattern struct has all required fields" do
      pattern = %Pattern{
        id: "test",
        name: "Test Pattern",
        description: "Test description",
        complexity: "Easy",
        tags: ["Tag1"],
        workflow_type: "test_workflow",
        status: :available,
        use_cases: ["Use case 1"]
      }

      assert pattern.id == "test"
      assert pattern.name == "Test Pattern"
      assert pattern.description == "Test description"
      assert pattern.complexity == "Easy"
      assert pattern.tags == ["Tag1"]
      assert pattern.workflow_type == "test_workflow"
      assert pattern.status == :available
      assert pattern.use_cases == ["Use case 1"]
    end

    test "Pattern struct allows nil values" do
      pattern = %Pattern{
        id: "test",
        name: "Test",
        description: "Test",
        complexity: nil
      }

      assert pattern.complexity == nil
    end
  end
end
