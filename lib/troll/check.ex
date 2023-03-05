defmodule Troll.Check do
  @moduledoc "Handles Traveller checks"
  alias Troll.Roll
  defstruct ~w[type target outcome rolls modifier total]a

  @type check_type() :: :over | :under
  @type target() :: pos_integer()
  @type outcome() :: :success | :failure
  @type rolls() :: list(pos_integer)
  @type modifier() :: integer()
  @type total() :: integer()

  @type t :: %__MODULE__{
          type: check_type,
          target: target,
          outcome: outcome,
          rolls: rolls,
          modifier: modifier,
          total: total
        }

  def roll(modifier, target, type \\ :over) do
    Roll.roll(2, 6, modifier)
    |> IO.inspect()
    |> check(target, type)
  end

  defp check(roll, target, :over) do
    total = roll.total

    outcome =
      if total >= target do
        :success
      else
        :failure
      end

    %__MODULE__{
      type: :over,
      target: target,
      outcome: outcome,
      rolls: roll.rolls,
      modifier: roll.modifier,
      total: total
    }
  end

  defp check(roll, target, :under) do
    total = roll.total

    outcome =
      if total <= target do
        :success
      else
        :failure
      end

    %__MODULE__{
      type: :under,
      target: target,
      outcome: outcome,
      rolls: roll.rolls,
      modifier: roll.modifier,
      total: total
    }
  end
end
