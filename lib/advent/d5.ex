defmodule Advent.D5 do
  def part1() do
    # file
    # |> File.read!()
    # |> String.split("", trim: true)

    clean_list("dabAcCaCBAcCcaDA", "", false)
  end

  def clean_list(string, acc, to_clean?) do
    if string == "" do
      {hd, tail} = get_head_and_tail(acc)
      clean_list(tail, hd, to_clean?)
    else
      {hd, tail} = get_head_and_tail(string)
      is_capital? = hd =~ ~r/^\p{Lu}$/u

      {hd_acc, tail_acc} = get_head_and_tail(acc)

      cond do
        hd == "" ->
          if to_clean? do
            x = clean_list("", acc, to_clean?)
            require IEx
            IEx.pry()
            x
          else
            acc
          end

        is_capital? and String.downcase(hd) == hd_acc ->
          clean_list(tail, tail_acc, true)

        true ->
          clean_list(tail, hd <> acc, false)
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
