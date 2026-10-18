/mob/living/carbon/human/proc/mark_panel()
	set name = "标记面板"
	set category = "Yautja.Marks"
	set desc = "Allows you to mark your prey."

	if(is_mob_incapacitated())
		to_chat(src, SPAN_DANGER("你现在无法这样做。"))
		return

	var/mob/living/carbon/human/T = src
	if(!isyautja(T))
		return

	var/list/options = list()
	var/list/optionsp = list(
		"Un-Mark as Thralled",
		"标记为荣誉猎物",
		"Un-Mark as Honored",
		"标记为不名誉猎物",
		"Un-Mark as Dishonorable",
		"Mark as Gear Carrier",
		"Un-Mark as Gear Carrier"
	)

	if(!T.hunter_data.prey)
		options += "Mark as Prey"
	else
		options += "Un-Mark as Prey"

	if(!T.hunter_data.thrall)
		options += "标记为仆从"

	options += optionsp

	var/input = tgui_input_list(usr, "选择要施加的标记", "标记面板", options)

	if(!input)
		return
	else if(input)

		switch(input)
			if("Mark as Prey")
				T.mark_for_hunt()
			if("Un-Mark as Prey")
				T.remove_from_hunt()
			if("标记为荣誉猎物")
				T.mark_honored()
			if("Un-Mark as Honored")
				T.unmark_honored()
			if("标记为不名誉猎物")
				T.mark_dishonored()
			if("Un-Mark as Dishonorable")
				T.unmark_dishonored()
			if("Mark as Gear Carrier")
				T.mark_gear()
			if("Un-Mark as Gear Carrier")
				T.unmark_gear()
			if("标记为仆从")
				T.mark_thralled()
			if("Un-Mark as Thralled")
				T.unmark_thralled()

	return

// Mark for Hunt verbs
// Add prey for hunt
/mob/living/carbon/human/proc/mark_for_hunt()
	set category = "Yautja.Marks"
	set name = "Mark for Hunt"
	set desc = "Mark a target for the hunt."

	if(is_mob_incapacitated())
		to_chat(src, SPAN_DANGER("你现在无法这样做。"))
		return

	// Only one prey per pred
	if(hunter_data.prey)
		to_chat(src, SPAN_DANGER("你已经在追猎其他目标了。"))
		return

	if(!isyautja(src))
		to_chat(src, SPAN_WARNING("你是怎么获得这个指令的？"))
		return

	// List all possible preys
	// We only target living humans and xenos
	var/list/target_list = list()
	for(var/mob/living/prey in view(7, usr.client))
		if((ishuman_strict(prey) || isxeno(prey)) && prey.stat != DEAD)
			target_list += prey

	var/mob/living/carbon/M = tgui_input_list(usr, "目标", "选择猎物。", target_list)
	if(!M)
		return
	if(M.hunter_data.hunter)
		to_chat(src, SPAN_YAUTJABOLD("[M]已被[M.hunter_data.hunter.real_name]选为猎物！"))
		return
	hunter_data.prey = M
	M.hunter_data.hunter = src
	M.hunter_data.hunted = TRUE
	M.hud_set_hunter()

	// Notify the pred
	to_chat(src, SPAN_YAUTJABOLD("你选择[hunter_data.prey]作为下一个猎物。"))

	// Notify other preds
	message_all_yautja("[real_name] has chosen [hunter_data.prey] ([max(hunter_data.prey.life_kills_total, hunter_data.prey.default_honor_value)] honor) as their next target at \the [get_area_name(hunter_data.prey)].")

	// log to server file
	log_interact(src, hunter_data.prey, "[key_name(src)] has marked [key_name(hunter_data.prey)] for the Hunt in [get_area(hunter_data.prey)] ([x],[y],[z]).")

// Removing prey from hunt (i.e. it died, it bugged, it left the game, etc.)
/mob/living/carbon/human/proc/remove_from_hunt()
	set category = "Yautja.Marks"
	set name = "Remove from Hunt"
	set desc = "Unmark your hunt target."

	if(is_mob_incapacitated())
		to_chat(src, SPAN_DANGER("你现在无法这样做。"))
		return

	if(!hunter_data.prey)
		to_chat(src, SPAN_DANGER("你目前没有追猎任何目标。"))
		return

	if(!isyautja(src))
		to_chat(src, SPAN_WARNING("你是怎么获得这个指令的？"))
		return

	if (alert(usr, "确定要放弃这个猎物吗？", "移出狩猎名单：", "Yes", "No") != "Yes")
		return
	var/mob/living/carbon/prey = hunter_data.prey
	to_chat(src, SPAN_YAUTJABOLD("你将[prey]从狩猎名单中移除了。"))
	prey.hunter_data.hunter = null
	prey.hunter_data.hunted = FALSE
	log_interact(src, hunter_data.prey, "[key_name(src)] has un-marked [key_name(hunter_data.prey)] for the Hunt")
	hunter_data.prey = null
	prey.hud_set_hunter()



/mob/living/carbon/human/proc/mark_honored()
	if(is_mob_incapacitated())
		to_chat(src, SPAN_DANGER("你现在无法这样做。"))
		return

	if(!isyautja(src))
		to_chat(src, SPAN_WARNING("你是怎么获得这个指令的？"))
		return

	var/list/target_list = list()
	for(var/mob/living/carbon/target in view(7, usr.client))
		if(ishuman_strict(target) && (target.stat != DEAD))
			target_list += target

	var/mob/living/carbon/T = tgui_input_list(usr, "目标", "选择目标。", target_list)
	if(!T)
		return
	if(T.hunter_data.honored)
		to_chat(src, SPAN_YAUTJABOLD("[T]已因“[T.hunter_data.honored_reason]”被[T.hunter_data.honored_set.real_name]授予荣誉！"))
		return

	var/reason = stripped_input(usr, "请输入授予目标荣誉的理由。", "标记为荣誉猎物", "", 120)

	if(!reason)
		return

	log_interact(src, T, "[key_name(src)] has marked [key_name(T)] as Honored for '[reason]'.")
	message_all_yautja("[real_name] has marked [T] as Honored for '[reason]'.")

	T.hunter_data.honored_set = src
	hunter_data.honored_targets += T
	T.hunter_data.honored = TRUE
	T.hunter_data.honored_reason = "[reason]' by '[src.real_name]"
	T.hud_set_hunter()



/mob/living/carbon/human/proc/unmark_honored()
	if(is_mob_incapacitated())
		to_chat(src, SPAN_DANGER("你现在无法这样做。"))
		return

	if(!isyautja(src))
		to_chat(src, SPAN_WARNING("你是怎么获得这个指令的？"))
		return

	var/list/target_list = list()
	for(var/mob/living/carbon/target in view(7, usr.client))
		if(ishuman_strict(target) && (target.stat != DEAD))
			if(target.hunter_data.honored)
				target_list += target

	var/mob/living/carbon/T = tgui_input_list(usr, "目标", "选择目标。", target_list)
	if(!T)
		return
	if(!T.hunter_data.honored)
		to_chat(src, SPAN_YAUTJABOLD("[T]没有被标记为荣誉猎物！"))
		return

	if(!T.hunter_data.honored_set || src == T.hunter_data.honored_set)

		log_interact(src, T, "[key_name(src)] has un-marked [key_name(T)] as honored!")
		message_all_yautja("[real_name] has un-marked [T] as honored!'.")

		T.hunter_data.honored_set = null
		hunter_data.honored_targets += T
		T.hunter_data.honored = FALSE
		T.hunter_data.honored_reason = null
		T.hud_set_hunter()
	else
		to_chat(src, SPAN_YAUTJABOLD("你不能撤销仍然在世的同胞所做的标记！"))



/mob/living/carbon/human/proc/mark_dishonored()
	if(is_mob_incapacitated())
		to_chat(src, SPAN_DANGER("你现在无法这样做。"))
		return

	if(!isyautja(src))
		to_chat(src, SPAN_WARNING("你是怎么获得这个指令的？"))
		return

	var/list/target_list = list()
	for(var/mob/living/carbon/target in view(7, usr.client))
		if((ishuman_strict(target) || isxeno(target)) && target.stat != DEAD)
			target_list += target

	if(isyautja(src) && src.hunter_data.thrall)
		target_list += src.hunter_data.thrall

	var/mob/living/carbon/T = tgui_input_list(usr, "目标", "选择目标。", target_list)
	if(!T)
		return
	if(T.hunter_data.dishonored)
		to_chat(src, SPAN_YAUTJABOLD("[T]已因“[T.hunter_data.dishonored_reason]”被[T.hunter_data.dishonored_set.real_name]标记为不名誉猎物！"))
		return

	var/reason = stripped_input(usr, "请输入将目标标记为不名誉猎物的理由。", "标记为不名誉猎物", "", 120)

	if(!reason)
		return

	log_interact(src, T, "[key_name(src)] has marked [key_name(T)] as Dishonorable for '[reason]'.")
	message_all_yautja("[real_name] has marked [T] as Dishonorable for '[reason]'.")

	T.hunter_data.dishonored_set = src
	hunter_data.dishonored_targets += T
	T.hunter_data.dishonored = TRUE
	T.hunter_data.dishonored_reason = "[reason]' by '[src.real_name]"
	T.hud_set_hunter()



/mob/living/carbon/human/proc/unmark_dishonored()
	if(is_mob_incapacitated())
		to_chat(src, SPAN_DANGER("你现在无法这样做。"))
		return

	if(!isyautja(src))
		to_chat(src, SPAN_WARNING("你是怎么获得这个指令的？"))
		return

	var/list/target_list = list()
	for(var/mob/living/carbon/target in view(7, usr.client))
		if((ishuman_strict(target) || isxeno(target)) && target.stat != DEAD)
			if(target.job != "Predalien" && target.job != "Predalien Larva")
				if(target.hunter_data.dishonored)
					target_list += target

	if(isyautja(src) && src.hunter_data.thrall)
		target_list += src.hunter_data.thrall

	var/mob/living/carbon/T = tgui_input_list(usr, "目标", "选择目标。", target_list)
	if(!T)
		return
	if(!T.hunter_data.dishonored)
		to_chat(src, SPAN_YAUTJABOLD("[T]没有被标记为不名誉猎物！"))
		return

	if(!T.hunter_data.dishonored_set || src == T.hunter_data.dishonored_set)

		log_interact(src, T, "[key_name(src)] has un-marked [key_name(T)] as dishonorable!")
		message_all_yautja("[real_name] has un-marked [T] as dishonorable!'.")

		T.hunter_data.dishonored_set = null
		hunter_data.dishonored_targets -= T
		T.hunter_data.dishonored = FALSE
		T.hunter_data.dishonored_reason = null
		T.hud_set_hunter()
	else
		to_chat(src, SPAN_YAUTJABOLD("你不能撤销仍然在世的同胞所做的标记！"))



/mob/living/carbon/human/proc/mark_gear()
	if(is_mob_incapacitated())
		to_chat(src, SPAN_DANGER("你现在无法这样做。"))
		return

	if(!isyautja(src))
		to_chat(src, SPAN_WARNING("你是怎么获得这个指令的？"))
		return

	var/list/target_list = list()
	for(var/mob/living/carbon/target in view(7, usr.client))
		if((ishuman_strict(target) && target.stat != DEAD))
			target_list += target

	var/mob/living/carbon/T = tgui_input_list(usr, "目标", "选择目标。", target_list)
	if(!T)
		return
	if(T.hunter_data.gear)
		to_chat(src, SPAN_YAUTJABOLD("[T]已被[T.hunter_data.gear_set]标记为铁血装备携带者！"))
		return

	log_interact(src, T, "[key_name(src)] has marked [key_name(T)] as a Gear Carrier!")
	message_all_yautja("[real_name] has marked [T] as a Gear Carrier!'.")

	T.hunter_data.gear_set = src
	hunter_data.gear_targets += T
	T.hunter_data.gear = TRUE
	T.hud_set_hunter()



/mob/living/carbon/human/proc/unmark_gear()
	if(is_mob_incapacitated())
		to_chat(src, SPAN_DANGER("你现在无法这样做。"))
		return

	if(!isyautja(src))
		to_chat(src, SPAN_WARNING("你是怎么获得这个指令的？"))
		return

	var/list/target_list = list()
	for(var/mob/living/carbon/target in view(7, usr.client))
		if((ishuman_strict(target) && target.stat != DEAD))
			if(target.hunter_data.gear)
				target_list += target

	var/mob/living/carbon/T = tgui_input_list(usr, "目标", "选择目标。", target_list)
	if(!T)
		return
	if(!T.hunter_data.gear)
		to_chat(src, SPAN_YAUTJABOLD("[T]没有被标记为铁血装备携带者！"))
		return

	if(!T.hunter_data.gear_set || src == T.hunter_data.gear_set)

		log_interact(src, T, "[key_name(src)] has un-marked [key_name(T)] as a Gear Carrier!")
		message_all_yautja("[real_name] has un-marked [T] as a Gear Carrier!'.")

		T.hunter_data.gear_set = null
		hunter_data.gear_targets -= T
		T.hunter_data.gear = FALSE
		T.hud_set_hunter()
	else
		to_chat(src, SPAN_YAUTJABOLD("你不能撤销仍然在世的同胞所做的标记！"))


/mob/living/carbon/human/proc/mark_thralled()
	if(is_mob_incapacitated())
		to_chat(src, SPAN_DANGER("你现在无法这样做。"))
		return

	if(!isyautja(src))
		to_chat(src, SPAN_WARNING("你是怎么获得这个指令的？"))
		return

	if(hunter_data.thrall)
		to_chat(src, SPAN_WARNING("你已经有一名仆从了。"))
		return

	// List all possible targets
	// We only target living humans
	var/list/target_list = list()
	for(var/mob/living/carbon/target in view(7, usr.client))
		if(ishuman_strict(target) && target.stat != DEAD)
			target_list += target

	var/mob/living/carbon/T = tgui_input_list(usr, "目标", "选择目标。", target_list)
	if(!T)
		return
	if(T.hunter_data.thralled)
		to_chat(src, SPAN_YAUTJABOLD("[T]已因“[T.hunter_data.thralled_reason]”被[T.hunter_data.thralled_set.real_name]收为仆从！"))
		return

	var/reason = stripped_input(usr, "请输入将目标收为仆从的理由。", "标记为仆从", "", 120)

	if(!reason)
		return

	log_interact(src, T, "[key_name(src)] has taken [key_name(T)] as their Thrall for '[reason]'.")
	message_all_yautja("[real_name] has taken [T] as their Thrall for '[reason]'.")

	T.hunter_data.thralled_set = src
	T.hunter_data.thralled = TRUE
	T.hunter_data.thralled_reason = reason
	hunter_data.thrall = T
	T.hud_set_hunter()



/mob/living/carbon/human/proc/unmark_thralled()
	if(is_mob_incapacitated())
		to_chat(src, SPAN_DANGER("你现在无法这样做。"))
		return

	if(!isyautja(src))
		to_chat(src, SPAN_WARNING("你是怎么获得这个指令的？"))
		return

	// List all possible targets
	// We only target living humans
	var/list/target_list = list()
	for(var/mob/living/carbon/target in view(7, usr.client))
		if(ishuman_strict(target) && target.stat != DEAD)
			if(target.hunter_data.thralled)
				target_list += target

	if(isyautja(src) && src.hunter_data.thrall)
		target_list += src.hunter_data.thrall

	var/mob/living/carbon/T = tgui_input_list(usr, "目标", "选择目标。", target_list)
	if(!T)
		return
	if(!T.hunter_data.thralled)
		to_chat(src, SPAN_YAUTJABOLD("[T]没有被标记为仆从！"))
		return

	if(!T.hunter_data.thralled_set || src == T.hunter_data.thralled_set)

		log_interact(src, T, "[key_name(src)] has released [key_name(T)] from thralldom!")
		message_all_yautja("[real_name] has released [T] from thralldom!'.")

		T.hunter_data.thralled_set = null
		T.hunter_data.thralled = FALSE
		T.hunter_data.thralled_reason = null
		hunter_data.thrall = null
		T.hud_set_hunter()
	else
		to_chat(src, SPAN_YAUTJABOLD("你不能撤销仍然在世的同胞所做的标记！"))

/mob/living/carbon/human/proc/call_combi()
	set name = "Yank combi-stick"
	set category = "Yautja.Weapons"
	set desc = "Yank on your combi-stick's chain, if it's in range. Otherwise... recover it yourself."

	if(usr.is_mob_incapacitated())
		return FALSE
	call_combi_internal(usr)

/mob/living/carbon/human/proc/call_combi_internal(mob/user, forced = FALSE)
	for(var/datum/effects/tethering/tether in user.effects_list)
		if(istype(tether.tethered.affected_atom, /obj/item/weapon/yautja/combistick))
			var/obj/item/weapon/yautja/combistick/stick = tether.tethered.affected_atom
			stick.recall()
