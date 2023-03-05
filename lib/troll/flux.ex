defmodule Troll.Flux do
  @moduledoc "Handles Traveller5 style flux rolls"
  alias Troll.Roll
  defstruct ~w[type first second modifier total]a

  @type flux_type() :: :bad | :good | :neutral
  @type modifier() :: number()

  @type t :: %__MODULE__{
          type: flux_type(),
          total: number(),
          first: pos_integer(),
          second: pos_integer(),
          modifier: modifier()
        }

  defp new(type, d1, d2, modifier) do
    %__MODULE__{
      type: type,
      first: d1,
      second: d2,
      modifier: modifier,
      total: d1 - d2 + modifier
    }
  end

  @spec roll(modifier(), flux_type()) :: Troll.Flux.t()
  def roll(modifier, type) do
    Roll.roll(2, 6, modifier)
    |> flux(type)
  end

  defp flux(%Roll{max: d2, min: d1, modifier: modifier}, :bad) do
    new(:bad, d1, d2, modifier)
  end

  defp flux(%Roll{max: d1, min: d2, modifier: modifier}, :good) do
    new(:good, d1, d2, modifier)
  end

  defp flux(%Roll{rolls: [d1, d2], modifier: modifier}, :neutral) do
    new(:neutral, d1, d2, modifier)
  end
end
