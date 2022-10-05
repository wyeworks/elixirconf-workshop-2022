defmodule WorldCup.Repo.Migrations.AddMatchesTable do
  use Ecto.Migration

  def change do
    create table(:matches) do
      add :played, :boolean, default: false
      add :round, :string, null: false

      add :home_team_id, references(:teams)
      add :away_team_id, references(:teams)

      timestamps(type: :utc_datetime)
    end
  end
end
