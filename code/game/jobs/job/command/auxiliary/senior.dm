/datum/job/command/senior
	title = JOB_DI
	flags_startup_parameters = ROLE_ADD_TO_DEFAULT|ROLE_ADMIN_NOTIFY|ROLE_WHITELISTED
	flags_whitelist = WHITELIST_MENTOR
	gear_preset = /datum/equipment_preset/uscm_ship/di

	job_options = list("Gunnery Sergeant" = "GySGT", "Master Sergeant" = "MSgt", "First Sergeant" = "1Sgt", "Master Gunnery Sergeant" = "MGySgt", "Sergeant Major" = "SgtMaj")

/datum/job/command/senior/on_config_load()
	entry_message_body = "<a href='"+WIKI_PLACEHOLDER+"'>你</a>必须遵守更高标准，除了服务器规则，还须遵守<a href='"+LAW_PLACEHOLDER+"'>陆战队军法</a>与<a href='[CONFIG_GET(string/wikiarticleurl)]/[URL_WIKI_SOP]'>标准操作规程</a>，否则可能被取消导师资格。你的主要职责是教其他玩家熟悉游戏及其机制，并向舰上所有USCM部门及人员提供建议。"
	return ..()

/datum/job/command/senior/announce_entry_message(mob/living/carbon/human/H)
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(all_hands_on_deck), "Attention all hands, [H.get_paygrade(0)] [H.real_name] on deck!"), 1.5 SECONDS)
	return ..()

/datum/job/command/senior/filter_job_option(mob/job_applicant)
	. = ..()

	var/list/filtered_job_options = list(job_options[1])

	if(job_applicant?.client?.prefs)
		if(get_job_playtime(job_applicant.client, JOB_DI) >= JOB_PLAYTIME_TIER_1)
			filtered_job_options += list(job_options[2]) + list(job_options[3])
		if(get_job_playtime(job_applicant.client, JOB_DI) >= JOB_PLAYTIME_TIER_3)
			filtered_job_options += list(job_options[4]) + list(job_options[5])

	return filtered_job_options

/obj/effect/landmark/start/senior
	name = JOB_DI
	icon_state = "sea_spawn"
	job = /datum/job/command/senior
