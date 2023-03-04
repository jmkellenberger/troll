defmodule Troll.Flux do
  @moduledoc "Handles Traveller5 style flux rolls"
  alias Troll.Roll
  defstruct ~w[type total first second modifier]a

  @type flux_type() :: :bad | :good | :neutral
  @type modifier() :: number()

  @type t :: %__MODULE__{
          type: flux_type(),
          total: number(),
          first: pos_integer(),
          second: pos_integer(),
          modifier: modifier()
        }

  @spec roll(modifier(), flux_type()) :: Troll.Flux.t()
  def roll(modifier, type) do
    Roll.roll("2d6")
    |> elem(1)
    |> flux(modifier, type)
  end

  @spec flux(Troll.Roll.t(), modifier(), flux_type()) :: Troll.Flux.t()
  defp flux(%Roll{max: d2, min: d1}, modifier, :bad) do
    new(:bad, d1, d2, modifier)
  end

  defp flux(%Roll{max: d1, min: d2}, modifier, :good) do
    new(:good, d1, d2, modifier)
  end

  defp flux(%Roll{rolls: [d1, d2]}, modifier, :neutral) do
    new(:neutral, d1, d2, modifier)
  end

  defp new(type, d1, d2, modifier) do
    %__MODULE__{
      type: type,
      first: d1,
      second: d2,
      modifier: modifier,
      total: d1 - d2 + modifier
    }
  end
end
