defmodule Day3 do

  @spec fill_adjacency(map(), Point.p(), String.t())  :: map()
  def fill_adjacency(adjacency_map, point, symbol) do

    Map.get_and_update(adjacency_map, %Point{x: point.x - 1, y: point.y - 1}, fn val -> {val, if val == nil do [symbol] else [symbol] ++ val end} end ) |>
      elem(1) |>
      Map.get_and_update(%Point{x: point.x, y: point.y - 1}, fn val -> {val, if val == nil do [symbol] else [symbol] ++ val end} end ) |>
      elem(1) |>
      Map.get_and_update(%Point{x: point.x + 1, y: point.y - 1}, fn val -> {val, if val == nil do [symbol] else [symbol] ++ val end} end ) |>
      elem(1) |>
      Map.get_and_update(%Point{x: point.x - 1, y: point.y}, fn val -> {val, if val == nil do [symbol] else [symbol] ++ val end} end ) |>
      elem(1) |>
      Map.get_and_update(point, fn val -> {val, if val == nil do [symbol] else [symbol] ++ val end} end ) |>
      elem(1) |>
      Map.get_and_update(%Point{x: point.x + 1, y: point.y}, fn val -> {val, if val == nil do [symbol] else [symbol] ++ val end} end ) |>
      elem(1) |>
      Map.get_and_update(%Point{x: point.x - 1, y: point.y + 1}, fn val -> {val, if val == nil do [symbol] else [symbol] ++ val end} end ) |>
      elem(1) |>
      Map.get_and_update(%Point{x: point.x, y: point.y + 1}, fn val -> {val, if val == nil do [symbol] else [symbol] ++ val end} end ) |>
      elem(1) |>
      Map.get_and_update(%Point{x: point.x + 1, y: point.y + 1}, fn val -> {val, if val == nil do [symbol] else [symbol] ++ val end} end ) |>
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
