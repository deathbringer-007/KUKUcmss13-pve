/datum/job/civilian/professor
	title = JOB_CMO
	total_positions = 1
	spawn_positions = 1
	supervisors = "现任指挥官"
	selection_class = "job_cmo"
	flags_startup_parameters = ROLE_ADD_TO_DEFAULT
	gear_preset = /datum/equipment_preset/uscm_ship/uscm_medical/cmo
	entry_message_body = "你是USCM的一名委任军官。<a href='"+WIKI_PLACEHOLDER+"'>你有权管理医疗舱和科研部门的一切事务</a>，只有副指挥官和指挥官能够推翻你的决定。你负责管理医务人员、手术、药物配制与兴奋剂，并维持陆战队员的整体健康。"

/obj/effect/landmark/start/professor
	name = JOB_CMO
	icon_state = "cmo_spawn"
	job = /datum/job/civilian/professor
