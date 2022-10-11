defmodule WorldCupWeb.Components.StandingsComponent do
  use WorldCupWeb, :live_component

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
            <td><b><%= team.points %></b></td>
          </tr>
        <% end %>
      </tbody>
    </table>
    """
  end
end
