defmodule WorldCup.Match do
  defstruct [:scheduled_at, :home_team, :away_team, result: %WorldCup.Result{}]

  @type t() :: %__MODULE__{
    scheduled_at: DateTime.t(),
    home_team: WorldCup.Team.t(),
    away_team: WorldCup.Team.t(),
    result: WorldCup.Result.t()
  }
end
