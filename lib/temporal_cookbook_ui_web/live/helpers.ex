defmodule TemporalCookbookUiWeb.Live.Helpers do
  @moduledoc """
  Shared helper functions for LiveView modules.

  This module contains reusable utility functions for parsing and transforming
  data in LiveView modules. These functions are pure and side-effect free,
  making them easy to test and reuse.
  """

  @doc """
  Parses a string, float, or nil value into a float.

  ## Parameters
  - `value`: Can be `nil`, a binary string, or an existing float

  ## Returns
  - A float value if parsing succeeds
  - `nil` if the value is `nil` or cannot be parsed

  ## Examples

      iex> TemporalCookbookUiWeb.Live.Helpers.parse_float("3.14")
      3.14

      iex> TemporalCookbookUiWeb.Live.Helpers.parse_float("0.7")
      0.7

      iex> TemporalCookbookUiWeb.Live.Helpers.parse_float(nil)
      nil

      iex> TemporalCookbookUiWeb.Live.Helpers.parse_float("invalid")
      nil

      iex> TemporalCookbookUiWeb.Live.Helpers.parse_float(3.14)
      3.14
  """
  def parse_float(nil), do: nil

  def parse_float(str) when is_binary(str) do
    case Float.parse(str) do
      {float, _} -> float
      :error -> nil
    end
  end

  def parse_float(float) when is_float(float), do: float
  def parse_float(_), do: nil

  @doc """
  Parses a string, integer, or nil value into an integer.

  ## Parameters
  - `value`: Can be `nil`, a binary string, or an existing integer

  ## Returns
  - An integer value if parsing succeeds
  - `nil` if the value is `nil` or cannot be parsed

  ## Examples

      iex> TemporalCookbookUiWeb.Live.Helpers.parse_integer("42")
      42

      iex> TemporalCookbookUiWeb.Live.Helpers.parse_integer("500")
      500

      iex> TemporalCookbookUiWeb.Live.Helpers.parse_integer(nil)
      nil

      iex> TemporalCookbookUiWeb.Live.Helpers.parse_integer("invalid")
      nil

      iex> TemporalCookbookUiWeb.Live.Helpers.parse_integer(42)
      42
  """
  def parse_integer(nil), do: nil

  def parse_integer(str) when is_binary(str) do
    case Integer.parse(str) do
      {int, _} -> int
      :error -> nil
    end
  end

  def parse_integer(int) when is_integer(int), do: int
  def parse_integer(_), do: nil
end
