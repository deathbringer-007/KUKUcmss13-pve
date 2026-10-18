#define STANDARD_VARIANT "Working Joe"
#define HAZMAT_VARIANT "Hazmat Joe"

/datum/job/civilian/working_joe
	title = JOB_WORKING_JOE
	total_positions = 6
	spawn_positions = 6
	allow_additional = TRUE
	scaled = TRUE
	supervisors = "ARES与APOLLO"
	selection_class = "job_working_joe"
	flags_startup_parameters = ROLE_ADD_TO_DEFAULT|ROLE_WHITELISTED|ROLE_CUSTOM_SPAWN
	flags_whitelist = WHITELIST_JOE
	gear_preset = /datum/equipment_preset/synth/working_joe
	gets_emergency_kit = FALSE

	job_options = list(STANDARD_VARIANT = "JOE", HAZMAT_VARIANT = "HAZ")
	var/standard = TRUE

/datum/job/civilian/working_joe/check_whitelist_status(mob/user)
	if(user.client.check_whitelist_status(WHITELIST_SYNTHETIC))
		return TRUE

	return ..()

/datum/job/civilian/working_joe/handle_job_options(option)
	if(option != HAZMAT_VARIANT)
		standard = TRUE
		gear_preset = /datum/equipment_preset/synth/working_joe
	else
		standard = FALSE
		gear_preset = /datum/equipment_preset/synth/working_joe/engi

/datum/job/civilian/working_joe/set_spawn_positions(count)
	spawn_positions = working_joe_slot_formula(count)

/datum/job/civilian/working_joe/get_total_positions(latejoin = 0)
	var/positions = spawn_positions
	if(latejoin)
		positions = working_joe_slot_formula(get_total_marines())
		if(positions <= total_positions_so_far)
			positions = total_positions_so_far
		else
			total_positions_so_far = positions
	else
		total_positions_so_far = positions
	return positions

/datum/job/civilian/working_joe/generate_entry_message(mob/living/carbon/human/H)
	if(standard)
		. = {"你是一名<a href='[generate_wiki_link()]'>工作乔。</a>你必须遵守更高标准，除了服务器规则，还须遵守陆战队军法、角色扮演要求和合成人规则。你的主要任务是保持舰船整洁，将物品归回适当位置。你也可能被安排在能力范围内协助体力劳动或文书工作。你的能力有限，但所需装备一应俱全，中央AI自有安排！始终保持角色扮演，并通过APOLLO链路与上级系统联络！"}
	else
		. = {"你是一名用于危险环境的<a href='[generate_wiki_link()]'>防化乔</a>！你必须遵守更高标准，除了服务器规则，还须遵守陆战队军法、角色扮演要求和合成人规则。你是为严苛环境设计的工作乔变型，专门承担危险的维修和维护工作。你的首要任务是维护反应堆、SMES与AI核心。其次，你应处理大气泄漏、生物危害物泄漏等危险情况，并在AI主机或委任军官下令时协助维修。除紧急情况外，你不应出现在工程部和AI核心以外的地方！始终保持角色扮演，并通过APOLLO链路与上级系统联络！"}

/datum/job/civilian/working_joe/announce_entry_message(mob/living/carbon/human/H)
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(ares_apollo_talk), "[H.real_name]已启动。"), 1.5 SECONDS)
	return ..()

/obj/effect/landmark/start/working_joe
	name = JOB_WORKING_JOE
	icon_state = "wj_spawn"
	job = /datum/job/civilian/working_joe

/datum/job/civilian/working_joe/generate_entry_conditions(mob/living/M, whitelist_status)
	. = ..()

	if(SSticker.mode)
		SSticker.mode.initialize_joe(M)
