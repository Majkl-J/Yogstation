/mob/living/simple_animal/spiderbot
	name = "Spider bot"
	desc = "Unlike drones, spiderbots are actually smart and make good friends!"
	icon = 'icons/mob/robots.dmi'
	icon_state = "spiderbot"
	icon_living = "spiderbot"
	icon_dead = "spiderbot-dead"
	initial_language_holder = /datum/language_holder/spiderbot
	atmos_requirements = list("min_oxy" = 0, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 1, "min_co2" = 0, "max_co2" = 0, "min_n2" = 0, "max_n2" = 0)
	faction = list("neutral","silicon","turrets","spiders")
	minbodytemp = 0
	maxbodytemp = 500
	wander = FALSE
	health = 25
	maxHealth = 25
	attacktext = "shocks"
	melee_damage_type = BURN
	melee_damage_lower = 1
	melee_damage_upper = 3
	response_help  = "pets"
	response_disarm = "shoos"
	response_harm   = "stomps on"
	density = FALSE
	speed = -1  //Spiderbots gotta go fast.
	pass_flags = PASSTABLE | PASSGRILLE | PASSMOB
	ventcrawler = VENTCRAWLER_ALWAYS
	mob_size = MOB_SIZE_TINY
	speak_emote = list("beeps","clicks","chirps")

	var/obj/item/radio/borg/radio = null
	var/obj/machinery/camera/camera = null
	var/obj/item/mmi/mmi = null
	var/req_access = ACCESS_ROBOTICS //Access needed to pop out the brain.
	var/emagged = 0

	var/spiderbot_upgrade_level = 1 //This is used for actually upgrading the spiderbots, derived from manipulators used on construction
	var/list/spiderbot_upgrades = list()
	var/list/valid_upgrades = list(/obj/item/bot_assembly/cleanbot,
									/obj/item/bot_assembly/floorbot,
									/obj/item/bot_assembly/medbot,
									/obj/item/bot_assembly/honkbot,
									/obj/item/bot_assembly/firebot,
									/obj/item/bot_assembly/atmosbot
	)
	var/obj/item/held_item = null //Storage for single item they can hold.

	var/default_speed = -1
	var/slowed_speed = 2
	var/clean_on_move = FALSE

/mob/living/simple_animal/spiderbot/attackby(obj/item/O, mob/user)
	if(istype(O, /obj/item/mmi))
		var/obj/item/mmi/M = O
		if(mmi) //There's already a brain in it.
			to_chat(user, span_warning("There's already a brain in [src]!"))
			return
		if(!M.brainmob)
			to_chat(user, span_warning("Sticking an empty MMI into the frame would sort of defeat the purpose."))
			return
		var/mob/living/brain/BM = M.brainmob
		if(!BM.key || !BM.mind)
			to_chat(user, span_warning("The MMI indicates that their mind is completely unresponsive; there's no point!"))
			return

		if(!BM.client) //braindead
			to_chat(user, span_warning("The MMI indicates that their mind is currently inactive; it might change!"))
			return

		if(BM.stat == DEAD || BM.suiciding || (M.brain && (M.brain.brain_death || M.brain.suicided)))
			to_chat(user, span_warning("Sticking a dead brain into the frame would sort of defeat the purpose!"))
			return

		if(is_banned_from(BM.ckey, "Cyborg") || QDELETED(src) || QDELETED(BM) || QDELETED(user) || QDELETED(M) || !Adjacent(user))
			if(!QDELETED(M))
				to_chat(user, span_warning("This [M.name] does not seem to fit!"))
			return

		if(!user.temporarilyRemoveItemFromInventory(M))
			return
		to_chat(user, span_notice("You install [M] in [src]!"))
		mmi = M
		transfer_personality(M)
		update_icon()
		return 1

	else if(O.tool_behaviour == TOOL_WELDER && (user.a_intent != INTENT_HARM || user == src))
		user.changeNext_move(CLICK_CD_MELEE)
		if (!getBruteLoss())
			to_chat(user, span_warning("[src] is already in good condition!"))
			return
		if (!O.tool_start_check(user, amount=0))
			return
		adjustBruteLoss(-10)
		updatehealth()
		add_fingerprint(user)
		visible_message(span_notice("[user] has fixed some of the dents on [src]."))
		return

	else if(istype(O, /obj/item/card/id)||istype(O, /obj/item/pda))
		if (!mmi)
			to_chat(user, span_warning("There's no reason to swipe your ID - the spiderbot has no brain to remove."))
			return 0

		var/obj/item/card/id/id_card
		if(istype(O, /obj/item/card/id))
			id_card = O
		else
			var/obj/item/pda/pda = O
			id_card = pda.id

		if(req_access in id_card.GetAccess())
			to_chat(user, span_notice("You swipe your access card and pop the brain out of [src]."))
			eject_brain()
			if(held_item)
				held_item.loc = src.loc
				held_item = null
			return 1
		else
			to_chat(user, span_warning("You swipe your card, with no effect."))
			return 0
	else if(istype(O, /obj/item/bot_assembly)) //Upgrades people, upgrades
		if(spiderbot_upgrades.len >= spiderbot_upgrade_level) //Better have this on >= just in case
			to_chat(user, span_warning("The [src]'s upgrade slots are already full!"))
			return FALSE
		else if(O.type in valid_upgrades)
			if(O.type in spiderbot_upgrades)
				to_chat(user, span_warning("The [src] is already upgraded with this assembly!"))
				return FALSE
			else
				if(!user.temporarilyRemoveItemFromInventory(O))
					return
				O.forceMove(src)
				spiderbot_upgrades += O.type
				to_chat(user, span_warning("You insert the assembly into one of [src]'s upgrade slots!"))
				update_upgrades()
				return TRUE
		else
			to_chat(user, span_warning("The [O] won't fit into the [src]."))
			return FALSE

	return ..()

/mob/living/simple_animal/spiderbot/proc/transfer_personality(obj/item/mmi/M)
	M.brainmob.mind.transfer_to(src)
	M.forceMove(src)
	job = "Spider Bot"

/mob/living/simple_animal/spiderbot/emag_act(mob/user)
	if (emagged)
		to_chat(user, span_warning("[src] is already overloaded - better run."))
		return
	else
		emagged = 1
		to_chat(user, span_notice("You short out the security protocols and overload [src]'s cell, priming it to explode in a short time."))
		spawn(100)
			to_chat(src, span_warning("Your cell seems to be outputting a lot of power..."))
		spawn(200)
			to_chat(src, span_warning("Internal heat sensors are spiking! Something is badly wrong with your cell!"))
		spawn(300)
			explode()
		return

/mob/living/simple_animal/spiderbot/proc/explode() //When emagged.
	visible_message(span_warning("[src] makes an odd warbling noise, fizzles, and explodes."))
	explosion(get_turf(src), -1, 0, 2, 3, 0, flame_range = 2) ///Explodes like a fireball
	if(!QDELETED(src) && stat != DEAD)
		gib()

/mob/living/simple_animal/spiderbot/proc/update_icon()
	icon_state = "spiderbot"
	icon_living = "spiderbot"
	if(mmi)
		if(istype(mmi, /obj/item/mmi/posibrain))
			add_overlay("spiderbot_posi")
		else
			add_overlay("spiderbot_mmi")
		return
	else
		overlays = null

/mob/living/simple_animal/spiderbot/proc/eject_brain()
	if(mmi)
		if(mind)	
			mind.transfer_to(mmi.brainmob)
		else if(key)
			mmi.brainmob.key = key
		mmi.forceMove(loc)
		mmi.update_icon()
		mmi = null
		name = initial(name)
	update_icon()

/mob/living/simple_animal/spiderbot/gib()
	eject_brain()
	new /obj/effect/decal/remains/robot(loc)
	qdel(src)

/mob/living/simple_animal/spiderbot/Destroy()
	eject_brain()
	return ..()

/mob/living/simple_animal/spiderbot/Initialize(mapload, obj/item/stock_parts/manipulator/M)
	. = ..()
	radio = new /obj/item/radio/borg(src)
	camera = new /obj/machinery/camera(src)
	spiderbot_upgrade_level = M.rating
	camera.c_tag = name
	add_verb(src, list(/mob/living/simple_animal/spiderbot/proc/hide, \
			  /mob/living/simple_animal/spiderbot/proc/drop_held_item, \
			  /mob/living/simple_animal/spiderbot/proc/get_item))
	RegisterSignal(src, COMSIG_MOB_DEATH, .proc/on_death)
	update_upgrades()

/mob/living/simple_animal/spiderbot/proc/on_death()
	UnregisterSignal(src, COMSIG_MOB_DEATH)
	gib()

/mob/living/simple_animal/spiderbot/Destroy()
	if(radio)
		qdel(radio)
		radio = null
	if(camera)
		qdel(camera)
		camera = null
	if(held_item)
		held_item.forceMove(loc)
		held_item = null
	if(mmi)
		mmi.forceMove(loc)
		mmi = null
	UnregisterSignal(src, COMSIG_MOB_DEATH)
	. = ..()


/mob/living/simple_animal/spiderbot/examine(mob/user)
	. = ..()
	if(health < maxHealth)
		. += "This [src] looks a bit dented"
	if(src.held_item)
		to_chat(user, "It is carrying \a [src.held_item] [icon2html(src.held_item, src)].")
