defmodule WorldCupWeb.GroupLive do
  use WorldCupWeb, :live_view

  alias WorldCup.Fixture
  alias WorldCup.Fixture.Result

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
      <h1>Fixture</h1>
      <%= for round <- @rounds do %>
        <%= for match <- round.matches do %>
          <.form let={f} for={:match} id={"#{round.id}_#{match.id}"} phx_submit="update_forecast" %>
            <!-- Needed to catch these values to have them in the handle_event -->
            <%= hidden_input f, :round_id, value: round.id %>
            <%= hidden_input f, :match_id, value: match.id %>

            <%= match.home_team.name %>
            <%= number_input f, :home_score, value: match.result.home_score || 0, min: 0 %>
            <%= number_input f, :away_score, value: match.result.away_score || 0, min: 0 %>
            <%= match.away_team.name %>

            <%= submit do: "Send" %>
          </.form>
        <% end %>
      <% end %>

      <h1>Results</h1>
      <table>
        <thead>
          <tr>
            <th>Position</th>
            <th>Name</th>
            <th>Points</th>
          </tr>
        </thead>
        <tbody>
          <%= for {team, index} <- Enum.with_index(@teams, 1) do %>
            <tr>
              <td><%= index %></td>
              <td><%= team.abbreviation %></td>
              <td><%= team.points %></td>
            </tr>
          <% end %>
        </tbody>
      </table>
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
    socket) do
    result = %Result{
      home_score: String.to_integer(home_score),
      away_score: String.to_integer(away_score)
    }

    rounds = Fixture.update_match_result(socket.assigns.rounds, round_id, match_id, result)
    teams = Fixture.set_teams_points(rounds)

    socket =
      socket
      |> assign(:rounds, rounds)
      |> assign(:teams, teams)

    {:noreply, socket}
  end
end
