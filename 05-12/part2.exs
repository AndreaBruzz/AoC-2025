defmodule Main do
  def main(path) do
    lines =
      File.read!(path)
      |> String.split("\n", trim: true)

    ranges = get_ranges(lines)

    collapse_ranges(ranges)
    |> Enum.map(fn [l, u] -> u - l + 1 end)
    |> Enum.sum()
  end

  defp collapse_ranges(ranges) do
    ranges
    |> Enum.sort()
    |> Enum.reduce([], fn [l, u], acc ->
      case acc do
        [] ->
          [[l, u] | acc]

        _ ->
          [[l_acc, u_acc] | rest] = acc

          if l <= u_acc + 1 do
            [[l_acc, max(u_acc, u)] | rest]
          else
            [[l, u] | acc]
          end
      end
    end)
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
end

Main.main("test_dataset.txt") |> IO.inspect()
Main.main("dataset.txt") |> IO.inspect()
