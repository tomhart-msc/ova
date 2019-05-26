defmodule Character.Attack.Perk do
  @moduledoc """
  This module defines the structure of a perk of a character's ability.
  """
  defstruct [:name, :rank, :qualifier]

  @type t :: %Character.Attack.Perk{
    name: String.t,
    rank: pos_integer(),
    qualifier: String.t
  }

  @doc "Specifies default values for a perk a character has taken"
  def default do
    %Character.Attack.Perk{
      name: "",
      rank: 1,
      qualifier: ""
    }
  end

  # Given a perk (eg. Effective at Rank 3), statistic (eg. DX), and
  # a list of modifiers (perks and flaws),
  # calculates the effect the ability has on this stat.
  def stat_effect(perk, stat, modifiers) do
    trait = Trait.Modifiers.byName(modifiers, perk.name)
    effect = Trait.Perk.effect(trait)
    Trait.Effect.effectOnCharacterStat(effect, stat) * perk.rank
  end


  defimpl Poison.Decoder, for: Character.Attack.Perk do
    def decode(data, _options) do
      data
    end
  end
end
