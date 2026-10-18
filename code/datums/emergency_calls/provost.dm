//*******************************************************************************************************
//Provost Enforcer Team
/datum/emergency_call/provost_enforcer
	name = "USCM Provost Enforcers"
	mob_max = 5
	mob_min = 5
	probability = 0

/datum/emergency_call/provost_enforcer/New()
	objectives = "部署到 [MAIN_SHIP_NAME]，执行《陆战队军法》。"
	return ..()

/datum/emergency_call/provost_enforcer/create_member(datum/mind/M, turf/override_spawn_loc)
	var/turf/T = override_spawn_loc ? override_spawn_loc : get_spawn_point()

	if(!istype(T))
		return FALSE

	var/mob/living/carbon/human/H = new(T)
	M.transfer_to(H, TRUE)

	if(!leader && HAS_FLAG(H.client.prefs.toggles_ert, PLAY_LEADER) && check_timelock(H.client, list(JOB_WARDEN, JOB_CHIEF_POLICE), time_required_for_job))    //First one spawned is always the leader.
		leader = H
		arm_equipment(H, /datum/equipment_preset/uscm_event/provost/tml, TRUE, TRUE)
		to_chat(H, SPAN_ROLE_HEADER("你是军法监察执法小队的队长！"))
		to_chat(H, SPAN_ROLE_BODY("直接服从最高指挥部下达的所有命令！"))
		to_chat(H, SPAN_ROLE_BODY("你只对《陆战队军法》和军法监察长负责！"))
	else
		arm_equipment(H, /datum/equipment_preset/uscm_event/provost/enforcer, TRUE, TRUE)
		to_chat(H, SPAN_ROLE_HEADER("你是军法监察执法小队的一员！"))
		to_chat(H, SPAN_ROLE_BODY("服从最高指挥部或你的小队长下达的所有命令！"))
		to_chat(H, SPAN_ROLE_BODY("你只对你的上级、《陆战队军法》和最高指挥部负责！"))

	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(to_chat), H, SPAN_BOLD("目标：[objectives]")), 1 SECONDS)


/datum/emergency_call/provost_enforcer/spawn_items()
	var/turf/drop_spawn

	drop_spawn = get_spawn_point(TRUE)
	new /obj/item/storage/box/handcuffs(drop_spawn)
	new /obj/item/storage/box/handcuffs(drop_spawn)
