defmodule WorldCupWeb.ForecastLive do
  use WorldCupWeb, :live_view

  alias WorldCup.Fixture
  alias WorldCupWeb.Components.{RoundComponent, ResultsComponent}

  def mount(_params, _session, socket) do
    matches = Fixture.list_matches()
    teams = Fixture.calculate_teams_stats(matches)

    socket =
      socket
      |> assign(:teams, teams)
      |> assign(:matches, matches)

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <.live_component module={ResultsComponent} id="results" teams={@teams} />

    <h1>Fixture</h1>
    <%= for {round_id, matches} <- get_rounds(@matches) do %>
      <.live_component module={RoundComponent} id={round_id} matches={matches} />
    <% end %>
    """
  end

  defp get_rounds(matches) do
    Fixture.split_in_rounds(matches)
  end

  def handle_event(
        "update_forecast",
        %{
          "result" => %{
            "match_id" => match_id,
            "home_score" => home_score,
            "away_score" => away_score
          }
        } = _params,
        socket
      ) do
    match_id = String.to_integer(match_id)

    new_result = %{
      home_score: String.to_integer(home_score),
      away_score: String.to_integer(away_score),
      match_id: match_id
    }

    match = Enum.find(socket.assigns.matches, fn match -> match.id == match_id end)

    socket =
      case Fixture.update_match_result(match, new_result) do
        {:ok, _result_and_match} ->
          matches = Fixture.list_matches()
          teams = Fixture.calculate_teams_stats(matches)

          socket
          |> assign(:matches, matches)
          |> assign(:teams, teams)

        {:error, _, _, _} ->
          put_flash(
            socket,
            :error,
            "Result couldn't be updated"
          )
      end

    {:noreply, socket}
  end
end
