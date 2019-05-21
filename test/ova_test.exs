defmodule OVATest do
  use ExUnit.Case
  doctest OVA

  test "greets the world" do
    assert OVA.hello() == :world
  end

  test "sees test data" do
    refute Enum.empty?(File.ls!("./test/examples"))
  end

end
