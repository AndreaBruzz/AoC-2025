defmodule Main do
  def main(path) do
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

    {_circuits, {last_i, last_j}} =
      Enum.reduce_while(pairs, {circuits, nil}, fn {_dist, i, j}, {acc, _last} ->
        root_i = find(acc, i)
        root_j = find(acc, j)

        if root_i != root_j do
          new_acc = Map.put(acc, root_i, root_j)

          if all_connected?(new_acc, n) do
            {:halt, {new_acc, {i, j}}}
          else
            {:cont, {new_acc, {i, j}}}
          end
        else
          {:cont, {acc, nil}}
        end
      end)

    [x1, _, _] = Enum.at(coords, last_i)
    [x2, _, _] = Enum.at(coords, last_j)
    x1 * x2
  end

  defp all_connected?(circuits, n) do
    roots =
      0..(n - 1)
      |> Enum.map(fn i -> find(circuits, i) end)
      |> Enum.uniq()

    length(roots) == 1
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
end

Main.main("test_dataset.txt") |> IO.inspect()
Main.main("dataset.txt") |> IO.inspect()
