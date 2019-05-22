defmodule Trait.Ability do
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
