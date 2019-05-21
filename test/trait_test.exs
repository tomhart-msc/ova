defmodule TraitTest do
  use ExUnit.Case

  test "default effect" do
    effect = Trait.Effect.default
    assert effect.__struct__ == Trait.Effect
    assert effect.type == :buff
    assert effect.target == :self
  end

  test "parse effect" do
    json = File.read!("./test/examples/effect.json")
    effect = Poison.decode!(json, as: Trait.Effect.default)
    assert effect.__struct__ == Trait.Effect
    assert effect.type == :buff
    assert effect.stat == :endurance
    assert effect.target == :self
    assert effect.by == 10
    assert effect.optional == false
  end

  test "parse a list of abilities and their effects on the game" do
    json = File.read!("./assets/abilities.json")
    l = Poison.decode!(json, as: [%Trait.Ability{}])
    traits = %Trait.Traits{list: l}
    tough = Trait.Traits.byName(traits, "Tough")
    assert tough.effect.__struct__ == Trait.Effect
    knowledge = Enum.find(l, fn a -> a.name == "Knowledge" end)
    assert knowledge.cost_multiplier == 0.5
    #IO.inspect(l)
  end

end
