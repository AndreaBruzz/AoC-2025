defmodule Main do
  def main(path) do
    File.read!(path)
    |> String.split("\n", trim: true)
    |> Enum.reduce(%{}, fn line, positions ->
      cond do
        String.contains?(line, "S") ->
          {idx, _} = :binary.match(line, "S")
          %{idx => 1}

        true ->
          splitters = find_splitters(line) |> MapSet.new()
          line_len = byte_size(line)

          Enum.reduce(positions, %{}, fn {idx, count}, acc ->
            if idx in splitters do
              acc
              |> add_if_valid(idx - 1, count, line_len)
              |> add_if_valid(idx + 1, count, line_len)
            else
              Map.update(acc, idx, count, &(&1 + count))
            end
          end)
      end
    end)
    |> Map.values()
    |> Enum.sum()
  end

  defp add_if_valid(acc, idx, count, line_len) when idx >= 0 and idx < line_len do
    Map.update(acc, idx, count, &(&1 + count))
  end

  defp find_splitters(string) do
    :binary.matches(string, "^")
    |> Enum.map(fn {idx, _len} -> idx end)
  end
end

Main.main("test_dataset.txt") |> IO.inspect()
Main.main("dataset.txt") |> IO.inspect()
