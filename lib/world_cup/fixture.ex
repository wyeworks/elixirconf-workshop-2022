defmodule WorldCup.Fixture do
  @moduledoc """
  The fixture context.
  """
  import Ecto.Query, only: [order_by: 2, preload: 2]

  alias WorldCup.Fixture.{Match, Result, Team, TeamStats}
  alias WorldCup.Repo

  def list_teams(), do: Repo.all(Team)

  def list_matches() do
    Match
    |> order_by(:id)
    |> preload([:result, :home_team, :away_team])
    |> Repo.all()
  end

  def split_in_rounds(matches), do: Enum.group_by(matches, & &1.round)

  def update_match_result(match, result) do
    Ecto.Multi.new()
    |> Ecto.Multi.update(:match, Match.changeset(match, %{played: true}))
    |> Ecto.Multi.update(:result, Result.changeset(match.result, result))
    |> Repo.transaction()
  end

  def calculate_teams_stats(matches) do
    list_teams() |> TeamStats.calculate(matches)
  end
end
