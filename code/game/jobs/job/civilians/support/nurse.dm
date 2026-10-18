/datum/job/civilian/nurse
	title = JOB_NURSE
	total_positions = 3
	spawn_positions = 3
	supervisors = "首席医疗官"
	selection_class = "job_doctor"
	flags_startup_parameters = ROLE_ADD_TO_DEFAULT
	gear_preset = /datum/equipment_preset/uscm_ship/uscm_medical/nurse
	entry_message_body = "<a href='"+WIKI_PLACEHOLDER+"'>你的职责是让陆战队员保持健康与战斗力。</a>你也精通用药与治疗，并能施行小型手术。请以协助医生和为受伤陆战队员分诊为重点。"

/obj/effect/landmark/start/nurse
	name = JOB_NURSE
	icon_state = "nur_spawn"
	job = /datum/job/civilian/nurse
