defmodule WorldCupWeb.Components.ResultsComponent do
  use WorldCupWeb, :live_component

  def render(assigns) do
    ~H"""
    <table>
      <thead>
        <tr>
          <th>Position</th>
          <th>Name</th>
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
          <tr class={highlight_la_celeste(team.abbreviation)}>
            <td><%= index %></td>
            <td><%= ~s(#{team.flag} #{team.abbreviation}) %></td>
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

  defp highlight_la_celeste("URU" = _team_abbreviation), do: "highlight-row"
  defp highlight_la_celeste(_team_abbreviation), do: ""
end
