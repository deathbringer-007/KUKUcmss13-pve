#define SSGT_VARIANT "Staff Sergeant"
#define SGT_VARIANT "Sergeant"
#define CPL_VARIANT "Corporal"
#define JSGT_VARIANT "Junior Sergeant"

/datum/job/marine/tl
	title = JOB_SQUAD_TEAM_LEADER
	total_positions = 8
	spawn_positions = 8
	allow_additional = 1
	flags_startup_parameters = ROLE_ADD_TO_DEFAULT|ROLE_ADD_TO_SQUAD
	gear_preset = /datum/equipment_preset/uscm/tl
	gear_preset_secondary = /datum/equipment_preset/uscm/tl/corporal
	entry_message_body = "你是<a href='"+WIKI_PLACEHOLDER+"'>小队长。</a>你的任务是率领指定的小队，并运用可用军械。如果分队士官阵亡，你应接替其指挥。<br><b>你记得自己的个人装备和制服存放在宿舍或更衣室内。</b>"

	job_options = list(CPL_VARIANT = "CPL", SGT_VARIANT = "SGT")

/datum/job/marine/tl/generate_entry_conditions(mob/living/carbon/human/spawning_human)
	. = ..()
	spawning_human.important_radio_channels += JTAC_FREQ

/datum/job/marine/tl/handle_job_options(option)
	if(option != CPL_VARIANT)
		gear_preset = initial(gear_preset)
	else
		gear_preset = gear_preset_secondary

/obj/effect/landmark/start/marine/tl
	name = JOB_SQUAD_TEAM_LEADER
	icon_state = "tl_spawn"
	job = /datum/job/marine/tl

/obj/effect/landmark/start/marine/tl/alpha
	icon_state = "tl_spawn_alpha"
	squad = SQUAD_MARINE_1

/obj/effect/landmark/start/marine/tl/bravo
	icon_state = "tl_spawn_bravo"
	squad = SQUAD_MARINE_2

/obj/effect/landmark/start/marine/tl/charlie
	icon_state = "tl_spawn_charlie"
	squad = SQUAD_MARINE_3

/obj/effect/landmark/start/marine/tl/delta
	icon_state = "tl_spawn_delta"
	squad = SQUAD_MARINE_4

/datum/job/marine/tl/ai
	total_positions = 2
	spawn_positions = 2

/datum/job/marine/tl/ai/upp
	title = JOB_SQUAD_TEAM_LEADER_UPP
	gear_preset = /datum/equipment_preset/uscm/tl/upp
	gear_preset_secondary = /datum/equipment_preset/uscm/tl/upp/junior_sergeant
	job_options = list(JSGT_VARIANT = "JrSGT", SGT_VARIANT = "SGT")

/datum/job/marine/tl/ai/upp/handle_job_options(option)
	gear_preset = initial(gear_preset)
	if(option == JSGT_VARIANT)
		gear_preset = gear_preset_secondary

/datum/job/marine/tl/ai/forecon
	total_positions = 1
	spawn_positions = 1
	title = JOB_SQUAD_TEAM_LEADER_FORECON
	gear_preset = /datum/equipment_preset/uscm/tl/forecon
	gear_preset_secondary = /datum/equipment_preset/uscm/tl/forecon/sergeant
	job_options = list(SGT_VARIANT = "SGT", SSGT_VARIANT = "SSGT")

/datum/job/marine/tl/ai/forecon/handle_job_options(option)
	gear_preset = initial(gear_preset)
	if(option == SGT_VARIANT)
		gear_preset = gear_preset_secondary

/obj/effect/landmark/start/marine/tl/upp
	name = JOB_SQUAD_TEAM_LEADER_UPP
	squad = SQUAD_UPP
	job = /datum/job/marine/tl/ai/upp


/datum/job/marine/tl/ai/pmc
	title = JOB_PMCPLAT_FTL
	gear_preset = /datum/equipment_preset/uscm/pmc/tl
	job_options = null

/obj/effect/landmark/start/marine/tl/pmc
	name = JOB_PMCPLAT_FTL
	squad = SQUAD_PMCPLT
	job = /datum/job/marine/tl/ai/pmc

/datum/job/marine/tl/ai/pmc/small
	title = JOB_PMCPLAT_SMALL_FTL
	gear_preset = /datum/equipment_preset/uscm/pmc/tl
	job_options = null
	total_positions = 1
	spawn_positions = 1

/obj/effect/landmark/start/marine/tl/pmc/small
	name = JOB_PMCPLAT_SMALL_FTL
	squad = SQUAD_PMCPLT_SMALL
	job = /datum/job/marine/tl/ai/pmc/small

/obj/effect/landmark/start/marine/tl/forecon
	name = JOB_SQUAD_TEAM_LEADER_FORECON
	squad = SQUAD_LRRP
	job = /datum/job/marine/tl/ai/forecon

//-- RMC Platoon --//
//Section/squad leader & team leader//

/datum/job/marine/tl/ai/rmc
	total_positions = 1
	spawn_positions = 1
	title = JOB_TWE_RMC_SECTIONLEADER
	gear_preset = /datum/equipment_preset/uscm/rmc/sl
	job_options = null
	supervisors = "突击排指挥官与突击排士官"
	entry_message_body = "你是皇家陆战突击队步枪班的班长。你的任务是率领步枪班、运用可用军械，并按需派出班内的火力支援组。<br><b>你记得自己的个人装备和制服存放在更衣室内，作战装备位于军械库。</b>"

/obj/effect/landmark/start/marine/tl/rmc
	name = JOB_TWE_RMC_SECTIONLEADER
	squad = SQUAD_RMC
	job = /datum/job/marine/tl/ai/rmc

/datum/job/marine/tl/ai/rmc2ic
	total_positions = 1
	spawn_positions = 1
	title = JOB_TWE_RMC_TEAMLEADER
	gear_preset = /datum/equipment_preset/uscm/rmc/tl
	job_options = null
	supervisors = "班长与突击排指挥官"
	entry_message_body = "你是皇家陆战突击队武器专家组成的火力支援组的组长。你的任务是协调小组可用的各类军械火力。如果班长阵亡，你可能需要接替步枪班的指挥。<br><b>你记得自己的个人装备和制服存放在更衣室内。</b>"

/obj/effect/landmark/start/marine/tl/rmc2ic
	name = JOB_TWE_RMC_TEAMLEADER
	squad = SQUAD_RMC
	job = /datum/job/marine/tl/ai/rmc2ic

#undef SSGT_VARIANT
#undef SGT_VARIANT
#undef CPL_VARIANT
#undef JSGT_VARIANT
