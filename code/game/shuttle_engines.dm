/obj/structure/shuttle
	name = "穿梭机"
	icon = 'icons/turf/shuttle.dmi'

/obj/structure/shuttle/window
	name = "穿梭机舷窗"
	icon = 'icons/turf/podwindows.dmi'
	icon_state = "1"
	density = TRUE
	opacity = FALSE
	anchored = TRUE
	unslashable = TRUE
	unacidable = TRUE
	layer = WINDOW_LAYER

/obj/structure/shuttle/window/ex_act(severity)
	return

/obj/structure/shuttle/window/fire_act(exposed_temperature, exposed_volume)
	return

/obj/structure/shuttle/engine
	name = "引擎"
	density = TRUE
	anchored = TRUE
	unslashable = TRUE
	unacidable = TRUE

/obj/structure/shuttle/engine/heater
	name = "加热器"
	icon_state = "heater"

/obj/structure/shuttle/engine/platform
	name = "引擎平台"
	icon_state = "platform"

/obj/structure/shuttle/engine/propulsion
	name = "推进装置"
	icon_state = "propulsion"
	opacity = TRUE

/obj/structure/shuttle/engine/propulsion/burst
	name = "推进喷流"

/obj/structure/shuttle/engine/propulsion/burst/left
	name = "左侧推进喷流"
	icon_state = "burst_l"

/obj/structure/shuttle/engine/propulsion/burst/right
	name = "右侧推进喷流"
	icon_state = "burst_r"

/obj/structure/shuttle/engine/router
	name = "导流装置"
	icon_state = "router"

/obj/structure/shuttle/diagonal
	icon = 'icons/turf/shuttle.dmi'
	icon_state = "diagonalWall"
	name = "墙壁"
	layer = ABOVE_TURF_LAYER
	density = TRUE
