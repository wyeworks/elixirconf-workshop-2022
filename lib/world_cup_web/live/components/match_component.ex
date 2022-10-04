defmodule WorldCupWeb.Components.MatchComponent do
  use WorldCupWeb, :live_component

  alias WorldCup.Fixture
  alias WorldCup.Fixture.Result

  def preload(list_of_assigns) do
    matches = Fixture.list_matches()

    Enum.map(list_of_assigns, fn assigns ->
      Map.put(assigns, :match, Enum.find(matches, fn match -> match.id == assigns.id end))
    end)
  end

  def render(assigns) do
    ~H"""
      <div>
        <.form let={f} for={:match} phx_submit="update_forecast" phx-target={@myself}>
          <%= @match.home_team.name %>
          <%= number_input(f, :home_score, value: @match.result.home_score || 0, min: 0) %>
          <%= number_input(f, :away_score, value: @match.result.away_score || 0, min: 0) %>
          <%= @match.away_team.name %>

          <%= submit(do: "Send") %>
        </.form>
      </div>
    """
  end

  def handle_event(
    "update_forecast",
    %{
      "match" => %{
        "home_score" => home_score,
        "away_score" => away_score
      }
    } = _params,
    socket
  ) do
    result = %Result{
      home_score: String.to_integer(home_score),
      away_score: String.to_integer(away_score)
    }

    match = Fixture.update_match_result(socket.assigns.match, result)

    send(socket.root_pid, {:updated_match, match})

    {:noreply, socket}
  end
end
