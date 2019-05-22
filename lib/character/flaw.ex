defmodule Character.Attack.Flaw do
  defstruct [:name, :cost, :qualifier]

  defimpl Poison.Decoder, for: Character.Attack.Flaw do
    def decode(data, _options) do
      data
    end
  end
end
