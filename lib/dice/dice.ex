defmodule Dice do
    @moduledoc """
    This module defines dice rolls according to OVA's semantics for doubles.
    """
    def empty, do: %{1 => 0, 2 => 0, 3 => 0, 4 => 0, 5 => 0, 6 => 0}

    defp roll(map, _, 0) do
        map
    end

    defp roll(map, roll, n) do
        roll(%{map | roll => map[roll] + 1}, :rand.uniform(6), n - 1)
    end

    def roll(n) when is_integer(n) do
        roll(empty(), :rand.uniform(6), n)
    end

    def result(map) when is_map(map) do
        result(Map.to_list(map))
    end

    def result(list) when is_list(list) do
        die_result(Enum.max_by(list, &die_result/1))
    end

    def die_result({face, num}) do
        face * num
    end
end
