/obj/structure/machinery/ignition_switch
	name = "点火开关"
	icon = 'icons/obj/objects.dmi'
	icon_state = "launcherbtt"
	desc = "固定式点火器的遥控开关。"
	var/id = null
	var/active = 0
	anchored = TRUE
	use_power = USE_POWER_IDLE
	idle_power_usage = 2
	active_power_usage = 4

/obj/structure/machinery/flasher_button
	name = "闪光器按钮"
	desc = "固定式闪光器的遥控开关。"
	icon = 'icons/obj/objects.dmi'
	icon_state = "launcherbtt"
	var/id = null
	var/active = 0
	anchored = TRUE
	use_power = USE_POWER_IDLE
	idle_power_usage = 2
	active_power_usage = 4

/obj/structure/machinery/crema_switch
	desc = "燃烧吧，宝贝，燃烧吧！"
	name = "焚化炉点火器"
	icon = 'icons/obj/structures/machinery/power.dmi'
	icon_state = "crema_switch"
	anchored = TRUE
	req_access = list(ACCESS_MARINE_MEDBAY)
	var/on = 0
	var/area/area = null
	var/otherarea = null
	var/id = 1
