defmodule Character.Sheet do
  @foreground "#3c3c3c"
  @red "#852F1C"
  @grey "#E0CBC6"

  def html_character_sheet(character = %Character.Character{}, traits = %Trait.Traits{}, modifiers = %Trait.Modifiers{}) do
    Sneeze.render([
      :html,
      [
        :body,
        %{
          style:
            style(%{
              "font-family" => "Helvetica",
              "font-size" => "20pt",
              "color" => @foreground
            })
        },
        render_header(character.name),
        render_abilities_and_weaknesses(character),
        [:br, %{}, ""],
        render_attacks(character, traits, modifiers)
      ]
    ])
  end

  def pdf_character_sheet(character = %Character.Character{}, traits = %Trait.Traits{}, modifiers = %Trait.Modifiers{}) do
    html = html_character_sheet(character, traits, modifiers)
    {:ok, filename} = PdfGenerator.generate(html, page_size: "Letter", shell_params: ["--dpi", "300"])

    File.rename(filename, "#{character.name}.pdf")
  end

  defp style(style_map) do
    style_map
    |> Enum.map(fn {key, value} ->
      "#{key}: #{value}"
    end)
    |> Enum.join(";")
  end

  defp render_header(character_name) do
    [
      :div,
      %{},
      [
        :table,
        %{},
        [
          :tr,
          %{},
          [
            [
              :td,
              %{"vertical-align" => "center"},
              [
                :p,
                header_style(),
                "OVA"
              ]
            ],
            [
              :td,
              %{},
              [
                :table,
                name_table_style(),
                [
                  [
                    :tr,
                    %{},
                    [
                      [:td, name_cell_style(), character_name],
                      [:td, name_cell_style(), ""]
                    ]
                  ],
                  [
                    :tr,
                    %{},
                    [
                      [:td, %{}, "Character Name"],
                      [:td, %{}, "Player name"]
                    ]
                  ]
                ]
              ]
            ]
          ]
        ]
      ]
    ]
  end

  defp header_style() do
    %{
      style: style(%{"font-size" => "52pt", "font-style" => "oblique", color: @red})
    }
  end

  defp name_table_style() do
    %{
      style: style(%{
        "border-radius" => "10px",
        "text-align" => "left",
        background: @red,
        color: "white",
        padding: "5px"
      })
    }
  end

  defp name_cell_style() do
    %{
      style: style(%{
        "text-align" => "left",
        background: "white",
        border: "5px solid #{@red}",
        color: "black",
        padding: "2px",
        width: "8cm"
      })
    }
  end

  defp render_abilities_and_weaknesses(character = %Character.Character{}) do
    [
      :table,
      %{style: style(%{"border-radius" => "7px", background: @grey})},
      [
        :tr,
        %{},
        [
          [
            :td,
            %{style: style(%{"vertical-align" => "top"})},
            render_abilities(character)
          ],
          [
            :td,
            %{style: style(%{"vertical-align" => "top"})},
            render_weaknesses(character)
          ]
        ]
      ]
    ]
  end

  defp render_abilities(character = %Character.Character{}) do
    [
      :table,
      %{},
      [
        render_ability_title("ABILITIES") | Enum.map(character.abilities, fn a -> render_ability(a) end)
      ]
    ]
  end

  defp render_weaknesses(character = %Character.Character{}) do
    range = 0..(max_abilities(character)-1)
    [
      :table,
      %{},
      [
        render_ability_title("WEAKNESSES") | Enum.map(range, fn i -> render_ability_line(character.weaknesses, i) end)
      ]
    ]
  end

  defp render_ability_line(abilities, i) when i < length(abilities) do
    render_ability(Enum.at(abilities, i))
  end

  defp render_ability_line(abilities, i) when i >= length(abilities) do
    render_ability("", "_")
  end

  defp max_abilities(character = %Character.Character{}), do: max(length(character.abilities), length(character.weaknesses))

  defp render_ability_title(title), do: [:tr, %{}, [:td, %{colspan: "2", style: style(%{"font-weight" => "bold", color: "black"})}, title]]

  defp render_ability(ability = %Character.Ability{}), do: render_ability(ability.name, ability.value)

  defp render_ability(name, value) do
    [
      :tr,
      %{},
      [
        [:td, ability_value_style(), value],
        [:td, ability_name_style(), name]
      ]
    ]
  end


  defp ability_value_style() do
    %{style: style(
      %{
        "border-radius" => "5px",
        "text-align" => "right",
        background: "white",
        border: "2px",
        width: "1cm"
      })}
  end

  defp ability_name_style() do
    %{style: style(
      %{
        "border-radius" => "5px",
        "text-align" => "left",
        background: "white",
        border: "2px",
        width: "9cm"
      })}
  end

  defp render_attacks(character = %Character.Character{}, traits = %Trait.Traits{}, modifiers = %Trait.Modifiers{}) do
    attack_rows = Enum.map(character.attacks, fn a -> render_attack(character, a, traits, modifiers) end)
    [
      :table,
      %{style: style(%{"border-radius" => "7px", width: "21cm", background: @red})},
      [
         render_combat_header() | [
           render_attack_header() | Enum.concat(attack_rows, render_defense_health_endurance(character, traits, modifiers)) ]
      ]
    ]
  end

  defp render_combat_header() do
    [:tr, %{},
      [
        :td,
        %{style: style(%{"font-weight" => "bold", "font-size" => "28", color: "white"})},
        "Combat Stats"
      ]
    ]
  end

  defp render_defense_health_endurance(character = %Character.Character{}, traits = %Trait.Traits{}, modifiers = %Trait.Modifiers{}) do
    health = Character.Character.health(character, traits)
    defense = Character.Character.defense(character, traits)
    endurance = Character.Character.endurance(character, traits)
    tv = Character.Character.threat_value(character, traits, modifiers)
    [
      :tr,
      %{},
      [
        [:td, %{}, render_statistic("Defense", defense)],
        [:td, %{}, render_statistic("Health", health)],
        [:td, %{}, render_statistic("Endurance", endurance)],
        [:td, %{}, render_statistic("TV", tv)]
      ]
    ]
  end

  defp render_statistic(name, value) do
    [
      :table,
      %{width: "100%"},
      [
        [
          :tr, combat_stat_style(), [[:td, %{}, name]]
        ],
        [
          :tr, combat_stat_style(), [[:td, %{}, value]]
        ]
      ]
    ]
  end

  defp combat_stat_style() do
    %{style: style(
      %{
        "border-radius" => "5px",
        "text-align" => "left",
        background: "white",
        border: "2px"
      })}
  end


  defp render_attack(character = %Character.Character{}, attack = %Character.Attack{}, traits = %Trait.Traits{}, modifiers = %Trait.Modifiers{}) do
    {attack, attack_dice, dx, endurance} = Character.Attack.details(character, attack, traits, modifiers)
    [
      [
        :tr,
        %{},
        [
          [:td, combat_stat_style(), Character.Attack.description(attack, modifiers)],
          [:td, combat_stat_style(), attack_dice],
          [:td, combat_stat_style(), dx],
          [:td, combat_stat_style(), endurance]
        ]
      ]
    ]
  end

  defp render_attack_header() do
    [
      [
        :tr,
        %{},
        [
          [:td, combat_stat_header_style(), "Description"],
          [:td, combat_stat_header_style(), "Roll"],
          [:td, combat_stat_header_style(), "DX"],
          [:td, combat_stat_header_style(), "Endurance"]
        ]
      ]
    ]
  end

  defp combat_stat_header_style() do
    %{style: style(
      %{
        "font-weight" => "bold",
        "border-radius" => "5px",
        "text-align" => "left",
        background: "white",
        border: "2px"
      })}
  end

end
