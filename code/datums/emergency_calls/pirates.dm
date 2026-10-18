
//A gaggle of gladiators
/datum/emergency_call/pirates
	name = "Fun - Pirates"
	mob_max = 35
	mob_min = 10
	arrival_message = "“醉醺醺的水手该怎么办？醉醺醺的水手该怎么办？醉醺醺的水手该怎么办，大清早的怎么办？”"
	objectives = "当海盗！掠夺！勒索赎金！"
	probability = 0
	hostility = TRUE

/datum/emergency_call/pirates/create_member(datum/mind/M, turf/override_spawn_loc)
	var/turf/spawn_loc = override_spawn_loc ? override_spawn_loc : get_spawn_point()

	if(!istype(spawn_loc))
		return //Didn't find a useable spawn point.

	var/mob/living/carbon/human/H = new(spawn_loc)
	M.transfer_to(H, TRUE)
	if(!leader && HAS_FLAG(H.client.prefs.toggles_ert, PLAY_LEADER) && check_timelock(H.client, JOB_SQUAD_LEADER, time_required_for_job))
		leader = H
		arm_equipment(H, /datum/equipment_preset/fun/pirate/captain, TRUE, TRUE)
		to_chat(H, SPAN_ROLE_HEADER("你是这群快活海盗的头领！"))
		to_chat(H, SPAN_ROLE_BODY("把这里洗劫一空！搬走所有没有钉死的值钱东西！"))
	else
		arm_equipment(H, /datum/equipment_preset/fun/pirate, TRUE, TRUE)
		to_chat(H, SPAN_ROLE_HEADER("你是一名快活的海盗！呀哈！"))
		to_chat(H, SPAN_ROLE_BODY("把这里洗劫一空！搬走所有没有钉死的值钱东西！"))

	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(to_chat), H, SPAN_BOLD("目标：[objectives]")), 1 SECONDS)
