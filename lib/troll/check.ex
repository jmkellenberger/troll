defmodule Troll.Check do
  @moduledoc "Handles Traveller checks"
  alias Troll.Roll
  defstruct ~w[type target outcome rolls modifier total]a

  @type check_type() :: :over | :under
  @type target() :: pos_integer()
  @type outcome() :: :success | :failure
  @type rolls() :: list(pos_integer)
  @type total() :: integer()

  @type t :: %__MODULE__{
          type: check_type,
          target: target,
          outcome: outcome,
          rolls: rolls,
          modifier: Troll.modifier(),
          total: total
        }

  @spec roll(target, Troll.modifier(), check_type) :: t()
  def roll(target, modifier, type) do
    Roll.roll(2, 6, modifier)
    |> check(target, type)
  end

  defp check(%Roll{total: total} = roll, target, :over) do
    new(:over, target, roll, outcome(total >= target))
  end

  defp check(%Roll{total: total} = roll, target, :under) do
    new(:under, target, roll, outcome(total <= target))
  end

  defp outcome(true), do: :success
  defp outcome(false), do: :failure

  defp new(type, target, roll, outcome) do
    %__MODULE__{
      type: type,
      target: target,
      outcome: outcome,
      rolls: roll.rolls,
      modifier: roll.modifier,
      total: roll.total
    }
  end
end
