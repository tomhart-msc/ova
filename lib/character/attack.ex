defmodule Character.Attack do
  import Character.Poison.Helpers
  defstruct [:name, :perks, :flaws]

  defimpl Poison.Decoder, for: Character.Attack do
    def decode(data, options) do
      perkOptions = %{options | as: %Character.Attack.Perk{}}
      flawOptions = %{options | as: %Character.Attack.Flaw{}}
      data
      |> Map.update!(
        :perks,
        fn list ->
          decode_list(list, &decode_perk/2, perkOptions)
        end
      )
      |> Map.update!(
        :flaws,
        fn list ->
          decode_list(list, &decode_flaw/2, flawOptions)
        end
      )
    end

    defp decode_perk(%Character.Attack.Perk{} = ability, _) do
      ability
    end

    defp decode_perk(ability, options) do
      Poison.Decode.transform(ability, options)
    end

    defp decode_flaw(%Character.Attack.Flaw{} = ability, _) do
      ability
    end

    defp decode_flaw(ability, options) do
      Poison.Decode.transform(ability, options)
    end


  end
end
