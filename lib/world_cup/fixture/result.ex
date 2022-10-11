defmodule WorldCup.Fixture.Result do
  defstruct [:away_score, :home_score]

  @type t() :: %__MODULE__{
          away_score: integer(),
          home_score: integer()
        }
end
