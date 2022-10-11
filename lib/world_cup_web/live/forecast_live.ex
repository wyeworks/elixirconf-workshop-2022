defmodule WorldCupWeb.ForecastLive do
  use WorldCupWeb, :live_view

  alias WorldCup.Fixture
  alias WorldCupWeb.Components.{RoundComponent, StandingsComponent}

  def mount(_params, _session, socket) do
    teams = Fixture.list_teams()
    matches = Fixture.list_matches()

    socket =
      socket
      |> assign(:teams, teams)
      |> assign(:matches, matches)

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
      <.live_component module={StandingsComponent} id="results" teams={@teams} />

      <div class="rounds">
        <%= for {round_id, matches} <- get_rounds(@matches) do %>
          <.live_component module={RoundComponent} id={round_id} matches={matches} />
        <% end %>
      </div>
    """
  end

  defp get_rounds(matches) do
    Fixture.split_in_rounds(matches)
  end
end
