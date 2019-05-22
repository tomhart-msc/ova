defmodule Trait.Effect do
  @types [:buff, :debuff, :replace]
  @stats [:attack, :defense, :dx, :endurance, :health]
  @targets [:self, :enemy]
  # type: buff, debuff, replace -- equivalent of enum is atoms
  # stat: Attack, Defense, DX, Endurance, Health
  # target: self or enemy
  # by: default is 1 per level in the ability, -1 per level in a weakness
  # optional: default false
  # match: default is to match anything. TBD, not part of first phase.
  defstruct [:type, :stat, :target, :by, :optional, :match]
  import Json.Helpers

  def types do
    @types
  end

  def stats do
    @stats
  end

  def targets do
    @targets
  end

  def default do
    %Trait.Effect{
      type: :buff,
      stat: :attack,
      target: :self,
      by: 1,
      optional: false,
      match: "any"
    }
  end

  def effectOnCharacterStat(effect = %Trait.Effect{type: :buff, stat: stat, target: :self}, stat) do
    effect.by
  end

  def effectOnCharacterStat(effect = %Trait.Effect{type: :debuff, stat: stat, target: :self}, stat) do
    effect.by * -1
  end

  def effectOnCharacterStat(_, _) do
    0
  end

  defimpl Poison.Decoder, for: Trait.Effect do
    def decode(data, _) do
      data
      |> Map.update!(
        :type,
        &(atomize(&1, Trait.Effect.types))
      )
      |> Map.update!(
        :stat,
        &(atomize(&1, Trait.Effect.stats))
      )
      |> Map.update!(
        :target,
        &(atomize(&1, Trait.Effect.targets))
      )
    end
  end

end
