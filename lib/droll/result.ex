defmodule Droll.Result do
  @moduledoc "Contains the total and other calculations for a roll"
  defstruct total: 0, rolls: [], modifier: 0, min: 0, max: 0, avg: 0

  @type t() :: %Droll.Result{
          total: number(),
          rolls: [pos_integer()],
          modifier: number(),
          min: number(),
          max: number(),
          avg: number()
        }
end
