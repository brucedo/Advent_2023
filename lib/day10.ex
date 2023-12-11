defmodule Day10 do
require Logger

  @type pointmap() :: %{Point.p() => {Point.p(), Point.p()}}

  def run() do
    lines = Common.open(File.cwd, "day10.txt") |> Common.read_file_pipe() |> Common.close()

    start_point = find_start(lines)

    map = load_map(lines)

    case trace_route(map, start_point) do
      {:ok, steps} -> IO.puts("A complete circuit is #{Integer.to_string(steps)}, so the furthest point should be #{Integer.to_string(div(steps, 2))}")
    end

    # Part 2
    walk = find_walk(map, start_point)
    map_with_start = infer_start(map, start_point)

  end

  @spec is_inside?(list({Point.p(), Point.p()}), Point.p()) :: boolean()
  def is_inside?(polygon, point) do
    raster_line = point.y
  end

  def count_crossings(_, _, []) do
    0
  end
  def count_crossings(raster_line, x_intercept, [line | polylines]) do

  end

  def find_polygon(map, walk) do
    polylines = start_segment(map, walk)
    fix_the_last_segment(polylines)
  end

  def fix_the_last_segment(points) do
    polygon_start = List.first(points)
    polygon_end = List.last(points)
    last_element = length(points) - 1

    new_poly_end = Tuple.insert_at(polygon_end, 1, elem(polygon_start, 0))

    List.replace_at(points, last_element, new_poly_end)
  end

  @spec start_segment(pointmap(), list(Point.p())) :: list({Point.p(), Point.p()})
  def start_segment(map, [first | walk]) do
    line = {first}
    follow_line(map, line, walk)
  end

  @spec follow_line(pointmap(), {Point.p()}, list(Point.p())) :: list({Point.p(), Point.p()})
  def follow_line(_, prev_vertex, []) do
    [prev_vertex]
  end
  def follow_line(map, prev_vertex, [first | walk]) do
    case is_corner?(map, first) do
      true -> [Tuple.insert_at(prev_vertex, 1, first)] ++ start_segment(map, [first | walk])
      false -> follow_line(map, prev_vertex, walk)
    end
  end

  @spec rotate_to_corner(pointmap(), list(Point.p())) :: list(Point.p())
  def rotate_to_corner(map, [start | walk]) do
    case is_corner?(map, start) do
      true -> [start | walk]
      false -> rotate_to_corner(map, walk ++ [start])
    end
  end

  @spec is_corner?(pointmap(), Point.p()) :: boolean()
  def is_corner?(map, point) do
    {intake, outflow} = Map.get(map, point)
    intake.y != outflow.y && intake.x != outflow.x
  end

  def infer_start(map, walk) do
    start = List.first(walk)
    first_after_start = List.delete_at(walk, 0) |> List.first()
    second_after_walk = List.last(walk)

    Map.put(map, start, {first_after_start, second_after_walk})
  end

  @spec find_walk(pointmap(), Point.p()) :: list(Point.p())
  def find_walk(map, start) do
    walk = walk_and_record(map, start, start, %Point{x: start.x + 1, y: start.y}) |> elem(1)
    [start] ++ walk
  end

  @spec walk_and_record(pointmap(), Point.p(), Point.p(), Point.p()) :: {:ok, list(Point)} | {:error, String.t()}
  defp walk_and_record(map, start, _, next)
  when start == next
  do
    # if is_horizontal?(Map.get(map, next)) do {:ok, []} else {:ok, [next]} end
    {:ok, []}
  end
  defp walk_and_record(map, start, current, next) do
    connections = Map.get(map, next)
    Logger.debug("Trying to walk from #{inspect current} to #{inspect next}, next has connections #{inspect connections}")
    case next_exit(current, connections) do
      {:error, msg} -> {:error, msg}
      {:ok, exit_point} ->
        case walk_and_record(map, start, next, exit_point) do
          {:ok, path} -> {:ok, [next] ++ path}
          otherwise -> otherwise
        end
    end
  end

  @spec is_horizontal?({Point.p(), Point.p()}) :: boolean()
  def is_horizontal?({left, right}) do
    left.y == right.y
  end

  @spec sort_ascending(list(Point.p())) :: list(Point.p())
  def sort_ascending(raster_line) do
    Enum.sort(raster_line, fn left, right -> left.x <= right.x end)
  end

  @spec rasterize(list(Point.p()))  :: %{Point.p() => list(Point.p())}
  def rasterize(unrasterized) do
    categorized = categorize_points(unrasterized)
    keys = Map.keys(categorized)
    Enum.reduce(keys, categorized, fn key, categorized -> Map.get_and_update(categorized, key, fn raster_line -> {raster_line, sort_ascending(raster_line)} end) |> elem(1) end)
  end

  defp categorize_points([]) do
    %{}
  end
  defp categorize_points([next | rasterized]) do
    Map.get_and_update(categorize_points(rasterized), next.y, fn list -> {list, if list == nil do [next] else [next] ++ list end} end) |> elem(1)
  end

  @spec trace_route(pointmap(), Point.p()) :: {:ok, integer()} | {:error, String.t()}
  def trace_route(map, start) do

    path_starts = [%Point{x: start.x + 1, y: start.y}, %Point{x: start.x, y: start.y + 1}, %Point{x: start.x - 1, y: start.y}, %Point{x: start.x, y: start.y - 1}]

    paths = Enum.map(path_starts, fn start_point -> walk_path(map, start, start, start_point) end)
    path_tuple = paths
      |> Enum.filter( fn {success, _} -> success == :ok end)
      |> List.first(nil)


    case path_tuple do
      nil -> {:error, "No path could be found from starting point (#{start.x}, #{start.y})"}
      win -> win
    end
  end

  @spec find_start(list(String.t())) :: Point.p()
  def find_start(lines) do
    find_start(lines, 0)
  end

  defp find_start([], _) do
    raise("There was no start point in this map.")
  end
  defp find_start([curr_line | lines], row) do
    case String.contains?(curr_line, "S") do
      true -> %Point{x: String.graphemes(curr_line) |> Enum.find_index(fn elem -> elem == "S" end), y: row }
      false -> find_start(lines, row + 1)
    end
  end

  @spec walk_path(pointmap(), Point.p(),  Point.p(), Point.p()) :: {:ok, integer()} | {:error, String.t()}
  defp walk_path(_, start, _, next_point)
  when start == next_point
  do
    {:ok, 1}
  end
  defp walk_path(map, start, current_point, next_point) do
    # advance
    connections = Map.get(map, next_point)
    case next_exit(current_point, connections) do
      {:error, msg} -> {:error, msg}
      {:ok, exit_point} ->
        case walk_path(map, start, next_point, exit_point) do
          {:ok, path_length} -> {:ok, path_length + 1}
          otherwise -> otherwise
        end
    end

  end

  @spec next_exit(Point.p(), {Point.p(), Point.p()}) :: {:ok, Point.p()} | {:error, String.t()}
  defp next_exit(point, destination)
  when elem(destination, 0) == point
  do
    {:ok, elem(destination, 1)}
  end
  defp next_exit(point, destination)
  when elem(destination, 1) == point
  do
    {:ok, elem(destination, 0)}
  end
  defp next_exit(point, pipe) do
    {:error, "The point #{inspect point} does not actually connect to either end of the pipe #{inspect pipe}."}
  end

  @spec load_map(list(String.t())) :: %{Point.p => {Point.p(), Point.p()}}
  def load_map(lines) do
    load_map(lines, 0)
  end

  defp load_map([], _) do
    %{}
  end
  defp load_map([line | rest], row) do
    Map.merge(load_line(line, row), load_map(rest, row + 1))
  end

  @spec load_line(String.t(), integer()) :: %{Point.p() => {Point.p(), Point.p()}}
  def load_line(line, row) do

    String.graphemes(line)
      |> Enum.zip(0..(String.length(line) - 1))
      |> Enum.filter(fn {symbol, _} -> Regex.match?(~r/[|\-LJ77F]/, symbol) end)
      |> Enum.map(fn {symbol, index} -> {symbol, %Point{x: index, y: row}} end)
      |> List.foldl(%{}, fn {symbol, point}, acc -> Map.put(acc, point, tile_to_points(point, symbol)) end)
  end

  @spec tile_to_points(Point.p(), String.t()) :: {Point.p(), Point.p()}
  def tile_to_points(coordinate, "|") do
    {%Point{x: coordinate.x, y: coordinate.y - 1}, %Point{x: coordinate.x, y: coordinate.y + 1}}
  end
  def tile_to_points(coordinate, "-") do
    {%Point{x: coordinate.x - 1, y: coordinate.y}, %Point{x: coordinate.x + 1, y: coordinate.y}}
  end
  def tile_to_points(coordinate, "L") do
    {%Point{x: coordinate.x, y: coordinate.y - 1}, %Point{x: coordinate.x + 1, y: coordinate.y}}
  end
  def tile_to_points(coordinate, "J") do
    {%Point{x: coordinate.x, y: coordinate.y - 1}, %Point{x: coordinate.x - 1, y: coordinate.y}}
  end
  def tile_to_points(coordinate, "7") do
    {%Point{x: coordinate.x - 1, y: coordinate.y}, %Point{x: coordinate.x, y: coordinate.y + 1}}
  end
  def tile_to_points(coordinate, "F") do
    {%Point{x: coordinate.x + 1, y: coordinate.y}, %Point{x: coordinate.x, y: coordinate.y + 1}}
  end



end
