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
    Enum.map(matches, fn
      match when match.id == match_id -> %{match | played: true, result: result}
      match -> match
    end)
  end

  def calculate(matches) do
    Enum.map(list_teams(), fn team ->
      Enum.reduce(matches, team, fn match, acc -> process_match_result(match, acc) end)
    end)
  end

  defp process_match_result(
         %{played: true, home_team: home_team, away_team: away_team},
         team
       )
       when home_team.id == team.id or away_team.id == team.id do
    update_team_stats(team)
  end

  defp process_match_result(_match, team), do: team

  defp update_team_stats(team) do
    Map.merge(team, %{points: team.points + 3})
  end
end
