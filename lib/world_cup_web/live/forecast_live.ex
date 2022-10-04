defmodule WorldCupWeb.ForecastLive do
  use WorldCupWeb, :live_view

  alias WorldCup.Fixture
  alias WorldCup.Fixture.Result
  alias WorldCupWeb.Components.{MatchComponent, ResultsComponent}

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
    <.live_component module={ResultsComponent} id="results" teams={@teams} />

    <h1>Fixture</h1>
    <%= for {round_id, matches} <- get_rounds(@matches) do %>
      <h3><%= round_title(round_id) %></h3>

      <%= for match_id <- get_matches_ids(matches) do %>
        <.live_component module={MatchComponent} id={match_id} />
      <% end %>
    <% end %>
    """
  end

  defp round_title(round_id) do
    round_id |> String.replace("_", " ") |> String.capitalize()
  end

  defp get_rounds(matches) do
    Fixture.split_in_rounds(matches)
  end

  defp get_matches_ids(matches), do: Enum.map(matches, & &1.id)

  def handle_info({:updated_match, match}, socket) do
    matches = Fixture.update_matches(socket.assigns.matches, match)
    teams = Fixture.update_teams_stats(matches)

    socket =
      socket
      |> assign(:matches, matches)
      |> assign(:teams, teams)

    send_update MatchComponent, id: match.id

    {:noreply, socket}
  end
end
