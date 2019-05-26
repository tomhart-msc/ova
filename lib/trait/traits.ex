defmodule Trait.Traits do
  @moduledoc """
  This module defines a list of traits in OVA. A trait is an ability or weakness; the two are mechanically
  identical, but abilities have beneficial effects and weaknesses have harmful ones.
  """

  defstruct [:list]

  def fromAbilitiesAndWeaknesses(abilities, weaknesses) do
    %Trait.Traits{list: Enum.concat(abilities, weaknesses)}
  end

  # Given a list of traits, finds the trait with the given name if one exists.
  def byName(traits, name) when is_binary(name) do
    Enum.find(traits.list, fn t -> t.name == name end)
  end
end
