/obj/structure/pipes/standard/simple/visible/universal
	name = "通用管道转接头"
	desc = "适用于普通管道、供气管道与洗涤管道的转接头。"
	icon_state = "map_universal"

/obj/structure/pipes/standard/simple/visible/universal/update_icon(safety = 0)
	if(!check_icon_cache())
		return
	alpha = 255

	overlays.Cut()
	underlays.Cut()
	overlays += icon_manager.get_atmos_icon("pipe", , pipe_color, "universal")

	universal_underlays(dir)
	universal_underlays(turn(dir, 180))

/obj/structure/pipes/standard/simple/hidden/universal
	name="通用管道转接头"
	desc = "适用于普通管道、供气管道与洗涤管道的转接头。"
	icon_state = "map_universal"

/obj/structure/pipes/standard/simple/hidden/universal/update_icon(safety = 0)
	if(!check_icon_cache())
		return
	alpha = 255

	overlays.Cut()
	underlays.Cut()
	overlays += icon_manager.get_atmos_icon("pipe", , pipe_color, "universal")

	universal_underlays(dir)
	universal_underlays(turn(dir, -180))

/obj/structure/pipes/proc/universal_underlays(direction)
	var/turf/T = loc
	add_underlay_adapter(T, direction)
	add_underlay_adapter(T, direction)
	add_underlay_adapter(T, direction)

/obj/structure/pipes/proc/add_underlay_adapter(turf/T, direction) //modified from add_underlay, does not make exposed underlays
	if(T.intact_tile && level == 1)
		underlays += icon_manager.get_atmos_icon("underlay", direction, color_cache_name(src), "down")
	else
		underlays += icon_manager.get_atmos_icon("underlay", direction, color_cache_name(src), "intact")


/obj/structure/pipes/standard/cap
	name = "管道封头"
	desc = "用于封闭管道末端的封头。"
	icon = 'icons/obj/pipes/pipes3.dmi'
	icon_state = ""
	level = 2
	dir = SOUTH
	valid_directions = list(SOUTH)

/obj/structure/pipes/standard/cap/create_valid_directions()
	valid_directions = list(dir)

/obj/structure/pipes/standard/cap/update_icon(safety = 0)
	if(!check_icon_cache())
		return

	alpha = 255

	overlays.Cut()
	overlays += icon_manager.get_atmos_icon("pipe", , pipe_color, "cap")

/obj/structure/pipes/standard/cap/visible
	level = 2
	icon_state = "cap"

/obj/structure/pipes/standard/cap/visible/scrubbers
	name = "洗涤管道封头"
	desc = "用于封闭洗涤管道末端的封头。"
	icon_state = "cap-scrubbers"
	layer = ATMOS_PIPE_SCRUBBER_LAYER
	color = PIPE_COLOR_RED

/obj/structure/pipes/standard/cap/visible/supply
	name = "供气管道封头"
	desc = "用于封闭供气管道末端的封头。"
	icon_state = "cap-supply"
	layer = ATMOS_PIPE_SUPPLY_LAYER
	color = PIPE_COLOR_BLUE

/obj/structure/pipes/standard/cap/hidden
	icon_state = "cap"
	alpha = 128

/obj/structure/pipes/standard/cap/hidden/update_icon()
	level = 1

	. = ..()

/obj/structure/pipes/standard/cap/hidden/scrubbers
	name = "洗涤管道封头"
	desc = "用于封闭洗涤管道末端的封头。"
	icon_state = "cap-f-scrubbers"
	layer = ATMOS_PIPE_SCRUBBER_LAYER
	color = PIPE_COLOR_RED

/obj/structure/pipes/standard/cap/hidden/supply
	name = "供气管道封头"
	desc = "用于封闭供气管道末端的封头。"
	icon_state = "cap-f-supply"
	layer = ATMOS_PIPE_SUPPLY_LAYER
	color = PIPE_COLOR_BLUE

/obj/structure/pipes/standard/cap/hidden/supply/no_boom
	name = "加固供气管道封头"
	explodey = FALSE
	color = PIPE_COLOR_PURPLE


/obj/structure/pipes/standard/tank
	icon = 'icons/obj/pipes/tank.dmi'
	icon_state = "air_map"
	name = "压力储罐"
	desc = "装有加压气体的大型容器。"
	dir = SOUTH
	valid_directions = list(SOUTH)
	density = TRUE
	layer = OBJ_LAYER
	var/actual_icon_state = "air"

/obj/structure/pipes/standard/tank/New()
	icon_state = actual_icon_state
	valid_directions = list(dir)
	..()

/obj/structure/pipes/standard/tank/update_underlays()
	if(..())
		underlays.Cut()
		var/turf/T = get_turf(src)
		if(!istype(T))
			return
		add_underlay(T, dir)

/obj/structure/pipes/standard/tank/hide()
	update_underlays()

/obj/structure/pipes/standard/tank/air
	name = "压力储罐（空气）"
	icon_state = "air_map"
	actual_icon_state = "air"

/obj/structure/pipes/standard/tank/oxygen
	name = "压力储罐（氧气）"
	icon_state = "o2_map"
	actual_icon_state = "o2"

/obj/structure/pipes/standard/tank/nitrogen
	name = "压力储罐（氮气）"
	icon_state = "n2_map"
	actual_icon_state = "n2_map"

/obj/structure/pipes/standard/tank/carbon_dioxide
	name = "压力储罐（二氧化碳）"
	icon_state = "co2_map"
	actual_icon_state = "co2"

/obj/structure/pipes/standard/tank/phoron
	name = "压力储罐（弗燃素）"
	icon_state = "phoron_map"
	actual_icon_state = "phoron"

/obj/structure/pipes/standard/tank/nitrous_oxide
	name = "压力储罐（一氧化二氮）"
	icon_state = "n2o_map"
	actual_icon_state = "n2o"
