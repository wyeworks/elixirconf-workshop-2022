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

  def list_teams(),
    do: Enum.sort_by(@teams, &{&1.points, &1.goal_diff}, :desc)

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

  def set_teams_stats(rounds) do
    rounds
    |> Enum.reduce(list_teams(), fn round, teams ->
      Enum.reduce(round.matches, teams, fn match, teams ->
        update_match_stats(match, teams)
      end)
    end)
    |> Enum.sort_by(&{&1.points, &1.goal_diff}, :desc)
  end

  defp update_match_stats(%{played: false} = _match, teams), do: teams

  defp update_match_stats(
         %{played: true, result: %{home_score: home_score, away_score: away_score}} = match,
         teams
       )
       when home_score > away_score do
    teams
    |> update_in_list(match.home_team.id, fn team ->
      team
      |> Map.put(:points, team.points + 3)
      |> Map.put(:won_games, team.won_games + 1)
      |> Map.put(:goal_diff, team.goal_diff + home_score - away_score)
    end)
    |> update_in_list(match.away_team.id, fn team ->
      team
      |> Map.put(:lost_games, team.won_games + 1)
      |> Map.put(:goal_diff, team.goal_diff + away_score - home_score)
    end)
  end

  defp update_match_stats(
         %{played: true, result: %{home_score: home_score, away_score: away_score}} = match,
         teams
       )
       when home_score < away_score do
    teams
    |> update_in_list(match.away_team.id, fn team ->
      team
      |> Map.put(:points, team.points + 3)
      |> Map.put(:won_games, team.won_games + 1)
      |> Map.put(:goal_diff, team.goal_diff + away_score - home_score)
    end)
    |> update_in_list(match.home_team.id, fn team ->
      team
      |> Map.put(:lost_games, team.won_games + 1)
      |> Map.put(:goal_diff, team.goal_diff + home_score - away_score)
    end)
  end

  defp update_match_stats(
         %{played: true, result: %{home_score: home_score, away_score: away_score}} = match,
         teams
       )
       when home_score == away_score do
    teams
    |> update_in_list(match.away_team.id, fn team ->
      team
      |> Map.put(:points, team.points + 1)
      |> Map.put(:draw_games, team.draw_games + 1)
    end)
    |> update_in_list(match.home_team.id, fn team ->
      team
      |> Map.put(:points, team.points + 1)
      |> Map.put(:draw_games, team.draw_games + 1)
    end)
  end

  defp update_in_list(list, entity_id, update_fn) do
    Enum.map(list, fn
      entity when entity.id == entity_id -> update_fn.(entity)
      e -> e
    end)
  end
end
