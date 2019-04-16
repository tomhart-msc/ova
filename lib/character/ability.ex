defmodule Character.Ability do
    defstruct [:name, :qualifier, :value, :details]
    import Character.Poison.Helpers

    defimpl Poison.Decoder, for: Character.Ability do

        # Special case 1: The Transformation ability includes a list of abilities and weaknesses
        # for the character's transformed form.
        def decode(%{name: "Transformation"} = data, _options) do
            ability(data, decode_field(data.details, %{as: %Character.TransformationDetails{}}))
        end

        # Special case 2: The Barrier ability has perks and flaws
        def decode(%{name: "Barrier"} = data, _options) do
            ability(data, decode_field(data.details, %{as: %Character.BarrierDetails{}}))
        end

        def decode(data, _options) do
            ability(data, nil)
        end

        defp ability(data, details) do
            %Character.Ability{name: data.name, qualifier: data.qualifier, value: data.value, details: details}
        end
    end
end
