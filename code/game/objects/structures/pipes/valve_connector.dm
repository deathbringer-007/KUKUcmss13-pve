/obj/structure/pipes/valve
	icon = 'icons/obj/pipes/valve.dmi'
	icon_state = "map_valve0"
	name = "手动阀门"
	desc = "管道阀门。"
	level = 1
	dir = SOUTH
	valid_directions = list(SOUTH, NORTH)

/obj/structure/pipes/valve/create_valid_directions()
	valid_directions = list(dir, turn(dir, 180))

/obj/structure/pipes/valve/update_underlays()
	if(..())
		underlays.Cut()
		var/turf/T = get_turf(src)
		if(!istype(T))
			return
		add_underlay(T, dir)

/obj/structure/pipes/valve/hide(invis)
	update_underlays()

/obj/structure/pipes/valve/open
	icon_state = "map_valve1"


/obj/structure/pipes/valve/digital
	name = "数字阀门"
	desc = "数字控制阀门。"
	icon = 'icons/obj/pipes/digital_valve.dmi'

/obj/structure/pipes/valve/digital/open
	icon_state = "map_valve1"


/obj/structure/pipes/tvalve
	icon = 'icons/obj/pipes/tvalve.dmi'
	icon_state = "map_tvalve0"
	name = "手动换向阀"
	desc = "管道阀门。"
	level = 1
	dir = SOUTH
	valid_directions = list(SOUTH, NORTH, WEST)

/obj/structure/pipes/tvalve/bypass
	icon_state = "map_tvalve1"

/obj/structure/pipes/tvalve/update_underlays()
	if(..())
		underlays.Cut()
		var/turf/T = get_turf(src)
		if(!istype(T))
			return
		add_underlay(T, turn(dir, -180))

		if(istype(src, /obj/structure/pipes/tvalve/mirrored))
			add_underlay(T, turn(dir, 90))
		else
			add_underlay(T, turn(dir, -90))

		add_underlay(T, dir)

/obj/structure/pipes/tvalve/hide(invis)
	update_underlays()

/obj/structure/pipes/tvalve/create_valid_directions()
	valid_directions = list(turn(dir, 180), dir, turn(dir, 90))

/obj/structure/pipes/tvalve/digital // can be controlled by AI
	name = "数字换向阀"
	desc = "数字控制阀门。"
	icon = 'icons/obj/pipes/digital_tvalve.dmi'

/obj/structure/pipes/tvalve/digital/bypass
	icon_state = "map_tvalve1"

/obj/structure/pipes/tvalve/mirrored
	icon_state = "map_tvalvem0"

/obj/structure/pipes/tvalve/mirrored/bypass
	icon_state = "map_tvalvem1"

/obj/structure/pipes/tvalve/mirrored/create_valid_directions()
	valid_directions = list(turn(dir, 180), dir, turn(dir, -90))

/obj/structure/pipes/tvalve/mirrored/digital
	name = "数字换向阀"
	desc = "数字控制阀门。"
	icon = 'icons/obj/pipes/digital_tvalve.dmi'

/obj/structure/pipes/tvalve/mirrored/digital/bypass
	icon_state = "map_tvalvem1"


/obj/structure/pipes/portables_connector
	icon = 'icons/obj/pipes/connector.dmi'
	icon_state = "map_connector"
	name = "连接端口"
	desc = "用于连接便携式大气控制设备。"
	dir = SOUTH
	valid_directions = list(SOUTH)
	level = 1

/obj/structure/pipes/portables_connector/New()
	valid_directions = list(dir)
	..()

/obj/structure/pipes/portables_connector/update_icon()
	icon_state = "connector"

/obj/structure/pipes/portables_connector/update_underlays()
	if(..())
		underlays.Cut()
		var/turf/T = get_turf(src)
		if(!istype(T))
			return
		add_underlay(T, dir)

/obj/structure/pipes/portables_connector/hide(invis)
	update_underlays()
