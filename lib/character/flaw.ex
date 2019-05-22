defmodule Character.Attack.Flaw do
  @moduledoc """
  This module defines the structure of a flaw in a character's ability.
  """
  defstruct [:name, :cost, :qualifier]

  defimpl Poison.Decoder, for: Character.Attack.Flaw do
    def decode(data, _options) do
      data
    end
  end
end
