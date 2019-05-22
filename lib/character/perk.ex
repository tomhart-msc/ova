defmodule Character.Attack.Perk do
  @moduledoc """
  This module defines the structure of a perk of a character's ability.
  """
  defstruct [:name, :cost, :qualifier]

  defimpl Poison.Decoder, for: Character.Attack.Perk do
    def decode(data, _options) do
      data
    end
  end
end
