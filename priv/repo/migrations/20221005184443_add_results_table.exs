defmodule WorldCup.Repo.Migrations.AddResultsTable do
  use Ecto.Migration

  def change do
    create table(:results) do
      add :home_score, :integer, default: 0
      add :away_score, :integer, default: 0

      add :match_id, references(:matches)

      timestamps(type: :utc_datetime)
    end

    create unique_index(:results, [:match_id])
  end
end
