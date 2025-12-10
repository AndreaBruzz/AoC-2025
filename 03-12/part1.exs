defmodule Main do
  def main(path) do
    path
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.map(&process_bank/1)
    |> Enum.sum()
  end

  defp process_bank(line) do
    digits = line |> String.graphemes() |> Enum.map(&String.to_integer/1)

    # I wanted to do this in a way that would generalize to some more
    # digits with minimum effort, if needed in part 2.
    {_, rest} = List.pop_at(digits, -1)

    with {max1, idx} <- max_with_index(rest),
         rem <- Enum.drop(digits, idx + 1),
         {max2, _} <- max_with_index(rem) do
      max1 * 10 + max2
    end
  end

  defp max_with_index(list) do
    # Leveraging the fact that find_index will return the first occurrence of the max
    {Enum.max(list), Enum.find_index(list, fn x -> x == Enum.max(list) end)}
  end
end

Main.main("test_dataset.txt") |> IO.inspect()
Main.main("dataset.txt") |> IO.inspect()
