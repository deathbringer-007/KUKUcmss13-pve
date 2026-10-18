

//whiskey outpost extra marines
/datum/emergency_call/tank_crew
	name = "Vehicle Crew Cryo Reinforcements"
	mob_max = 2
	mob_min = 2
	probability = 0
	objectives = "协助美国殖民地海军陆战队。"
	name_of_spawn = /obj/effect/landmark/ert_spawns/distress_cryo
	shuttle_id = ""

/datum/emergency_call/tank_crew/create_member(datum/mind/M, turf/override_spawn_loc)
	set waitfor = 0
	if(SSmapping.configs[GROUND_MAP].map_name == MAP_WHISKEY_OUTPOST)
		name_of_spawn = /obj/effect/landmark/ert_spawns/distress_wo
	var/turf/spawn_loc = override_spawn_loc ? override_spawn_loc : get_spawn_point()

	if(!istype(spawn_loc)) return //Didn't find a useable spawn point.

	var/mob/living/carbon/human/H = new(spawn_loc)
	M.transfer_to(H, TRUE)

	sleep(5)
	arm_equipment(H, /datum/equipment_preset/uscm/tank, TRUE, TRUE)
	to_chat(H, SPAN_ROLE_HEADER("你是美国殖民地海军陆战队的一名车组成员。"))
	to_chat(H, SPAN_ROLE_BODY("你前来协助保卫 [SSmapping.configs[GROUND_MAP].map_name]。请服从指挥链的命令。"))
	to_chat(H, SPAN_BOLDWARNING("如果你刚加入就想进入冷冻休眠或转为观察者，必须通过管理员求助告知工作人员，以便安排人员接替。"))

	sleep(10)
	to_chat(H, SPAN_BOLD("目标：[objectives]"))

	GLOB.data_core.manifest_inject(H) //Put people in crew manifest
