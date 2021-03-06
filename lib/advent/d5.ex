defmodule Advent.D5 do
  def part1() do
    File.read!("inputs/d5.txt")
    |> clean_list("")
    |> String.length()
  end

  def part2() do
    string = File.read!("inputs/d5.txt")

    capital_letters =
      string
      |> String.split("", trim: true)
      |> Enum.uniq()
      |> Enum.filter(&(&1 =~ ~r/^\p{Lu}$/u))

    capital_letters
    |> Enum.map(&String.split(string, [&1, String.downcase(&1)]))
    |> Enum.map(&Enum.join(&1))
    |> Enum.map(&(clean_list(&1, "") |> String.length()))
    |> Enum.min(& &1)
  end

  def clean_list(string, acc) do
    if string == "" do
      acc
    else
      {hd, tail} = get_head_and_tail(string)
      hd_capital? = hd =~ ~r/^\p{Lu}$/u

      {hd_acc, tail_acc} = get_head_and_tail(acc)
      hd_acc_capital? = hd_acc =~ ~r/^\p{Lu}$/u

      cond do
        (hd_capital? and String.downcase(hd) == hd_acc) or
            (hd_acc_capital? and String.downcase(hd_acc) == hd) ->
          clean_list(tail, clean_list("", tail_acc))

        true ->
          clean_list(tail, hd <> acc)
      end
    end
  end

  defp get_head_and_tail(string) do
    if string == "" do
      {"", ""}
    else
      {hd, tail} = string |> String.to_charlist() |> List.pop_at(0)

      hd = List.to_string([hd])
      tail = List.to_string(tail)
      {hd, tail}
    end
  end
end
