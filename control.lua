---Isolator, on selection end.
---@param event EventData.on_player_selected_area | EventData.on_player_alt_selected_area | EventData.on_player_reverse_selected_area | EventData.on_player_alt_reverse_selected_area
local function isolator_on_select_end(event)
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

---Circuit connector, on selection end.
---@param event EventData.on_player_selected_area | EventData.on_player_alt_selected_area | EventData.on_player_reverse_selected_area | EventData.on_player_alt_reverse_selected_area
---@param alt boolean
---@param reverse boolean
local function circuit_connector_on_select_end(event, alt, reverse)
  local wire, wire_name
  if alt then
    wire = defines.wire_type.green
    wire_name = "green"
  else
    wire = defines.wire_type.red
    wire_name = "red"
  end

  local inside = {}
  for _, entity in pairs(event.entities) do
    inside[entity.unit_number] = true
  end

  local modified = false
  for _, entity in pairs(event.entities) do
    if entity.valid and entity.circuit_connected_entities ~= nil then
      for _, connection in pairs(entity.copper_connection_definitions) do
        if connection.source_wire_connector == defines.wire_connection_id.electric_pole and
            connection.target_wire_connector == defines.wire_connection_id.electric_pole and
            connection.target_entity.valid and
            connection.target_entity.type == "electric-pole" and
            inside[connection.target_entity.unit_number] ~= nil
        then
          local connected = false
          for _, target_entity in ipairs(entity.circuit_connected_entities[wire_name]) do
            if connection.target_entity == target_entity then
              connected = true
            end
          end

          local target = {
            wire = wire,
            target_entity = connection.target_entity
          }
          if reverse and connected then
            entity.disconnect_neighbour(target)
            modified = true
          elseif not reverse and not connected then
            modified = entity.connect_neighbour(target) or modified
          end
        end
      end
    end
  end

  local player = game.get_player(event.player_index)
  if player then
    local path = "utility/upgrade_selection_ended"
    if modified and reverse then
      path = "utility/wire_pickup"
    elseif modified and not reverse then
      path = "utility/wire_connect_pole"
    end
    player.play_sound({
      path = path,
      override_sound_type = "gui-effect",
    })
  end
end


--
-- Tool names
--

local isolator = "wire-tools-isolator"
local circuit_connector = "wire-tools-circuit-connector"


--
-- Selection start
--
do
  local normal = "wire-tools-select-start"
  local alt = "wire-tools-alt-select-start"
  local reverse = "wire-tools-reverse-select-start"
  local alt_reverse = "wire-tools-alt-reverse-select-start"

  ---Checks whether name is one of our tools
  ---@param name string
  ---@return boolean
  local function is_our_tool(name)
    return name:sub(1, #"wire-tools") == "wire-tools"
  end

  ---On selection start: play a sound if the player is holding one of our tools.
  ---@param event EventData.CustomInputEvent
  local function on_select_start(event)
    local player = game.get_player(event.player_index)
    if player and player.cursor_stack and player.cursor_stack.valid_for_read then
      local item = player.cursor_stack.name
      local path = nil
      if item == isolator then
        -- Isolator always deconstructs
        path = "utility/deconstruction_selection_started"
      elseif is_our_tool(item) then
        if event.name == reverse or event.name == alt_reverse then
          path = "utility/deconstruction_selection_started"
        else
          path = "utility/upgrade_selection_started"
        end
      end

      if path ~= nil then
        player.play_sound({
          path = path,
          override_sound_type = "gui-effect",
        })
      end
    end
  end

  script.on_event({ normal, alt, reverse, alt_reverse }, on_select_start)
end

--
-- Selection end
--
do
  ---On selection end: perform the action of our tool.
  ---@param event EventData.on_player_selected_area
  local function on_select_end(event)
    local item = event.item
    if item == isolator then
      isolator_on_select_end(event)
    elseif item == circuit_connector then
      circuit_connector_on_select_end(event, false, false)
    end
  end
  ---On alternative selection end: perform the action of our tool.
  ---@param event EventData.on_player_alt_selected_area
  local function on_alt_select_end(event)
    local item = event.item
    if item == isolator then
      isolator_on_select_end(event)
    elseif item == circuit_connector then
      circuit_connector_on_select_end(event, true, false)
    end
  end
  ---On reverse selection end: perform the action of our tool.
  ---@param event EventData.on_player_reverse_selected_area
  local function on_reverse_select_end(event)
    local item = event.item
    if item == isolator then
      isolator_on_select_end(event)
    elseif item == circuit_connector then
      circuit_connector_on_select_end(event, false, true)
    end
  end
  ---On alternative reverse selection end: perform the action of our tool.
  ---@param event EventData.on_player_alt_reverse_selected_area
  local function on_alt_reverse_select_end(event)
    local item = event.item
    if item == isolator then
      isolator_on_select_end(event)
    elseif item == circuit_connector then
      circuit_connector_on_select_end(event, true, true)
    end
  end

  local es = defines.events
  script.on_event(es.on_player_selected_area, on_select_end)
  script.on_event(es.on_player_alt_selected_area, on_alt_select_end)
  script.on_event(es.on_player_reverse_selected_area, on_reverse_select_end)
  script.on_event(es.on_player_alt_reverse_selected_area, on_alt_reverse_select_end)
end
