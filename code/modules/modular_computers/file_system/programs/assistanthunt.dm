#define ASSISTANTHUNT_CONTINUE 0
#define ASSISTANTHUNT_LOSE 1
#define ASSISTANTHUNT_WIN 2
#define ASSISTANTHUNT_IDLE 3

//Different statuses for assistants
#define ASSISTANTHUNT_DEAD 0
#define ASSISTANTHUNT_ALIVE 1
#define ASSISTANTHUNT_SHOT 2

#define ASSISTANTHUNT_MAX 500

/datum/computer_file/program/assistanthunt
	filename = "asshunt"
	filedesc = "Nanotrasen Micro Arcade: Assistant Hunt"
	program_icon_state = "arcade"
	extended_desc = "A game released exclusively on modern Nanotrasen hardware, originally meant for security training."
	requires_ntnet = FALSE
	network_destination = "arcade network"
	size = 8
	tgui_id = "NtosAssistantHunt"
	program_icon = "gamepad"

	var/datum/assistanthunt/game/board

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
	if(..())
		return TRUE
	
	if(!board)
		return
	
	if(!board.host && computer)
		board.host = computer

	var/obj/item/computer_hardware/printer/printer
	if(istype(board.host, /obj/item/modular_computer))
		var/obj/item/modular_computer/comp = board.host
		printer = comp.all_components[MC_PRINT]

	switch(action)
		if("PRG_tickets")
			board.play_snd('yogstation/sound/arcade/minesweeper_boardpress.ogg')
			if(!printer && istype(board.host, /obj/item/modular_computer))
				computer.visible_message(span_notice("Hardware error: A printer is required to redeem tickets."))
				return
			if(printer.stored_paper <= 0 && istype(board.host, /obj/item/modular_computer))
				computer.visible_message(span_notice("Hardware error: Printer is out of paper."))
				return
			else
				computer.visible_message(span_notice("\The [computer] prints out paper."))
				if(board.ticket_count >= 1)
					new /obj/item/stack/arcadeticket((get_turf(computer)), 1)
					to_chat(user, span_notice("[src] dispenses a ticket!"))
					board.ticket_count -= 1
					printer.stored_paper -= 1
				else
					to_chat(user, span_notice("You don't have any stored tickets!"))
				return TRUE
		if("PRG_Click")
			var/clickx = params["x"]
			var/clicky = params["y"]

			to_chat(user, span_notice("[clickx], [clicky]"))

/datum/assistanthunt/game/proc/play_snd(sound)
	if(istype(host, /obj/item/modular_computer))
		var/obj/item/modular_computer/comp = host
		comp.play_computer_sound(sound, 50, 0)
	else
		playsound(get_turf(host), sound, 50, 0, extrarange = -3, falloff = 10)

/datum/assistanthunt/game/proc/create_assistant(spawnamount)
	var/i
	for(i = 0 , i<spawnamount, i++)
		var/datum/assistanthunt/assistant/assistant_buffer
		for(var/C in assistant_buffer.target)
			C = rand(0,ASSISTANTHUNT_MAX)

		assistants.Add(assistant_buffer)
	qdel(i)
/datum/assistanthunt/game/proc/process_assistant()


/datum/assistanthunt/game
	var/ticket_count = 0
	var/points = 0
	
	var/current_level = 1
	/* Used to define each and every level */
	var/list/assistants = list()
	var/wave = 1
	var/point_per_assistant
	var/lasers
	var/radius
	var/time

	var/emaggable = FALSE
	var/obj/host

/datum/assistanthunt/assistant
	var/x = 10
	var/y = 10
	var/target = list(350,350)
	var/escaping = FALSE
	var/status = ASSISTANTHUNT_ALIVE
	var/speed = 5
