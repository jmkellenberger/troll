defmodule Troll.Flux do
  @moduledoc "Handles Traveller5 style flux rolls"
  alias Troll.Roll
  defstruct ~w[type first second modifier total formula]a

  @type flux_type() :: :bad | :good | :neutral

  @type t :: %__MODULE__{
          type: flux_type(),
          total: integer(),
          first: pos_integer(),
          second: pos_integer(),
          modifier: integer()
        }

  defp new(type, d1, d2, modifier, formula) do
    %__MODULE__{
      type: type,
      first: d1,
      second: d2,
      modifier: modifier,
      total: d1 - d2 + modifier,
      formula: formula
    }
  end

  @spec flux(Troll.Roll.t(), flux_type()) :: Troll.Flux.t()
  def flux(%Roll{max: d2, min: d1, modifier: modifier, formula: formula}, :bad) do
    new(:bad, d1, d2, modifier, formula)
  end

  def flux(%Roll{max: d1, min: d2, modifier: modifier, formula: formula}, :good) do
    new(:good, d1, d2, modifier, formula)
  end

  def flux(%Roll{rolls: [d1, d2], modifier: modifier, formula: formula}, :neutral) do
    new(:neutral, d1, d2, modifier, formula)
  end
end
