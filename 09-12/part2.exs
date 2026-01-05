defmodule Main do
  def main(path) do
    coords =
      File.read!(path)
      |> String.split("\n", trim: true)
      |> Enum.map(fn line ->
        line |> String.split(",") |> Enum.map(&String.to_integer/1) |> List.to_tuple()
      end)

    corner_set = MapSet.new(coords)
    indexed = Enum.with_index(coords)

    for {{x1, y1}, i} <- indexed, {{x2, y2}, j} <- indexed, j > i do
      min_x = min(x1, x2)
      max_x = max(x1, x2)
      min_y = min(y1, y2)
      max_y = max(y1, y2)

      if is_red_or_green?({x1, y2}, coords, corner_set) and
           is_red_or_green?({x2, y1}, coords, corner_set) and
           not edge_crosses_rectangle?(coords, min_x, max_x, min_y, max_y) do
        (abs(x1 - x2) + 1) * (abs(y1 - y2) + 1)
      else
        0
      end
    end
    |> Enum.max()
  end

  defp edge_crosses_rectangle?(coords, min_x, max_x, min_y, max_y) do
    coords
    |> Stream.concat([hd(coords)])
    |> Stream.chunk_every(2, 1, :discard)
    |> Enum.any?(fn [{x1, y1}, {x2, y2}] ->
      cond do
        x1 == x2 ->
          x1 > min_x and x1 < max_x and
            min(y1, y2) < max_y and max(y1, y2) > min_y

        y1 == y2 ->
          y1 > min_y and y1 < max_y and
            min(x1, x2) < max_x and max(x1, x2) > min_x

        true ->
          false
      end
    end)
  end

  defp is_red_or_green?({x, y}, coords, corner_set) do
    MapSet.member?(corner_set, {x, y}) or
      on_edge?({x, y}, coords) or
      inside_polygon?({x, y}, coords)
  end

  defp on_edge?({x, y}, coords) do
    coords
    |> Stream.concat([hd(coords)])
    |> Stream.chunk_every(2, 1, :discard)
    |> Enum.any?(fn [{x1, y1}, {x2, y2}] ->
      (x1 == x2 and x == x1 and y in min(y1, y2)..max(y1, y2)) or
        (y1 == y2 and y == y1 and x in min(x1, x2)..max(x1, x2))
    end)
  end

  defp inside_polygon?({x, y}, coords) do
    crossings =
      coords
      |> Stream.concat([hd(coords)])
      |> Stream.chunk_every(2, 1, :discard)
      |> Enum.count(fn [{x1, y1}, {x2, y2}] ->
        x1 == x2 and x1 > x and y > min(y1, y2) and y < max(y1, y2)
      end)

    rem(crossings, 2) == 1
  end
end

Main.main("test_dataset.txt") |> IO.inspect()
Main.main("dataset.txt") |> IO.inspect()
