defmodule SheetTest do
  use ExUnit.Case

  test "generate HTML character sheet" do
    json = File.read!("./test/examples/superman.json")
    options = %{as: %Character.Character{}, abilities: abilities(), weaknesses: weaknesses()}
    char = Poison.decode!(json, options)
    traits = Trait.Traits.fromAbilitiesAndWeaknesses(abilities(), weaknesses())
    modifiers = Trait.Modifiers.fromPerksAndFlaws(perks(), flaws())

    sheet = Character.Sheet.html_character_sheet(char, traits, modifiers)
    File.write("superman.html", sheet)
  end

  test "generate PDF character sheet" do
    json = File.read!("./test/examples/superman.json")
    options = %{as: %Character.Character{}, abilities: abilities(), weaknesses: weaknesses()}
    char = Poison.decode!(json, options)
    traits = Trait.Traits.fromAbilitiesAndWeaknesses(abilities(), weaknesses())
    modifiers = Trait.Modifiers.fromPerksAndFlaws(perks(), flaws())

    Character.Sheet.pdf_character_sheet(char, traits, modifiers)
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
