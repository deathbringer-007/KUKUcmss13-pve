//Executive Officer
/datum/job/command/executive
	title = JOB_XO
	flags_startup_parameters = ROLE_ADD_TO_DEFAULT|ROLE_ADMIN_NOTIFY
	gear_preset = /datum/equipment_preset/uscm_ship/xo

/datum/job/command/executive/generate_entry_message(mob/living/carbon/human/H)
	entry_message_body = "<a href='[generate_wiki_link()]'>你是[MAIN_SHIP_NAME]的副指挥官，</a>在指挥序列中仅次于指挥官。在适用情况下，你必须遵守<a href='[CONFIG_GET(string/wikiarticleurl)][URL_WIKI_CO_RULES]'>指挥官行为准则</a>。当某些岗位缺员时，你可能需要代行其职责，并已获得相应权限。为USCM争光！"
	return ..()

/datum/job/command/executive/generate_entry_conditions(mob/living/M, whitelist_status)
	. = ..()
	GLOB.marine_leaders[JOB_XO] = M
	RegisterSignal(M, COMSIG_PARENT_QDELETING, PROC_REF(cleanup_leader_candidate))

/datum/job/command/executive/proc/cleanup_leader_candidate(mob/M)
	SIGNAL_HANDLER
	GLOB.marine_leaders -= JOB_XO

/obj/effect/landmark/start/executive
	name = JOB_XO
	icon_state = "xo_spawn"
	job = /datum/job/command/executive
