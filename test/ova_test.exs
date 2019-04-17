defmodule OVATest do
  use ExUnit.Case
  doctest OVA

  test "greets the world" do
    assert OVA.hello() == :world
  end

  test "sees test data" do
    refute Enum.empty?(File.ls!("./test/examples"))
  end

  #test "parse ability" do
  #  json = File.read!("./test/examples/basic_ability.json")
  #  a = Poison.decode!(json, as: %Character.Ability{})
  #  assert a.name == "Knowledge"
  #  IO.inspect a
  #end

  # Examples of the Poison library use Poison.Decode.decode, which was removed
  # in Poison 4.0. Use Poison.Decode.transform to recursively transform data.
  test "how does poison work" do
    json = File.read!("./test/examples/basic_ability.json")
    map = Poison.decode!(json)
    a = Poison.Decode.transform(map, %{as: %Character.Ability{}})
    assert a.name == "Knowledge"
  end

  test "parse attack" do
    json = File.read!("./test/examples/attack.json")
    a = Poison.decode!(json, %{as: %Character.Attack{}})
    assert a.name == "First Day of Sale Shove!"
  end

  test "parse character" do
    json = File.read!("./test/examples/braun.json")
    options = %{as: %Character.Character{}}
    braun = Poison.decode!(json, options)
    assert braun.name == "Braun"

    # Verify that everything was decoded with the correct type
    attack = Enum.at(braun.attacks, 0)
    assert attack.__struct__ == Character.Attack
    assert Enum.at(attack.perks, 0).__struct__ == Character.Attack.Perk
    assert Enum.at(attack.flaws, 0).__struct__ == Character.Attack.Flaw
    assert Enum.at(braun.abilities, 0).__struct__ == Character.Ability
    assert Enum.at(braun.weaknesses, 0).__struct__ == Character.Weakness

    [found, _] = Character.Character.transformation(braun)
    assert :not_found == found
    #IO.inspect braun
  end

  test "parse character with transformation" do
    json = File.read!("./test/examples/fukiko.json")
    options = %{as: %Character.Character{}}
    fukiko = Poison.decode!(json, options)
    assert fukiko.name == "Fukiko"
    attack = Enum.at(fukiko.attacks, 0)
    assert attack.__struct__ == Character.Attack
    assert Enum.at(attack.perks, 0).__struct__ == Character.Attack.Perk
    assert Enum.at(fukiko.abilities, 0).__struct__ == Character.Ability
    assert Enum.at(fukiko.weaknesses, 0).__struct__ == Character.Weakness

    [found, transform] = Character.Character.transformation(fukiko)
    assert :ok == found
    assert transform.details.__struct__ == Character.TransformationDetails
    assert Enum.at(transform.details.abilities, 0).__struct__ == Character.Ability
    assert Enum.at(transform.details.weaknesses, 0).__struct__ == Character.Weakness

    #IO.inspect fukiko
  end

  test "parse character with companion" do
    json = File.read!("./test/examples/yuu.json")
    options = %{as: %Character.Character{}}
    yuu = Poison.decode!(json, options)
    assert yuu.name == "Yuu"
    attack = Enum.at(yuu.attacks, 0)
    assert attack.__struct__ == Character.Attack
    assert Enum.at(attack.perks, 0).__struct__ == Character.Attack.Perk
    assert Enum.at(yuu.abilities, 0).__struct__ == Character.Ability
    assert Enum.at(yuu.weaknesses, 0).__struct__ == Character.Weakness

    [found, fenrir] = Character.Character.companion(yuu)
    assert :ok == found
    assert fenrir.details.__struct__ == Character.Character
    assert Enum.at(fenrir.details.abilities, 0).__struct__ == Character.Ability
    assert Enum.at(fenrir.details.weaknesses, 0).__struct__ == Character.Weakness

    #IO.inspect yuu
  end
end
