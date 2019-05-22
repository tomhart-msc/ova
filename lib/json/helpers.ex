defmodule Json.Helpers do

  def decode_field(%{__struct__: _} = data, _options) do
    # Already decoded
    data
  end

  def decode_field(data, options) do
    #IO.puts "Transforming "
    #IO.inspect data
    # Calling transform structures the field, and calling decode recurses
    data |> Poison.Decode.transform(options) |> Poison.Decoder.decode(options)
  end

  def decode_list(nil, _, _) do
    []
  end

  def decode_list(list, helper, options) do
    Enum.map(list, fn x -> helper.(x, options) end)
  end

  def atomize(atom, _) when is_atom(atom) do
    atom
  end

  def atomize(string, allowed) do
    string |> String.downcase |> String.to_existing_atom |> atom_in_list(allowed)
  end

  defp atom_in_list(string, allowed) do
    if string in allowed do
      string
    else
      raise "Unallowed value: " + string
    end
  end

end
