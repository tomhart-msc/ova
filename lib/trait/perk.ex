defmodule Trait.Perk do
  @moduledoc """
  This module defines the structure of the metadata for a perk (or flaw) in OVA. A perk
  has a name, a cost per rank, and an optional mechanical effect.
  """

  # Perk models both perk and flaw. A flaw is a perk whose effect is negative.
  defstruct [:name, :cost, :effect]
  import Json.Helpers

  def effect(nil) do
    nil
  end

  def effect(ability) do
    ability.effect
  end

  defimpl Poison.Decoder, for: Trait.Perk do
    def decode(data, _) do
      data
      |> Map.update!(
        :effect,
        fn e -> decode_field(e, %{as: Trait.Effect.default}) end
      )
    end
  end

end
