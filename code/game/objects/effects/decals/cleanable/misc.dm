/obj/effect/decal/cleanable/generic
	name = "杂物"
	desc = "该有人把这里清理一下了。"
	gender = PLURAL
	density = FALSE
	anchored = TRUE
	layer = TURF_LAYER
	icon = 'icons/obj/objects.dmi'
	icon_state = "shards"

/obj/effect/decal/cleanable/ash
	name = "灰烬"
	desc = "尘归尘，土归土，最终飘向太空。"
	gender = PLURAL
	icon = 'icons/obj/objects.dmi'
	icon_state = "ash"
	anchored = TRUE

/obj/effect/decal/cleanable/ash/attack_hand(mob/user as mob)
	to_chat(user, SPAN_NOTICE("[src]从你的指缝间漏了下去。"))
	qdel(src)

/obj/effect/decal/cleanable/dirt
	name = "污垢"
	desc = "该有人把这里清理一下了。"
	gender = PLURAL
	density = FALSE
	anchored = TRUE
	layer = TURF_LAYER
	icon = 'icons/effects/effects.dmi'
	icon_state = "dirt"
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT

/obj/effect/decal/cleanable/dirt/greenglow
	name = "发光黏液"
	acid_damage = 1
	icon_state = "greenglow"
	light_range = 1
	light_color = COLOR_LIGHT_GREEN
/obj/effect/decal/cleanable/flour
	name = "面粉"
	desc = "还能吃，四秒法则！"
	gender = PLURAL
	density = FALSE
	anchored = TRUE
	layer = TURF_LAYER
	icon = 'icons/effects/effects.dmi'
	icon_state = "flour"

/obj/effect/decal/cleanable/greenglow
	name = "发光黏液"
	desc = "天哪，希望这不是午餐。"
	gender = PLURAL
	density = FALSE
	anchored = TRUE
	layer = TURF_LAYER
	light_range = 1
	light_color = COLOR_LIGHT_GREEN
	icon = 'icons/effects/effects.dmi'
	icon_state = "greenglow"

/obj/effect/decal/cleanable/greenglow/Initialize(mapload, ...)
	if(mapload)
		return INITIALIZE_HINT_QDEL
	. = ..()
	QDEL_IN(WEAKREF(src), 2 MINUTES)

/obj/effect/decal/cleanable/cobweb
	name = "蛛网"
	desc = "该有人把它清除了。"
	density = FALSE
	anchored = TRUE
	layer = FLY_LAYER
	icon = 'icons/effects/effects.dmi'
	icon_state = "cobweb1"

/obj/effect/decal/cleanable/molten_item
	name = "灰色黏稠物"
	desc = "看起来像是某种……熔化的东西。"
	density = FALSE
	anchored = TRUE
	layer = OBJ_LAYER
	gender = PLURAL
	icon = 'icons/obj/items/chemistry.dmi'
	icon_state = "molten"

/obj/effect/decal/cleanable/cobweb2
	name = "蛛网"
	desc = "该有人把它清除了。"
	density = FALSE
	anchored = TRUE
	layer = OBJ_LAYER
	icon = 'icons/effects/effects.dmi'
	icon_state = "cobweb2"

/// Variant used for halloween - need to pass info in constructor as its turned in an overlay
/obj/effect/decal/cleanable/cobweb2/dynamic
	alpha = 80
	appearance_flags = RESET_ALPHA | TILE_BOUND | PIXEL_SCALE
	garbage = FALSE
/obj/effect/decal/cleanable/cobweb2/dynamic/Initialize(mapload, targetdir, webscale = 1.0)
	alpha += floor(webscale * 120)
	var/angle = dir2angle(targetdir)
	var/matrix/TM = new
	TM *= webscale
	TM = TM.Translate(16 * (1 - webscale))
	angle -= 225 // Flip and adjust, base sprite is top right
	TM = TM.Turn(angle)
	transform = TM
	return ..()

//Vomit (sorry)
/obj/effect/decal/cleanable/vomit
	name = "呕吐物"
	desc = "天哪，真恶心。"
	gender = PLURAL
	density = FALSE
	anchored = TRUE
	layer = TURF_LAYER
	icon = 'icons/effects/blood.dmi'
	icon_state = "vomit_1"
	random_icon_states = list("vomit_1", "vomit_2", "vomit_3", "vomit_4")
	cleanable_type = CLEANABLE_SPLATTER

/obj/effect/decal/cleanable/vomit/ex_act()
	return

/obj/effect/decal/cleanable/tomato_smudge
	name = "番茄污渍"
	desc = "红彤彤的。"
	density = FALSE
	anchored = TRUE
	layer = TURF_LAYER
	icon = 'icons/effects/effects.dmi'
	random_icon_states = list("tomato_floor1", "tomato_floor2", "tomato_floor3")

/obj/effect/decal/cleanable/egg_smudge
	name = "碎鸡蛋"
	desc = "看来这颗蛋孵不出来了。"
	density = FALSE
	anchored = TRUE
	layer = TURF_LAYER
	icon = 'icons/effects/effects.dmi'
	random_icon_states = list("smashed_egg1", "smashed_egg2", "smashed_egg3")

/obj/effect/decal/cleanable/pie_smudge //honk
	name = "碎馅饼"
	desc = "奶油派上的奶油。"
	density = FALSE
	anchored = TRUE
	layer = TURF_LAYER
	icon = 'icons/effects/effects.dmi'
	random_icon_states = list("smashed_pie")

/obj/effect/decal/cleanable/blackgoo
	name = "黑色黏液"
	desc = "浓稠又黏腻。"
	gender = PLURAL
	icon = 'icons/effects/effects.dmi'
	icon_state = "blackgoo"

/obj/effect/decal/cleanable/blackgoo/Crossed(mob/living/carbon/human/H)
	if(!istype(H)) return
	if(H.species.name == "Human")
		if(!H.shoes && prob(50))
			H.contract_disease(new /datum/disease/black_goo)




/obj/effect/decal/cleanable/mucus
	name = "黏液"
	desc = "令人作呕的黏液。"
	gender = PLURAL
	density = FALSE
	anchored = TRUE
	layer = TURF_LAYER
	icon = 'icons/effects/blood.dmi'
	icon_state = "mucus"
	random_icon_states = list("mucus")
