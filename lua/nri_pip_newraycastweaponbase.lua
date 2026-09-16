local orig_zoom = RaycastWeaponBase.zoom
function RaycastWeaponBase:zoom()
	if NRI_PIP.settings and NRI_PIP.settings.nri_pip_fov_based==false then
		return tweak_data.weapon.stats.zoom[1]
	end

	return self._zoom
end