defmodule WorldCup.Fixture.Result do
  use Ecto.Schema

  import Ecto.Changeset

  alias WorldCup.Fixture.Match

  schema "results" do
    field :home_score, :integer, default: 0
    field :away_score, :integer, default: 0

    belongs_to :match, Match

    timestamps(type: :utc_datetime)
  end

  def changeset(result, attrs \\ %{}) do
    result
    |> cast(attrs, [
      :home_score,
      :away_score,
      :match_id
    ])
    |> validate_required([:home_score, :away_score])
    |> unique_constraint(:match_id)
    |> foreign_key_constraint(:match_id)
  end
end
