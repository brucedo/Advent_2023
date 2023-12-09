defmodule Day8 do
require Logger

  def run do
    lines = Common.open(File.cwd, "day8.txt") |> Common.read_file_pipe() |> Common.close()

    path = List.first(lines) |> String.graphemes()
    map = List.delete_at(lines, 0) |> List.delete_at(0) |> make_map()

    steps = solve_maze(map, path)

    IO.puts("The list of solution times is #{inspect steps}")

    growth_vector = for _ <- steps, do: 0
    grow_by = List.to_tuple(steps)
    growth_vector = List.replace_at(growth_vector, 0, elem(grow_by, 0))


    lcm = shitty_lcm(growth_vector, grow_by)

    IO.puts("LCM is #{inspect lcm} ???? ")

    # case state do
    #   :ok -> IO.puts("Map solved in #{Integer.to_string(steps)} steps.")
    #   _ -> IO.puts("Could not solve map: #{inspect(steps)}")
    # end

  end

  @spec find_gcd(%{integer() => integer()}, integer()) :: integer()
  def find_gcd(gcd_map, count) do
    Map.to_list(gcd_map)
      |> Enum.filter(fn {_, value} -> value == count end)
      |> Enum.reduce({0, 0}, fn {key, value}, {prev_key, prev_value} -> if {key > prev_key} do {key, value} else {prev_key, prev_value} end end)
      |> elem(0)
  end

  @spec find_divisors(integer()) :: list(integer())
  def find_divisors(number) do
    Enum.filter(1..number, fn divisor -> Integer.mod(number, divisor) == 0 end)
  end

  @spec group_divisors(%{integer() => integer()}, list(integer())) :: %{integer() => integer()}
  def group_divisors(divisor_map, divisors) do
    List.foldl(divisors, divisor_map, fn divisor, map -> Map.get_and_update(map, divisor, fn count -> {count, if count == nil do 1 else count + 1 end} end) end)
  end

  @spec shitty_lcm(list(integer()), {}) :: integer()
  def shitty_lcm(current_vector, add_by) do
    case is_lcm?(current_vector) do
      true -> List.first(current_vector)
      false -> grow_smallest(current_vector, add_by) |> shitty_lcm(add_by)
    end
  end

  @spec grow_smallest(list(integer()), tuple()) :: list(integer())
  def grow_smallest(current_vector, add_by) do
    index = smallest_index(current_vector)
    value_to_grow = Enum.fetch(current_vector, index) |> elem(1)
    List.replace_at(current_vector, index, value_to_grow + elem(add_by, index))
  end

  @spec smallest_index(list(integer())) :: integer()
  def smallest_index(vector) do
    smallest = Enum.sort(vector) |> List.first()
    Enum.find_index(vector, fn elem -> elem == smallest end)
  end

  @spec is_lcm?(list(integer())) :: boolean()
  def is_lcm?(vector) do
    start = List.first(vector)
    Enum.all?(vector, fn value -> value == start end)
  end

  @spec make_map(list()) :: %{atom() => {atom(), atom()}}
  def make_map([]) do
    %{}
  end

  def make_map([current_line | rest]) do
    map = make_map(rest)

    nodes = Regex.named_captures(~r/(?<key>[A-Z]+) = \((?<left>[A-Z]+), (?<right>[A-Z]+)\)/, current_line)
    Map.put(map, Map.get(nodes, "key") |> String.to_atom, {Map.get(nodes, "left") |> String.to_atom, Map.get(nodes, "right") |> String.to_atom})
  end

  @spec solve_path(%{atom() => {atom(), atom()}}, list(String.t()), list(atom())) :: {atom(), integer()} | {atom(), list(atom())}

  # def solve_path(_, _, :ZZZ) do
  #   {:ok, 0}
  # end
  def solve_path(_map, [], last_node) do
    {:error, last_node}
  end

  def solve_path(map, ["R" | rest], last_nodes) do
    # updated_nodes = for node <- last_nodes, do: (Map.get(map, node) |> elem(1))
    updated_node = Map.get(map, last_nodes) |> elem(1)
    case done?(updated_node) do
      true -> {:ok, 1}
      false ->
        case solve_path(map, rest, updated_node) do
          {:ok, steps} -> {:ok, steps + 1}
          x -> x
        end
    end
    # case solve_path(map, rest, Map.get(map, last_nodes) |> elem(1)) do
    #   {:ok, steps} -> {:ok, steps + 1}
    #   x -> x
    # end
  end

  def solve_path(map, ["L" | rest], last_nodes) do
    # updated_nodes = for node <- last_nodes, do: (Map.get(map, node) |> elem(0))
    updated_node = Map.get(map, last_nodes) |> elem(0)
    case done?(updated_node) do
      true -> {:ok, 1}
      false ->
        case solve_path(map, rest, updated_node) do
          {:ok, steps} -> {:ok, steps + 1}
          x -> x
        end
    end
    # end
    # case solve_path(map, rest, Map.get(map, last_nodes) |> elem(0)) do
    #   {:ok, steps} -> {:ok, steps + 1}
    #     x -> x
    # end
  end

  @spec done?(atom()) :: boolean()
  def done?(nodes) do
    Atom.to_string(nodes) |> String.ends_with?("Z")
    # List.foldl(nodes, true, fn elem, acc -> (Atom.to_string(elem) |> String.ends_with?("Z")) && acc end)
  end

  @spec solve_maze(%{atom() => {atom(), atom()}}, list(String.t())) :: list(integer()) #{atom(), atom()} | {list(integer())}
  def solve_maze(map, path) do
    Logger.debug("The starting map is #{inspect map}")
    start_set = find_start_set(map)
    Logger.debug("The start set is #{inspect start_set}")
    for starter <- start_set, do: (solve_maze_with_state(map, path, starter, MapSet.new()) |> elem(1))
  end

  @spec solve_maze_with_state(%{atom() => {atom(), atom()}}, list(String.t()), [atom()], MapSet.t(atom())) :: {atom(), atom()} | {atom(), integer()}
  defp solve_maze_with_state(map, path, next_node, visited) do
    # case MapSet.member?(visited, next_node) do
    #   true -> {:error, :unsolvable}
    #   false ->
        case solve_path(map, path, next_node) do
          {:error, last_node} ->
            case solve_maze_with_state(map, path, last_node, MapSet.put(visited, next_node)) do
              {:ok, step_count} -> {:ok, step_count + length(path)}
              # err -> err
            end
          ok -> ok
      end
    # end
  end

  @spec find_start_set(%{atom() => {atom(), atom()}}) :: list(atom())
  def find_start_set(map) do
    Logger.debug("#{inspect Map.keys(map)}")
    Logger.debug("#{Map.keys(map) |> Enum.map(fn node -> Atom.to_string(node) end)}")
    Map.keys(map) |> Enum.filter(fn node -> Atom.to_string(node) |> String.ends_with?("A") end)
  end

end
