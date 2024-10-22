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
      local connector = entity.get_wire_connector(defines.wire_connector_id.pole_copper, false)
      if connector.valid then
        for _, connection in pairs(connector.real_connections) do
          if connection.target.valid and
              connection.target.wire_connector_id == defines.wire_connector_id.pole_copper and -- TODO: is this needed? Does the connector only deal with wires of its own type?
              connection.target.owner.valid and
              connection.target.owner.type == "electric-pole" and
              inside[connection.target.owner.unit_number] == nil -- Not inside selected area
          then
            connector.disconnect_from(connection.target)
            disconnect_occurred = true
          end
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
    end
  end
end

---Circuit connector, on selection end.
---@param event EventData.on_player_selected_area | EventData.on_player_alt_selected_area | EventData.on_player_reverse_selected_area | EventData.on_player_alt_reverse_selected_area
---@param alt boolean
---@param reverse boolean
local function circuit_connector_on_select_end(event, alt, reverse)
  local wire_connector_id
  if alt then
    wire_connector_id = defines.wire_connector_id.circuit_green
  else
    wire_connector_id = defines.wire_connector_id.circuit_red
  end

  local inside = {}
  for _, entity in pairs(event.entities) do
    inside[entity.unit_number] = true
  end


  -- For each entity, for each copper wire connection of that entity within the selection, connect a circuit wire along that copper wire connection.
  local modified = false
  for _, entity in pairs(event.entities) do
    if entity.valid then
      local copper_connector = entity.get_wire_connector(defines.wire_connector_id.pole_copper, false)
      if copper_connector.valid then
        for _, copper_connection in pairs(copper_connector.connections) do
          if copper_connection.target.valid and
              copper_connection.target.wire_connector_id == defines.wire_connector_id.pole_copper and -- TODO: is this needed? Does the connector only deal with wires of its own type?
              copper_connection.target.owner.valid and
              copper_connection.target.owner.type == "electric-pole" and
              inside[copper_connection.target.owner.unit_number] ~= nil -- Only inside selected area
          then
            local circuit_connector = entity.get_wire_connector(wire_connector_id, true)
            local target_circuit_connector = copper_connection.target.owner.get_wire_connector(wire_connector_id, true)
            if circuit_connector.valid and target_circuit_connector.valid then
              if reverse then
                modified = circuit_connector.disconnect_from(target_circuit_connector) or modified
              else
                modified = circuit_connector.connect_to(target_circuit_connector) or modified
              end
            end
          end
        end
      end
    end
  end

  local player = game.get_player(event.player_index)
  if player then
    local path = nil
    if modified and reverse then
      path = "utility/wire_pickup"
    elseif modified and not reverse then
      path = "utility/wire_connect_pole"
    end
    if path ~= nil then
      player.play_sound({
        path = path,
        override_sound_type = "gui-effect",
      })
    end
  end
end


--
-- Selection end
--
do
  local isolator = "wire-tools-isolator"
  local circuit_connector = "wire-tools-circuit-connector"

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
