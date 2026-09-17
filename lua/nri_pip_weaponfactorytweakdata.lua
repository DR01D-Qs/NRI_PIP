Hooks:PostHook( WeaponFactoryTweakData, "init", "nri_pip_WeaponFactoryTweakData:init", function(self)
	--wepfactory loads before menumanager, so the mod options has to be loaded here separately
	local temp_settings = {}
	local file = io.open( SavePath .. "NRI_PIP_Savefile.txt", "r" )
	if file then
		temp_settings = json.decode( file:read("*all") )
		file:close()
	end

	--de-pip-ify combat sight
	if temp_settings.nri_pip_o_cs==false then
		self.parts.wpn_fps_upg_o_cs.camera = nil
		self.parts.wpn_fps_upg_o_cs.visibility = nil
	end



	--pip-ify sights forgotten by ovk
	local ovk_pls = { "wpn_fps_upg_o_poe", "wpn_fps_upg_o_hamr", "wpn_fps_upg_o_atibal" }
	for i, k in pairs(ovk_pls) do
		self.parts[k].visibility = deep_clone(self.parts.wpn_fps_upg_o_specter.visibility)
		self.parts[k].camera = deep_clone(self.parts.wpn_fps_upg_o_specter.camera)
		self.parts[k].camera.fov = 11
	end



	--enable pip objects for sights that have it
	for i, k in pairs(self.parts) do
		if k.camera and k.visibility then
			k.visibility[1].condition = function () return not managers.menu_scene end

			--disable steelsight_swap for pip sights
			if k.steelsight_visible==false and k.adds then
				k.steelsight_visible = nil

				for u, j in pairs(k.adds) do
					if string.find(j, "_steelsight", 1, true) and self.parts[j] and self.parts[j].steelsight_visible then
						table.remove(k.adds, u)
						break
					end
				end
			end
		end
	end



	--singular manual stance adjustments
	for i, k in pairs(self.parts.wpn_fps_upg_o_box.stance_mod) do
		k.translation = Vector3(k.translation.x, k.translation.y, k.translation.z-0.35)
	end
	self.parts.wpn_fps_upg_o_shortdot_vanilla.stance_mod.wpn_fps_snp_awp = { translation = Vector3(0, 0, 0.05) }
	self.parts.wpn_fps_upg_winchester_o_classic.stance_mod.wpn_fps_snp_winchester.translation = Vector3(0, -2, -1.69)
	self.parts.wpn_fps_pis_c96_sight.stance_mod.wpn_fps_pis_c96.translation = Vector3(-3.41, 0, 0.93)
	self.parts.wpn_fps_pis_c96_sight.camera.fov = 13

	--de-y-ing stance_mods of sniper sights so they don't drill through your head
	self.nri_pip_snoptics = {
		"wpn_fps_upg_o_shortdot",
		"wpn_fps_upg_o_shortdot_vanilla",
		"wpn_fps_upg_o_leupold",
		"wpn_fps_upg_o_box",
		"wpn_fps_upg_o_schmidt",
		"wpn_fps_upg_o_schmidt_magnified",
		"wpn_fps_upg_o_northtac",
	}
	for i, k in pairs(self.nri_pip_snoptics) do
		if self.parts[k] and self.parts[k].stance_mod then
			for u, j in pairs(self.parts[k].stance_mod) do
				if j.translation then j.translation = Vector3(j.translation.x, 0, j.translation.z) end
			end
		end
	end

	--y-adjusting broken stance_mods of sniper rifles
	self.nri_pip_trns_adjusts = {
		wpn_fps_snp_m95 = 15,
		wpn_fps_snp_mosin = -6,
		wpn_fps_snp_awp = 28,
		wpn_fps_snp_siltstone = 10,
		wpn_fps_snp_victor = 3,
		wpn_fps_snp_scout = -8,
	}
	for i, k in pairs(self.parts) do
		if k.stance_mod then
			for u, j in pairs(self.nri_pip_trns_adjusts) do
				local trns = k.stance_mod[u] and k.stance_mod[u].translation
				if trns then k.stance_mod[u].translation = Vector3(trns.x, j, trns.z) end
			end

			--x-adjusting awp while we're here (vanilla poopie)
			local awp_trns = k.stance_mod.wpn_fps_snp_awp and k.stance_mod.wpn_fps_snp_awp.translation
			if awp_trns then k.stance_mod.wpn_fps_snp_awp.translation = awp_trns + Vector3(0.05, 0, 0) end
		end
	end
end)