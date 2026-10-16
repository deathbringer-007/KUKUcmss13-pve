/obj/vehicle/multitile/apc/movie/med
	name = "M577A5装甲医疗车"
	desc = "由标准M577装甲输送车改装而来，常见于支援连，专为行进中的医疗救治设计。进攻能力有限，但足以击退把红十字标志当成软目标的敌人。可搭载少量伤员，入口位于右侧。"

	icon_state = "apc_base_medical"
	interior_map = /datum/map_template/interior/apc_moviemed

	hardpoints_allowed = list(
		/obj/item/hardpoint/secondary/frontalcannon,
		/obj/item/hardpoint/support/smoke_launcher,
		/obj/item/hardpoint/locomotion/apc_wheels,
	)

	passengers_slots = 8

/obj/vehicle/multitile/apc/movie/med/initialize_cameras(change_tag = FALSE)
	if(!camera)
		camera = new /obj/structure/machinery/camera/vehicle(src)
	if(change_tag)
		camera.c_tag = "#[rand(1,100)] M577A5 \"[nickname]\" ATV"
		if(camera_int)
			camera_int.c_tag = camera.c_tag + " interior"
	else
		camera.c_tag = "#[rand(1,100)] M577A5 ATV"
		if(camera_int)
			camera_int.c_tag = camera.c_tag + " interior"

/*
** PRESETS SPAWNERS
*/
/obj/effect/vehicle_spawner/apc_moviemed
	name = "Armored Treatment Vehicle Spawner"
	icon = 'icons/obj/vehicles/movieapc.dmi'
	icon_state = "apc_base_medical"
	pixel_x = -64
	pixel_y = -64

/obj/effect/vehicle_spawner/apc_moviemed/Initialize()
	. = ..()
	spawn_vehicle()
	qdel(src)

//PRESET: no hardpoints
/obj/effect/vehicle_spawner/apc_moviemed/spawn_vehicle()
	var/obj/vehicle/multitile/apc/movie/med/APC = new (loc)

	load_misc(APC)
	load_hardpoints(APC)
	handle_direction(APC)
	APC.update_icon()

//PRESET: only wheels installed
/obj/effect/vehicle_spawner/apc_moviemed/plain/load_hardpoints(obj/vehicle/multitile/apc/movie/med/V)
	V.add_hardpoint(new /obj/item/hardpoint/locomotion/apc_wheels)

//PRESET: default hardpoints, destroyed
/obj/effect/vehicle_spawner/apc_moviemed/decrepit/spawn_vehicle()
	var/obj/vehicle/multitile/apc/movie/med/APC = new (loc)

	load_misc(APC)
	load_hardpoints(APC)
	handle_direction(APC)
	load_damage(APC)
	APC.update_icon()

/obj/effect/vehicle_spawner/apc_moviemed/decrepit/load_hardpoints(obj/vehicle/multitile/apc/movie/med/V)
	V.add_hardpoint(new /obj/item/hardpoint/secondary/frontalcannon)
	V.add_hardpoint(new /obj/item/hardpoint/support/smoke_launcher)
	V.add_hardpoint(new /obj/item/hardpoint/locomotion/apc_wheels)

//PRESET: default hardpoints
/obj/effect/vehicle_spawner/apc_moviemed/fixed/load_hardpoints(obj/vehicle/multitile/apc/movie/med/V)
	V.add_hardpoint(new /obj/item/hardpoint/secondary/frontalcannon)
	V.add_hardpoint(new /obj/item/hardpoint/support/smoke_launcher)
	V.add_hardpoint(new /obj/item/hardpoint/locomotion/apc_wheels)
