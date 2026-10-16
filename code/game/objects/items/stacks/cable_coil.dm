
// the cable coil object, used for laying cable

#define MAXCOIL 30
/obj/item/stack/cable_coil
	name = "电缆卷"
	icon = 'icons/obj/structures/machinery/power.dmi'
	icon_state = "coil"
	amount = MAXCOIL
	max_amount = MAXCOIL
	color = COLOR_RED
	desc = "一卷电力电缆。"
	throwforce = 10
	w_class = SIZE_SMALL
	throw_speed = SPEED_SLOW
	throw_range = 5
	matter = list("metal" = 50, "glass" = 20)
	flags_equip_slot = SLOT_WAIST
	item_state = "coil"
	attack_verb = list("鞭打", "抽打", "鞭笞", "抽打")
	stack_id = "cable coil"
	attack_speed = 3
	ground_offset_x = 2
	ground_offset_y = 2
	flags_human_ai = HEALING_ITEM

/obj/item/stack/cable_coil/Initialize(mapload, length = MAXCOIL, param_color = null)
	. = ..()
	src.amount = length
	if (param_color) // It should be red by default, so only recolor it if parameter was specified.
		color = param_color
	updateicon()
	update_wclass()

/obj/item/stack/cable_coil/proc/updateicon()
	if (!color)
		color = pick(COLOR_RED, COLOR_BLUE, COLOR_GREEN, COLOR_ORANGE, COLOR_WHITE, COLOR_MAGENTA, COLOR_YELLOW, COLOR_CYAN)
	if(amount == 1)
		icon_state = "coil1"
		name = "电缆段"
	else if(amount == 2)
		icon_state = "coil2"
		name = "电缆段"
	else
		icon_state = "coil"
		name = "电缆卷"

/obj/item/stack/cable_coil/proc/update_wclass()
	if(amount == 1)
		w_class = SIZE_TINY
	else
		w_class = SIZE_SMALL

/obj/item/stack/cable_coil/get_examine_text(mob/user)
	. = list()
	if(amount == 1)
		. += "一小段电力电缆。"
	else if(amount == 2)
		. += "一段电力电缆。"
	else
		. += "一卷电力电缆，共有[amount]段。"

/obj/item/stack/cable_coil/verb/make_restraint()
	set name = "制作电缆束缚带"
	set category = "物品"
	set src in usr
	var/mob/M = usr

	if(ishuman(M) && !M.is_mob_incapacitated())
		if(!istype(usr.loc,/turf)) return
		if(src.amount <= 14)
			to_chat(usr, SPAN_WARNING("你至少需要15段电缆才能制作束缚带！"))
			return
		var/obj/item/restraint/adjustable/cable/B = new /obj/item/restraint/adjustable/cable(usr.loc)
		B.color = color
		to_chat(usr, SPAN_NOTICE("你将电缆绕在一起，制成了束缚带。"))
		src.use(15)
	else
		to_chat(usr, SPAN_NOTICE("\blue 你无法进行此操作。"))

/obj/item/stack/cable_coil/attackby(obj/item/W, mob/user)
	if( HAS_TRAIT(W, TRAIT_TOOL_WIRECUTTERS) && src.amount > 1)
		src.amount--
		new/obj/item/stack/cable_coil(user.loc, 1,color)
		to_chat(user, SPAN_NOTICE("你从电缆卷上剪下了一段电缆。"))
		src.updateicon()
		src.update_wclass()
		return

	else if( istype(W, /obj/item/stack/cable_coil) )
		var/obj/item/stack/cable_coil/C = W
		if(C.amount >= MAXCOIL)
			to_chat(user, "这卷电缆已经太长，无法再加了。")
			return

		if( (C.amount + src.amount <= MAXCOIL) )
			to_chat(user, "你将两卷电缆接在了一起。")
			C.add(src.amount) // give it cable
			src.use(src.amount) // make sure this one cleans up right

		else
			var/amt = MAXCOIL - C.amount
			to_chat(user, "你将[amt]段电缆从一卷转移到了另一卷。")
			C.add(amt)
			src.use(amt)
		return
	..()

/obj/item/stack/cable_coil/attack_hand(mob/user as mob)
	if (user.get_inactive_hand() == src)
		var/obj/item/stack/cable_coil/F = new /obj/item/stack/cable_coil(user, 1, color)
		transfer_fingerprints_to(F)
		user.put_in_hands(F)
		src.add_fingerprint(user)
		F.add_fingerprint(user)
		use(1)
	else
		..()
	return

/obj/item/stack/cable_coil/use(used)
	if( ..() )
		updateicon()
		update_wclass()
		return 1

/obj/item/stack/cable_coil/add(extra)
	if( ..() )
		updateicon()
		update_wclass()
		return 1

// called when cable_coil is clicked on a turf/open/floor

/obj/item/stack/cable_coil/proc/turf_place(turf/open/floor/F, mob/user)

	if(!isturf(user.loc))
		return

	if(get_dist(F,user) > 1)
		to_chat(user, SPAN_WARNING("那里太远，无法铺设电缆。"))
		return

	if(F.intact_tile) // if floor is intact, complain
		to_chat(user, SPAN_WARNING("必须先撬起地砖，才能在那里铺设电缆。"))
		return

	else
		var/dirn

		if(user.loc == F)
			dirn = user.dir // if laying on the tile we're on, lay in the direction we're facing
		else
			dirn = get_dir(F, user)

		for(var/obj/structure/cable/LC in F)
			if((LC.d1 == dirn && LC.d2 == 0 ) || ( LC.d2 == dirn && LC.d1 == 0))
				to_chat(user, SPAN_WARNING("那个位置已经有电缆了。"))
				return

		for(var/obj/structure/cable/LC in F)
			if((LC.d1 == dirn && LC.d2 == 0 ) || ( LC.d2 == dirn && LC.d1 == 0))
				to_chat(user, "那个位置已经有电缆了。")
				return

		var/obj/structure/cable/C = new(F)

		C.cableColor(color)

		C.d1 = 0
		C.d2 = dirn
		C.add_fingerprint(user)
		C.updateicon()


		use(1)
		if (C.shock(user, 50))
			if (prob(50)) //fail
				new/obj/item/stack/cable_coil(C.loc, 1, C.color)
				qdel(C)
		//src.laying = 1
		//last = C


// called when cable_coil is click on an installed obj/cable

/obj/item/stack/cable_coil/proc/cable_join(obj/structure/cable/C, mob/user)

	var/turf/U = user.loc
	if(!isturf(U))
		return

	var/turf/T = C.loc

	if(!isturf(T) || T.intact_tile) // sanity checks, also stop use interacting with T-scanner revealed cable
		return

	if(get_dist(C, user) > 1) // make sure it's close enough
		to_chat(user, SPAN_WARNING("那里太远，无法铺设电缆。"))
		return


	if(U == T) // do nothing if we clicked a cable we're standing on
		return // may change later if can think of something logical to do

	var/dirn = get_dir(C, user)

	if(C.d1 == dirn || C.d2 == dirn) // one end of the clicked cable is pointing towards us
		if(U.intact_tile) // can't place a cable if the floor is complete
			to_chat(user, SPAN_WARNING("必须先撬起地砖，才能在那里铺设电缆。"))
			return
		else
			// cable is pointing at us, we're standing on an open tile
			// so create a stub pointing at the clicked cable on our tile

			var/fdirn = turn(dirn, 180) // the opposite direction

			for(var/obj/structure/cable/LC in U) // check to make sure there's not a cable there already
				if(LC.d1 == fdirn || LC.d2 == fdirn)
					to_chat(user, SPAN_WARNING("那个位置已经有电缆了。"))
					return

			var/obj/structure/cable/NC = new(U)
			NC.cableColor(color)

			NC.d1 = 0
			NC.d2 = fdirn
			NC.add_fingerprint()
			NC.updateicon()

			use(1)
			if (NC.shock(user, 50))
				if (prob(50)) //fail
					new/obj/item/stack/cable_coil(NC.loc, 1, NC.color)
					qdel(NC)

			return
	else if(C.d1 == 0) // exisiting cable doesn't point at our position, so see if it's a stub
							// if so, make it a full cable pointing from it's old direction to our dirn
		var/nd1 = C.d2 // these will be the new directions
		var/nd2 = dirn


		if(nd1 > nd2) // swap directions to match icons/states
			nd1 = dirn
			nd2 = C.d2


		for(var/obj/structure/cable/LC in T) // check to make sure there's no matching cable
			if(LC == C) // skip the cable we're interacting with
				continue
			if((LC.d1 == nd1 && LC.d2 == nd2) || (LC.d1 == nd2 && LC.d2 == nd1) ) // make sure no cable matches either direction
				to_chat(user, SPAN_WARNING("那个位置已经有电缆了。"))
				return


		C.cableColor(color)

		C.d1 = nd1
		C.d2 = nd2

		C.add_fingerprint()
		C.updateicon()

		use(1)
		if (C.shock(user, 50))
			if (prob(50)) //fail
				new/obj/item/stack/cable_coil(C.loc, 2, C.color)
				qdel(C)



/obj/item/stack/cable_coil/cut
	item_state = "coil2"
	garbage = TRUE

/obj/item/stack/cable_coil/cut/Initialize()
	. = ..()
	src.amount = rand(1,2)
	updateicon()
	update_wclass()

/obj/item/stack/cable_coil/yellow
	color = "#ffe28a"

/obj/item/stack/cable_coil/blue
	color = "#a8c1dd"

/obj/item/stack/cable_coil/green
	color = "#589471"

/obj/item/stack/cable_coil/pink
	color = "#6fcb9f"

/obj/item/stack/cable_coil/orange
	color = "#ff9845"

/obj/item/stack/cable_coil/cyan
	color = "#a8c1dd"

/obj/item/stack/cable_coil/white
	color = COLOR_WHITE

/obj/item/stack/cable_coil/random/Initialize()
	. = ..()
	color = pick(COLOR_RED, COLOR_BLUE, COLOR_GREEN, COLOR_WHITE, COLOR_MAGENTA, COLOR_YELLOW, COLOR_CYAN)

/obj/item/stack/cable_coil/attack(mob/M as mob, mob/user as mob)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M

		var/obj/limb/S = H.get_limb(user.zone_selected)
		if(!(S.status & (LIMB_ROBOT|LIMB_SYNTHSKIN)) || user.a_intent != INTENT_HELP)
			return ..()

		if(user.action_busy)
			return
		var/self_fixing = FALSE

		if(H.species.flags & IS_SYNTHETIC && M == user)
			self_fixing = TRUE

		if(S.burn_dam > 0 && use(1))
			if(self_fixing)
				user.visible_message(SPAN_WARNING("[user]开始修复自己[S.display_name]上的烧伤。"), \
					SPAN_WARNING("你开始小心修补自己[S.display_name]上的烧伤，以免失去保修资格。"))
				if(!do_after(user, 30, INTERRUPT_ALL, BUSY_ICON_FRIENDLY))
					return

			S.heal_damage(0, 15, TRUE)
			H.pain.recalculate_pain()
			user.visible_message(SPAN_DANGER("[user]用[src]修复了[M]的[S.display_name]上的部分烧伤。"))
			return
		else
			to_chat(user, "没有需要修复的损伤！")

	else
		return ..()

// Medical purposes for synths
/obj/item/stack/cable_coil/ai_can_use(mob/living/carbon/human/user, datum/human_ai_brain/ai_brain, mob/living/carbon/human/target)
	if(!issynth(target))
		return FALSE

	for(var/obj/limb/limb as anything in target.limbs)
		for(var/datum/wound/wound in limb.wounds)
			if(wound.internal || (wound.damage_type == BRUTE))
				continue

			return TRUE

	return FALSE

/obj/item/stack/cable_coil/ai_use(mob/living/carbon/human/user, datum/human_ai_brain/ai_brain, mob/living/carbon/human/target)
	user.a_intent_change(INTENT_HELP)

	for(var/obj/limb/limb as anything in target.limbs)
		if(QDELETED(src))
			return

		for(var/datum/wound/wound in limb.wounds)
			if(wound.internal || (wound.damage_type == BRUTE))
				continue

			if(QDELETED(src))
				return

			user.zone_selected = limb.name
			attack(target, user)
			sleep(ai_brain.short_action_delay * ai_brain.action_delay_mult)
