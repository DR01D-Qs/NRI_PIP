require("lib/units/cameras/ScopeCamera")
PlayerCamera = PlayerCamera or class()

Hooks:PostHook(PlayerCamera, "init", "nri_pip_PlayerCamera:init", function(self, unit)
	self._scope_camera = ScopeCamera:new(self)
end)