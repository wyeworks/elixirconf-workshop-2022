defmodule WorldCupWeb.ForecastLive do
  use WorldCupWeb, :live_view

  alias WorldCup.Fixture
  alias WorldCup.Fixture.Result
  alias WorldCupWeb.Components.{RoundComponent, ResultsComponent}

  def mount(_params, _session, socket) do
    teams = Fixture.list_teams()
    rounds = Fixture.list_rounds()

    socket =
      socket
      |> assign(:rounds, rounds)
      |> assign(:teams, teams)

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <.live_component module={ResultsComponent} id="results" teams={@teams} />

    <h1>Fixture</h1>
    <%= for round <- @rounds do %>
      <.live_component module={RoundComponent} id={round.id} round={round} />
    <% end %>
    """
  end

  def handle_event(
        "update_forecast",
        %{
          "match" => %{
            "round_id" => round_id,
            "match_id" => match_id,
            "home_score" => home_score,
            "away_score" => away_score
          }
        } = _params,
        socket
      ) do
    result = %Result{
      home_score: String.to_integer(home_score),
      away_score: String.to_integer(away_score)
    }

    rounds = Fixture.update_match_result(socket.assigns.rounds, round_id, match_id, result)
    teams = Fixture.set_teams_stats(rounds)

    socket =
      socket
      |> assign(:rounds, rounds)
      |> assign(:teams, teams)

    {:noreply, socket}
  end
end
