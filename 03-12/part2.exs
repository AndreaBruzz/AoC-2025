defmodule Main do
  @k 12

  def main(path) do
    path
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.map(&process_bank/1)
    |> Enum.sum()
  end

  defp process_bank(line) do
    digits = line |> String.graphemes() |> Enum.map(&String.to_integer/1)

    digits
    |> do_pick_k_digits(@k)
    |> Enum.reduce(0, fn d, acc -> acc * 10 + d end)
  end

  defp do_pick_k_digits(digits, k), do: pick_k_digits(digits, k, [])

  defp pick_k_digits(_, 0, acc), do: Enum.reverse(acc)
  defp pick_k_digits(digits, k, acc) do
    n = length(digits)

    {best, idx} =
      digits
      |> Enum.take(n - k + 1)
      |> max_with_index()

    Enum.drop(digits, idx + 1)
    |> pick_k_digits(k - 1, [best | acc])
  end

  defp max_with_index(list) do
    # Leveraging the fact that find_index will return the first occurrence of the max
    {Enum.max(list), Enum.find_index(list, fn x -> x == Enum.max(list) end)}
  end
end

Main.main("test_dataset.txt") |> IO.inspect(label: "Test")
Main.main("dataset.txt") |> IO.inspect(label: "Result")
