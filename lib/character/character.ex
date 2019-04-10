defmodule Character.Character do
  @derive [Poison.Encoder]
  import Character.Poison.Helpers

  defstruct [:name, :abilities, :weaknesses, :attacks]

  defimpl Poison.Decoder, for: Character.Character do
    def decode(data, options) do
      # Data is the JSON, parsed as a map. It may already have been decoded and
      # this function needs to handle that case. We do so with helper functions which
      # pattern match against abilities and weaknesses which have already been
      # transformed into lists of structs.
      # Options are things like "as: %Character.Character{}"
      abilityOptions = %{options | as: %Character.Ability{}}
      weaknessOptions = %{options | as: %Character.Weakness{}}
      attackOptions = %{options | as: %Character.Attack{}}

      data
      # Transform each ability into a Character.Ability
      |> Map.update!(
        :abilities,
        fn abilityList ->
          decode_list(abilityList, &decode_ability/2, abilityOptions)
        end
      )
      # Transform each weakness into a Character.Weakness
      |> Map.update!(
        :weaknesses,
        fn abilityList -> decode_list(abilityList, &decode_weakness/2, weaknessOptions) end
      )
      # Transform each attack into a Character.Attack
      |> Map.update!(
        :attacks,
        fn abilityList -> decode_list(abilityList, &decode_attack/2, attackOptions) end
      )
    end

    defp decode_ability(%Character.Ability{} = ability, _) do
      ability
    end

    defp decode_ability(ability, options) do
      Poison.Decode.transform(ability, options)
    end

    defp decode_weakness(%Character.Weakness{} = weakness, _) do
      weakness
    end

    defp decode_weakness(weakness, options) do
      Poison.Decode.transform(weakness, options)
    end

    defp decode_attack(%Character.Attack{} = attack, _) do
      attack
    end

    defp decode_attack(attack, options) do
      # transform turns it into a Poison.Attack, and calling decode for Poison.Attack recurses (BUT DOESN'T)
      Poison.Decode.transform(attack, options) |> Poison.Decoder.decode(options)
    end
  end
end
