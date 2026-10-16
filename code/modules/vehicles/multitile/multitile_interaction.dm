
// Special cases abound, handled below or in subclasses
/obj/vehicle/multitile/attackby(obj/item/O, mob/user)
	// Are we trying to install stuff?
	if(istype(O, /obj/item/hardpoint))
		var/obj/item/hardpoint/HP = O
		install_hardpoint(HP, user)
		return

	if(ispowerclamp(O))
		var/obj/item/powerloader_clamp/PC = O
		if(PC.linked_powerloader && PC.loaded && istype(PC.loaded, /obj/item/hardpoint))
			install_hardpoint(PC, user)
			return

	// Are we trying to remove stuff?
	if(HAS_TRAIT(O, TRAIT_TOOL_CROWBAR) || ispowerclamp(O))
		uninstall_hardpoint(O, user)
		return

	// Are we trying to repair the frame?
	if(iswelder(O) || HAS_TRAIT(O, TRAIT_TOOL_WRENCH))
		handle_repairs(O, user)
		return

	// Are we trying to immobilize the vehicle?
	if(istype(O, /obj/item/vehicle_clamp))
		if(clamped)
			to_chat(user, SPAN_WARNING("[src]上已经装有一个[O.name]。"))
			return

		//only can clamp friendly vehicles
		if(!get_target_lock(user.faction_group))
			to_chat(user, SPAN_WARNING("你只能给己方载具安装车轮锁。"))
			return

		if(!skillcheck(user, SKILL_POLICE, SKILL_POLICE_SKILLED))
			to_chat(user, SPAN_WARNING("你不知道该如何使用[O.name]。"))
			return

		for(var/obj/item/hardpoint/locomotion/Loco in hardpoints)
			user.visible_message(SPAN_WARNING("[user]将车轮锁装到了[src]上。"), SPAN_NOTICE("你将车轮锁装到[src]上，并锁定了机构。"))
			attach_clamp(O, user)
			return

		to_chat(user, SPAN_WARNING("没有可供[O.name]锁住的履带或车轮。"))
		return

	// Are we trying to remove a vehicle clamp?
	if(HAS_TRAIT(O, TRAIT_TOOL_SCREWDRIVER))
		if(!clamped)
			return

		user.visible_message(SPAN_WARNING("[user]开始从[src]上拆除车轮锁。"), SPAN_NOTICE("你开始从[src]上拆除车轮锁。"))
		if(skillcheck(user, SKILL_POLICE, SKILL_POLICE_SKILLED))
			if(!do_after(user, 2 SECONDS, INTERRUPT_ALL, BUSY_ICON_BUILD))
				user.visible_message(SPAN_WARNING("[user]停止拆除[src]上的车轮锁。"), SPAN_WARNING("你停止拆除[src]上的车轮锁。"))
				return
			user.visible_message(SPAN_WARNING("[user]迅速拆下了[src]上的车轮锁。"), SPAN_NOTICE("你熟练地解开机构，迅速拆下了[src]上的车轮锁。"))
		else
			if(!do_after(user, 5 SECONDS, INTERRUPT_ALL, BUSY_ICON_BUILD))
				user.visible_message(SPAN_WARNING("[user]停止拆除[src]上的车轮锁。"), SPAN_WARNING("你停止拆除[src]上的车轮锁。"))
				return
			user.visible_message(SPAN_WARNING("[user]笨拙地拆下了[src]上的车轮锁。"), SPAN_NOTICE("你总算解开了车轮锁，将它从[src]上取了下来。"))
		detach_clamp(user)
		return

	//try to fit something in vehicle without getting in ourselves
	if(istype(O, /obj/item/grab) && ishuman(user)) //only humans are allowed to fit dragged stuff inside
		if(user.a_intent == INTENT_HELP)
			var/mob_x = user.x - src.x
			var/mob_y = user.y - src.y
			for(var/entrance in entrances)
				var/entrance_coord = entrances[entrance]
				if(mob_x == entrance_coord[1] && mob_y == entrance_coord[2])
					var/obj/item/grab/G = O
					var/atom/dragged_atom = G.grabbed_thing
					if(istype(/obj/item/explosive/grenade, dragged_atom))
						var/obj/item/explosive/grenade/nade = dragged_atom
						if(!nade.active) //very creative, but no.
							break

					handle_fitting_pulled_atom(user, dragged_atom)
					return
		else
			to_chat(user, SPAN_INFO("使用[SPAN_HELPFUL("帮助")]意图，可将拖拽的物体或生物放入载具，而不让自己进入。"))
			handle_player_entrance(user)
			return

	if(istype(O, /obj/item/explosive/grenade))
		var/obj/item/explosive/grenade/nade = O
		if(nade.antigrief_protection && user.faction == FACTION_MARINE && explosive_antigrief_check(nade, user))
			to_chat(user, SPAN_WARNING("[nade.name]的安全区域事故抑制器阻止了你激活手榴弹！"))
			// Let staff know, in case someone's actually about to try to grief
			msg_admin_niche("[key_name(user)] attempted to prime \a [nade.name] in [get_area(src)] [ADMIN_JMP(src.loc)]")
			return
		if(door_locked && health > 0 && (!allowed(user) || !get_target_lock(user.faction_group)))
			to_chat(user, SPAN_WARNING("[src]锁着！"))
			return

		var/mob_x = user.x - x
		var/mob_y = user.y - y
		var/entrance_used = null
		for(var/entrance in entrances)
			var/entrance_coord = entrances[entrance]
			if(mob_x == entrance_coord[1] && mob_y == entrance_coord[2])
				entrance_used = entrance
				break
		if(entrance_used) //if we are at a door, throw it in, else do nothing.
			user.visible_message(SPAN_WARNING("[user]摆好姿势，准备将[nade]从[src]的舱门扔进去。"),
			SPAN_WARNING("你摆好姿势，准备将[nade]从[src]的舱门扔进去。"))
			if(!do_after(user, 1 SECONDS, INTERRUPT_ALL, BUSY_ICON_HOSTILE))
				return
			if(mob_x != user.x - x || mob_y != user.y - y)
				return

			user.visible_message(SPAN_WARNING("[user]将[nade]从[src]的舱门扔了进去！"),
			SPAN_WARNING("你将[nade]从[src]的舱门扔了进去。"))

			user.drop_held_item()
			interior.enter(nade, entrance_used)
			if(!nade.active)
				nade.activate(user)
		return

	if(istype(O, /obj/item/device/motiondetector))
		if(!interior)
			to_chat(user, SPAN_WARNING("[O]似乎无法确定[src]内部空间的边界。（出现了故障，请告知开发者）"))
			return
		var/obj/item/device/motiondetector/MD = O

		if(!MD.active)
			to_chat(user, SPAN_WARNING("必须先启动[MD]，才能扫描[src]内部。"))
			return

		user.visible_message(SPAN_WARNING("[user]摆弄着对准[src]的[MD]。"), SPAN_NOTICE("你开始重新校准[MD]，准备扫描[src]内部的信号。"))
		if(!do_after(user, 3 SECONDS, INTERRUPT_ALL, BUSY_ICON_GENERIC))
			user.visible_message(SPAN_WARNING("[user]停止摆弄[MD]。"), SPAN_WARNING("你不再尝试扫描[src]内部。"))
			return
		if(get_dist(src, user) > 2)
			to_chat(user, SPAN_WARNING("你离[src]太远了。"))
			return

		user.visible_message(SPAN_WARNING("[user]完成了对[MD]的调整。"), SPAN_NOTICE("你重新校准了[MD]，完成了对[src]内部信号的扫描。"))

		interior.update_passenger_count()

		var/humans_inside = 0
		if(length(interior.role_reserved_slots))
			for(var/datum/role_reserved_slots/RRS in interior.role_reserved_slots)
				humans_inside += RRS.taken
		humans_inside += interior.passengers_taken_slots

		var/msg = ""
		if(humans_inside || interior.xenos_taken_slots)
			msg += "[MD]显示，[src]内[humans_inside ? ("约有[SPAN_HELPFUL(humans_inside)]个阵营不明的信号") : "没有阵营不明的信号"]\
			[interior.xenos_taken_slots ? ("，以及约[SPAN_HELPFUL(interior.xenos_taken_slots)]个异常信号") : ""]。"
			MD.show_blip(user, src)
			playsound(user, pick('sound/items/detector_ping_1.ogg', 'sound/items/detector_ping_2.ogg', 'sound/items/detector_ping_3.ogg', 'sound/items/detector_ping_4.ogg'), 60, FALSE, 7, 2)
			to_chat(user, SPAN_NOTICE(msg))
		else
			playsound(user, 'sound/items/detector.ogg', 60, FALSE, 7, 2)
			to_chat(user, SPAN_WARNING("[MD]没有探测到信号，所以载具应该是空的。理论上如此。"))
		return

	if(user.a_intent != INTENT_HARM)
		handle_player_entrance(user)
		return

	take_damage_type(O.force * 0.05, "blunt", user) //Melee weapons from people do very little damage

// Frame repairs on the vehicle itself
/obj/vehicle/multitile/proc/handle_repairs(obj/item/repairing_item, mob/user)
	if(user.action_busy)
		return

	var/max_hp = initial(health)
	if(health > max_hp)
		health = max_hp
		to_chat(user, SPAN_NOTICE("车体完好无损。"))
		for(var/obj/item/hardpoint/holder/H in hardpoints)
			if(H.health > 0)
				if(!iswelder(repairing_item))
					to_chat(user, SPAN_WARNING("你需要焊接工具才能修复[H.name]。"))
					return
				if(!HAS_TRAIT(repairing_item, TRAIT_TOOL_BLOWTORCH))
					to_chat(user, SPAN_WARNING("你需要功率更大的喷灯！"))
					return
				H.handle_repair(repairing_item, user)
				update_icon()
				return
			else
				to_chat(user, SPAN_WARNING("[H]已经无法修复！"))
				return

	var/repair_message = "结构支撑复位焊接"
	var/sound_file = 'sound/items/weldingtool_weld.ogg'
	var/obj/item/tool/weldingtool/welder

	// For health < 75%, the frame needs welderwork, otherwise wrench
	if(health < max_hp * 0.75)
		if(!iswelder(repairing_item))
			to_chat(user, SPAN_NOTICE("车架损坏得太严重了！试试用[SPAN_HELPFUL("焊枪")]修理。"))
			return

		if(!HAS_TRAIT(repairing_item, TRAIT_TOOL_BLOWTORCH))
			to_chat(user, SPAN_NOTICE("你需要功率更大的喷灯！"))
			return

		welder = repairing_item
		if(!welder.isOn())
			to_chat(user, SPAN_WARNING("必须先打开[welder]！"))
			return

	else
		if(!HAS_TRAIT(repairing_item, TRAIT_TOOL_WRENCH))
			to_chat(user, SPAN_NOTICE("车架结构完好，但有很多松动的螺母和螺栓。试试用[SPAN_HELPFUL("扳手")]紧固。"))
			return

		repair_message = "螺母与螺栓紧固"
		sound_file = 'sound/items/Ratchet.ogg'

	var/amount_fixed_adjustment = user.get_skill_duration_multiplier(SKILL_ENGINEER)
	user.visible_message(SPAN_WARNING("[user]开始对[src]进行[repair_message]。"), SPAN_NOTICE("你开始对[src]进行[repair_message]。"))
	playsound(get_turf(user), sound_file, 25)

	while(health < max_hp)
		if(!(world.time % 3))
			playsound(get_turf(user), sound_file, 25)

		if(!do_after(user, 1 SECONDS, INTERRUPT_ALL, BUSY_ICON_BUILD))
			user.visible_message(SPAN_WARNING("[user]停止了对[src]的[repair_message]。"), SPAN_NOTICE("你停止了对[src]的[repair_message]。车体完整度为[SPAN_HELPFUL(100.0*health/max_hp)]%。"))
			return

		health = min(health + max_hp/100 * (5 / amount_fixed_adjustment), max_hp)
		if(health >= max_hp * 0.50)
			set_light_on(vehicle_light_range && vehicle_light_power)
			light_holder.set_light_on(vehicle_light_range && vehicle_light_power)
			to_chat(user, SPAN_NOTICE("[src]的灯光闪烁着亮了起来！"))

		to_chat(user, SPAN_NOTICE("车体完整度为[SPAN_HELPFUL(100.0*health/max_hp)]%。"))

		if(!welder)
			continue

		welder.remove_fuel(1, user)
		if(welder.get_fuel() < 1)
			user.visible_message(SPAN_WARNING("[user]停止了对[src]的[repair_message]。"), SPAN_NOTICE("你停止了对[src]的[repair_message]。车体完整度为[SPAN_HELPFUL(100.0*health/max_hp)]%。"))
			return
		if(health >= max_hp * 0.75)
			user.visible_message(SPAN_WARNING("[user]完成了对[src]的[repair_message]。"), SPAN_NOTICE("你完成了对[src]的[repair_message]。车架结构现已完好，但仍有很多松动的螺母和螺栓。试试用[SPAN_HELPFUL("扳手")]紧固。"))
			return

	health = initial(health)

	toggle_cameras_status(TRUE)
	update_icon()
	user.visible_message(SPAN_NOTICE("[user]完成了对[src]的[repair_message]。"), SPAN_NOTICE("你完成了对[src]的[repair_message]。车体完整度为[SPAN_HELPFUL(100.0*health/max_hp)]%。"))
	return

//Special case for entering the vehicle without using the verb
/obj/vehicle/multitile/attack_hand(mob/user)
	var/mob_x = user.x - src.x
	var/mob_y = user.y - src.y
	for(var/entrance in entrances)
		var/entrance_coord = entrances[entrance]
		if(mob_x == entrance_coord[1] && mob_y == entrance_coord[2])
			handle_player_entrance(user)
			return
	. = ..()

/obj/vehicle/multitile/attack_ghost(mob/dead/observer/user)
	if(!interior)
		return ..()

	var/turf/middle = interior.get_middle_turf()
	if(!middle)
		return ..()

	user.forceMove(middle)

/obj/vehicle/multitile/attack_alien(mob/living/carbon/xenomorph/X)
	// If they're on help intent, attempt to enter the vehicle
	if(X.a_intent == INTENT_HELP)
		handle_player_entrance(X)
		return XENO_NO_DELAY_ACTION

	// If the vehicle is completely broken, xenos can enter from anywhere
	if(health <= 0)
		handle_player_entrance(X)
		return XENO_NO_DELAY_ACTION

	if(X.mob_size < mob_size_required_to_hit)
		to_chat(X, SPAN_XENOWARNING("我们的体型太小，无法对这辆载具造成明显伤害！"))
		return XENO_NO_DELAY_ACTION

	var/damage = (X.melee_vehicle_damage + rand(-5,5)) * XENO_UNIVERSAL_VEHICLE_DAMAGEMULT

	var/damage_mult = 1
	//Ravs, as designated vehicles fighters do a heckin double damage
	//Queen, being Queen, does x2 damage to discourage blocking her
	if(X.caste == XENO_CASTE_RAVAGER || X.caste == XENO_CASTE_QUEEN)
		damage_mult = 2

	//Frenzy auras stack in a way, then the raw value is multipled by two to get the additive modifier
	if(X.frenzy_aura > 0)
		damage += (X.frenzy_aura * FRENZY_DAMAGE_MULTIPLIER)

	X.animation_attack_on(src)

	//Somehow we will deal no damage on this attack
	if(!damage)
		playsound(X.loc, 'sound/weapons/alien_claw_swipe.ogg', 25, 1)
		X.visible_message(SPAN_DANGER("[X]挥爪拍打[src]，却毫无效果！"), \
		SPAN_DANGER("我们挥爪拍打[src]，却毫无效果！"))
		return XENO_ATTACK_ACTION

	X.visible_message(SPAN_DANGER("[X]挥爪撕抓[src]！"), \
	SPAN_DANGER("我们挥爪撕抓[src]！"))
	playsound(X.loc, pick('sound/effects/metalhit.ogg', 'sound/weapons/alien_claw_metal1.ogg', 'sound/weapons/alien_claw_metal2.ogg', 'sound/weapons/alien_claw_metal3.ogg'), 25, 1)

	take_damage_type(damage * damage_mult, "slash", X)

	healthcheck()
	return XENO_ATTACK_ACTION

//Differentiates between damage types from different bullets
//Applies a linear transformation to bullet damage that will generally decrease damage done
/obj/vehicle/multitile/bullet_act(obj/projectile/P)
	var/dam_type = "bullet"
	var/damage = P.damage
	var/ammo_flags = P.ammo.flags_ammo_behavior | P.projectile_override_flags
	var/penetration = P.ammo.penetration
	var/firer = P.firer

	//IFF bullets magically stop themselves short of hitting friendly vehicles,
	//because both sentries and smartgun users keep trying to shoot through them
	if(P.runtime_iff_group && get_target_lock(P.runtime_iff_group))
		return

	if(ammo_flags & (AMMO_ANTISTRUCT|AMMO_ANTIVEHICLE))
		// Multiplier based on tank railgun relationship, so might have to reconsider multiplier for AMMO_SIEGE in general
		damage = floor(damage*ANTISTRUCT_DMG_MULT_TANK)
	if(ammo_flags & AMMO_ACIDIC)
		dam_type = "acid"

	// trust me bro
	var/pixel_x_offset = 64 + ((P.x - x) * 32)
	if(pixel_x_offset > 0 && (dir == NORTH || dir == SOUTH))
		pixel_x_offset -= 32
	var/pixel_y_offset = 64 + ((P.y - y) * 32)
	if(pixel_y_offset > 0 && (dir == EAST || dir == WEST))
		pixel_y_offset -= 32
	bullet_ping(P, pixel_x_offset, pixel_y_offset)

	take_damage_type(damage * (0.33 + penetration/100), dam_type, firer)

	healthcheck()

//to handle IFF bullets
/obj/vehicle/multitile/proc/get_target_lock(access_to_check)
	if(isnull(access_to_check) || !vehicle_faction)
		return FALSE

	if(!islist(access_to_check))
		return access_to_check == vehicle_faction

	return vehicle_faction in access_to_check

/obj/vehicle/multitile/ex_act(severity)
	take_damage_type(severity * 0.5, "explosive")
	take_damage_type(severity * 0.1, "slash")

	healthcheck()

/obj/vehicle/multitile/on_set_interaction(mob/user)
	RegisterSignal(user, COMSIG_MOB_MOUSEDOWN, PROC_REF(crew_mousedown))
	RegisterSignal(user, COMSIG_MOB_MOUSEDRAG, PROC_REF(crew_mousedrag))
	RegisterSignal(user, COMSIG_MOB_MOUSEUP, PROC_REF(crew_mouseup))

/obj/vehicle/multitile/on_unset_interaction(mob/user)
	UnregisterSignal(user, list(COMSIG_MOB_MOUSEUP, COMSIG_MOB_MOUSEDOWN, COMSIG_MOB_MOUSEDRAG))

	var/obj/item/hardpoint/hardpoint = get_mob_hp(user)
	if(hardpoint)
		SEND_SIGNAL(hardpoint, COMSIG_GUN_INTERRUPT_FIRE) //abort fire when crew leaves

/// Relays crew mouse release to active hardpoint.
/obj/vehicle/multitile/proc/crew_mouseup(datum/source, atom/object, turf/location, control, params)
	SIGNAL_HANDLER
	var/obj/item/hardpoint/hardpoint = get_mob_hp(source)
	if(!hardpoint)
		return

	hardpoint.stop_fire(source, object, location, control, params)

/// Relays crew mouse movement to active hardpoint.
/obj/vehicle/multitile/proc/crew_mousedrag(datum/source, atom/src_object, atom/over_object, turf/src_location, turf/over_location, src_control, over_control, params)
	SIGNAL_HANDLER
	var/obj/item/hardpoint/hardpoint = get_mob_hp(source)
	if(!hardpoint)
		return

	hardpoint.change_target(source, src_object, over_object, src_location, over_location, src_control, over_control, params)

/// Checks for special control keybinds, else relays crew mouse press to active hardpoint.
/obj/vehicle/multitile/proc/crew_mousedown(datum/source, atom/object, turf/location, control, params)
	SIGNAL_HANDLER

	var/list/modifiers = params2list(params)
	if(modifiers[SHIFT_CLICK] || modifiers[MIDDLE_CLICK] || modifiers[RIGHT_CLICK] || modifiers[BUTTON4] || modifiers[BUTTON5]) //don't step on examine, point, etc
		return

	var/seat = get_mob_seat(source)
	switch(seat)
		if(VEHICLE_DRIVER)
			if(modifiers[LEFT_CLICK] && modifiers[CTRL_CLICK])
				activate_horn()
				return
		if(VEHICLE_GUNNER)
			if(modifiers[LEFT_CLICK] && modifiers[ALT_CLICK])
				toggle_gyrostabilizer()
				return

	var/obj/item/hardpoint/hardpoint = get_mob_hp(source)
	if(!hardpoint)
		to_chat(source, SPAN_WARNING("请先选择一个可用挂点。"))
		return

	hardpoint.start_fire(source, object, location, control, params)

/obj/vehicle/multitile/proc/handle_player_entrance(mob/M)
	if(!M || M.client == null) return

	var/mob_x = M.x - src.x
	var/mob_y = M.y - src.y
	var/entrance_used = null
	for(var/entrance in entrances)
		var/entrance_coord = entrances[entrance]
		if(mob_x == entrance_coord[1] && mob_y == entrance_coord[2])
			entrance_used = entrance
			break

	var/enter_time = 0
	// door locks break when hull is destroyed. Xenos enter slower, but their speed is not affected by anything and they ignore locks
	if(isxeno(M))
		enter_time = 3 SECONDS
	else
		if(door_locked && health > 0) //check if lock on and actually works
			if(ishuman(M))
				var/mob/living/carbon/human/user = M
				if(!allowed(user) || !get_target_lock(user.faction_group)) //if we are human, we check access and faction
					to_chat(user, SPAN_WARNING("[src]锁着！"))
					return
			else
				to_chat(M, SPAN_WARNING("[src]锁着！")) //animals are not allowed inside without supervision
				return


	// Only xenos can force their way in without doors, and only when the frame is completely broken
	if(!entrance_used && health > 0)
		return
	else if(!entrance_used && !isxeno(M))
		return

	var/enter_msg = "我们开始爬进[src]……"
	if(health <= 0 && isxeno(M))
		enter_msg = "我们开始撬开松动的装甲板，挤进[src]……"

	// Check if drag anything
	var/atom/dragged_atom
	if(istype(M.get_inactive_hand(), /obj/item/grab))
		var/obj/item/grab/G = M.get_inactive_hand()
		dragged_atom = G.grabbed_thing
	else if(istype(M.get_active_hand(), /obj/item/grab))
		var/obj/item/grab/G = M.get_active_hand()
		dragged_atom = G.grabbed_thing

	if(!enter_time)
		enter_time = entrance_speed
		if(dragged_atom)
			enter_time = 2 SECONDS

	to_chat(M, SPAN_NOTICE(enter_msg))
	if(!do_after(M, enter_time, INTERRUPT_NO_NEEDHAND, BUSY_ICON_GENERIC))
		return

	if(entrance_used)
		var/entrance_coord = entrances[entrance_used]
		mob_x = M.x - src.x
		mob_y = M.y - src.y
		if(mob_x != entrance_coord[1] || mob_y != entrance_coord[2])
			to_chat(M, SPAN_WARNING("[src]移动了！"))
			return

	//Dragged stuff comes with us only if properly waited 2 seconds. No cheating!
	if(dragged_atom)
		dragged_atom = null
		if(istype(M.get_inactive_hand(), /obj/item/grab))
			var/obj/item/grab/G = M.get_inactive_hand()
			dragged_atom = G.grabbed_thing
		else if(istype(M.get_active_hand(), /obj/item/grab))
			var/obj/item/grab/G = M.get_active_hand()
			dragged_atom = G.grabbed_thing

	// Transfer them to the interior
	interior.enter(M, entrance_used)

	// We try to make the dragged thing enter last so that the mob who actually entered takes precedence
	if(dragged_atom)
		var/success = interior.enter(dragged_atom, entrance_used)
		if(!success)
			to_chat(M, SPAN_WARNING("你没能将[dragged_atom]放进[src]，只好将[ismob(dragged_atom) ? "对方" : "它"]留在外面。"))

//try to fit something into the vehicle
/obj/vehicle/multitile/proc/handle_fitting_pulled_atom(mob/living/carbon/human/user, atom/dragged_atom)
	if(!ishuman(user))
		return
	if(door_locked && health > 0 && (!allowed(user) || !get_target_lock(user.faction_group)))
		to_chat(user, SPAN_WARNING("[src]锁着！"))
		return

	var/mob_x = user.x - x
	var/mob_y = user.y - y
	var/entrance_used = null
	for(var/entrance in entrances)
		var/entrance_coord = entrances[entrance]
		if(mob_x == entrance_coord[1] && mob_y == entrance_coord[2])
			entrance_used = entrance
			break

	to_chat(user, SPAN_NOTICE("你开始尝试将[dragged_atom]放进[src]……"))
	if(!do_after(user, 1 SECONDS, INTERRUPT_NO_NEEDHAND, BUSY_ICON_GENERIC))
		return
	if(mob_x != user.x - x || mob_y != user.y - y)
		return

	var/atom/currently_dragged

	if(istype(user.get_inactive_hand(), /obj/item/grab))
		var/obj/item/grab/G = user.get_inactive_hand()
		currently_dragged = G.grabbed_thing
	else if(istype(user.get_active_hand(), /obj/item/grab))
		var/obj/item/grab/G = user.get_active_hand()
		currently_dragged = G.grabbed_thing

	if(currently_dragged != dragged_atom)
		to_chat(user, SPAN_WARNING("你停止将[dragged_atom]放进[src]！"))
		return

	var/success = interior.enter(dragged_atom, entrance_used)
	if(success)
		to_chat(user, SPAN_NOTICE("你成功将[dragged_atom]放进了[src]。"))
	else
		to_chat(user, SPAN_WARNING("你没能将[dragged_atom]放进[src]！它太大了，或是载具内已没有空间！"))
	return

//CLAMP procs, unsafe proc, checks are done before calling it
/obj/vehicle/multitile/proc/attach_clamp(obj/item/vehicle_clamp/O, mob/user)
	user.temp_drop_inv_item(O, 0)
	clamped = TRUE
	move_delay = VEHICLE_SPEED_STATIC
	next_move = world.time + move_delay
	qdel(O)
	update_icon()
	message_admins("[key_name(user)] ([user.job]) attached vehicle clamp to [src]")

/obj/vehicle/multitile/proc/detach_clamp(mob/user)
	clamped = FALSE
	move_delay = initial(move_delay)

	var/obj/item/hardpoint/locomotion/Loco
	for(Loco in hardpoints)
		Loco.on_install(src) //we restore speed respective to wheels/treads if any installed

	next_move = world.time + move_delay
	var/obj/item/vehicle_clamp/O = new(get_turf(src))
	if(user)
		O.forceMove(get_turf(user))
		message_admins("[key_name(user)] ([user.job]) detached vehicle clamp from \the [src]")
	else
		O.forceMove(get_turf(src))
		message_admins("Vehicle clamp was detached from \the [src].")
	update_icon()
