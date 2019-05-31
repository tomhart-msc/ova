defmodule Character.Attack do
  @moduledoc """
  This module defines the structure of a perk of a character's attack. An attack has a name, zero or more perks,
  and zero or more flaws.
  """

  import Json.Helpers
  defstruct [:name, :perks, :flaws]

  @type t :: %Character.Attack{
    name: String.t,
    perks: Character.Attack.Perk.t,
    flaws: Character.Attack.Perk.t
  }

  def details(character = %Character.Character{}, attack = %Character.Attack{}, traits = %Trait.Traits{}, modifiers = %Trait.Modifiers{}) do
    {attack,
    attack_dice(character, attack, traits, modifiers),
    dx(character, attack, traits, modifiers),
    endurance_cost(attack, modifiers)}
  end

  def description(attack = %Character.Attack{perks: [], flaws: []}, _) do
    attack.name
  end

  def description(attack = %Character.Attack{}, modifiers = %Trait.Modifiers{}) do
    attack_modifiers = Enum.concat(attack.perks, attack.flaws)
    modifiers_with_costs = Enum.map(attack_modifiers, fn mod -> format_modifier(mod, modifiers) end)
    details = Enum.join(modifiers_with_costs, ", ")
    "#{attack.name} (#{details})"
  end

  defp format_modifier(modifier = %Character.Attack.Perk{}, modifiers = %Trait.Modifiers{}) do
    modifier_details = Trait.Modifiers.byName(modifiers, modifier.name)
    "#{modifier.name}#{format_cost(modifier.rank, modifier_details.cost)}"
  end

  defp format_cost(_, cost) when cost == 0, do: ""
  defp format_cost(rank, cost) when cost > 0, do: " +#{rank * cost}"
  defp format_cost(rank, cost) when cost < 0, do: " #{rank * cost}"

  def attack_dice(character, attack, traits, modifiers) do
    abilities = filter(attack, character |> Character.Character.traits)
    base = Enum.reduce(abilities, 2, fn ability, acc -> acc + Character.Ability.stat_effect(ability, :attack, traits) end)
    Enum.reduce(attack |> modifiers, base, fn perk, acc -> acc + Character.Attack.Perk.stat_effect(perk, :attack, modifiers) end)
  end

  def dx(character, attack, traits, modifiers) do
    abilities = filter(attack, character |> Character.Character.traits)
    base = Enum.reduce(abilities, 2, fn ability, acc -> acc + Character.Ability.stat_effect(ability, :dx, traits) end)
    adjusted = Enum.reduce(attack |> modifiers, base, fn perk, acc -> acc + Character.Attack.Perk.stat_effect(perk, :dx, modifiers) end)
    max(0.5, adjusted)
  end

  def endurance_cost(attack, modifierz) do
    all = attack |> Character.Attack.modifiers
    cost = Enum.reduce(all, 0, fn perk, acc -> acc + (Trait.Modifiers.byName(modifierz, perk.name).cost * perk.rank) end)
    max(0, cost)
  end

  def modifiers(attack) do
    Enum.concat(attack.perks, attack.flaws)
  end

  # Removes the Stong ability from consideration for ranged attacks
  defp filter(attack, abilities) do
    if Enum.any?(attack.perks, fn perk -> perk.name == "Ranged" end) do
      Enum.filter(abilities, fn perk -> perk.name != "Strong" end)
    else
      abilities
    end
  end

  defimpl Poison.Decoder, for: Character.Attack do
    def decode(data, options) do
      perk_options = %{options | as: Character.Attack.Perk.default()}
      data
      |> Map.update!(
        :perks,
        fn list ->
          decode_list(list, &decode_field/2, perk_options)
        end
      )
      |> Map.update!(
        :flaws,
        fn list ->
          decode_list(list, &decode_field/2, perk_options)
        end
      )
    end

  end
end
