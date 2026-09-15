Hooks:PostHook( WeaponFactoryTweakData, "init", "nri_pip_WeaponFactoryTweakData:init", function(self)
	for i, k in pairs(self.parts) do
		if k.camera and k.visibility then
			k.visibility[1].condition = function ()
				return not managers.menu_scene
			end
		end
	end

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
end)

function WeaponFactoryTweakData:_init_steelsight_units()
end