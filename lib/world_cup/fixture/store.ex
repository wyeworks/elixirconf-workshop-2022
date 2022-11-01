defmodule WorldCup.Fixture.Store do
  use Agent

  alias WorldCup.Fixture

  def start_link(_initial_value) do
    Agent.start_link(fn -> Fixture.list_matches() end, name: __MODULE__)
  end

  def get_matches do
    Agent.get(__MODULE__, & &1)
  end

  def save_matches(matches) do
    Agent.update(__MODULE__, fn _matches -> matches end)
    matches
  end
end
