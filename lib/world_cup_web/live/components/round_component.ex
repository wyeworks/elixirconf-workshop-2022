defmodule WorldCupWeb.Components.RoundComponent do
  use WorldCupWeb, :live_component

  def render(assigns) do
    ~H"""
    <div class="round">
      <h3><%= round_title(@id) %></h3>
      <%= for match <- @matches do %>
        <.form let={f} for={:match} id={match.id} phx_change="update_forecast" class="match-pending">
          <%= hidden_input(f, :match_id, value: match.id) %>

          <div class="team-input">
            <p class="team-name"><%= ~s(#{match.home_team.flag} #{match.home_team.abbreviation}) %></p>
            <%= number_input(f, :home_score, value: match.result.home_score, min: 0) %>
          </div>

          <div class="team-input">
            <p class="team-name"><%= ~s(#{match.away_team.flag} #{match.away_team.abbreviation}) %></p>
            <%= number_input(f, :away_score, value: match.result.away_score, min: 0) %>
          </div>
        </.form>
      <% end %>
    </div>
    """
  end

  defp round_title(round_id) do
    round_id |> String.replace("_", " ") |> String.capitalize()
  end
end
