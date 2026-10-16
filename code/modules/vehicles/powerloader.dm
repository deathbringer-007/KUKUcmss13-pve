/obj/vehicle/powerloader
	name = "\improper 卡特彼勒P-5000动力装载机"
	icon = 'icons/obj/vehicles/powerloader.dmi'
	desc = "卡特彼勒P-5000动力装载机是一种用于搬运重型材料和物件的商用机械外骨骼，最初由维兰德公司于2025年1月29日设计。它虽已老旧，但可靠耐用，广泛用于仓库、建筑工地和军舰。"
	icon_state = "powerloader_open"
	layer = POWERLOADER_LAYER //so the top appears above windows and wall mounts
	anchored = TRUE
	density = TRUE
	move_delay = 8
	buckling_y = 9
	health = 200
	maxhealth = 200
	pixel_x = -16
	pixel_y = -2
	var/base_state = "powerloader"
	var/open_state = "powerloader_open"
	var/overlay_state = "powerloader_overlay"
	var/wreckage = /obj/structure/powerloader_wreckage
	var/obj/item/powerloader_clamp/PC_left
	var/obj/item/powerloader_clamp/PC_right

//--------------------GENERAL PROCS-----------------

/obj/vehicle/powerloader/Initialize()
	cell = new /obj/item/cell/apc
	PC_left = new(src)
	PC_left.name = "\improper 动力装载机左液压夹爪"
	PC_left.linked_powerloader = src
	PC_right = new(src)
	PC_right.name = "\improper 动力装载机右液压夹爪"
	PC_right.linked_powerloader = src
	PC_right.is_right = TRUE
	PC_right.icon_state = "loader_clamp_right"

	. = ..()

/obj/vehicle/powerloader/Destroy()
	qdel(PC_left)
	PC_left = null
	qdel(PC_right)
	PC_right = null
	return ..()

/obj/vehicle/powerloader/relaymove(mob/user, direction)
	if(user.is_mob_incapacitated())
		return
	if(world.time > l_move_time + move_delay)
		if(dir != direction)
			l_move_time = world.time
			setDir(direction)
			handle_rotation()
			pick(playsound(src.loc, 'sound/mecha/powerloader_turn.ogg', 25, 1), playsound(src.loc, 'sound/mecha/powerloader_turn2.ogg', 25, 1))
			. = TRUE
		else
			. = step(src, direction)
			if(.)
				pick(playsound(loc, 'sound/mecha/powerloader_step.ogg', 25), playsound(loc, 'sound/mecha/powerloader_step2.ogg', 25))

/obj/vehicle/powerloader/handle_rotation()
	if(buckled_mob)
		buckled_mob.setDir(dir)
		switch(dir)
			if(EAST)
				buckled_mob.pixel_x = 7
			if(WEST)
				buckled_mob.pixel_x = -7
			else
				buckled_mob.pixel_x = 0

/obj/vehicle/powerloader/explode()
	new wreckage(loc)
	playsound(loc, 'sound/effects/metal_crash.ogg', 75)
	..()

//--------------------INTERACTION PROCS-----------------

/obj/vehicle/powerloader/get_examine_text(mob/user)
	. = ..()
	if(PC_left)
		. += PC_left.get_examine_text(user, TRUE)
	if(PC_right)
		. += PC_right.get_examine_text(user, TRUE)

/obj/vehicle/powerloader/attack_hand(mob/user)
	if(buckled_mob && user != buckled_mob)
		buckled_mob.visible_message(SPAN_WARNING("[user]试图把[buckled_mob]从[src]中拉出来。"),\
		SPAN_DANGER("[user]试图把你从[src]中拉出来！"))
		var/oldloc = loc
		var/olddir = dir
		var/old_buckled_mob = buckled_mob
		if(do_after(user, 30, INTERRUPT_ALL, BUSY_ICON_HOSTILE) && dir == olddir && loc == oldloc && buckled_mob == old_buckled_mob)
			manual_unbuckle(user)
			playsound(loc, 'sound/mecha/powerloader_unbuckle.ogg', 25)

/obj/vehicle/powerloader/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/powerloader_clamp))
		var/obj/item/powerloader_clamp/PC = W
		if(PC.linked_powerloader == src)
			unbuckle() //clicking the powerloader with its own clamp unbuckles the pilot.
			playsound(loc, 'sound/mecha/powerloader_unbuckle.ogg', 25)
			return 1
	. = ..()

/obj/vehicle/powerloader/buckle_mob(mob/M, mob/user)
	if(M != user)
		return
	if(!ishuman(M))
		return
	var/mob/living/carbon/human/H = M
	if(!skillcheck(user, SKILL_POWERLOADER, SKILL_POWERLOADER_TRAINED))
		to_chat(H, SPAN_WARNING("你似乎不知道如何操作[src]。"))
		return
	if(H.r_hand || H.l_hand)
		to_chat(H, SPAN_WARNING("你需要腾出双手才能操作[src]。"))
		return
	. = ..()

/obj/vehicle/powerloader/afterbuckle(mob/M)
	. = ..()
	overlays.Cut()
	playsound(loc, 'sound/mecha/powerloader_buckle.ogg', 25)
	if(.)
		icon_state = base_state
		overlays += image(icon_state = overlay_state, layer = MOB_LAYER + 0.1)
		if(M.mind && M.skills)
			move_delay = max(4, move_delay - 2 * M.skills.get_skill_level(SKILL_POWERLOADER))
		if(!M.put_in_l_hand(PC_left))
			PC_left.forceMove(src)
			unbuckle()
			return
		else if(!M.put_in_r_hand(PC_right))
			PC_right.forceMove(src)
			unbuckle()
			return
			//can't use the powerloader without both clamps equipped
	else
		move_delay = initial(move_delay)
		icon_state = open_state
		M.drop_held_items() //drop the clamp when unbuckling

//verb
/obj/vehicle/powerloader/verb/enter_powerloader(mob/M)
	set category = "物品"
	set name = "进入动力装载机"
	set src in oview(1)

	buckle_mob(M, usr)

//--------------------POWERLOADER CLAMP-----------------

/obj/item/powerloader_clamp
	name = "\improper 动力装载机液压夹爪"
	icon = 'icons/obj/vehicles/powerloader_clamp.dmi'
	icon_state = "loader_clamp"
	force = 20
	flags_item = ITEM_ABSTRACT //to prevent placing the item on a table/closet.
								//We're controlling the clamp but the item isn't really in our hand.
	var/obj/vehicle/powerloader/linked_powerloader
	var/obj/loaded
	var/is_right = FALSE

//--------------------GENERAL PROCS-----------------

/obj/item/powerloader_clamp/Destroy()
	if(loaded)
		loaded.forceMove(get_turf(src))
	linked_powerloader = null
	return ..()

/obj/item/powerloader_clamp/dropped(mob/user)
	if(!linked_powerloader)
		qdel(src)
	..()
	forceMove(linked_powerloader)
	if(linked_powerloader.buckled_mob && linked_powerloader.buckled_mob == user)
		linked_powerloader.unbuckle() //drop a clamp, you auto unbuckle from the powerloader.

/obj/item/powerloader_clamp/update_icon(icon_tag = "")
	if(loaded)
		if(!icon_tag)
			icon_tag = "big_crate"
	else
		icon_tag = "loader_clamp"
	if(is_right)
		icon_tag += "_right"
	icon_state = icon_tag

//--------------------INTERACTION PROCS-----------------

/obj/item/powerloader_clamp/get_examine_text(mob/user, compact_info = FALSE)
	if(compact_info && loaded)
		return list(SPAN_NOTICE("[icon2html(src, user)] [src.name]正夹着[icon2html(loaded, user)] [SPAN_HELPFUL(loaded.name)]。"))
	else
		. = ..()
		if(loaded)
			. += SPAN_NOTICE("[icon2html(src, user)] [src.name]正夹着[icon2html(loaded, user)] [SPAN_HELPFUL(loaded.name)]。")

/obj/item/powerloader_clamp/attack(mob/living/M, mob/living/user)
	if(M == linked_powerloader.buckled_mob)
		unbuckle() //if the pilot clicks themself with the clamp, it unbuckles them.
		return TRUE
	else
		return ..()

/obj/item/powerloader_clamp/afterattack(atom/target, mob/user, proximity)
	if(!proximity)
		return
	if(!linked_powerloader)
		if(!isturf(loc))
			forceMove(get_turf(loc))
		qdel(src)
		return
	if(loaded)
		if(isturf(target))
			var/turf/T = target
			if(!T.density)
				for(var/atom/movable/AM in T.contents)
					if(AM.density)
						to_chat(user, SPAN_WARNING("无法在这里放下[loaded]，[AM]挡住了位置。"))
						return
				if(loaded.bound_height > 32)
					var/turf/next_turf = get_step(T, NORTH)
					if(next_turf.density)
						to_chat(user, SPAN_WARNING("无法在这里放下[loaded]，有东西挡住了位置。"))
						return
					for(var/atom/movable/AM in next_turf.contents)
						if(AM.density)
							to_chat(user, SPAN_WARNING("无法在这里放下[loaded]，[AM]挡住了位置。"))
							return
				if(loaded.bound_width > 32)
					var/turf/next_turf = get_step(T, EAST)
					if(next_turf.density)
						to_chat(user, SPAN_WARNING("无法在这里放下[loaded]，有东西挡住了位置。"))
						return
					for(var/atom/movable/AM in next_turf.contents)
						if(AM.density)
							to_chat(user, SPAN_WARNING("无法在这里放下[loaded]，[AM]挡住了位置。"))
							return

				user.visible_message(SPAN_NOTICE("[user]用[src]将[loaded]放到[T]上。"),
				SPAN_NOTICE("你用[src]将[loaded]放到[T]上。"))
				loaded.forceMove(T)
				playsound(src, 'sound/machines/hydraulics_1.ogg', 40, 1)

				if(istype(loaded, /obj/structure/bed/chair))
					var/obj/structure/bed/chair/chair_stack = loaded
					chair_stack.dir = user.dir
					chair_stack.update_overlays()
					//skill reduces the chance of collapse
					if(chair_stack.stacked_size > 8 && prob(50 / user.skills.get_skill_level(SKILL_POWERLOADER)))
						chair_stack.stack_collapse()

				loaded = null
				update_icon()
				return

	if(isturf(target))
		return

	for(var/obj/effect/xenomorph/acid/A in get_turf(target))
		if(A.acid_t == target)
			to_chat(src, SPAN_WARNING("[target]正在滋滋作响的酸液中熔化。试图夹起它会损坏[src]。"))
			return

	var/load_target_tag = ""

	if(istype(target, /obj/structure/closet/crate))
		var/obj/structure/closet/crate/C = target
		if(C.anchored || C.store_mobs)
			to_chat(user, SPAN_WARNING("[src]无法夹起[target]。"))
			return
		for(var/X in C)
			if(ismob(X)) //just in case.
				to_chat(user, SPAN_WARNING("[src]无法夹起[target]，里面有生物！"))
				return
		load_target_tag = "crate"

	else if(istype(target, /obj/structure/largecrate))
		var/obj/structure/largecrate/LC = target
		if(LC.anchored)
			to_chat(user, SPAN_WARNING("[src]无法夹起[target]，它似乎固定在地面上。"))
			return
		load_target_tag = "big_crate"

	else if(istype(target, /obj/structure/reagent_dispensers))
		var/obj/structure/reagent_dispensers/RD = target
		if(RD.anchored)
			to_chat(user, SPAN_WARNING("[src]无法夹起[target]，它固定在地面上。"))
			return
		if(RD.reagents && RD.reagents.total_volume > 0)
			for(var/datum/reagent/R in RD.reagents.reagent_list)
				if(initial(R.name) != "Water" && initial(R.name) != "Beer")
					to_chat(user, SPAN_WARNING("没有先排空[RD]就用[linked_powerloader]搬运它是不安全的。"))
					return
		load_target_tag = "reagent_dispenser"

	else if(istypestrict(target, /obj/structure/machinery/floodlight))
		var/obj/structure/machinery/floodlight/FD = target
		if(FD.anchored)
			to_chat(user, SPAN_WARNING("[FD]固定在地面上，你需要先用[SPAN_HELPFUL("扳手")]松开固定螺栓，才能用[src]夹起它。"))
			return
		load_target_tag = "floodlight"

	if(!load_target_tag)
		return
	grab_object(user, target, load_target_tag)

//a bit unsafe proc
/obj/item/powerloader_clamp/proc/grab_object(mob/user, obj/target, target_tag = "", sound = 'sound/machines/hydraulics_2.ogg')
	if(loaded)
		to_chat(user, SPAN_WARNING("[src]必须空着才能夹起[target]！"))
		return
	if(!linked_powerloader)
		qdel(src)
		return
	loaded = target
	loaded.forceMove(src)
	to_chat(user, SPAN_NOTICE("你用[src]夹起了[target]。"))
	playsound(src, sound, 40, 1)
	update_icon(target_tag)
	target.update_icon()

/obj/item/powerloader_clamp/attack_self(mob/user)
	..()
	if(linked_powerloader)
		linked_powerloader.unbuckle()

//--------------------LOADER WRECKAGE-----------------

/obj/structure/powerloader_wreckage
	name = "\improper 卡特彼勒P-5000动力装载机残骸"
	desc = "某台不幸的动力装载机留下的残骸，已经完全无法修复。"
	icon = 'icons/obj/vehicles/powerloader.dmi'
	icon_state = "wreck"
	density = TRUE
	anchored = FALSE
	opacity = FALSE
	pixel_x = -18
	pixel_y = -5
	health = 100

/obj/structure/powerloader_wreckage/attack_alien(mob/living/carbon/xenomorph/attacking_xeno)
	if(attacking_xeno.a_intent == INTENT_HELP)
		return XENO_NO_DELAY_ACTION

	if(attacking_xeno.mob_size < MOB_SIZE_XENO)
		to_chat(attacking_xeno, SPAN_XENOWARNING("你的体型太小，无法对这辆载具造成明显伤害！"))
		return XENO_NO_DELAY_ACTION

	attacking_xeno.animation_attack_on(src)

	attacking_xeno.visible_message(SPAN_DANGER("[attacking_xeno]抓挠了[src]！"), SPAN_DANGER("你抓挠了[src]！"))
	playsound(attacking_xeno, pick('sound/effects/metalhit.ogg', 'sound/weapons/alien_claw_metal1.ogg', 'sound/weapons/alien_claw_metal2.ogg', 'sound/weapons/alien_claw_metal3.ogg'), 25, 1)

	var/damage = (attacking_xeno.melee_vehicle_damage + rand(-5,5))

	health -= damage

	if(health <= 0)
		deconstruct(FALSE)

	return XENO_NONCOMBAT_ACTION

/obj/structure/powerloader_wreckage/jd
	name = "\improper 约翰迪尔4300动力装载机残骸"
	icon_state = "wreck_jd"

/obj/vehicle/powerloader/jd
	name = "\improper 约翰迪尔4300动力装载机"
	desc = "约翰迪尔4300动力装载机是一种用于搬运重型材料和物件的商用机械外骨骼，以维兰德公司于2025年1月29日最初设计的卡特彼勒P-5000为基础。它虽已老旧，但可靠耐用，广泛用于仓库、建筑工地和军舰。这台采用标志性的绿黄涂装。"
	icon_state = "powerloader_open_jd"
	base_state = "powerloader_jd"
	open_state = "powerloader_open_jd"
	overlay_state = "powerloader_overlay_jd"
	wreckage = /obj/structure/powerloader_wreckage/jd

/obj/structure/powerloader_wreckage/ft
	name = "\improper 雪貂重工Mk4动力装载机残骸"
	icon_state = "wreck_ft"

/obj/vehicle/powerloader/ft
	name = "\improper 雪貂重工Mk4动力装载机"
	desc = "雪貂重工Mk4动力装载机是一种用于搬运重型材料和物件的商用机械外骨骼，以维兰德公司于2025年1月29日最初设计的卡特彼勒P-5000为基础。它虽已老旧，但可靠耐用，广泛用于仓库、建筑工地和军舰。这台采用雪貂重工标志性的蓝白涂装，而该公司已于两年前破产。"
	icon_state = "powerloader_open_ft"
	base_state = "powerloader_ft"
	open_state = "powerloader_open_ft"
	overlay_state = "powerloader_overlay_ft"
	wreckage = /obj/structure/powerloader_wreckage/ft
