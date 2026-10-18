


//Randomly-equipped mercenaries. May be friendly or hostile to the USCM, hostile to xenos.
/datum/emergency_call/mercs
	name = "Freelancers (Squad)"
	localized_name = "自由佣兵（小队）"
	mob_max = 8
	probability = 20


/datum/emergency_call/mercs/New()
	. = ..()
	hostility = pick(75;FALSE,25;TRUE)
	arrival_message = "[MAIN_SHIP_NAME]，这里是响应求救的自由佣兵穿梭机 [pick(GLOB.alphabet_lowercase)][pick(GLOB.alphabet_lowercase)]-[rand(1, 99)]。请准备接受登舰。"
	if(hostility)
		objectives = "洗劫 [MAIN_SHIP_NAME]，杀死所有挡路的人。听从首领的命令，不惜一切代价确保自己活下来。"
	else
		objectives = "帮助 [MAIN_SHIP_NAME] 的船员以换取报酬，并谨慎选择报酬。听从首领的命令，不惜一切代价确保自己活下来。"

/datum/emergency_call/mercs/friendly //if admins want to specifically call in friendly ones
	name = "Friendly Freelancers (Squad)"
	localized_name = "友善自由佣兵（小队）"
	mob_max = 8
	probability = 0

/datum/emergency_call/mercs/friendly/New()
	. = ..()
	hostility = FALSE
	arrival_message = "[MAIN_SHIP_NAME]，这里是响应求救的自由佣兵穿梭机 [pick(GLOB.alphabet_lowercase)][pick(GLOB.alphabet_lowercase)]-[rand(1, 99)]。请准备接受登舰。"
	objectives = "帮助 [MAIN_SHIP_NAME] 的船员以换取报酬，并谨慎选择报酬。听从首领的命令，不惜一切代价确保自己活下来。"

/datum/emergency_call/mercs/hostile //ditto
	name = "Hostile Freelancers (Squad)"
	localized_name = "敌对自由佣兵（小队）"
	mob_max = 8
	probability = 0

/datum/emergency_call/mercs/hostile/New()
	. = ..()
	hostility = TRUE
	arrival_message = "[MAIN_SHIP_NAME]，这里是响应求救的自由佣兵穿梭机 [pick(GLOB.alphabet_lowercase)][pick(GLOB.alphabet_lowercase)]-[rand(1, 99)]。请准备接受登舰。"
	objectives = "洗劫 [MAIN_SHIP_NAME]，杀死所有挡路的人。听从首领的命令，不惜一切代价确保自己活下来。"

/datum/emergency_call/mercs/print_backstory(mob/living/carbon/human/H)
	to_chat(H, SPAN_BOLD("你最初是一名殖民者，来到尼洛德星区，想在已建成的殖民地找份工作。"))
	to_chat(H, SPAN_BOLD("2180年代初，美洲联盟军队撤离后，这个星系陷入混乱。"))
	to_chat(H, SPAN_BOLD("自由佣兵拿起武器，成为维护星系秩序的一支强大力量。"))
	to_chat(H, SPAN_BOLD("虽然主要受金钱驱使，许多殖民者仍将自由佣兵视为尼洛德星区维持秩序的主要力量。"))
	if(hostility)
		to_chat(H, SPAN_NOTICE(SPAN_BOLD("尽管如此，你接到的任务却是洗劫 [MAIN_SHIP_NAME]，杀死所有挡路的人。")))
		to_chat(H, SPAN_NOTICE(SPAN_BOLD("其他响应求救的进步人民联盟、殖民地解放阵线或维兰德-汤谷部队，在表明敌意前均应视为中立方。")))
	else
		to_chat(H, SPAN_NOTICE(SPAN_BOLD("为此，USCSS罗伊斯号上的维兰德-汤谷人员联系了你，请你协助 [MAIN_SHIP_NAME]。")))
		to_chat(H, SPAN_NOTICE(SPAN_BOLD("确保他们不会被消灭。</b>")))

/datum/emergency_call/mercs/create_member(datum/mind/M, turf/override_spawn_loc)
	var/turf/spawn_loc = override_spawn_loc ? override_spawn_loc : get_spawn_point()

	if(!istype(spawn_loc))
		return //Didn't find a useable spawn point.

	var/mob/living/carbon/human/H = new(spawn_loc)
	H.name = H.real_name
	M.transfer_to(H, TRUE)
	H.job = "Mercenary"

	if(!leader && HAS_FLAG(H.client.prefs.toggles_ert, PLAY_LEADER) && check_timelock(H.client, JOB_SQUAD_LEADER, time_required_for_job))
		leader = H
		arm_equipment(H, /datum/equipment_preset/other/freelancer/leader, TRUE, TRUE)
		to_chat(H, SPAN_ROLE_HEADER("你是自由佣兵的领袖！"))
	else if(medics < max_medics && HAS_FLAG(H.client.prefs.toggles_ert, PLAY_MEDIC) && check_timelock(H.client, JOB_SQUAD_MEDIC, time_required_for_job))
		medics++
		arm_equipment(H, /datum/equipment_preset/other/freelancer/medic, TRUE, TRUE)
		to_chat(H, SPAN_ROLE_HEADER("你是自由佣兵的医疗兵！"))
	else
		arm_equipment(H, /datum/equipment_preset/other/freelancer/standard, TRUE, TRUE)
		to_chat(H, SPAN_ROLE_HEADER("你是一名自由佣兵！"))
	print_backstory(H)

	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(to_chat), H, SPAN_BOLD("目标：[objectives]")), 1 SECONDS)

/datum/emergency_call/mercs/platoon
	name = "Freelancers (Platoon)"
	localized_name = "自由佣兵（排）"
	mob_min = 8
	mob_max = 30
	probability = 0
	max_medics = 3

/datum/emergency_call/heavy_mercs
	name = "Elite Mercenaries (Random Alignment)"
	localized_name = "精锐佣兵（随机立场）"
	mob_min = 4
	mob_max = 8
	probability = 0
	max_medics = 1
	max_engineers = 1
	max_heavies = 1

/datum/emergency_call/heavy_mercs/New()
	. = ..()
	hostility = pick(75;FALSE,25;TRUE)
	arrival_message = "[MAIN_SHIP_NAME]，这里是响应求救的精锐自由佣兵穿梭机 [pick(GLOB.alphabet_lowercase)][pick(GLOB.alphabet_lowercase)]-[rand(1, 99)]。请准备接受登舰。"
	if(hostility)
		objectives = "洗劫 [MAIN_SHIP_NAME]，杀死所有挡路的人。听从队长的命令，不惜一切代价确保自己活下来。"
	else
		objectives = "帮助 [MAIN_SHIP_NAME] 的船员以换取报酬，并谨慎选择报酬。听从队长的命令，不惜一切代价确保自己活下来。"

/datum/emergency_call/heavy_mercs/hostile
	name = "Elite Mercenaries (HOSTILE to USCM)"
	localized_name = "精锐佣兵（与殖民地陆战队敌对）"

/datum/emergency_call/heavy_mercs/hostile/New()
	. = ..()
	hostility = TRUE
	arrival_message = "[MAIN_SHIP_NAME]，这里是响应求救的精锐自由佣兵穿梭机 [pick(GLOB.alphabet_lowercase)][pick(GLOB.alphabet_lowercase)]-[rand(1, 99)]。请准备接受登舰。"
	objectives = "洗劫 [MAIN_SHIP_NAME]，杀死所有挡路的人。听从队长的命令，不惜一切代价确保自己活下来。"

/datum/emergency_call/heavy_mercs/friendly
	name = "Elite Mercenaries (Friendly)"
	localized_name = "精锐佣兵（友军）"

/datum/emergency_call/heavy_mercs/friendly/New()
	. = ..()
	hostility = FALSE
	arrival_message = "[MAIN_SHIP_NAME]，这里是响应求救的精锐自由佣兵穿梭机 [pick(GLOB.alphabet_lowercase)][pick(GLOB.alphabet_lowercase)]-[rand(1, 99)]。请准备接受登舰。"
	objectives = "帮助 [MAIN_SHIP_NAME] 的船员以换取报酬，并谨慎选择报酬。听从队长的命令，不惜一切代价确保自己活下来。"

/datum/emergency_call/heavy_mercs/print_backstory(mob/living/carbon/human/H)
	to_chat(H, SPAN_BOLD("你最初是一名经验丰富的矿工，来到尼洛德星区，想在已建成的殖民地找份工作。"))
	to_chat(H, SPAN_BOLD("2180年代初，美洲联盟军队撤离后，这个星系陷入混乱。"))
	to_chat(H, SPAN_BOLD("自由佣兵拿起武器，成为维护星系秩序的一支强大力量。"))
	to_chat(H, SPAN_BOLD("虽然主要受金钱驱使，许多殖民者仍将自由佣兵视为尼洛德星区维持秩序的主要力量。"))
	if(hostility)
		to_chat(H, SPAN_NOTICE(SPAN_BOLD("尽管如此，你却被专门指派去洗劫 [MAIN_SHIP_NAME]，杀死所有挡路的人。")))
		to_chat(H, SPAN_NOTICE(SPAN_BOLD("其他响应求救的进步人民联盟、殖民地解放阵线或维兰德-汤谷部队，在表明敌意前均应视为中立方。")))
	else
		to_chat(H, SPAN_NOTICE(SPAN_BOLD("为此，USCSS罗伊斯号上的维兰德-汤谷人员联系了你，请你协助 [MAIN_SHIP_NAME]。")))
		to_chat(H, SPAN_NOTICE(SPAN_BOLD("确保他们不会被消灭。</b>")))

/datum/emergency_call/heavy_mercs/create_member(datum/mind/M, turf/override_spawn_loc)
	var/turf/spawn_loc = override_spawn_loc ? override_spawn_loc : get_spawn_point()

	if(!istype(spawn_loc))
		return //Didn't find a useable spawn point.

	var/mob/living/carbon/human/H = new(spawn_loc)
	H.name = H.real_name
	M.transfer_to(H, TRUE)
	H.job = "Mercenary"

	if(!leader && HAS_FLAG(H.client.prefs.toggles_ert, PLAY_LEADER) && check_timelock(H.client, JOB_SQUAD_LEADER, time_required_for_job))    //First one spawned is always the leader.
		leader = H
		arm_equipment(H, /datum/equipment_preset/other/elite_merc/leader, TRUE, TRUE)
		to_chat(H, SPAN_ROLE_HEADER("你是精锐佣兵的领袖！"))
	else if(medics < max_medics && HAS_FLAG(H.client.prefs.toggles_ert, PLAY_MEDIC) && check_timelock(H.client, JOB_SQUAD_MEDIC, time_required_for_job))
		medics++
		arm_equipment(H, /datum/equipment_preset/other/elite_merc/medic, TRUE, TRUE)
		to_chat(H, SPAN_ROLE_HEADER("你是精锐佣兵的医疗兵！"))
	else if(engineers < max_engineers && HAS_FLAG(H.client.prefs.toggles_ert, PLAY_ENGINEER) && check_timelock(H.client, JOB_SQUAD_ENGI, time_required_for_job))
		engineers++
		arm_equipment(H, /datum/equipment_preset/other/elite_merc/engineer, TRUE, TRUE)
		to_chat(H, SPAN_ROLE_HEADER("你是精锐佣兵的工程兵！"))
	else if(heavies < max_heavies && HAS_FLAG(H.client.prefs.toggles_ert, PLAY_SMARTGUNNER) && check_timelock(H.client, JOB_SQUAD_SMARTGUN, time_required_for_job))
		heavies++
		arm_equipment(H, /datum/equipment_preset/other/elite_merc/heavy, TRUE, TRUE)
		to_chat(H, SPAN_ROLE_HEADER("你是精锐佣兵的武器专家！"))
	else
		arm_equipment(H, /datum/equipment_preset/other/elite_merc/standard, TRUE, TRUE)
		to_chat(H, SPAN_ROLE_HEADER("你是一名精锐佣兵！"))
	print_backstory(H)

	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(to_chat), H, SPAN_BOLD("目标：[objectives]")), 1 SECONDS)
