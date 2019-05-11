defmodule Trait.Traits do
  defstruct [:list]

  def fromAbilitiesAndWeaknesses(abilities, weaknesses) do
    %Trait.Traits{list: Enum.concat(abilities, weaknesses)}
  end

  # Given a list of traits, finds the trait with the given name if one exists.
  def byName(traits, name) do
    Enum.find(traits.list, fn t -> t.name == name end)
  end
end
