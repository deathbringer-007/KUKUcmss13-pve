#define STATE_STANDARD 0
#define STATE_DISMANTLING 1
#define STATE_WALL 2
#define STATE_REINFORCED_WALL 3
#define STATE_DISPLACED 4

#define STATE_SCREWDRIVER 1
#define STATE_WIRECUTTER 2
#define STATE_METAL 3
#define STATE_PLASTEEL 4
#define STATE_RODS 5

#define GIRDER_UPGRADE_MATERIAL_COST 5

/obj/structure/girder
	icon_state = "girder"
	anchored = TRUE
	density = TRUE
	layer = OBJ_LAYER
	unacidable = FALSE
	debris = list(/obj/item/stack/sheet/metal, /obj/item/stack/sheet/metal)
	var/state = STATE_STANDARD
	var/step_state = STATE_STANDARD
	health = 125
	// To store what type of wall it used to be
	var/original

/obj/structure/girder/initialize_pass_flags(datum/pass_flags_container/PF)
	..()
	if (PF)
		PF.flags_can_pass_all = PASS_THROUGH|PASS_HIGH_OVER_ONLY

/obj/structure/girder/get_examine_text(mob/user)
	. = ..()
	if (health <= 0)
		. += "它坏了，但可以通过焊接修复。"
		return

	switch(state)
		if(STATE_STANDARD)
			if(step_state == STATE_STANDARD)
				. += SPAN_NOTICE("可以用[SPAN_HELPFUL("螺丝刀")]拆解，用[SPAN_HELPFUL("金属")]建造墙壁，或用[SPAN_HELPFUL("塑钢")]建造加固墙。")
				return
		if(STATE_DISMANTLING)
			if(step_state == STATE_SCREWDRIVER)
				. += SPAN_NOTICE("支撑杆已松开，可用[SPAN_HELPFUL("剪线钳")]拆除。")
			else if(step_state == STATE_WIRECUTTER)
				. += SPAN_NOTICE("支撑杆已拆除，可用[SPAN_HELPFUL("撬棍")]撬松，或用[SPAN_HELPFUL("扳手")]拆解。")
			return
		if(STATE_WALL)
			if(step_state == STATE_METAL)
				. += SPAN_NOTICE("金属板已放好，可用[SPAN_HELPFUL("螺丝刀")]固定。")
			else if(step_state == STATE_SCREWDRIVER)
				. += SPAN_NOTICE("金属板已固定，可用[SPAN_HELPFUL("焊炬")]完成施工。")
			return
		if(STATE_REINFORCED_WALL)
			if(step_state == STATE_PLASTEEL)
				. += SPAN_NOTICE("塑钢板已放好，再加入[SPAN_HELPFUL("金属杆")]加固。")
			else if(step_state == STATE_RODS)
				. += SPAN_NOTICE("金属杆已放好，可用[SPAN_HELPFUL("螺丝刀")]固定。")
			else if(step_state == STATE_SCREWDRIVER)
				. += SPAN_NOTICE("塑钢板已固定，可用[SPAN_HELPFUL("焊炬")]完成施工。")
			return
		if(STATE_DISPLACED)
			. += SPAN_NOTICE("它已松脱，可用[SPAN_HELPFUL("撬棍")]重新固定。")

/obj/structure/girder/update_icon()
	. = ..()

	if(!anchored)
		icon_state = "displaced"
	else
		icon_state = "girder"

/obj/structure/girder/attackby(obj/item/W, mob/user)
	for(var/obj/effect/xenomorph/acid/A in src.loc)
		if(A.acid_t == src)
			to_chat(user, "它正在熔化，你无法靠近！")
			return

	if(user.action_busy)
		return TRUE //no afterattack

	if(istype(W, /obj/item/weapon/twohanded/breacher))
		var/obj/item/weapon/twohanded/breacher/current_hammer = W
		if(user.action_busy)
			return
		if(!(HAS_TRAIT(user, TRAIT_SUPER_STRONG) || !current_hammer.really_heavy))
			to_chat(user, SPAN_WARNING("你无法正确使用[current_hammer]！"))
			return

		to_chat(user, SPAN_NOTICE("你开始拆除[src]。"))
		if(!do_after(user, 3 SECONDS, INTERRUPT_ALL_OUT_OF_RANGE, BUSY_ICON_BUILD))
			to_chat(user, SPAN_NOTICE("你停止拆除[src]。"))
			return
		to_chat(user, SPAN_NOTICE("你拆除了[src]。"))

		playsound(loc, 'sound/effects/metal_shatter.ogg', 40, 1)
		dismantle()
		return

	if(istool(W) && !skillcheck(user, SKILL_CONSTRUCTION, SKILL_CONSTRUCTION_TRAINED))
		to_chat(user, SPAN_WARNING("你没有接受过配置[src]的训练……"))
		return TRUE

	if(health > 0)
		if(change_state(W, user))
			return
	else if(iswelder(W))
		if(!HAS_TRAIT(W, TRAIT_TOOL_BLOWTORCH))
			to_chat(user, SPAN_WARNING("你需要更强力的焊炬！"))
			return
		for(var/obj/object in loc)
			if(object.density)
				to_chat(user, SPAN_WARNING("[object]挡住了位置，你无法焊接[src]！"))
				return
		if(do_after(user,30, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
			if(QDELETED(src))
				return
			to_chat(user, SPAN_NOTICE("你将大梁焊接起来！"))
			repair()
			return
	..()

/obj/structure/girder/proc/change_state(obj/item/W, mob/user)
	switch(state)
		if(STATE_STANDARD)
			if(HAS_TRAIT(W, TRAIT_TOOL_SCREWDRIVER))
				playsound(loc, 'sound/items/Screwdriver.ogg', 25, 1)
				to_chat(user, SPAN_NOTICE("开始松开支撑杆。"))
				if(!do_after(user, 40 * user.get_skill_duration_multiplier(SKILL_CONSTRUCTION), INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
					return TRUE
				to_chat(user, SPAN_NOTICE("你松开了支撑杆！"))
				state = STATE_DISMANTLING
				step_state = STATE_SCREWDRIVER
				return TRUE

			else if(istype(W, /obj/item/stack/sheet/metal))
				if(istype(get_area(loc), /area/shuttle))
					to_chat(user, SPAN_WARNING("不行，这片区域要供运输艇与人员通行。"))
					return TRUE

				var/obj/item/stack/sheet/metal/M = W
				to_chat(user, SPAN_NOTICE("你开始往内部结构加入金属板。"))
				if(!do_after(user, 40 * user.get_skill_duration_multiplier(SKILL_CONSTRUCTION), INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
					return TRUE
				if(M.use(GIRDER_UPGRADE_MATERIAL_COST))
					state = STATE_WALL
					step_state = STATE_METAL
					to_chat(user, SPAN_NOTICE("你往内部结构加入了金属板！"))
				else
					to_chat(user, SPAN_NOTICE("金属不足！"))
				return TRUE

			else if(istype(W, /obj/item/stack/sheet/plasteel))
				if(istype(get_area(loc), /area/shuttle))
					to_chat(user, SPAN_WARNING("不行，这片区域要供运输艇与人员通行。"))
					return TRUE

				var/obj/item/stack/sheet/plasteel/P = W
				to_chat(user, SPAN_NOTICE("你开始往内部结构加入塑钢板。"))
				if(!do_after(user, 40 * user.get_skill_duration_multiplier(SKILL_CONSTRUCTION), INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
					return TRUE
				if(P.use(GIRDER_UPGRADE_MATERIAL_COST))
					state = STATE_REINFORCED_WALL
					step_state = STATE_PLASTEEL
					to_chat(user, SPAN_NOTICE("你往内部结构加入了塑钢板！"))
				else
					to_chat(user, SPAN_NOTICE("塑钢不足！"))
				return TRUE

		if(STATE_DISMANTLING)
			return do_dismantle(W, user)
		if(STATE_WALL)
			return do_wall(W, user)
		if(STATE_REINFORCED_WALL)
			return do_reinforced_wall(W, user)
		if(STATE_DISPLACED)
			if(HAS_TRAIT(W, TRAIT_TOOL_CROWBAR))
				var/turf/open/floor = loc
				if(!floor.allow_construction)
					to_chat(user, SPAN_WARNING("大梁必须固定在合适的表面上！"))
					return
				var/obj/structure/tunnel/tunnel = locate(/obj/structure/tunnel) in loc
				if(tunnel)
					to_chat(user, SPAN_WARNING("不能把大梁固定在隧道上！"))
					return
				playsound(loc, 'sound/items/Crowbar.ogg', 25, 1)
				to_chat(user, SPAN_NOTICE("开始固定大梁……"))
				if(!do_after(user, 40 * user.get_skill_duration_multiplier(SKILL_CONSTRUCTION), INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
					return TRUE
				to_chat(user, SPAN_NOTICE("你固定了大梁！"))
				anchored = TRUE
				state = STATE_STANDARD
				step_state = STATE_STANDARD
				update_icon()
				return TRUE
	return FALSE

/obj/structure/girder/proc/do_dismantle(obj/item/W, mob/user)
	if(!(state == STATE_DISMANTLING))
		return FALSE

	else if(HAS_TRAIT(W, TRAIT_TOOL_WIRECUTTERS) && step_state == STATE_SCREWDRIVER)
		playsound(loc, 'sound/items/Wirecutter.ogg', 25, 1)
		to_chat(user, SPAN_NOTICE("开始拆除支撑杆。"))
		if(!do_after(user, 40 * user.get_skill_duration_multiplier(SKILL_CONSTRUCTION), INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
			return TRUE
		to_chat(user, SPAN_NOTICE("你拆除了支撑杆！"))
		step_state = STATE_WIRECUTTER
		return TRUE

	else if(HAS_TRAIT(W, TRAIT_TOOL_CROWBAR) && step_state == STATE_WIRECUTTER)
		playsound(loc, 'sound/items/Crowbar.ogg', 25, 1)
		to_chat(user, SPAN_NOTICE("开始撬松大梁……"))
		if(!do_after(user, 40 * user.get_skill_duration_multiplier(SKILL_CONSTRUCTION), INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
			return TRUE
		to_chat(user, SPAN_NOTICE("你撬松了大梁！"))
		anchored = FALSE
		state = STATE_DISPLACED
		step_state = STATE_STANDARD
		update_icon()
		return TRUE

	else if(HAS_TRAIT(W, TRAIT_TOOL_WRENCH) && step_state == STATE_WIRECUTTER)
		to_chat(user, SPAN_NOTICE("你开始用扳手拆解它。"))
		playsound(loc, 'sound/items/Ratchet.ogg', 25, 1)
		if(!do_after(user, 40 * user.get_skill_duration_multiplier(SKILL_CONSTRUCTION), INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
			return TRUE
		to_chat(user, SPAN_NOTICE("你用扳手拆解了它！"))
		deconstruct(TRUE)

		return TRUE
	return FALSE

/obj/structure/girder/deconstruct(disassembled = TRUE)
	if(disassembled)
		new /obj/item/stack/sheet/metal(loc, 2)
	return ..()

/obj/structure/girder/proc/do_wall(obj/item/W, mob/user)
	if(!(state == STATE_WALL))
		return FALSE

	if(HAS_TRAIT(W, TRAIT_TOOL_SCREWDRIVER) && step_state == STATE_METAL)
		playsound(loc, 'sound/items/Screwdriver.ogg', 25, 1)
		to_chat(user, SPAN_NOTICE("你正在将金属板固定到内部结构上。"))
		if(!do_after(user, 40 * user.get_skill_duration_multiplier(SKILL_CONSTRUCTION), INTERRUPT_NO_NEEDHAND|BEHAVIOR_IMMOBILE, BUSY_ICON_FRIENDLY, src))
			return TRUE
		to_chat(user, SPAN_NOTICE("你将金属板固定到了内部结构上！"))
		step_state = STATE_SCREWDRIVER
		return TRUE

	if(iswelder(W) && step_state == STATE_SCREWDRIVER)
		if(!HAS_TRAIT(W, TRAIT_TOOL_BLOWTORCH))
			to_chat(user, SPAN_WARNING("你需要更强力的焊炬！"))
			return
		var/obj/item/tool/weldingtool/WT = W
		if(WT.remove_fuel(5, user))
			to_chat(user, SPAN_NOTICE("你开始焊接新加的部件。"))
			playsound(loc, 'sound/items/Welder2.ogg', 25, 1)
			if(!do_after(user, 50 * user.get_skill_duration_multiplier(SKILL_CONSTRUCTION), INTERRUPT_NO_NEEDHAND|BEHAVIOR_IMMOBILE, BUSY_ICON_FRIENDLY, src))
				WT.remove_fuel(-5)
				return TRUE
			to_chat(user, SPAN_NOTICE("你焊接好了新加的部件！"))
			playsound(loc, 'sound/items/Welder2.ogg', 25, 1)
			var/turf/T = get_turf(src)
			if(is_mainship_level(z))
				T.PlaceOnTop(/turf/closed/wall/almayer)
				SEND_SIGNAL(user, COMSIG_MOB_CONSTRUCT_WALL, /turf/closed/wall/almayer)
			else
				T.PlaceOnTop(/turf/closed/wall)
				SEND_SIGNAL(user, COMSIG_MOB_CONSTRUCT_WALL, /turf/closed/wall)
			var/obj/effect/alien/weeds/weeds_in_tile = locate(/obj/effect/alien/weeds) in T
			if(weeds_in_tile)
				qdel(weeds_in_tile)
			T.add_fingerprint(user)
			qdel(src)
		return TRUE
	return FALSE

/obj/structure/girder/proc/do_reinforced_wall(obj/item/W, mob/user)
	if(!(state == STATE_REINFORCED_WALL))
		return FALSE

	if(istype(W, /obj/item/stack/rods) && step_state == STATE_PLASTEEL)
		var/obj/item/stack/rods/R = W
		if(R.use(2))
			to_chat(user, SPAN_NOTICE("你加固了连接杆。"))
			step_state = STATE_RODS
		else
			to_chat(user, SPAN_NOTICE("你未能加固连接杆，还需要更多金属杆。"))
		return TRUE

	if(HAS_TRAIT(W, TRAIT_TOOL_SCREWDRIVER) && step_state == STATE_RODS)
		playsound(loc, 'sound/items/Screwdriver.ogg', 25, 1)
		to_chat(user, SPAN_NOTICE("你正在将塑钢板固定到内部结构上。"))
		if(!do_after(user, 40 * user.get_skill_duration_multiplier(SKILL_CONSTRUCTION), INTERRUPT_NO_NEEDHAND|BEHAVIOR_IMMOBILE, BUSY_ICON_FRIENDLY, src))
			return TRUE
		to_chat(user, SPAN_NOTICE("你将塑钢板固定到了内部结构上！"))
		step_state = STATE_SCREWDRIVER
		return TRUE

	if(iswelder(W) && step_state == STATE_SCREWDRIVER)
		if(!HAS_TRAIT(W, TRAIT_TOOL_BLOWTORCH))
			to_chat(user, SPAN_WARNING("你需要更强力的焊炬！"))
			return
		var/obj/item/tool/weldingtool/WT = W
		if(WT.remove_fuel(5, user))
			to_chat(user, SPAN_NOTICE("你开始焊接新加的部件。"))
			playsound(loc, 'sound/items/Welder2.ogg', 25, 1)
			if(!do_after(user, 50 * user.get_skill_duration_multiplier(SKILL_CONSTRUCTION), INTERRUPT_NO_NEEDHAND|BEHAVIOR_IMMOBILE, BUSY_ICON_FRIENDLY, src))
				WT.remove_fuel(-5)
				return TRUE
			to_chat(user, SPAN_NOTICE("你焊接好了新加的部件！"))
			playsound(loc, 'sound/items/Welder2.ogg', 25, 1)
			var/turf/T = get_turf(src)
			if(is_mainship_level(z))
				T.PlaceOnTop(/turf/closed/wall/almayer/reinforced)
			else
				T.PlaceOnTop(/turf/closed/wall/r_wall)
			var/obj/effect/alien/weeds/weeds_in_tile = locate(/obj/effect/alien/weeds) in T
			if(weeds_in_tile)
				qdel(weeds_in_tile)
			T.add_fingerprint(user)
			qdel(src)
		return TRUE

	return FALSE

/obj/structure/girder/bullet_act(obj/projectile/P)
	//Tasers and the like should not damage girders.
	if(P.ammo.damage_type == HALLOSS || P.ammo.damage_type == TOX || P.ammo.damage_type == CLONE || P.damage == 0)
		return FALSE
	var/dmg = 0
	if(P.ammo.damage_type == BURN)
		dmg = P.damage
	else
		dmg = floor(P.damage * 0.5)
	if(dmg)
		take_damage(dmg)
		bullet_ping(P)
	if(health <= 0)
		update_state()
	return TRUE

/obj/structure/girder/proc/take_damage(damage)
	health -= damage
	if(health <= -100)
		qdel(src)
	if(health <= 0)
		update_state()


/obj/structure/girder/proc/dismantle()
	health = 0
	update_state()

/obj/structure/girder/proc/repair()
	health = initial(health)
	update_state()

/obj/structure/girder/proc/update_state()
	if(health <= 0 && density)
		icon_state = "[icon_state]_damaged"
		density = FALSE

	else if(health > 0 && !density)
		var/underscore_position =  findtext(icon_state,"_")
		var/new_state = copytext(icon_state, 1, underscore_position)
		icon_state = new_state
		density = TRUE

/obj/structure/girder/attack_animal(mob/living/simple_animal/user)
	if(user.wall_smash)
		visible_message(SPAN_DANGER("[user]将[src]砸得粉碎！"))
		dismantle()
		return
	return ..()

/obj/structure/girder/ex_act(severity, direction, datum/cause_data/cause_data)
	health -= severity
	if(health <= 0)
		var/location = get_turf(src)
		handle_debris(severity, direction)
		deconstruct(FALSE)
		create_shrapnel(location, rand(2,5), direction, 45, /datum/ammo/bullet/shrapnel/light, cause_data) // Shards go flying
	else
		update_state()

/obj/structure/girder/displaced
	icon_state = "displaced"
	anchored = FALSE
	state = STATE_DISPLACED

/obj/structure/girder/reinforced
	icon_state = "reinforced"
	health = 500


#undef STATE_STANDARD
#undef STATE_DISMANTLING
#undef STATE_WALL
#undef STATE_REINFORCED_WALL

#undef STATE_SCREWDRIVER
#undef STATE_WIRECUTTER
#undef STATE_METAL
#undef STATE_PLASTEEL
#undef STATE_RODS

#undef GIRDER_UPGRADE_MATERIAL_COST
