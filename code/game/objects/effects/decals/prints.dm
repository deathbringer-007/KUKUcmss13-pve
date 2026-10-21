/obj/effect/decal/prints
	name = "可疑指纹"
	gender = PLURAL
	icon = 'icons/effects/fingerprints.dmi'
	icon_state = "prints"
	anchored = TRUE
	unacidable = TRUE

	var/description = null

	var/criminal_name = null
	var/criminal_rank = null
	var/criminal_squad = null

	var/created_time = 0

/obj/effect/decal/prints/New(turf/location, mob/living/carbon/human/criminal_mob, incident = "")
	. = ..()

	if(!criminal_mob)
		return

	forceMove(location)
	criminal_name = criminal_mob.name

	var/obj/item/card/id/I = criminal_mob.get_idcard()
	if(I)
		criminal_rank = I.rank

	if(criminal_mob.assigned_squad)
		criminal_squad = criminal_mob.assigned_squad.name

	description = incident

	created_time = world.timeofday

	SSclues.prints_list += src

/obj/effect/decal/prints/attackby(obj/item/W, mob/living/user)
	if(!istype(W, /obj/item/device/clue_scanner))
		..()
		return

	var/obj/item/device/clue_scanner/S = W

	if(!skillcheck(user, SKILL_POLICE, SKILL_POLICE_SKILLED))
		to_chat(user, SPAN_WARNING("你似乎不知道该如何使用[S]……"))
		return

	S.scanning = TRUE
	S.update_icon()
	to_chat(user, SPAN_NOTICE("你开始扫描[src]……"))
	if(!do_after(user, 50, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
		S.scanning = FALSE
		S.update_icon()
		return
	S.scanning = FALSE

	moveToNullspace()
	LAZYADD(S.print_list, src)
	S.update_icon()
	to_chat(user, SPAN_INFO("新发现1组指纹，共计[length(S.print_list)]组。"))

/obj/effect/decal/prints/proc/decipher_clue()
	var/information = ""
	information += criminal_name

	if(!criminal_rank)
		return information

	information += ", "
	information += localized_player_label(criminal_rank)

	if(!criminal_squad)
		return information

	information += " "
	information += preference_label(criminal_squad)

	return information

/obj/effect/decal/prints/Destroy()
	SSclues.prints_list -= src

	. = ..()
