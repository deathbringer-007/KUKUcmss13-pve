// the light switch
// can have multiple per area
// can also operate on non-loc area through "otherarea" var
/obj/structure/machinery/light_switch
	name = "照明开关"
	desc = "用来开灯和关灯。这还用解释吗？"
	icon = 'icons/obj/structures/machinery/power.dmi'
	icon_state = "light1"
	anchored = TRUE
	var/on = 1
	var/area/area = null
	var/otherarea = null

/obj/structure/machinery/light_switch/Initialize()
	. = ..()
	src.area = src.loc.loc

	if(otherarea)
		src.area = locate(text2path("/area/[otherarea]"))

	if(!name)
		name = "照明开关（[area.name]）"

	src.on = src.area.lightswitch
	updateicon()



/obj/structure/machinery/light_switch/proc/updateicon()
	if(stat & NOPOWER)
		icon_state = "light-p"
	else
		if(on)
			icon_state = "light1"
		else
			icon_state = "light0"

/obj/structure/machinery/light_switch/get_examine_text(mob/user)
	. = ..()
	. += "当前处于[on? "开启" : "关闭"]状态。"

/obj/structure/machinery/light_switch/attack_hand(mob/user)
	on = !on

	area.lightswitch = on
	area.updateicon()

	for(var/obj/structure/machinery/light_switch/L in area)
		L.on = on
		L.updateicon()

	area.power_change()

/obj/structure/machinery/light_switch/power_change()
	if(!otherarea)
		if(powered(POWER_CHANNEL_LIGHT) || !needs_power)
			stat &= ~NOPOWER
		else
			stat |= NOPOWER

/obj/structure/machinery/light_switch/emp_act(severity)
	. = ..()
	if(inoperable())
		return
	power_change()
