
/datum/tech/repeatable/cryomarine
	name = "唤醒增援部队"
	desc = "唤醒更多部队，应对各类威胁。"
	icon_state = "cryotroops"

	announce_message = "正在从冷冻休眠中唤醒增援部队。"

	required_points = 6
	increase_per_purchase = 6

	flags = TREE_FLAG_MARINE
	tier = /datum/tier/three

/datum/tech/repeatable/cryomarine/can_unlock(mob/M)
	. = ..()
	if(!.)
		return
	if(!SSticker.mode)
		to_chat(M, SPAN_WARNING("现在无法执行此操作！"))
		return

/datum/tech/repeatable/cryomarine/on_unlock()
	. = ..()
	SSticker.mode.get_specific_call(/datum/emergency_call/cryo_squad/tech, TRUE, FALSE) // "Marine Cryo Reinforcements (Tech)"
