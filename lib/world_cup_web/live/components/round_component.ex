defmodule WorldCupWeb.Components.RoundComponent do
  use WorldCupWeb, :live_component

  alias WorldCup.Fixture
  alias WorldCup.Fixture.Result

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
          phx_target={@myself}
          phx-auto-recover="ignore"
          class={match_class(match.played)}
        >
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

  defp match_class(true), do: "match-played"
  defp match_class(false), do: "match-pending"

  defp round_title(round_id) do
    round_id |> String.replace("_", " ") |> String.capitalize()
  end

  def handle_event(
        "update_forecast",
        %{
          "match" => %{
            "match_id" => match_id,
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

    matches = Fixture.update_match_result(match_id, result)

    send(self(), :match_updated)

    round_matches = Enum.filter(matches, &(&1.round == socket.assigns.id))
    {:noreply, assign(socket, :matches, round_matches)}
  end
end
