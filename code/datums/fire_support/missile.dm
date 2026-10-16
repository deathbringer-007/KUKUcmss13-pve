/datum/fire_support/missile
	name = "激光制导导弹打击"
	fire_support_firer = FIRESUPPORT_CAS
	fire_support_type = FIRESUPPORT_TYPE_MISSILE
	scatter_range = 1
	cost = 4
	icon_state = "missile"
	initiate_chat_message = "目标已锁定，导弹即将抵达。"
	initiate_screen_message = list(
		"瞄准吊舱已锁定激光标记，一发导弹已出。",
		"希望这个目标值得，一发导弹出去了。",
		"一份大爆炸，马上送到。",
		"导弹来了，都把头低下。",
		)
	initiate_sound = 'sound/effects/IncomingRocket.ogg'
	start_visual = null
	start_sound = null
	impact_start_visual = /obj/effect/temp_visual/falling_obj/keeper

/datum/fire_support/missile/do_impact(turf/target_turf)
	cell_explosion(target_turf, 450, 80, EXPLOSION_FALLOFF_SHAPE_EXPONENTIAL, null, create_cause_data("LGM strike"))
	for(var/obj/vehicle/multitile/vic in target_turf)
		vic.take_damage_type(1e8, "LGM")
		vic.take_damage_type(1e8, "LGM")
		vic.healthcheck() // JUST DIE
		playsound(vic, 'sound/effects/meteorimpact.ogg', 50)
		vic.at_munition_interior_explosion_effect(1200, 400, cause_data = create_cause_data("LGM strike"))
		vic.interior_crash_effect()

/datum/fire_support/missile/upp
	faction = FACTION_UPP
	fire_support_firer = FIRESUPPORT_CAS_UPP
	fire_support_type = FIRESUPPORT_TYPE_MISSILE_UPP
	portrait_type = "pilot_red"
	initiate_title = "野猪一号"

/datum/fire_support/missile/napalm
	name = "凝固汽油弹打击"
	fire_support_type = FIRESUPPORT_TYPE_NAPALM_MISSILE
	cost = 3
	icon_state = "napalm_missile"
	initiate_chat_message = "目标已锁定，凝固汽油导弹即将抵达。"
	impact_start_visual = /obj/effect/temp_visual/falling_obj/napalm

/datum/fire_support/missile/napalm/do_impact(turf/target_turf)
	cell_explosion(target_turf, 150, 20, EXPLOSION_FALLOFF_SHAPE_LINEAR, null, create_cause_data("Napalm missile"))
	fire_spread(target_turf, create_cause_data("Napalm missile"), 6, 60, 30, "#EE6515")

/datum/fire_support/missile/napalm/upp
	faction = FACTION_UPP
	fire_support_firer = FIRESUPPORT_CAS_UPP
	fire_support_type = FIRESUPPORT_TYPE_NAPALM_MISSILE_UPP
	portrait_type = "pilot_red"
	initiate_title = "野猪一号"

/datum/fire_support/missile/smoke
	name = "烟幕导弹"
	fire_support_type = FIRESUPPORT_TYPE_SMOKE_MISSILE
	cost = 2
	icon_state = "smoke_missile"
	initiate_chat_message = "目标已锁定，烟幕导弹即将抵达。"
	impact_start_visual = /obj/effect/temp_visual/falling_obj/banshee
	///smoke type created when the grenade is primed
	var/datum/effect_system/smoke_spread/smoketype = /datum/effect_system/smoke_spread/bad
	///radius this smoke grenade will encompass
	var/smokeradius = 12
	///The duration of the smoke
	var/smoke_duration = 40

/datum/fire_support/missile/smoke/do_impact(turf/target_turf)
	var/datum/effect_system/smoke_spread/smoke = new smoketype()
	playsound(target_turf, 'sound/effects/smoke.ogg', 25, TRUE)
	smoke.set_up(smokeradius, 0, target_turf, smoke_time = smoke_duration)
	smoke.start()

/datum/fire_support/missile/smoke/upp
	faction = FACTION_UPP
	fire_support_firer = FIRESUPPORT_CAS_UPP
	fire_support_type = FIRESUPPORT_TYPE_SMOKE_MISSILE_UPP
	portrait_type = "pilot_red"
	initiate_title = "野猪一号"

/datum/fire_support/missile/smoke/nerve
	name = "CN-20神经毒气导弹"
	fire_support_type = FIRESUPPORT_TYPE_NERVE_MISSILE_UPP
	cost = 3
	icon_state = "nerve_missile"
	initiate_screen_message = list("神经毒气弹来了！")
	smoketype = /datum/effect_system/smoke_spread/cn20
	smoke_duration = 30

/datum/fire_support/missile/smoke/nerve/upp
	faction = FACTION_UPP
	fire_support_firer = FIRESUPPORT_CAS_UPP
	fire_support_type = FIRESUPPORT_TYPE_NERVE_MISSILE_UPP
	portrait_type = "pilot_red"
	initiate_title = "野猪一号"

/datum/fire_support/missile/smoke/lsd
	name = "LSD致幻气体导弹"
	fire_support_type = FIRESUPPORT_TYPE_LSD_MISSILE_UPP
	cost = 2
	icon_state = "lsd_missile"
	initiate_screen_message = list("LSD致幻气体弹来了！")
	smoketype = /datum/effect_system/smoke_spread/LSD
	smoke_duration = 30

/datum/fire_support/missile/smoke/lsd/upp
	faction = FACTION_UPP
	fire_support_firer = FIRESUPPORT_CAS_UPP
	fire_support_type = FIRESUPPORT_TYPE_LSD_MISSILE_UPP
	portrait_type = "pilot_red"
	initiate_title = "野猪一号"
