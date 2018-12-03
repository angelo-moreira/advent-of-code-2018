defmodule Advent.D2 do
  def occurences(string) do
    string
    |> String.split("", trim: true)
    |> Enum.group_by(&String.first/1)
    |> Enum.reduce_while({0, 0}, fn {_, occ}, {acc2, acc3} ->
      cond do
        acc2 == 1 and acc3 == 1 -> {:halt, {1, 1}}
        length(occ) == 2 -> {:cont, {1, acc3}}
        length(occ) == 3 -> {:cont, {acc2, 1}}
        true -> {:cont, {acc2, acc3}}
      end
    end)
  end

  def checksum(file) do
    case File.read(file) do
      {:ok, checksums} ->
        {occ2, occ3} =
          checksums
          |> String.split("\n")
          |> Enum.reduce({0, 0}, fn checksum_line, {acc2, acc3} ->
            {occ2, occ3} = occurences(checksum_line)
            {acc2 + occ2, acc3 + occ3}
          end)

        occ2 * occ3

      {:error, reason} ->
        {:error, reason}
    end
  end

  # we want to use with_index so we avoid to send all the list over
  # with the index we can keep track of what we have already processed
  def common_letter(file) do
    list_of_strings =
      file
      |> File.read!()
      |> String.split("\n", trim: true)

    list_of_strings
    |> Enum.reduce_while("", fn string, _ ->
      res =
        computate_difference(string, list_of_strings)
        |> Enum.find(&common_letter?/1)

      if res == nil,
        do: {:cont, ""},
        else: {:halt, res.eq |> Enum.map(&elem(&1, 1)) |> Enum.join()}
    end)
  end

  def computate_difference(string, list_of_strings) do
    list_of_strings
    |> Enum.map(&String.myers_difference(&1, string))
    |> Enum.map(&Enum.group_by(&1, fn {x, _} -> x end))
  end

  def common_letter?(differences) when is_list(differences),
    do:
      differences
      |> Enum.find(&common_letter?/1)

  def common_letter?(difference) do
    Map.has_key?(difference, :ins) and Map.has_key?(difference, :del) and
      length(difference.ins) == 1 and length(difference.del) == 1 and
      difference.ins[:ins] |> String.length() == 1 and
      difference.del[:del] |> String.length() == 1
  end
end
