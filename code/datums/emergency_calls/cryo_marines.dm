

/datum/emergency_call/cryo_squad
	name = "Marine Cryo Reinforcements (Squad)"
	mob_max = 10
	mob_min = 1
	probability = 0
	objectives = "协助美国殖民地海军陆战队。"
	max_engineers = 2
	max_medics = 2
	name_of_spawn = /obj/effect/landmark/ert_spawns/distress_cryo
	shuttle_id = ""
	var/leaders = 0
	spawn_max_amount = TRUE

/datum/emergency_call/cryo_squad/spawn_candidates(quiet_launch, announce_incoming, override_spawn_loc)
	var/datum/squad/marine/cryo/cryo_squad = GLOB.RoleAuthority.squads_by_type[/datum/squad/marine/cryo]
	leaders = cryo_squad.num_leaders
	. = ..()
	shipwide_ai_announcement("已成功部署[mob_max]名福克斯特罗特陆战队员，其中[length(members)]名已准备好执勤。")
	if(mob_max > length(members))
		announce_dchat("Some cryomarines were not taken, use the Join As Freed Mob verb to take one of them.")

/datum/emergency_call/cryo_squad/create_member(datum/mind/mind, turf/override_spawn_loc)
	set waitfor = 0
	if(SSmapping.configs[GROUND_MAP].map_name == MAP_WHISKEY_OUTPOST)
		name_of_spawn = /obj/effect/landmark/ert_spawns/distress_wo
	var/turf/spawn_loc = override_spawn_loc ? override_spawn_loc : get_spawn_point()

	if(!istype(spawn_loc)) return //Didn't find a useable spawn point.

	var/mob/living/carbon/human/human = new(spawn_loc)

	if(mind)
		mind.transfer_to(human, TRUE)
	else
		human.create_hud()

	if(!mind)
		FOR_DVIEW(var/obj/structure/machinery/cryopod/pod, 7, human, HIDE_INVISIBLE_OBSERVER)
			if(pod && !pod.occupant)
				pod.go_in_cryopod(human, silent = TRUE)
				break
		FOR_DVIEW_END

	sleep(5)
	var/datum/squad/marine/cryo/cryo_squad = GLOB.RoleAuthority.squads_by_type[/datum/squad/marine/cryo]
	if(leaders < cryo_squad.max_leaders && (!mind || (HAS_FLAG(human.client.prefs.toggles_ert, PLAY_LEADER) && check_timelock(human.client, JOB_SQUAD_LEADER, time_required_for_job))))
		leader = human
		leaders++
		human.client?.prefs.copy_all_to(human, JOB_SQUAD_LEADER, TRUE, TRUE)
		to_chat(human, SPAN_ROLE_HEADER("你是美国殖民地海军陆战队的一名小队长。"))
		to_chat(human, SPAN_ROLE_BODY("你前来协助保卫 [SSmapping.configs[GROUND_MAP].map_name]。请服从指挥链的命令。"))
		to_chat(human, SPAN_BOLDWARNING("如果你刚加入就想进入冷冻休眠或转为观察者，必须通过管理员求助告知工作人员，以便安排人员接替。"))
	else if (heavies < max_heavies && (!mind || (HAS_FLAG(human.client.prefs.toggles_ert, PLAY_HEAVY) && check_timelock(human.client, JOB_SQUAD_SPECIALIST, time_required_for_job))))
		heavies++
		human.client?.prefs.copy_all_to(human, JOB_SQUAD_SPECIALIST, TRUE, TRUE)
		arm_equipment(human, /datum/equipment_preset/uscm/specialist_equipped,  mind == null, TRUE)
		to_chat(human, SPAN_ROLE_HEADER("你是美国殖民地海军陆战队的一名武器专家。"))
		to_chat(human, SPAN_ROLE_BODY("你的小队前来协助保卫 [SSmapping.configs[GROUND_MAP].map_name]。请服从指挥链的命令。"))
		to_chat(human, SPAN_BOLDWARNING("如果你刚加入就想进入冷冻休眠或转为观察者，必须通过管理员求助告知工作人员，以便安排人员接替。"))
	else if (medics < max_medics && (!mind || (HAS_FLAG(human.client.prefs.toggles_ert, PLAY_MEDIC) && check_timelock(human.client, JOB_SQUAD_MEDIC, time_required_for_job))))
		medics++
		human.client?.prefs.copy_all_to(human, JOB_SQUAD_MEDIC, TRUE, TRUE)
		to_chat(human, SPAN_ROLE_HEADER("你是美国殖民地海军陆战队的一名医疗兵。"))
		to_chat(human, SPAN_ROLE_BODY("你前来协助保卫 [SSmapping.configs[GROUND_MAP].map_name]。请服从指挥链的命令。"))
		to_chat(human, SPAN_BOLDWARNING("如果你刚加入就想进入冷冻休眠或转为观察者，必须通过管理员求助告知工作人员，以便安排人员接替。"))
	else if (engineers < max_engineers && (!mind || (HAS_FLAG(human.client.prefs.toggles_ert, PLAY_ENGINEER) && check_timelock(human.client, JOB_SQUAD_ENGI, time_required_for_job))))
		engineers++
		human.client?.prefs.copy_all_to(human, JOB_SQUAD_ENGI, TRUE, TRUE)
		arm_equipment(human, /datum/equipment_preset/uscm/engineer_equipped,  mind == null, TRUE)
		to_chat(human, SPAN_ROLE_HEADER("你是美国殖民地海军陆战队的一名工程兵。"))
		to_chat(human, SPAN_ROLE_BODY("你前来协助保卫 [SSmapping.configs[GROUND_MAP].map_name]。请服从指挥链的命令。"))
		to_chat(human, SPAN_BOLDWARNING("如果你刚加入就想进入冷冻休眠或转为观察者，必须通过管理员求助告知工作人员，以便安排人员接替。"))
	else
		human.client?.prefs.copy_all_to(human, JOB_SQUAD_MARINE, TRUE, TRUE)
		to_chat(human, SPAN_ROLE_HEADER("你是美国殖民地海军陆战队的一名步枪兵。"))
		to_chat(human, SPAN_ROLE_BODY("你前来协助保卫 [SSmapping.configs[GROUND_MAP].map_name]。请服从指挥链的命令。"))
		to_chat(human, SPAN_BOLDWARNING("如果你刚加入就想进入冷冻休眠或转为观察者，必须通过管理员求助告知工作人员，以便安排人员接替。"))

	sleep(10)
	if(!mind)
		human.free_for_ghosts()
	to_chat(human, SPAN_BOLD("目标：[objectives]"))

/datum/emergency_call/cryo_squad/platoon
	name = "Marine Cryo Reinforcements (Platoon)"
	mob_min = 8
	mob_max = 30
	probability = 0
	max_engineers = 8

/obj/effect/landmark/ert_spawns/distress_cryo
	name = "Distress_Cryo"

/datum/emergency_call/cryo_squad/tech
	name = "Marine Cryo Reinforcements (Tech)"
	mob_max = 5
	max_engineers = 1
	max_medics = 1
	max_heavies = 0
