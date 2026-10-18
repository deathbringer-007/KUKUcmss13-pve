//Reactor damage states
#define BUILDSTATE_FUNCTIONAL 0
#define BUILDSTATE_DAMAGE_WRENCH 1
#define BUILDSTATE_DAMAGE_WIRE 2
#define BUILDSTATE_DAMAGE_WELD 3

//How often it checks if the reactor has failed
#define REACTOR_FAIL_CHECK_TICKS 100

/obj/structure/machinery/power/reactor
	name = "\improper S-52聚变反应堆"
	icon = 'icons/obj/structures/machinery/fusion_eng.dmi'
	icon_state = "off"
	desc = "一台韦斯廷兰S-52聚变反应堆。"
	directwired = FALSE  //Requires a cable directly underneath
	unslashable = TRUE
	unacidable = TRUE
	anchored = TRUE
	density = TRUE
	power_machine = TRUE
	throwpass = FALSE

	///Whether the reactor is functional
	var/is_on = TRUE
	///Whether the reactor is on the ship
	var/is_ship_reactor = FALSE
	///If the generator is overloaded
	var/overloaded = FALSE //Only possible during hijack once fuel is at 100%

	///How damaged the reactor is
	var/buildstate = BUILDSTATE_FUNCTIONAL

	///Original fail rate of the reactor
	var/original_fail_rate = 0
	///% chance of the reactor failing every check_failure
	var/fail_rate = 0
	///How often the reactor checks if it can fail
	var/fail_check_ticks = REACTOR_FAIL_CHECK_TICKS
	///How many ticks since last fail check
	var/cur_tick = 0 //Tick updater

	///% of power produced, increases to 100% over time
	var/power_gen_percent = 0
	///How much the reactor will generate at max power_gen_percent
	var/power_generation_max = 50000 //50,000W
	///All icon states split by power_gen_percent
	var/list/power_percent_states = list(10, 25, 50, 75, 100) //Easier to add more icon states to one without also adding them to the other

	///Whether the reactor requires a fusion cell
	var/require_fusion_cell = TRUE
	///The reactors fuel cell, fail rate increases if empty
	var/obj/item/fuel_cell/fusion_cell

/obj/structure/machinery/power/reactor/Initialize(mapload, ...)
	. = ..()
	if(is_mainship_level(z)) //Only ship reactors can overload
		is_ship_reactor = TRUE

	if(!buildstate && is_ground_level(z)) //Colony reactors start damaged
		switch(rand(1, 6))
			if(1 to 3) //50%
				buildstate = BUILDSTATE_DAMAGE_WELD
			if(4 to 5) //34%
				buildstate = BUILDSTATE_DAMAGE_WIRE
			if(6) //16%
				buildstate = BUILDSTATE_DAMAGE_WRENCH

	if(require_fusion_cell) //Set up fuel cell if needed
		fusion_cell = new /obj/item/fuel_cell/used(src)
		fusion_cell.fuel_amount = fusion_cell.max_fuel_amount

	fail_rate = original_fail_rate
	update_icon()

	if(is_on)
		start_processing()

	return INITIALIZE_HINT_ROUNDSTART

/obj/structure/machinery/power/reactor/LateInitialize() //Need to wait for powernets to start existing first
	. = ..()

	if(QDELETED(src))
		return
	if(powernet)
		return

	if(!connect_to_network()) //Make sure its connected to a powernet
		CRASH("[src] has failed to connect to a power network. Check that it has been mapped correctly.")

/obj/structure/machinery/power/reactor/Destroy()
	QDEL_NULL(fusion_cell)
	return ..()

/obj/structure/machinery/power/reactor/get_examine_text(mob/user)
	. = ..()

	if(!is_on)
		. += SPAN_INFO("它处于停机状态。")

	if(!ishuman(user))
		return
	if(is_on)
		. += SPAN_INFO("功率表读数：[power_gen_percent]%。")

	switch(buildstate)
		if(BUILDSTATE_DAMAGE_WELD)
			. += SPAN_INFO(SPAN_BOLD("可用焊炬修复。"))
		if(BUILDSTATE_DAMAGE_WIRE)
			. += SPAN_INFO(SPAN_BOLD("可用剪线钳修复。"))
		if(BUILDSTATE_DAMAGE_WRENCH)
			. += SPAN_INFO(SPAN_BOLD("可用扳手修复。"))

	if(buildstate || require_fusion_cell && (!fusion_cell || fusion_cell.fuel_amount <= 0))
		if(is_on)
			. += SPAN_INFO("可以看到紧急停机按钮。")
		else
			. += SPAN_INFO("可以看到紧急启动杆。")

	if(!fusion_cell)
		. += SPAN_INFO("里面没有燃料电池。")
	else
		switch(fusion_cell.get_fuel_percent())
			if(-INFINITY to 0)
				. += SPAN_INFO("[fusion_cell]已空。")
			if(1 to 9)
				. += SPAN_INFO("[fusion_cell]剩余量极低。")
			if(10 to 24)
				. += SPAN_INFO("[fusion_cell]剩余量偏低。")
			if(25 to 49)
				. += SPAN_INFO("[fusion_cell]剩余不到一半。")
			if(50 to 74)
				. += SPAN_INFO("[fusion_cell]剩余超过一半。")
			if(75 to 99)
				. += SPAN_INFO("[fusion_cell]接近全满。")
			if(99 to INFINITY)
				. += SPAN_INFO("[fusion_cell]已满。")

	if(is_ship_reactor && SShijack.sd_unlocked)
		if(overloaded)
			. += SPAN_INFO("它正处于过载状态。")
			return
		if(skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_TRAINED))
			. += SPAN_INFO("可用多用工具使其安全系统过载。")

/obj/structure/machinery/power/reactor/power_change()
	. = ..()
	if(overloaded)
		set_overloading(FALSE)
		visible_message(SPAN_NOTICE("主电源断开，[src]的过载突然停止了。"))

/obj/structure/machinery/power/reactor/process()
	if(!is_on) //if off, turn off
		start_functioning(FALSE)
		return

	if(buildstate)
		if(require_fusion_cell) //if broken and fuel cell, lose fuel
			if(fusion_cell && fusion_cell.fuel_amount)
				fusion_cell.modify_fuel(rand(-5, -20))
				visible_message(SPAN_DANGER("[src]发出嘶嘶声，燃料开始在周围积聚。"))
		else //Otherwise just start to break down faster
			visible_message(SPAN_DANGER("[src]冒出火花，停止运转。"))
			fail_rate += 2.5

	if(require_fusion_cell && (!fusion_cell || fusion_cell.fuel_amount <= 0)) //empty fuel
		if(prob(20))
			visible_message(SPAN_DANGER("引擎停止运转，[src]闪烁提示燃料电池[fusion_cell ? "已空" : "缺失"]。"))
		fail_rate += 2.5

	if(overloaded && prob(1)) // up to 18 generators at 1% every 3.5 seconds means that every ~21 seconds or so, one generator will make noise assuming all are overloaded
		if(prob(50))
			visible_message(SPAN_NOTICE("[src]发出响亮的嗡鸣。"))
			playsound(src, 'sound/machines/resource_node/node_idle.ogg', 60, TRUE)
		else
			visible_message(SPAN_NOTICE("[src]发出令人担忧的嘶嘶声。"))
			playsound(src, 'sound/machines/hiss.ogg', 60, TRUE)

	if(power_gen_percent < 100)
		power_gen_percent = min(power_gen_percent + 1, 100)

	add_avail(power_generation_max * (power_gen_percent / 100))
	check_failure(buildstate > BUILDSTATE_DAMAGE_WIRE || require_fusion_cell && (!fusion_cell || fusion_cell.fuel_amount <= 0))
	update_icon()

/obj/structure/machinery/power/reactor/proc/check_failure(damaged_reactor = FALSE)
	if(cur_tick < fail_check_ticks) //Nope, not time for it yet
		cur_tick++
		if(damaged_reactor)
			cur_tick += fail_check_ticks/5 //fail much faster if damaged
		return
	cur_tick = 0 //reset the timer

	fail_rate = clamp(fail_rate, 0, 100)
	if(!prob(fail_rate)) //Oh snap, we failed! Shut it down!
		return

	visible_message(SPAN_DANGER("[src]停止运转并损坏了。"))
	if(buildstate >= BUILDSTATE_DAMAGE_WELD)
		start_functioning(FALSE)
	buildstate = clamp(buildstate + 1, BUILDSTATE_FUNCTIONAL, BUILDSTATE_DAMAGE_WELD)

/obj/structure/machinery/power/reactor/attack_hand(mob/user)
	. = TRUE
	if(overloaded)
		to_chat(user, SPAN_DANGER("[src]没有响应你的停堆操作。"))
		return FALSE
	add_fingerprint(user)

	if(buildstate || require_fusion_cell && (!fusion_cell || fusion_cell.fuel_amount <= 0))
		if(is_on)
			to_chat(user, SPAN_NOTICE("你按下了[src]的紧急停机按钮。"))
			visible_message(SPAN_NOTICE("[user]按下了[src]的紧急停机按钮。"))
			start_functioning(FALSE)
			return

		visible_message(SPAN_NOTICE("[user]开始按住[src]的紧急启动杆。"))
		if(!do_after(user, 3 SECONDS, INTERRUPT_ALL, BUSY_ICON_BUILD, src))
			to_chat(user, SPAN_NOTICE("你松开了紧急启动杆。"))
			return FALSE
		start_functioning(TRUE)
		return

	if(is_on)
		visible_message(SPAN_WARNING("[user]关闭发电机，[src]轻轻鸣响，停止嗡鸣。"))
		start_functioning(FALSE)
		return

	visible_message(SPAN_NOTICE("[user]启动反应堆，[src]响亮地鸣叫。"))
	start_functioning(TRUE)

/obj/structure/machinery/power/reactor/attack_alien(mob/living/carbon/xenomorph/xeno)
	. = XENO_NONCOMBAT_ACTION
	if(buildstate >= BUILDSTATE_DAMAGE_WELD)
		to_chat(xeno, SPAN_WARNING("你觉得没必要攻击[src]。"))
		return

	if(xeno.action_busy)
		to_chat(xeno, SPAN_WARNING("你正忙于其他动作，无法破坏[src]。"))
		return

	if(overloaded)
		xeno.animation_attack_on(src)
		playsound(src, 'sound/effects/metalhit.ogg', 25, 1)
		xeno.visible_message(SPAN_DANGER("[xeno]对[src]使出[xeno.slashes_verb]，中止了过载过程！"), \
		SPAN_DANGER("你对[src]使出[xeno.slash_verb]，中止了过载过程！"), null, 5, CHAT_TYPE_XENO_COMBAT)
		set_overloading(FALSE)
		return

	var/looping = FALSE
	while(buildstate < BUILDSTATE_DAMAGE_WELD)
		to_chat(xeno, SPAN_NOTICE("你[looping ? "继续破坏" : "开始破坏"][src]。"))
		if(!do_after(xeno, 10 SECONDS, INTERRUPT_ALL, BUSY_ICON_HOSTILE, src))
			to_chat(xeno, SPAN_DANGER("你停止破坏[src]。"))
			break
		xeno.animation_attack_on(src)
		playsound(src, 'sound/effects/metalhit.ogg', 25, 1)
		xeno.visible_message(SPAN_DANGER("[xeno]对[src]使出[xeno.slashes_verb]，使其[is_on ? "停机" : "受损"]！"))
		switch(buildstate)
			if(BUILDSTATE_FUNCTIONAL)
				visible_message(SPAN_DANGER("[src]开始散架！"))
			if(BUILDSTATE_DAMAGE_WRENCH)
				visible_message(SPAN_DANGER("[src]的电线脱落，火花四溅！"))
			if(BUILDSTATE_DAMAGE_WIRE)
				visible_message(SPAN_DANGER("[src]被撕碎了！"))
		buildstate = clamp(buildstate + 1, BUILDSTATE_FUNCTIONAL, BUILDSTATE_DAMAGE_WELD)
		update_icon()
		looping = TRUE

/obj/structure/machinery/power/reactor/attackby(obj/item/attacking_item, mob/user)
	//Fuel Cells
	if(user.action_busy)
		return

	if(istype(attacking_item, /obj/item/fuel_cell))
		var/obj/item/fuel_cell/cell = attacking_item
		if(fusion_cell)
			to_chat(user, SPAN_WARNING("[src]里已经装有[fusion_cell]。要换成[cell]，必须先用撬棍将其取出。"))
			return

		to_chat(user, SPAN_NOTICE("你开始将[cell]插入[src]。"))
		if(!do_after(user, 10 SECONDS * user.get_skill_duration_multiplier(SKILL_ENGINEER), INTERRUPT_ALL, BUSY_ICON_BUILD, src))
			return

		if(!user.drop_inv_item_to_loc(cell, src))
			to_chat(user, SPAN_NOTICE("你未能将[cell]插入[src]。"))
			return
		to_chat(user, SPAN_NOTICE("你将[cell]插入了[src]。"))
		fusion_cell = cell
		update_icon()
		if(cell.new_cell)
			fail_rate = original_fail_rate
			cell.new_cell = FALSE
		return

	if(HAS_TRAIT(attacking_item, TRAIT_TOOL_CROWBAR))
		if(!fusion_cell)
			to_chat(user, SPAN_WARNING("[src]里没有可取出的燃料电池。"))
			return

		to_chat(user, SPAN_NOTICE("你开始从[src]中撬出[fusion_cell]。"))
		if(!do_after(user, 10 SECONDS * user.get_skill_duration_multiplier(SKILL_ENGINEER), INTERRUPT_ALL, BUSY_ICON_BUILD, src))
			return

		to_chat(user, SPAN_NOTICE("你从[src]中取出了[fusion_cell]。"))
		fusion_cell.update_icon()
		user.put_in_hands(fusion_cell)
		fusion_cell = null
		update_icon()
		return

	//Repairing
	if(HAS_TRAIT(attacking_item, TRAIT_TOOL_BLOWTORCH))
		if(!attempt_repair(attacking_item, BUILDSTATE_DAMAGE_WELD, user))
			return
		var/obj/item/tool/weldingtool/welder = attacking_item
		if(!welder.remove_fuel(1, user))
			return
		playsound(loc, 'sound/items/Welder2.ogg', 25, 1)
		buildstate = BUILDSTATE_DAMAGE_WIRE
		update_icon()
		return

	if(HAS_TRAIT(attacking_item, TRAIT_TOOL_WIRECUTTERS))
		if(!attempt_repair(attacking_item, BUILDSTATE_DAMAGE_WIRE, user))
			return
		playsound(loc, 'sound/items/Wirecutter.ogg', 25, 1)
		buildstate = BUILDSTATE_DAMAGE_WRENCH
		update_icon()
		return

	if(HAS_TRAIT(attacking_item, TRAIT_TOOL_WRENCH))
		if(!attempt_repair(attacking_item, BUILDSTATE_DAMAGE_WRENCH, user))
			return
		playsound(loc, 'sound/items/Ratchet.ogg', 25, 1)
		buildstate = BUILDSTATE_FUNCTIONAL
		update_icon()
		return

	//Self Destruct
	if(HAS_TRAIT(attacking_item, TRAIT_TOOL_MULTITOOL))
		if(!SShijack.sd_unlocked)
			return
		if(!is_ship_reactor)
			return

		if(!skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_TRAINED))
			return

		to_chat(user, SPAN_WARNING("你开始[overloaded ? "使其过载" : "恢复"][src]的安全系统。"))
		if(!do_after(user, 2 SECONDS, INTERRUPT_ALL, BUSY_ICON_BUILD))
			return

		if(inoperable())
			to_chat(user, SPAN_WARNING("[src]必须处于运转状态且接有外部电源，才能使其过载。"))
			return

		set_overloading(!overloaded)
		to_chat(user, SPAN_WARNING("你完成了对[src]安全系统的[overloaded ? "过载操作" : "恢复"]。"))
		log_game("[key_name(user)] has [overloaded ? "overloaded" : "restored the safeties of"] a generator.")
		return

	. = ..()

/obj/structure/machinery/power/reactor/update_icon()
	switch(buildstate)
		if(BUILDSTATE_DAMAGE_WELD)
			icon_state = "weld"
		if(BUILDSTATE_DAMAGE_WIRE)
			icon_state = "wire"
		if(BUILDSTATE_DAMAGE_WRENCH)
			icon_state = "wrench"
	if(buildstate)
		return

	if(!is_on)
		icon_state = "off"
		return

	if(require_fusion_cell && !fusion_cell)
		icon_state = "cell_missing"
		return

	if(overloaded)
		icon_state = "overloaded"
		return

	var/abs_percent = 100
	var/closest_percent
	for(var/current_percent in power_percent_states)
		if(abs(current_percent-power_gen_percent) >= abs_percent)
			continue
		abs_percent = abs(current_percent-power_gen_percent)
		closest_percent = current_percent
		if(!abs_percent)
			break
	icon_state = "on-[closest_percent]"

/obj/structure/machinery/power/reactor/ex_act(severity)
	. = FALSE
	if(severity <= EXPLOSION_THRESHOLD_MLOW)
		return

	var/datum/effect_system/spark_spread/sparks = new
	sparks.set_up(7, FALSE, loc)
	buildstate = clamp(buildstate + 1, BUILDSTATE_FUNCTIONAL, BUILDSTATE_DAMAGE_WELD)
	sparks.start()

	if(!overloaded)
		return
	set_overloading(FALSE)

/obj/structure/machinery/power/reactor/bullet_act(obj/projectile/bullet)
	. = ..()
	if(buildstate >= BUILDSTATE_DAMAGE_WELD)
		return
	if(!prob(5))
		return

	var/datum/effect_system/spark_spread/sparks = new
	sparks.set_up(7, FALSE, loc)
	buildstate = clamp(buildstate + 1, BUILDSTATE_FUNCTIONAL, BUILDSTATE_DAMAGE_WELD)
	sparks.start()

/obj/structure/machinery/power/reactor/proc/start_functioning(enabling)
	if(enabling)
		is_on = TRUE
		start_processing()
		update_icon()
		return
	is_on = FALSE
	power_gen_percent = 0
	cur_tick = 0
	set_overloading(FALSE)
	update_icon()

/obj/structure/machinery/power/reactor/proc/attempt_repair(obj/item/tool, repair_type, mob/user)
	if(!tool || !repair_type)
		return
	if(!buildstate)
		to_chat(user, SPAN_NOTICE("[src]无需修复。"))
		return
	if(buildstate != repair_type)
		to_chat(user, SPAN_WARNING("你需要换一种工具修复[src]。"))
		return

	var/repair_time = 20 SECONDS
	repair_time *= user.get_skill_duration_multiplier(SKILL_ENGINEER)
	if(!skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_TRAINED))
		repair_time += 5 SECONDS

	to_chat(user, SPAN_NOTICE("你开始用[tool]修复[src]。"))
	if(!do_after(user, repair_time, INTERRUPT_ALL, BUSY_ICON_BUILD, src))
		return

	return TRUE

/obj/structure/machinery/power/reactor/proc/set_overloading(new_overloading)
	if(!is_ship_reactor)
		return
	if(overloaded == new_overloading)
		return

	overloaded = new_overloading
	SEND_GLOBAL_SIGNAL(COMSIG_GLOB_GENERATOR_SET_OVERLOADING, overloaded)
	update_icon()

/obj/structure/machinery/power/reactor/colony
	name = "\improper G-11地热发电机"
	icon = 'icons/obj/structures/machinery/geothermal.dmi'
	desc = "一台架设在充满等离子体的钻孔上方的热电发电机。"

	is_on = FALSE
	power_generation_max = 100000 //100,000W at full capacity
	original_fail_rate = 0

#undef BUILDSTATE_FUNCTIONAL
#undef BUILDSTATE_DAMAGE_WELD
#undef BUILDSTATE_DAMAGE_WIRE
#undef BUILDSTATE_DAMAGE_WRENCH
#undef REACTOR_FAIL_CHECK_TICKS
