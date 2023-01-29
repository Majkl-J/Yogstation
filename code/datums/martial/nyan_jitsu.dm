/// Tail swipe
#define TAIL_SWIPE_COMBO "DH"
/// Lacerate, a very destructive move
#define LACERATE_COMBO "HHHH"
/// [im Thinking of a cool name tm]
#define COOL_NAME_COMBO "DDD"

/datum/martial_art/nyanjitsu
	name = "Nyan Jitsu"
	id = MARTIALART_NYANJITSU
	no_guns = TRUE
	help_verb = /mob/living/carbon/human/proc/nyanjitsu_help	

/datum/martial_art/nyanjitsu/can_use(mob/living/carbon/human/H)
	return iscatperson(H)

/datum/martial_art/nyanjitsu/proc/check_streak(mob/living/carbon/human/A, mob/living/carbon/human/D)
	if(findtext(streak,TAIL_SWIPE_COMBO))
		streak = ""
		Swipe(A,D)
		return 1
	if(findtext(streak,LACERATE_COMBO))
		streak = ""
		Lacerate(A,D)
		return 1
	if(findtext(streak,COOL_NAME_COMBO))
		streak = ""
		CoolName(A,D)
		return 1
	return 0

//Tail Swipe, Blind the person for 3-6 Second Depending whether they have eye Protection
/datum/martial_art/nyanjitsu/proc/Swipe(mob/living/carbon/human/A, mob/living/carbon/human/D)
	if(!can_use(A))
		return
	A.emote("spin")
	var/obj/item/organ/tail = A.getorganslot(ORGAN_SLOT_TAIL)
	if(!istype(tail, /obj/item/organ/tail/cat))
		A.visible_message(span_danger("[A] spins around."), \
						  span_userdanger("You spin around like a doofus."))
		return
	playsound(get_turf(A), 'sound/weapons/thudswoosh.ogg', 50, TRUE, -1)
	if(D.flash_act(1,10))
		D.visible_message(span_danger("[A] blinds [D] with their tail!"), \
										span_userdanger("[A] blinds you with their tail!"))
		to_chat(A, span_danger("You swipe your tail across [D]'s eyes, blinding them!"))
		D.Knockdown(rand(50,80))
	else
		D.flash_act((D.get_eye_protection() + 1),3)
		D.visible_message(span_danger("[A] swipes their tail across [D]'s eye protection!"), \
										span_userdanger("[A] blinds you with their tail!"))
		to_chat(A, span_danger("You swipe your tail across [D]'s eye protection, failing to properly blind them!"))


//I DID NOT STEAL THIS FROM FLYING FANG NOW SHUTUP
/datum/martial_art/nyanjitsu/proc/Lacerate(mob/living/carbon/human/A, mob/living/carbon/human/D)
	if(!can_use(A))
		return
	var/selected_zone = A.zone_selected
	var/obj/item/bodypart/affecting = D.get_bodypart(ran_zone(A.zone_selected))
	var/lacerate_damage = A.get_punchdamagehigh() * 2 + 10 //About 30 hopefully
	var/armor_block = D.run_armor_check(affecting, MELEE, armour_penetration = 50)
	A.do_attack_animation(D, ATTACK_EFFECT_CLAW)
	playsound(D, 'sound/weapons/whip.ogg', 50, TRUE, -1)
	D.apply_damage(lacerate_damage, A.dna.species.attack_type, selected_zone, armor_block, sharpness = SHARP_EDGED)
	D.visible_message(span_danger("[A] slashes a deep cut into [D]'s [affecting]!"), \
					  span_userdanger("[A] heavily cuts your [affecting]!"))
	A.Stun(0.5 SECONDS)
	D.Stun(1 SECONDS)
	log_combat(A, D, "chest cut (Nyan Jitsu)")

/datum/martial_art/nyanjitsu/proc/CoolName(mob/living/carbon/human/A, mob/living/carbon/human/D)









/datum/martial_art/nyanjitsu/harm_act(mob/living/carbon/human/A, mob/living/carbon/human/D)
	add_to_streak("H",D)
	if(check_streak(A,D))
		return TRUE
	basic_hit(A,D)
	return FALSE

/datum/martial_art/nyanjitsu/disarm_act(mob/living/carbon/human/A, mob/living/carbon/human/D)
	add_to_streak("D",D)
	if(check_streak(A,D))
		return TRUE
	return FALSE

/datum/martial_art/nyanjitsu/grab_act(mob/living/carbon/human/A, mob/living/carbon/human/D)
	add_to_streak("G",D)
	if(check_streak(A,D))
		return TRUE
	return FALSE


/mob/living/carbon/human/proc/nyanjitsu_help()
	set name = "Recall Your Teachings"
	set desc = "You try to remember your training of Nyan Jitsu."
	set category = "Nyan Jitsu"
	to_chat(usr, "<b><i>You try to remember some of the basics of Nyan Jitsu.</i></b>")

	to_chat(usr, span_warning("However, the primitive instincts gained through this training prevent you from using guns, stun weapons, or armor."))
	to_chat(usr, span_notice("<b>All of your unarmed attacks deal increased brute damage with a small amount of armor piercing</b>"))
	
	to_chat(usr, "[span_notice("Tail Swipe")]: Disarm Harm. Blinds the person for 3-6 Second Depending whether they have eye Protection")
	to_chat(usr, "[span_notice("Lacerate")]: Harm Harm Harm Harm. Extend your claws past their normal capabilities and inflict heavy wounds upon the target's chest")
	to_chat(usr, "[span_notice("CoolName")]: Disarm Disarm Disarm. Strike Fear Into Your Foes, confusing them.")
