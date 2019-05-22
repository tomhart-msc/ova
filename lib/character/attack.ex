defmodule Character.Attack do
  @moduledoc """
  This module defines the structure of a perk of a character's attack. An attack has a name, zero or more perks,
  and zero or more flaws.
  """

  import Json.Helpers
  defstruct [:name, :perks, :flaws]

  @type t :: %Character.Attack{
    name: String.t,
    perks: any(),
    flaws: any() #TODO
  }

  defimpl Poison.Decoder, for: Character.Attack do
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
