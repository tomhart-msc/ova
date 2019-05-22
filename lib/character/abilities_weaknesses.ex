defmodule Character.AbilitiesWeaknesses do
  @moduledoc """
  This module defines the structure for storing an ability or weakness within an OVA character.
  """
  defstruct [:abilities, :weaknesses]
  import Json.Helpers

  defimpl Poison.Decoder, for: Character.AbilitiesWeaknesses do
    def decode(data, options) do
      weakness_options = %{options | as: %Character.Ability{}}
      ability_options = %{options | as: %Character.Ability{}}

      data
      # Transform each ability into a Character.Ability
      |> Map.update!(
        :abilities,
        fn list ->
          decode_list(list, &decode_field/2, ability_options)
        end
      )
      # Transform each weakness into a Character.Ability
      |> Map.update!(
        :weaknesses,
        fn list -> decode_list(list, &decode_field/2, weakness_options) end
      )
    end
  end
end
