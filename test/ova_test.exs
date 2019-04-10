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
    IO.inspect braun
  end
end
