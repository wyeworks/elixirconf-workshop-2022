defmodule WorldCup.Standings do
  def calculate(teams, matches) do
    Enum.map(teams, fn team ->
      Enum.reduce(matches, team, fn match, acc -> process_match_result(match, acc) end)
    end)
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
    Map.put(team, :points, team.points + 3)
  end

  defp update_team_stats(team, team_score, rival_score) when team_score == rival_score do
    Map.put(team, :points, team.points + 1)
  end

  defp update_team_stats(team, team_score, rival_score) when team_score < rival_score do
    team
  end
end
