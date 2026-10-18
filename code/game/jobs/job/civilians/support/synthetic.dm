/datum/job/civilian/synthetic
	title = JOB_SYNTH
	total_positions = 2
	spawn_positions = 1
	allow_additional = 1
	scaled = 1
	supervisors = "现任指挥官"
	selection_class = "job_synth"
	flags_startup_parameters = ROLE_ADD_TO_DEFAULT|ROLE_ADMIN_NOTIFY|ROLE_WHITELISTED|ROLE_CUSTOM_SPAWN
	flags_whitelist = WHITELIST_SYNTHETIC
	gear_preset = /datum/equipment_preset/synth/uscm
	entry_message_body = "你是一名<a href='"+WIKI_PLACEHOLDER+"'>合成人！</a>你必须遵守更高标准，除了服务器规则，还须遵守陆战队军法与合成人规则，否则可能被取消白名单资格。你的主要职责是支援和协助舰上所有USCM部门及人员。作为合成人，你掌握舰上各个领域和专业的知识。通常情况下，你听命于现任指挥官；特殊情况可能改变这一关系！"

/datum/job/civilian/synthetic/New()
	. = ..()
	gear_preset_whitelist = list(
		"[JOB_SYNTH][WHITELIST_NORMAL]" = /datum/equipment_preset/synth/uscm,
		"[JOB_SYNTH][WHITELIST_COUNCIL]" = /datum/equipment_preset/synth/uscm,
		"[JOB_SYNTH][WHITELIST_LEADER]" = /datum/equipment_preset/synth/uscm
	)

/datum/job/civilian/synthetic/get_whitelist_status(client/player)
	. = ..()
	if(!.)
		return

	if(player.check_whitelist_status(WHITELIST_SYNTHETIC_LEADER))
		return get_desired_status(player.prefs.synth_status, WHITELIST_LEADER)
	if(player.check_whitelist_status(WHITELIST_SYNTHETIC_COUNCIL|WHITELIST_SYNTHETIC_COUNCIL_LEGACY))
		return get_desired_status(player.prefs.synth_status, WHITELIST_COUNCIL)
	if(player.check_whitelist_status(WHITELIST_SYNTHETIC))
		return get_desired_status(player.prefs.synth_status, WHITELIST_NORMAL)

/datum/job/civilian/synthetic/set_spawn_positions(count)
	spawn_positions = synth_slot_formula(count)

/datum/job/civilian/synthetic/get_total_positions(latejoin = 0)
	var/positions = spawn_positions
	if(latejoin)
		positions = synth_slot_formula(get_total_marines())
		if(positions <= total_positions_so_far)
			positions = total_positions_so_far
		else
			total_positions_so_far = positions
	else
		total_positions_so_far = positions
	return positions

/obj/effect/landmark/start/synthetic
	name = JOB_SYNTH
	icon_state = "syn_spawn"
	job = /datum/job/civilian/synthetic
