defmodule WorldCup.Fixture do
  @moduledoc """
  The fixture context.
  """

  alias WorldCup.Fixture.{Match, Round, Team}

  @teams [
    %Team{
      id: "team_1",
      name: "Uruguay",
      abbreviation: "URU",
      flag: "🇺🇾"
    },
    %Team{
      id: "team_2",
      name: "Korea",
      abbreviation: "KOR",
      flag: "🇰🇷"
    },
    %Team{
      id: "team_3",
      name: "Portugal",
      abbreviation: "POR",
      flag: "🇵🇹"
    },
    %Team{
      id: "team_4",
      name: "Ghana",
      abbreviation: "GHA",
      flag: "🇬🇭"
    }
  ]

  def list_teams(), do: rank_teams(@teams)

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
      }
    ]
  end

  def update_match_result(rounds, round_id, match_id, result) do
    update_in_list(rounds, round_id, fn round ->
      %Round{
        id: round.id,
        matches:
          update_in_list(round.matches, match_id, fn match ->
            match
            |> Map.put(:played, true)
            |> Map.put(:result, result)
          end)
      }
    end)
  end

  def update_teams_stats(rounds) do
    for round <- rounds,
        match <- round.matches,
        reduce: list_teams() do
      teams -> process_match_result(match, teams)
    end
    |> rank_teams()
  end

  defp process_match_result(%{played: false} = _match, teams), do: teams

  defp process_match_result(
         %{result: %{home_score: home_score, away_score: away_score}} = match,
         teams
       ) do
    teams
    |> update_in_list(match.home_team.id, &update_team_stats(&1, home_score, away_score))
    |> update_in_list(match.away_team.id, &update_team_stats(&1, away_score, home_score))
  end

  defp update_team_stats(team, team_score, rival_score) when team_score > rival_score do
    team
    |> Map.put(:points, team.points + 3)
    |> Map.put(:won_games, team.won_games + 1)
    |> Map.put(:goal_diff, team.goal_diff + team_score - rival_score)
  end

  defp update_team_stats(team, team_score, rival_score) when team_score < rival_score do
    team
    |> Map.put(:lost_games, team.lost_games + 1)
    |> Map.put(:goal_diff, team.goal_diff + team_score - rival_score)
  end

  defp update_team_stats(team, team_score, rival_score) when team_score == rival_score do
    team
    |> Map.put(:points, team.points + 1)
    |> Map.put(:draw_games, team.draw_games + 1)
  end

  defp update_in_list(list, entity_id, update_fn) do
    Enum.map(list, fn
      entity when entity.id == entity_id -> update_fn.(entity)
      e -> e
    end)
  end

  defp rank_teams(teams), do: Enum.sort_by(teams, &{&1.points, &1.goal_diff}, :desc)
end
