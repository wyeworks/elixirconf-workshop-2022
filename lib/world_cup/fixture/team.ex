defmodule WorldCup.Fixture.Team do
  defstruct [:id, :abbreviation, :name, points: 0]

  @type t() :: %__MODULE__{
    id: String.t(),
    abbreviation: String.t(),
    name: String.t(),
    points: Integer.t()
  }
end
