_G.NRI_PIP = _G.NRI_PIP or {}
NRI_PIP._path = ModPath
NRI_PIP._loc_path = ModPath .. "loc/"
NRI_PIP._settings_path = SavePath .. "NRI_PIP_Savefile.txt"



function NRI_PIP:Reset()
	NRI_PIP.settings = {
        nri_pip_res_scaling = 4,
		nri_pip_zoom_mul = 1,
	}
end
function NRI_PIP:Save()
	local file = io.open( NRI_PIP._settings_path, "w+" )
	if file then
		file:write( json.encode( NRI_PIP.settings ) )
		file:close()
	end
end
function NRI_PIP:Load()
	local file = io.open( NRI_PIP._settings_path, "r" )
	if file then
		NRI_PIP:Reset() 

		local saved_settings = json.decode( file:read("*all") ) or {}
		for k, v in pairs(saved_settings) do
			NRI_PIP.settings[k] = v
		end

		file:close()
	else
		NRI_PIP:Reset()
		NRI_PIP:Save()
	end
end

NRI_PIP:Load()

Hooks:Add("LocalizationManagerPostInit", "LocalizationManagerPostInit_NRI_PIP", function(loc)
	for i, k in pairs(file.GetFiles(NRI_PIP._loc_path)) do
		if Idstring(k:match('^(.*).txt$') or ""):key()==SystemInfo:language():key() then
			loc:load_localization_file(NRI_PIP._loc_path .. k)
			break
		end
	end
	loc:load_localization_file(NRI_PIP._loc_path .. "english.txt", false)
end)

Hooks:Add("MenuManagerInitialize", "MenuManagerInitialize_NRI_PIP", function(menu_manager)
	MenuCallbackHandler.nri_pip_res_scaling_choice_callback = function(self, item)
		NRI_PIP.settings.nri_pip_res_scaling = item:value()
		NRI_PIP:Save()
	end
	MenuCallbackHandler.nri_pip_zoom_mul_callback = function(self, item)
		NRI_PIP.settings.nri_pip_zoom_mul = item:value()
		NRI_PIP:Save()
	end

	NRI_PIP:Load()
	MenuHelper:LoadFromJsonFile( NRI_PIP._path .. "nri_pip_modoptions.json", NRI_PIP, NRI_PIP.settings )
end)