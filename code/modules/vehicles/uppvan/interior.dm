/obj/structure/prop/vehicle/uppvan
	name = "进步人民联盟厢型车底盘"

	icon = 'icons/obj/vehicles/interiors/uppvan_chassis.dmi'
	icon_state = "uppvan_chassis"
	layer = ABOVE_TURF_LAYER
	mouse_opacity = FALSE

/obj/structure/prop/vehicle/uppvan/turret
	name = "进步人民联盟炮塔厢型车底盘"

	icon = 'icons/obj/vehicles/interiors/uppvan_chassis.dmi'
	icon_state = "uppvant_chassis"
	layer = ABOVE_TURF_LAYER
	mouse_opacity = FALSE

/obj/structure/prop/vehicle/uppvan_logistics
	name = "进步人民联盟后勤厢型车底盘"

	icon = 'icons/obj/vehicles/interiors/uppvan_chassis.dmi'
	icon_state = "uppvan_logistics_chassis"
	layer = ABOVE_TURF_LAYER
	mouse_opacity = FALSE

/obj/structure/interior_exit/vehicle/uppvan/left
	name = "厢型车左侧门"
	icon = 'icons/obj/vehicles/interiors/uppvan.dmi'
	icon_state = "interior_door"

/obj/structure/interior_exit/vehicle/uppvan/right
	name = "厢型车右侧门"
	icon = 'icons/obj/vehicles/interiors/uppvan.dmi'
	icon_state = "exterior_door_unique"
	dir = SOUTH

/obj/structure/interior_exit/vehicle/uppvan/backleft
	name = "厢型车后部出口"
	icon = 'icons/obj/vehicles/interiors/uppvan.dmi'
	icon_state = "back_2"
	dir = WEST

/obj/structure/interior_exit/vehicle/uppvan/backright
	name = "厢型车后部出口"
	icon = 'icons/obj/vehicles/interiors/uppvan.dmi'
	icon_state = "back_1"
	dir = WEST


//Landmark for spawning windows
/obj/effect/landmark/interior/spawn/interior_viewport/simple/uppvan
	name = "simple vehicle viewport spawner"
	icon = 'icons/obj/vehicles/interiors/uppvan.dmi'
	icon_state = "viewport_simple"
	layer = INTERIOR_DOOR_LAYER
	color = "#009cb8"

/obj/structure/interior_viewport/simple/uppvan
	name = "观察窗"
	desc = "嘿，从这里能看见我的基地！"
	icon = 'icons/obj/vehicles/interiors/uppvan.dmi'
	icon_state = "viewport_simple"

/obj/effect/landmark/interior/spawn/interior_viewport/simple/uppvan/on_load(datum/interior/I)
	var/obj/structure/interior_viewport/simple/uppvan/V = new(loc)

	V.vehicle = I.exterior
	V.pixel_x = pixel_x
	V.pixel_y = pixel_y
	V.layer = layer
	V.alpha = alpha

	qdel(src)

//Landmark for van's windshield
/obj/effect/landmark/interior/spawn/interior_viewport/simple/uppvanfront
	name = "viewport"
	desc = "Hey, I can see my base from here!"
	icon = 'icons/obj/vehicles/interiors/uppvan.dmi'
	icon_state = "viewport_simple_front"
	layer = INTERIOR_DOOR_LAYER
	color = "#009cb8"
	alpha = 80

/obj/structure/interior_viewport/simple/uppvanfront
	name = "观察窗"
	desc = "嘿，从这里能看见我的基地！"
	icon = 'icons/obj/vehicles/interiors/uppvan.dmi'
	icon_state = "viewport_simple_front"


/obj/effect/landmark/interior/spawn/interior_viewport/simple/uppvanfront/on_load(datum/interior/I)
	var/obj/structure/interior_viewport/simple/uppvanfront/V = new(loc)

	V.vehicle = I.exterior
	V.pixel_x = pixel_x
	V.pixel_y = pixel_y
	V.alpha = alpha
	V.icon = icon

	qdel(src)
