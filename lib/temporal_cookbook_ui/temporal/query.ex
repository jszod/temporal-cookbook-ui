defmodule TemporalCookbookUi.Temporal.Query do
  @moduledoc """
  Functional core for querying and parsing Temporal workflow data.

  This module contains pure functions for transforming Temporal CLI output
  into structured data. All functions are side-effect free and easily testable.

  ## Examples

      iex> TemporalCookbookUi.Temporal.Query.parse_status("Status: COMPLETED")
      "COMPLETED"

      iex> TemporalCookbookUi.Temporal.Query.parse_status("Some other output")
      "UNKNOWN"

      iex> TemporalCookbookUi.Temporal.Query.extract_result(~s(Result: {"text": "hello"}))
      {:ok, %{"text" => "hello"}}
  """

  @doc """
  Parses workflow status from Temporal CLI describe output.

  ## Parameters
  - `cli_output`: String output from `temporal workflow describe` command

  ## Returns
  - `"COMPLETED"` if the workflow has completed successfully
  - `"FAILED"` if the workflow has failed
  - `"RUNNING"` if the workflow is currently running
  - `"UNKNOWN"` if the status cannot be determined

  ## Examples

      iex> TemporalCookbookUi.Temporal.Query.parse_status("Status: COMPLETED")
      "COMPLETED"

      iex> TemporalCookbookUi.Temporal.Query.parse_status("Workflow RUNNING")
      "RUNNING"

      iex> TemporalCookbookUi.Temporal.Query.parse_status("Status: FAILED")
      "FAILED"

      iex> TemporalCookbookUi.Temporal.Query.parse_status("Some random output")
      "UNKNOWN"
  """
  def parse_status(cli_output) when is_binary(cli_output) do
    cond do
      String.contains?(cli_output, "Status: COMPLETED") or
          String.contains?(cli_output, "COMPLETED") ->
        "COMPLETED"

      String.contains?(cli_output, "Status: FAILED") or
          String.contains?(cli_output, "FAILED") ->
        "FAILED"

      String.contains?(cli_output, "Status: RUNNING") or
          String.contains?(cli_output, "RUNNING") ->
        "RUNNING"

      true ->
        "UNKNOWN"
    end
  end

  @doc """
  Extracts JSON result from Temporal CLI show output.

  This function attempts to find and parse JSON data from the CLI output,
  trying multiple patterns to locate the JSON.

  ## Parameters
  - `cli_output`: String output from `temporal workflow show` command

  ## Returns
  - `{:ok, map}` containing the parsed JSON data
  - `{:error, reason}` if JSON parsing fails

  ## Examples

      iex> TemporalCookbookUi.Temporal.Query.extract_result(~s(Result: {"text": "hello", "tokens": 10}))
      {:ok, %{"text" => "hello", "tokens" => 10}}

      iex> TemporalCookbookUi.Temporal.Query.extract_result(~s(Some text {"text": "hello"} more text))
      {:ok, %{"text" => "hello"}}

      iex> TemporalCookbookUi.Temporal.Query.extract_result("No JSON here")
      {:ok, %{}}
  """
  def extract_result(cli_output) when is_binary(cli_output) do
    case find_json_in_output(cli_output) do
      nil -> {:ok, %{}}
      json_str -> Jason.decode(json_str)
    end
  end

  # Private helper functions

  defp find_json_in_output(output) do
    # Try to find "Result: {...}" pattern first
    case Regex.run(~r/Result[:\s]+(\{.*\})/s, output) do
      [_, json_str] -> json_str
      _ -> find_any_json(output)
    end
  end

  defp find_any_json(output) do
    case Regex.run(~r/\{[\s\S]*\}/, output) do
      [json_str] -> json_str
      _ -> nil
    end
  end
end
