/datum/tech/repeatable/req_points
	name = "增加军需预算"
	icon_state = "budget_req"
	desc = "向军需部门分配可支配资源。"

	announce_name = "阿尔迈耶号特殊装备使用已获授权"
	announce_message = "本次行动已获批追加补给预算。"

	required_points = 7
	increase_per_purchase = 1

	flags = TREE_FLAG_MARINE
	tier = /datum/tier/one

	var/points_to_give = 50

/datum/tech/repeatable/req_points/proc/get_tech_scaling_value()
	//We take the number of marine players, deduced from other lists, and then get a scale multiplier from it, to be used in arbitrary manners to distribute equipment
	//This might count players who ready up but get kicked back to the lobby
	var/marine_pop_size = length(GLOB.alive_human_list)

	//This gives a decimal value representing a scaling multiplier. Cannot go below 1
	return max(marine_pop_size / MARINE_GEAR_SCALING_NORMAL, 1)

/datum/tech/repeatable/req_points/on_unlock()
	. = ..()
	GLOB.supply_controller.points += points_to_give * get_tech_scaling_value()

/datum/tech/repeatable/dropship_points
	name = "增加运输机预算"
	icon_state = "budget_ds"
	desc = "向运输机制造机分配资源。"

	announce_message = "本次行动已获批追加运输机零件制造点数。"

	required_points = 6
	increase_per_purchase = 1

	flags = TREE_FLAG_MARINE
	tier = /datum/tier/one

	var/points_to_give = 2000

/datum/tech/repeatable/dropship_points/on_unlock()
	. = ..()
	GLOB.supply_controller.dropship_points += points_to_give
