/* In this file:
 *
 * Plasma floor
 * Gold floor
 * Silver floor
 * Bananium floor
 * Diamond floor
 * Uranium floor
 * Shuttle floor (Titanium)
 */

/turf/open/floor/mineral
	name = "mineral floor"
	icon_state = ""
	var/list/icons
	tiled_dirt = FALSE


/turf/open/floor/mineral/Initialize(mapload)
	if(!broken_states)
		broken_states = list("[initial(icon_state)]_dam")
	. = ..()
	icons = typelist("icons", icons)


/turf/open/floor/mineral/update_icon_state()
	. = ..()
	if(!.)
		return
	if(!broken && !burnt)
		if(!(icon_state in icons))
			icon_state = initial(icon_state)

//PLASMA

/turf/open/floor/mineral/plasma
	name = "plasma floor"
	icon_state = "plasma"
	floor_tile = /obj/item/stack/tile/mineral/plasma
	icons = list("plasma","plasma_dam")
	flammability = 25 // oh fuck-

/turf/open/floor/mineral/plasma/temperature_expose(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	if(exposed_temperature > 300)
		PlasmaBurn(exposed_temperature)

/turf/open/floor/mineral/plasma/attackby(obj/item/W, mob/user, params)
	if(W.is_hot() > 300)//If the temperature of the object is over 300, then ignite
		message_admins("Plasma flooring was ignited by [ADMIN_LOOKUPFLW(user)] in [ADMIN_VERBOSEJMP(src)]")
		log_game("Plasma flooring was ignited by [key_name(user)] in [AREACOORD(src)]")
		ignite(W.is_hot())
		return
	..()

/turf/open/floor/mineral/plasma/proc/PlasmaBurn(temperature)
	make_plating()
	atmos_spawn_air("plasma=20;TEMP=[temperature]")

/turf/open/floor/mineral/plasma/proc/ignite(exposed_temperature)
	if(exposed_temperature > 300)
		PlasmaBurn(exposed_temperature)

/turf/open/floor/mineral/plasma/broken
	icon_state = "plasma_dam"
	broken = TRUE

//GOLD

/turf/open/floor/mineral/gold
	name = "gold floor"
	icon_state = "gold"
	floor_tile = /obj/item/stack/tile/mineral/gold
	icons = list("gold","gold_dam")

/turf/open/floor/mineral/gold/broken
	icon_state = "gold_dam"
	broken = TRUE

//SILVER

/turf/open/floor/mineral/silver
	name = "silver floor"
	icon_state = "silver"
	floor_tile = /obj/item/stack/tile/mineral/silver
	icons = list("silver","silver_dam")

/turf/open/floor/mineral/silver/broken
	icon_state = "gold_dam"
	broken = TRUE

//TITANIUM (shuttle)

/turf/open/floor/mineral/titanium
	name = "shuttle floor"
	icon_state = "titanium"
	flags_1 = NO_RUST | CAN_BE_DIRTY_1
	floor_tile = /obj/item/stack/tile/mineral/titanium
	broken_states = list("titanium_dam1","titanium_dam2","titanium_dam3","titanium_dam4","titanium_dam5")

/turf/open/floor/mineral/titanium/broken
	icon_state = "titanium_dam1"
	broken = TRUE

/turf/open/floor/mineral/titanium/broken/two
	icon_state = "titanium_dam2"

/turf/open/floor/mineral/titanium/broken/three
	icon_state = "titanium_dam3"

/turf/open/floor/mineral/titanium/broken/four
	icon_state = "titanium_dam4"

/turf/open/floor/mineral/titanium/broken/fice
	icon_state = "titanium_dam5"

/turf/open/floor/mineral/titanium/airless
	initial_gas_mix = AIRLESS_ATMOS

/turf/open/floor/mineral/titanium/airless/broken
	icon_state = "titanium_dam1"
	broken = TRUE

/turf/open/floor/mineral/titanium/airless/broken/two
	icon_state = "titanium_dam2"

/turf/open/floor/mineral/titanium/airless/broken/three
	icon_state = "titanium_dam3"

/turf/open/floor/mineral/titanium/airless/broken/four
	icon_state = "titanium_dam4"

/turf/open/floor/mineral/titanium/airless/broken/five
	icon_state = "titanium_dam5"

/turf/open/floor/mineral/titanium/yellow
	icon_state = "titanium_yellow"

/turf/open/floor/mineral/titanium/yellow/airless
	initial_gas_mix = AIRLESS_ATMOS

/turf/open/floor/mineral/titanium/blue
	icon_state = "titanium_blue"

/turf/open/floor/mineral/titanium/blue/airless
	initial_gas_mix = AIRLESS_ATMOS

/turf/open/floor/mineral/titanium/white
	icon_state = "titanium_white"

/turf/open/floor/mineral/titanium/white/airless
	initial_gas_mix = AIRLESS_ATMOS

/turf/open/floor/mineral/titanium/purple
	icon_state = "titanium_purple"

/turf/open/floor/mineral/titanium/purple/airless
	initial_gas_mix = AIRLESS_ATMOS

//PLASTITANIUM (syndieshuttle)
/turf/open/floor/mineral/plastitanium
	name = "shuttle floor"
	icon_state = "plastitanium"
	floor_tile = /obj/item/stack/tile/mineral/plastitanium
	broken_states = list("plastitanium_dam1","plastitanium_dam2","plastitanium_dam3","plastitanium_dam4","plastitanium_dam5")

/turf/open/floor/mineral/plastitanium/broken
	icon_state = "plastitanium_dam1"

/turf/open/floor/mineral/plastitanium/broken/two
	icon_state = "plastitanium_dam2"

/turf/open/floor/mineral/plastitanium/broken/three
	icon_state = "plastitanium_dam3"

/turf/open/floor/mineral/plastitanium/broken/four
	icon_state = "plastitanium_dam4"

/turf/open/floor/mineral/plastitanium/broken/five
	icon_state = "plastitanium_dam5"

/turf/open/floor/mineral/plastitanium/airless
	initial_gas_mix = AIRLESS_ATMOS

/turf/open/floor/mineral/plastitanium/airless/broken
	broken = TRUE

/turf/open/floor/mineral/plastitanium/red
	icon_state = "plastitanium_red"

/turf/open/floor/mineral/plastitanium/red/airless
	initial_gas_mix = AIRLESS_ATMOS

/turf/open/floor/mineral/plastitanium/red/brig
	name = "brig floor"

/turf/open/floor/mineral/plastitanium/red/brig/fakepit
	name = "brig chasm"
	desc = "A place for very naughy criminals."
	smooth = SMOOTH_TRUE | SMOOTH_BORDER | SMOOTH_MORE
	canSmoothWith = list(/turf/open/floor/mineral/plastitanium/red/brig/fakepit)
	icon = 'icons/turf/floors/Chasms.dmi'
	icon_state = "smooth"
	tiled_dirt = FALSE

//BANANIUM

/turf/open/floor/mineral/bananium
	name = "bananium floor"
	icon_state = "bananium"
	floor_tile = /obj/item/stack/tile/mineral/bananium
	icons = list("bananium","bananium_dam")
	var/spam_flag = 0

/turf/open/floor/mineral/bananium/Entered(atom/movable/AM)
	.=..()
	if(!.)
		if(isliving(AM))
			squeak()

/turf/open/floor/mineral/bananium/attackby(obj/item/W, mob/user, params)
	.=..()
	if(!.)
		honk()

/turf/open/floor/mineral/bananium/attack_hand(mob/user)
	.=..()
	if(!.)
		honk()

/turf/open/floor/mineral/bananium/attack_paw(mob/user)
	.=..()
	if(!.)
		honk()

/turf/open/floor/mineral/bananium/proc/honk()
	if(spam_flag < world.time)
		playsound(src, 'sound/items/bikehorn.ogg', 50, 1)
		spam_flag = world.time + 20

/turf/open/floor/mineral/bananium/proc/squeak()
	if(spam_flag < world.time)
		playsound(src, "clownstep", 50, 1)
		spam_flag = world.time + 10

/turf/open/floor/mineral/bananium/airless
	initial_gas_mix = AIRLESS_ATMOS

/turf/open/floor/mineral/bananium/honk_act()
	return FALSE

/turf/open/floor/mineral/bananium/broken
	icon_state = "bananium_dam"
	broken = TRUE

/turf/open/floor/mineral/bananium/airless/broken
	icon_state = "bananium_dam"
	broken = TRUE

//DIAMOND

/turf/open/floor/mineral/diamond
	name = "diamond floor"
	icon_state = "diamond"
	floor_tile = /obj/item/stack/tile/mineral/diamond
	icons = list("diamond","diamond_dam")

/turf/open/floor/mineral/diamond/broken
	icon_state = "diamond_dam"
	broken = TRUE

//URANIUM

/turf/open/floor/mineral/uranium
	article = "a"
	name = "uranium floor"
	icon_state = "uranium"
	floor_tile = /obj/item/stack/tile/mineral/uranium
	icons = list("uranium","uranium_dam")
	var/last_event = 0
	var/active = null

/turf/open/floor/mineral/uranium/Entered(atom/movable/AM)
	.=..()
	if(!.)
		if(ismob(AM))
			radiate()

/turf/open/floor/mineral/uranium/attackby(obj/item/W, mob/user, params)
	.=..()
	if(!.)
		radiate()

/turf/open/floor/mineral/uranium/attack_hand(mob/user)
	.=..()
	if(!.)
		radiate()

/turf/open/floor/mineral/uranium/attack_paw(mob/user)
	.=..()
	if(!.)
		radiate()

/turf/open/floor/mineral/uranium/proc/radiate()
	if(!active)
		if((SSticker.current_state == GAME_STATE_PLAYING) && (world.time > last_event+15))
			active = 1
			radiation_pulse(src, 10)
			for(var/turf/open/floor/mineral/uranium/T in orange(1,src))
				T.radiate()
			last_event = world.time
			active = 0
			return

/turf/open/floor/mineral/uranium/broken
	icon_state = "uranium_dam"
	broken = TRUE

// ALIEN ALLOY
/turf/open/floor/mineral/abductor
	name = "alien floor"
	icon_state = "alienpod1"
	floor_tile = /obj/item/stack/tile/mineral/abductor
	icons = list("alienpod1", "alienpod2", "alienpod3", "alienpod4", "alienpod5", "alienpod6", "alienpod7", "alienpod8", "alienpod9")
	baseturfs = /turf/open/floor/plating/abductor2

/turf/open/floor/mineral/abductor/Initialize(mapload)
	. = ..()
	icon_state = "alienpod[rand(1,9)]"

/turf/open/floor/mineral/abductor/break_tile()
	return //unbreakable

/turf/open/floor/mineral/abductor/burn_tile()
	return //unburnable
