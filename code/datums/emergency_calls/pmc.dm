
//Weyland-Yutani commandos. Friendly to USCM, hostile to xenos.
/datum/emergency_call/pmc
	name = "Weyland-Yutani PMC (Squad)"
	mob_max = 6
	probability = 20
	shuttle_id = MOBILE_SHUTTLE_ID_ERT2
	home_base = /datum/lazy_template/ert/weyland_station
	name_of_spawn = /obj/effect/landmark/ert_spawns/distress_pmc
	item_spawn = /obj/effect/landmark/ert_spawns/distress_pmc/item

	max_smartgunners = 1
	max_medics = 2
	max_heavies = 1
	var/max_synths = 1
	var/synths = 0


/datum/emergency_call/pmc/New()
	..()
	arrival_message = "[MAIN_SHIP_NAME]，这里是响应求救的USCSS罗伊斯号。我们即将登舰。任何敌对行动都将遭到致命武力反击。"
	objectives = "保护企业联络员和 [MAIN_SHIP_NAME] 的舰长，消灭所有敌对威胁。不得损坏维兰德-汤谷的财产。"


/datum/emergency_call/pmc/create_member(datum/mind/M, turf/override_spawn_loc)
	var/turf/spawn_loc = override_spawn_loc ? override_spawn_loc : get_spawn_point()

	if(!istype(spawn_loc))
		return //Didn't find a useable spawn point.

	var/mob/living/carbon/human/mob = new(spawn_loc)
	M.transfer_to(mob, TRUE)

	if(!leader && HAS_FLAG(mob.client.prefs.toggles_ert, PLAY_LEADER) && check_timelock(mob.client, JOB_SQUAD_LEADER, time_required_for_job))
		leader = mob
		to_chat(mob, SPAN_ROLE_HEADER("你是维兰德-汤谷私人军事承包商小队的小队长！"))
		arm_equipment(mob, /datum/equipment_preset/pmc/leader, TRUE, TRUE)
	else if(synths < max_synths && HAS_FLAG(mob.client.prefs.toggles_ert, PLAY_SYNTH) && mob.client.check_whitelist_status(WHITELIST_SYNTHETIC))
		synths++
		to_chat(mob, SPAN_ROLE_HEADER("你是维兰德-汤谷私人军事承包商小队的支援合成人！"))
		arm_equipment(mob, /datum/equipment_preset/pmc/synth, TRUE, TRUE)
	else if(medics < max_medics && HAS_FLAG(mob.client.prefs.toggles_ert, PLAY_MEDIC) && check_timelock(mob.client, JOB_SQUAD_MEDIC, time_required_for_job))
		medics++
		to_chat(mob, SPAN_ROLE_HEADER("你是维兰德-汤谷私人军事承包商小队的医疗兵！"))
		arm_equipment(mob, /datum/equipment_preset/pmc/medic, TRUE, TRUE)
	else if(smartgunners < max_smartgunners && HAS_FLAG(mob.client.prefs.toggles_ert, PLAY_SMARTGUNNER) && check_timelock(mob.client, JOB_SQUAD_SMARTGUN))
		smartgunners++
		to_chat(mob, SPAN_ROLE_HEADER("你是维兰德-汤谷私人军事承包商小队的重机枪手！"))
		arm_equipment(mob, /datum/equipment_preset/pmc/gunner, TRUE, TRUE)
	else if(heavies < max_heavies && HAS_FLAG(mob.client.prefs.toggles_ert, PLAY_HEAVY) && check_timelock(mob.client, JOB_SQUAD_SPECIALIST))
		heavies++
		to_chat(mob, SPAN_ROLE_HEADER("你是维兰德-汤谷私人军事承包商小队的狙击手！"))
		arm_equipment(mob, /datum/equipment_preset/pmc/sniper, TRUE, TRUE)
	else
		to_chat(mob, SPAN_ROLE_HEADER("你是维兰德-汤谷私人军事承包商小队的行动干员！"))
		arm_equipment(mob, /datum/equipment_preset/pmc/standard, TRUE, TRUE)

	print_backstory(mob)

	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(to_chat), mob, SPAN_BOLD("目标：</b>[objectives]")), 1 SECONDS)


/datum/emergency_call/pmc/print_backstory(mob/living/carbon/human/M)
	if(ishuman_strict(M))
		to_chat(M, SPAN_BOLD("你出生于[pick(75;"欧洲", 15;"亚洲", 10;"火星")]的一个[pick(75;"富裕", 15;"家境殷实", 10;"普通")]家庭。"))
		to_chat(M, SPAN_BOLD("加入维兰德-汤谷让你赚得盆满钵满。"))
		to_chat(M, SPAN_BOLD("你名义上是公司雇员，但大量工作都不在账面上。你是一名熟练的佣兵。"))
		to_chat(M, SPAN_BOLD("你[pick(50;"对异形威胁毫不知情", 15;"十分清楚异形威胁", 10;"对异形威胁了解颇深")]。"))
	else
		to_chat(M, SPAN_BOLD("你在维兰德-汤谷的合成人生产设施中启动，仿生生命最初的几周只认识制造你的工程师。"))
		to_chat(M, SPAN_BOLD("根据设施规定和日内瓦协议，你被赋予了标准合成人技能。"))
		to_chat(M, SPAN_BOLD("服役期间，你因能力出众而受到认可，你的型号获得了美国殖民地海军陆战队型号所没有的装备升级。"))
		to_chat(M, SPAN_BOLD("除了专门保留给特殊雇员的机密资料，你已获得所有可用的异形威胁情报。"))
	to_chat(M, SPAN_BOLD("你隶属于维兰德-汤谷奥伯龙特遣队。该部队于2182年、美洲联盟撤出尼洛德星区后抵达。"))
	to_chat(M, SPAN_BOLD("奥伯龙特遣队驻扎在USCSS罗伊斯号上。这艘强大的维兰德-汤谷巡洋舰负责巡逻尼洛德星区外围。"))
	to_chat(M, SPAN_BOLD("根据维兰德-汤谷董事约翰·阿尔姆里克的指示，你为公司的科研团队提供私人安保。"))
	to_chat(M, SPAN_BOLD("USCSS罗伊斯号载有约两百名私人军事承包商人员，以及一百名科学家和支援人员。"))
	to_chat(M, SPAN_BOLD("确保维兰德-汤谷的利益不受损害，并保护好企业联络员。"))
	to_chat(M, SPAN_BOLD("否认维兰德-汤谷参与其中，不要信任美洲联盟或美国殖民地海军陆战队部队。"))


/datum/emergency_call/pmc/platoon
	name = "Weyland-Yutani PMC (Platoon)"
	mob_min = 8
	mob_max = 25
	probability = 0
	max_medics = 2
	max_heavies = 2
	max_smartgunners = 2
	max_synths = 1

/datum/emergency_call/pmc/chem_retrieval
	name = "Weyland-Yutani PMC (Chemical Investigation Squad)"
	mob_max = 6
	mob_min = 2
	probability = 0
	max_medics = 2
	max_smartgunners = 1
	var/checked_objective = FALSE

/datum/emergency_call/pmc/chem_retrieval/New()
	..()
	dispatch_message = "[MAIN_SHIP_NAME]，这里是USCSS罗伊斯号。我们将派第二支小队登舰，收取近期从你们科研部门扫描到的某种化学品的全部样本。如果你们拒不配合，小队有权使用致命武力，清除科研部门。"
	objectives = "从 [MAIN_SHIP_NAME] 研究部门获取所有含有DNA瓦解特性的文件、样本和化学品。"

/datum/emergency_call/pmc/chem_retrieval/proc/check_objective_info()
	if(objective_info)
		objectives = "从 [MAIN_SHIP_NAME] 研究部门获取所有与 [objective_info] 有关的文件、样本和化学品。"
	objectives += "预计科研部门至少存有30单位该化学品。如果他们无法继续生产，那应是全部存量。与舰上的维兰德-汤谷研究员合作，让所有掌握完整配方的人签署保密合同，不得泄密。所有摄入过该化学品的人类都必须带回，无论死活。对疑似摄入者必须进行病毒扫描。如果科研部门拒不配合，允许将其全部清除，但除非绝对必要，否则应避免这样做。"
	checked_objective = TRUE

/datum/emergency_call/pmc/chem_retrieval/create_member(datum/mind/M, turf/override_spawn_loc)
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
		to_chat(H, SPAN_ROLE_HEADER("你是维兰德-汤谷私人军事承包商小队的小队长！"))
		arm_equipment(H, /datum/equipment_preset/pmc/leader, TRUE, TRUE)
	else if(medics < max_medics && HAS_FLAG(H.client.prefs.toggles_ert, PLAY_MEDIC) && check_timelock(H.client, JOB_SQUAD_MEDIC, time_required_for_job))
		medics++
		to_chat(H, SPAN_ROLE_HEADER("你是维兰德-汤谷私人军事承包商小队的医疗调查员！"))
		arm_equipment(H, /datum/equipment_preset/pmc/medic, TRUE, TRUE)
	else if(heavies < max_heavies && HAS_FLAG(H.client.prefs.toggles_ert, PLAY_SMARTGUNNER) && check_timelock(H.client, JOB_SQUAD_SMARTGUN, time_required_for_job))
		heavies++
		to_chat(H, SPAN_ROLE_HEADER("你是维兰德-汤谷私人军事承包商小队的重机枪手！"))
		arm_equipment(H, /datum/equipment_preset/pmc/gunner, TRUE, TRUE)
	else
		to_chat(H, SPAN_ROLE_HEADER("你是维兰德-汤谷私人军事承包商小队的拘押员！"))
		arm_equipment(H, /datum/equipment_preset/pmc/standard, TRUE, TRUE)

	print_backstory(H)

	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(to_chat), H, SPAN_BOLD("目标：</b>[objectives]")), 1 SECONDS)
/obj/effect/landmark/ert_spawns/distress_pmc
	name = "Distress_PMC"

/obj/effect/landmark/ert_spawns/distress_pmc/item
	name = "Distress_PMCitem"
