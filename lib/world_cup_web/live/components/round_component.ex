defmodule WorldCupWeb.Components.RoundComponent do
  use WorldCupWeb, :live_component

  def render(assigns) do
    ~H"""
    <div class="round">
      <h3><%= round_title(@id) %></h3>
      <%= for match <- @matches do %>
        <.form
          let={f}
          for={:match}
          id={match.id}
          phx_change="update_forecast"
          class={match_class(match.played)}
        >
          <!-- Needed to catch this value to have it in the handle_event -->
          <%= hidden_input(f, :match_id, value: match.id) %>

          <div class="team-input">
            <p class="team-name"><%= ~s(#{match.home_team.flag} #{match.home_team.abbreviation}) %></p>
            <%= number_input(f, :home_score,
              value: match.result.home_score || 0,
              min: 0,
              phx_debounce: "100"
            ) %>
          </div>
          <div class="team-input">
            <p class="team-name"><%= ~s(#{match.away_team.flag} #{match.away_team.abbreviation}) %></p>
            <%= number_input(f, :away_score,
              value: match.result.away_score || 0,
              min: 0,
              phx_debounce: "100"
            ) %>
          </div>
        </.form>
      <% end %>
    </div>
    """
  end

  defp round_title(round_id) do
    round_id |> String.replace("_", " ") |> String.capitalize()
  end

  defp match_class(true), do: "match-played"
  defp match_class(false), do: "match-pending"
end
