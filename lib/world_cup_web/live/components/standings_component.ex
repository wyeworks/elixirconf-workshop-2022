defmodule WorldCupWeb.Components.StandingsComponent do
  use WorldCupWeb, :live_component

  alias WorldCup.Fixture.Team

  def render(assigns) do
    ~H"""
    <table>
      <thead>
        <tr>
          <th>Position</th>
          <th class="table-team-name">Name</th>
          <th>Points</th>
          <th>Played</th>
          <th>Won</th>
          <th>Draw</th>
          <th>Lost</th>
          <th>Goal diff.</th>
        </tr>
      </thead>
      <tbody>
        <%= for {team, index} <- Enum.with_index(@teams, 1) do %>
          <tr class={row_class(team)}>
            <td><%= index %></td>
            <td class="table-team-name"><b><%= "#{team.flag} #{team.name}" %></b></td>
            <td><b><%= team.points %></b></td>
            <td><%= team.won_games + team.draw_games + team.lost_games %></td>
            <td><%= team.won_games %></td>
            <td><%= team.draw_games %></td>
            <td><%= team.lost_games %></td>
            <td><%= team.goal_diff %></td>
          </tr>
        <% end %>
      </tbody>
    </table>
    """
  end

  defp row_class(%Team{name: "Uruguay"}), do: "table-highlight-row"
  defp row_class(%Team{}), do: ""
end
