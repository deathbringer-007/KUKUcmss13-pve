
//A gaggle of gladiators
/datum/emergency_call/deus_vult
	name = "Deus Vult!"
	mob_max = 35
	mob_min = 10
	max_heavies = 10
	arrival_message = "“天主所愿。天主所愿！天主所愿！！”"
	objectives = "清除此地的一切不洁之物！荣耀赴死！"
	probability = 0
	hostility = TRUE

/datum/emergency_call/deus_vult/create_member(datum/mind/M, turf/override_spawn_loc)
	var/turf/spawn_loc = override_spawn_loc ? override_spawn_loc : get_spawn_point()

	if(!istype(spawn_loc))
		return //Didn't find a useable spawn point.

	var/mob/living/carbon/human/H = new(spawn_loc)
	M.transfer_to(H, TRUE)

	if(!leader && HAS_FLAG(H.client.prefs.toggles_ert, PLAY_LEADER) && check_timelock(H.client, JOB_SQUAD_LEADER, time_required_for_job))
		leader = H
		arm_equipment(H, /datum/equipment_preset/other/gladiator/leader, TRUE, TRUE)
		to_chat(H, SPAN_ROLE_HEADER("你是这些神圣战士的领袖！"))
		to_chat(H, SPAN_ROLE_BODY("你必须清除这个可憎之地的一切不洁痕迹！"))
		to_chat(H, SPAN_ROLE_BODY("直接服从至高力量下达的所有命令！"))
	else if(heavies < max_heavies && HAS_FLAG(H.client.prefs.toggles_ert, PLAY_HEAVY))
		heavies++
		arm_equipment(H, /datum/equipment_preset/other/gladiator/champion, TRUE, TRUE)
		to_chat(H, SPAN_ROLE_HEADER("你是神圣战士中的勇士！"))
		to_chat(H, SPAN_ROLE_BODY("你必须清除这个可憎之地的一切不洁痕迹！"))
		to_chat(H, SPAN_ROLE_BODY("直接服从至高力量下达的所有命令！"))
	else
		arm_equipment(H, /datum/equipment_preset/other/gladiator, TRUE, TRUE)
		to_chat(H, SPAN_ROLE_HEADER("你是一名神圣战士！"))
		to_chat(H, SPAN_ROLE_BODY("你必须清除这个可憎之地的一切不洁痕迹！"))
		to_chat(H, SPAN_ROLE_BODY("直接服从至高力量下达的所有命令！"))

	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(to_chat), H, SPAN_BOLD("目标：[objectives]")), 1 SECONDS)
