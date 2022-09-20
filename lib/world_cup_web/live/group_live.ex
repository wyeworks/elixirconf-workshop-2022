defmodule WorldCupWeb.GroupLive do
  use WorldCupWeb, :live_view

  alias WorldCup.Fixture
  alias WorldCup.Fixture.{Result, Round}

  def mount(_params, _session, socket) do
    teams = Fixture.list_teams()
    rounds = Fixture.list_rounds()

    socket =
      socket
      |> assign(:rounds, rounds)
      |> assign(:teams, teams)

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
      <%= for round <- @rounds do %>
        <%= for match <- round.matches do %>
          <.form let={f} for={:match} id={"#{round.id}_#{match.id}"} phx_submit="update_forecast" %>
            <!-- Needed to catch these values to have them in the handle_event -->
            <%= hidden_input f, :round_id, value: round.id %>
            <%= hidden_input f, :match_id, value: match.id %>

            <%= match.home_team %>
            <%= number_input f, :home_score, value: match.result.home_score || 0, min: 0 %>
            <%= number_input f, :away_score, value: match.result.away_score || 0, min: 0 %>
            <%= match.away_team %>

            <%= submit do: "Send" %>
          </.form>
        <% end %>
      <% end %>
    """
  end

  def handle_event(
    "update_forecast",
    %{
      "match" => %{
        "round_id" => round_id,
        "match_id" => match_id,
        "home_score" => home_score,
        "away_score" => away_score
      }
    } = _params,
    socket) do
    result = %Result{
      home_score: String.to_integer(home_score),
      away_score: String.to_integer(away_score)
    }

    socket = update(socket, :rounds,
      fn rounds ->
        update_in_list(rounds, round_id, fn round ->
          %Round{
            id: round.id,
            matches: update_in_list(round.matches, match_id, fn match -> Map.put(match, :result, result) end)
          }
        end)
      end)

    {:noreply, socket}
  end

  defp update_in_list(list, entity_id, update_fn) do
    Enum.map(list, fn
      entity when entity.id == entity_id -> update_fn.(entity)
      e -> e
    end)
  end
end
