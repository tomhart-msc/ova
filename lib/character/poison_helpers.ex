defmodule Character.Poison.Helpers do
  def decode_list(list, helper, options) do
    Enum.map(list, fn x -> helper.(x, options) end)
  end
end
