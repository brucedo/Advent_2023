defmodule Day8 do

  def run do
    lines = Common.open(File.cwd, "day8.txt") |> Common.read_file_pipe() |> Common.close()

    path = List.first(lines) |> String.graphemes()
    map = List.delete_at(lines, 0) |> List.delete_at(0) |> make_map()

    {state, steps} = solve_maze(map, path)

    case state do
      :ok -> IO.puts("Map solved in #{Integer.to_string(steps)} steps.")
      _ -> IO.puts("Could not solve map: #{inspect(steps)}")
    end

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
    updated_nodes = for node <- last_nodes, do: (Map.get(map, node) |> elem(1))

    case done?(updated_nodes) do
      true -> {:ok, 1}
      false ->
        case solve_path(map, rest, updated_nodes) do
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
    updated_nodes = for node <- last_nodes, do: (Map.get(map, node) |> elem(0))
    case done?(updated_nodes) do
      true -> {:ok, 1}
      false ->
        case solve_path(map, rest, updated_nodes) do
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

  @spec done?(list(atom())) :: boolean()
  def done?(nodes) do
    List.foldl(nodes, true, fn elem, acc -> (Atom.to_string(elem) |> String.ends_with?("Z")) && acc end)
  end

  @spec solve_maze(%{atom() => {atom(), atom()}}, list(String.t())) :: {atom(), atom()} | {atom(), integer()}
  def solve_maze(map, path) do
    solve_maze_with_state(map, path, :AAA, MapSet.new(), 0)
  end

  @spec solve_maze_with_state(%{atom() => {atom(), atom()}}, list(String.t()), atom(), MapSet.t(atom()), integer()) :: {atom(), atom()} | {atom(), integer()}
  defp solve_maze_with_state(map, path, next_node, visited, tries) do
    case MapSet.member?(visited, next_node) do
      true -> {:error, :unsolvable}
      false ->
        case solve_path(map, path, next_node) do
          {:error, last_node} ->
            case solve_maze_with_state(map, path, last_node, MapSet.put(visited, next_node), tries + 1) do
              {:ok, step_count} -> {:ok, step_count + length(path)}
              err -> err
            end
          ok -> ok
      end
    end
  end

end
