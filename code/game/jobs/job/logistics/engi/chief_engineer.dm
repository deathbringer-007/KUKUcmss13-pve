/datum/job/logistics/engineering
	title = JOB_CHIEF_ENGINEER
	selection_class = "job_ce"
	flags_startup_parameters = ROLE_ADD_TO_DEFAULT
	gear_preset = /datum/equipment_preset/uscm_ship/chief_engineer
	entry_message_body = "<a href='"+WIKI_PLACEHOLDER+"'>你的职责</a>是管理工程部门并监督技师。你负责工程、电力、军械和轨道炮。若指挥官和副指挥官均无法履职，你就是指挥序列中的下一人。"

/obj/effect/landmark/start/engineering
	name = JOB_CHIEF_ENGINEER
	icon_state = "ce_spawn"
	job = /datum/job/logistics/engineering
