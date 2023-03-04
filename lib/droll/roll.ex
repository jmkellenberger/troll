defmodule Droll.Roll do
  @moduledoc "Contains the total and other calculations for a roll"
  defstruct [:formula, total: 0, rolls: [], modifier: 0, min: 0, max: 0, avg: 0]

  alias Droll.Formula

  @type t() :: %__MODULE__{
          formula: Droll.dice_formula(),
          total: number(),
          rolls: [pos_integer()],
          modifier: number(),
          min: number(),
          max: number(),
          avg: number()
        }
  @spec roll(Droll.dice_formula()) :: {:ok, Droll.Result.t()} | {:error, String.t()}
  @doc """
  Execute a roll based on a formula. See `Droll.parse/1` for more information
  """
  def roll(formula_str) do
    with {:ok, formula} <- Formula.parse(formula_str) do
      {:ok,
       formula
       |> new()
       |> apply_roll(formula)
       |> apply_modifier(formula)
       |> total()
       |> min()
       |> max()
       |> avg()}
    end
  end

  defp new(%Formula{input: input}) do
    %__MODULE__{formula: input}
  end

  @spec apply_roll(Result.t(), Formula.t()) :: Result.t()
  defp apply_roll(result, formula) do
    rolls =
      Enum.map(1..formula.num_dice, fn _ ->
        1 + :erlang.floor(:rand.uniform() * formula.num_sides)
      end)

    %{result | rolls: rolls}
  end

  @spec apply_modifier(Result.t(), Formula.t()) :: Result.t()
  defp apply_modifier(result, %{modifier: modifier, operation: :+}),
    do: %{result | total: result.total + modifier, modifier: modifier}

  defp apply_modifier(result, %{modifier: modifier, operation: :-}),
    do: %{result | total: result.total - modifier, modifier: -modifier}

  defp apply_modifier(result, %{modifier: modifier, operation: :/}),
    do: %{result | total: result.total / modifier, modifier: modifier}

  defp apply_modifier(result, %{modifier: modifier, operation: :x}),
    do: %{result | total: result.total * modifier, modifier: modifier}

  @spec total(Result.t()) :: Result.t()
  defp total(result) do
    Enum.reduce(1..Enum.count(result.rolls), result, fn b, result ->
      %{result | total: result.total + Enum.at(result.rolls, b - 1)}
    end)
  end

  @spec min(Result.t()) :: Result.t()
  defp min(result), do: %{result | min: Enum.min(result.rolls)}

  @spec max(Result.t()) :: Result.t()
  defp max(result), do: %{result | min: Enum.max(result.rolls)}

  @spec avg(Result.t()) :: Result.t()
  defp avg(result), do: %{result | avg: result.total / Enum.count(result.rolls)}
end
