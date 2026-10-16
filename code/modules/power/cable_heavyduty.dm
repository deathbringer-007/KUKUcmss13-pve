/obj/item/stack/cable_coil/heavyduty
	name = "重型电缆卷"
	icon = 'icons/obj/structures/machinery/power.dmi'
	icon_state = "wire"

/obj/structure/cable/heavyduty
	icon = 'icons/obj/pipes/power_cond_heavy.dmi'
	name = "大型电力电缆"
	desc = "这种电缆十分坚韧，普通手工工具无法将其剪断。"
	layer = BELOW_ATMOS_PIPE_LAYER

/obj/structure/cable/heavyduty/attackby(obj/item/W, mob/user)

	var/turf/T = src.loc
	if(T.intact_tile)
		return

	if(HAS_TRAIT(W, TRAIT_TOOL_WIRECUTTERS))
		to_chat(usr, SPAN_NOTICE("这些电缆太坚韧了，无法用[W.name]剪断。"))
		return
	else if(istype(W, /obj/item/stack/cable_coil))
		to_chat(usr, SPAN_NOTICE("你需要更粗的电缆才能连接这些电缆。"))
		return
	else
		..()

/obj/structure/cable/heavyduty/cableColor(colorC)
	return

/obj/structure/cable/heavyduty/south
	icon_state = "0-2"

/obj/structure/cable/heavyduty/east
	icon_state = "0-4"

/obj/structure/cable/heavyduty/west
	icon_state = "0-8"

/obj/structure/cable/heavyduty/north_south
	icon_state = "1-2"

/obj/structure/cable/heavyduty/north_east
	icon_state = "1-4"

/obj/structure/cable/heavyduty/north_west
	icon_state = "1-8"

/obj/structure/cable/heavyduty/east_south
	icon_state = "2-4"

/obj/structure/cable/heavyduty/west_south
	icon_state = "2-8"

/obj/structure/cable/heavyduty/west_east
	icon_state = "4-8"

/obj/structure/cable/heavyduty/north_east_south
	icon_state = "1-2-4"

/obj/structure/cable/heavyduty/north_east_west
	icon_state = "1-4-8"

/obj/structure/cable/heavyduty/north_west_south
	icon_state = "1-2-8"

/obj/structure/cable/heavyduty/north_south_east_west
	icon_state = "1-2-4-8"
