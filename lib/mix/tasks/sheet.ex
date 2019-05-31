defmodule Mix.Tasks.Sheet do
  @moduledoc """
  This module defines a mix command to create a PDF character sheet from a JSON file.
  """

  use Mix.Task

  defp make_sheet([arg | []]) do
    json = File.read!(arg)
    options = %{as: %Character.Character{}, abilities: abilities(), weaknesses: weaknesses()}
    char = Poison.decode!(json, options)
    traits = Trait.Traits.fromAbilitiesAndWeaknesses(abilities(), weaknesses())
    modifiers = Trait.Modifiers.fromPerksAndFlaws(perks(), flaws())

    Character.Sheet.pdf_character_sheet(char, traits, modifiers)
  end

  defp make_sheet(_) do
    IO.puts("Invalid argument")
  end

  @impl Mix.Task
  def run(args) do
    Application.ensure_all_started(:pdf_generator)
    make_sheet(args)
  end

  defp abilities do
    json = File.read!("./assets/abilities.json")
    Poison.decode!(json, as: [%Trait.Ability{}])
  end

  defp weaknesses do
    json = File.read!("./assets/weaknesses.json")
    Poison.decode!(json, as: [%Trait.Ability{}])
  end

  defp perks do
    json = File.read!("./assets/perks.json")
    Poison.decode!(json, as: [%Trait.Perk{}])
  end

  defp flaws do
    json = File.read!("./assets/flaws.json")
    Poison.decode!(json, as: [%Trait.Perk{}])
  end

end
