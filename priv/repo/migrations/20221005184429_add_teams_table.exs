defmodule WorldCup.Repo.Migrations.AddTeamsTable do
  use Ecto.Migration

  def change do
    create table(:teams) do
      add :name, :string, null: false
      add :abbreviation, :string, null: false
      add :flag, :string, null: false

      timestamps(type: :utc_datetime)
    end

    create unique_index(:teams, [:name])
    create unique_index(:teams, [:abbreviation])
  end
end
