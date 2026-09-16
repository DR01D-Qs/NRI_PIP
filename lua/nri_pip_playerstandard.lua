function PlayerStandard:get_zoom_fov(stance_data)
	local fov = stance_data and stance_data.FOV or 75
	local fov_multiplier = self._setting_fov_multiplier

	if self._state_data.in_steelsight then
		fov = tweak_data.weapon.stats.zoom[1]
		fov_multiplier = 1 + (fov_multiplier - 1) / 2
	end

	return fov * fov_multiplier
end