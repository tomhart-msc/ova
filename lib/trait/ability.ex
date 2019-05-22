defmodule Trait.Ability do
  @moduledoc """
  This module defines the structure of the metadata for an ability (or weakness) in OVA. An ability
  has a name, a cost multiplier, an optional mechanical effect, and optional details. The details
  may be an affinity (eg. resistance to fire), a set of perks and flaws (ie. a barrier that can
  affect a group), a set of abilities and weaknesses (ie. for a transformation), or another
  character (ie. if the chracter has a companion).
  """

  @details [:perksflaws, :character, :abilitiesweaknesses, :affinity]
  # Ability models both ability and weakness. A weakness is an ability whose effect is negative.
  defstruct [:name, :cost_multiplier, :details, :effect]
  import Json.Helpers

  def default do
    %Trait.Ability{
      cost_multiplier: 1,
      details: nil,
      effect: nil
    }
  end

  def effect(nil) do
    nil
  end

  def effect(ability) do
    ability.effect
  end

  # Enumerates the allowed types of details for an ability
  def details do
    @details
  end

  defimpl Poison.Decoder, for: Trait.Ability do
    def decode(data, _) do
      data
      |> Map.update!(
        :details,
        &(atomize(&1, Trait.Ability.details))
      )
      |> Map.update!(
        :effect,
        fn e -> decode_field(e, %{as: Trait.Effect.default}) end
      )
    end
  end
end
