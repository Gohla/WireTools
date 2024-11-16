---@type data.SelectionModeData
local default_select = {
  mode = { "buildable-type", "same-force", "entity-ghost" },
  border_color = { r = 1, g = 1, b = 1, a = 1 },
  cursor_box_type = "electricity",
  entity_type_filters = { "electric-pole" },
}

---@param name string
---@param order string
---@param key_sequence string
---@return data.SelectionToolPrototype, data.CustomInputPrototype, data.ShortcutPrototype
local function create_selection_tool_prototypes(name, order, key_sequence)
  ---@type data.SelectionToolPrototype
  local item = {
    type = "selection-tool",
    name = name,
    order = order,
    hidden = true,
    hidden_in_factoriopedia = true,

    stack_size = 1,
    draw_label_for_cursor_render = true,
    subgroup = "tool",
    flags = { "only-in-cursor", "spawnable", "not-stackable" },

    select = table.deepcopy(default_select),
    alt_select = table.deepcopy(default_select),
  }

  ---@type data.CustomInputPrototype
  local input = {
    type = "custom-input",
    name = name,
    order = order,
    localised_name = { "controls-name." .. name, { "item-name." .. name } },
    localised_description = { "controls-description." .. name, { "item-description." .. name } },

    key_sequence = key_sequence,
    consuming = "game-only",
    action = "spawn-item",
    item_to_spawn = name,
  }

  ---@type data.ShortcutPrototype
  local shortcut = {
    type = "shortcut",
    name = name,
    order = order,
    localised_name = { "shortcut." .. name, { "item-name." .. name } },
    localised_description = { "shortcut-description." .. name, { "item-description." .. name } },

    action = "spawn-item",
    item_to_spawn = name,
    associated_control_input = name,
  }

  return item, input, shortcut
end


-- Isolator
do
  local item, input, shortcut = create_selection_tool_prototypes(
    "wire-tools-isolator",
    "wire-tools-a",
    "SHIFT + G"
  )

  item.select.border_color = { r = 0.72, g = 0.45, b = 0.2, a = 1 }
  item.select.started_sound = { filename = "__core__/sound/deconstruct-select-start.ogg" }
  item.select.ended_sound = { filename = "__core__/sound/deconstruct-select-end.ogg" }
  item.select.play_ended_sound_when_nothing_selected = true

  -- Alt select is same as normal select.
  item.alt_select = item.select

  item.icons = {
    {
      icon = "__WireTools__/graphics/icons/cut-tool.png",
      icon_size = 64,
    },
    {
      icon = "__WireTools__/graphics/icons/copper-cable.png",
      icon_size = 64,
      shift = { 0, -6 },
      scale = 0.3,
    },
  }
  shortcut.icons = {
    {
      icon = "__WireTools__/graphics/icons/new-deconstruction-planner-x56.png",
      icon_size = 56,
      scale = 0.5,
      tint = { r = 0.1, g = 0.1, b = 0.1 },
    }
  }
  shortcut.small_icons = {
    {
      icon = "__WireTools__/graphics/icons/new-deconstruction-planner-x24.png",
      icon_size = 24,
      scale = 0.5,
      tint = { r = 0.1, g = 0.1, b = 0.1 },
    }
  }

  data:extend {
    item,
    input,
    shortcut,
  }
end


-- Circuit wire connector
do
  local item, input, shortcut = create_selection_tool_prototypes(
    "wire-tools-circuit-connector",
    "wire-tools-b",
    "SHIFT + C"
  )

  item.reverse_select = table.deepcopy(default_select)
  item.alt_reverse_select = table.deepcopy(default_select)

  -- Select does red wires: color border red
  item.select.border_color = { r = 1.0, }
  item.reverse_select.border_color = item.select.border_color
  -- Alt select does green wires: color borders green
  item.alt_select.border_color = { g = 1.0, }
  item.alt_reverse_select.border_color = item.alt_select.border_color

  -- Select connects wires: color item text blue, upgrade sound
  item.select.count_button_color = { r = 0.4, g = 0.4, b = 1.0 }
  item.select.started_sound = { filename = "__core__/sound/upgrade-select-start.ogg" }
  item.select.ended_sound = { filename = "__core__/sound/upgrade-select-end.ogg" }
  item.select.play_ended_sound_when_nothing_selected = true
  item.alt_select.count_button_color = item.select.count_button_color
  item.alt_select.started_sound = item.select.started_sound
  item.alt_select.ended_sound = item.select.ended_sound
  item.alt_select.play_ended_sound_when_nothing_selected = item.select.play_ended_sound_when_nothing_selected
  --- Reverse select disconnects wires: color item text yellow, deconstruct sound
  item.reverse_select.count_button_color = { r = 1.0, g = 1.0 }
  item.reverse_select.started_sound = { filename = "__core__/sound/deconstruct-select-start.ogg" }
  item.reverse_select.ended_sound = { filename = "__core__/sound/deconstruct-select-end.ogg" }
  item.reverse_select.play_ended_sound_when_nothing_selected = true
  item.alt_reverse_select.count_button_color = item.select.count_button_color
  item.alt_reverse_select.started_sound = item.select.started_sound
  item.alt_reverse_select.ended_sound = item.select.ended_sound
  item.alt_reverse_select.play_ended_sound_when_nothing_selected = item.select.play_ended_sound_when_nothing_selected

  item.icons = {
    {
      icon = "__WireTools__/graphics/icons/tool.png",
      icon_size = 64,
      tint = { r = 0.1, g = 0.1, b = 0.1, },
    },
    {
      icon = "__WireTools__/graphics/icons/wire.png",
      icon_size = 64,
      scale = 0.5,
    },
  }
  shortcut.icons = {
    {
      icon = "__WireTools__/graphics/icons/wire.png",
      icon_size = 64,
      scale = 0.5,
      tint = { r = 0.5, g = 0.5, b = 0.5 },
    }
  }
  shortcut.small_icons = {
    {
      icon = "__WireTools__/graphics/icons/wire.png",
      icon_size = 64,
      scale = 0.25,
      tint = { r = 0.5, g = 0.5, b = 0.5 },
    }
  }

  data:extend {
    item,
    input,
    shortcut,
  }
end
