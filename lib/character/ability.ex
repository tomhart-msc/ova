defmodule Character.Ability do
    defstruct [:name, :qualifier, :value, :details]
    import Json.Helpers

    @type t :: %Character.Ability{
        name: String.t,
        qualifier: String.t,
        value: non_neg_integer(),
        details: any()
    }

    # Given an ability (eg. Strong at rank 3), statistic (eg. Health), and
    # a list of traits (abilities and weaknesses),
    # calculates the effect the ability has on this stat.
    def stat_effect(ability, stat, traits) do
        trait = Trait.Traits.byName(traits, ability.name)
        effect = Trait.Ability.effect(trait)
        Trait.Effect.effectOnCharacterStat(effect, stat) * ability.value
    end

    defimpl Poison.Decoder, for: Character.Ability do
        @details %{perksflaws: %{as: %Character.PerksFlaws{}},
            character: %{as: %Character.Character{}},
            abilitiesweaknesses: %{as: %Character.AbilitiesWeaknesses{}}}

        def decode(data, options) do
            detailsType = details_type(data, Enum.concat(options.abilities, options.weaknesses))
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
