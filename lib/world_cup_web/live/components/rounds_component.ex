defmodule WorldCupWeb.Components.RoundsComponent do
  use WorldCupWeb, :live_component

  alias WorldCup.Fixture
  alias WorldCupWeb.Components.RoundComponent

  def mount(socket) do
    rounds = Fixture.matches_in_rounds()
    {:ok, assign(socket, :rounds, rounds)}
  end

  def render(assigns) do
    ~H"""
      <div class="rounds">
        <%= for {round_id, matches} <- @rounds do %>
          <.live_component module={RoundComponent} id={round_id} matches={matches} />
        <% end %>
      </div>
    """
  end
end
