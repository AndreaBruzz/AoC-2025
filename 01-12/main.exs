defmodule Main do
  # This may be improved with some math and have it running in O(1)
  # but I couldn't figure out the perfect formula so I went brute force.
  def count_crossings(pos, delta) do
    Enum.count(1..abs(delta), fn k ->
      step_pos =
        if delta > 0 do
          rem(pos + k, 100)
        else
          abs(rem(pos - k, 100))
        end

      step_pos == 0
    end)
  end

  def apply_rotation(pos, "R" <> val), do: {pos + String.to_integer(val), String.to_integer(val)}
  def apply_rotation(pos, "L" <> val), do: {pos - String.to_integer(val), -String.to_integer(val)}

  def normalize(raw), do: rem(rem(raw, 100) + 100, 100)

  def main(path) do
    File.read!(path)
    |> String.split("\n", trim: true)
    |> Enum.reduce({50, 0}, fn instr, {pos, acc} ->
      {raw_pos, delta} = apply_rotation(pos, instr)

      crossings = count_crossings(pos, delta)

      {normalize(raw_pos), acc + crossings}
    end)
  end
end

Main.main("dataset.txt") |> IO.inspect()
Main.main("test_dataset.txt") |> IO.inspect()
