/datum/job/command/tank_crew
	title = JOB_TANK_CREW
	total_positions = 2
	spawn_positions = 2
	allow_additional = TRUE
	scaled = TRUE
	supervisors = "现任指挥官"
	flags_startup_parameters = ROLE_ADD_TO_DEFAULT
	gear_preset = /datum/equipment_preset/uscm/tank
	entry_message_body = "你的职责是操作和维护舰上的装甲载具。你在行动中负责为陆战队提供装甲支援，同时也负责维护和修理自己的载具。"

/datum/job/command/tank_crew/set_spawn_positions(count)
	if (length(GLOB.clients) >= 200)
		spawn_positions = 2
	else
		spawn_positions = 0

/datum/job/command/tank_crew/get_total_positions(latejoin = FALSE)
	if(SStechtree.trees[TREE_MARINE].get_node(/datum/tech/arc).unlocked)
		return 0
	if(length(GLOB.clients) >= 200 || total_positions_so_far > 0)
		return 2

	return 0

/obj/effect/landmark/start/tank_crew
	name = JOB_TANK_CREW
	job = /datum/job/command/tank_crew
