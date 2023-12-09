defmodule Day9 do

  def run() do
    lines = Common.open(File.cwd, "day9.txt") |> Common.read_file_pipe() |> Common.close()

    numbers = Enum.map(lines, fn line -> String.split(line) |> Enum.map(fn str_num -> String.to_integer(str_num) end) end)

    deltas = for variable_list <- numbers, do: Day9.compute_deltas(variable_list)

    next_steps = for delta_list <- deltas, do: (Day9.tails(delta_list) |> Day9.compute_next_step)

    IO.puts("The sum of the next steps of all of the inputs is #{Integer.to_string(Enum.sum(next_steps))}")

    prev_steps = for delta_list <- deltas, do: (Day9.heads(delta_list) |> compute_prev_step())

    IO.puts("The sum of the previous steps of all the inputs is #{Integer.to_string(Enum.sum(prev_steps))}")

  end

  @spec compute_step(list(integer())) :: list(integer())
  def compute_step([head | tail]) do
    compute_step(tail, head)
  end

  defp compute_step([], _) do
    []
  end
  defp compute_step([head | tail], last_int) do
    [head - last_int] ++ compute_step(tail, head)
  end

  @spec all_zero?(list(integer())) :: boolean()
  def all_zero?(sequence) do
    Enum.all?(sequence, fn elem -> elem == 0 end)
  end

  @spec compute_deltas(list(integer())) :: list((list(integer())))
  def compute_deltas(start_sequence) do
    delta = compute_step(start_sequence)

    case all_zero?(delta) do
      true -> [start_sequence, delta]
      false -> [start_sequence] ++ compute_deltas(delta)
    end
  end

  @spec tails(list(list(integer()))) :: list(integer())
  def tails(deltas) do
    (for delta <- deltas, do: List.last(delta)) |> Enum.reverse()
  end

  @spec heads(list(list(integer()))) :: list(integer())
  def heads(deltas) do
    (for deltas <- deltas, do: List.first(deltas)) |> Enum.reverse()
  end

  @spec compute_prev_step(list(integer())) :: integer()
  def compute_prev_step(heads) do
    compute_prev_step(heads, 0)
  end

  defp compute_prev_step([], prev_result) do
    prev_result
  end
  defp compute_prev_step([current | rest], prev_result) do
    diff = current - prev_result
    compute_prev_step(rest, diff)
  end

  @spec compute_next_step(list(integer())) :: integer()
  def compute_next_step(tails) do
    Enum.sum(tails)
  end


end
