defmodule Character.Ability do
    defstruct [:name, :qualifier, :value, :details]
    import Character.Poison.Helpers

    defimpl Poison.Decoder, for: Character.Ability do

        # Special case 1: The Transformation ability includes a list of abilities and weaknesses
        # for the character's transformed form.
        def decode(%{name: "Transformation"} = data, _options) do
            #IO.puts("BATMAN")
            #IO.inspect data
            ability(data, transformation_details(data.details))
        end

        def decode(data, _options) do
            #IO.puts(Map.get(data, :name))
            ability(data, [])
        end

        defp ability(data, details) do
            %Character.Ability{name: data.name, qualifier: data.qualifier, value: data.value, details: details}
        end

        defp transformation_details(%{__struct__: _} = data) do
            data
        end

        defp transformation_details(data) do
            decode_field(data, %{as: %Character.TransformationDetails{}})
        end
    end
end
