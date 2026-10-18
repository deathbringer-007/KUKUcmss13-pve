
//Anti-riot team
/datum/emergency_call/riot
	name = "USCM Riot Control"
	localized_name = "陆战队防暴队"
	mob_max = 10
	mob_min = 5
	objectives = "确保恢复秩序并维护《陆战队军法》。"
	probability = 0


/datum/emergency_call/riot/create_member(datum/mind/M, turf/override_spawn_loc)
	var/turf/T = override_spawn_loc ? override_spawn_loc : get_spawn_point()

	if(!istype(T))
		return FALSE

	var/mob/living/carbon/human/H = new(T)
	M.transfer_to(H, TRUE)

	if(!leader && HAS_FLAG(H.client.prefs.toggles_ert, PLAY_LEADER) && check_timelock(H.client, list(JOB_WARDEN, JOB_CHIEF_POLICE), time_required_for_job))
		leader = H
		arm_equipment(H, /datum/equipment_preset/uscm_ship/uscm_police/riot_mp/riot_cmp, TRUE, TRUE)
		to_chat(H, SPAN_ROLE_HEADER("你是最高指挥部防暴部队的指挥官！"))
		to_chat(H, SPAN_ROLE_BODY("直接服从最高指挥部下达的所有命令！"))
		to_chat(H, SPAN_ROLE_BODY("你只对《陆战队军法》和最高指挥部负责！"))
	else
		arm_equipment(H, /datum/equipment_preset/uscm_ship/uscm_police/riot_mp, TRUE, TRUE)
		to_chat(H, SPAN_ROLE_HEADER("你是最高指挥部防暴部队的一员！"))
		to_chat(H, SPAN_ROLE_BODY("服从最高指挥部或你的上级下达的所有命令！"))
		to_chat(H, SPAN_ROLE_BODY("你只对你的上级、《陆战队军法》和最高指挥部负责！"))

	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(to_chat), H, SPAN_BOLD("目标：[objectives]")), 1 SECONDS)


/datum/emergency_call/riot/spawn_items()
	var/turf/drop_spawn

	drop_spawn = get_spawn_point(TRUE)
	new /obj/item/storage/box/handcuffs(drop_spawn)
	new /obj/item/storage/box/handcuffs(drop_spawn)

	drop_spawn = get_spawn_point(TRUE)
	new /obj/item/storage/box/handcuffs(drop_spawn)
	new /obj/item/storage/box/handcuffs(drop_spawn)

	drop_spawn = get_spawn_point(TRUE)
	new /obj/item/ammo_magazine/shotgun/beanbag(drop_spawn)
	new /obj/item/ammo_magazine/shotgun/beanbag(drop_spawn)
	new /obj/item/ammo_magazine/shotgun/beanbag(drop_spawn)
	drop_spawn = get_spawn_point(TRUE)
	new /obj/item/ammo_magazine/shotgun/beanbag(drop_spawn)
	new /obj/item/ammo_magazine/shotgun/beanbag(drop_spawn)
	new /obj/item/ammo_magazine/shotgun/beanbag(drop_spawn)

	drop_spawn = get_spawn_point(TRUE)
	new /obj/item/ammo_box/magazine/nade_box/ltl/tear_gas(drop_spawn)
	new /obj/item/ammo_box/magazine/nade_box/ltl/tear_gas(drop_spawn)

	drop_spawn = get_spawn_point(TRUE)
	new /obj/item/ammo_magazine/shotgun/buckshot(drop_spawn)
	new /obj/item/ammo_magazine/shotgun/buckshot(drop_spawn)
	drop_spawn = get_spawn_point(TRUE)
	new /obj/item/ammo_magazine/shotgun/buckshot(drop_spawn)
	new /obj/item/ammo_magazine/shotgun/buckshot(drop_spawn)

	drop_spawn = get_spawn_point(TRUE)
	new /obj/item/weapon/gun/launcher/grenade/m81/riot(drop_spawn)
	new /obj/item/weapon/gun/launcher/grenade/m81/riot(drop_spawn)
	drop_spawn = get_spawn_point(TRUE)
	new /obj/item/weapon/gun/launcher/grenade/m81/riot(drop_spawn)
	new /obj/item/weapon/gun/launcher/grenade/m81/riot(drop_spawn)
