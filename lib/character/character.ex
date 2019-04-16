defmodule Character.Character do
  @derive [Poison.Encoder]
  import Character.Poison.Helpers

  defstruct [:name, :abilities, :weaknesses, :attacks]

  def transformation(character) do
    if_exists(Enum.find(character.abilities, fn x -> x.name == "Transformation" end))
  end

  defp if_exists(nil) do
    [:not_found, nil]
  end

  defp if_exists(x) do
    [:ok, x]
  end

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
          decode_list(abilityList, &decode_field/2, abilityOptions)
        end
      )
      # Transform each weakness into a Character.Weakness
      |> Map.update!(
        :weaknesses,
        fn abilityList -> decode_list(abilityList, &decode_field/2, weaknessOptions) end
      )
      # Transform each attack into a Character.Attack
      |> Map.update!(
        :attacks,
        fn abilityList -> decode_list(abilityList, &decode_field/2, attackOptions) end
      )
    end
  end
end
