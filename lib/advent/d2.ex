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
end
