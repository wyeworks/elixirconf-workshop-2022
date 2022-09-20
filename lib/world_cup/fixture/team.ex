defmodule WorldCup.Fixture.Team do
  defstruct [:abbreviation, :name, :ranking]

  @type t() :: %__MODULE__{
    abbreviation: String.t(),
    name: String.t(),
    ranking: Integer.t()
  }
end
