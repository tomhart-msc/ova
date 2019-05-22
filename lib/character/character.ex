defmodule Character.Character do
  @moduledoc """
  This is the main module for storing an OVA character as a character sheet. A character has a name,
  a list of abilities, a list of weaknesses, and a list of attacks.
  """

  @derive [Poison.Encoder]
  import Json.Helpers

  defstruct [:name, :abilities, :weaknesses, :attacks]

  @type t :: %Character.Character{
    name: String.t,
    abilities: list(Character.Ability.t),
    weaknesses: list(Character.Ability.t),
    attacks: list(Character.Attack.t)
  }

  def transformation(character) do
    get_ability(character, "Transformation")
  end

  def companion(character) do
    get_ability(character, "Companion")
  end

  def get_ability(character, abilityName) do
    if_exists(Enum.find(character.abilities, fn x -> x.name == abilityName end))
  end

  defp if_exists(nil) do
    [:not_found, nil]
  end

  defp if_exists(x) do
    [:ok, x]
  end

  def health(character, traits) do
    Enum.reduce(character.abilities, 40, fn ability, acc -> acc + Character.Ability.stat_effect(ability, :health, traits) end)
  end

  def endurance(character, traits) do
    Enum.reduce(character.abilities, 40, fn ability, acc -> acc + Character.Ability.stat_effect(ability, :endurance, traits) end)
  end

  defimpl Poison.Decoder, for: Character.Character do
    def decode(data, options) do
      # Data is the JSON, parsed as a map. It may already have been decoded and
      # this function needs to handle that case. We do so with helper functions which
      # pattern match against abilities and weaknesses which have already been
      # transformed into lists of structs.
      # Options are things like "as: %Character.Character{}"
      ability_options = %{options | as: %Character.Ability{}}
      attack_options = %{options | as: %Character.Attack{}}

      data
      # Transform each ability into a Character.Ability
      |> Map.update!(
        :abilities,
        fn list ->
          decode_list(list, &decode_field/2, ability_options)
        end
      )
      # Transform each weakness into a Character.Ability
      |> Map.update!(
        :weaknesses,
        fn list -> decode_list(list, &decode_field/2, ability_options) end
      )
      # Transform each attack into a Character.Attack
      |> Map.update!(
        :attacks,
        fn list -> decode_list(list, &decode_field/2, attack_options) end
      )
    end
  end
end
