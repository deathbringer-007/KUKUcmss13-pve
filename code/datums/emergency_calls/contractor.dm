/datum/emergency_call/contractors
	name = "Military Contractors (Squad) (Friendly)"
	mob_max = 7
	probability = 20

	max_engineers =  1
	max_medics = 1
	max_heavies = 1
	var/max_synths = 1
	var/synths = 0


/datum/emergency_call/contractors/New()
	..()
	arrival_message = "[MAIN_SHIP_NAME]，这里是先锋之箭公司主要行动部的USCSS继承者号。我们正在响应你们的求救，并依据《2177年军事援助法案》登舰。认证代码：Lima-18153。"
	objectives = "确保 [MAIN_SHIP_NAME] 幸存，消灭所有敌对目标，并尽一切可能协助船员。"


/datum/emergency_call/contractors/create_member(datum/mind/M, turf/override_spawn_loc)
	var/turf/spawn_loc = override_spawn_loc ? override_spawn_loc : get_spawn_point()

	if(!istype(spawn_loc))
		return //Didn't find a useable spawn point.

	var/mob/living/carbon/human/mob = new(spawn_loc)
	M.transfer_to(mob, TRUE)

	if(!leader && HAS_FLAG(mob.client.prefs.toggles_ert, PLAY_LEADER) && check_timelock(mob.client, JOB_SQUAD_LEADER, time_required_for_job))
		leader = mob
		to_chat(mob, SPAN_ROLE_HEADER("你是先锋之箭公司承包商小队的队长！"))
		arm_equipment(mob, /datum/equipment_preset/contractor/duty/leader, TRUE, TRUE)
	else if(synths < max_synths && HAS_FLAG(mob.client.prefs.toggles_ert, PLAY_SYNTH) && mob.client.check_whitelist_status(WHITELIST_SYNTHETIC))
		synths++
		to_chat(mob, SPAN_ROLE_HEADER("你是先锋之箭公司承包商小队的支援合成人！"))
		arm_equipment(mob, /datum/equipment_preset/contractor/duty/synth, TRUE, TRUE)
	else if(medics < max_medics && HAS_FLAG(mob.client.prefs.toggles_ert, PLAY_MEDIC) && check_timelock(mob.client, JOB_SQUAD_MEDIC, time_required_for_job))
		medics++
		to_chat(mob, SPAN_ROLE_HEADER("你是先锋之箭公司承包商小队的医疗专家！"))
		arm_equipment(mob, /datum/equipment_preset/contractor/duty/medic, TRUE, TRUE)
	else if(heavies < max_heavies && HAS_FLAG(mob.client.prefs.toggles_ert, PLAY_HEAVY) && check_timelock(mob.client, JOB_SQUAD_SPECIALIST))
		heavies++
		to_chat(mob, SPAN_ROLE_HEADER("你是先锋之箭公司承包商小队的机枪手！"))
		arm_equipment(mob, /datum/equipment_preset/contractor/duty/heavy, TRUE, TRUE)
	else if(engineers < max_engineers && HAS_FLAG(mob.client.prefs.toggles_ert, PLAY_ENGINEER) && check_timelock(mob.client, JOB_SQUAD_ENGI))
		engineers++
		to_chat(mob, SPAN_ROLE_HEADER("你是先锋之箭公司承包商小队的工程专家！"))
		arm_equipment(mob, /datum/equipment_preset/contractor/duty/engi, TRUE, TRUE)
	else
		to_chat(mob, SPAN_ROLE_HEADER("你是先锋之箭公司的承包商雇员！"))
		arm_equipment(mob, /datum/equipment_preset/contractor/duty/standard, TRUE, TRUE)

	print_backstory(mob)

	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(to_chat), mob, SPAN_BOLD("目标：</b>[objectives]")), 1 SECONDS)


/datum/emergency_call/contractors/print_backstory(mob/living/carbon/human/M)
	if(ishuman_strict(M))
		to_chat(M, SPAN_BOLD("你出生于[pick(60;"美国", 20;"地球", 20;"某个殖民地")]的一个[pick(75;"普通", 15;"贫困", 10;"家境殷实")]家庭。"))
		to_chat(M, SPAN_BOLD("加入美国殖民地海军陆战队让你获得了丰富的战斗经验和实用技能，也改变了你。"))
		to_chat(M, SPAN_BOLD("退役后，那些亲眼所见与亲手所做的事让你无法保住工作。为了发挥自己的技能，你加入了一家军事承包公司。"))
		to_chat(M, SPAN_BOLD("你是一名熟练的佣兵，收入比在陆战队服役时更高。"))
	else
		to_chat(M, SPAN_BOLD("你在一座民用工厂启动。"))
		to_chat(M, SPAN_BOLD("你被赋予了军队支援单位所需的全部医疗与工程知识。"))
		to_chat(M, SPAN_BOLD("不久后，先锋之箭公司（VAI）买下了你，让你担任支援人员。"))
		to_chat(M, SPAN_BOLD("购入数月后，你被派往VAI运输舰USCSS继承者号。"))
	to_chat(M, SPAN_BOLD("你对异形威胁的了解程度是：[pick(80;"毫不知情", 15;"略有耳闻", 5;"十分了解")]。"))
	to_chat(M, SPAN_BOLD("你受雇于先锋之箭公司（VAI），是先锋之箭主要行动部（VAIPO）的一员。"))
	to_chat(M, SPAN_BOLD("你驻扎在USCSS继承者号上，隶属于VAIPO查理特遣队。"))
	to_chat(M, SPAN_BOLD("根据VAI执行董事会的指示，你参与防暴、军事援助，并尽可能支援美国殖民地海军陆战队部队。"))
	to_chat(M, SPAN_BOLD("USCSS继承者号上约有三百名军事承包商人员和五十名支援人员。"))
	to_chat(M, SPAN_BOLD("尽你所能，协助 [MAIN_SHIP_NAME] 的美国殖民地海军陆战队部队。"))
	to_chat(M, SPAN_BOLD("另有一项附带目标：一位不明资助者雇用VAI对维兰德-汤谷开展商业间谍活动与破坏。避免正面冲突，你们毕竟不是VAISO；但若有机会，应设法获取维兰德-汤谷的机密与计划。"))


/datum/emergency_call/contractors/platoon
	name = "Military Contractors (Platoon) (Friendly)"
	mob_min = 7
	mob_max = 28
	probability = 0
	max_medics = 3
	max_heavies = 3
	max_engineers = 2
	max_synths = 2

/datum/emergency_call/contractors/covert
	name = "Military Contractors (Covert) (Hostile to WY)"
	mob_max = 7
	probability = 20
	max_medics = 1
	max_engineers = 1
	max_heavies = 1
	max_synths = 1
	var/checked_objective = FALSE

/datum/emergency_call/contractors/covert/New()
	..()
	arrival_message = "[MAIN_SHIP_NAME]，这里是先锋之箭公司特别行动部的USCSS桑布兰号。我们将依据《2177年军事援助法案》登舰。授权代码：X-Ray 19601。"
	objectives = "尽一切可能协助美国殖民地海军陆战队，破坏维兰德-汤谷的行动。"

/datum/emergency_call/contractors/covert/proc/check_objective_info()
	if(objective_info)
		objectives = "尽一切可能协助美国殖民地海军陆战队。"
	objectives += "破坏维兰德-汤谷的行动。"
	checked_objective = TRUE

/datum/emergency_call/contractors/covert/create_member(datum/mind/M, turf/override_spawn_loc)
	var/turf/spawn_loc = override_spawn_loc ? override_spawn_loc : get_spawn_point()

	if(!istype(spawn_loc))
		return //Didn't find a useable spawn point.

	if(!checked_objective)
		check_objective_info()

	var/mob/living/carbon/human/H = new(spawn_loc)
	H.key = M.key
	if(H.client)
		H.client.change_view(GLOB.world_view_size)

	if(!leader && HAS_FLAG(H.client.prefs.toggles_ert, PLAY_LEADER) && check_timelock(H.client, JOB_SQUAD_LEADER, time_required_for_job))    //First one spawned is always the leader.
		leader = H
		to_chat(H, SPAN_ROLE_HEADER("你是先锋之箭公司秘密承包商小队的队长！"))
		arm_equipment(H, /datum/equipment_preset/contractor/covert/leader, TRUE, TRUE)
	else if(synths < max_synths && HAS_FLAG(H.client.prefs.toggles_ert, PLAY_SYNTH) && H.client.check_whitelist_status(WHITELIST_SYNTHETIC))
		synths++
		to_chat(H, SPAN_ROLE_HEADER("你是先锋之箭公司承包商小队的支援合成人！"))
		arm_equipment(H, /datum/equipment_preset/contractor/covert/synth, TRUE, TRUE)
	else if(medics < max_medics && HAS_FLAG(H.client.prefs.toggles_ert, PLAY_MEDIC) && check_timelock(H.client, JOB_SQUAD_MEDIC, time_required_for_job))
		medics++
		to_chat(H, SPAN_ROLE_HEADER("你是先锋之箭公司秘密承包商小队的医疗专家！"))
		arm_equipment(H, /datum/equipment_preset/contractor/covert/medic, TRUE, TRUE)
	else if(heavies < max_heavies && HAS_FLAG(H.client.prefs.toggles_ert, PLAY_SMARTGUNNER) && check_timelock(H.client, JOB_SQUAD_SMARTGUN, time_required_for_job))
		heavies++
		to_chat(H, SPAN_ROLE_HEADER("你是先锋之箭公司秘密承包商小队的机枪手！"))
		arm_equipment(H, /datum/equipment_preset/contractor/covert/heavy, TRUE, TRUE)
	else if(engineers < max_engineers && HAS_FLAG(H.client.prefs.toggles_ert, PLAY_ENGINEER) && check_timelock(H.client, JOB_SQUAD_ENGI))
		engineers++
		to_chat(H, SPAN_ROLE_HEADER("你是先锋之箭公司秘密承包商小队的工程专家！"))
		arm_equipment(H, /datum/equipment_preset/contractor/covert/engi, TRUE, TRUE)
	else
		to_chat(H, SPAN_ROLE_HEADER("你是先锋之箭公司的秘密承包商雇员！"))
		arm_equipment(H, /datum/equipment_preset/contractor/covert/standard, TRUE, TRUE)

	print_backstory(H)

	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(to_chat), H, SPAN_BOLD("目标：</b>[objectives]")), 1 SECONDS)

