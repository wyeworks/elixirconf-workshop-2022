defmodule WorldCup.Result do
  defstruct [:away_score, :home_score]

  @type t() :: %__MODULE__{
    away_score: Integer.t(),
    home_score: Integer.t()
  }
end
