defmodule TemporalCookbookUiWeb.Live.HelpersTest do
  use ExUnit.Case, async: true
  doctest TemporalCookbookUiWeb.Live.Helpers

  alias TemporalCookbookUiWeb.Live.Helpers

  describe "parse_float/1" do
    test "parses valid float strings" do
      assert Helpers.parse_float("3.14") == 3.14
      assert Helpers.parse_float("0.7") == 0.7
      assert Helpers.parse_float("1.0") == 1.0
      assert Helpers.parse_float("0.0") == 0.0
      assert Helpers.parse_float("-1.5") == -1.5
    end

    test "returns nil for nil input" do
      assert Helpers.parse_float(nil) == nil
    end

    test "returns nil for invalid strings" do
      assert Helpers.parse_float("invalid") == nil
      assert Helpers.parse_float("not a number") == nil
      assert Helpers.parse_float("") == nil
    end

    test "returns float as-is when already a float" do
      assert Helpers.parse_float(3.14) == 3.14
      assert Helpers.parse_float(0.7) == 0.7
    end

    test "returns nil for non-string, non-float, non-nil input" do
      assert Helpers.parse_float(42) == nil
      assert Helpers.parse_float(%{}) == nil
      assert Helpers.parse_float([]) == nil
    end

    test "handles strings with trailing characters" do
      # Float.parse only parses the float part, but we use the result
      # This is expected behavior - we only parse what we can
      assert Helpers.parse_float("3.14abc") == 3.14
    end
  end

  describe "parse_integer/1" do
    test "parses valid integer strings" do
      assert Helpers.parse_integer("42") == 42
      assert Helpers.parse_integer("500") == 500
      assert Helpers.parse_integer("0") == 0
      assert Helpers.parse_integer("-100") == -100
    end

    test "returns nil for nil input" do
      assert Helpers.parse_integer(nil) == nil
    end

    test "returns nil for invalid strings" do
      assert Helpers.parse_integer("invalid") == nil
      assert Helpers.parse_integer("not a number") == nil
      assert Helpers.parse_integer("") == nil
    end

    test "parses integer from float string (parses leading digits)" do
      # Integer.parse will parse "3" from "3.14", which is expected behavior
      assert Helpers.parse_integer("3.14") == 3
    end

    test "returns integer as-is when already an integer" do
      assert Helpers.parse_integer(42) == 42
      assert Helpers.parse_integer(500) == 500
    end

    test "returns nil for non-string, non-integer, non-nil input" do
      assert Helpers.parse_integer(3.14) == nil
      assert Helpers.parse_integer(%{}) == nil
      assert Helpers.parse_integer([]) == nil
    end

    test "handles strings with trailing characters" do
      # Integer.parse only parses the integer part, but we use the result
      # This is expected behavior - we only parse what we can
      assert Helpers.parse_integer("42abc") == 42
    end
  end
end

