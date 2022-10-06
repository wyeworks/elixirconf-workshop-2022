defmodule WorldCup.Fixture.TeamStats do
  def calculate(teams, matches) do
    Enum.map(teams, fn team ->
      Enum.reduce(matches, team, fn match, acc -> process_match_result(match, acc) end)
    end)
    |> rank_teams()
  end

  defp process_match_result(
         %{played: true, home_team: home_team, result: result},
         team
       )
       when home_team.id == team.id do
    update_team_stats(team, result.home_score, result.away_score)
  end

  defp process_match_result(
         %{played: true, away_team: away_team, result: result},
         team
       )
       when away_team.id == team.id do
    update_team_stats(team, result.away_score, result.home_score)
  end

  defp process_match_result(_match, team), do: team

  defp update_team_stats(team, team_score, rival_score) when team_score > rival_score do
    Map.merge(team, %{
      points: team.points + 3,
      won_games: team.won_games + 1,
      goal_diff: team.goal_diff + team_score - rival_score
    })
  end

  defp update_team_stats(team, team_score, rival_score) when team_score < rival_score do
    Map.merge(team, %{
      lost_games: team.lost_games + 1,
      goal_diff: team.goal_diff + team_score - rival_score
    })
  end

  defp update_team_stats(team, team_score, rival_score) when team_score == rival_score do
    Map.merge(team, %{
      points: team.points + 1,
      draw_games: team.draw_games + 1
    })
  end

  defp rank_teams(teams), do: Enum.sort_by(teams, &{&1.points, &1.goal_diff}, :desc)
end
