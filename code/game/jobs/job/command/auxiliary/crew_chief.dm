/datum/job/command/crew_chief
	title = JOB_DROPSHIP_CREW_CHIEF
	total_positions = 2
	spawn_positions = 2
	allow_additional = TRUE
	scaled = TRUE
	supervisors = "飞行军官"
	flags_startup_parameters = ROLE_ADD_TO_DEFAULT
	gear_preset = /datum/equipment_preset/uscm_ship/dcc
	entry_message_body = "<a href='"+WIKI_PLACEHOLDER+"'>你的职责是协助</a>飞行军官维护舰上的运输机。你的权限仅限于运输机内，但你应维持秩序，避免打扰飞行员。"

/obj/effect/landmark/start/crew_chief
	name = JOB_DROPSHIP_CREW_CHIEF
	icon_state = "dcc_spawn"
	job = /datum/job/command/crew_chief
