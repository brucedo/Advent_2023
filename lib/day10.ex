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


  end

  @spec find_walk(pointmap(), Point.p()) :: list(Point.p())
  def find_walk(map, start) do

  end

  @spec sort_ascending(list(Point.p())) :: list(Point.p())
  def sort_ascending(raster_line) do

  end

  @spec rasterize(list(Point.p()))  :: %{Point.p() => list(Point.p())}
  def rasterize(unrasterized) do

  end

  @spec trace_route(pointmap(), Point.p()) :: {:ok, integer()} | {:error, String.t()}
  def trace_route(map, start) do
    IO.puts("Map: #{inspect map}")

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
    IO.puts("Have found our way to the end of this path.")
    {:ok, 1}
  end
  defp walk_path(map, start, current_point, next_point) do
    # advance
    connections = Map.get(map, next_point)
    IO.puts("Checking point path #{inspect current_point} to  #{inspect next_point} and it is connected to #{inspect connections}")
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
