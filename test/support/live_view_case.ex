defmodule TemporalCookbookUiWeb.LiveViewCase do
  @moduledoc """
  This module defines the test case to be used by
  tests that require setting up a LiveView connection.

  Such tests rely on `Phoenix.LiveViewTest` and also
  import other functionality to make it easier
  to build common data structures and query the data layer.
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      # The default endpoint for testing
      @endpoint TemporalCookbookUiWeb.Endpoint

      # Import conveniences for testing with connections
      import Phoenix.ConnTest
      import Phoenix.LiveViewTest
      import TemporalCookbookUiWeb.ConnCase
      import TemporalCookbookUiWeb.LiveViewCase

      # Include verified routes for ~p sigil
      use TemporalCookbookUiWeb, :verified_routes
    end
  end

  setup _tags do
    {:ok, conn: Phoenix.ConnTest.build_conn()}
  end
end
