/obj/effect/decal/strata_decals
	icon = 'icons/effects/strata_decals.dmi'
	layer = TURF_LAYER
	anchored = TRUE

/obj/effect/decal/strata_decals/catwalk/prison //For finding and replacing prison catwalk objects since they nasty
	icon = 'icons/turf/floors/strata_floor.dmi'
	icon_state = "catwalk"
	name = "格栅走道"
	layer = CATWALK_LAYER
	desc = "这些东西毫无立体感，难道只是画上去的？"

//////////////////OUTDOOR STUFF/////////////////

/obj/effect/decal/strata_decals/rocks
	icon_state = ""
	name = "一些石块"
	desc = "一堆不起眼的小石块。"

/obj/effect/decal/strata_decals/rocks/ice
	icon_state = ""
	name = "一些冰冻石块"
	desc = "零星的冰块和石头杂乱地散落着。"

/obj/effect/decal/strata_decals/rocks/ice/ice1
	icon_state = "icerock"

/obj/effect/decal/strata_decals/grasses
	icon_state = "tufts"
	name = "一些草木"
	desc = "几簇顽强生长的雪草。"

////////////////INDOORS STUFF////////////////////

/obj/effect/decal/strata_decals/grime
	icon_state = ""
	name = "污渍"
	desc = "一块难看的褐色污渍，可能是咖啡、烟灰，也可能是水渍。谁知道呢。"
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT

/obj/effect/decal/strata_decals/grime/grime1
	icon_state = "grime1"

/obj/effect/decal/strata_decals/grime/grime2
	icon_state = "grime2"

/obj/effect/decal/strata_decals/grime/grime3
	icon_state = "grime3"

/obj/effect/decal/strata_decals/grime/grime4
	icon_state = "grime4"

/obj/effect/decal/strata_decals/grime/grime4/game_plane
	icon_state = "grime4"
	plane = GAME_PLANE
