defmodule Main do
  def main(path, pairs_count) do
    coords =
      File.read!(path)
      |> String.split("\n", trim: true)
      |> Enum.map(fn line ->
        line |> String.split(",") |> Enum.map(&String.to_integer/1)
      end)

    n = length(coords)

    pairs =
      for i <- 0..(n - 2),
          j <- (i + 1)..(n - 1) do
        {distance(Enum.at(coords, i), Enum.at(coords, j)), i, j}
      end
      |> Enum.sort()

    circuits = Enum.into(0..(n - 1), %{}, fn i -> {i, i} end)

    circuits =
      pairs
      |> Enum.take(pairs_count)
      |> Enum.reduce(circuits, fn {_dist, i, j}, acc ->
        union(acc, i, j)
      end)

    0..(n - 1)
    |> Enum.map(fn i -> find(circuits, i) end)
    |> Enum.frequencies()
    |> Map.values()
    |> Enum.sort(:desc)
    |> Enum.take(3)
    |> Enum.product()
  end

  defp distance([x1, y1, z1], [x2, y2, z2]) do
    :math.sqrt((x2 - x1) ** 2 + (y2 - y1) ** 2 + (z2 - z1) ** 2)
  end

  defp find(parent, i) do
    if parent[i] == i do
      i
    else
      find(parent, parent[i])
    end
  end

  defp union(parent, i, j) do
    root_i = find(parent, i)
    root_j = find(parent, j)

    if root_i != root_j do
      Map.put(parent, root_i, root_j)
    else
      parent
    end
  end
end

Main.main("test_dataset.txt", 10) |> IO.inspect()
Main.main("dataset.txt", 1000) |> IO.inspect()
