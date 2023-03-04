defmodule Troll.Roll do
  @moduledoc "Contains the total and other calculations for a roll"
  defstruct ~w[formula total rolls modifier min max avg]a

  alias Troll.Formula

  @type t() :: %__MODULE__{
          formula: Troll.dice_formula(),
          total: number(),
          rolls: [pos_integer()],
          modifier: number(),
          min: number(),
          max: number(),
          avg: number()
        }

  @spec roll(Troll.dice_formula()) :: {:ok, Troll.t()} | {:error, String.t()}
  @doc """
  Execute a roll based on a formula. See `Troll.parse/1` for more information
  """
  def roll(formula_str) do
    with {:ok, formula} <- Formula.parse(formula_str) do
      {
        :ok,
        formula
        |> new()
        |> apply_roll(formula)
        |> total()
        |> apply_modifier(formula)
        |> min()
        |> max()
        |> avg()
      }
    end
  end

  defp new(%Formula{input: input}) do
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
    do: %{roll | min: Enum.max(rolls)}

  @spec avg(t()) :: t()
  defp avg(%__MODULE__{rolls: rolls, total: total} = roll),
    do: %{roll | avg: total / length(rolls)}

  defp roll_dice(num_dice, num_sides) do
    for _ <- 1..num_dice, do: :rand.uniform(num_sides)
  end
end
