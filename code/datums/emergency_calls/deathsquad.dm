


//Weyland-Yutani Deathsquad - W-Y Deathsquad. Event only
/datum/emergency_call/death
	name = "Weyland Whiteout Operators (!DEATHSQUAD!)"
	mob_max = 8
	mob_min = 5
	arrival_message = "“*杂音*杀光他们……不留目击者……通话完毕……*杂音*”"
	objectives = "目标区域已启动白幕协议。确保感染痕迹和目击者都被彻底清除。"
	probability = 0
	shuttle_id = MOBILE_SHUTTLE_ID_ERT2
	home_base = /datum/lazy_template/ert/weyland_station
	name_of_spawn = /obj/effect/landmark/ert_spawns/distress_pmc
	item_spawn = /obj/effect/landmark/ert_spawns/distress_pmc/item
	max_medics = 1
	max_heavies = 2
	hostility = TRUE


// DEATH SQUAD--------------------------------------------------------------------------------
/datum/emergency_call/death/create_member(datum/mind/player, turf/override_spawn_loc)
	var/turf/spawn_loc = override_spawn_loc ? override_spawn_loc : get_spawn_point()

	if(!istype(spawn_loc))
		return //Didn't find a useable spawn point.

	var/mob/living/carbon/human/person = new(spawn_loc)
	player.transfer_to(person, TRUE)

	if(!leader && HAS_FLAG(person.client.prefs.toggles_ert, PLAY_LEADER) && check_timelock(person.client, JOB_SQUAD_LEADER, time_required_for_job))
		leader = person
		to_chat(person, SPAN_ROLE_HEADER("你是白幕小队的队长！"))
		to_chat(person, SPAN_ROLE_BODY("目标区域已启动白幕协议。除非维兰德-汤谷董事级或以上人员另有指示，否则必须迅速清除舰上全部资产。"))
		arm_equipment(person, /datum/equipment_preset/pmc/w_y_whiteout/leader, TRUE, TRUE)
	else if(medics < max_medics && HAS_FLAG(person.client.prefs.toggles_ert, PLAY_MEDIC) && check_timelock(person.client, JOB_SQUAD_MEDIC, time_required_for_job))
		medics++
		to_chat(person, SPAN_ROLE_HEADER("你是白幕小队的医疗兵！"))
		to_chat(person, SPAN_ROLE_BODY("目标区域已启动白幕协议。除非维兰德-汤谷董事级或以上人员另有指示，否则必须迅速清除舰上全部资产。"))
		arm_equipment(person, /datum/equipment_preset/pmc/w_y_whiteout/medic, TRUE, TRUE)
	else if(heavies < max_heavies && HAS_FLAG(person.client.prefs.toggles_ert, PLAY_SMARTGUNNER) && check_timelock(person.client, list(JOB_SQUAD_SPECIALIST, JOB_SQUAD_SMARTGUN), time_required_for_job))
		heavies++
		to_chat(person, SPAN_ROLE_HEADER("你是白幕小队的终结者！"))
		to_chat(person, SPAN_ROLE_BODY("目标区域已启动白幕协议。除非维兰德-汤谷董事级或以上人员另有指示，否则必须迅速清除舰上全部资产。"))
		arm_equipment(person, /datum/equipment_preset/pmc/w_y_whiteout/terminator, TRUE, TRUE)
	else
		to_chat(person, SPAN_ROLE_HEADER("你是白幕小队的行动干员！"))
		to_chat(person, SPAN_ROLE_BODY("目标区域已启动白幕协议。除非维兰德-汤谷董事级或以上人员另有指示，否则必须迅速清除舰上全部资产。"))
		arm_equipment(person, /datum/equipment_preset/pmc/w_y_whiteout, TRUE, TRUE)

	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(to_chat), person, SPAN_BOLD("目标：[objectives]")), 1 SECONDS)

/datum/emergency_call/death/low_threat
	name = "Weyland Whiteout Operators"

// DEATH SQUAD--------------------------------------------------------------------------------
/datum/emergency_call/death/low_threat/create_member(datum/mind/player, turf/override_spawn_loc)
	var/turf/spawn_loc = override_spawn_loc ? override_spawn_loc : get_spawn_point()

	if(!istype(spawn_loc))
		return //Didn't find a useable spawn point.

	var/mob/living/carbon/human/person = new(spawn_loc)
	player.transfer_to(person, TRUE)

	if(!leader && HAS_FLAG(person.client.prefs.toggles_ert, PLAY_LEADER) && check_timelock(person.client, JOB_SQUAD_LEADER, time_required_for_job))
		leader = person
		to_chat(person, SPAN_ROLE_HEADER("你是白幕小队的队长！"))
		to_chat(person, SPAN_ROLE_BODY("目标区域已启动白幕协议。除非维兰德-汤谷董事级或以上人员另有指示，否则必须迅速清除舰上全部资产。"))
		arm_equipment(person, /datum/equipment_preset/pmc/w_y_whiteout/low_threat/leader, TRUE, TRUE)
	else if(medics < max_medics && HAS_FLAG(person.client.prefs.toggles_ert, PLAY_MEDIC) && check_timelock(person.client, JOB_SQUAD_MEDIC, time_required_for_job))
		medics++
		to_chat(person, SPAN_ROLE_HEADER("你是白幕小队的医疗兵！"))
		to_chat(person, SPAN_ROLE_BODY("目标区域已启动白幕协议。除非维兰德-汤谷董事级或以上人员另有指示，否则必须迅速清除舰上全部资产。"))
		arm_equipment(person, /datum/equipment_preset/pmc/w_y_whiteout/low_threat/medic, TRUE, TRUE)
	else if(heavies < max_heavies && HAS_FLAG(person.client.prefs.toggles_ert, PLAY_SMARTGUNNER) && check_timelock(person.client, list(JOB_SQUAD_SPECIALIST, JOB_SQUAD_SMARTGUN), time_required_for_job))
		heavies++
		to_chat(person, SPAN_ROLE_HEADER("你是白幕小队的终结者！"))
		to_chat(person, SPAN_ROLE_BODY("目标区域已启动白幕协议。除非维兰德-汤谷董事级或以上人员另有指示，否则必须迅速清除舰上全部资产。"))
		arm_equipment(person, /datum/equipment_preset/pmc/w_y_whiteout/low_threat/terminator, TRUE, TRUE)
	else
		to_chat(person, SPAN_ROLE_HEADER("你是白幕小队的行动干员！"))
		to_chat(person, SPAN_ROLE_BODY("目标区域已启动白幕协议。除非维兰德-汤谷董事级或以上人员另有指示，否则必须迅速清除舰上全部资产。"))
		arm_equipment(person, /datum/equipment_preset/pmc/w_y_whiteout/low_threat, TRUE, TRUE)

	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(to_chat), person, SPAN_BOLD("目标：[objectives]")), 1 SECONDS)
