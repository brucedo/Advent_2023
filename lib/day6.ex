defmodule Day6 do

  def run() do
    lines = Common.open(File.cwd(), "day6.txt") |> Common.read_file_pipe() |> Common.close()

    time = List.first(lines) |> convert_line_to_numbers()
    dist = List.last(lines) |> convert_line_to_numbers()

    succeeding = calculate_races(time, dist)
    Enum.chunk_whi
    Enum.chunk_while(succeeding, [], fn {time, other}, chunk, acc ->  end)

  end

  def chunker()

  def calculate_races([], []) do
    []
  end
  def calculate_races([next_time | rest_time ], [next_dist | rest_dist]) do
    {down_range, up_range} = make_test_ranges(next_time)

    succeeding = distance_calculator(down_range, &part1_distance/2, next_dist) ++ distance_calculator(up_range, &part1_distance/2, next_dist)

    succeeding ++ calculate_races(rest_time, rest_dist)

  end

  def convert_line_to_numbers(line) do
    String.split(line, ":") |> List.last() |> String.split() |> Enum.map(&String.to_integer/1)
  end

  @spec part1_distance(integer(), integer()) :: integer()
  def part1_distance(p1, p2) do
    (p1 - p2) * p2
  end

  @spec distance_calculator(list({integer(), integer()}), fun(), integer()) :: list({integer(), integer()})
  def distance_calculator([{p1, p2} | rest], two_param, threshold) do
    cond do
      two_param.(p1, p2) > threshold -> [{p1, p2}] ++ distance_calculator(rest, two_param, threshold)
      true -> []
    end
  end

  @spec make_test_ranges(integer()) :: {list({integer(), integer()}), list({integer(), integer()})}
  def make_test_ranges(c) do
    midpoint = div(c, 2)

    {Enum.map(midpoint..0, fn ind -> {c, ind} end), Enum.map((midpoint+1)..c, fn ind -> {c, ind} end)}
  end

end
