defmodule Character.Ability do
    defstruct [:name, :qualifier, :value, :details]
    import Json.Helpers

    defimpl Poison.Decoder, for: Character.Ability do
        @details %{perksflaws: %{as: %Character.PerksFlaws{}},
            character: %{as: %Character.Character{}},
            abilitiesweaknesses: %{as: %Character.AbilitiesWeaknesses{}}}

        def decode(data, options) do
            detailsType = details_type(data, options.abilities)
            ability(data, decode_details(data, detailsType, options))
        end

        defp details_type(data, abilities) do
            ability = Enum.find(abilities, fn a -> a.name == data.name end)
            Map.get(@details, ability.details)
        end

        defp decode_details(_, nil, _) do
            nil
        end

        defp decode_details(data, type, options) do
            decode_field(data.details, Map.merge(options, type))
        end

        defp ability(data, details) do
            %Character.Ability{name: data.name, qualifier: data.qualifier, value: data.value, details: details}
        end
    end
end
