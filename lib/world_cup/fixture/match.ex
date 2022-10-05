defmodule WorldCup.Fixture.Match do
  use Ecto.Schema

  import Ecto.Changeset

  alias WorldCup.Fixture.{Result, Team}

  schema "matches" do
    field :played, :boolean, default: false
    field :round, :string

    belongs_to :home_team, Team
    belongs_to :away_team, Team

    has_one :result, Result

    timestamps(type: :utc_datetime)
  end

  def changeset(match, attrs \\ %{}) do
    match
    |> cast(attrs, [
      :played,
      :round,
      :home_team_id,
      :away_team_id
    ])
    |> validate_required(:round)
    |> foreign_key_constraint(:home_team_id)
    |> foreign_key_constraint(:away_team_id)
  end
end
