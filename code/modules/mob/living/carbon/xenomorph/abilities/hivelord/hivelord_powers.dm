/datum/action/xeno_action/active_toggle/toggle_speed/enable_toggle()
	. = ..()
	update_weedwalking()

/datum/action/xeno_action/active_toggle/toggle_speed/disable_toggle()
	. = ..()
	update_weedwalking()

/datum/action/xeno_action/active_toggle/toggle_speed/proc/update_weedwalking()
	var/mob/living/carbon/xenomorph/hivelord/xeno = owner
	if(!xeno.check_state())
		return

	var/datum/behavior_delegate/hivelord_base/hivelord_delegate = xeno.behavior_delegate

	if(!istype(hivelord_delegate))
		return

	if(hivelord_delegate.toggle_resin_walker() == TRUE)
		if(!check_and_use_plasma_owner(plasma_cost))
			to_chat(xeno, SPAN_WARNING("等离子体不足！"))
			return
		to_chat(xeno, SPAN_NOTICE("我们与树脂融为一体，迫不及待地想奔跑！"))
		button.icon_state = "template_active"
		action_active = TRUE
	else
		to_chat(xeno, SPAN_WARNING("我们与树脂的联系减弱了。"))
		button.icon_state = "template"
		action_active = FALSE
		return

	xeno.recalculate_move_delay = TRUE
