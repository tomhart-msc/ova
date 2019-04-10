defmodule Character.Ability do
    defstruct [:name, :qualifier, :value]

    defimpl Poison.Decoder, for: Character.Ability do
        def decode(data, _options) do
            %Character.Ability{name: data.name, qualifier: data.qualifier, value: data.value}
        end
    end
end
