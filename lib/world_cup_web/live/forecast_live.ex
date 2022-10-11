defmodule WorldCupWeb.ForecastLive do
  use WorldCupWeb, :live_view

  alias WorldCup.Fixture

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
              <td><%= team.name %></td>
              <td><%= team.points %></td>
            </tr>
          <% end %>
        </tbody>
      </table>

      <%= for match <- @matches do %>
        <div>
        <%= match.home_team.name %> vs <%= match.away_team.name %>
        </div>
      <% end %>
    """
  end
end
