defmodule WorldCupWeb.Components.RoundComponent do
  use WorldCupWeb, :live_component

  def render(assigns) do
    ~H"""
    <div class="round">
      <h3><%= round_title(@id) %></h3>
      <%= for match <- @matches do %>
        <div>
          <%= match.home_team.name %> vs <%= match.away_team.name %>
        </div>
      <% end %>
    </div>
    """
  end

  defp round_title(round_id) do
    round_id |> String.replace("_", " ") |> String.capitalize()
  end
end
