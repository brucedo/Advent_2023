defmodule Day6 do
require Logger

  def run() do
    lines = Common.open(File.cwd(), "day6.txt") |> Common.read_file_pipe() |> Common.close()

    time = List.first(lines) |> convert_line_to_numbers()
    dist = List.last(lines) |> convert_line_to_numbers()

    succeeding = calculate_races(time, dist)

    lengths = Enum.map(succeeding, fn sublist -> length(sublist) end)

    IO.puts("The success product is #{Enum.product(lengths)}")

    # part 2
    time = List.first(lines) |> dekern_lines()
    dist = List.last(lines) |> dekern_lines()

    smallest_time = Day6.binary_search(0, time, time, dist, false)
    largest_time = Day6.binary_search(0, time, time, dist, true)

    Logger.debug("Total time #{Integer.to_string(time)}")
    Logger.debug("Total distance #{Integer.to_string(dist)}")
    Logger.debug("Low end: #{smallest_time}")
    Logger.debug("High end: #{largest_time}")

    total_range = largest_time - smallest_time + 1

    IO.puts("The total range should be #{total_range}")

  end

  def calculate_races([], []) do
    []
  end
  def calculate_races([next_time | rest_time ], [next_dist | rest_dist]) do
    {down_range, up_range} = make_test_ranges(next_time)

    succeeding = distance_calculator(down_range, &part1_distance/2, next_dist) ++ distance_calculator(up_range, &part1_distance/2, next_dist)

    List.insert_at(calculate_races(rest_time, rest_dist), 0, succeeding)

  end

  def convert_line_to_numbers(line) do
    String.split(line, ":") |> List.last() |> String.split() |> Enum.map(&String.to_integer/1)
  end

  def dekern_lines(line) do
    String.split(line, ":") |> List.last() |> String.split() |> List.foldl("", fn elem, acc -> acc <> elem  end) |> String.to_integer()
  end

  @spec binary_search(integer(), integer(), integer(), integer(), boolean()) :: integer()
  def binary_search(low_end, high_end, max_time, threshold, _)
  when (high_end - low_end) <3 do
    success_map = Enum.map(low_end..high_end, fn time -> {time, beats_distance?(max_time, time, threshold)} end)
    Enum.filter(success_map, fn {_, beats} -> beats end) |> Enum.min_by(fn {time, _} -> time end) |> elem(0)
  end

  def binary_search(low_end, high_end, max_time, threshold, invert_search) do
    midpoint = (high_end - low_end) |> div(2)
    Logger.debug("High: #{Integer.to_string(high_end)}, low_end: #{Integer.to_string(low_end)}, Midpoint: #{Integer.to_string(midpoint)}")
    beats = beats_distance?(max_time, low_end + midpoint, threshold)
    Logger.debug("Beats distance? #{beats}")
    beats = if invert_search do !beats else beats end
    case beats do
      true -> binary_search(low_end, low_end + midpoint, max_time, threshold, invert_search)
      false -> binary_search(low_end + midpoint, high_end, max_time, threshold, invert_search)
    end
  end

  @spec beats_distance?(integer(), integer(), integer()) :: boolean()
  def beats_distance?(total_time, push_time, threshold) do
    (total_time - push_time) * push_time > threshold
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
