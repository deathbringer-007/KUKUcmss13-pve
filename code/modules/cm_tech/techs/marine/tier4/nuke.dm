#define NUKE_UNLOCK_TIME (115 MINUTES)

/datum/tech/nuke
	name = "核装置"
	desc = "购买一枚核装置，只有这样才能万无一失。"
	icon_state = "nuke"

	required_points = 5

	tier = /datum/tier/four

	announce_name = "已获得核武器"
	announce_message = "一枚核装置已获批准，将通过ASRS交付至军需部门。"

	flags = TREE_FLAG_MARINE

/datum/tech/nuke/New()
	SSticker.OnRoundstart(CALLBACK(src, PROC_REF(handle_description)))

/datum/tech/nuke/on_unlock()
	. = ..()

	var/datum/supply_order/new_order = new()
	new_order.ordernum = GLOB.supply_controller.ordernum++
	var/actual_type = GLOB.supply_packs_types["Encrypted Operational Nuke"]
	new_order.object = GLOB.supply_packs_datums[actual_type]
	new_order.orderedby = MAIN_AI_SYSTEM
	new_order.approvedby = MAIN_AI_SYSTEM

	GLOB.supply_controller.shoppinglist += new_order

/datum/tech/nuke/can_unlock(mob/unlocking_mob)
	. = ..()

	if(!.)
		return

	if(ROUND_TIME < NUKE_UNLOCK_TIME)
		to_chat(unlocking_mob, SPAN_WARNING("行动开始[ceil((NUKE_UNLOCK_TIME + SSticker.round_start_time) / (1 MINUTES))]分钟后才能购买此节点。"))
		return FALSE

	return TRUE

/datum/tech/nuke/proc/handle_description()
	desc = "购买一枚核装置。行动开始[ceil((NUKE_UNLOCK_TIME + SSticker.round_start_time) / (1 MINUTES))]分钟后才能购买，只有这样才能万无一失。"
