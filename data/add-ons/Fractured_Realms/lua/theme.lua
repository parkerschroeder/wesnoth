-- #textdomain wesnoth-Fractured_Realms
local _ = wesnoth.textdomain "wesnoth-Fractured_Realms"
local old_unit_status = wesnoth.interface.game_display.unit_status

function wesnoth.interface.game_display.unit_status()
	local u = wesnoth.interface.get_displayed_unit()
	if not u then return {} end
	local s = old_unit_status()

	if u.status.festering then
		table.insert(s, { "element", { image = "misc/curse-status-icon.png~CROP_TRANSPARENCY()",
			tooltip = _ "festering: This unit has a festering curse. If not cured before nightfall, it will take root permanently. Stand on a village or next to a healer to cure it."
		} } )
	elseif u.status.lycanthropy then
		table.insert(s, { "element", { image = "misc/curse-status-icon.png~CROP_TRANSPARENCY()",
			tooltip = _ "lycanthropy: This unit is permanently cursed with lycanthropy. It transforms into a werefolk at nightfall and reverts at dawn."
		} } )
	end

	return s
end
