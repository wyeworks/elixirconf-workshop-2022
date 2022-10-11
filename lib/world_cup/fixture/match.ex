defmodule WorldCup.Fixture.Match do
  alias WorldCup.Fixture.{Result, Team}

  defstruct [
    :id,
    :scheduled_at,
    :home_team,
    :away_team,
    :round,
    played: false,
    result: %Result{away_score: 0, home_score: 0}
  ]

  @type t() :: %__MODULE__{
          id: String.t(),
          scheduled_at: DateTime.t(),
          home_team: Team.t(),
          away_team: Team.t(),
          played: boolean(),
          result: Result.t()
        }
end
