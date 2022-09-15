defmodule WorldCup.Repo do
  use Ecto.Repo,
    otp_app: :world_cup,
    adapter: Ecto.Adapters.Postgres
end
