#define LCPL_VARIANT "Lance Corporal"
#define PFC_VARIANT "Private First Class"

/datum/job/marine/engineer
	title = JOB_SQUAD_ENGI
	total_positions = 12
	spawn_positions = 12
	allow_additional = 1
	flags_startup_parameters = ROLE_ADD_TO_DEFAULT|ROLE_ADD_TO_SQUAD
	gear_preset = /datum/equipment_preset/uscm/engineer
	entry_message_body = "你拥有<a href='"+WIKI_PLACEHOLDER+"'>建造工事、改接电线和构筑防御所需的装备与技能</a>。在战场建设方面，队友会依靠你。"

/datum/job/marine/engineer/set_spawn_positions(count)
	for(var/datum/squad/sq in GLOB.RoleAuthority.squads)
		if(sq)
			sq.max_engineers = engi_slot_formula(count)

/datum/job/marine/engineer/get_total_positions(latejoin=0)
	var/slots = engi_slot_formula(get_total_marines())

	if(slots <= total_positions_so_far)
		slots = total_positions_so_far
	else
		total_positions_so_far = slots

	if(latejoin)
		for(var/datum/squad/sq in GLOB.RoleAuthority.squads)
			if(sq)
				sq.max_engineers = slots

	return (slots*4)

/datum/job/marine/engineer/whiskey
	title = JOB_WO_SQUAD_ENGINEER
	flags_startup_parameters = ROLE_ADD_TO_SQUAD
	gear_preset = /datum/equipment_preset/wo/marine/engineer

/obj/effect/landmark/start/marine/engineer
	name = JOB_SQUAD_ENGI
	icon_state = "engi_spawn"
	job = /datum/job/marine/engineer

/obj/effect/landmark/start/marine/engineer/alpha
	icon_state = "engi_spawn_alpha"
	squad = SQUAD_MARINE_1

/obj/effect/landmark/start/marine/engineer/bravo
	icon_state = "engi_spawn_bravo"
	squad = SQUAD_MARINE_2

/obj/effect/landmark/start/marine/engineer/charlie
	icon_state = "engi_spawn_charlie"
	squad = SQUAD_MARINE_3

/obj/effect/landmark/start/marine/engineer/delta
	icon_state = "engi_spawn_delta"
	squad = SQUAD_MARINE_4

//Having to add a /ai subtype before the /rmc one, might as well make it viable for use
/datum/job/marine/engineer/ai
	total_positions = 2
	spawn_positions = 2
	gear_preset = /datum/equipment_preset/uscm/engineer
	gear_preset_secondary = /datum/equipment_preset/uscm/engineer/pfc
	job_options = list(PFC_VARIANT = "PFC", LCPL_VARIANT = "LCPL")

/obj/effect/landmark/start/marine/engineer/ai
	job = /datum/job/marine/engineer/ai

/datum/job/marine/engineer/ai/set_spawn_positions(count)
	return spawn_positions

/datum/job/marine/engineer/ai/get_total_positions(latejoin=0)
	return latejoin ? total_positions : spawn_positions

/datum/job/marine/engineer/ai/rmc
	total_positions = 1
	spawn_positions = 1
	title = JOB_TWE_RMC_ENGI
	flags_startup_parameters = ROLE_ADD_TO_DEFAULT|ROLE_ADD_TO_SQUAD
	gear_preset = /datum/equipment_preset/uscm/rmc/eng
	job_options = null
	supervisors = "班长与突击排指挥官"
	entry_message_body = "你是经过突击队训练的皇家工兵团成员，随皇家陆战突击队服役。你在步枪班中配备相应装备，并负责建造工事、改接电线，以及处理战场上的各类工程事务。<br><b>你记得自己的个人装备和制服存放在更衣室内，专业装备位于军械库。</b>"

/obj/effect/landmark/start/marine/engineer/rmc
	name = JOB_TWE_RMC_ENGI
	squad = SQUAD_RMC
	job = /datum/job/marine/engineer/ai/rmc

/datum/job/marine/engineer/ai/rmcmortar
	total_positions = 1
	spawn_positions = 1
	title = JOB_TWE_RMC_BREACHER
	flags_startup_parameters = ROLE_ADD_TO_DEFAULT|ROLE_ADD_TO_SQUAD
	gear_preset = /datum/equipment_preset/uscm/rmc/mor
	job_options = null
	supervisors = "突击排指挥官与突击排士官"
	entry_message_body = "你是经过突击队训练的皇家炮兵团成员，随皇家陆战突击队服役。你负责通过迫击炮或多发榴弹发射器系统，为突击排提供轻型火力支援。作为指挥班的一员，你将与突击排指挥官及突击排士官密切协作；后者应携带你的备用支援武器弹药。<br><b>你记得自己的个人装备和制服存放在更衣室内，专业装备位于军械库。</b>"

/obj/effect/landmark/start/marine/engineer/rmcmortar
	name = JOB_TWE_RMC_BREACHER
	squad = SQUAD_RMC
	job = /datum/job/marine/engineer/ai/rmcmortar

#undef LCPL_VARIANT
#undef PFC_VARIANT
