defmodule WorldCupWeb.Components.RoundComponent do
  use WorldCupWeb, :live_component

  def render(assigns) do
    ~H"""
    <div>
      <%= round_title(@round.id) %>
      <%= for match <- @round.matches do %>
        <.form let={f} for={:match} id={"#{@round.id}_#{match.id}"} phx_submit="update_forecast" %>
          <!-- Needed to catch these values to have them in the handle_event -->
          <%= hidden_input(f, :round_id, value: @round.id) %>
          <%= hidden_input(f, :match_id, value: match.id) %>

          <%= match.home_team.name %>
          <%= number_input(f, :home_score, value: match.result.home_score || 0, min: 0) %>
          <%= number_input(f, :away_score, value: match.result.away_score || 0, min: 0) %>
          <%= match.away_team.name %>

          <%= submit(do: "Send") %>
        </.form>
      <% end %>
    </div>
    """
  end

  defp round_title(round_id) do
    String.replace(round_id, "_", " ") |> String.capitalize()
  end
end
