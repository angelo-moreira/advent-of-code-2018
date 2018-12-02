defmodule Advent.D2 do
  def occurences(string) do
    string
    |> String.split("", trim: true)
    |> Enum.group_by(&String.first/1)
    |> Enum.reduce({0, 0}, fn {_, occ}, acc ->
      acc2 = elem(acc, 0)
      acc3 = elem(acc, 1)

      cond do
        length(occ) == 2 -> {1, acc3}
        length(occ) == 3 -> {acc2, 1}
        true -> {acc2, acc3}
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

            cond do
              occ2 > 0 and occ3 > 0 -> {acc2 + 1, acc3 + 1}
              occ2 > 0 -> {acc2 + 1, acc3}
              occ3 > 0 -> {acc2, acc3 + 1}
              true -> {acc2, acc3}
            end
          end)

        occ2 * occ3

      {:error, reason} ->
        {:error, reason}
    end
  end
end
