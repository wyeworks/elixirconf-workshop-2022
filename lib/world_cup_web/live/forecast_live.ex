defmodule WorldCupWeb.ForecastLive do
  use WorldCupWeb, :live_view

  alias WorldCup.Fixture
  alias WorldCup.Fixture.Result
  alias WorldCupWeb.Components.{RoundComponent, ResultsComponent}

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
    <div>
      <.live_component module={ResultsComponent} id="results" teams={@teams} />

      <div class="flex justify-center mt-10">
        <%= for {round_id, matches} <- get_rounds(@matches) do %>
          <.live_component module={RoundComponent} id={round_id} matches={matches} />
        <% end %>
      </div>
    </div>
    """
  end

  defp get_rounds(matches) do
    Fixture.split_in_rounds(matches)
  end

  def handle_event(
        "update_forecast",
        %{
          "match" => %{
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

    matches = Fixture.update_match_result(socket.assigns.matches, match_id, result)
    teams = Fixture.update_teams_stats(matches)

    socket =
      socket
      |> assign(:matches, matches)
      |> assign(:teams, teams)

    {:noreply, socket}
  end
end
