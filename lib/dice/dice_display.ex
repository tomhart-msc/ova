defmodule DiceDisplay do
    
    # Warning: These likely will display incorrectly in the Windows console.
    @faces %{1 => "⚀", 2 => "⚁", 3 => "⚂", 4 => "⚃", 5 => "⚄", 6 => "⚅"}

    def faces({a, b}) do
        String.duplicate(@faces[a], b)
    end

    def as_faces(map) do
        Enum.reduce(map, "", fn i, acc -> acc <> faces(i) end)
    end
end