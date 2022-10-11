defmodule WorldCup.Fixture.Match do
  alias WorldCup.Fixture.Team

  defstruct [
    :id,
    :scheduled_at,
    :home_team,
    :away_team,
    :round,
    played: false
  ]

  @type t() :: %__MODULE__{
          id: String.t(),
          scheduled_at: DateTime.t(),
          home_team: Team.t(),
          away_team: Team.t(),
          played: boolean()
        }
end
