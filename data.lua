---@param name string
---@param order string
---@param key_sequence string
---@return data.SelectionToolPrototype, data.CustomInputPrototype, data.ShortcutPrototype
local function create_selection_tool_prototypes(name, order, key_sequence)
  ---@type SelectionModeFlags
  local selection_mode = { "buildable-type", "same-force", "entity-ghost" }
  ---@type Color
  local selection_color = { r = 0.72, g = 0.45, b = 0.2, a = 1 }
  ---@type data.CursorBoxType
  local selection_cursor_box_type = "electricity"
  ---@type (string)[]
  local entity_type_filters = { "electric-pole" }

  ---@type data.SelectionToolPrototype
  local item = {
    type = "selection-tool",
    name = name,
    order = order,

    stack_size = 1,
    draw_label_for_cursor_render = true,
    subgroup = "tool",
    flags = { "only-in-cursor", "spawnable", "hidden", "not-stackable" },

    selection_mode = selection_mode,
    selection_color = selection_color,
    selection_cursor_box_type = selection_cursor_box_type,
    entity_type_filters = entity_type_filters,

    -- Alt mode: same as normal mode
    alt_selection_mode = selection_mode,
    alt_selection_color = selection_color,
    alt_selection_cursor_box_type = selection_cursor_box_type,
    alt_entity_type_filters = entity_type_filters,

    -- Reverse mode: same as normal mode
    reverse_selection_mode = selection_mode,
    reverse_selection_color = selection_color,
    reverse_selection_cursor_box_type = selection_cursor_box_type,
    reverse_entity_type_filters = entity_type_filters,

    -- Alt reverse mode: same as normal mode
    alt_reverse_selection_mode = selection_mode,
    alt_reverse_selection_color = selection_color,
    alt_reverse_selection_cursor_box_type = selection_cursor_box_type,
    alt_reverse_entity_type_filters = entity_type_filters,
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
    icon = {
      filename = "__base__/graphics/icons/shortcut-toolbar/mip/paste-x32.png",
      priority = "extra-high-no-scale",
      size = 32,
      scale = 0.5,
      mipmap_count = 2,
      flags = { "gui-icon" },
    },
  }

  return item, input, shortcut
end


-- Isolator
do
  local item, input, shortcut = create_selection_tool_prototypes(
    "wire-tools-isolator",
    "wire-tools-a",
    "ALT + G"
  )
  item.icons = {
    {
      icon = "__WireTools__/graphics/icons/cut-tool.png",
    },
    {
      icon = "__base__/graphics/icons/copper-cable.png",
      scale = 0.3,
      shift = { 0, -6 },
    },
  }
  item.icon_size = 64
  item.icon_mipmaps = 4
  shortcut.icon = {
    filename = "__base__/graphics/icons/shortcut-toolbar/mip/new-deconstruction-planner-x32-white.png",
    priority = "extra-high-no-scale",
    size = 32,
    scale = 0.5,
    mipmap_count = 2,
    flags = { "gui-icon" },
    tint = { r = 0.1, g = 0.1, b = 0.1 },
  }
  shortcut.small_icon = {
    filename = "__base__/graphics/icons/shortcut-toolbar/mip/new-deconstruction-planner-x24-white.png",
    priority = "extra-high-no-scale",
    size = 24,
    scale = 0.5,
    mipmap_count = 2,
    flags = { "gui-icon" },
    tint = { r = 0.1, g = 0.1, b = 0.1 },
  }
  shortcut.disabled_small_icon = {
    filename = "__base__/graphics/icons/shortcut-toolbar/mip/new-deconstruction-planner-x24-white.png",
    priority = "extra-high-no-scale",
    size = 24,
    scale = 0.5,
    mipmap_count = 2,
    flags = { "gui-icon" },
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
    "ALT + C"
  )
  item.selection_color = { r = 1.0, }
  item.reverse_selection_color = item.selection_color
  item.alt_selection_color = { g = 1.0, }
  item.alt_reverse_selection_color = item.alt_selection_color

  item.selection_count_button_color = { r = 0.4, g = 0.4, b = 1.0 }
  item.alt_selection_count_button_color = item.selection_count_button_color
  item.reverse_selection_count_button_color = { r = 1.0, g = 1.0 }
  item.alt_reverse_selection_count_button_color = item.reverse_selection_count_button_color

  item.icons = {
    {
      icon = "__WireTools__/graphics/icons/tool.png",
      tint = { r = 0.1, g = 0.1, b = 0.1, },
    },
    {
      icon = "__WireTools__/graphics/icons/wire.png",
      scale = 0.5,
    },
  }
  item.icon_size = 64
  item.icon_mipmaps = 4
  shortcut.icon = {
    filename = "__WireTools__/graphics/icons/wire.png",
    priority = "extra-high-no-scale",
    size = 64,
    scale = 0.5,
    mipmap_count = 4,
    flags = { "gui-icon" },
    tint = { r = 0.5, g = 0.5, b = 0.5 },
  }
  data:extend {
    item,
    input,
    shortcut,
  }
end


-- Selection sounds

---@param name string
---@param linked_game_control data.LinkedGameControl
---@return data.CustomInputPrototype
local function create_select_custom_input(name, linked_game_control)
  ---@type data.CustomInputPrototype
  return {
    type = "custom-input",
    name = name,
    key_sequence = "",
    linked_game_control = linked_game_control,
    consuming = "none",
    action = "lua",
  }
end

data:extend {
  create_select_custom_input("wire-tools-select-start", "select-for-blueprint"),
  create_select_custom_input("wire-tools-alt-select-start", "select-for-cancel-deconstruct"),
  create_select_custom_input("wire-tools-reverse-select-start", "reverse-select"),
  create_select_custom_input("wire-tools-alt-reverse-select-start", "alt-reverse-select"),
}
