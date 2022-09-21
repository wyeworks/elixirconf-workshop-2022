defmodule WorldCup.Fixture do
  @moduledoc """
  The fixture context.
  """

  alias WorldCup.Fixture.{Match, Round, Team}

  @teams [
    %Team{
      id: "team_1",
      name: "Uruguay",
      abbreviation: "URU"
    },
    %Team{
      id: "team_2",
      name: "Korea",
      abbreviation: "KOR"
    },
    %Team{
      id: "team_3",
      name: "Portugal",
      abbreviation: "POR"
    },
    %Team{
      id: "team_4",
      name: "Ghana",
      abbreviation: "GHA"
    }
  ]

  def list_teams(),
    do: Enum.sort_by(@teams, &(&1.points), :desc)

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

  def update_match_result(rounds, round_id, match_id, result) do
    update_in_list(rounds, round_id, fn round ->
      %Round{
        id: round.id,
        matches: update_in_list(round.matches, match_id, fn match ->
          match
          |> Map.put(:played, true)
          |> Map.put(:result, result)
        end)
      }
    end)
  end

  def set_teams_points(rounds) do
    rounds
    |> Enum.reduce(list_teams(), fn round, teams ->
        Enum.reduce(round.matches, teams, fn match, teams ->
          if match.played do
            cond do
              match.result.home_score > match.result.away_score ->
                update_in_list(teams, match.home_team.id, fn team -> Map.put(team, :points, team.points + 3) end)
              match.result.home_score == match.result.away_score ->
                teams
                |> update_in_list(match.home_team.id, fn team -> Map.put(team, :points, team.points + 1) end)
                |> update_in_list(match.away_team.id, fn team -> Map.put(team, :points, team.points + 1) end)
              true ->
                update_in_list(teams, match.away_team.id, fn team -> Map.put(team, :points, team.points + 3) end)
            end
          else
            teams
          end
        end)
      end)
    |> Enum.sort_by(&(&1.points), :desc)
  end

  defp update_in_list(list, entity_id, update_fn) do
    Enum.map(list, fn
      entity when entity.id == entity_id -> update_fn.(entity)
      e -> e
    end)
  end
end
