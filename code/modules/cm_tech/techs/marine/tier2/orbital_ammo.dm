/datum/tech/repeatable/ob
	name = "轨道轰炸弹药"
	desc = "购买轨道轰炸弹药。"

	required_points = 5
	increase_per_purchase = 2

	tier = /datum/tier/two

	var/type_to_give

/datum/tech/repeatable/ob/on_unlock()
	. = ..()
	if(!type_to_give)
		return

	var/datum/supply_order/O = new /datum/supply_order()
	O.ordernum = GLOB.supply_controller.ordernum++
	var/actual_type = GLOB.supply_packs_types[type_to_give]
	O.object = GLOB.supply_packs_datums[actual_type]
	O.orderedby = MAIN_AI_SYSTEM

	GLOB.supply_controller.shoppinglist += O

/datum/tech/repeatable/ob/he
	name = "追加轨道轰炸弹药——高爆"
	desc = "装填至轨道炮的高爆轰炸弹药。"
	icon_state = "ob_he"

	announce_message = "追加的轨道轰炸弹头（高爆）已送达军需部门ASRS。"

	flags = TREE_FLAG_MARINE

	type_to_give = "OB HE Crate"

/datum/tech/repeatable/ob/cluster
	name = "追加轨道轰炸弹药——集束"
	desc = "装填至轨道炮、会分裂散布的高爆轰炸弹药。"
	icon_state = "ob_cluster"

	announce_message = "追加的轨道轰炸弹头（集束）已送达军需部门ASRS。"

	flags = TREE_FLAG_MARINE

	type_to_give = "OB Cluster Crate"

/datum/tech/repeatable/ob/incend
	name = "追加轨道轰炸弹药——燃烧"
	desc = "装填至轨道炮的高燃性轰炸弹药。"
	icon_state = "ob_incend"

	announce_message = "追加的轨道轰炸弹头（燃烧）已送达军需部门ASRS。"

	flags = TREE_FLAG_MARINE

	type_to_give = "OB Incendiary Crate"
