/datum/job/marine/specialist
	title = JOB_SQUAD_SPECIALIST
	total_positions = 4
	spawn_positions = 4
	allow_additional = 1
	scaled = 1
	flags_startup_parameters = ROLE_ADD_TO_DEFAULT|ROLE_ADD_TO_SQUAD
	gear_preset = /datum/equipment_preset/uscm/specialist_equipped
	entry_message_body = "<a href='"+WIKI_PLACEHOLDER+"'>你是稀缺而宝贵的武器专家</a>，受训使用特种装备。你能承担多种职责，请慎重选择。"

/datum/job/marine/specialist/set_spawn_positions(count)
	spawn_positions = spec_slot_formula(count)

/datum/job/marine/specialist/get_total_positions(latejoin = 0)
	var/positions = spawn_positions
	if(latejoin)
		positions = spec_slot_formula(get_total_marines())
		if(positions <= total_positions_so_far)
			positions = total_positions_so_far
		else
			total_positions_so_far = positions
	else
		total_positions_so_far = positions
	return positions

/datum/job/marine/specialist/on_cryo(mob/living/carbon/human/cryoing)
	var/specialist_set = get_specialist_set(cryoing)
	if(isnull(specialist_set))
		return
	GLOB.specialist_set_datums[specialist_set].refund_set(cryoing)

/datum/job/marine/specialist/whiskey
	title = JOB_WO_SQUAD_SPECIALIST
	flags_startup_parameters = ROLE_ADD_TO_SQUAD
	gear_preset = /datum/equipment_preset/wo/marine/spec

/obj/effect/landmark/start/marine/spec
	name = JOB_SQUAD_SPECIALIST
	icon_state = "spec_spawn"
	job = /datum/job/marine/specialist

/obj/effect/landmark/start/marine/spec/alpha
	icon_state = "spec_spawn_alpha"
	squad = SQUAD_MARINE_1

/obj/effect/landmark/start/marine/spec/bravo
	icon_state = "spec_spawn_bravo"
	squad = SQUAD_MARINE_2

/obj/effect/landmark/start/marine/spec/charlie
	icon_state = "spec_spawn_charlie"
	squad = SQUAD_MARINE_3

/obj/effect/landmark/start/marine/spec/delta
	icon_state = "spec_spawn_delta"
	squad = SQUAD_MARINE_4

/datum/job/marine/specialist/ai
	total_positions = 0
	spawn_positions = 0

/datum/job/marine/specialist/ai/set_spawn_positions(count)
	return spawn_positions

/datum/job/marine/specialist/ai/get_total_positions(latejoin=0)
	return latejoin ? total_positions : spawn_positions

/datum/job/marine/specialist/ai/rmc
	total_positions = 1
	spawn_positions = 1
	title = JOB_TWE_RMC_MARKSMAN
	flags_startup_parameters = ROLE_ADD_TO_DEFAULT|ROLE_ADD_TO_SQUAD
	gear_preset = /datum/equipment_preset/uscm/rmc/snp
	job_options = null
	supervisors = "战斗组长与突击排指挥官"
	entry_message_body = "你是皇家陆战突击队中受过专门训练的侦察狙击手。作为火力支援组的一员，你的任务是为步枪班提供高精度火力支援。<br><b>你记得自己的个人装备和制服存放在更衣室内，专业装备位于军械库。</b>"

/obj/effect/landmark/start/marine/specialist/rmc
	name = JOB_TWE_RMC_MARKSMAN
	squad = SQUAD_RMC
	job = /datum/job/marine/specialist/ai/rmc
