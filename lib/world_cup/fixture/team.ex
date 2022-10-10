defmodule WorldCup.Fixture.Team do
  defstruct [
    :id,
    :abbreviation,
    :name,
    :flag,
    points: 0,
    won_games: 0,
    lost_games: 0,
    draw_games: 0,
    goal_diff: 0
  ]

  @type t() :: %__MODULE__{
          id: String.t(),
          abbreviation: String.t(),
          name: String.t(),
          flag: String.t(),
          points: integer(),
          won_games: integer(),
          lost_games: integer(),
          draw_games: integer(),
          goal_diff: integer()
        }
end
