defmodule WorldCup.Fixture.Team do
  use Ecto.Schema

  import Ecto.Changeset

  schema "teams" do
    field :name, :string
    field :abbreviation, :string
    field :flag, :string
    field :points, :integer, default: 0, virtual: true
    field :won_games, :integer, default: 0, virtual: true
    field :lost_games, :integer, default: 0, virtual: true
    field :draw_games, :integer, default: 0, virtual: true
    field :goal_diff, :integer, default: 0, virtual: true

    timestamps(type: :utc_datetime)
  end

  def changeset(team, attrs \\ %{}) do
    team
    |> cast(attrs, [
      :name,
      :abbreviation,
      :flag,
      :points,
      :won_games,
      :lost_games,
      :draw_games,
      :goal_diff
    ])
    |> validate_required([:name, :abbreviation, :flag])
    |> unique_constraint(:name)
    |> unique_constraint(:abbreviation)
    |> validate_number(:points, greater_than_or_equal_to: 0)
    |> validate_number(:won_games, greater_than_or_equal_to: 0)
    |> validate_number(:lost_games, greater_than_or_equal_to: 0)
    |> validate_number(:draw_games, greater_than_or_equal_to: 0)
    |> validate_number(:goal_diff, greater_than_or_equal_to: 0)
  end
end
