defmodule Character.Weakness do
    defstruct [:name, :qualifier, :value]

    defimpl Poison.Decoder, for: Character.Weakness do
        def decode(data, _options) do
            data
        end
    end
end
