/* Diffrent misc types of tiles
 * Contains:
 * Grass
 * Wood
 * Carpet
 */

/obj/item/stack/tile
	name = "抽象地砖"
	singular_name = "抽象地砖"
	desc = "如果你看见了这段文字，说明开发者出了差错，请在 GitHub 上报告。"
	w_class = SIZE_MEDIUM
	force = 1
	throwforce = 1
	throw_speed = SPEED_VERY_FAST
	throw_range = 20
	max_amount = 60
	stack_id = "abstract tile"

	var/turf_type = /turf/open/floor/plating

/obj/item/stack/tile/Initialize(mapload, amount, new_turf_type)
	. = ..()
	if(new_turf_type)
		set_turf_type(new_turf_type)

/obj/item/stack/tile/proc/set_turf_type(new_turf_type)
	var/turf/open/floor/floor_type = new_turf_type
	name = "[initial(floor_type.name)] tile"
	singular_name = name
	turf_type = new_turf_type
	stack_id = name
	name = "[initial(floor_type.name)]地砖"
	singular_name = name

/obj/item/stack/tile/proc/build(turf/build_turf)
	build_turf.ChangeTurf(turf_type)

/obj/item/stack/tile/plasteel
	name = "地砖"
	singular_name = "地砖"
	desc = "这些东西用来投掷伤人倒是挺不错。"
	icon_state = "tile"
	w_class = SIZE_MEDIUM
	force = 6
	matter = list("metal" = 937.5)
	throwforce = 8
	throw_speed = SPEED_VERY_FAST
	throw_range = 6
	flags_atom = FPRINT|CONDUCT
	max_amount = 60
	stack_id = "floor tile"
	turf_type = null

/obj/item/stack/tile/plasteel/Initialize(mapload, amount)
	. = ..()
	src.pixel_x = rand(1, 14)
	src.pixel_y = rand(1, 14)

/obj/item/stack/tile/plasteel/build(turf/build_turf)
	build_turf.ChangeTurf(turf_type || /turf/open/floor)

/*
 * Grass
 */
/obj/item/stack/tile/grass
	name = "草皮地砖"
	desc = "一块高尔夫球场上常用的草皮。"
	singular_name = "草皮地砖"
	icon_state = "tile_grass"
	stack_id = "grass patch tile"
	turf_type = /turf/open/floor/grass


/*
 * Wood
 */
/obj/item/stack/tile/wood
	name = "木地板"
	desc = "一块便于安装的木地板。"
	singular_name = "木地板"
	icon_state = "tile-wood"
	stack_id = "wooden floor tile"
	turf_type = /turf/open/floor/wood

/obj/item/stack/tile/wood/fake
	name = "仿木地板"
	desc = "看起来像木头，摸起来像金属。"
	singular_name = "仿木地板"
	stack_id = "fake wooden floor tile"
	turf_type = /turf/open/floor/wood/ship

/*
 * Carpets
 */
/obj/item/stack/tile/carpet
	name = "地毯块"
	desc = "一块地毯，大小与普通地砖相同！"
	singular_name = "地毯块"
	icon_state = "tile-carpet"
	stack_id = "carpet tile"
	turf_type = /turf/open/floor/carpet
