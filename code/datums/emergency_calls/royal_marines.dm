/datum/emergency_call/royal_marines
	name = "Royal Marines Commando (Squad) (Friendly)"
	mob_max = 7
	probability = 15
	home_base = /datum/lazy_template/ert/twe_station
	shuttle_id = MOBILE_SHUTTLE_ID_ERT4
	name_of_spawn = /obj/effect/landmark/ert_spawns/distress_twe
	item_spawn = /obj/effect/landmark/ert_spawns/distress_twe/item
	max_engineers =  0
	max_medics = 0
	max_heavies = 3

/datum/emergency_call/royal_marines/New()
	..()
	arrival_message = "[MAIN_SHIP_NAME]，这里是[pick_weight(list("HMS帕特纳号"= 50, "HMS雷霆之子号" = 50))]。我们正在响应你们的求救信号，并依据《2177年军事援助法案》登舰。认证代码：Lima-18153。"
	objectives = "确保 [MAIN_SHIP_NAME] 幸存，消灭所有敌对目标，并尽一切可能协助船员。"


/datum/emergency_call/royal_marines/create_member(datum/mind/spawning_mind, turf/override_spawn_loc)
	var/turf/spawn_loc = override_spawn_loc ? override_spawn_loc : get_spawn_point()

	if(!istype(spawn_loc))
		return //Didn't find a useable spawn point.

	var/mob/living/carbon/human/mob = new(spawn_loc)
	spawning_mind.transfer_to(mob, TRUE)

	if(!leader && HAS_FLAG(mob.client.prefs.toggles_ert, PLAY_LEADER) && check_timelock(mob.client, JOB_SQUAD_LEADER, time_required_for_job))
		leader = mob
		to_chat(mob, SPAN_ROLE_HEADER("你是皇家陆战突击队的一名军官，出生于三世界帝国。"))
		arm_equipment(mob, /datum/equipment_preset/royal_marine/leader, TRUE, TRUE)
	else if(heavies < max_heavies && HAS_FLAG(mob.client.prefs.toggles_ert, PLAY_HEAVY) && check_timelock(mob.client, JOB_SQUAD_SPECIALIST))
		var/specialist_kit = pick("Sniper", "Smartgun", "Breach")
		switch(specialist_kit)
			if("Sniper")
				to_chat(mob, SPAN_ROLE_HEADER("你是皇家陆战突击队的一名熟练射手，出生于三世界帝国。"))
				arm_equipment(mob, /datum/equipment_preset/royal_marine/standard, TRUE, TRUE)
			if("Smartgun")
				to_chat(mob, SPAN_ROLE_HEADER("你是皇家陆战突击队的一名智能机枪手，出生于三世界帝国。"))
				arm_equipment(mob, /datum/equipment_preset/royal_marine/machinegun, TRUE, TRUE)
			if("Breach")
				to_chat(mob, SPAN_ROLE_HEADER("你是皇家陆战突击队的一名近距离作战专家，出生于三世界帝国。"))
				arm_equipment(mob, /datum/equipment_preset/royal_marine/standard, TRUE, TRUE)
		heavies++
	else
		to_chat(mob, SPAN_ROLE_HEADER("你是皇家陆战突击队的一员，出生于三世界帝国。"))
		arm_equipment(mob, /datum/equipment_preset/royal_marine/standard, TRUE, TRUE)

	print_backstory(mob)

	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(to_chat), mob, SPAN_BOLD("目标：</b>[objectives]")), 1 SECONDS)


/datum/emergency_call/royal_marines/print_backstory(mob/living/carbon/human/spawning_mob)
	to_chat(spawning_mob, SPAN_BOLD("你出生于三世界帝国的一个[pick_weight(list("普通" = 75, "贫困" = 15, "家境殷实" = 10))]家庭。"))
	to_chat(spawning_mob, SPAN_BOLD("加入皇家陆战突击队让你获得了丰富的战斗经验与实用技能。"))
	to_chat(spawning_mob, SPAN_BOLD("你对异形威胁的了解程度是：[pick_weight(list("毫不知情" = 75, "略有耳闻" = 15, "十分了解" = 10))]。"))
	to_chat(spawning_mob, SPAN_BOLD("你是三世界帝国公民，并加入了皇家陆战突击队。"))
	to_chat(spawning_mob, SPAN_BOLD("你隶属于一支驻扎在帕特纳号和雷霆之子号上的美洲联盟与三世界帝国联合特遣队。"))
	to_chat(spawning_mob, SPAN_BOLD("根据皇家陆战突击队最高指挥部的指示，你一直在协助美国殖民地海军陆战队维护当地和平。"))
	to_chat(spawning_mob, SPAN_BOLD("尽你所能，协助 [MAIN_SHIP_NAME] 的美国殖民地海军陆战队部队。"))

/datum/emergency_call/royal_marines/platoon
	name = "Royal Marines Commando (Platoon) (Friendly)"
	mob_min = 7
	mob_max = 28
	probability = 0
	max_medics = 0
	max_heavies = 6
	max_engineers = 0

/obj/effect/landmark/ert_spawns/distress_twe
	name = "Distress_TWE"

/obj/effect/landmark/ert_spawns/distress_twe/item
	name = "Distress_TWEItem"

