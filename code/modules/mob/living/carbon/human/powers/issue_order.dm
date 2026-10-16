/mob/living/carbon/human/proc/issue_order(order)
	if(!HAS_TRAIT(src, TRAIT_LEADERSHIP))
		to_chat(src, SPAN_WARNING("你没有资格下达命令！"))
		return

	if(stat)
		to_chat(src, SPAN_WARNING("你现在的状态无法下达命令。"))
		return

	if(!command_aura_available)
		to_chat(src, SPAN_WARNING("你刚下达过命令，先冷静一下。"))
		return

	if(!skills)
		return FALSE
	var/order_level = skills.get_skill_level(SKILL_LEADERSHIP)
	if(!order_level)
		order_level = SKILL_LEAD_TRAINED

	var/list/order_labels = list("机动" = COMMAND_ORDER_MOVE, "坚守" = COMMAND_ORDER_HOLD, "专注" = COMMAND_ORDER_FOCUS, "帮助" = "help", "取消" = "cancel")
	if(!order)
		order = order_labels[tgui_input_list(src, "选择一道命令", "下达命令", order_labels)]
		if(order == "help")
			to_chat(src, SPAN_NOTICE("<br>命令能暂时强化附近的士兵，随后进入冷却。效果如下：<br><B>机动</B>——提高机动性和闪避弹丸的概率。<br><B>坚守</B>——提高对疼痛和战斗伤害的抵抗力。<br><B>专注</B>——提高枪械精度和有效射程。<br>"))
			return
		if(!order || order == "cancel")
			return

		if(!command_aura_available)
			to_chat(src, SPAN_WARNING("你刚下达过命令，先冷静一下。"))
			return

	command_aura_available = FALSE
	var/command_aura_strength = order_level
	var/command_aura_duration = (order_level + 1) * 10 SECONDS

	var/turf/T = get_turf(src)
	for(var/mob/living/carbon/human/H in range(COMMAND_ORDER_RANGE, T))
		if(H.stat == DEAD)
			continue
		H.activate_order_buff(order, command_aura_strength, command_aura_duration)

	if(loc != T) //if we were inside something, the range() missed us.
		activate_order_buff(order, command_aura_strength, command_aura_duration)

	for(var/datum/action/A in actions)
		A.update_button_icon()

	// 1min cooldown on orders
	addtimer(CALLBACK(src, PROC_REF(make_aura_available)), COMMAND_ORDER_COOLDOWN)

	visible_message(SPAN_BOLDNOTICE("[src]下达了[order == COMMAND_ORDER_MOVE ? "机动" : order == COMMAND_ORDER_HOLD ? "坚守" : "专注"]命令！"), SPAN_BOLDNOTICE("你下达了[order == COMMAND_ORDER_MOVE ? "机动" : order == COMMAND_ORDER_HOLD ? "坚守" : "专注"]命令！"))

/mob/living/carbon/human/proc/make_aura_available()
	to_chat(src, SPAN_NOTICE("你可以再次下达命令了。"))
	command_aura_available = TRUE
	for(var/datum/action/A in actions)
		A.update_button_icon()


/mob/living/carbon/human/verb/issue_order_verb()
	set name = "下达命令"
	set desc = "向附近的人类下达命令，用你的威望坚定他们的意志。"
	set category = "IC"

	issue_order()


/mob/living/carbon/human/proc/activate_order_buff(order, strength, duration)
	if(!order || !strength)
		return

	switch(order)
		if(COMMAND_ORDER_MOVE)
			mobility_aura_count++
			mobility_aura = clamp(mobility_aura, strength, ORDER_MOVE_MAX_LEVEL)
		if(COMMAND_ORDER_HOLD)
			protection_aura_count++
			protection_aura = clamp(protection_aura, strength, ORDER_HOLD_MAX_LEVEL)
			pain.apply_pain_reduction(protection_aura * PAIN_REDUCTION_AURA)
		if(COMMAND_ORDER_FOCUS)
			marksman_aura_count++
			marksman_aura = clamp(marksman_aura, strength, ORDER_FOCUS_MAX_LEVEL)

	hud_set_order()

	if(duration)
		addtimer(CALLBACK(src, PROC_REF(deactivate_order_buff), order), duration)


/mob/living/carbon/human/proc/deactivate_order_buff(order)
	switch(order)
		if(COMMAND_ORDER_MOVE)
			if(mobility_aura_count > 1)
				mobility_aura_count--
			else
				mobility_aura_count = 0
				mobility_aura = 0
		if(COMMAND_ORDER_HOLD)
			if(protection_aura_count > 1)
				protection_aura_count--
			else
				pain.reset_pain_reduction()
				protection_aura_count = 0
				protection_aura = 0
		if(COMMAND_ORDER_FOCUS)
			if(marksman_aura_count > 1)
				marksman_aura_count--
			else
				marksman_aura_count = 0
				marksman_aura = 0

	hud_set_order()
