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
  name = "wire-tools-isolator",
  order = "z[wire-tools-isolator]",

  stack_size = 1,
  draw_label_for_cursor_render = true,
  subgroup = "tool",
  flags = { "only-in-cursor", "spawnable", "hidden", "not-stackable" },
  icons = {
    {
      icon = "__base__/graphics/icons/cut-paste-tool.png",
    },
    {
      icon = "__base__/graphics/icons/copper-cable.png",
      scale = 0.3,
      shift = { 0, -12 },
    },
  },
  icon_size = 64,
  icon_mipmaps = 4,

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
  name = "wire-tools-isolator",
  order = "w[wire-tools-isolator]",
  localised_name = { "controls-name.wire-tools-isolator", { "item-name.wire-tools-isolator" } },
  localised_description = { "controls-description.wire-tools-isolator", { "item-description.wire-tools-isolator" } },

  key_sequence = "ALT + G",
  consuming = "game-only",
  action = "spawn-item",
  item_to_spawn = "wire-tools-isolator",
}

---@type data.ShortcutPrototype
local shortcut = {
  type = "shortcut",
  name = "wire-tools-isolator",
  order = "w[wire-tools-isolator]",
  localised_name = { "shortcut.wire-tools-isolator", { "item-name.wire-tools-isolator" } },
  localised_description = { "shortcut-description.wire-tools-isolator", { "item-description.wire-tools-isolator" } },

  action = "spawn-item",
  item_to_spawn = "wire-tools-isolator",
  associated_control_input = "wire-tools-isolator",
  icon = {
    filename = "__base__/graphics/icons/shortcut-toolbar/mip/new-deconstruction-planner-x32-white.png",
    priority = "extra-high-no-scale",
    size = 32,
    scale = 0.5,
    mipmap_count = 2,
    flags = { "gui-icon" },
    tint = { r = 0.1, g = 0.1, b = 0.1 },
  },
  small_icon = {
    filename = "__base__/graphics/icons/shortcut-toolbar/mip/new-deconstruction-planner-x24-white.png",
    priority = "extra-high-no-scale",
    size = 24,
    scale = 0.5,
    mipmap_count = 2,
    flags = { "gui-icon" },
    tint = { r = 0.1, g = 0.1, b = 0.1 },
  },
  disabled_small_icon = {
    filename = "__base__/graphics/icons/shortcut-toolbar/mip/new-deconstruction-planner-x24-white.png",
    priority = "extra-high-no-scale",
    size = 24,
    scale = 0.5,
    mipmap_count = 2,
    flags = { "gui-icon" },
  }
}

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
  item,
  input,
  shortcut,
  create_select_custom_input("wire-tools-select-start", "select-for-blueprint"),
  create_select_custom_input("wire-tools-alt-select-start", "select-for-cancel-deconstruct"),
  create_select_custom_input("wire-tools-reverse-select-start", "reverse-select"),
  create_select_custom_input("wire-tools-alt-reverse-select-start", "alt-reverse-select"),
}
