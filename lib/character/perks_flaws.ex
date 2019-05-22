defmodule Character.PerksFlaws do
  @moduledoc """
  This module contains the list of perks and flaws for one of a character's abilities.
  """

  defstruct [:perks, :flaws]
  import Json.Helpers

  defimpl Poison.Decoder, for: Character.PerksFlaws do
    def decode(data, options) do
      perk_options = %{options | as: %Character.Attack.Perk{}}
      flaw_options = %{options | as: %Character.Attack.Flaw{}}
      data
      |> Map.update!(
        :perks,
        fn list ->
          decode_list(list, &decode_field/2, perk_options)
        end
      )
      |> Map.update!(
        :flaws,
        fn list ->
          decode_list(list, &decode_field/2, flaw_options)
        end
      )
    end
  end
end
