defmodule Trait.Modifiers do
  @moduledoc """
  This module defines a list of modifiers in OVA. A modifier is a perk or aflaw; the two are mechanically
  identical, but perks have beneficial effects and flaws have harmful ones.
  """

  defstruct [:list]

  def fromPerksAndFlaws(perks, flaws) do
    %Trait.Modifiers{list: Enum.concat(perks, flaws)}
  end

  # Given a list of modifiers, finds the modifier with the given name if one exists.
  def byName(modifiers, name) do
    Enum.find(modifiers.list, fn t -> t.name == name end)
  end
end
