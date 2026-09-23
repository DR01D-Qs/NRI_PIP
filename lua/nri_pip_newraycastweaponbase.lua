local orig_zoom = RaycastWeaponBase.zoom
function RaycastWeaponBase:zoom()
	if self._scope_camera_configuration and NRI_PIP.settings and NRI_PIP.settings.nri_pip_fov_based==false then
		return tweak_data.weapon.stats.zoom[1]
	end

	return self._zoom
end

local orig__check_reticle_obj = NewRaycastWeaponBase._check_reticle_obj
function NewRaycastWeaponBase:_check_reticle_obj()
	orig__check_reticle_obj(self)

	if self._scope_camera_configuration then self._reticle_obj = nil end
end