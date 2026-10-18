//sensor tower for deser dam. It is there to add the xeno's to the tactical map for marines.

#define SENSORTOWER_BUILDSTATE_WORKING 0
#define SENSORTOWER_BUILDSTATE_BLOWTORCH 1
#define SENSORTOWER_BUILDSTATE_WIRECUTTERS 2
#define SENSORTOWER_BUILDSTATE_WRENCH 3

/obj/structure/machinery/sensortower
	name = "\improper 实验型传感器塔"
	icon = 'icons/obj/structures/machinery/motion_sensor_v2.dmi'
	icon_state = "sensor_broken"
	desc = "装有大量精密传感器的气象监测塔，现已改为追踪生物特征。损坏严重，需要依次用焊枪、剪线钳和扳手修理。"
	anchored = TRUE
	density = TRUE
	unslashable = TRUE
	unacidable = TRUE   //NOPE.jpg
	needs_power = FALSE
	idle_power_usage = 1000
	var/buildstate = SENSORTOWER_BUILDSTATE_BLOWTORCH //What state of building it are we on, 0-3, 1 is "broken", the default
	var/is_on = FALSE  //Is this damn thing on or what?
	var/fail_rate = 15 //% chance of failure each fail_tick check
	var/fail_check_ticks = 50 //Check for failure every this many ticks
	//The sensor tower fails more often since it is experimental.
	var/cur_tick = 0 //Tick updater

	/// weakrefs of xenos temporarily added to the marine minimap
	var/list/minimap_added = list()


/obj/structure/machinery/sensortower/update_icon()
	..()
	if(!buildstate && is_on)
		desc = "装有大量精密传感器的气象监测塔，现已改为追踪生物特征。看起来处于在线状态。"
		icon_state = "sensor_"
	else if (!buildstate && !is_on)
		desc = "装有大量精密传感器的气象监测塔，现已改为追踪生物特征。看起来处于离线状态。"
		icon_state = "sensor_off"
	else if(buildstate == SENSORTOWER_BUILDSTATE_BLOWTORCH)
		desc = "装有大量精密传感器的气象监测塔，现已改为追踪生物特征。损坏严重，需要依次用焊枪、剪线钳和扳手修理。"
		icon_state = "sensor_broken"
	else if(buildstate == SENSORTOWER_BUILDSTATE_WIRECUTTERS)
		desc = "装有大量精密传感器的气象监测塔，现已改为追踪生物特征。损坏严重，需要依次用剪线钳和扳手修理。"
		icon_state = "sensor_broken"
	else if(buildstate == SENSORTOWER_BUILDSTATE_WRENCH)
		desc = "装有大量精密传感器的气象监测塔，现已改为追踪生物特征。损坏严重，需要用扳手修理。"
		icon_state = "sensor_broken"

/obj/structure/machinery/sensortower/process()
	if(!is_on || buildstate || !anchored) //Default logic checking
		remove_xenos_from_minimap()
		return FALSE
	if(inoperable())
		remove_xenos_from_minimap()
		return FALSE
	checkfailure()
	add_xenos_to_minimap()

/obj/structure/machinery/sensortower/proc/remove_xenos_from_minimap()
	for(var/mob/living/carbon/xenomorph/current_xeno as anything in GLOB.living_xeno_list)
		if(WEAKREF(current_xeno) in minimap_added)
			SSminimaps.remove_marker(current_xeno)
			current_xeno.add_minimap_marker()
			minimap_added -= WEAKREF(current_xeno)

/obj/structure/machinery/sensortower/proc/add_xenos_to_minimap()
	for(var/mob/living/carbon/xenomorph/current_xeno as anything in GLOB.living_xeno_list)
		if(WEAKREF(current_xeno) in minimap_added)
			continue

		SSminimaps.remove_marker(current_xeno)
		current_xeno.add_minimap_marker(MINIMAP_FLAG_USCM|get_minimap_flag_for_faction(current_xeno.hivenumber))
		minimap_added += WEAKREF(current_xeno)

/obj/structure/machinery/sensortower/proc/checkfailure()
	cur_tick++
	if(cur_tick < fail_check_ticks) //Nope, not time for it yet
		return FALSE
	else if(cur_tick > fail_check_ticks) //Went past with no fail, reset the timer
		cur_tick = 0
		return FALSE
	if(rand(1,100) < fail_rate) //Oh snap, we failed! Shut it down!
		if(prob(25))
			visible_message("[icon2html(src, viewers(src))] [SPAN_NOTICE("<b>\The [src]</b> 疯狂鸣叫，一根保险丝熔断了！依次使用剪线钳和扳手修理。")]")
			buildstate = SENSORTOWER_BUILDSTATE_WIRECUTTERS
		else
			visible_message("[icon2html(src, viewers(src))] [SPAN_NOTICE("<b>\The [src]</b> 疯狂鸣叫，零件四处飞散！使用扳手修理。")]")
			buildstate = SENSORTOWER_BUILDSTATE_WRENCH
		is_on = FALSE
		update_icon()
		cur_tick = 0
		stop_processing()
		return TRUE
	return FALSE

/obj/structure/machinery/sensortower/attack_hand(mob/user as mob)
	if(!anchored) return FALSE //Shouldn't actually be possible
	if(user.is_mob_incapacitated()) return FALSE
	if(!ishuman(user))
		to_chat(user, SPAN_DANGER("你完全不知道该怎么使用它。")) //No xenos or mankeys
		return FALSE

	add_fingerprint(user)

	if(!skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_TRAINED))
		to_chat(user, SPAN_WARNING("你完全不懂这东西的工作原理……"))
		return FALSE

	if(buildstate == SENSORTOWER_BUILDSTATE_BLOWTORCH)
		to_chat(usr, SPAN_INFO("依次使用焊枪、剪线钳和扳手进行修理。"))
		return FALSE
	else if (buildstate == SENSORTOWER_BUILDSTATE_WIRECUTTERS)
		to_chat(usr, SPAN_INFO("依次使用剪线钳和扳手进行修理。"))
		return FALSE
	else if (buildstate == SENSORTOWER_BUILDSTATE_WRENCH)
		to_chat(usr, SPAN_INFO("使用扳手进行修理。"))
		return FALSE
	if(is_on)
		visible_message("[icon2html(src, viewers(src))] [SPAN_WARNING("[usr] 关闭电源，<b>\The [src]</b> 随之熄灭。")]")
		is_on = FALSE
		cur_tick = 0
		update_icon()
		STOP_PROCESSING(SSslowobj, src)
		remove_xenos_from_minimap()
		return TRUE
	visible_message("[icon2html(src, viewers(src))] [SPAN_WARNING("[usr] 接通电源，<b>\The [src]</b> 随之亮起。")]")
	is_on = TRUE
	cur_tick = 0
	update_icon()
	START_PROCESSING(SSslowobj, src)
	return TRUE

/obj/structure/machinery/sensortower/attackby(obj/item/O as obj, mob/user as mob)
	if(iswelder(O))
		if(!HAS_TRAIT(O, TRAIT_TOOL_BLOWTORCH))
			to_chat(user, SPAN_WARNING("你需要功率更大的焊枪！"))
			return
		if(buildstate == SENSORTOWER_BUILDSTATE_BLOWTORCH && !is_on)
			if(!skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_TRAINED))
				to_chat(user, SPAN_WARNING("你完全不知道该怎么修理这东西。"))
				return FALSE
			var/obj/item/tool/weldingtool/WT = O
			if(WT.remove_fuel(1, user))

				playsound(loc, 'sound/items/weldingtool_weld.ogg', 25)
				user.visible_message(SPAN_NOTICE("[user] 开始焊接 \the [src] 内部受损的部件。"),
				SPAN_NOTICE("你开始焊接 \the [src] 内部受损的部件。"))
				if(do_after(user, 200 * user.get_skill_duration_multiplier(SKILL_ENGINEER), INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
					if(buildstate != SENSORTOWER_BUILDSTATE_BLOWTORCH || is_on || !WT.isOn())
						return FALSE
					playsound(loc, 'sound/items/Welder2.ogg', 25, 1)
					buildstate = SENSORTOWER_BUILDSTATE_WIRECUTTERS
					user.visible_message(SPAN_NOTICE("[user] 焊好了 \the [src] 内部受损的部件。"),
					SPAN_NOTICE("你焊好了 \the [src] 内部受损的部件。"))
					update_icon()
					return TRUE
			else
				to_chat(user, SPAN_WARNING("焊枪燃料不足，无法完成这项工作。"))
				return

	else if(HAS_TRAIT(O, TRAIT_TOOL_WIRECUTTERS))
		if(buildstate == SENSORTOWER_BUILDSTATE_WIRECUTTERS && !is_on)
			if(!skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_TRAINED))
				to_chat(user, SPAN_WARNING("你完全不知道该怎么修理这东西。"))
				return FALSE
			playsound(loc, 'sound/items/Wirecutter.ogg', 25, 1)
			user.visible_message(SPAN_NOTICE("[user] 开始固定 \the [src] 的线路。"),
			SPAN_NOTICE("你开始固定 \the [src] 的线路。"))
			if(do_after(user, 120 * user.get_skill_duration_multiplier(SKILL_ENGINEER), INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD, numticks = 12))
				if(buildstate != SENSORTOWER_BUILDSTATE_WIRECUTTERS || is_on)
					return FALSE
				playsound(loc, 'sound/items/Wirecutter.ogg', 25, 1)
				buildstate = SENSORTOWER_BUILDSTATE_WRENCH
				user.visible_message(SPAN_NOTICE("[user] 固定好了 \the [src] 的线路。"),
				SPAN_NOTICE("你固定好了 \the [src] 的线路。"))
				update_icon()
				return TRUE
	else if(HAS_TRAIT(O, TRAIT_TOOL_WRENCH))
		if(buildstate == SENSORTOWER_BUILDSTATE_WRENCH && !is_on)
			if(!skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_TRAINED))
				to_chat(user, SPAN_WARNING("你完全不知道该怎么修理这东西。"))
				return FALSE
			playsound(loc, 'sound/items/Ratchet.ogg', 25, 1)
			user.visible_message(SPAN_NOTICE("[user] 开始修理 \the [src] 的管路和底板。"),
			SPAN_NOTICE("你开始修理 \the [src] 的管路和底板。"))
			if(do_after(user, 150 * user.get_skill_duration_multiplier(SKILL_ENGINEER), INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
				if(buildstate != SENSORTOWER_BUILDSTATE_WRENCH || is_on)
					return FALSE
				playsound(loc, 'sound/items/Ratchet.ogg', 25, 1)
				buildstate = SENSORTOWER_BUILDSTATE_WORKING
				user.visible_message(SPAN_NOTICE("[user] 修好了 \the [src] 的管路和底板。"),
				SPAN_NOTICE("你修好了 \the [src] 的管路和底板。"))
				update_icon()
				return TRUE
	else
		return ..() //Deal with everything else, like hitting with stuff

/obj/structure/machinery/sensortower/attack_alien(mob/living/carbon/xenomorph/M)
	if(buildstate == SENSORTOWER_BUILDSTATE_BLOWTORCH)
		to_chat(M, SPAN_WARNING("你茫然地盯着 \the [src]。"))
		return XENO_NO_DELAY_ACTION

	if(M.action_busy)
		return XENO_NO_DELAY_ACTION

	var/turf/cur_loc = M.loc

	playsound(loc, 'sound/effects/metal_creaking.ogg', 25, TRUE)
	M.visible_message(SPAN_DANGER("[M] 开始用力拆开 \the [src] 的面板，将手伸入内部！"), \
	SPAN_DANGER("你开始用力拆开 \the [src] 的面板，将手伸入内部！"), null, 5, CHAT_TYPE_XENO_COMBAT)
	xeno_attack_delay(M)
	if(do_after(M, 40, INTERRUPT_ALL, BUSY_ICON_HOSTILE))
		if(M.loc != cur_loc)
			return XENO_NO_DELAY_ACTION //Make sure we're still there
		if(M.is_mob_incapacitated())
			return XENO_NO_DELAY_ACTION
		if(buildstate == SENSORTOWER_BUILDSTATE_BLOWTORCH)
			return XENO_NO_DELAY_ACTION
		buildstate = SENSORTOWER_BUILDSTATE_BLOWTORCH
		if(is_on)
			is_on = FALSE
			cur_tick = 0
			stop_processing()
		update_icon()
		M.visible_message(SPAN_DANGER("[M] 拆开 \the [src] 的面板，将内部线路和管路全部扯断！"), \
		SPAN_DANGER("你拆开 \the [src] 的面板，将内部线路和管路全部扯断！"), null, 5, CHAT_TYPE_XENO_COMBAT)
		playsound(loc, 'sound/effects/meteorimpact.ogg', 25, 1)
	else
		M.visible_message(SPAN_DANGER("[M] 停止破坏 \the [src] 的内部机械！"), \
		SPAN_DANGER("你停止破坏 \the [src] 的内部机械！"), null, 5, CHAT_TYPE_XENO_COMBAT)
	return XENO_NO_DELAY_ACTION

/* Decreases the buildstate of the sensor tower and switches it off if affected by any explosion.
Higher severity explosion will damage the sensor tower more
*/
/obj/structure/machinery/sensortower/ex_act(severity)
	if(buildstate == SENSORTOWER_BUILDSTATE_WRENCH)
		return
	switch(severity)
		if(0 to EXPLOSION_THRESHOLD_LOW)
			buildstate += 1
		if(EXPLOSION_THRESHOLD_LOW to EXPLOSION_THRESHOLD_MEDIUM)
			buildstate = clamp(buildstate + 2, SENSORTOWER_BUILDSTATE_WORKING, SENSORTOWER_BUILDSTATE_WRENCH)
		if(EXPLOSION_THRESHOLD_HIGH to INFINITY)
			buildstate = 3
	if(is_on)
		is_on = FALSE
		cur_tick = 0
		stop_processing()
	update_icon()

#undef SENSORTOWER_BUILDSTATE_WORKING
#undef SENSORTOWER_BUILDSTATE_BLOWTORCH
#undef SENSORTOWER_BUILDSTATE_WIRECUTTERS
#undef SENSORTOWER_BUILDSTATE_WRENCH
