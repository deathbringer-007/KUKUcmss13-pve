

//whiskey outpost extra marines
/datum/emergency_call/wo
	name = "Marine Reinforcements (Squad)"
	localized_name = "陆战队增援（小队）"
	mob_max = 15
	mob_min = 1
	probability = 0
	objectives = "协助美国殖民地海军陆战队。"

	max_smartgunners = 1
	max_heavies = 1
	max_engineers = 2
	max_medics = 2

/datum/emergency_call/wo/create_member(datum/mind/M, turf/override_spawn_loc)
	set waitfor = 0
	if(SSmapping.configs[GROUND_MAP].map_name == MAP_WHISKEY_OUTPOST)
		name_of_spawn = /obj/effect/landmark/ert_spawns/distress_wo
	var/turf/spawn_loc = override_spawn_loc ? override_spawn_loc : get_spawn_point()

	if(!istype(spawn_loc)) return //Didn't find a useable spawn point.

	var/mob/living/carbon/human/mob = new(spawn_loc)
	M.transfer_to(mob, TRUE)

	sleep(5)
	if(!leader && HAS_FLAG(mob.client.prefs.toggles_ert, PLAY_LEADER) && check_timelock(mob.client, JOB_SQUAD_LEADER, time_required_for_job))
		leader = mob
		arm_equipment(mob, /datum/equipment_preset/uscm/leader_equipped, TRUE, TRUE)
		to_chat(mob, SPAN_BOLDNOTICE("你是美国殖民地海军陆战队的一名小队长，你的小队前来协助保卫 [SSmapping.configs[GROUND_MAP].map_name]。"))
	else if (heavies < max_heavies && HAS_FLAG(mob.client.prefs.toggles_ert, PLAY_HEAVY) && check_timelock(mob.client, JOB_SQUAD_SPECIALIST, time_required_for_job))
		heavies++
		arm_equipment(mob, /datum/equipment_preset/uscm/specialist_equipped, TRUE, TRUE)
		to_chat(mob, SPAN_BOLDNOTICE("你是美国殖民地海军陆战队的一名武器专家，你的小队前来协助保卫 [SSmapping.configs[GROUND_MAP].map_name]。"))
	else if(smartgunners < max_smartgunners && HAS_FLAG(mob.client.prefs.toggles_ert, PLAY_SMARTGUNNER) && check_timelock(mob.client, JOB_SQUAD_SMARTGUN, time_required_for_job))
		smartgunners++
		arm_equipment(mob, /datum/equipment_preset/uscm/smartgunner_equipped, TRUE, TRUE)
		to_chat(mob, SPAN_BOLDNOTICE("你是美国殖民地海军陆战队的一名智能机枪手，你的小队前来协助保卫 [SSmapping.configs[GROUND_MAP].map_name]。"))
	else if(engineers < max_engineers && HAS_FLAG(mob.client.prefs.toggles_ert, PLAY_ENGINEER) && check_timelock(mob.client, JOB_SQUAD_ENGI, time_required_for_job))
		engineers++
		arm_equipment(mob, /datum/equipment_preset/uscm/engineer_equipped, TRUE, TRUE)
		to_chat(mob, SPAN_BOLDNOTICE("你是美国殖民地海军陆战队的一名工程兵，你的小队前来协助保卫 [SSmapping.configs[GROUND_MAP].map_name]。"))
	else if (medics < max_medics && HAS_FLAG(mob.client.prefs.toggles_ert, PLAY_MEDIC) && check_timelock(mob.client, JOB_SQUAD_MEDIC, time_required_for_job))
		medics++
		arm_equipment(mob, /datum/equipment_preset/uscm/engineer_equipped, TRUE, TRUE)
		to_chat(mob, SPAN_BOLDNOTICE("你是美国殖民地海军陆战队的一名医疗兵，你的小队前来协助保卫 [SSmapping.configs[GROUND_MAP].map_name]。"))
	else
		arm_equipment(mob, /datum/equipment_preset/uscm/private_equipped, TRUE, TRUE)
		to_chat(mob, SPAN_BOLDNOTICE("你是美国殖民地海军陆战队的一名步枪兵，你的小队前来协助保卫 [SSmapping.configs[GROUND_MAP].map_name]。"))

	sleep(10)
	to_chat(mob, "<B>目标：</b>[objectives]")
	GLOB.RoleAuthority.randomize_squad(mob)
	mob.sec_hud_set_ID()
	mob.hud_set_squad()

	GLOB.data_core.manifest_inject(mob) //Put people in crew manifest


/datum/game_mode/whiskey_outpost/activate_distress()
	var/datum/emergency_call/em_call = /datum/emergency_call/wo
	em_call.activate(TRUE, FALSE)
	return

/datum/emergency_call/wo/platoon
	name = "Marine Reinforcements (Platoon)"
	localized_name = "陆战队增援（排）"
	mob_min = 8
	mob_max = 30
	probability = 0

	max_heavies = 4
	max_smartgunners = 4

/datum/emergency_call/wo/platoon/cryo
	name = "Marine Reinforcements (Platoon) (Cryo)"
	localized_name = "陆战队增援（排，冷冻休眠）"
	probability = 0
	name_of_spawn = /obj/effect/landmark/ert_spawns/distress_cryo
	shuttle_id = ""

/datum/emergency_call/wo/cryo
	name = "Marine Reinforcements (Squad) (Cryo)"
	localized_name = "陆战队增援（小队，冷冻休眠）"
	probability = 0
	name_of_spawn = /obj/effect/landmark/ert_spawns/distress_cryo
	shuttle_id = ""
