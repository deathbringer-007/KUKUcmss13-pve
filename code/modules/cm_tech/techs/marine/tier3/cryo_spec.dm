/datum/tech/cryomarine
	name = "唤醒额外武器专家"
	desc = "唤醒一名额外的武器专家，应对各类威胁。"
	icon_state = "overshield"

	announce_message = "正在从冷冻休眠中唤醒一名额外的武器专家。"

	required_points = 8

	flags = TREE_FLAG_MARINE
	tier = /datum/tier/three

/datum/tech/cryomarine/can_unlock(mob/user)
	. = ..()
	if(!.)
		return
	if(!SSticker.mode)
		to_chat(user, SPAN_WARNING("现在无法执行此操作！"))
		return

/datum/tech/cryomarine/on_unlock()
	. = ..()
	SSticker.mode.get_specific_call(/datum/emergency_call/cryo_spec, TRUE, FALSE) // "Marine Cryo Reinforcement (Spec)"
