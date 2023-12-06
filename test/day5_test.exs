defmodule Day5Test do
  require Logger
  use ExUnit.Case
  doctest Day5

  test "Given some range line, consume_range will return a map correlating source + i and destination + i numbers from i = 0 -> count - 1" do
    line = "57 7 4"

    range_map = Day5.consume_range(line)

    assert Map.get(range_map, 7) == 57
    assert Map.get(range_map, 10) == 60
  end

  test "Given some list of range lines, consume_ranges will return a single map combining all correlations for all range lines" do
    input_set = ["49 53 8", "0 11 42", "42 0 7", "57 7 4"]

    single_map = Day5.consume_ranges(input_set)

    assert Map.get(single_map, 53) == 49
    assert Map.get(single_map, 11) == 0
    assert Map.get(single_map, 0) == 42
    assert Map.get(single_map, 10) == 60
  end

  test "Given a collection of input lines, break_alamanac will produce a map categorizing each group of lines into a map keyed by an atom" do
    input_set = ["seed-to-soil map:","50 98 2","52 50 48","","soil-to-fertilizer map:","0 15 37","37 52 2","39 0 15","",
                "fertilizer-to-water map:","49 53 8","0 11 42",
                "42 0 7","57 7 4","","water-to-light map:","88 18 7","18 25 70","","light-to-temperature map:","45 77 23","81 45 19",
                "68 64 13","","temperature-to-humidity map:","0 69 1","1 0 69","","humidity-to-location map:","60 56 37","56 93 4"]

    broken_set = Day5.break_almanac(input_set)

    assert Map.get(broken_set, :seed_to_soil) == ["50 98 2","52 50 48"]
    assert Map.get(broken_set, :soil_to_fertilizer) == ["0 15 37","37 52 2","39 0 15"]
    assert Map.get(broken_set, :fertilizer_to_water) == ["49 53 8","0 11 42","42 0 7","57 7 4"]
    assert Map.get(broken_set, :water_to_light) == ["88 18 7","18 25 70"]
    assert Map.get(broken_set, :light_to_temperature) == ["45 77 23","81 45 19","68 64 13"]
    assert Map.get(broken_set, :temperature_to_humidity) == ["0 69 1","1 0 69"]
    assert Map.get(broken_set, :humidity_to_location) == ["60 56 37","56 93 4"]
  end

  test "Given an atom name and a list of string numbers, make_plant_map will produce a PlantMap where the atom name becomes PlantMap.name and the String numbers become the ranges" do


    assert Day5.make_plant_map(:fertilizer_to_water, ["49 53 8","0 11 42","42 0 7","57 7 4"]) ==
      %PlantMap{name: :fertilizer_to_water, ranges: [{49, 53, 8}, {0, 11, 42}, {42, 0, 7}, {57, 7, 4}]}
  end

  test "Given a key that sits between [src, src + rng) then search_ranges will return the mapped destination value" do
    assert Day5.search_ranges([{49, 53, 8}], 56) == 52
  end

  test "Given a key that sits between [src, src + rng) for some arbitrary tuple then search_ranges will return the mapped desination using that tuple's destination" do
    assert Day5.search_ranges([{49, 53, 8}, {0, 11, 42}, {42, 0, 7}, {57, 7, 4}], 6) == 48
  end

  test "Given a key that does not sit between any [src, src + rng) for any of the tuples in the list then search_ranges will return the key" do
    assert Day5.search_ranges([{49, 53, 8}, {0, 11, 42}, {42, 0, 7}, {57, 7, 4}], 200) == 200
  end

  test "Given a list containing the map name header and the ranges tuplify_raw_maps will return a tuple with the map name in element 0 and the list in element 1" do
    map_set = ["seed-to-soil map:","50 98 2","52 50 48","","soil-to-fertilizer map:","0 15 37","37 52 2","39 0 15"]

    assert Day5.tuplify_raw_maps(map_set) == {"seed-to-soil map:", ["50 98 2","52 50 48","","soil-to-fertilizer map:","0 15 37","37 52 2","39 0 15"]}
  end

  test "Given some full section name, map_name_to_atom will return an atom version of the string with ' map:' removed and - replaced with _" do
    map_header = "seed-to-soil map:"

    assert Day5.map_name_to_atom(map_header) == :seed_to_soil
  end

  test "Given a map of map names to lists of ranges, convert_to_range_maps will return a map of map name atoms to range maps" do
    map_names = %{seed_to_soil: ["50 98 2","52 50 48"]}

    ranges = Map.merge(Day5.consume_range("50 98 2"), Day5.consume_range("52 50 48"))

    assert Day5.convert_to_range_maps(map_names) == %{seed_to_soil: ranges}
  end

  test "Start putting it all together..." do
    input_set = ["seed-to-soil map:","50 98 2","52 50 48","","soil-to-fertilizer map:","0 15 37","37 52 2","39 0 15","",
                "fertilizer-to-water map:","49 53 8","0 11 42",
                "42 0 7","57 7 4","","water-to-light map:","88 18 7","18 25 70","","light-to-temperature map:","45 77 23","81 45 19",
                "68 64 13","","temperature-to-humidity map:","0 69 1","1 0 69","","humidity-to-location map:","60 56 37","56 93 4"]

    range_maps = Day5.break_almanac(input_set) |> Day5.convert_to_range_maps()

    seeds = [79, 14, 55, 13]

    order = [:seed_to_soil, :soil_to_fertilizer, :fertilizer_to_water, :water_to_light, :light_to_temperature, :temperature_to_humidity, :humidity_to_location]

    maps = for map_name <- order, do: Map.get(range_maps, map_name)

    final = Enum.map(seeds, fn seed -> {seed, Enum.reduce(maps, seed, fn map, amt -> Map.get(map, amt, amt) end)} end)
      |> Enum.min_by(fn {seed, location} -> location end)
    # assert final == 82

    assert final == {13, 35}

  end

end
