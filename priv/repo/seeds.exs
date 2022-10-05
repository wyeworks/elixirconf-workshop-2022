alias WorldCup.Fixture.{Match, Result, Team}
alias WorldCup.Repo

teams = [
  %Team{
    name: "Uruguay",
    abbreviation: "URU",
    flag: "🇺🇾"
  },
  %Team{
    name: "Korea",
    abbreviation: "KOR",
    flag: "🇰🇷"
  },
  %Team{
    name: "Portugal",
    abbreviation: "POR",
    flag: "🇵🇹"
  },
  %Team{
    name: "Ghana",
    abbreviation: "GHA",
    flag: "🇬🇭"
  }
]

[uru_team, kor_team, por_team, gha_team] =
  Enum.map(teams, fn team ->
    team
    |> Team.changeset()
    |> Repo.insert!()
  end)

matches = [
  %Match{
    home_team_id: uru_team.id,
    away_team_id: kor_team.id,
    round: "round_1",
    result: %Result{}
  },
  %Match{
    home_team_id: por_team.id,
    away_team_id: gha_team.id,
    round: "round_1",
    result: %Result{}
  },
  %Match{
    home_team_id: uru_team.id,
    away_team_id: gha_team.id,
    round: "round_2",
    result: %Result{}
  },
  %Match{
    home_team_id: por_team.id,
    away_team_id: kor_team.id,
    round: "round_2",
    result: %Result{}
  },
  %Match{
    home_team_id: uru_team.id,
    away_team_id: por_team.id,
    round: "round_3",
    result: %Result{}
  },
  %Match{
    home_team_id: gha_team.id,
    away_team_id: kor_team.id,
    round: "round_3",
    result: %Result{}
  }
]

Enum.map(matches, fn match ->
  match
  |> Match.changeset()
  |> Repo.insert!()
end)
