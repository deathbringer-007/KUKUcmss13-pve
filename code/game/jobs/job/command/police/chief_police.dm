//Chief MP
/datum/job/command/warrant
	title = JOB_CHIEF_POLICE
	selection_class = "job_cmp"
	flags_startup_parameters = ROLE_ADD_TO_DEFAULT
	gear_preset = /datum/equipment_preset/uscm_ship/uscm_police/cmp
	entry_message_body = "<a href='"+WIKI_PLACEHOLDER+"'>你</a>必须遵守更高标准，除了服务器规则，还须遵守<a href='"+LAW_PLACEHOLDER+"'>陆战队军法</a>，否则可能受到职位封禁或服务器封禁。你领导宪兵，确保他们维持舰上的和平与秩序。陆战队员在低温休眠数周后可能会变得躁动！此外，你还负责保护包括指挥人员在内的高级人员。务必确保他们安全！"
	var/mob/living/carbon/human/active_cmp

/datum/job/command/warrant/generate_entry_conditions(mob/living/cmp, whitelist_status)
	. = ..()
	active_cmp = cmp
	RegisterSignal(cmp, COMSIG_PARENT_QDELETING, PROC_REF(cleanup_active_cmp))

/datum/job/command/warrant/proc/cleanup_active_cmp(mob/cmp)
	SIGNAL_HANDLER
	active_cmp = null

/obj/effect/landmark/start/warrant
	name = JOB_CHIEF_POLICE
	icon_state = "cmp_spawn"
	job = /datum/job/command/warrant
