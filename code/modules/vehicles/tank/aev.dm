/obj/vehicle/multitile/tank/aev
	name = "M34E1“巴克纳”装甲工程车"
	desc = "一大块装甲，配上一副推铲，你知道该怎么用。入口位于后方。"
	desc_lore = "M34E1在殖民地海军陆战队的装备中极为罕见，其研发源于坚毅号部队为平定当地大规模叛乱而实施的“奥多拉猛攻”行动。当时，第2团第1营“铁头”陆战队员受到简易迫击炮压制，又被简易爆炸装置包围，于是给一辆“朗斯特里特”坦克加装临时装甲和扫雷犁，让它无人驶入雷区，为快速突击敌方阵地打开通路。陆战远征部队司令部注意到了此事，仅耗时创纪录的3个月、耗资1000万美元便完成研发，并少量列装M34E1。"

	icon_state = "aev_base"

	hardpoints_allowed = list(
		/obj/item/hardpoint/support/overdrive_enhancer,
		/obj/item/hardpoint/support/smoke_launcher/aev,
		/obj/item/hardpoint/secondary/m56cupola/aev,
		/obj/item/hardpoint/armor/ballistic,
		/obj/item/hardpoint/armor/caustic,
		/obj/item/hardpoint/armor/concussive,
		/obj/item/hardpoint/armor/paladin,
		/obj/item/hardpoint/armor/snowplow,
		/obj/item/hardpoint/locomotion/treads,
		/obj/item/hardpoint/locomotion/treads/robust,
	)

	required_skill = SKILL_VEHICLE_LARGE
	interior_map = /datum/map_template/interior/aev

	active_hp = list(VEHICLE_DRIVER = null)

	explosive_resistance = 750

	passengers_slots = 15

	move_max_momentum = 2.2 //No turret and autoloader systems, saves on overall weight so moves quicker
	move_momentum_build_factor = 1.5
	move_turn_momentum_loss_factor = 0.6
	wall_ram_damage = 600

/obj/vehicle/multitile/tank/aev/initialize_cameras(change_tag = FALSE)
	if(!camera)
		camera = new /obj/structure/machinery/camera/vehicle(src)
	if(change_tag)
		camera.c_tag = "#[rand(1,100)] M34E1 \"[nickname]\" AEV"
		if(camera_int)
			camera_int.c_tag = camera.c_tag + " interior" //this fluff allows it to be at the start of cams list
	else
		camera.c_tag = "#[rand(1,100)] M34E1 AEV"
		if(camera_int)
			camera_int.c_tag = camera.c_tag + " interior" //this fluff allows it to be at the start of cams list

/obj/vehicle/multitile/tank/aev/add_seated_verbs(mob/living/user, seat)
	if(!user.client)
		return
	add_verb(user.client, list(
		/obj/vehicle/multitile/proc/switch_hardpoint,
		/obj/vehicle/multitile/proc/get_status_info,
		/obj/vehicle/multitile/proc/open_controls_guide,
		/obj/vehicle/multitile/proc/name_vehicle,
	))
	user.client.change_view(view_boost, seat)
	user.client.pixel_x = 0
	user.client.pixel_y = 0
	if(seat == VEHICLE_DRIVER)
		add_verb(user.client, list(
			/obj/vehicle/multitile/proc/toggle_door_lock,
			/obj/vehicle/multitile/proc/activate_horn,
			/obj/vehicle/multitile/proc/cycle_hardpoint,
		))

/obj/vehicle/multitile/tank/aev/remove_seated_verbs(mob/living/user, seat)
	if(!user.client)
		return
	remove_verb(user.client, list(
		/obj/vehicle/multitile/proc/get_status_info,
		/obj/vehicle/multitile/proc/open_controls_guide,
		/obj/vehicle/multitile/proc/name_vehicle,
		/obj/vehicle/multitile/proc/switch_hardpoint,
	))
	user.client.change_view(GLOB.world_view_size, seat)
	user.client.pixel_x = 0
	user.client.pixel_y = 0
	SStgui.close_user_uis(user, src)
	if(seat == VEHICLE_DRIVER)
		remove_verb(user.client, list(
			/obj/vehicle/multitile/proc/toggle_door_lock,
			/obj/vehicle/multitile/proc/activate_horn,
			/obj/vehicle/multitile/proc/cycle_hardpoint,
		))

/obj/vehicle/multitile/tank/aev/load_hardpoints()
	return

/obj/vehicle/multitile/tank/aev/desert
	desc = "一大块装甲，配上一副推铲，你知道该怎么用。入口位于后方。采用干旱环境迷彩。"
	icon_state = "aev_base_d"

/obj/vehicle/multitile/tank/aev/jungle
	desc = "一大块装甲，配上一副推铲，你知道该怎么用。入口位于后方。采用茂密植被环境迷彩。"
	icon_state = "aev_base_j"

/obj/vehicle/multitile/tank/aev/night
	desc = "一大块装甲，配上一副推铲，你知道该怎么用。入口位于后方。采用夜间环境迷彩。"
	icon_state = "aev_base_n"

/obj/effect/vehicle_spawner/aev
	name = "AEV Spawner"
	icon = 'icons/obj/vehicles/tank.dmi'
	icon_state = "aev_base"
	pixel_x = -48
	pixel_y = -48

/obj/effect/vehicle_spawner/aev/Initialize()
	. = ..()
	spawn_vehicle()
	qdel(src)

/obj/effect/vehicle_spawner/aev/spawn_vehicle()
	var/obj/vehicle/multitile/tank/aev/AEV = new(loc)

	load_misc(AEV)
	load_hardpoints(AEV)
	handle_direction(AEV)
	AEV.update_icon()

	return AEV

/obj/effect/vehicle_spawner/aev/load_hardpoints(obj/vehicle/multitile/tank/V)
	V.add_hardpoint(new /obj/item/hardpoint/locomotion/treads)
	V.add_hardpoint(new /obj/item/hardpoint/armor/snowplow)
	V.add_hardpoint(new /obj/item/hardpoint/support/overdrive_enhancer)
	V.add_hardpoint(new /obj/item/hardpoint/secondary/m56cupola/aev)
	V.add_hardpoint(new /obj/item/hardpoint/support/smoke_launcher/aev)

/obj/effect/vehicle_spawner/aev/decrepit/spawn_vehicle()
	var/obj/vehicle/multitile/tank/aev/AEV = new(loc)

	load_misc(AEV)
	handle_direction(AEV)
	load_hardpoints(AEV)
	load_damage(AEV)
	AEV.update_icon()

//DESERT CAMO PRESET
/obj/effect/vehicle_spawner/aev/desert/spawn_vehicle()
	var/obj/vehicle/multitile/tank/aev/desert/AEV = new(loc)

	load_misc(AEV)
	load_hardpoints(AEV)
	handle_direction(AEV)
	AEV.update_icon()

	return AEV

/obj/effect/vehicle_spawner/aev/desert/load_hardpoints(obj/vehicle/multitile/tank/V)
	V.add_hardpoint(new /obj/item/hardpoint/locomotion/treads)
	V.add_hardpoint(new /obj/item/hardpoint/armor/snowplow)
	V.add_hardpoint(new /obj/item/hardpoint/support/overdrive_enhancer)
	V.add_hardpoint(new /obj/item/hardpoint/secondary/m56cupola/aev)
	V.add_hardpoint(new /obj/item/hardpoint/support/smoke_launcher/aev)

//JUNGLE CAMO PRESET
/obj/effect/vehicle_spawner/aev/jungle/spawn_vehicle()
	var/obj/vehicle/multitile/tank/aev/jungle/AEV = new(loc)

	load_misc(AEV)
	load_hardpoints(AEV)
	handle_direction(AEV)
	AEV.update_icon()

	return AEV

/obj/effect/vehicle_spawner/aev/jungle/load_hardpoints(obj/vehicle/multitile/tank/V)
	V.add_hardpoint(new /obj/item/hardpoint/locomotion/treads)
	V.add_hardpoint(new /obj/item/hardpoint/armor/snowplow)
	V.add_hardpoint(new /obj/item/hardpoint/support/overdrive_enhancer)
	V.add_hardpoint(new /obj/item/hardpoint/secondary/m56cupola/aev)
	V.add_hardpoint(new /obj/item/hardpoint/support/smoke_launcher/aev)

//NIGHT/URBAN CAMO PRESET
/obj/effect/vehicle_spawner/aev/night/spawn_vehicle()
	var/obj/vehicle/multitile/tank/aev/night/AEV = new(loc)

	load_misc(AEV)
	load_hardpoints(AEV)
	handle_direction(AEV)
	AEV.update_icon()

	return AEV

/obj/effect/vehicle_spawner/aev/night/load_hardpoints(obj/vehicle/multitile/tank/V)
	V.add_hardpoint(new /obj/item/hardpoint/locomotion/treads)
	V.add_hardpoint(new /obj/item/hardpoint/armor/snowplow)
	V.add_hardpoint(new /obj/item/hardpoint/support/overdrive_enhancer)
	V.add_hardpoint(new /obj/item/hardpoint/secondary/m56cupola/aev)
	V.add_hardpoint(new /obj/item/hardpoint/support/smoke_launcher/aev)
