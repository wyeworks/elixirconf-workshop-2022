defmodule WorldCup.Fixture do
  @moduledoc """
  The fixture context.
  """

  alias WorldCup.Fixture.Team

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

  def list_teams(), do: @teams
end
