defmodule OVATest do
  use ExUnit.Case
  doctest OVA

  test "greets the world" do
    assert OVA.hello() == :world
  end
end
