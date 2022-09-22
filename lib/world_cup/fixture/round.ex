defmodule WorldCup.Fixture.Round do
  alias WorldCup.Fixture.Match

  defstruct [:id, :matches]

  @type t() :: %__MODULE__{
          id: String.t(),
          matches: list(Match.t())
        }
end
