defmodule WorldCupWeb.Components.MatchFormComponent do
  use WorldCupWeb, :live_component

  alias WorldCup.Fixture
  alias WorldCup.Fixture.Result

  def render(assigns) do
    ~H"""
    <div>
      <.form
        let={f}
        for={Result.changeset(@match.result)}
        id={"#{@match.id}"}
        phx_change="update_forecast"
        phx_target={@myself}
        phx-auto-recover="ignore"
        class={match_class(@match.played)}
      >
        <div class="team-input">
          <p class="team-name"><%= ~s(#{@match.home_team.flag} #{@match.home_team.abbreviation}) %></p>
          <%= number_input(f, :home_score, value: @match.result.home_score, min: 0) %>
        </div>

        <div class="team-input">
          <p class="team-name"><%= ~s(#{@match.away_team.flag} #{@match.away_team.abbreviation}) %></p>
          <%= number_input(f, :away_score, value: @match.result.away_score, min: 0) %>
        </div>
      </.form>
    </div>
    """
  end

  defp match_class(true), do: "match-played"
  defp match_class(false), do: "match-pending"

  def handle_event(
        "update_forecast",
        %{
          "result" => %{
            "home_score" => home_score,
            "away_score" => away_score
          }
        } = _params,
        %{
          assigns: %{
            match: match
          }
        } = socket
      ) do
    new_result = %{
      home_score: String.to_integer(home_score),
      away_score: String.to_integer(away_score),
      match_id: match.id
    }

    socket =
      case Fixture.update_match_result(match, new_result) do
        {:ok, %{match: match}} ->
          # Notify parent live view (ForecastLive)
          send(self(), :match_updated)

          assign(socket, :match, match)

        {:error, _, _, _} ->
          put_flash(
            socket,
            :error,
            "Result couldn't be updated"
          )
      end

    {:noreply, socket}
  end
end
