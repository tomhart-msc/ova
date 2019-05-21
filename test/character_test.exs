defmodule CharacterTest do
  use ExUnit.Case

  test "parse ability" do
    json = File.read!("./test/examples/basic_ability.json")
    a = Poison.decode!(json, as: %Character.Ability{}, abilities: abilities(), weaknesses: weaknesses())
    assert a.name == "Knowledge"
  end

  # Examples of the Poison library use Poison.Decode.decode, which was removed
  # in Poison 4.0. Use Poison.Decode.transform to recursively transform data.
  test "parse acharacter's ability using Poison.Decode.transform" do
    json = File.read!("./test/examples/basic_ability.json")
    map = Poison.decode!(json)
    a = Poison.Decode.transform(map, %{as: %Character.Ability{}, abilities: abilities(), weaknesses: weaknesses()})
    assert a.name == "Knowledge"
  end

  test "parse attack" do
    json = File.read!("./test/examples/attack.json")
    a = Poison.decode!(json, %{as: %Character.Attack{}})
    assert a.name == "First Day of Sale Shove!"
  end

  test "parse character" do
    json = File.read!("./test/examples/braun.json")
    options = %{as: %Character.Character{}, abilities: abilities(), weaknesses: weaknesses()}
    braun = Poison.decode!(json, options)
    assert braun.name == "Braun"

    # Verify that everything was decoded with the correct type
    attack = Enum.at(braun.attacks, 0)
    assert attack.__struct__ == Character.Attack
    assert Enum.at(attack.perks, 0).__struct__ == Character.Attack.Perk
    assert Enum.at(attack.flaws, 0).__struct__ == Character.Attack.Flaw
    assert Enum.at(braun.abilities, 0).__struct__ == Character.Ability
    assert Enum.at(braun.weaknesses, 0).__struct__ == Character.Ability

    [found, _] = Character.Character.transformation(braun)
    assert :not_found == found
    #IO.inspect braun
  end

  test "parse character with transformation" do
    json = File.read!("./test/examples/fukiko.json")
    options = %{as: %Character.Character{}, abilities: abilities(), weaknesses: weaknesses()}
    fukiko = Poison.decode!(json, options)
    assert fukiko.name == "Fukiko"
    attack = Enum.at(fukiko.attacks, 0)
    assert attack.__struct__ == Character.Attack
    assert Enum.at(attack.perks, 0).__struct__ == Character.Attack.Perk
    assert Enum.at(fukiko.abilities, 0).__struct__ == Character.Ability
    assert Enum.at(fukiko.weaknesses, 0).__struct__ == Character.Ability
    assert Character.Character.health(fukiko, %Trait.Traits{list: abilities()}) == 40
    assert Character.Character.endurance(fukiko, %Trait.Traits{list: abilities()}) == 40

    [found, transform] = Character.Character.transformation(fukiko)
    assert :ok == found
    assert transform.details.__struct__ == Character.AbilitiesWeaknesses
    assert Enum.at(transform.details.abilities, 0).__struct__ == Character.Ability
    assert Enum.at(transform.details.weaknesses, 0).__struct__ == Character.Ability

    #IO.inspect fukiko
  end

  test "parse character with companion" do
    json = File.read!("./test/examples/yuu.json")
    options = %{as: %Character.Character{}, abilities: abilities(), weaknesses: weaknesses()}
    yuu = Poison.decode!(json, options)
    assert yuu.name == "Yuu"
    attack = Enum.at(yuu.attacks, 0)
    assert attack.__struct__ == Character.Attack
    assert Enum.at(attack.perks, 0).__struct__ == Character.Attack.Perk
    assert Enum.at(yuu.abilities, 0).__struct__ == Character.Ability
    assert Enum.at(yuu.weaknesses, 0).__struct__ == Character.Ability
    assert Character.Character.health(yuu, %Trait.Traits{list: abilities()}) == 60

    [found, fenrir] = Character.Character.companion(yuu)
    assert :ok == found
    assert fenrir.details.__struct__ == Character.Character
    assert Enum.at(fenrir.details.abilities, 0).__struct__ == Character.Ability
    assert Enum.at(fenrir.details.weaknesses, 0).__struct__ == Character.Ability

    #IO.inspect yuu
  end

  defp abilities do
    json = File.read!("./assets/abilities.json")
    Poison.decode!(json, as: [%Trait.Ability{}])
  end

  defp weaknesses do
    json = File.read!("./assets/weaknesses.json")
    Poison.decode!(json, as: [%Trait.Ability{}])
  end

end
