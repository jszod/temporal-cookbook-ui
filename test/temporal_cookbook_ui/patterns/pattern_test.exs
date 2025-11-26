defmodule TemporalCookbookUi.Patterns.PatternTest do
  use ExUnit.Case, async: true

  alias TemporalCookbookUi.Patterns.Pattern

  describe "list_all/0" do
    test "returns list of all patterns" do
      patterns = Pattern.list_all()

      assert is_list(patterns)
      assert length(patterns) == 3
    end

    test "returns patterns with correct structure" do
      patterns = Pattern.list_all()

      for pattern <- patterns do
        assert %Pattern{} = pattern
        assert pattern.id != nil
        assert is_binary(pattern.name) or is_integer(pattern.id)
        assert is_binary(pattern.description)
        assert pattern.complexity in ["Easy", "Medium", "Hard", nil]
      end
    end

    test "returns patterns in consistent order" do
      patterns1 = Pattern.list_all()
      patterns2 = Pattern.list_all()

      assert patterns1 == patterns2
    end

    test "includes expected patterns" do
      patterns = Pattern.list_all()
      pattern_ids = Enum.map(patterns, & &1.id)

      assert 1 in pattern_ids
      assert 2 in pattern_ids
      assert 3 in pattern_ids
    end
  end

  describe "get_by_id/1" do
    test "returns pattern for valid integer ID" do
      pattern = Pattern.get_by_id(1)

      assert %Pattern{} = pattern
      assert pattern.id == 1
      assert pattern.name == "Hello World Litellm"
      assert pattern.description == "Use Litellm to provide AI capabilities within your Temporal workflows."
      assert pattern.complexity == "Easy"
    end

    test "returns pattern for valid integer ID (2)" do
      pattern = Pattern.get_by_id(2)

      assert %Pattern{} = pattern
      assert pattern.id == 2
      assert pattern.name == "Pattern B"
      assert pattern.complexity == "Medium"
    end

    test "returns pattern for valid integer ID (3)" do
      pattern = Pattern.get_by_id(3)

      assert %Pattern{} = pattern
      assert pattern.id == 3
      assert pattern.name == "Pattern C"
      assert pattern.complexity == "Hard"
    end

    test "returns default pattern for string ID (no string-to-integer conversion)" do
      # String IDs don't match integer IDs in the current implementation
      pattern = Pattern.get_by_id("1")

      assert %Pattern{} = pattern
      assert pattern.id == "1"
      assert pattern.name == "Unknown Pattern"
    end

    test "returns default pattern for invalid integer ID" do
      pattern = Pattern.get_by_id(999)

      assert %Pattern{} = pattern
      assert pattern.id == 999
      assert pattern.name == "Unknown Pattern"
      assert pattern.description == "Pattern not found"
      assert pattern.complexity == "Unknown"
    end

    test "returns default pattern for invalid string ID" do
      pattern = Pattern.get_by_id("invalid")

      assert %Pattern{} = pattern
      assert pattern.id == "invalid"
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

    test "handles negative IDs" do
      pattern = Pattern.get_by_id(-1)

      assert %Pattern{} = pattern
      assert pattern.id == -1
      assert pattern.name == "Unknown Pattern"
    end

    test "handles zero ID" do
      pattern = Pattern.get_by_id(0)

      assert %Pattern{} = pattern
      assert pattern.id == 0
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
      end
    end

    test "get_by_id returns same pattern instance as list_all" do
      all_patterns = Pattern.list_all()
      pattern_from_list = Enum.find(all_patterns, &(&1.id == 1))
      pattern_by_id = Pattern.get_by_id(1)

      assert pattern_from_list.id == pattern_by_id.id
      assert pattern_from_list.name == pattern_by_id.name
      assert pattern_from_list.description == pattern_by_id.description
      assert pattern_from_list.complexity == pattern_by_id.complexity
    end
  end

  describe "struct definition" do
    test "Pattern struct has all required fields" do
      pattern = %Pattern{
        id: "test",
        name: "Test Pattern",
        description: "Test description",
        complexity: "Easy"
      }

      assert pattern.id == "test"
      assert pattern.name == "Test Pattern"
      assert pattern.description == "Test description"
      assert pattern.complexity == "Easy"
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
