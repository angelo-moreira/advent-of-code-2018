defmodule Advent do
  @moduledoc """
  Get a list of numbers and returns the result
  """

  @doc """
  Counting.

  ## Examples

      iex> Advent.counting(["-5", "-2", "+1", "+14"])
      8

  """
  def counting(file) do
    case File.read(file) do
      {:ok, numbers} ->
        numbers
        |> string_to_ints
        |> Enum.reduce(0, &(&1 + &2))

      {:error, reason} ->
        {:error, reason}
    end
  end

  defp string_to_ints(list_of_strings),
    do: list_of_strings |> String.split("\n") |> Enum.map(&String.to_integer/1)
end
