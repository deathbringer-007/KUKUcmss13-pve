//Xeno Cultists
/datum/emergency_call/xeno_cult
	name = "Xeno Cultists"
	mob_max = 6
	arrival_message = "“咿呀！咿呀！”"
	objectives = "尽一切可能支援异形，必要时为它们献出生命！"
	probability = 0
	hostility = TRUE
	var/max_synths = 1
	var/synths = 0

/datum/emergency_call/xeno_cult/print_backstory(mob/living/carbon/human/H)
	to_chat(H, SPAN_BOLD("异形降临尼洛德星区，赐予了这里荣光！是时候让它们的荣耀传遍群星了！"))

/datum/emergency_call/xeno_cult/create_member(datum/mind/M, turf/override_spawn_loc)
	var/turf/spawn_loc = override_spawn_loc ? override_spawn_loc : get_spawn_point()

	if(!istype(spawn_loc))
		return //Didn't find a useable spawn point.

	var/mob/living/carbon/human/H = new(spawn_loc)
	M.transfer_to(H, TRUE)

	if(!leader && HAS_FLAG(H.client.prefs.toggles_ert, PLAY_LEADER) && check_timelock(H.client, JOB_SQUAD_LEADER, time_required_for_job))
		leader = H
		to_chat(H, SPAN_ROLE_HEADER("你是这个异形教派的领袖！为母皇带来荣耀！"))
		arm_equipment(H, /datum/equipment_preset/other/xeno_cultist/leader, TRUE, TRUE)
	else if(synths < max_synths && HAS_FLAG(H.client.prefs.toggles_ert, PLAY_SYNTH) && H.client.check_whitelist_status(WHITELIST_SYNTHETIC))
		synths++
		to_chat(H, SPAN_ROLE_HEADER("你是异形教派的合成人！照料巢群和俘获的宿主，确保巢群壮大！"))
		arm_equipment(H, /datum/equipment_preset/synth/survivor/cultist_synth, TRUE, TRUE)
	else
		to_chat(H, SPAN_ROLE_HEADER("你是一名异形教徒！依次服从母皇、女皇和教派领袖的命令！"))
		arm_equipment(H, /datum/equipment_preset/other/xeno_cultist, TRUE, TRUE)
	print_backstory(H)

	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(to_chat), H, SPAN_BOLD("目标：[objectives]")), 1 SECONDS)
