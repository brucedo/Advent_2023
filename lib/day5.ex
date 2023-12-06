defmodule PlantMap do
  defstruct name: :nil, ranges: []
end

defmodule Day5 do
require Logger

  def run() do
    [seed | rest] = Common.open(File.cwd, "day5.txt") |> Common.read_file_pipe() |> Common.close()

    map_resolution_order = [
      :seed_to_soil, :soil_to_fertilizer, :fertilizer_to_water, :water_to_light,
      :light_to_temperature, :temperature_to_humidity, :humidity_to_location]

    seed_numbers = String.split(seed) |> List.delete_at(0) |> Enum.map(&String.to_integer/1)

    assorted_crap = break_almanac(rest)

    plant_maps = Enum.map(assorted_crap, fn {name, range_strings} -> make_plant_map(name, range_strings) end)
      |> Enum.reduce(%{}, fn plant_map, acc -> Map.put(acc, plant_map.name, plant_map) end)

    ordered_maps = Enum.map(map_resolution_order, fn map_name -> Map.get(plant_maps, map_name) end)

    pairs = Enum.map(seed_numbers, fn seed_number ->
      {seed_number, Enum.reduce(ordered_maps, seed_number, fn map, seed_number -> search_ranges(map.ranges, seed_number) end)} end)

    smallest = Enum.min_by(pairs, fn {_, location} -> location end)

    IO.puts("of all of the seeds #{inspect pairs}, the one with the smallest location should be #{inspect smallest}")

    # part 2.

    seed_pairs = Enum.chunk_every(seed_numbers, 2) |> Enum.map(fn pair -> List.to_tuple(pair) end)

    what_have_i_done = Enum.map(seed_pairs, fn {start, range} -> calculate_seed_range(start, range, ordered_maps) end)

    smallest = Enum.min_by(what_have_i_done, fn {_, location} -> location end)

    IO.puts("Part 2 is telling me that the smallest is #{inspect smallest}")

  end

  def calculate_seed_range(start, range, ordered_maps) do
    Logger.debug("starting at seed #{start}, with range #{range}")
    starter = actual_calc(start, ordered_maps)
    Enum.reduce((start + 1)..(start + range - 1), {start, starter}, fn elem, acc -> seed_min(acc, {elem, actual_calc(elem, ordered_maps)})  end)
  end

  def seed_min(left_tuple, right_tuple) do
    if elem(left_tuple, 1) <= elem(right_tuple, 1) do left_tuple else right_tuple end
  end

  def actual_calc(seed, ordered_maps) do
    Enum.reduce(ordered_maps, seed, fn map, seed_number -> search_ranges(map.ranges, seed_number) end)
  end


  def make_plant_map(name, range_strings) do
    list_of_ranges = for string <- range_strings, do: String.split(string) |> Enum.map(&String.to_integer/1) |> List.to_tuple
    %PlantMap{name: name, ranges: list_of_ranges}
  end

  @spec search_ranges(list({integer(), integer(), integer()}), integer()) :: integer()
  def search_ranges([], key) do
    key
  end

  def search_ranges([current_range | remaining], key) do
    {dest, src, rng} = current_range
    cond do
      src <= key and key < (src + rng) -> dest + key - src
      true -> search_ranges(remaining, key)
    end
  end


  @spec consume_range(String.t()) :: map()
  def consume_range(range_line) do
    {destination, start, range} = String.split(range_line) |> Enum.map(fn elem -> String.to_integer(elem) end) |> List.to_tuple()

    Enum.reduce(0..(range - 1), %{}, fn val, acc -> Map.put(acc, start + val, destination + val) end)
  end

  @spec consume_ranges(list(String.t())) :: map()
  def consume_ranges(ranges) do
    (for range <- ranges, do: consume_range(range)) |> List.foldl(%{}, fn elem, acc -> Map.merge(acc, elem) end)
  end

  @spec break_almanac(list(String.t())) :: map()
  def break_almanac(lines) do
    Enum.chunk_by(lines, fn line -> String.trim(line) == "" end)
      |> Enum.filter(fn records -> records != [""] end)
      |> Enum.map( &tuplify_raw_maps/1)
      |> Enum.map(fn record -> put_elem(record, 0, map_name_to_atom(elem(record, 0))) end)
      |> Enum.reduce(%{}, fn pair, acc -> Map.put(acc, elem(pair, 0), elem(pair, 1)) end)

  end

  def tuplify_raw_maps([map_name | ranges]) do
    {map_name, ranges}
  end

  @spec map_name_to_atom(String.t()) :: atom()
  def map_name_to_atom(map_name) do
    String.split(map_name) |> List.first() |> String.replace("-", "_") |> String.to_atom()
  end

  @spec convert_to_range_maps(map()) :: map()
  def convert_to_range_maps(unfinished) do
    Enum.map(unfinished, fn {name, string_list} -> {name, consume_ranges(string_list)} end)
      |> Enum.reduce(%{}, fn {name, map}, acc -> Map.put(acc, name, map) end)
  end

end
