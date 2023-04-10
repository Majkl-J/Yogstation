#define ASSISTANTHUNT_CONTINUE 0
#define ASSISTANTHUNT_DEAD 1
#define ASSISTANTHUNT_WIN 2
#define ASSISTANTHUNT_IDLE 3

/datum/computer_file/program/assistanthunt
	filename = "asshunt"
	filedesc = "Nanotrasen Micro Arcade: Assistant Hunt"
	program_icon_state = "arcade"
	extended_desc = "A game released exclusively on modern Nanotrasen hardware, originally meant for security training."
	requires_ntnet = FALSE
	network_destination = "arcade network"
	size = 8
	tgui_id = "Assistanthunt"
	program_icon = "gamepad"

	var/datum/assistanthunt/board

/datum/computer_file/program/assistanthunt/New(obj/item/modular_computer/comp)
	. = ..()
	board = new /datum/assistanthunt()
	board.emaggable = FALSE
	board.host = comp

/datum/computer_file/program/assistanthunt/Destroy()
	board.host = null
	QDEL_NULL(board)
	. = ..()

/datum/computer_file/program/assistanthunt/ui_assets(mob/user)
	return list(
		get_asset_datum(/datum/asset/simple/assistanthunt),
	)

/datum/computer_file/program/assistanthunt/ui_data(mob/user)
	var/list/data = get_header_data()

	return data

/datum/computer_file/program/assistanthunt/ui_act(action, list/params, mob/user)
