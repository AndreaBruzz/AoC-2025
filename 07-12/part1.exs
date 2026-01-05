defmodule Main do
  def main(path) do
    File.read!(path)
    |> String.split("\n", trim: true)
    |> Enum.reduce({0, []}, fn line, {count, positions} ->
      cond do
        String.contains?(line, "S") ->
          {idx, _} = :binary.match(line, "S")
          {0, [idx]}

        true ->
          splitters = find_splitters(line)

          if splitters == [] do
            {count, positions}
          else
            new_positions =
              positions
              |> Enum.flat_map(fn idx ->
                if idx in splitters do
                  cond do
                    idx == 0 -> [idx + 1]
                    idx == byte_size(line) - 1 -> [idx - 1]
                    true -> [idx - 1, idx + 1]
                  end
                else
                  [idx]
                end
              end)
              |> Enum.uniq()

            pos_set = MapSet.new(positions)
            splitter_set = MapSet.new(splitters)
            hits = MapSet.intersection(pos_set, splitter_set) |> MapSet.size()

            {count + hits, new_positions}
          end
      end
    end)
    |> elem(0)
  end

  defp find_splitters(string) do
    :binary.matches(string, "^")
    |> Enum.map(fn {idx, _len} -> idx end)
  end
end

Main.main("test_dataset.txt") |> IO.inspect()
Main.main("dataset.txt") |> IO.inspect()
