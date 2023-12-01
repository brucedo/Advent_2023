defmodule Day1 do
require Logger

  def run() do
    lines = Common.open(File.cwd, "day1.txt") |> Common.read_file_pipe() |> Common.close()

    digits = decode(lines, &bracketing_numbers/1) |> fold() |> Enum.sum()

    IO.puts("The finished sum of all digits appears to be #{digits}")

    better_digits = decode(lines, &bracketing_fucked/1) |> fold() |> Enum.sum()

    IO.puts("The part 2 finished value appears to be #{better_digits}")
  end

  @spec decode(list(String.t()), fun()) :: list({integer(), integer()})
  def decode(lines, bracket_fn) do
    Enum.map(lines, bracket_fn)
  end

  @spec fold(list({integer(), integer()})) :: list(integer())
  def fold(pairs) do
    for {left, right} <- pairs do
      (left * 10) + right
    end
  end

  @spec bracketing_numbers(String.t()) :: {integer(), integer()}
  def bracketing_numbers(to_search) do
    digits = real_search(to_search, []) |> Enum.reverse()

    {List.first(digits), List.last(digits)}
  end

  @spec real_search(String.t(), [integer()]) :: [integer()]
  def real_search("", digits) do
    digits
  end

  def real_search(to_search, digits) do
    {first, tail} = String.split_at(to_search, 1)
    case Integer.parse(first) do
      :error ->
        real_search(tail, digits)
      {digit, _} ->
        real_search(tail, List.insert_at(digits, 0, digit))
    end

  end

  @spec destring(String.t()) :: String.t()
  def destring(digit) when digit == "one" or digit == "1" do 1 end
  def destring(digit) when digit == "two" or digit == "2"  do 2 end
  def destring(digit) when digit =="three" or digit == "3" do 3 end
  def destring(digit) when digit =="four" or digit == "4"  do 4 end
  def destring(digit) when digit =="five" or digit == "5"  do 5 end
  def destring(digit) when digit =="six" or digit == "6"   do 6 end
  def destring(digit) when digit =="seven" or digit == "7" do 7 end
  def destring(digit) when digit =="eight" or digit == "8" do 8 end
  def destring(digit) when digit =="nine" or digit == "9"  do 9 end

  @spec bracketing_fucked(String.t()) :: {integer(), integer()}
  def bracketing_fucked(mess) do
    all_digits = find_digits_including_words(mess)
    {List.first(all_digits), List.last(all_digits)}
  end

  def find_digits_including_words("") do
    []
  end


  def find_digits_including_words(mess)
  do
    case test_for_word_number(mess) do
      nil -> String.split_at(mess, 1) |> elem(1) |> find_digits_including_words()
      digit -> String.split_at(mess, 1) |> elem(1) |> find_digits_including_words() |> List.insert_at(0, digit)
    end
  end

  defp test_for_word_number(line) do
    regex = ~r/\A(one|1|two|2|three|3|four|4|five|5|six|6|seven|7|eight|8|nine|9)/

    case Regex.run(regex, line, capture: :first) do
      nil -> nil
      [number_word] -> destring(number_word)
    end
  end

  defp try_digit(mebbe_digit) do
    case Integer.parse(mebbe_digit) do
      :error -> :error
      {digit, _} -> digit
    end
  end
end
