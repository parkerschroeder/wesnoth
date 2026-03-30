-- #textdomain wesnoth-Fractured_Realms
local _ = wesnoth.textdomain "wesnoth-Fractured_Realms"
local old_unit_status = wesnoth.interface.game_display.unit_status

function wesnoth.interface.game_display.unit_status()
	local u = wesnoth.interface.get_displayed_unit()
	if not u then return {} end
	local s = old_unit_status()

	if u.status.lycanthropy then
		table.insert(s, { "element", { image = "misc/curse-status-icon.png~CROP_TRANSPARENCY()",
			tooltip = _ "lycanthropy: This unit is cursed with lycanthropy. It will transform into a werefolk at nightfall and revert at dawn. Stand on a village to cure it."
		} } )
	end

	return s
end
