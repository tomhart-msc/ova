defmodule Mix.Tasks.Roll do
    @moduledoc """
    This module defines a mix command to roll dice. It takes as an argument the number of dice to roll.
    """

    use Mix.Task

    defp roll({n, ""}) do
        Dice.roll(n)
    end

    defp roll([arg | []]) do
        result = roll(Integer.parse(arg))
        #IO.inspect(result)
        IO.puts("#{DiceDisplay.as_faces(result)} : #{Dice.result(result)}")
    end

    defp roll(_) do
        IO.puts("Invalid argument")
    end

    @impl Mix.Task
    def run(args) do
        roll(args)
    end
end
