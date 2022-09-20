defmodule WorldCupWeb.GroupLive do
  use WorldCupWeb, :live_view

  @rounds %{
    "round_1" => %{
      "match_1" => %{
        "home_team" => "URU",
        "away_team" => "KOR"
      },
      "match_2" => %{
        "home_team" => "POR",
        "away_team" => "GHA"
      }
    },
    "round_2" => %{
      "match_1" => %{
        "home_team" => "KOR",
        "away_team" => "GHA"
      },
      "match_2" => %{
        "home_team" => "POR",
        "away_team" => "URU"
      }
    },
    "round_3" => %{
      "match_1" => %{
        "home_team" => "KOR",
        "away_team" => "POR"
      },
      "match_2" => %{
        "home_team" => "GHA",
        "away_team" => "URU"
      }
    }
  }

  def mount(_params, _session, socket) do
    {:ok, assign(socket, :rounds, @rounds)}
  end

  def render(assigns) do
    ~H"""
    <%= for {round_id, matches} <- @rounds do %>
      <%= round_id %>
      <%= for {match_id, match} <- matches do %>
        <.form let={f} for={:match} id={"#{round_id}_#{match_id}"} phx_change="update_forecast" %>
          <%= hidden_input f, :round_id, value: round_id %>
          <%= hidden_input f, :match_id, value: match_id %>

          <%= match["home_team"] %>
          <%= number_input f, :home_score, id: "#{round_id}_#{match["home_team"]}", value: match["result"]["home_score"] || 0 %>
          <%= number_input f, :away_score, id: "#{round_id}_#{match["away_team"]}", value: match["result"]["away_score"] || 0 %>
          <%= match["away_team"] %>
        </.form>
      <% end %>
    <% end %>
    """
  end

  def handle_event("update_forecast", %{"match" => params}, socket) do
    socket = update(socket, :rounds, fn rounds -> update_rounds(rounds, params) end)

    {:noreply, socket}
  end

  defp update_rounds(rounds, %{"round_id" => round_id, "match_id" => match_id} = params) do
    result = Map.take(params, ["home_score", "away_score"])
    update_in(rounds, [round_id, match_id], fn match -> Map.put(match, "result", result) end)
  end
end
