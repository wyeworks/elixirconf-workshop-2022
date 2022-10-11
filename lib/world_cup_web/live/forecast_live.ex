defmodule WorldCupWeb.ForecastLive do
  use WorldCupWeb, :live_view

  alias WorldCup.Fixture
  alias WorldCupWeb.Components.RoundComponent

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
