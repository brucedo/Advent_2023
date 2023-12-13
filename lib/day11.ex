defmodule Day11 do
require Logger

  def run() do
    lines = Common.open(File.cwd, "day11.txt") |> Common.read_file_pipe() |> Common.close()

    universe = Enum.map(lines, fn line -> String.graphemes(line) end) |> expand_universe()

    pairs = Day11.find_pairs(universe)
    Logger.debug("Count of pairs: #{length(pairs)}")
    calculated_distances = Enum.map(pairs, &Day11.calculate_taxi_distance/1)
    total_dist = Enum.sum(calculated_distances)

    IO.puts("Total length is possibly #{Integer.to_string(total_dist)}")

    universe = Enum.map(lines, fn line -> String.graphemes(line) end)

    empty_rows = Day11.find_empty_rows(universe)
    empty_columns = Enum.zip_with(universe, &Function.identity/1) |> Day11.find_empty_rows()
    pairs = Day11.find_pairs(universe)

    calculated_distances = Enum.map(pairs, fn pair -> Day11.big_distance(pair, empty_rows, empty_columns, 1000000) end)

    total_dist = Enum.sum(calculated_distances)
    IO.puts("The calculated distance for part 2 is #{Integer.to_string total_dist}")
  end

  @spec big_distance({Point.p(), Point.p()}, list(integer()), list(integer()), integer()) :: integer()
  def big_distance({left, right}, empty_rows, empty_columns, expansion_coeffient) do
    {small_x, large_x} = if left.x < right.x do {left.x, right.x} else {right.x, left.x} end
    {small_y, large_y} = if left.y < right.y do {left.y, right.y} else {right.y, left.y} end

    Logger.debug("small_x and small_y: #{Integer.to_string small_x}, #{Integer.to_string small_y}")
    Logger.debug("large_x and large_y: #{Integer.to_string large_x}, #{Integer.to_string large_y}")

    empty_col_count = Enum.filter(empty_columns, fn col -> small_x < col && col < large_x end) |> Enum.count()
    empty_row_count = Enum.filter(empty_rows, fn row -> small_y < row && row < large_y end) |> Enum.count()

    Logger.debug("Empty column count: #{Integer.to_string empty_col_count}")
    Logger.debug("Empty row count: #{Integer.to_string empty_row_count}")

    x_distance = (large_x - small_x - empty_col_count) + (empty_col_count * expansion_coeffient)
    y_distance = (large_y - small_y - empty_row_count) + (empty_row_count * expansion_coeffient)

    Logger.debug("x_distance and y_distance: #{Integer.to_string x_distance}, #{Integer.to_string y_distance}")

    x_distance + y_distance

  end

  @spec calculate_taxi_distance({Point.p(), Point.p()}) :: integer()
  def calculate_taxi_distance({left, right}) do
    # Logger.debug("left #{inspect left} - right #{inspect right} = #{abs(left.x - right.x) + abs(left.y - right.y)}")
    abs(left.x - right.x) + abs(left.y - right.y)
  end

  @spec find_pairs(list(list(String.t()))) :: list({Point.p(), Point.p()})
  def find_pairs(list_of_lists) do
    # Logger.debug("Starting with grid #{inspect(list_of_lists)}")
    find_pairs_int(list_of_lists, 0, 0)
  end

  @spec find_pairs_int(list(list(String.t())), integer(), integer()) :: list({Point.p(), Point.p()})
  defp find_pairs_int([], _, _) do
    []
  end
  defp find_pairs_int([[] | rest], _, row) do
    find_pairs_int(rest, 0, row + 1)
  end
  defp find_pairs_int([[cell_value | line_end] | rest], col, row) do
    # Logger.debug("Testing cell_value #{cell_value} at x: #{Integer.to_string(col)}, y: #{Integer.to_string(row)}")
    case cell_value do
      "." -> find_pairs_int([line_end | rest], col + 1, row)
      "#" -> (for left <- [%Point{x: col, y: row}], right <- find_other_halves([line_end | rest], col + 1, row), do: {left, right}) ++
                find_pairs_int([line_end | rest], col + 1, row)
    end
  end

  @spec find_other_halves(list(list(String.t())), integer(), integer()) :: list(Point.p())
  def find_other_halves([], _, _) do
    []
  end
  def find_other_halves([[] | rest], _, row) do
    find_other_halves(rest, 0, row + 1)
  end
  def find_other_halves([[cell_value | line_end] | rest], column, row) do
    # Logger.debug("Searching for other # symbols starting with #{cell_value}, x: #{Integer.to_string(column)}, y: #{Integer.to_string(row)}")
    case cell_value do
      "#" -> [%Point{x: column, y: row}] ++ find_other_halves([line_end | rest], column + 1, row)
      "." -> find_other_halves([line_end | rest], column + 1, row)
    end
  end

  # @spec scan_line_from(list(String.t()), integer()) :: {:some, index} | {:none}
  # defp scan_line_from(line, start_at) do

  # end

  @spec expand_universe(list(list(String.t()))) :: list(list(String.t()))
  def expand_universe(galaxy) do
    expand_line(galaxy)
      |> Enum.zip_with(&Function.identity/1)
      |> expand_line()
      |> Enum.zip_with(&Function.identity/1)
    # transpose = Enum.zip_with(first_expansion, &Function.identity/1)
    # second_expansion = expand_line(transpose)
    # Enum.zip_w
  end

  @spec has_galaxies?(list(String.t())) :: boolean()
  def has_galaxies?(space_line) do
    Enum.any?(space_line, fn element -> element == "#" end)
  end

  @spec find_empty_rows(list(list(String.t()))) :: list(number())
  def find_empty_rows(space_lines) do
    find_empty_rows(space_lines, 0)
  end

  defp find_empty_rows([], _) do
    []
  end
  defp find_empty_rows([current_line | space_lines], counter) do
    case has_galaxies?(current_line) do
      true -> find_empty_rows(space_lines, counter + 1)
      false -> [counter] ++ find_empty_rows(space_lines, counter + 1)
    end
  end

  @spec expand_line(list(list(String.t()))) :: list(list(String.t()))
  def expand_line([]) do
    []
  end
  def expand_line([line | remaining_field]) do
    case has_galaxies?(line) do
      true -> [line] ++ expand_line(remaining_field)
      false -> [line] ++ [line] ++ expand_line(remaining_field)
    end
  end
end
