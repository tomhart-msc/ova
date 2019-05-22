defmodule Character.Attack.Perk do
  defstruct [:name, :cost, :qualifier]

  defimpl Poison.Decoder, for: Character.Attack.Perk do
    def decode(data, _options) do
      data
    end
  end
end
