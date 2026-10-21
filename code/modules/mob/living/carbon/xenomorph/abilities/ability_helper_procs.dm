//Corrosive acid is consolidated -- it checks for specific castes for strength now, but works identically to each other.
//The acid items are stored in XenoProcs.
/mob/living/carbon/xenomorph/proc/corrosive_acid(atom/O, acid_type, plasma_cost)
	if(!check_state())
		return
	if(!O.Adjacent(src))
		if(istype(O,/obj/item/explosive/plastic))
			var/obj/item/explosive/plastic/E = O
			if(E.plant_target && !E.plant_target.Adjacent(src))
				to_chat(src, SPAN_WARNING("我们够不着[O]。"))
				return
		else
			to_chat(src, SPAN_WARNING("[O]太远了。"))
			return

	if(!isturf(loc) || HAS_TRAIT(src, TRAIT_ABILITY_BURROWED))
		to_chat(src, SPAN_WARNING("我们无法从这里腐蚀[O]！"))
		return

	face_atom(O)

	var/wait_time = 10

	var/turf/turf = get_turf(O)

	for(var/obj/effect/xenomorph/acid/A in turf)
		if(acid_type == A.type && A.acid_t == O)
			to_chat(src, SPAN_WARNING("[A]已经被酸液浸透了。"))
			return

	var/obj/I
	//OBJ CHECK
	if(isobj(O))
		I = O

		wait_time = I.get_applying_acid_time()
		if(wait_time == -1)
			to_chat(src, SPAN_WARNING("我们无法溶解[I]。"))
			return

	//TURF CHECK
	else if(isturf(O))

		if(istype(O, /turf/closed/wall))
			var/turf/closed/wall/wall_target = O
			if(wall_target.acided_hole)
				to_chat(src, SPAN_WARNING("[O]已经被削弱了。"))
				return

		var/dissolvability = turf.can_be_dissolved()
		switch(dissolvability)
			if(0)
				to_chat(src, SPAN_WARNING("我们无法溶解[turf]。"))
				return
			if(1)
				wait_time = 50
			if(2)
				if(acid_type != /obj/effect/xenomorph/acid/strong)
					to_chat(src, SPAN_WARNING("这种[turf.name]太坚固了，我们的弱酸无法将其融化。"))
					return
				wait_time = 100
			else
				return
		if(istype(turf, /turf/closed/wall))
			var/turf/closed/wall/W = turf

			// Direction from wall to the mob generating acid on the wall turf
			var/ambiguous_dir_msg = SPAN_XENOWARNING("我们不确定该朝哪个方向腐蚀[W]。正对它再试一次。")
			var/dir_to = get_dir(src, W)
			switch(dir_to)
				if(WEST, EAST, NORTH, SOUTH)
					W.acided_hole_dir = dir_to
				if(NORTHWEST, NORTHEAST, SOUTHWEST, SOUTHEAST)
					var/turf/closed/wall/wall_north_turf = get_step(W, NORTH)
					var/turf/closed/wall/wall_south_turf = get_step(W, SOUTH)
					var/turf/closed/wall/wall_east_turf = get_step(W, EAST)
					var/turf/closed/wall/wall_west_turf = get_step(W, WEST)
					// When wall is passable from all cardinal directions...
					if(!istype(wall_north_turf) && !istype(wall_south_turf) && !istype(wall_east_turf) && !istype(wall_west_turf))
						// ...don't make an acid hole
						to_chat(src, ambiguous_dir_msg)
						return
					else if(!istype(wall_north_turf) && !istype(wall_south_turf))
						W.acided_hole_dir = dir_to & (NORTH|SOUTH)
					else if(!istype(wall_east_turf) && !istype(wall_west_turf))
						W.acided_hole_dir = dir_to & (EAST|WEST)
					else
						// ...don't make an acid hole for corners bordering other walls
						to_chat(src, ambiguous_dir_msg)
						return

			var/acided_hole_type = W.acided_hole_dir & (EAST|WEST) ? "一个横向通道" : "一个纵向通道"
			to_chat(src, SPAN_XENOWARNING("我们开始积聚足够的酸液，准备在[W]上腐蚀出[acided_hole_type]。"))
		else
			to_chat(src, SPAN_XENOWARNING("我们开始积聚足够的酸液，准备腐蚀穿透[turf]。"))
	else
		to_chat(src, SPAN_WARNING("你无法溶解[O]。"))
		return

	if(!do_after(src, wait_time, INTERRUPT_NO_NEEDHAND, BUSY_ICON_HOSTILE))
		return

	// AGAIN BECAUSE SOMETHING COULD'VE ACIDED THE PLACE
	for(var/obj/effect/xenomorph/acid/A in turf)
		if(acid_type == A.type && A.acid_t == O)
			to_chat(src, SPAN_WARNING("[A]已经被酸液浸透了。"))
			return

	if(HAS_TRAIT(src, TRAIT_ABILITY_BURROWED)) //Checked again to account for people trying to place acid while channeling the burrow ability
		to_chat(src, SPAN_WARNING("我们无法从这里腐蚀[O]！"))
		return

	if(!check_state())
		return

	if(!O || QDELETED(O)) //Some logic.
		return

	if(!check_plasma(plasma_cost))
		return

	if(!O.Adjacent(src) || (I && !isturf(I.loc)))//not adjacent or inside something
		if(istype(O,/obj/item/explosive/plastic))
			var/obj/item/explosive/plastic/E = O
			if(E.plant_target && !E.plant_target.Adjacent(src))
				to_chat(src, SPAN_WARNING("我们够不着[O]。"))
				return
		else
			to_chat(src, SPAN_WARNING("[O]太远了。"))
			return

	use_plasma(plasma_cost)

	var/obj/effect/xenomorph/acid/A = new acid_type(turf, O)

	if(istype(O, /obj/vehicle/multitile))
		var/obj/vehicle/multitile/R = O
		R.take_damage_type(40 / A.acid_delay, "acid", src)
		visible_message(SPAN_XENOWARNING("[src]朝[O]吐出一团团恶心的液体，冒泡的酸液滋滋作响！"), \
			SPAN_XENOWARNING("我们朝[O]吐出一团团恶心的液体，冒泡的酸液滋滋作响！"), null, 5)
		playsound(loc, "sound/bullets/acid_impact1.ogg", 25)
		QDEL_IN(A, 20)
		return

	if(isturf(O))
		A.icon_state += "_wall"

	if(istype(O, /obj/structure) || istype(O, /obj/structure/machinery)) //Always appears above machinery
		A.layer = O.layer + 0.1
	else //If not, appear on the floor or on an item
		A.layer = LOWER_ITEM_LAYER //below any item, above BELOW_OBJ_LAYER (smartfridge)

	A.add_hiddenprint(src)
	A.name += " ([O])"

	if(!isturf(O))
		msg_admin_attack("[src.name] ([src.ckey]) spat acid on [O] in [get_area(src)] ([src.loc.x],[src.loc.y],[src.loc.z]).", src.loc.x, src.loc.y, src.loc.z)
		attack_log += text("\[[time_stamp()]\] <font color='green'>Spat acid on [O]</font>")
	visible_message(SPAN_XENOWARNING("[src]朝[O]喷吐恶心的液体，它在冒泡的酸液下滋滋作响，开始融化！"), \
	SPAN_XENOWARNING("我们朝[O]喷吐恶心的液体，它在冒泡的酸液下滋滋作响，开始融化！"), null, 5)
	playsound(loc, "sound/bullets/acid_impact1.ogg", 25)

/proc/unroot_human(mob/living/carbon/H, trait_source)
	if (!isxeno_human(H))
		return

	REMOVE_TRAIT(H, TRAIT_IMMOBILIZED, trait_source)

	if(ishuman(H))
		var/mob/living/carbon/human/turf = H
		turf.update_xeno_hostile_hud()
	to_chat(H, SPAN_XENOHIGHDANGER("我们又能行动了！"))

/mob/living/carbon/xenomorph/proc/zoom_in()
	if(stat || resting)
		if(is_zoomed)
			is_zoomed = 0
			zoom_out()
			return
		return
	if(is_zoomed)
		return
	if(!client)
		return
	is_zoomed = 1
	client.change_view(viewsize)
	var/viewoffset = 32 * tileoffset
	switch(dir)
		if(NORTH)
			client.pixel_x = 0
			client.pixel_y = viewoffset
		if(SOUTH)
			client.pixel_x = 0
			client.pixel_y = -viewoffset
		if(EAST)
			client.pixel_x = viewoffset
			client.pixel_y = 0
		if(WEST)
			client.pixel_x = -viewoffset
			client.pixel_y = 0

	for (var/datum/action/xeno_action/onclick/toggle_long_range/action in actions)
		action.on_zoom_in()
		return

/mob/living/carbon/xenomorph/proc/zoom_out()
	if(!client)
		return
	client.change_view(GLOB.world_view_size)
	client.pixel_x = 0
	client.pixel_y = 0
	is_zoomed = 0
	// Since theres several ways we can get here, we need to update the ability button state and handle action's specific effects
	for (var/datum/action/xeno_action/onclick/toggle_long_range/action in actions)
		action.on_zoom_out()
		return

/mob/living/carbon/xenomorph/proc/do_acid_spray_cone(turf/turf, spray_type = /obj/effect/xenomorph/spray, range = 3)
	set waitfor = FALSE

	var/facing = get_cardinal_dir(src, turf)
	setDir(facing)

	turf = loc
	for(var/i in 0 to range - 1)
		var/turf/next_turf = get_step(turf, facing)
		var/atom/movable/temp = new/obj/effect/xenomorph/spray()
		var/atom/movable/AM = LinkBlocked(temp, turf, next_turf)
		qdel(temp)
		if(AM)
			AM.acid_spray_act(src)
			return
		turf = next_turf
		var/obj/effect/xenomorph/spray/S = new spray_type(turf, create_cause_data(initial( caste_type), src), hivenumber)
		do_acid_spray_cone_normal(turf, i, facing, S, spray_type)
		sleep(2)

// Normal refers to the mathematical normal
/mob/living/carbon/xenomorph/proc/do_acid_spray_cone_normal(turf/turf, distance, facing, obj/effect/xenomorph/spray/source_spray, spray_type = /obj/effect/xenomorph/spray)
	if(!distance)
		return

	var/obj/effect/xenomorph/spray/left_S = source_spray
	var/obj/effect/xenomorph/spray/right_S = source_spray

	var/normal_dir = turn(facing, 90)
	var/inverse_normal_dir = turn(facing, -90)

	var/turf/normal_turf = turf
	var/turf/inverse_normal_turf = turf

	var/normal_density_flag = FALSE
	var/inverse_normal_density_flag = FALSE

	for(var/i in 1 to distance)
		if(normal_density_flag && inverse_normal_density_flag)
			return

		if(!normal_density_flag)
			var/next_normal_turf = get_step(normal_turf, normal_dir)
			var/atom/A = LinkBlocked(left_S, normal_turf, next_normal_turf)

			if(A)
				A.acid_spray_act()
				normal_density_flag = TRUE
			else
				normal_turf = next_normal_turf
				left_S = new spray_type(normal_turf, create_cause_data(initial(caste_type), src), hivenumber)


		if(!inverse_normal_density_flag)
			var/next_inverse_normal_turf = get_step(inverse_normal_turf, inverse_normal_dir)
			var/atom/A = LinkBlocked(right_S, inverse_normal_turf, next_inverse_normal_turf)

			if(A)
				A.acid_spray_act()
				inverse_normal_density_flag = TRUE
			else
				inverse_normal_turf = next_inverse_normal_turf
				right_S = new spray_type(inverse_normal_turf, create_cause_data(initial(caste_type), src), hivenumber)


/mob/living/carbon/xenomorph/proc/do_acid_spray_line(list/turflist, spray_path = /obj/effect/xenomorph/spray, distance_max = 5)
	if(isnull(turflist))
		return
	var/turf/prev_turf = loc

	var/distance = 0
	for(var/turf/turf in turflist)
		distance++

		if(!prev_turf && length(turflist) > 1)
			prev_turf = get_turf(src)
			continue //So we don't burn the tile we be standin on

		if(turf.density || istype(turf, /turf/open/space))
			break
		if(distance > distance_max)
			break
		var/atom/movable/temp = new spray_path()
		var/atom/movable/blocker = LinkBlocked(temp, prev_turf, turf)
		qdel(temp)
		if(blocker)
			blocker.acid_spray_act(src)
			break

		prev_turf = turf
		new spray_path(turf, create_cause_data(initial(caste_type), src), hivenumber)
		sleep(2)


/mob/living/carbon/xenomorph/proc/xeno_transfer_plasma(atom/A, amount = 50, transfer_delay = 20, max_range = 2)
	if(!istype(A, /mob/living/carbon/xenomorph))
		return
	var/mob/living/carbon/xenomorph/target = A

	if(!check_can_transfer_plasma(target, max_range))
		return

	to_chat(src, SPAN_NOTICE("我们开始将体内的等离子体汇向[target]。"))
	to_chat(target, SPAN_NOTICE("我们感觉到[src]开始向我们输送等离子体。"))
	face_atom(target)
	target.flick_heal_overlay(transfer_delay, COLOR_CYAN)

	if(!do_after(src, transfer_delay, INTERRUPT_ALL, BUSY_ICON_FRIENDLY))
		return

	if(!check_can_transfer_plasma(target, max_range))
		return

	if(plasma_stored < amount)
		amount = plasma_stored //Just use all of it
	use_plasma(amount)
	target.gain_plasma(amount)
	target.xeno_jitter(1 SECONDS)
	to_chat(target, SPAN_XENOWARNING("[src]向我们输送了[amount]点等离子体。我们现在有[target.plasma_stored]点。"))
	to_chat(src, SPAN_XENOWARNING("我们向[target]输送了[amount]点等离子体。我们现在有[plasma_stored]点。"))
	playsound(src, "alien_drool", 25)

/mob/living/carbon/xenomorph/proc/check_can_transfer_plasma(mob/living/carbon/xenomorph/target, max_range)
	if(!check_state())
		return FALSE

	if(target.stat == DEAD)
		to_chat(src, SPAN_WARNING("[target]已经死了！"))
		return FALSE

	if(!isturf(loc))
		to_chat(src, SPAN_WARNING("我们无法从这里输送等离子体！"))
		return FALSE

	if(get_dist(src, target) > max_range)
		to_chat(src, SPAN_WARNING("我们需要靠近[target]。"))
		return FALSE

	if(HAS_TRAIT(target, TRAIT_ABILITY_OVIPOSITOR))
		to_chat(src, SPAN_WARNING("我们无法向坐在产卵器上的女皇输送等离子体。"))
		return FALSE

	if(HAS_TRAIT(target, TRAIT_ABILITY_NO_PLASMA_TRANSFER))
		to_chat(src, SPAN_WARNING("我们无法向[target]输送等离子体。"))
		return FALSE

	if(target.plasma_max == XENO_NO_PLASMA)
		to_chat(src, SPAN_WARNING("[target]不使用等离子体。"))
		return FALSE

	if(target == src)
		to_chat(src, SPAN_WARNING("我们无法向自己输送等离子体！"))
		return FALSE

	return TRUE
