require("lib/units/cameras/ScopeCamera")
MenuSceneManager = MenuSceneManager or class()

local orig_setup_camera = MenuSceneManager.setup_camera
function MenuSceneManager:setup_camera()
	orig_setup_camera(self)

	self._scope_camera = ScopeCamera:new(self._camera_object)
end

function MenuSceneManager:link_scope(camera_object, screen_object, material, texture_channel, zoom, display_gui)
	self._scope_camera:link_scope(camera_object, screen_object, material, texture_channel, zoom, display_gui)
end

function MenuSceneManager:unlink_scope()
	self._scope_camera:unlink_scope()
end

local orig_update = MenuSceneManager.update
function MenuSceneManager:update(t, dt)
	orig_update(self, t, dt)

	if self._scope_camera then
		self._scope_camera:update(t, dt)
	end
end