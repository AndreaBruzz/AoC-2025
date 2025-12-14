defmodule Main do
  def main(path) do
    lines =
      File.read!(path)
      |> String.split("\n", trim: true)

    ranges = get_ranges(lines)
    availables = get_availables(lines)

    availables |> Enum.count(&in_range?(&1, ranges))
  end

  defp get_ranges(lines) do
    lines
    |> Enum.filter(&String.contains?(&1, "-"))
    |> Enum.map(fn range ->
      range
      |> String.split("-", trim: true)
      |> Enum.map(&String.to_integer/1)
    end)
  end

  defp get_availables(lines) do
    lines
    |> Enum.filter(&(!String.contains?(&1, "-")))
    |> Enum.map(&String.to_integer/1)
  end

  defp in_range?(num, ranges) do
    ranges |> Enum.any?(fn [l, u] -> num >= l and num <= u end)
  end
end

Main.main("test_dataset.txt") |> IO.inspect()
Main.main("dataset.txt") |> IO.inspect()
