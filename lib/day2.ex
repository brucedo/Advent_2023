defmodule Game do
  @typedoc """
  Game structure.  Holds the game ID and the ordered list of Draws.
  """
  @type g :: %__MODULE__{game_id: integer(), draws: list(Draw.d())}
  defstruct game_id: 0, draws: []
end

defmodule Draw do
  @typedoc """
  Simple struct representing the count of cube colours for any single draw
  """
  @type d :: %__MODULE__{red: integer(), green: integer(), blue: integer()}
  defstruct red: 0, green: 0, blue: 0
end

defmodule Day2 do
require Logger

  def run() do
    lines = Common.open(File.cwd, "day2.txt") |> Common.read_file_pipe() |> Common.close()

    games = for line <- lines, do: decode(line)

    red = 12
    green = 13
    blue = 14

    viable_games =
      Enum.filter(games, fn game -> List.foldl(game.draws, true, fn draw, acc -> acc && draw.red <= red && draw.green <= green && draw.blue <= blue end) end )

    viable_ids = Enum.map(viable_games, fn viable -> viable.game_id end)
    total = Enum.sum(viable_ids)

    IO.puts("The sum of the viable game IDs is #{total}")

    # Minimum set
    minimum_viable = Enum.map(games, fn game -> List.foldl(game.draws, {0, 0, 0},
      fn draw, acc -> {max(draw.red, elem(acc, 0)), max(draw.green, elem(acc, 1)), max(draw.blue, elem(acc, 2))} end ) end)

    powers = Enum.map(minimum_viable, fn set -> elem(set, 0) * elem(set, 1) * elem(set, 2) end)
    power_sum = List.foldl(powers, 0, fn power, acc -> power + acc end)

    IO.puts("The sum of the powers of the sets is #{power_sum}")

  end

  def decode(line) do
    game_and_draws = String.split(line, ":")
    game = decode_game(List.first(game_and_draws))
    Map.put(game, :draws, decode_draws(List.last(game_and_draws)))

  end


  @spec decode_game(String.t()) :: Game.g()
  def decode_game(game_slice) do
    %Game{game_id: String.split(game_slice, " ") |> List.last() |> Integer.parse() |> elem(0)}
  end

  @spec decode_draws(String.t()) :: list(Draw.d())
  def decode_draws(draws_slice) do
    for draw <- String.split(draws_slice, ";"), do: decode_draw(draw)
  end

  @spec decode_draw(String.t()) :: Draw.d()
  def decode_draw(draw_slice) do
    red_regex = ~r/ *(?<red>[0-9]+) red/
    green_regex = ~r/ *(?<green>[0-9]+) green/
    blue_regex = ~r/ *(?<blue>[0-9]+) blue/

    %Draw{red: run_regex_and_get_count(red_regex, draw_slice), green: run_regex_and_get_count(green_regex, draw_slice), blue: run_regex_and_get_count(blue_regex, draw_slice)}

  end

  @spec run_regex_and_get_count(Regex.t(), String.t()) :: integer()
  defp run_regex_and_get_count(regex, slice) do

    found = Regex.run(regex, slice)

    case found do
      nil -> 0
      [""] -> 0
      capture -> List.last(capture) |> Integer.parse() |> elem(0)
    end
  end

  def slice_game(game_line) do
    String.split(game_line, ":") |> List.to_tuple()
  end

  def slice_draws(draw_slice) do
    String.split(draw_slice, ";")
  end

end
