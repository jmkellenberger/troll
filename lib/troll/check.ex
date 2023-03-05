defmodule Troll.Check do
  @moduledoc "Handles Traveller checks"
  alias Troll.Roll
  defstruct ~w[type target outcome rolls modifier total]a

  @type check_type() :: :over | :under
  @type outcome() :: :success | :failure
  @type rolls() :: list(pos_integer)

  @type t :: %__MODULE__{
          type: check_type,
          target: pos_integer(),
          outcome: outcome,
          rolls: rolls,
          modifier: Troll.modifier(),
          total: integer()
        }

  @spec check(Troll.Roll.t(), pos_integer(), check_type()) :: t()
  def check(%Roll{total: total} = roll, target, :over) do
    new(:over, target, roll, outcome(total >= target))
  end

  def check(%Roll{total: total} = roll, target, :under) do
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
