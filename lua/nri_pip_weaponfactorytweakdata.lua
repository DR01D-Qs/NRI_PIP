Hooks:PostHook( WeaponFactoryTweakData, "init", "nri_pip_WeaponFactoryTweakData:init", function(self)
	local ovk_pls = {
		"wpn_fps_upg_o_poe",
		"wpn_fps_upg_o_hamr",
		"wpn_fps_upg_o_atibal",
	}
	for i, k in pairs(ovk_pls) do
		self.parts[k].visibility = deep_clone(self.parts.wpn_fps_upg_o_specter.visibility)
		self.parts[k].camera = deep_clone(self.parts.wpn_fps_upg_o_specter.camera)
		self.parts[k].camera.fov = 11
	end

	for i, k in pairs(self.parts) do
		if k.camera and k.visibility then
			k.visibility[1].condition = function ()
				return not managers.menu_scene
			end

			if k.steelsight_visible==false and k.adds then
				k.steelsight_visible = nil

				for u, j in pairs(k.adds) do
					if string.find(j, "_steelsight", 1, true) and self.parts[j] and self.parts[j].steelsight_visible then
						table.remove(k.adds, u)
						break
					end
				end
			end

			if k.stance_mod then
				for u, j in pairs(k.stance_mod) do
					j.translation = Vector3(j.translation.x, 0, j.translation.z)
				end
			end
		end
	end

	for i, k in pairs(self.parts.wpn_fps_upg_o_box.stance_mod) do
		k.translation = Vector3(k.translation.x, k.translation.y, k.translation.z-0.35)
	end
end)