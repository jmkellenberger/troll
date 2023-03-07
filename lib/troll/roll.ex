defmodule Troll.Roll do
  @moduledoc "Contains the total and other calculations for a roll"
  defstruct ~w[formula total rolls modifier min max avg]a

  alias Troll.Formula

  @type t() :: %__MODULE__{
          formula: Troll.dice_formula(),
          total: number(),
          rolls: [pos_integer()],
          modifier: integer(),
          min: number(),
          max: number(),
          avg: number()
        }

  @doc """
  Execute a roll based on a formula. See `Troll.parse/1` for more information
  """
  @spec parse(Troll.dice_expression()) :: {:error, binary} | {:ok, Troll.Roll.t()}
  def parse(formula) when is_binary(formula) do
    with {:ok, formula} <- Formula.parse(formula) do
      {:ok, roll(formula)}
    end
  end

  @spec roll(pos_integer, pos_integer, number) :: Troll.Roll.t()
  def roll(dice, sides, modifier) when dice > 0 and sides > 0 do
    Formula.new(dice, sides, modifier)
    |> roll()
  end

  defp roll(%Formula{} = formula) do
    formula
    |> new()
    |> apply_roll(formula)
    |> total()
    |> apply_modifier(formula)
    |> min()
    |> max()
    |> avg()
  end

  defp roll_dice(num_dice, num_sides) when num_dice > 0 and num_sides > 1 do
    for _ <- 1..num_dice, do: :rand.uniform(num_sides)
  end

  defp new(%Formula{expression: input}) do
    %__MODULE__{
      formula: input,
      total: 0,
      rolls: [],
      modifier: 0,
      min: 0,
      max: 0,
      avg: 0
    }
  end

  @spec apply_roll(t(), Formula.t()) :: t()
  defp apply_roll(
         roll,
         %Formula{
           num_dice: num_dice,
           num_sides: num_sides
         }
       ),
       do: %{roll | rolls: roll_dice(num_dice, num_sides)}

  @spec apply_modifier(t(), Formula.t()) :: t()
  defp apply_modifier(
         %__MODULE__{total: total} = roll,
         %Formula{
           modifier: modifier,
           operation: :+
         }
       ),
       do: %{roll | total: total + modifier, modifier: modifier}

  defp apply_modifier(
         %__MODULE__{total: total} = roll,
         %Formula{
           modifier: modifier,
           operation: :-
         }
       ),
       do: %{roll | total: total - modifier, modifier: -modifier}

  defp apply_modifier(
         %__MODULE__{total: total} = roll,
         %Formula{
           modifier: modifier,
           operation: :/
         }
       ),
       do: %{roll | total: total / modifier, modifier: modifier}

  defp apply_modifier(
         %__MODULE__{total: total} = roll,
         %Formula{
           modifier: modifier,
           operation: :x
         }
       ),
       do: %{roll | total: total * modifier, modifier: modifier}

  @spec total(t()) :: t()
  defp total(%__MODULE__{rolls: rolls} = roll),
    do: %{roll | total: Enum.sum(rolls)}

  @spec min(t()) :: t()
  defp min(%__MODULE__{rolls: rolls} = roll),
    do: %{roll | min: Enum.min(rolls)}

  @spec max(t()) :: t()
  defp max(%__MODULE__{rolls: rolls} = roll),
    do: %{roll | max: Enum.max(rolls)}

  @spec avg(t()) :: t()
  defp avg(%__MODULE__{rolls: rolls, total: total} = roll),
    do: %{roll | avg: total / length(rolls)}
end
