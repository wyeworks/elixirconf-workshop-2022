defmodule WorldCup.Fixture do
  @moduledoc """
  The fixture context.
  """

  alias WorldCup.Fixture.{Match, Round, Team}

  @teams [
    %Team{
      name: "Uruguay",
      abbreviation: "URU",
      ranking: 1
    },
    %Team{
      name: "Korea",
      abbreviation: "KOR",
      ranking: 2
    },
    %Team{
      name: "Portugal",
      abbreviation: "POR",
      ranking: 3
    },
    %Team{
      name: "Ghana",
      abbreviation: "GHA",
      ranking: 4
    }
  ]

  def list_teams(),
    do: Enum.sort_by(@teams, &(&1.ranking))

  def list_rounds() do
    teams = list_teams()

    [
      %Round{
        id: "round_1",
        matches: [
          %Match{
            id: "match_1",
            home_team: Enum.at(teams, 0),
            away_team: Enum.at(teams, 1)
          },
          %Match{
            id: "match_2",
            home_team: Enum.at(teams, 2),
            away_team: Enum.at(teams, 3)
          }
        ]
      },
      %Round{
        id: "round_2",
        matches: [
          %Match{
            id: "match_1",
            home_team: Enum.at(teams, 0),
            away_team: Enum.at(teams, 3)
          },
          %Match{
            id: "match_2",
            home_team: Enum.at(teams, 2),
            away_team: Enum.at(teams, 1)
          }
        ]
      },
      %Round{
        id: "round_3",
        matches: [
          %Match{
            id: "match_1",
            home_team: Enum.at(teams, 0),
            away_team: Enum.at(teams, 2)
          },
          %Match{
            id: "match_2",
            home_team: Enum.at(teams, 3),
            away_team: Enum.at(teams, 1)
          }
        ]
      },
    ]
  end
end
