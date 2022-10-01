defmodule WorldCup.Fixture do
  @moduledoc """
  The fixture context.
  """

  alias WorldCup.Fixture.{Match, Team}

  @uru_team %Team{
    id: "team_1",
    name: "Uruguay",
    abbreviation: "URU",
    flag: "🇺🇾"
  }

  @kor_team %Team{
    id: "team_2",
    name: "Korea",
    abbreviation: "KOR",
    flag: "🇰🇷"
  }

  @por_team %Team{
    id: "team_3",
    name: "Portugal",
    abbreviation: "POR",
    flag: "🇵🇹"
  }

  @gha_team %Team{
    id: "team_4",
    name: "Ghana",
    abbreviation: "GHA",
    flag: "🇬🇭"
  }

  @teams [@uru_team, @kor_team, @por_team, @gha_team]

  @matches [
    %Match{
      id: "match_1",
      home_team: @uru_team,
      away_team: @kor_team,
      round: "round_1"
    },
    %Match{
      id: "match_2",
      home_team: @por_team,
      away_team: @gha_team,
      round: "round_1"
    },
    %Match{
      id: "match_3",
      home_team: @uru_team,
      away_team: @gha_team,
      round: "round_2"
    },
    %Match{
      id: "match_4",
      home_team: @por_team,
      away_team: @kor_team,
      round: "round_2"
    },
    %Match{
      id: "match_5",
      home_team: @uru_team,
      away_team: @por_team,
      round: "round_3"
    },
    %Match{
      id: "match_6",
      home_team: @gha_team,
      away_team: @kor_team,
      round: "round_3"
    }
  ]

  def list_teams(), do: @teams
  def list_matches(), do: @matches

  def split_in_rounds(matches), do: Enum.group_by(matches, & &1.round)

  def update_match_result(matches, match_id, result) do
    update_in_list(matches, match_id, fn match ->
      %{match | played: true, result: result}
    end)
  end

  def update_teams_stats(matches) do
    for match <- matches,
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
