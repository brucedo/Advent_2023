defmodule Day3 do
require Logger

  def run() do
    lines = Common.open(File.cwd, "day3.txt") |> Common.read_file_pipe() |> Common.close()

    parts = parse_lines(lines, 0)

    {numbers, symbols} = split_parts(parts)

    adjacency_map = capture_symbols(symbols)

    adjacent_sum = Enum.filter(numbers, &Day3.is_adjacent?(&1, adjacency_map)) |> Enum.map(&elem(&1, 1)) |> Enum.sum()

    IO.puts("The sum of all adjacent numbers is #{adjacent_sum}")

    gears_only = symbols |> Enum.filter(fn element -> elem(element, 1) == "*" end)
    gear_map = capture_symbols(gears_only)

    ratio_map = Enum.filter(numbers, &Day3.is_adjacent?(&1, gear_map))
      |> Enum.map(fn (number) -> {Day3.gear_point(number, gear_map), elem(number, 1)} end)
      |> List.foldl(%{}, fn e, acc ->
          elem(Map.get_and_update(acc, elem(e, 0), fn v -> {v, if v == nil do [elem(e, 1)] else [elem(e, 1)] ++ v end} end), 1) end)

    gear_ratios = Enum.filter(Map.values(ratio_map), fn ratios -> length(ratios) == 2 end)
      |> Enum.map(&Enum.product/1)

    IO.puts("The sum of all gear ratios, if I have not royally fucked up, is #{Enum.sum(gear_ratios)}")


  end

  def gear_point(number, adjacency_map) do
    left_point = elem(number, 2)
    right_point = %Point{x: left_point.x + length(Integer.digits(elem(number, 1))) - 1, y: left_point.y}

    left_adj = Map.get(adjacency_map, left_point)
    right_adj = Map.get(adjacency_map, right_point)

    adjacent = if (left_adj == nil) do
      right_adj
    else
      left_adj
    end

    if (length(adjacent) > 1) do
      raise "There are, in fact, numbers adjacent to more than one gear.  yeesh."
    end

    Enum.map(adjacent, &elem(&1, 0)) |> List.first()

  end

  def is_adjacent?(number, adjacency_map) do
    left_point = elem(number, 2)
    right_point = %Point{x: left_point.x + length(Integer.digits(elem(number, 1))) - 1, y: left_point.y}

    Map.has_key?(adjacency_map, left_point) || Map.has_key?(adjacency_map, right_point)
  end

  def split_parts(parts_list) do
    flattened = List.flatten(parts_list)
    part_numbers = Enum.filter(flattened, fn part -> elem(part, 0) == :Number end)
    symbols = Enum.filter(flattened, fn part -> elem(part, 0) == :Symbol end)

    {part_numbers, symbols}
  end

  def capture_symbols([]) do
    %{}
  end

  def capture_symbols([element | remaining]) do
    fill_adjacency(capture_symbols(remaining), elem(element, 2), elem(element, 1))
  end

  def parse_lines([], _) do
    []
  end

  def parse_lines([line | lines], index) do
    [(parse_line(line) |> Enum.map(&pointify &1, index))] ++ parse_lines(lines, index + 1)
  end

  @spec fill_adjacency(map(), Point.p(), String.t())  :: map()
  def fill_adjacency(adjacency_map, point, symbol) do

    reference = {point, symbol}
    Map.get_and_update(adjacency_map, %Point{x: point.x - 1, y: point.y - 1}, fn val -> {val, if val == nil do [reference] else [reference] ++ val end} end ) |>
      elem(1) |>
      Map.get_and_update(%Point{x: point.x, y: point.y - 1}, fn val -> {val, if val == nil do [reference] else [reference] ++ val end} end ) |>
      elem(1) |>
      Map.get_and_update(%Point{x: point.x + 1, y: point.y - 1}, fn val -> {val, if val == nil do [reference] else [reference] ++ val end} end ) |>
      elem(1) |>
      Map.get_and_update(%Point{x: point.x - 1, y: point.y}, fn val -> {val, if val == nil do [reference] else [reference] ++ val end} end ) |>
      elem(1) |>
      Map.get_and_update(point, fn val -> {val, if val == nil do [reference] else [reference] ++ val end} end ) |>
      elem(1) |>
      Map.get_and_update(%Point{x: point.x + 1, y: point.y}, fn val -> {val, if val == nil do [reference] else [reference] ++ val end} end ) |>
      elem(1) |>
      Map.get_and_update(%Point{x: point.x - 1, y: point.y + 1}, fn val -> {val, if val == nil do [reference] else [reference] ++ val end} end ) |>
      elem(1) |>
      Map.get_and_update(%Point{x: point.x, y: point.y + 1}, fn val -> {val, if val == nil do [reference] else [reference] ++ val end} end ) |>
      elem(1) |>
      Map.get_and_update(%Point{x: point.x + 1, y: point.y + 1}, fn val -> {val, if val == nil do [reference] else [reference] ++ val end} end ) |>
      elem(1)
  end

  @spec parse_line(String.t()) :: [{atom(), String.t(), integer()} | {atom(), integer(), integer()}]
  def parse_line(line) do
    parse_line_counting(line, 0)
  end

  def parse_line_counting("", _) do
    []
  end
  def parse_line_counting(line, index) do
    indicator = String.first(line)

    cond do
      indicator == "." -> parse_line_counting(String.split_at(line, 1) |> elem(1), index + 1)
      String.match?(indicator, ~r/[0-9]/) -> parse_number(line, index)
      true -> parse_symbol(line, index)
    end

  end

  @spec parse_number(String.t(), integer()) :: [{atom(), String.t(), integer()} | {atom(), integer(), integer()}]
  defp parse_number(line, index) do
    num_string = Regex.named_captures(~r/(?<num>[0-9]+)/, line, capture: :first) |> Map.get("num")
    digits = String.length(num_string)
    remaining = String.split_at(line, digits) |> elem(1)
    [{:Number, Integer.parse(num_string) |> elem(0), index}] ++ parse_line_counting(remaining, index + digits)
  end

  @spec parse_symbol(String.t(), integer()) :: [{atom(), String.t(), integer()} | {atom(), integer(), integer()}]
  defp parse_symbol(line, index) do
    {symbol, remaining} = String.split_at(line, 1)

    [{:Symbol, symbol, index}] ++ parse_line_counting(remaining, index + 1)
  end

  @spec pointify({atom(), any(), integer()}, integer()) :: {atom(), any, Point.p()}
  def pointify(parsed_element, line_index) do
    put_elem(parsed_element, 2, %Point{x: elem(parsed_element, 2), y: line_index})
  end
end
