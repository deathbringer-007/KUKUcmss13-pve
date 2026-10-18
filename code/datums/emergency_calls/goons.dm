/datum/emergency_call/goon
	name = "Weyland-Yutani Corporate Security (Squad)"
	mob_max = 6
	probability = 0
	home_base = /datum/lazy_template/ert/weyland_station

/datum/emergency_call/goon/New()
	..()
	arrival_message = "[MAIN_SHIP_NAME]，这里是维兰德-汤谷企业安保穿梭机，正飞往你们的求救信标。我们前来提供帮助。"
	objectives = "保护企业联络员和 [MAIN_SHIP_NAME] 的舰长，消灭所有敌对威胁。不得损坏维兰德-汤谷的财产。"

/datum/emergency_call/goon/create_member(datum/mind/M, turf/override_spawn_loc)
	var/turf/spawn_loc = override_spawn_loc ? override_spawn_loc : get_spawn_point()

	if(!istype(spawn_loc))
		return //Didn't find a useable spawn point.

	var/mob/living/carbon/human/mob = new(spawn_loc)
	M.transfer_to(mob, TRUE)

	if(!leader && HAS_FLAG(mob.client.prefs.toggles_ert, PLAY_LEADER) && check_timelock(mob.client, JOB_SQUAD_LEADER, time_required_for_job))
		leader = mob
		to_chat(mob, SPAN_ROLE_HEADER("你是维兰德-汤谷企业安保队长！"))
		arm_equipment(mob, /datum/equipment_preset/colonist/security/weyland/tactical/lead, TRUE, TRUE)
	else
		to_chat(mob, SPAN_ROLE_HEADER("你是维兰德-汤谷企业安保员！"))
		arm_equipment(mob, /datum/equipment_preset/colonist/security/weyland/tactical, TRUE, TRUE)

	print_backstory(mob)

	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(to_chat), mob, SPAN_BOLD("目标：</b>[objectives]")), 1 SECONDS)

/datum/emergency_call/goon/print_backstory(mob/living/carbon/human/M)
	to_chat(M, SPAN_BOLD("你出生于[pick(75;"欧洲", 15;"亚洲", 10;"火星")]的一个贫困家庭。"))
	to_chat(M, SPAN_BOLD("为了让自己和亲人吃饱，加入维兰德-汤谷是你唯一能做的选择。"))
	to_chat(M, SPAN_BOLD("你根本不知道异形是什么。"))
	to_chat(M, SPAN_BOLD("你是维兰德-汤谷雇用的普通安保员，负责守卫公司的前哨站和殖民地。"))
	to_chat(M, SPAN_BOLD("你早就听说了最初的求救信号，但直到现在才获得公司进入该区域的许可。"))
	to_chat(M, SPAN_BOLD("确保维兰德-汤谷的利益不受损害，并保护好企业联络员。"))

/datum/emergency_call/goon/chem_retrieval
	name = "Weyland-Yutani Goon (Chemical Investigation Squad)"
	mob_max = 6
	mob_min = 2
	max_medics = 1
	var/checked_objective = FALSE

/datum/emergency_call/goon/chem_retrieval/New()
	..()
	dispatch_message = "[MAIN_SHIP_NAME]，这里是USCSS罗伊斯号。我们的小队将登舰，收取近期从你们科研部门扫描到的某种化学品的全部样本。对于这项发现，你们部门应已收到一笔可观的款项。作为回报，请配合回收小队，提供与该化学品有关的一切资料和物品。"
	objectives = "从 [MAIN_SHIP_NAME] 研究部门获取所有含有DNA瓦解特性的文件、样本和化学品，并带回应急响应队基地。"

/datum/emergency_call/goon/chem_retrieval/proc/check_objective_info()
	if(objective_info)
		objectives = "从 [MAIN_SHIP_NAME] 研究部门获取所有与 [objective_info] 有关的文件、样本和化学品，并带回应急响应队基地。"
	objectives += "预计科研部门至少存有30单位该化学品。如果他们无法继续生产，那应是全部存量。与舰上的公司联络员合作，让所有掌握完整配方的人签署保密合同，不得泄密。所有摄入过该化学品的人类都必须带回，无论死活。对疑似摄入者必须进行病毒扫描。未经私人军事承包商调度处明确许可，不得前往殖民地。若局势失控，教授可呼叫私人军事承包商增援。"
	checked_objective = TRUE

/datum/emergency_call/goon/chem_retrieval/create_member(datum/mind/M, turf/override_spawn_loc)
	var/turf/spawn_loc = override_spawn_loc ? override_spawn_loc : get_spawn_point()

	if(!istype(spawn_loc))
		return //Didn't find a useable spawn point.

	var/mob/living/carbon/human/mob = new(spawn_loc)
	M.transfer_to(mob, TRUE)

	if(!leader && HAS_FLAG(mob.client.prefs.toggles_ert, PLAY_LEADER) && check_timelock(mob.client, JOB_SQUAD_LEADER, time_required_for_job))
		leader = mob
		to_chat(mob, SPAN_ROLE_HEADER("你是维兰德-汤谷企业安保队长！"))
		arm_equipment(mob, /datum/equipment_preset/colonist/security/weyland/tactical/lead, TRUE, TRUE)
	else if(medics < max_medics && HAS_FLAG(mob.client.prefs.toggles_ert, PLAY_MEDIC) && check_timelock(mob.client, JOB_SQUAD_MEDIC, time_required_for_job))
		medics++
		to_chat(mob, SPAN_ROLE_HEADER("你是维兰德-汤谷企业研究顾问！"))
		arm_equipment(mob, /datum/equipment_preset/goon/researcher, TRUE, TRUE)
	else
		to_chat(mob, SPAN_ROLE_HEADER("你是维兰德-汤谷企业安保员！"))
		arm_equipment(mob, /datum/equipment_preset/colonist/security/weyland/tactical, TRUE, TRUE)

	print_backstory(mob)

	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(to_chat), mob, SPAN_BOLD("目标：</b>[objectives]")), 1 SECONDS)

/datum/emergency_call/goon/chem_retrieval/print_backstory(mob/living/carbon/human/backstory_human)
	if(backstory_human.job == JOB_WY_GOON_RESEARCHER)
		to_chat(backstory_human, SPAN_BOLD("你出生于[pick(75;"欧洲", 15;"亚洲", 10;"火星")]的一个富裕家庭。"))
		to_chat(backstory_human, SPAN_BOLD("加入维兰德-汤谷，是推进你研究目标的绝佳方式。"))
		to_chat(backstory_human, SPAN_BOLD("你对异形有非常深入的了解。"))
		to_chat(backstory_human, SPAN_BOLD("你是维兰德-汤谷雇用、接受过良好教育的科学家，负责研究各类非人类生物。"))
		to_chat(backstory_human, SPAN_BOLD("你早就听说了最初的求救信号，但直到现在才获得公司进入该区域的许可。"))
		to_chat(backstory_human, SPAN_BOLD("你唯一的目标是取回阿尔迈耶号上的化学品。为此可以不择手段。"))
	else
		to_chat(backstory_human, SPAN_BOLD("你出生于[pick(75;"欧洲", 15;"亚洲", 10;"火星")]的一个贫困家庭。"))
		to_chat(backstory_human, SPAN_BOLD("为了让自己和亲人吃饱，加入维兰德-汤谷是你唯一能做的选择。"))
		to_chat(backstory_human, SPAN_BOLD("你接受过关于异形的基础简报。"))
		to_chat(backstory_human, SPAN_BOLD("你是维兰德-汤谷雇用的普通安保员，负责守卫公司的前哨站和殖民地。"))
		to_chat(backstory_human, SPAN_BOLD("你早就听说了最初的求救信号，但直到现在才获得公司进入该区域的许可。"))
		to_chat(backstory_human, SPAN_BOLD("确保维兰德-汤谷的利益不受损害。保护好研究员，并服从其指示。"))

/datum/emergency_call/goon/bodyguard
	name = "Weyland-Yutani Goon (Executive Bodyguard Detail)"
	mob_max = 1
	mob_min = 1

/datum/emergency_call/goon/bodyguard/New()
	..()
	dispatch_message = "[MAIN_SHIP_NAME]，这里是维兰德-汤谷公司安保警卫分队运输机，正驶向联络员信标。"
	objectives = "保护企业联络员并服从其命令，除非命令违反公司政策。不得损坏维兰德-汤谷的财产。"

/datum/emergency_call/goon/bodyguard/create_member(datum/mind/M, turf/override_spawn_loc)
	var/turf/spawn_loc = override_spawn_loc ? override_spawn_loc : get_spawn_point()

	if(!istype(spawn_loc))
		return //Didn't find a useable spawn point.

	var/mob/living/carbon/human/mob = new(spawn_loc)
	M.transfer_to(mob, TRUE)

	if(!leader && HAS_FLAG(mob.client.prefs.toggles_ert, PLAY_LEADER) && check_timelock(mob.client, JOB_SQUAD_LEADER, time_required_for_job))
		leader = mob
		to_chat(mob, SPAN_ROLE_HEADER("你是维兰德-汤谷企业安保队长！"))
		arm_equipment(mob, /datum/equipment_preset/colonist/security/weyland/tactical/lead, TRUE, TRUE)
	else
		to_chat(mob, SPAN_ROLE_HEADER("你是维兰德-汤谷企业安保员！"))
		arm_equipment(mob, /datum/equipment_preset/colonist/security/weyland/tactical, TRUE, TRUE)

	print_backstory(mob)

	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(to_chat), mob, SPAN_BOLD("目标：</b>[objectives]")), 1 SECONDS)

/datum/emergency_call/goon/bodyguard/print_backstory(mob/living/carbon/human/M)
	to_chat(M, SPAN_BOLD("你出生于[pick(75;"欧洲", 15;"亚洲", 10;"火星")]的一个贫困家庭。"))
	to_chat(M, SPAN_BOLD("为了让自己和亲人吃饱，加入维兰德-汤谷是你唯一能做的选择。"))
	to_chat(M, SPAN_BOLD("你根本不知道异形是什么。"))
	to_chat(M, SPAN_BOLD("你是维兰德-汤谷雇用的普通安保员，负责保护各部门的高管。"))
	to_chat(M, SPAN_BOLD("你被派往 [MAIN_SHIP_NAME]，担任高管的贴身保镖，已获得公司进入该区域的许可。"))
	to_chat(M, SPAN_BOLD("确保维兰德-汤谷的利益不受损害，并保护好企业联络员。"))

/datum/emergency_call/goon/platoon
	name = "Weyland-Yutani Corporate Security (Platoon)"
	mob_min = 8
	mob_max = 25
	probability = 0
