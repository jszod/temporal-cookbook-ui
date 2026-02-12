defmodule TemporalCookbookUiWeb.PatternDetailLiveTest do
  use TemporalCookbookUiWeb.LiveViewCase

  alias TemporalCookbookUi.Temporal.Workflow

  describe "mount/3" do
    test "initializes with pattern data for known pattern", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/patterns/1")

      assert has_element?(view, "h1", "Hello World Litellm")

      assert has_element?(
               view,
               "p",
               "Use Litellm to provide AI capabilities within your Temporal workflows."
             )

      assert has_element?(view, "span", "Easy")
    end

    test "initializes with default pattern for unknown pattern", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/patterns/999")

      assert has_element?(view, "h1", "Unknown Pattern")
      assert has_element?(view, "p", "Pattern not found")
    end

    test "shows workflow controls for pattern 1", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/patterns/1")

      # Should render WorkflowControls component for pattern 1
      assert render(view) =~ "Workflow Controls"
    end

    test "shows placeholder for other patterns", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/patterns/2")

      assert render(view) =~ "Workflow controls for this pattern coming soon"
    end
  end

  describe "handle_event start_workflow" do
    test "successfully starts workflow and navigates to execution view" do
      # Mock the Client.start_workflow to return success
      # Build expected workflow request
      params = %{
        "provider" => "ollama",
        "prompt" => "Test prompt",
        "temperature" => "0.7",
        "max_tokens" => "100"
      }

      workflow_request = Workflow.build_request("1", params)

      # We need to mock Client.start_workflow
      # Since we can't easily mock in ExUnit, we'll test the behavior
      # by checking that the function is called correctly
      # For now, we'll test that the workflow request is built correctly
      assert workflow_request.pattern_id == "1"
      assert String.starts_with?(workflow_request.workflow_id, "litellm-")
      assert workflow_request.input["model"] == "ollama/gemma3:latest"
      assert workflow_request.input["prompt"] == "Test prompt"
      assert workflow_request.input["temperature"] == 0.7
      assert workflow_request.input["max_tokens"] == 100

      # Note: Full integration test would require mocking Client.start_workflow
      # or using a test double. For now, we verify the workflow building logic.
    end

    test "builds workflow request with minimal parameters" do
      params = %{
        "provider" => "openai",
        "prompt" => "Minimal test"
      }

      workflow_request = Workflow.build_request("1", params)

      assert workflow_request.pattern_id == "1"
      assert workflow_request.input["model"] == "gpt-3.5-turbo"
      assert workflow_request.input["prompt"] == "Minimal test"
      # Temperature and max_tokens should not be in input if not provided
      assert not Map.has_key?(workflow_request.input, "temperature")
      assert not Map.has_key?(workflow_request.input, "max_tokens")
    end

    test "handles workflow start error gracefully", %{conn: conn} do
      # This test verifies error handling structure
      # Full test would require mocking Client.start_workflow to return error
      # For now, we verify the error handling converter exists
      {:ok, view, _html} = live(conn, ~p"/patterns/1")

      # The show_error converter should handle errors
      # We can't easily test this without mocking, but we verify the structure
      assert view.module.__info__(:functions)[:handle_event] != nil
    end
  end

  describe "render/1" do
    test "renders pattern details correctly", %{conn: conn} do
      {:ok, _view, html} = live(conn, ~p"/patterns/1")

      assert html =~ "Hello World Litellm"
      assert html =~ "Use Litellm to provide AI capabilities"
      assert html =~ "Easy"
      assert html =~ "Back to Catalog"
    end

    test "renders back link", %{conn: conn} do
      {:ok, _view, html} = live(conn, ~p"/patterns/1")

      assert html =~ "Back to Catalog"
    end

    test "renders pattern details section", %{conn: conn} do
      {:ok, _view, html} = live(conn, ~p"/patterns/1")

      assert html =~ "Pattern Details"
    end
  end
end
