require("lib/utils/VRLoadingEnvironment")

VRViewport = VRViewport or class()
VRManagerPD2 = VRManagerPD2 or class()

VRManagerPD2.DISABLE_ADAPTIVE_QUALITY = false

function VRManagerPD2:init()
	print("[VRManagerPD2] init")

	if not PackageManager:loaded("packages/vr_base") then
		PackageManager:load("packages/vr_base")
	end

	if _G.IS_VR then VRManager:set_max_adaptive_levels(7) end

	self._adaptive_scale = {
		0.85,
		0.9,
		1,
		1.1,
		1.2,
		1.3
	}
	self._adaptive_scale_max = 1.4

	if _G.IS_VR then VRManager:set_present_post_processor(Idstring("core/shaders/render_to_backbuffer"), Idstring("stretch_copy"), "back_buffer") end

	self._is_default_hmd = true
	if _G.IS_VR then self._is_oculus = string.find(string.lower(VRManager:hmd_manufacturer()), "oculus") ~= nil end
	self._is_default_hmd = self._is_default_hmd and not self._is_oculus
	self._super_sample_scale = _G.IS_VR and VRManager:super_sample_scale() or 1
	self._viewports = {}
	self._default = {
		belt_height_ratio = 0.6,
		height = 140,
		keep_items_in_hand = false,
		autowarp_length = "long",
		weapon_precision_mode = true,
		belt_snap = 72,
		auto_reload = true,
		warp_zone_size = 0,
		belt_size = 96,
		fadeout_type = "fadeout_smooth",
		default_tablet_hand = "left",
		enable_dead_zone_warp = true,
		zipline_screen = true,
		rotate_player_angle = 45,
		collision_instant_teleport = false,
		default_weapon_hand = "right",
		arm_animation = false,
		movement_type = "warp",
		belt_distance = 10,
		grip_toggle = true,
		dead_zone_size = self._is_default_hmd and 50 or 35,
		belt_layout = {
			bag = {
				7,
				5
			},
			reload = {
				7,
				3
			},
			melee = {
				3,
				7
			},
			throwable = {
				4,
				4
			},
			deployable = {
				10,
				4
			},
			deployable_secondary = {
				12,
				4
			},
			weapon = {
				11,
				7
			}
		},
		belt_box_sizes = {
			bag = {
				2,
				1
			},
			reload = {
				2,
				1
			},
			melee = {
				2,
				2
			},
			deployable = {
				1,
				1
			},
			throwable = {
				1,
				1
			},
			deployable_secondary = {
				1,
				1
			},
			weapon = {
				2,
				2
			}
		},
		arm_length = tweak_data.vr.default_body_metrics.arm_length,
		head_to_shoulder = tweak_data.vr.default_body_metrics.head_to_shoulder,
		shoulder_width = tweak_data.vr.default_body_metrics.shoulder_width
	}
	self._limits = {
		height = {
			max = 250,
			min = 50
		},
		belt_height_ratio = {
			max = 0.9,
			min = 0.1
		},
		belt_distance = {
			max = 30,
			min = -10
		},
		belt_size = {
			max = 126,
			min = 66
		},
		belt_snap = {
			max = 360,
			min = 0
		},
		rotate_player_angle = {
			max = 90,
			min = 45
		},
		warp_zone_size = {
			max = 100,
			min = 0
		},
		dead_zone_size = {
			max = 100,
			min = 0
		},
		arm_length = {
			max = 150,
			min = 10
		},
		head_to_shoulder = {
			max = 50,
			min = 10
		},
		shoulder_width = {
			max = 120,
			min = 20
		}
	}

	if not Global.vr then
		Global.vr = {}
	end

	self._global = Global.vr

	for setting, default in pairs(self._default) do
		if self._global[setting] == nil then
			if type(default) == "table" then
				self._global[setting] = deep_clone(default)
			else
				self._global[setting] = default
			end
		end
	end

	self._vr_loading_environment = VRLoadingEnvironment:new()
	self._force_disable_low_adaptive_quality = false

	MenuRoom:load("units/pd2_dlc_vr/menu/vr_menu_mini", false)
end

local orig_init_finalize = VRManagerPD2.init_finalize
function VRManagerPD2:init_finalize()
	if not _G.IS_VR then return end

	orig_init_finalize(self)
end

local orig__update_adaptive_quality_level = VRManagerPD2._update_adaptive_quality_level
function VRManagerPD2:_update_adaptive_quality_level(t)
	if not _G.IS_VR then return end

	orig__update_adaptive_quality_level(self, t)
end
