---On selection start: play a sound if the player is holding one of our tools.
---
---@param event EventData.CustomInputEvent
local function on_select_start(event)
  local player = game.get_player(event.player_index)
  if player and player.cursor_stack and player.cursor_stack.valid_for_read and player.cursor_stack.name == "wire-tools-isolator" then
    player.play_sound({
      path = "utility/deconstruction_selection_started",
      override_sound_type = "gui-effect",
    })
  end
end
local select_start_events = {
  "wire-tools-select-start",
  "wire-tools-alt-select-start",
  "wire-tools-reverse-select-start",
  "wire-tools-alt-reverse-select-start"
}
script.on_event(select_start_events, on_select_start)


---On selection end: perform the action of our tool.
---
---@param event EventData.on_player_selected_area
local function on_select_end(event)
  if event.item ~= "wire-tools-isolator" then return end

  local inside = {}
  for _, entity in pairs(event.entities) do
    inside[entity.unit_number] = true
  end

  local disconnect_occurred = false
  for _, entity in pairs(event.entities) do
    if entity.valid then
      for _, connection in pairs(entity.copper_connection_definitions) do
        if connection.source_wire_connector == defines.wire_connection_id.electric_pole and
            connection.target_wire_connector == defines.wire_connection_id.electric_pole and
            connection.target_entity.valid and
            connection.target_entity.type == "electric-pole" and
            inside[connection.target_entity.unit_number] == nil
        then
          entity.disconnect_neighbour(connection.target_entity)
          disconnect_occurred = true
        end
      end
    end
  end

  local player = game.get_player(event.player_index)
  if player then
    if disconnect_occurred then
      player.play_sound({
        path = "utility/wire_pickup",
        override_sound_type = "gui-effect",
      })
    else
      player.play_sound({
        path = "utility/cancel_deconstruction_selection_ended",
        override_sound_type = "gui-effect",
      })
    end
  end
end
local es = defines.events
local select_end_events = {
  es.on_player_selected_area,
  es.on_player_alt_selected_area,
  es.on_player_reverse_selected_area,
  es.on_player_alt_reverse_selected_area
}
script.on_event(select_end_events, on_select_end)
