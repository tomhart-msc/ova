defmodule Character.Attack do
  import Json.Helpers
  defstruct [:name, :perks, :flaws]

  defimpl Poison.Decoder, for: Character.Attack do
    def decode(data, options) do
      perkOptions = %{options | as: %Character.Attack.Perk{}}
      flawOptions = %{options | as: %Character.Attack.Flaw{}}
      data
      |> Map.update!(
        :perks,
        fn list ->
          decode_list(list, &decode_field/2, perkOptions)
        end
      )
      |> Map.update!(
        :flaws,
        fn list ->
          decode_list(list, &decode_field/2, flawOptions)
        end
      )
    end

  end
end
