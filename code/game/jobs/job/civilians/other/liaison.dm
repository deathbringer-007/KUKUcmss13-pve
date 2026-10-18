/datum/job/civilian/liaison
	title = JOB_CORPORATE_LIAISON
	total_positions = 1
	spawn_positions = 1
	supervisors = "维兰德-汤谷公司办事处"
	selection_class = "job_cl"
	flags_startup_parameters = ROLE_ADD_TO_DEFAULT
	gear_preset = /datum/equipment_preset/uscm_ship/liaison
	entry_message_body = "作为<a href='"+WIKI_PLACEHOLDER+"'>维兰德-汤谷公司的代表</a>，你必须始终保持角色扮演。你无需服从军事命令，但也无权下达军事命令。你的主要职责是观察情况，并将发现汇报给维兰德-汤谷。除非上级另有指示，否则应遵守常规游戏规则。使用办公室的传真机与公司总部联络或获取新指令。你可能收不到回复，这是正常的。"
	var/mob/living/carbon/human/active_liaison

/datum/job/civilian/liaison/generate_entry_conditions(mob/living/liaison, whitelist_status)
	. = ..()
	active_liaison = liaison
	RegisterSignal(liaison, COMSIG_PARENT_QDELETING, PROC_REF(cleanup_active_liaison))

/datum/job/civilian/liaison/proc/cleanup_active_liaison(mob/liaison)
	SIGNAL_HANDLER
	active_liaison = null

/obj/effect/landmark/start/liaison
	name = JOB_CORPORATE_LIAISON
	icon_state = "cl_spawn"
	job = /datum/job/civilian/liaison
