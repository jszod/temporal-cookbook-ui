defmodule TemporalCookbookUi.Patterns.Pattern do
  @moduledoc """
  Data and Functional Core for a pattern domain.
  """

  # ===== DATA LAYER =====
  defstruct [
    :id,
    :name,
    :description,
    :complexity
  ]

  # Static pattern data
  defp patterns do
    [
      %__MODULE__{
        id: 1,
        name: "Hello World Litellm",
        description: "Use Litellm to provide AI capabilities within your Temporal workflows.",
        complexity: "Easy"
      },
      %__MODULE__{
        id: 2,
        name: "Pattern B",
        description: "Description for Pattern B",
        complexity: "Medium"
      },
      %__MODULE__{
        id: 3,
        name: "Pattern C",
        description: "Description for Pattern C",
        complexity: "Hard"
      }
    ]
  end

  # ===== FUNCTIONAL CORE =====
  def list_all do
    patterns()
  end

  def get_by_id(id) do
    patterns()
    |> Enum.find(fn pattern -> pattern.id == id end) ||
      default_pattern(id)
  end

  defp default_pattern(id) do
    %TemporalCookbookUi.Patterns.Pattern{
      id: id,
      name: "Unknown Pattern",
      description: "Pattern not found",
      complexity: "Unknown"
    }
  end
end
