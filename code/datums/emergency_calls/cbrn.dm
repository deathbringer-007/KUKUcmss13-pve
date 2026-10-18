/datum/emergency_call/cbrn
	name = "CBRN (Squad)"
	arrival_message = "注意，这里是USS库尔茨号。我们已响应求救，派出一支核生化小队前往你们的舰船。请等待抵达。"
	objectives = "处理化学、生物、放射性或核威胁。后续可能下达进一步命令。"
	home_base = /datum/lazy_template/ert/uscm_station
	mob_min = 3
	mob_max = 5
	max_heavies = 0
	max_smartgunners = 0

/datum/emergency_call/cbrn/create_member(datum/mind/new_mind, turf/override_spawn_loc)
	var/turf/spawn_loc = override_spawn_loc ? override_spawn_loc : get_spawn_point()

	if(!istype(spawn_loc))
		return //Didn't find a useable spawn point.

	var/mob/living/carbon/human/mob = new(spawn_loc)
	new_mind.transfer_to(mob, TRUE)

	if(!leader && HAS_FLAG(mob.client.prefs.toggles_ert, PLAY_LEADER) && check_timelock(mob.client, JOB_SQUAD_LEADER, time_required_for_job))
		leader = mob
		arm_equipment(mob, /datum/equipment_preset/uscm/cbrn/leader, TRUE, TRUE)
		to_chat(mob, SPAN_ROLE_HEADER("你是核生化战斗组的组长！"))

	else if(medics < max_medics && HAS_FLAG(mob.client.prefs.toggles_ert, PLAY_MEDIC) && check_timelock(mob.client, JOB_SQUAD_MEDIC, time_required_for_job))
		medics++
		arm_equipment(mob, /datum/equipment_preset/uscm/cbrn/medic, TRUE, TRUE)
		to_chat(mob, SPAN_ROLE_HEADER("你是核生化小队的医疗兵！"))

	else if(engineers < max_engineers && HAS_FLAG(mob.client.prefs.toggles_ert, PLAY_ENGINEER) && check_timelock(mob.client, JOB_SQUAD_ENGI, time_required_for_job))
		engineers++
		arm_equipment(mob, /datum/equipment_preset/uscm/cbrn/engineer, TRUE, TRUE)
		to_chat(mob, SPAN_ROLE_HEADER("你是核生化小队的工程兵！"))

	else
		arm_equipment(mob, /datum/equipment_preset/uscm/cbrn/standard, TRUE, TRUE)
		to_chat(mob, SPAN_ROLE_HEADER("你是核生化小队的步枪兵！"))

	to_chat(mob, SPAN_ROLE_BODY("你是美国殖民地海军陆战队核生化部队的一员。核生化部队专门处理化学、生物、放射性与核威胁。"))
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(to_chat), mob, SPAN_BOLD("目标：</b>[objectives]")), 1 SECONDS)

/datum/emergency_call/cbrn/ert
	name = "CBRN (Distress)"
	arrival_message = "注意，这里是USS库尔茨号。我们已响应求救，派出一支核生化小队前往你们的舰船。请等待抵达。"
	probability = 10

/datum/emergency_call/cbrn/ert/New()
	..()
	objectives = "调查 [MAIN_SHIP_NAME] 上的求救信号。"

/datum/emergency_call/cbrn/specialists
	name = "CBRN (Specialists)"
	mob_min = 2
	mob_max = 5
	max_engineers = 0
	max_medics = 0

/datum/emergency_call/cbrn/specialists/New()
	var/cbrn_ship_name = "Unit [pick(GLOB.nato_phonetic_alphabet)]-[rand(1, 99)]"
	arrival_message = "[MAIN_SHIP_NAME]，核生化部队 [cbrn_ship_name] 已出动。请遵从 [cbrn_ship_name] 下达的所有命令。"
	objectives = "你们是 [cbrn_ship_name] 派出的专家小队，负责平息针对 [MAIN_SHIP_NAME] 的威胁。后续可能下达进一步命令。"

/datum/emergency_call/cbrn/specialists/create_member(datum/mind/new_mind, turf/override_spawn_loc)
	var/turf/spawn_loc = override_spawn_loc ? override_spawn_loc : get_spawn_point()

	if(!istype(spawn_loc))
		return //Didn't find a useable spawn point.

	var/mob/living/carbon/human/mob = new(spawn_loc)
	new_mind.transfer_to(mob, TRUE)

	if(!leader && HAS_FLAG(mob.client.prefs.toggles_ert, PLAY_LEADER) && check_timelock(mob.client, JOB_SQUAD_LEADER, time_required_for_job))
		leader = mob
		arm_equipment(mob, /datum/equipment_preset/uscm/cbrn/specialist/lead, TRUE, TRUE)
		to_chat(mob, SPAN_ROLE_HEADER("你是核生化专家小队的小队长！"))
	else
		arm_equipment(mob, /datum/equipment_preset/uscm/cbrn/specialist, TRUE, TRUE)
		to_chat(mob, SPAN_ROLE_HEADER("你是一名核生化专家！"))

	to_chat(mob, SPAN_ROLE_BODY("你是美国殖民地海军陆战队核生化部队的一员。核生化部队专门处理化学、生物、放射性与核威胁。"))
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(to_chat), mob, SPAN_BOLD("目标：</b>[objectives]")), 1 SECONDS)
