defmodule WorldCupWeb.ForecastLive do
  use WorldCupWeb, :live_view

  alias WorldCup.Fixture
  alias WorldCupWeb.Components.{RoundsComponent, StandingsComponent}

  def mount(_params, _session, socket) do
    teams = Fixture.calculate_team_stats()
    {:ok, assign(socket, :teams, teams)}
  end

  def render(assigns) do
    ~H"""
      <.live_component module={StandingsComponent} id="results" teams={@teams} />
      <.live_component module={RoundsComponent} id="rounds" />
    """
  end

  def handle_info(:match_updated, socket) do
    teams = Fixture.calculate_team_stats()
    {:noreply, assign(socket, :teams, teams)}
  end
end
