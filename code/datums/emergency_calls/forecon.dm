/datum/emergency_call/forecon
	name = "FORECON (Squad)"
	localized_name = "武装侦察部队（小队）"
	arrival_message = "一支武装侦察小队已奉命前往你们的舰船。请待命。"
	objectives = "处理当前出现的威胁。后续可能下达进一步命令。"
	home_base = /datum/lazy_template/ert/uscm_station
	probability = 0
	mob_min = 3
	mob_max = 6

	max_heavies = 1
	max_medics = 1
	max_smartgunners = 1

/datum/emergency_call/forecon/create_member(datum/mind/new_mind, turf/override_spawn_loc)
	var/turf/spawn_loc = override_spawn_loc ? override_spawn_loc : get_spawn_point()

	if(!istype(spawn_loc))
		return //Didn't find a useable spawn point.

	var/mob/living/carbon/human/mob = new(spawn_loc)
	new_mind.transfer_to(mob, TRUE)

	if(!leader && HAS_FLAG(mob.client.prefs.toggles_ert, PLAY_LEADER) && check_timelock(mob.client, JOB_SQUAD_LEADER, time_required_for_job))
		leader = mob
		arm_equipment(mob, /datum/equipment_preset/uscm/forecon/squad_leader, TRUE, TRUE)
		to_chat(mob, SPAN_ROLE_HEADER("你是武装侦察部队的小队长！"))

	else if(medics < max_medics && HAS_FLAG(mob.client.prefs.toggles_ert, PLAY_MEDIC) && check_timelock(mob.client, JOB_SQUAD_MEDIC, time_required_for_job))
		medics++
		arm_equipment(mob, /datum/equipment_preset/uscm/forecon/tech, TRUE, TRUE)
		to_chat(mob, SPAN_ROLE_HEADER("你是武装侦察部队的支援技师！"))

	else if(smartgunners < max_smartgunners && HAS_FLAG(mob.client.prefs.toggles_ert, PLAY_SMARTGUNNER) && check_timelock(mob.client, JOB_SQUAD_SMARTGUN))
		smartgunners++
		to_chat(mob, SPAN_ROLE_HEADER("你是武装侦察部队的一名智能机枪手！"))
		arm_equipment(mob, /datum/equipment_preset/uscm/forecon/smartgunner, TRUE, TRUE)

	else if(heavies < max_heavies && HAS_FLAG(mob.client.prefs.toggles_ert, PLAY_HEAVY) && check_timelock(mob.client, JOB_SQUAD_SPECIALIST))
		heavies++
		to_chat(mob, SPAN_ROLE_HEADER("你是武装侦察部队的一名精确射手！"))
		arm_equipment(mob, /datum/equipment_preset/uscm/forecon/marksman, TRUE, TRUE)

	else
		arm_equipment(mob, /datum/equipment_preset/uscm/forecon/standard, TRUE, TRUE)
		to_chat(mob, SPAN_ROLE_HEADER("你是武装侦察部队的一名步枪兵！"))

	to_chat(mob, SPAN_ROLE_BODY("你是美国殖民地海军陆战队武装侦察部队的成员。武装侦察部队专门执行敌后特种作战，或在常规陆战队难以应对的环境下开展侦察。"))
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(to_chat), mob, SPAN_BOLD("目标：</b>[objectives]")), 1 SECONDS)

/datum/emergency_call/forecon/platoon
	name = "FORECON (Platoon)"
	localized_name = "武装侦察部队（排）"
	mob_min = 6
	mob_max = 30
	probability = 0
	max_medics = 6
	max_heavies = 1
	max_smartgunners = 2

/datum/emergency_call/forecon/platoon/New()
	..()
	arrival_message = "一支武装侦察小队已奉命前往你们的舰船。请待命。"
	objectives = "处理当前出现的威胁。后续可能下达进一步命令。"
