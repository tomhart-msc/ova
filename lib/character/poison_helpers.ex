defmodule Character.Poison.Helpers do

  def decode_field(%{__struct__: _} = data, _options) do
    # Already decoded
    data
  end

  def decode_field(data, options) do
    # Calling transform structures the field, and calling decode recurses
    Poison.Decode.transform(data, options) |> Poison.Decoder.decode(options)
  end

  def decode_list(nil, _, _) do
    []
  end

  def decode_list(list, helper, options) do
    Enum.map(list, fn x -> helper.(x, options) end)
  end

end
