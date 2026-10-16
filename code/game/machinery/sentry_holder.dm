/obj/structure/machinery/sentry_holder
	name = "哨戒炮塔部署系统"
	desc = "能部署哨戒炮塔的箱体。"
	density = FALSE
	anchored = TRUE
	unacidable = 1
	icon = 'icons/obj/structures/props/almayer_props.dmi'
	icon_state = "sentry_system_installed"
	active_power_usage = 5000
	idle_power_usage = 1000
	power_channel = 1
	use_power = USE_POWER_IDLE
	var/deployment_cooldown
	var/turret_path = /obj/structure/machinery/defenses/sentry/premade/deployable // Path of the turret used
	var/obj/structure/machinery/defenses/sentry/premade/deployable/deployed_turret
	var/ox = 0
	var/oy = 0
	var/require_red_alert = FALSE
	var/base_icon_state = "sentry_system"

/obj/structure/machinery/sentry_holder/Initialize()
	. = ..()
	if(!deployed_turret)
		deployed_turret = new turret_path(src)
		deployed_turret.deployment_system = src
		ox = pixel_x
		oy = pixel_y

/obj/structure/machinery/sentry_holder/Destroy()
	QDEL_NULL(deployed_turret)
	. = ..()

/obj/structure/machinery/sentry_holder/get_examine_text(mob/user)
	. = ..()
	if(!deployed_turret)
		. += "它已离线。"

/obj/structure/machinery/sentry_holder/attack_hand(mob/user)
	if(!deployed_turret)
		to_chat(user, SPAN_WARNING("[src]没有反应。"))
		return

	if(deployment_cooldown > world.time)
		to_chat(user, SPAN_WARNING("[src]正在工作。"))
		return

	if(deployed_turret.loc == src) //not deployed
		if(stat & NOPOWER)
			to_chat(user, SPAN_WARNING("[src]无法运作。"))
			return

		if(require_red_alert && (seclevel2num(get_security_level()) < SEC_LEVEL_RED))
			to_chat(user, SPAN_WARNING("[src]只能在紧急情况下启动。"))
			return

		to_chat(user, SPAN_NOTICE("你展开了[src]。"))
		deploy_sentry()
		return

	to_chat(user, SPAN_NOTICE("你收回了[src]。"))
	undeploy_sentry()
	return

/obj/structure/machinery/sentry_holder/update_use_power(new_use_power)
	..()

	if(!(stat & NOPOWER))
		return

	undeploy_sentry()

/obj/structure/machinery/sentry_holder/proc/deploy_sentry()
	if(!deployed_turret)
		return

	playsound(loc, 'sound/machines/hydraulics_1.ogg', 40, 1)
	deployment_cooldown = world.time + 50
	deployed_turret.turned_on = TRUE
	deployed_turret.forceMove(loc)
	icon_state = "[base_icon_state]_deployed"

	if(deployed_turret.density)
		for(var/mob/blocking_mob in deployed_turret.loc)
			if(deployed_turret.loc == loc)
				step(blocking_mob, deployed_turret.dir)
			else
				step(blocking_mob, get_dir(src, deployed_turret))

	deployed_turret.setDir(dir)
	deployed_turret.pixel_x = 0
	deployed_turret.pixel_y = 0

	deployed_turret.start_processing()
	deployed_turret.set_range()

/obj/structure/machinery/sentry_holder/proc/undeploy_sentry()
	if(!deployed_turret)
		return

	playsound(loc, 'sound/machines/hydraulics_2.ogg', 40, 1)
	deployment_cooldown = world.time + 50
	deployed_turret.forceMove(src)
	deployed_turret.turned_on = FALSE
	deployed_turret.stop_processing()
	deployed_turret.unset_range()
	pixel_x = ox
	pixel_y = oy
	icon_state = "[base_icon_state]_installed"

/obj/structure/machinery/sentry_holder/colony
	desc = "能部署哨戒炮塔的箱体，用于保护附近居民。"
	turret_path = /obj/structure/machinery/defenses/sentry/premade/deployable/colony

/obj/structure/machinery/sentry_holder/wy
	health = 200
	desc = "能部署哨戒炮塔的箱体，用于保护维兰德-汤谷人员。"
	turret_path = /obj/structure/machinery/defenses/sentry/premade/deployable/wy

/obj/structure/machinery/sentry_holder/almayer
	icon_state = "floor_sentry_installed"
	turret_path = /obj/structure/machinery/defenses/sentry/premade/deployable/almayer
	base_icon_state = "floor_sentry"
	require_red_alert = TRUE

/obj/structure/machinery/sentry_holder/almayer/mini
	turret_path = /obj/structure/machinery/defenses/sentry/premade/deployable/almayer/mini

/obj/structure/machinery/sentry_holder/almayer/mini/aicore

/obj/structure/machinery/sentry_holder/almayer/mini/aicore/Initialize()
	. = ..()
	RegisterSignal(SSdcs, COMSIG_GLOB_AICORE_LOCKDOWN, PROC_REF(auto_deploy))
	RegisterSignal(SSdcs, COMSIG_GLOB_AICORE_LIFT, PROC_REF(undeploy_sentry))

/obj/structure/machinery/sentry_holder/almayer/mini/aicore/proc/auto_deploy()
	if(deployed_turret.loc == src) //not deployed
		if(stat & NOPOWER)
			return FALSE

		deploy_sentry()
		return TRUE

/obj/structure/machinery/sentry_holder/almayer/mini/aicore/attack_hand(mob/user)
	to_chat(user, SPAN_WARNING("[src]只能远程部署。"))
	return

/obj/structure/machinery/sentry_holder/landing_zone
	icon_state = "floor_sentry_installed" // TODO: More appropriate sprites
	turret_path = /obj/structure/machinery/defenses/sentry/premade/deployable/colony/landing_zone
	base_icon_state = "floor_sentry" // TODO: More appropriate sprites
	layer = HATCH_LAYER // Needs to not hide barricades

/obj/structure/machinery/sentry_holder/landing_zone/attack_hand(mob/user)
	var/obj/structure/machinery/defenses/sentry/premade/deployable/colony/landing_zone/turret = deployed_turret
	if(!istype(turret))
		to_chat(user, SPAN_WARNING("[src]没有反应。"))
		return

	if(deployment_cooldown > world.time)
		to_chat(user, SPAN_WARNING("[src]正在工作。"))
		return

	if(deployed_turret.loc == src) //not deployed
		if(turret.battery_state == TURRET_BATTERY_STATE_DEAD)
			to_chat(user, SPAN_WARNING("[src]无法运作。"))
			return

		if(require_red_alert && (seclevel2num(get_security_level()) < SEC_LEVEL_RED))
			to_chat(user, SPAN_WARNING("[src]只能在紧急情况下启动。"))
			return

		to_chat(user, SPAN_NOTICE("你展开了[src]。"))
		deploy_sentry()
		msg_admin_niche("[key_name(user)] deployed [turret] at [get_location_in_text(src)] [ADMIN_JMP(loc)]")
		return

	to_chat(user, SPAN_NOTICE("你收回了[src]。"))
	msg_admin_niche("[key_name(user)] retracted [turret] at [get_location_in_text(src)] [ADMIN_JMP(loc)]")
	undeploy_sentry()
	return

/obj/structure/machinery/sentry_holder/landing_zone/update_use_power(new_use_power)
	return
