require("lib/units/cameras/ScopeCamera")
PlayerCamera = PlayerCamera or class()

Hooks:PostHook(PlayerCamera, "init", "nri_pip_PlayerCamera:init", function(self, unit)
	self._scope_camera = self._scope_camera or ScopeCamera:new(self)
end)

function PlayerCamera:link_scope(camera_object, screen_object, material, texture_channel, zoom, display_gui)
	self._scope_camera:link_scope(camera_object, screen_object, material, texture_channel, zoom, display_gui)
end