/obj/item/pamphlet/skill/vc
	name = "载具驾驶训练手册"
	desc = "用于快速传授载具驾驶关键知识的手册。"
	icon_state = "pamphlet_vehicle"
	trait = /datum/character_trait/skills/vc
	bypass_pamphlet_limit = TRUE

/obj/item/vehicle_coupon
	name = "载具兑换券"
	desc = "可在ASRS载具控制台兑换一辆货真价实的装甲运兵车！好耶，终于不用走路了！仅限使用一次，必须手动将ASRS升降机送至下层。可能适用特殊限制，不提供保修。"
	icon = 'icons/obj/items/pamphlets.dmi'
	icon_state = "pamphlet_written"
	item_state = "pamphlet_written"
	var/vehicle_type = /datum/vehicle_order/apc/empty
	var/vehicle_category = "APC"

/obj/item/vehicle_coupon/tank
	name = "坦克兑换券"
	desc = "不闹着玩了！凭此券，船员可从载具ASRS领取一辆完整的朗斯特里特坦克。记得先把ASRS升降机降下去才能提车。仅限使用一次，不含LTB，附赠友军误伤。"
	vehicle_type = /datum/vehicle_order/tank/broken
	vehicle_category = "LONGSTREET"

/obj/item/vehicle_coupon/attack_self(mob/user)
	if(QDELETED(src))
		return
	if(redeem_vehicle())
		to_chat(user, SPAN_WARNING("[src]在被读取时燃烧起来，重置了ASRS载具系统！将升降机降下去，把你的奖品运上来吧。"))
		qdel(src)
	return ..()

/obj/item/vehicle_coupon/proc/redeem_vehicle(mob/user)
	SHOULD_NOT_SLEEP(TRUE)
	. = FALSE
	var/obj/structure/machinery/computer/supplycomp/vehicle/comp = GLOB.VehicleElevatorConsole
	var/obj/structure/machinery/cm_vending/gear/vehicle_crew/gearcomp = GLOB.VehicleGearConsole

	if(!comp || !gearcomp)
		return

	. = TRUE
	comp.spent = FALSE
	QDEL_NULL_LIST(comp.vehicles)
	comp.vehicles = list(
		new vehicle_type(),
	)
	comp.allowed_roles = null
	comp.req_access = list()
	comp.req_one_access = list()
	comp.spent = FALSE

	gearcomp.req_access = list()
	gearcomp.req_one_access = list()
	gearcomp.vendor_role = list()
	gearcomp.selected_vehicle = vehicle_category
	gearcomp.available_categories = VEHICLE_ALL_AVAILABLE

	return TRUE
