/obj/structure/pipes/unary/freezer
	name = "气体冷却系统"
	desc = "连接到管网后可冷却气体。"
	icon = 'icons/obj/structures/machinery/cryogenics.dmi'
	icon_state = "freezer_0"
	density = TRUE
	anchored = TRUE

	var/opened = 0 //for deconstruction

/obj/structure/pipes/unary/freezer/create_valid_directions()
	valid_directions = list(dir)

/obj/structure/pipes/unary/freezer/update_icon()
	if(length(connected_to))
		icon_state = "freezer"
	else
		icon_state = "freezer_0"

/obj/structure/pipes/unary/freezer/attackby(obj/item/O as obj, mob/user as mob)
	if(HAS_TRAIT(O, TRAIT_TOOL_SCREWDRIVER))
		opened = !opened
		to_chat(user, "你[opened ? "打开" : "关上"]了[src]的检修盖。")
		return

	..()

/obj/structure/pipes/unary/freezer/get_examine_text(mob/user)
	. = ..()
	if(opened)
		. += "检修盖开着。"


/obj/structure/pipes/unary/heat_exchanger
	name = "热交换器"
	desc = "在两路输入气体之间交换热量，专为快速传热设计。"
	icon = 'icons/obj/pipes/heat_exchanger.dmi'
	icon_state = "intact"
	density = TRUE

/obj/structure/pipes/unary/heat_exchanger/update_icon()
	if(length(connected_to))
		icon_state = "intact"
	else
		icon_state = "exposed"


/obj/structure/pipes/unary/heater
	name = "气体加热系统"
	desc = "连接到管网后可加热气体。"
	icon = 'icons/obj/structures/machinery/cryogenics.dmi'
	icon_state = "heater_0"
	density = TRUE
	anchored = TRUE
	var/opened = 0 //for deconstruction

/obj/structure/pipes/unary/heater/create_valid_directions()
	valid_directions = list(dir)


/obj/structure/pipes/unary/heater/update_icon()
	if(length(connected_to))
		icon_state = "heater"
	else
		icon_state = "heater_0"

//dismantling code. copied from autolathe
/obj/structure/pipes/unary/heater/attackby(obj/item/O as obj, mob/user as mob)
	if(HAS_TRAIT(O, TRAIT_TOOL_SCREWDRIVER))
		opened = !opened
		to_chat(user, "你[opened ? "打开" : "关上"]了[src]的检修盖。")
		return

	..()

/obj/structure/pipes/unary/heater/get_examine_text(mob/user)
	. = ..()
	if(opened)
		. += "检修盖开着。"


/obj/structure/pipes/unary/outlet_injector
	icon = 'icons/obj/pipes/injector.dmi'
	icon_state = "map_injector"
	layer = OBJ_LAYER
	name = "空气注入器"
	desc = "被动向周围环境注入空气，附有可控制流量的阀门。"

/obj/structure/pipes/unary/outlet_injector/update_icon()
	if(connected_to)
		icon_state = "on"
	else
		icon_state = "off"

/obj/structure/pipes/unary/outlet_injector/update_underlays()
	if(..())
		underlays.Cut()
		var/turf/T = get_turf(src)
		if(!istype(T))
			return
		add_underlay(T, dir)

/obj/structure/pipes/unary/outlet_injector/hide(invis)
	update_underlays()


/obj/structure/pipes/unary/oxygen_generator
	icon = 'icons/obj/pipes/oxygen_generator.dmi'
	icon_state = "intact_off"
	density = TRUE
	name = "制氧机"
	desc = ""
	dir = SOUTH
	valid_directions = list(SOUTH)

/obj/structure/pipes/unary/oxygen_generator/update_icon()
	if(connected_to)
		icon_state = "intact_on"
	else
		icon_state = "exposed_off"
