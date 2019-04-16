defmodule Character.TransformationDetails do
  defstruct [:abilities, :weaknesses]
  import Character.Poison.Helpers

  defimpl Poison.Decoder, for: Character.TransformationDetails do
    def decode(data, options) do
      weaknessOptions = %{options | as: %Character.Weakness{}}
      abilityOptions = %{options | as: %Character.Ability{}}

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
    end
  end
end