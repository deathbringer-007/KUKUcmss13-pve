/datum/job/logistics/maint
	title = JOB_MAINT_TECH
	total_positions = 3
	spawn_positions = 3
	supervisors = "总工程师"
	selection_class = "job_ot"
	flags_startup_parameters = ROLE_ADD_TO_DEFAULT
	gear_preset = /datum/equipment_preset/uscm_ship/maint
	entry_message_body = "<a href='"+WIKI_PLACEHOLDER+"'>你的职责是维护舰船的完整性，包括轨道炮。</a>你是舰上职责较为灵活的人员之一，因此上级也可能安排你处理其他杂务。"

/obj/effect/landmark/start/maint
	name = JOB_MAINT_TECH
	icon_state = "mt_spawn"
	job = /datum/job/logistics/maint
