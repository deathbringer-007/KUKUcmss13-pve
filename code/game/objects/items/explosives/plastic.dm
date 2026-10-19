/obj/item/explosive/plastic
	name = "塑性炸药"
	desc = "用于在指定位置开洞，尽量不多开几个洞。"
	gender = PLURAL
	icon = 'icons/obj/items/assemblies.dmi'
	icon_state = "plastic-explosive0"
	item_state = "plasticx"
	flags_item = NOBLUDGEON
	w_class = SIZE_SMALL
	allowed_sensors = list(/obj/item/device/assembly/prox_sensor, /obj/item/device/assembly/signaller, /obj/item/device/assembly/timer)
	max_container_volume = 180
	reaction_limits = list( "max_ex_power" = 260, "base_ex_falloff" = 90, "max_ex_shards" = 64,
							"max_fire_rad" = 6, "max_fire_int" = 26, "max_fire_dur" = 30,
							"min_fire_rad" = 2, "min_fire_int" = 4, "min_fire_dur" = 5
	)

	var/deploying_time = 50
	var/penetration = 1.5 // How much damage adjacent walls receive
	var/timer = 10 // detonation time
	var/min_timer = 10
	var/atom/plant_target = null //which atom the plstique explosive is planted on
	var/overlay_image = "plastic-explosive2"
	var/image/overlay
	var/list/breachable = list(/obj/structure/window, /turf/closed, /obj/structure/machinery/door, /obj/structure/mineral_door , /obj/structure/cargo_container)
	antigrief_protection = TRUE //Should it be checked by antigrief?

	var/req_skill = SKILL_ENGINEER
	var/req_skill_level = SKILL_ENGINEER_NOVICE

/obj/item/explosive/plastic/Destroy()
	disarm()
	return ..()

/obj/item/explosive/plastic/explosion_throw(severity, direction, scatter_multiplier)
	if(active)
		return
	return ..()

/obj/item/explosive/plastic/attack(mob/M as mob, mob/user as mob)
	return FALSE

/obj/item/explosive/plastic/attack_hand(mob/user)
	if(active)
		to_chat(user, SPAN_WARNING("装置正在运行，不能直接捡起[src]！请使用多功能工具！"))
		return
	. = ..()

/obj/item/explosive/plastic/attack_self(mob/user)
	if(!skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_NOVICE))
		to_chat(user, SPAN_WARNING("你似乎不知道如何使用[src]……"))
		return

	. = ..()
	if(customizable && detonator)
		if(istimer(detonator.a_right) || istimer(detonator.a_left))
			detonator.attack_self(user)
		return
	var/new_time = tgui_input_number(usr, "请设置定时器。", "Timer", min_timer, 60, min_timer)
	if(new_time < min_timer)
		new_time = min_timer
	else if(new_time > 60)
		new_time = 60
	timer = new_time
	to_chat(user, SPAN_NOTICE("定时器已设为[timer]秒。"))

/obj/item/explosive/plastic/afterattack(atom/target, mob/user, flag)
	setDir(get_dir(user, target))

	if(user.action_busy || !flag)
		return
	if(!skillcheck(user, req_skill, req_skill_level))
		to_chat(user, SPAN_WARNING("你似乎不知道如何使用[src]……"))
		return
	if(!can_place(user, target))
		return

	if(antigrief_protection && user.faction == FACTION_MARINE && explosive_antigrief_check(src, user))
		to_chat(user, SPAN_WARNING("[name]的安全区防误用装置阻止了你安放它！"))
		msg_admin_niche("[key_name(user)] attempted to prime \a [name] in [get_area(src)] [ADMIN_JMP(src.loc)]")
		return

	user.visible_message(SPAN_WARNING("[user]正试图将[name]安放到[target]上！"),
	SPAN_WARNING("你正试图将[name]安放到[target]上！"))
	if(ismob(target))
		var/mob/M = target
		to_chat(M, FONT_SIZE_HUGE(SPAN_DANGER("[user]正试图将[name]安放到你身上！")))

	if(!do_after(user, deploying_time, INTERRUPT_ALL, BUSY_ICON_HOSTILE, target, INTERRUPT_MOVED, BUSY_ICON_HOSTILE))
		if(!ismob(target))
			disarm()
		return

	user.drop_held_item()
	cause_data = create_cause_data(initial(name), user)
	plant_target = target
	icon_state = overlay_image
	layer = BELOW_MOB_LAYER

	if(!istype(target, /obj/structure/window) && !istype(target, /turf/closed))
		user.drop_held_item()
		target.contents += src
		overlay = image('icons/obj/items/assemblies.dmi', overlay_image)
		overlay.layer = ABOVE_XENO_LAYER
		target.overlays += overlay
	else
		calculate_pixel_offset(user, target)

	if(ismob(target))
		var/mob/M = target
		to_chat(M, FONT_SIZE_HUGE(SPAN_DANGER("[user]将[name]安放到了你身上！")))
		user.attack_log += "\[[time_stamp()]\] <font color='red'> [key_name(user)] successfully planted [name] on [key_name(target)]</font>"
		msg_admin_niche("[key_name(user, user.client)] planted [src.name] on [key_name(target)] with [timer] second fuse")
		log_game("[key_name(user)] planted [src.name] on [key_name(target)] with [timer] second fuse")
	else
		msg_admin_niche("[key_name(user, user.client)] planted [src.name] on [target.name] at ([target.x],[target.y],[target.z] [ADMIN_JMP(target)] with [timer] second fuse")
		log_game("[key_name(user)] planted [src.name] on [target.name] at ([target.x],[target.y],[target.z]) with [timer] second fuse")

	if(customizable)
		user.visible_message(SPAN_WARNING("[user]将[name]安放到了[target]上！"),
		SPAN_WARNING("你将[name]安放到了[target]上！"))
		activate_sensors()
		if(!istimer(detonator.a_right) && !istimer(detonator.a_left))
			icon_state = overlay_image
	else
		user.visible_message(SPAN_WARNING("[user]将[name]安放到了[target]上！"),
		SPAN_WARNING("你将[name]安放到了[target]上！定时器开始从[timer]秒倒数。"))
		active = TRUE
		addtimer(CALLBACK(src, PROC_REF(prime)), timer * 10)

/obj/item/explosive/plastic/attackby(obj/item/W, mob/user)
	if(HAS_TRAIT(W, TRAIT_TOOL_MULTITOOL))
		if(active)
			if(user.action_busy)
				return
			user.visible_message(SPAN_NOTICE("[user]开始拆除[src]。"), \
			SPAN_NOTICE("你开始拆除[src]。"))
			if(!do_after(user, 30, INTERRUPT_NO_NEEDHAND, BUSY_ICON_FRIENDLY))
				user.visible_message(SPAN_WARNING("[user]停止拆除[src]。"), \
					SPAN_WARNING("你停止拆除[src]。"))
				return
			if(!active)//someone beat us to it
				return
			user.visible_message(SPAN_NOTICE("[user]完成了[src]的拆除。"), \
			SPAN_NOTICE("你完成了[src]的拆除。"))
			disarm()
	else
		return ..()

/obj/item/explosive/plastic/pull_response(mob/puller)
	if(active)
		to_chat(puller, SPAN_WARNING("装置正在运行，不能直接抓起[src]！请使用多功能工具！"))
		return FALSE
	return TRUE

/obj/item/explosive/plastic/proc/disarm()
	pixel_x = 0
	pixel_y = 0
	if(plant_target && !istype(plant_target, /obj/structure/window) && !istype(plant_target, /turf/closed))
		plant_target.overlays -= overlay
		qdel(overlay)
		plant_target.contents -= src
		var/turf/plant_turf = get_turf(plant_target)
		if(plant_turf)
			forceMove(plant_turf)
	plant_target = null
	if(customizable)
		if(active) //deactivate
			if(!isigniter(detonator.a_right) && !issignaller(detonator.a_right))
				detonator.a_right.activate()
			if(!isigniter(detonator.a_left) && !issignaller(detonator.a_left))
				detonator.a_left.activate()
	active = FALSE
	update_icon()

/obj/item/explosive/plastic/proc/can_place(mob/user, atom/target)
	if(istype(target, /obj/structure/ladder) || istype(target, /obj/item) || istype(target, /turf/open) || istype(target, /obj/structure/barricade) || istype(target, /obj/structure/closet/crate))
		return FALSE

	if(istype(target, /obj/structure/closet))
		var/obj/structure/closet/C = target
		if(C.opened)
			return FALSE

	//vehicle interior stuff checks
	if(istype(target, /obj/vehicle/multitile))
		return FALSE

	//vehicle interior stuff checks
	if(SSinterior.in_interior(target))
		to_chat(user, SPAN_WARNING("这里太拥挤，无法部署[src]。"))
		return FALSE

	if(istype(target, /obj/effect) || istype(target, /obj/structure/machinery))
		var/obj/O = target
		if(O.unacidable)
			return FALSE

	if(istype(target, /turf/closed/wall))
		var/turf/closed/wall/W = target
		if(W.hull)
			to_chat(user, SPAN_WARNING("你无法将[src]贴到[W]上！"))
			return FALSE

	if(istype(target, /obj/structure/window))
		var/obj/structure/window/W = target
		if(W.not_damageable)
			to_chat(user, SPAN_WARNING("[W]过于坚固，[src]对它毫无作用。")) //On purpose to mimic wall message
			return FALSE

	if(ishuman(target))
		var/mob/living/carbon/human/H = target
		if(user.faction == H.faction)
			to_chat(user, SPAN_WARNING("你疯了吗？！"))
			return FALSE

	if(customizable && assembly_stage < ASSEMBLY_LOCKED)
		return FALSE

	return TRUE

/obj/item/explosive/plastic/proc/calculate_pixel_offset(mob/user, atom/target)
	switch(get_dir(user, target))
		if(NORTH)
			pixel_y = 24
		if(NORTHEAST)
			pixel_y = 24
			pixel_x = 24
		if(EAST)
			pixel_x = 24
		if(SOUTHEAST)
			pixel_x = 24
			pixel_y = -24
		if(SOUTH)
			pixel_y = -24
		if(SOUTHWEST)
			pixel_y = -24
			pixel_x = -24
		if(WEST)
			pixel_x = -24
		if(NORTHWEST)
			pixel_x = -24
			pixel_y = 24

/obj/item/explosive/plastic/prime(force = FALSE)
	if(!force && (!plant_target || QDELETED(plant_target) || !active))
		return
	var/turf/target_turf
	if(!force)
		if(!istype(plant_target, /obj/structure/window) && !istype(plant_target, /turf/closed))
			plant_target.overlays -= overlay
			qdel(overlay)
			plant_target.contents -= src
			forceMove(plant_target)
		if(ismob(plant_target))
			var/mob/M = plant_target
			M.last_damage_data = cause_data

		target_turf = get_turf(plant_target)
	else
		plant_target = loc
		target_turf = get_turf(loc)
	if(customizable)
		if(force)
			. = ..()
		else if(!detonator)
			return
		else if(issignaller(detonator.a_right) || issignaller(detonator.a_left))
			overlays += new /obj/effect/overlay/danger
			layer = INTERIOR_DOOR_LAYER
			addtimer(CALLBACK(src, PROC_REF(delayed_prime), target_turf), 3 SECONDS)
			return
		else
			. = ..()
		if(!QDELETED(src))
			overlays.Cut()
			cell_explosion(target_turf, 60, 30, EXPLOSION_FALLOFF_SHAPE_LINEAR, null, cause_data)
			qdel(src)
		return

	var/datum/cause_data/temp_cause = create_cause_data(cause_data.cause_name, cause_data.weak_mob.resolve())
	plant_target.ex_act(2000, dir, temp_cause)

	for(var/turf/closed/wall/W in orange(1, target_turf))
		if(W.hull)
			continue
		W.ex_act(1000 * penetration, , cause_data)

	for(var/obj/structure/window/W in orange(1, target_turf))
		if(W.not_damageable)
			continue

		W.ex_act(1000 * penetration, , cause_data)

	for(var/obj/structure/machinery/door/D in orange(1, target_turf))
		D.ex_act(1000 * penetration, , cause_data)

	handle_explosion(target_turf, dir, temp_cause)

/obj/item/explosive/plastic/proc/handle_explosion(turf/target_turf, dir, cause_data)
	cell_explosion(target_turf, 120, 30, EXPLOSION_FALLOFF_SHAPE_LINEAR, null, cause_data)
	qdel(src)

/obj/item/explosive/plastic/proc/delayed_prime(turf/target_turf)
	prime(TRUE)

/obj/item/explosive/plastic/custom
	name = "自制塑性炸药"
	desc = "一块自制塑性炸药。"
	icon_state = "custom_plastic_explosive"
	overlay_image = "custom_plastic_explosive_sensing"
	customizable = TRUE
	matter = list("metal" = 7500, "plastic" = 2000) // 2 metal and 1 plastic sheet
	has_blast_wave_dampener = TRUE

/obj/item/explosive/plastic/breaching_charge
	name = "破障炸药"
	desc = "用于破门的爆炸装置，可保护使用者免受冲击，并向另一侧喷射致命弹片。"
	icon_state = "satchel-charge"
	overlay_image = "satchel-active"
	w_class = SIZE_SMALL
	angle = 55
	timer = 3
	min_timer = 3
	penetration = 0.60
	deploying_time = 10
	var/shrapnel_volume = 40
	var/shrapnel_type = /datum/ammo/bullet/shrapnel/metal
	var/explosion_strength = 60

/obj/item/explosive/plastic/breaching_charge/can_place(mob/user, atom/target)
	if(!is_type_in_list(target, breachable))//only items on the list are allowed
		to_chat(user, SPAN_WARNING("你无法将[name]安放到[target]上！"))
		return FALSE

	if(SSinterior.in_interior(target))// vehicle checks again JUST IN CASE
		to_chat(user, SPAN_WARNING("这里太拥挤，无法部署[src]。"))
		return FALSE

	if(istype(target, /obj/structure/window))//no breaching charges on the briefing windows / brig / CIC e.e
		var/obj/structure/window/window = target
		if(window.not_damageable)
			to_chat(user, SPAN_WARNING("[window]过于坚固，[src]对它毫无作用。")) //On purpose to mimic wall message
			return FALSE

	if(istype(target, /turf/closed/wall))
		var/turf/closed/wall/targeted_wall = target
		if(targeted_wall.hull)
			to_chat(user, SPAN_WARNING("你无法将[src]贴到[targeted_wall]上！"))
			return FALSE

	return TRUE

/obj/item/explosive/plastic/breaching_charge/handle_explosion(turf/target_turf, dir, cause_data)
	var/explosion_target = get_step(target_turf, dir)
	create_shrapnel(explosion_target, shrapnel_volume, dir, angle, shrapnel_type, cause_data)
	addtimer(CALLBACK(src, PROC_REF(trigger_explosion), target_turf, dir, cause_data), 1)

/obj/item/explosive/plastic/breaching_charge/proc/trigger_explosion(turf/target_turf, dir, cause_data)
	cell_explosion(target_turf, explosion_strength, explosion_strength, EXPLOSION_FALLOFF_SHAPE_EXPONENTIAL, dir, cause_data)
	qdel(src)

/obj/item/explosive/plastic/breaching_charge/rubber
	name = "X17 防暴炸药"
	desc = "用于破门的爆炸装置，可保护使用者免受冲击。与标准破障炸药不同，X17 会向锥形区域喷射橡胶弹丸，以制服目标而非杀伤。"
	icon_state = "riot-charge"
	overlay_image = "riot-active"
	shrapnel_volume = 20
	shrapnel_type = /datum/ammo/bullet/shrapnel/rubber
	req_skill = SKILL_POLICE
	req_skill_level = SKILL_POLICE_SKILLED
	antigrief_protection = FALSE

/obj/item/explosive/plastic/breaching_charge/plasma
	name = "等离子炸药"
	desc = "外星爆炸装置。谁知道它会干什么。"
	icon_state = "plasma-charge"
	overlay_image = "plasma-active"
	w_class = SIZE_SMALL
	angle = 55
	timer = 5
	min_timer = 5
	penetration = 0.60
	deploying_time = 10
	flags_item = NOBLUDGEON|ITEM_PREDATOR
	shrapnel_volume = 10
	shrapnel_type = /datum/ammo/bullet/shrapnel/plasma
	explosion_strength = 90

/obj/item/explosive/plastic/breaching_charge/plasma/can_place(mob/user, atom/target)
	if(!HAS_TRAIT(user, TRAIT_YAUTJA_TECH))
		to_chat(user, SPAN_WARNING("你不太明白这装置的工作原理……"))
		return FALSE
	. = ..()

