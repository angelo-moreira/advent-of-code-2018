defmodule Advent.D5 do
  def part1() do
    # file
    # |> File.read!()
    # |> String.split("", trim: true)

    "dabAcCaCBAcCcaDA"
    |> String.split("", trim: true)
    |> Enum.reduce("", fn string, acc ->
      first_string = String.first(acc)

      is_capital? = string =~ ~r/^\p{Lu}$/u

      cond do
        acc == "" ->
          string

        is_capital? and String.downcase(string) == first_string ->
          {_, tail} = acc |> String.to_charlist() |> List.pop_at(0)
          List.to_string(tail)

        true ->
          string <> acc
      end
    end)
  end
end
