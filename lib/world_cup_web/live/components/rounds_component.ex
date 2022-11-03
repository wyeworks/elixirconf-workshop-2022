defmodule WorldCupWeb.Components.RoundsComponent do
  use WorldCupWeb, :live_component

  alias WorldCup.Fixture
  alias WorldCupWeb.Components.MatchFormComponent

  def mount(socket) do
    rounds = Fixture.matches_in_rounds()
    {:ok, assign(socket, :rounds, rounds)}
  end

  def render(assigns) do
    ~H"""
      <div class="rounds">
        <%= for {round_id, matches} <- @rounds do %>
          <div class="round">
            <h3><%= round_title(round_id) %></h3>
            <%= for match <- matches do %>
              <.live_component module={MatchFormComponent} id={match.id} match={match} />
            <% end %>
          </div>
        <% end %>
      </div>
    """
  end

  defp round_title(round_id) do
    round_id |> String.replace("_", " ") |> String.capitalize()
  end
end
