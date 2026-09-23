function NewRaycastWeaponBase:set_scope_enabled(enabled)
	if self:is_npc() then
		return
	end

	if not managers.menu_scene and not self._assembly_complete then
		self._didnt_assemble = true
		return
	end

	if self._scope_camera_configuration then
		local user_unit = managers.player:player_unit()
		local camera = nil

		if not user_unit then
			camera = _G.IS_VR and managers.menu:player() or managers.menu_scene or camera
		else
			camera = user_unit:camera()
		end

		if camera then
			if enabled then
				local config = self._scope_camera_configuration
				local zoom_mul = NRI_PIP.settings.nri_pip_zoom_mul or 1

				camera:link_scope(config.a_camera, config.a_screen, config.material, config.channel, config.fov / zoom_mul, config.display_gui)
			else
				camera:unlink_scope()
			end
		end
	end
end

function NewRaycastWeaponBase:configure_scope()
	if self:is_npc() then
		return
	end

	local parts_tweak = tweak_data.weapon.factory.parts

	for part_id, part in pairs(self._parts) do
		if parts_tweak[part_id] and parts_tweak[part_id].camera then
			local camera = parts_tweak[part_id] and parts_tweak[part_id].camera

			if camera then
				local config = {
					a_camera = part.unit:get_object(Idstring(camera.a_camera)),
					a_screen = part.unit:get_object(Idstring(camera.a_screen))
				}
				local material = nil
				local material_name = Idstring(camera.material)
				local material_config = part.unit:get_objects_by_type(Idstring("material"))

				for _, _material in ipairs(material_config) do
					if _material:name() == material_name then
						material = _material

						break
					end
				end

				if not material then return end

				part.steelsight_visible = nil
				if parts_tweak[part_id].adds then
					for u, j in pairs(parts_tweak[part_id].adds) do
						if self._parts[j] and (parts_tweak[j] and parts_tweak[j].type=="sight_swap") and self._parts[j].steelsight_visible then
							self._parts[j] = nil
						end
					end
				end

				if part.unit:digital_gui() then
					local obj = part.unit:get_object(Idstring(part.unit:digital_gui()._gui_object))
					config.display_gui = { obj = obj }
					config.display_gui.offset = parts_tweak[part_id].display_gui and parts_tweak[part_id].display_gui.offset or Vector3(0,0,0)
				end

				config.material = material
				config.channel = Idstring(camera.channel)
				local zoom_mul = NRI_PIP.settings.nri_pip_zoom_mul or 1
				config.fov = (camera.fov or 20) / zoom_mul
				self._scope_camera_configuration = config

				if self._didnt_assemble then self:set_scope_enabled(true) end

				break
			end
		end
	end
end