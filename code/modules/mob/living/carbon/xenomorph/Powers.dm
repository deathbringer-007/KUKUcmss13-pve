/mob/living/carbon/xenomorph/proc/build_resin(atom/A, thick = FALSE, message = TRUE, use_plasma = TRUE, add_build_mod = 1)
	if(!selected_resin)
		return SECRETE_RESIN_FAIL

	var/datum/resin_construction/RC = GLOB.resin_constructions_list[selected_resin]

	var/total_resin_cost = XENO_RESIN_BASE_COST + RC.cost // Live, diet, shit code, repeat

	if(action_busy && !can_stack_builds)
		return SECRETE_RESIN_FAIL
	if(!check_state())
		return SECRETE_RESIN_FAIL
	if(use_plasma && !check_plasma(total_resin_cost))
		return SECRETE_RESIN_FAIL
	if(SSinterior.in_interior(src))
		to_chat(src, SPAN_XENOWARNING("这里太狭窄，无法建造。"))
		return SECRETE_RESIN_FAIL

	if(RC.max_per_xeno != RESIN_CONSTRUCTION_NO_MAX)
		var/current_amount = length(built_structures[RC.build_path])
		if(current_amount >= RC.max_per_xeno)
			to_chat(src, SPAN_XENOWARNING("我们的建筑数量已经达到上限！"))
			return SECRETE_RESIN_FAIL

	var/turf/current_turf = get_turf(A)

	if(extra_build_dist != IGNORE_BUILD_DISTANCE && get_dist(src, A) > src.caste.max_build_dist + extra_build_dist) // Hivelords and eggsac carriers have max_build_dist of 1, drones and queens 0
		to_chat(src, SPAN_XENOWARNING("距离太远，无法建造！"))
		return SECRETE_RESIN_FAIL
	else if(thick) //hivelords can thicken existing resin structures.
		var/thickened = FALSE
		if(istype(A, /turf/closed/wall/resin))
			var/turf/closed/wall/resin/WR = A

			if(istype(A, /turf/closed/wall/resin/weak))
				to_chat(src, SPAN_XENOWARNING("[WR]太过脆弱，无法加固。"))
				return SECRETE_RESIN_FAIL

			for(var/datum/effects/xeno_structure_reinforcement/sf in WR.effects_list)
				to_chat(src, SPAN_XENOWARNING("额外的树脂使我们无法继续加固[WR]，请等效果消退。"))
				return SECRETE_RESIN_FAIL

			if (WR.hivenumber != hivenumber)
				to_chat(src, SPAN_XENOWARNING("[WR]不属于我们的虫巢！"))
				return SECRETE_RESIN_FAIL

			if(WR.type == /turf/closed/wall/resin)
				WR.ChangeTurf(/turf/closed/wall/resin/thick)
				total_resin_cost = XENO_THICKEN_WALL_COST
			else if(WR.type == /turf/closed/wall/resin/membrane)
				WR.ChangeTurf(/turf/closed/wall/resin/membrane/thick)
				total_resin_cost = XENO_THICKEN_MEMBRANE_COST
			else
				to_chat(src, SPAN_XENOWARNING("[WR]无法继续加厚。"))
				return SECRETE_RESIN_FAIL
			thickened = TRUE

		else if(istype(A, /obj/structure/mineral_door/resin))
			var/obj/structure/mineral_door/resin/DR = A
			if (DR.hivenumber != hivenumber)
				to_chat(src, SPAN_XENOWARNING("[DR]不属于我们的虫巢！"))
				return SECRETE_RESIN_FAIL

			for(var/datum/effects/xeno_structure_reinforcement/sf in DR.effects_list)
				to_chat(src, SPAN_XENOWARNING("额外的树脂使我们无法继续加固[DR]，请等效果消退。"))
				return SECRETE_RESIN_FAIL

			if(DR.hardness == 1.5) //non thickened
				var/oldloc = DR.loc
				qdel(DR)
				new /obj/structure/mineral_door/resin/thick (oldloc, DR.hivenumber)
				total_resin_cost = XENO_THICKEN_DOOR_COST
			else
				to_chat(src, SPAN_XENOWARNING("[DR]无法继续加厚。"))
				return SECRETE_RESIN_FAIL
			thickened = TRUE

		if(thickened)
			if(message)
				visible_message(SPAN_XENONOTICE("[src]吐出一团黏稠物质，加厚了[A]。"), \
					SPAN_XENONOTICE("我们吐出一些树脂，加厚[A]，消耗了[total_resin_cost]等离子体。"), null, 5)
				if(use_plasma)
					use_plasma(total_resin_cost)
				playsound(loc, "alien_resin_build", 25)
			A.add_hiddenprint(src) //so admins know who thickened the walls
			return TRUE

	if (!RC.can_build_here(current_turf, src))
		return SECRETE_RESIN_FAIL

	var/wait_time = RC.build_time * caste.build_time_mult * add_build_mod

	var/obj/effect/alien/weeds/alien_weeds = current_turf.weeds
	if(!alien_weeds || alien_weeds.secreting)
		return SECRETE_RESIN_FAIL

	var/obj/warning
	var/succeeded = TRUE
	if(RC.build_overlay_icon)
		warning = new RC.build_overlay_icon(current_turf)

	if(RC.build_animation_effect)
		warning = new RC.build_animation_effect(current_turf)

		switch(wait_time)
			if(1 SECONDS)
				warning.icon_state = "[warning.icon_state]Fast"
			if(4 SECONDS)
				warning.icon_state = "[warning.icon_state]Slow"

		update_icons(warning)

	alien_weeds.secreting = TRUE
	alien_weeds.update_icon()

	if(!do_after(src, wait_time, INTERRUPT_NO_NEEDHAND|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD, alien_weeds))
		succeeded = FALSE

	qdel(warning)

	if(!QDELETED(alien_weeds))
		alien_weeds.secreting = FALSE
		alien_weeds.update_icon()

	if(!succeeded)
		return SECRETE_RESIN_INTERRUPT

	if (!RC.can_build_here(current_turf, src))
		return SECRETE_RESIN_FAIL

	if(use_plasma)
		use_plasma(total_resin_cost)
	if(message)
		visible_message(SPAN_XENONOTICE("[src]吐出一团黏稠物质，将其塑造成[RC.construction_name]！"), \
			SPAN_XENONOTICE("我们吐出一些树脂，将其塑造成[RC.construction_name][use_plasma ? "，共消耗[total_resin_cost]等离子体" : ""]。"), null, 5)
		playsound(loc, "alien_resin_build", 25)

	var/atom/new_resin = RC.build(current_turf, hivenumber, src)
	if(RC.max_per_xeno != RESIN_CONSTRUCTION_NO_MAX)
		LAZYADD(built_structures[RC.build_path], new_resin)
		RegisterSignal(new_resin, COMSIG_PARENT_QDELETING, PROC_REF(remove_built_structure))

	new_resin.add_hiddenprint(src) //so admins know who placed it

	if(istype(new_resin, /turf/closed))
		for(var/mob/living/carbon/human/enclosed_human in new_resin.contents)
			if(enclosed_human.stat == DEAD)
				msg_admin_niche("[src.ckey]/([src]) has built a closed resin structure, [new_resin.name], on top of a dead human, [enclosed_human.ckey]/([enclosed_human]), at [new_resin.x],[new_resin.y],[new_resin.z] [ADMIN_JMP(new_resin)]")

	return SECRETE_RESIN_SUCCESS

/mob/living/carbon/xenomorph/proc/remove_built_structure(atom/A)
	SIGNAL_HANDLER
	LAZYREMOVE(built_structures[A.type], A)
	if(!built_structures[A.type])
		built_structures -= A.type

/mob/living/carbon/xenomorph/proc/place_construction(turf/current_turf, datum/construction_template/xenomorph/structure_template)
	if(!structure_template || !check_state() || action_busy)
		return

	var/current_area_name = get_area_name(current_turf)
	var/obj/effect/alien/resin/construction/new_structure = new(current_turf, hive)
	new_structure.set_template(structure_template)
	hive.add_construction(new_structure)

	var/max_constructions = hive.hive_structures_limit[structure_template.name]
	var/remaining_constructions = max_constructions - hive.get_structure_count(structure_template.name)
	visible_message(SPAN_XENONOTICE("一团黏稠物质从地面涌出，形成了[new_structure]。"), \
		SPAN_XENONOTICE("我们指定建造新的[structure_template]。（剩余可建数量：[remaining_constructions]/[max_constructions]）"), null, 5)
	playsound(new_structure, "alien_resin_build", 25)

	if(hive.living_xeno_queen)
		xeno_message("虫巢：已在[sanitize_area(current_area_name)]指定建造新的<b>[structure_template]<b>！", 3, hivenumber)

/mob/living/carbon/xenomorph/proc/make_marker(turf/target_turf)
	if(!target_turf)
		return FALSE
	var/found_weeds = FALSE
	if(!selected_mark)
		to_chat(src, SPAN_NOTICE("我们必须先选择标记含义，才能创建标记。"))
		hive.mark_ui.open_mark_menu(src)
		return FALSE
	if(target_turf.z != src.z)
		to_chat(src, SPAN_NOTICE("我们的灵能尚未触及那个世界。"))
		return FALSE
	if(!(istype(target_turf)) || target_turf.density)
		return FALSE
	for(var/atom/movable/AM  in target_turf.contents)
		if(istype(AM, /obj/effect/alien/weeds))
			found_weeds = TRUE
		if(AM.density || istype(AM, /obj/effect/alien/resin))
			to_chat(src, SPAN_XENONOTICE("那里没有足够空间放置树脂标记。"))
			return FALSE

	var/obj/effect/alien/resin/marker/NM = new /obj/effect/alien/resin/marker(target_turf, src)
	playsound(target_turf, "alien_resin_build", 25)

	if(!found_weeds)
		to_chat(src, SPAN_XENOMINORWARNING("我们将树脂标记放在了没有菌毯的地面上，若不铺设菌毯，它很快就会损坏。"))

	if(isqueen(src))
		NM.color = "#7a21c4"
	else
		NM.color = "#db6af1"
	if(hive.living_xeno_queen)
		var/current_area_name = get_area_name(target_turf)

		for(var/mob/living/carbon/xenomorph/X in hive.totalXenos)
			to_chat(X, SPAN_XENOANNOUNCE("[src.name]宣告：在[sanitize_area(current_area_name)]，[NM.mark_meaning.desc]！（<a href='byond://?src=\ref[X];overwatch=1;target=\ref[NM]'>观察</a>）（<a href='byond://?src=\ref[X];track=1;target=\ref[NM]'>追踪</a>）"))
			//this is killing the tgui chat and I dont know why
	return TRUE
