/datum/tech/arc
	name = "M540-B装甲侦察车"
	desc = "购买一辆M540-B装甲侦察车，专门用于协助地面指挥。参谋军官、副舰长和舰长均可驾驶。"
	icon_state = "upgrade"

	required_points = 5

	tier = /datum/tier/one

	announce_name = "已获得M540-B装甲侦察车"
	announce_message = "一辆M540-B装甲侦察车已获批准，将交付至载具舱。"

	flags = TREE_FLAG_MARINE


/datum/tech/arc/can_unlock(mob/unlocking_mob)
	. = ..()

	var/obj/structure/machinery/cm_vending/gear/vehicle_crew/gearcomp = GLOB.VehicleGearConsole

	if(gearcomp.selected_vehicle == "TANK")
		to_chat(unlocking_mob, SPAN_WARNING ("本次行动已经选定了载具。"))
		return FALSE

	return TRUE


/datum/tech/arc/on_unlock()
	. = ..()

	var/obj/structure/machinery/computer/supplycomp/vehicle/comp = GLOB.VehicleElevatorConsole
	var/obj/structure/machinery/cm_vending/gear/vehicle_crew/gearcomp = GLOB.VehicleGearConsole

	if(!comp || !gearcomp)
		return FALSE

	comp.spent = FALSE
	QDEL_NULL_LIST(comp.vehicles)
	comp.vehicles = list(
		new /datum/vehicle_order/arc()
	)
	comp.allowed_roles = list(JOB_SYNTH, JOB_DI, JOB_SO, JOB_XO, JOB_CO, JOB_GENERAL)
	comp.req_access = list(ACCESS_MARINE_COMMAND)
	comp.req_one_access = list()
	comp.spent = FALSE

	gearcomp.req_access = list(ACCESS_MARINE_COMMAND)
	gearcomp.req_one_access = list()
	gearcomp.vendor_role = list()
	gearcomp.selected_vehicle = "ARC"
	gearcomp.available_categories = VEHICLE_ALL_AVAILABLE

	return TRUE
