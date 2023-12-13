defmodule Day12 do

  @spec bind_pattern(String.t(), integer()) :: {:ok, String.t()} | {:error}
  def bind_pattern("#", 0) do
    {:error}
  end
  def bind_pattern(pattern, 0) do
    {:ok, String.split_at(pattern, 1) |> elem(1)}
  end
  def bind_pattern("", _count) do
    {:error}
  end
  def bind_pattern(pattern, number_springs) do
    {next, rest} = String.split_at(pattern, 1)
    case next == "#" || next == "?" do
      true -> bind_pattern(rest, number_springs - 1)
      false -> {:error}
    end
  end
end
