//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:32

/* Tools!
 * Note: Multitools are /obj/item/device
 *
 * Contains:
 * Wrench
 * Screwdriver
 * Wirecutters
 * Blowtorch
 * Crowbar
 */

/*
 * Wrench
 */
/obj/item/tool/wrench
	name = "扳手"
	desc = "用途广泛的扳手。通常就在你手里。"
	icon = 'icons/obj/items/items.dmi'
	icon_state = "wrench"
	pickup_sound = 'sound/handling/wrench_pickup.ogg'
	drop_sound = 'sound/handling/wrench_drop.ogg'
	flags_atom = FPRINT|CONDUCT
	flags_equip_slot = SLOT_WAIST
	force = 5
	throwforce = 7
	w_class = SIZE_SMALL
	matter = list("metal" = 150)
	attack_verb = list("猛击", "痛击", "钝击", "重击")
	inherent_traits = list(TRAIT_TOOL_WRENCH)
	preferred_storage = list(/obj/item/clothing/accessory/storage/tool_webbing = WEAR_ACCESSORY)


/*
 * Screwdriver
 */
/obj/item/tool/screwdriver
	name = "螺丝刀"
	desc = "有了它，你就能拧出一番名堂。"
	icon = 'icons/obj/items/items.dmi'
	icon_state = "screwdriver"
	pickup_sound = 'sound/handling/multitool_pickup.ogg'
	drop_sound = 'sound/handling/screwdriver_drop.ogg'
	flags_atom = FPRINT|CONDUCT
	flags_equip_slot = SLOT_WAIST | SLOT_EAR | SLOT_FACE
	force = 5
	w_class = SIZE_TINY
	throwforce = 5
	throw_speed = SPEED_VERY_FAST
	throw_range = 5
	matter = list("metal" = 75)
	attack_verb = list("刺击")
	flags_item = CAN_DIG_SHRAPNEL
	inherent_traits = list(TRAIT_TOOL_SCREWDRIVER)
	preferred_storage = list(/obj/item/clothing/accessory/storage/tool_webbing = WEAR_ACCESSORY)


/obj/item/tool/screwdriver/Initialize()
	. = ..()
	switch(pick("red","blue","purple","brown","green","cyan","yellow"))
		if ("red")
			icon_state = "screwdriver2"
			item_state = "screwdriver"
		if ("blue")
			icon_state = "screwdriver"
			item_state = "screwdriver_blue"
		if ("purple")
			icon_state = "screwdriver3"
			item_state = "screwdriver_purple"
		if ("brown")
			icon_state = "screwdriver4"
			item_state = "screwdriver_brown"
		if ("green")
			icon_state = "screwdriver5"
			item_state = "screwdriver_green"
		if ("cyan")
			icon_state = "screwdriver6"
			item_state = "screwdriver_cyan"
		if ("yellow")
			icon_state = "screwdriver7"
			item_state = "screwdriver_yellow"

	if (prob(75))
		src.pixel_y = rand(0, 16)
	return



/obj/item/tool/screwdriver/attack(mob/living/carbon/M as mob, mob/living/carbon/user as mob)
	if(!istype(M))
		return ..()
	if(user.zone_selected != "eyes") // && user.zone_selected != "head")
		return ..()
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		var/datum/internal_organ/eyes/E = H.internal_organs_by_name["eyes"]
		if(E)
			var/safety = H.get_eye_protection()
			if(!safety)
				user.visible_message(SPAN_DANGER("[user]用[src]刺向[H]的眼睛！"),
					SPAN_DANGER("你用[src]刺向[H]的眼睛！"))
				E.take_damage(rand(8,20))
	return ..()
/obj/item/tool/screwdriver/tactical
	name = "战术螺丝刀"
	desc = "锋利、哑黑、致命。紧急情况下，它可以代替铅笔成为你的打架武器。"
	force = MELEE_FORCE_TIER_2
	throwforce = MELEE_FORCE_NORMAL

/obj/item/tool/screwdriver/tactical/Initialize()
	. = ..()
	icon_state = "tac_screwdriver"

/*
 * Wirecutters
 */
/obj/item/tool/wirecutters
	name = "剪线钳"
	gender = PLURAL
	desc = "用于剪断电线。"
	icon = 'icons/obj/items/items.dmi'
	icon_state = "cutters"
	item_state = "cutters"
	pickup_sound = 'sound/handling/wirecutter_pickup.ogg'
	drop_sound = 'sound/handling/wirecutter_drop.ogg'
	flags_atom = FPRINT|CONDUCT
	flags_equip_slot = SLOT_WAIST
	force = 6
	throw_speed = SPEED_FAST
	throw_range = 9
	w_class = SIZE_SMALL
	matter = list("metal" = 80)

	attack_verb = list("夹击", "夹剪")
	sharp = IS_SHARP_ITEM_SIMPLE
	edge = 1
	inherent_traits = list(TRAIT_TOOL_WIRECUTTERS)
	preferred_storage = list(/obj/item/clothing/accessory/storage/tool_webbing = WEAR_ACCESSORY)

/obj/item/tool/wirecutters/tactical
	name = "战术剪线钳"
	desc = "这把重型钳子看起来更适合剪带刺铁丝，不过剪电线也一样好用。"
	icon_state = "tac_cutters"

/obj/item/tool/wirecutters/attack(mob/living/carbon/C, mob/user)
	if((C.handcuffed) && (istype(C.handcuffed, /obj/item/restraint/adjustable/cable)))
		user.visible_message("[usr]用[src]剪断了[C]身上的束缚物！",\
		"你用[src]剪断了[C]身上的束缚物！",\
		"你听到了线缆被剪断的声音。")
		C.handcuffed = null
		C.handcuff_update()
		return
	else
		..()

/*
 * Blowtorch
 */
/obj/item/tool/weldingtool
	name = "焊炬"
	icon = 'icons/obj/items/items.dmi'
	icon_state = "welder"
	pickup_sound = 'sound/handling/weldingtool_pickup.ogg'
	drop_sound = 'sound/handling/weldingtool_drop.ogg'
	flags_atom = FPRINT|CONDUCT
	flags_equip_slot = SLOT_WAIST
	var/base_icon_state = ""

	//Amount of OUCH when it's thrown
	force = 3
	throwforce = 5
	throw_speed = SPEED_FAST
	throw_range = 5
	w_class = SIZE_SMALL

	//Cost to make in the autolathe
	matter = list("metal" = 70, "glass" = 30)

	inherent_traits = list(TRAIT_TOOL_BLOWTORCH)

	light_range = 2
	light_power = 2

	//blowtorch specific stuff

	/// Whether or not the blowtorch is off(0), on(1) or currently welding(2)
	var/welding = 0
	/// The max amount of fuel the welder can hold
	var/max_fuel = 40
	/// Used to slowly deplete the fuel when the tool is left on.
	var/weld_tick = 0

	/// Whether you need welding protection to use without eye damage, if it has a welding screen you do not take eye damage
	var/has_welding_screen = TRUE
	preferred_storage = list(/obj/item/clothing/accessory/storage/tool_webbing = WEAR_ACCESSORY)
	flags_human_ai = HEALING_ITEM

/obj/item/tool/weldingtool/Initialize()
	. = ..()
	create_reagents(max_fuel)
	reagents.add_reagent("fuel", max_fuel)
	base_icon_state = initial(icon_state)
	return

/obj/item/tool/weldingtool/Destroy()
	if(welding)
		STOP_PROCESSING(SSobj, src)
	. = ..()

/obj/item/tool/weldingtool/get_examine_text(mob/user)
	. = ..()
	. += "内含[get_fuel()]/[max_fuel]单位燃料！"

/obj/item/tool/weldingtool/process()
	if(QDELETED(src))
		STOP_PROCESSING(SSobj, src)
		return
	if(welding)
		if(++weld_tick >= 20)
			weld_tick = 0
			remove_fuel(1)
	else //should never be happening, but just in case
		toggle(TRUE)

/obj/item/tool/weldingtool/attack(mob/target, mob/user)

	if(ishuman(target))
		var/mob/living/carbon/human/human = target
		var/obj/limb/limb = human.get_limb(user.zone_selected)

		if (!limb) return
		if(!(limb.status & (LIMB_ROBOT|LIMB_SYNTHSKIN)) || user.a_intent != INTENT_HELP)
			return ..()

		if(user.action_busy)
			return
		var/self_fixing = FALSE

		if(human.species.flags & IS_SYNTHETIC && target == user)
			self_fixing = TRUE

		if(limb.brute_dam && welding)
			remove_fuel(1,user)
			if(self_fixing)
				user.visible_message(SPAN_WARNING("[user]开始修补自己[limb.display_name]上的凹痕。"), \
					SPAN_WARNING("你开始小心地修补自己[limb.display_name]上的凹痕，以免失去保修资格。"))
				if(!do_after(user, 30, INTERRUPT_ALL, BUSY_ICON_FRIENDLY))
					return

			limb.heal_damage(15, 0, TRUE)
			human.pain.recalculate_pain()
			human.UpdateDamageIcon()
			user.visible_message(SPAN_WARNING("[user]用[src]修补了[human]的[limb.display_name]上的一些凹痕。"), \
								SPAN_WARNING("你用[src]修补了[human]的[limb.display_name]上的一些凹痕。"))
			return
		else
			to_chat(user, SPAN_WARNING("没有需要修理的地方！"))

	else
		if(ismob(target))
			remove_fuel(1)
		return ..()

/obj/item/tool/weldingtool/afterattack(obj/target, mob/user, proximity)
	if(!proximity)
		return
	if (istype(target, /obj/structure/reagent_dispensers/fueltank) && get_dist(src,target) <= 1)
		if(!welding)
			target.reagents.trans_to(src, max_fuel)
			weld_tick = 0
			user.visible_message(SPAN_NOTICE("[user]为[src]补充燃料。"), \
			SPAN_NOTICE("你为[src]补充燃料。"))
			playsound(src.loc, 'sound/effects/refill.ogg', 25, 1, 3)
		else
			message_admins("[key_name_admin(user)] triggered a fueltank explosion with a blowtorch.")
			log_game("[key_name(user)] triggered a fueltank explosion with a blowtorch.")
			to_chat(user, SPAN_DANGER("你开始焊接燃料罐，在清醒的最后一瞬，你意识到这或许不是个明智之举。"))
			var/obj/structure/reagent_dispensers/fueltank/tank = target
			tank.explode()
		return
	if (welding)
		if(isliving(target))
			var/mob/living/L = target
			L.IgniteMob()


/obj/item/tool/weldingtool/attack_self(mob/user)
	..()
	toggle()

/obj/item/tool/weldingtool/turn_light(mob/user, toggle_on)
	. = ..()
	if(. == NO_LIGHT_STATE_CHANGE)
		return

	set_light_on(toggle_on)

//Returns the amount of fuel in the welder
/obj/item/tool/weldingtool/proc/get_fuel()
	if(!reagents)
		return 0
	return reagents.get_reagent_amount("fuel")


//Removes fuel from the blowtorch. If a mob is passed, it will perform an eyecheck on the mob. This should probably be renamed to use()
/obj/item/tool/weldingtool/proc/remove_fuel(amount = 1, mob/M)
	if(!welding || !check_fuel())
		return 0
	if(get_fuel() >= amount)
		reagents.remove_reagent("fuel", amount)
		check_fuel()
		if(M)
			eyecheck(M)
		return 1
	else
		if(M)
			to_chat(M, SPAN_NOTICE("你需要更多焊接燃料才能完成这项操作。"))
		return 0

//Returns whether or not the blowtorch is currently on.
/obj/item/tool/weldingtool/proc/isOn()
	return src.welding

//Turns off the welder if there is no more fuel (does this really need to be its own proc?)
/obj/item/tool/weldingtool/proc/check_fuel()
	if((get_fuel() <= 0) && welding)
		toggle(TRUE)
		return 0
	return 1


//Toggles the welder off and on
/obj/item/tool/weldingtool/proc/toggle(message = 0)
	var/mob/M
	if(ismob(loc))
		M = loc
	if(!welding)
		if(get_fuel() > 0)
			playsound(loc, 'sound/items/weldingtool_on.ogg', 25)
			welding = 1
			if(M)
				to_chat(M, SPAN_NOTICE("你打开了[src]。"))
			turn_light((M ? M : null), toggle_on = TRUE)
			weld_tick += 8 //turning the tool on does not consume fuel directly, but it advances the process that regularly consumes fuel.
			force = 15
			damtype = "fire"
			icon_state = base_icon_state + "_on"
			w_class = SIZE_LARGE
			heat_source = 3800
			START_PROCESSING(SSobj, src)
		else
			if(M)
				to_chat(M, SPAN_WARNING("[src]需要更多燃料！"))
			return
	else
		playsound(loc, 'sound/items/weldingtool_off.ogg', 25)
		force = 3
		damtype = "brute"
		icon_state = base_icon_state
		welding = 0
		w_class = initial(w_class)
		heat_source = 0
		if(M)
			if(!message)
				to_chat(M, SPAN_NOTICE("你关闭了[src]。"))
			else
				to_chat(M, SPAN_WARNING("[src]熄灭了！"))
			if(M.r_hand == src)
				M.update_inv_r_hand()
			if(M.l_hand == src)
				M.update_inv_l_hand()

		turn_light((M ? M : null), toggle_on = FALSE)

		STOP_PROCESSING(SSobj, src)

//Decides whether or not to damage a player's eyes based on what they're wearing as protection
//Note: This should probably be moved to mob
/obj/item/tool/weldingtool/proc/eyecheck(mob/user)
	if(has_welding_screen || !iscarbon(user))
		return TRUE
	var/safety = user.get_eye_protection()
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		var/datum/internal_organ/eyes/E = H.internal_organs_by_name["eyes"]
		if(!E)
			return
		if(E.robotic == ORGAN_ROBOT)
			return
		switch(safety)
			if(EYE_PROTECTION_FLASH)
				to_chat(user, SPAN_DANGER("你的眼角余光中闪过一道强光。"))
				E.take_damage(rand(0, 1), TRUE)
				if(E.damage > 10)
					E.take_damage(rand(3, 5), TRUE)
			if(EYE_PROTECTION_FLAVOR)
				to_chat(user, SPAN_DANGER("你的眼睛有些刺痛。"))
				E.take_damage(rand(1, 2), TRUE)
				if(E.damage > 8) // dont abuse your funny flavor glasses
					E.take_damage(2, TRUE)
			if(EYE_PROTECTION_NONE)
				to_chat(user, SPAN_WARNING("你的眼睛火辣辣地疼。"))
				E.take_damage(rand(3, 4), TRUE)
				if(E.damage > 10)
					E.take_damage(rand(4, 10), TRUE)
			if(EYE_PROTECTION_NEGATIVE)
				to_chat(user, SPAN_WARNING("你的热成像镜放大了[src]的强光。你的眼睛又痒又痛，像被灼烧一样。"))
				H.AdjustEyeBlur(12,20)
				E.take_damage(rand(12, 16), TRUE)

		if(safety < EYE_PROTECTION_WELDING)
			if (E.damage >= E.min_broken_damage)
				to_chat(H, SPAN_WARNING("你失明了！也许毫无防护地焊接并不是个好主意……"))
				return FALSE
			if (E.damage >= E.min_bruised_damage)
				to_chat(H, SPAN_WARNING("你的视线开始模糊，双眼疼痛难忍！"))
				return FALSE
			if(E.damage > 5)
				to_chat(H, SPAN_WARNING("你的眼睛开始剧烈疼痛。这绝对不是什么好事！"))
				return FALSE

// Medical purposes for synths
/obj/item/tool/weldingtool/ai_can_use(mob/living/carbon/human/user, datum/human_ai_brain/ai_brain, mob/living/carbon/human/target)
	if(!issynth(target) || (get_fuel() <= 0))
		return FALSE

	for(var/obj/limb/limb as anything in target.limbs)
		for(var/datum/wound/wound in limb.wounds)
			if(wound.internal || (wound.damage_type == BURN))
				continue

			return TRUE

	return FALSE

/obj/item/tool/weldingtool/ai_use(mob/living/carbon/human/user, datum/human_ai_brain/ai_brain, mob/living/carbon/human/target)
	user.a_intent_change(INTENT_HELP)
	if(!welding)
		toggle(FALSE)

	for(var/obj/limb/limb as anything in target.limbs)
		if(QDELETED(src))
			return

		for(var/datum/wound/wound in limb.wounds)
			if(wound.internal || (wound.damage_type == BURN))
				continue

			if(QDELETED(src))
				return

			user.zone_selected = limb.name
			attack(target, user)
			sleep(ai_brain.short_action_delay * ai_brain.action_delay_mult)

	if(welding)
		toggle(FALSE)

/obj/item/tool/weldingtool/largetank
	name = "工业焊炬"
	max_fuel = 60
	matter = list("metal" = 70, "glass" = 60)
	icon_state = "welder_c"


/obj/item/tool/weldingtool/hugetank
	name = "大容量工业焊炬"
	max_fuel = 80
	w_class = SIZE_MEDIUM
	matter = list("metal" = 70, "glass" = 120)


/obj/item/tool/weldingtool/experimental
	name = "实验型焊炬"
	max_fuel = 40 //?
	w_class = SIZE_MEDIUM
	matter = list("metal" = 70, "glass" = 120)

	var/last_gen = 0

/obj/item/tool/weldingtool/experimental/proc/fuel_gen()//Proc to make the experimental welder generate fuel, optimized as fuck -Sieve
	var/gen_amount = ((world.time-last_gen)/25)
	reagents += (gen_amount)
	if(reagents > max_fuel)
		reagents = max_fuel

/obj/item/tool/weldingtool/simple
	name = "\improper ME3 手持焊炬"
	desc = "美国殖民地海军陆战队用于野外切割和焊接作业的小型手持焊炬。由于体积小、功率低，与技术人员使用的全尺寸焊炬相比，它的功能较为有限。"
	max_fuel = 5
	has_welding_screen = TRUE
	inherent_traits = list(TRAIT_TOOL_SIMPLE_BLOWTORCH)
	icon_state = "welder_b"

/*
 * Crowbar
 */

/obj/item/tool/crowbar
	name = "撬棍"
	desc = "用于拆除地板和撬开门。"
	icon = 'icons/obj/items/items.dmi'
	icon_state = "crowbar"
	pickup_sound = 'sound/handling/crowbar_pickup.ogg'
	drop_sound = 'sound/handling/crowbar_drop.ogg'
	flags_atom = FPRINT|CONDUCT
	flags_equip_slot = SLOT_WAIST
	force = 5
	throwforce = 7
	item_state = "crowbar"
	w_class = SIZE_SMALL
	matter = list("metal" = 50)

	attack_verb = list("攻击", "猛击", "痛击", "钝击", "重击")
	inherent_traits = list(TRAIT_TOOL_CROWBAR)
	pry_capable = IS_PRY_CAPABLE_CROWBAR
	preferred_storage = list(/obj/item/clothing/accessory/storage/tool_webbing = WEAR_ACCESSORY)

/obj/item/tool/crowbar/ai_can_use(mob/living/carbon/human/user, datum/human_ai_brain/ai_brain)
	return TRUE

/obj/item/tool/crowbar/red
	icon = 'icons/obj/items/items.dmi'
	icon_state = "red_crowbar"
	item_state = "red_crowbar"

/obj/item/tool/crowbar/tactical
	name = "战术撬棍"
	desc = "握着它，你就想突袭一栋满是恐怖分子的联排住宅。也可用作钝器。"
	icon_state = "tac_prybar"
	force = MELEE_FORCE_NORMAL
	throwforce = MELEE_FORCE_NORMAL

/obj/item/maintenance_jack
	name = "\improper K92 维护撬杠"
	desc = "集撬棍、扳手和大型钝器于一身的工具，紧急情况下很有用。可用于解除门锁机构。不过分量可不轻。"
	icon_state = "maintenance_jack"
	item_state = "maintenance_jack"
	hitsound = "swing_hit"
	w_class = SIZE_LARGE
	force = MELEE_FORCE_STRONG
	flags_equip_slot = SLOT_SUIT_STORE
	flags_atom = FPRINT|QUICK_DRAWABLE
	pry_capable = IS_PRY_CAPABLE_FORCE //but not really
	///Whether the Maintenance Jack is on crowbar or wrench mode
	var/crowbar_mode = TRUE //False for wrench mode
	///Whether you need the "super strength" trait to pry open doors
	var/requires_superstrength_pry = TRUE
	///Whether you get the speed penalty from not having engi 3
	var/requires_skills_unbolt = TRUE
	///How long it takes (in seconds) to pry open an airlock
	var/prying_time = 3 SECONDS
	///How long it takes (in seconds) to pry open a resin door
	var/resin_prying_time = 5 SECONDS
	///How long it takes (in seconds) to unbolt an airlock
	var/unbolt_time = 5 SECONDS
	///How long extra will it take (in seconds) people who do not have engi 3 (if requires_skills_unbolt is true)
	var/unskilled_unbolt_time = 15 SECONDS

/obj/item/maintenance_jack/Initialize()
	. = ..()
	RegisterSignal(src, COMSIG_ITEM_ATTACK_AIRLOCK, PROC_REF(handle_airlock_attack))

/obj/item/maintenance_jack/get_examine_text(mob/user)
	. = ..()
	. += SPAN_NOTICE("与维护撬杠交互可切换模式。")
	if(crowbar_mode)
		. += SPAN_NOTICE("当前处于撬棍模式，只要力气够大就能撬开门。说不定这一端还能拿来做手术……")
	else
		. += SPAN_NOTICE("当前处于扳手模式，只要掌握了操作方法就能解除门闩。")

/obj/item/maintenance_jack/attack_self(mob/living/user)
	. = ..()
	playsound(src, 'sound/weapons/punchmiss.ogg', 15, TRUE, 3)
	if(crowbar_mode) //Switch to wrench mode | Remove bolts
		user.visible_message(SPAN_INFO("[user]改变了握持[src]的姿势，准备把它当作扳手使用。"),
		SPAN_NOTICE("你改变了握持[src]的姿势，准备把它当作扳手使用。"))
		crowbar_mode = FALSE
		animate(src, transform = matrix(0, MATRIX_ROTATE), time = 2, easing = EASE_IN)
		animate(transform = matrix(90, MATRIX_ROTATE), time = 1)
		animate(transform = matrix(180, MATRIX_ROTATE), time = 2, easing = EASE_OUT)
		REMOVE_TRAIT(src, TRAIT_TOOL_CROWBAR, TRAIT_SOURCE_INHERENT)
		ADD_TRAIT(src, TRAIT_TOOL_WRENCH, TRAIT_SOURCE_INHERENT)
		return

	//Switch to crowbar mode | Pry open doors if super strong trait
	user.visible_message(SPAN_INFO("[user]改变了握持[src]的姿势，准备把它当作撬棍使用。"),
	SPAN_NOTICE("你改变了握持[src]的姿势，准备把它当作撬棍使用。"))
	crowbar_mode = TRUE
	animate(src, transform = matrix(180, MATRIX_ROTATE), time = 2, easing = EASE_IN)
	animate(transform = matrix(270, MATRIX_ROTATE), time = 1)
	animate(transform = matrix(360, MATRIX_ROTATE), time = 2, easing = EASE_OUT)
	REMOVE_TRAIT(src, TRAIT_TOOL_WRENCH, TRAIT_SOURCE_INHERENT)
	ADD_TRAIT(src, TRAIT_TOOL_CROWBAR, TRAIT_SOURCE_INHERENT)

/obj/item/maintenance_jack/proc/handle_airlock_attack(source, obj/structure/machinery/door/airlock/attacked_door, mob/user)
	. = COMPONENT_CANCEL_AIRLOCK_ATTACK
	if(crowbar_mode)
		if(attacked_door.locked) //Bolted
			to_chat(user, SPAN_DANGER("[attacked_door]的门闩已锁定，你无法将其撬开。"))
			return

		if(requires_superstrength_pry)
			if(!HAS_TRAIT(user, TRAIT_SUPER_STRONG)) //basically IS_PRY_CAPABLE_CROWBAR
				return
		if(attacked_door.heavy) //Unopenable
			to_chat(usr, SPAN_DANGER("你无法强行打开[attacked_door]。"))
			return
		if(user.action_busy)
			return
		if(!attacked_door.density && !attacked_door.arePowerSystemsOn()) //If its open and unpowered
			attacked_door.close(TRUE)
			return
		if(attacked_door.density && !attacked_door.arePowerSystemsOn()) // if its closed and unpowered
			attacked_door.open(TRUE)
			return
		if(!attacked_door.density) //If its open
			return

		user.visible_message(SPAN_DANGER("[user]将[src]插入[attacked_door]的门缝，开始撬门。"),
		SPAN_DANGER("你将[src]插入[attacked_door]的门缝，开始撬门。"))
		playsound(src, "pry", 15, TRUE)
		if(!do_after(user, prying_time, INTERRUPT_ALL, BUSY_ICON_HOSTILE))
			return

		if(!attacked_door.density)
			return
		if(attacked_door.locked)
			user.visible_message(SPAN_DANGER("[user]没能用[src]强行打开[attacked_door]。"),
			SPAN_DANGER("你没能用[src]强行打开[attacked_door]。"))
			return

		user.visible_message(SPAN_DANGER("[user]用[src]强行打开了[attacked_door]。"),
		SPAN_DANGER("你用[src]强行打开了[attacked_door]。"))
		attacked_door.open(TRUE)
		return

	//Wrench Mode
	if(!attacked_door.locked)
		to_chat(user, SPAN_NOTICE("这扇门的门闩已经解除了。"))
		return

	if(requires_skills_unbolt)
		if(!skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_MASTER)) //Engi 3 is much faster
			user.visible_message(SPAN_DANGER("[user]开始寻找[attacked_door]的门闩！"),\
			SPAN_NOTICE("你开始寻找[attacked_door]的门闩。"))
			if(!do_after(user, unskilled_unbolt_time, INTERRUPT_ALL, BUSY_ICON_HOSTILE, src, INTERRUPT_ALL)) //Otherwise it takes an extra 15 seconds
				to_chat(user, SPAN_WARNING("你没能找到[attacked_door]的门闩。"))
				return

	user.visible_message(SPAN_DANGER("[user]开始解除[attacked_door]的门闩！"),\
	SPAN_NOTICE("你开始解除[attacked_door]的门闩。"))
	playsound(attacked_door, "pry", 25, TRUE)

	if(!do_after(user, unbolt_time, INTERRUPT_ALL, BUSY_ICON_HOSTILE, src, INTERRUPT_ALL))
		to_chat(user, SPAN_WARNING("你决定不再解除[attacked_door]的门闩。"))
		return

	user.visible_message(SPAN_DANGER("[user]解除了[attacked_door]的门闩。"),\
	SPAN_NOTICE("你解除了[attacked_door]的门闩。"))
	attacked_door.unlock(TRUE)
	return

/obj/item/maintenance_jack/afterattack(atom/attacked_obj, mob/living/user, proximity)
	if(!proximity)
		return

	if(istype(attacked_obj, /obj/structure/mineral_door/resin))
		var/obj/structure/mineral_door/resin/resin_door = attacked_obj

		if(resin_door)
			if(crowbar_mode)
				if(requires_superstrength_pry)
					if(!HAS_TRAIT(user, TRAIT_SUPER_STRONG)) //basically IS_PRY_CAPABLE_CROWBAR
						return ..()
				if(resin_door.isSwitchingStates)
					return
				if(!resin_door.density || user.action_busy || user.a_intent == INTENT_HARM)
					return

				user.visible_message(SPAN_DANGER("[user]将[src]插入[resin_door]的门缝，开始撬门。"),
				SPAN_DANGER("你将[src]插入[resin_door]的门缝，开始撬门。"))
				playsound(user, 'sound/weapons/wristblades_hit.ogg', 15, TRUE)

				if(!do_after(user, resin_prying_time, INTERRUPT_ALL, BUSY_ICON_HOSTILE))
					to_chat(user, SPAN_NOTICE("你停止了撬开[resin_door]的动作。"))
					return

				user.visible_message(SPAN_DANGER("[user]用[src]强行打开了[resin_door]。"),
				SPAN_DANGER("你用[src]强行打开了[resin_door]。"))
				resin_door.open()
				return

	else if(istype(attacked_obj, /turf/open/floor))
		var/turf/open/floor/flooring = attacked_obj

		if(crowbar_mode && user.a_intent == INTENT_HELP) //Only pry flooring on help intent
			if(flooring.hull_floor) //no interaction for hulls
				return
			if(flooring.weeds)
				return attackby(src, user)

			to_chat(user, SPAN_WARNING("你强行撬下了[flooring]，也将它弄坏了。"))
			playsound(src, 'sound/items/Crowbar.ogg', 25, 1)
			flooring.make_plating()
			return
	return ..()
/*
Welding backpack
*/

/obj/item/tool/weldpack
	name = "焊接燃料背包"
	desc = "结实耐用的便携式焊接燃料容器。"
	flags_equip_slot = SLOT_BACK
	icon = 'icons/obj/items/items.dmi'
	icon_state = "welderpack"
	w_class = SIZE_LARGE
	/// More robust liner I guess
	health = 75
	/// placeholder value to be replaced in init
	var/original_health = 1
	/// Because the marine backpack can carry 260, and still allows you to take items, there should be a reason to still use this one.
	var/max_fuel = 600

/obj/item/tool/weldpack/Initialize()
	. = ..()
	create_reagents(max_fuel) //Lotsa refills
	reagents.add_reagent("fuel", max_fuel)
	original_health = health

/obj/item/tool/weldpack/attackby(obj/item/W as obj, mob/user as mob)
	if(iswelder(W))
		var/obj/item/tool/weldingtool/T = W
		if(T.welding & prob(50))
			message_admins("[key_name_admin(user)] triggered a fueltank explosion.")
			log_game("[key_name(user)] triggered a fueltank explosion.")
			to_chat(user, SPAN_DANGER("你这下可犯蠢了。"))
			reagents.source_mob = WEAKREF(user)
			if(reagents.handle_volatiles())
				qdel(src)
			return
		else
			if(T.reagents.total_volume == T.max_fuel)
				to_chat(user, SPAN_NOTICE("[src]已经满了！"))
				return
			if(T.welding)
				to_chat(user, SPAN_DANGER("好险！"))
			src.reagents.trans_to(W, T.max_fuel)
			to_chat(user, SPAN_NOTICE("焊炬燃料已补满！"))
			playsound(src.loc, 'sound/effects/refill.ogg', 25, 1, 3)
			return
	if(istype(W, /obj/item/ammo_magazine/flamer_tank))
		return
	to_chat(user, SPAN_NOTICE("你不知道如何将[W]与[src]配合使用。"))
	return

/obj/item/tool/weldpack/afterattack(obj/target as obj, mob/user as mob, proximity)
	if(!proximity) // this replaces and improves the get_dist(src,target) <= 1 checks used previously
		return
	if(istype(target, /obj/structure/reagent_dispensers))
		if(!(istypestrict(target, /obj/structure/reagent_dispensers/fueltank)))
			to_chat(user, SPAN_NOTICE("必须使用燃料罐为它补充燃料。"))
			return
		if(reagents.total_volume < max_fuel)
			target.reagents.trans_to(src, max_fuel)
			to_chat(user, SPAN_NOTICE("你打开[src]顶部的盖子，用燃料罐将它重新装满。"))
			playsound(loc, 'sound/effects/refill.ogg', 25, 1, 3)
			return
		if (reagents.total_volume >= max_fuel)
			to_chat(user, SPAN_NOTICE("[src]已经满了！"))
			return
	..()

/obj/item/tool/weldpack/get_examine_text(mob/user)
	. = ..()
	. += "还剩[reagents.total_volume]单位焊接燃料！"
	if(original_health > health)
		. += "[src]似乎受损了，自密封内衬已经露了出来。"
	else
		. += "仔细检查后，未发现[src]上有破孔。"

/obj/item/tool/weldpack/bullet_act(obj/projectile/P)
	var/damage = P.damage
	health -= damage
	..()
	healthcheck()
	return 1

/obj/item/tool/weldpack/proc/healthcheck()
	if(health <= 0)
		explode()

/obj/item/tool/weldpack/proc/explode()
	if(reagents.handle_volatiles())
		qdel(src)
	return



/obj/item/tool/weldpack/minitank
	name = "ES-11 燃料罐"
	desc = "坚固的小型加压罐，用于盛装焊接燃料，尺寸足以放入大多数背包。仔细查看可以发现，缠在罐体上的红色胶带印着褪色的文字：“警告：内有高压！请勿刺穿！”"
	icon_state = "welderpackmini"
	/// Just barely enough to be better than the satchel
	max_fuel = 120
	flags_equip_slot = SLOT_WAIST
	w_class = SIZE_MEDIUM
	health = 50
