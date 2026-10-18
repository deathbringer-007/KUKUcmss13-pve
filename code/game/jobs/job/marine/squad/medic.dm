#define SGT_VARIANT "Sergeant"
#define JSGT_VARIANT "Junior Sergeant"
#define CPL_VARIANT "Corporal"
#define LCPL_VARIANT "Lance Corporal"
#define PFC_VARIANT "Private First Class"
#define SR_PVT_VARIANT "Senior Private"
#define PVT_VARIANT "Private"

/datum/job/marine/medic
	title = JOB_SQUAD_MEDIC
	total_positions = 16
	spawn_positions = 16
	allow_additional = 1
	flags_startup_parameters = ROLE_ADD_TO_DEFAULT|ROLE_ADD_TO_SQUAD
	gear_preset = /datum/equipment_preset/uscm/medic
	gear_preset_secondary = /datum/equipment_preset/uscm/medic/lance_corporal
	gear_preset_tertiary = /datum/equipment_preset/uscm/medic/pfc
	gear_preset_quaternary = /datum/equipment_preset/uscm/medic/private
	entry_message_body = "<a href='"+WIKI_PLACEHOLDER+"'>你负责治疗陆战队战友的伤势</a>，让他们保持健康与战斗力。你或许不是一名全科医生，但关键时刻，你守在生与死之间。<br>你的军衔可能与小队长相同，但需要接替指挥时，小队长的顺位在你之前。<br><b>你记得自己的个人装备和制服存放在医疗办公室内。</b>"

	job_options = list(PVT_VARIANT = "PVT", PFC_VARIANT = "PFC", LCPL_VARIANT = "LCPL", CPL_VARIANT = "CPL")

/datum/job/marine/medic/set_spawn_positions(count)
	for(var/datum/squad/sq in GLOB.RoleAuthority.squads)
		if(sq)
			sq.max_medics = medic_slot_formula(count)

/datum/job/marine/medic/get_total_positions(latejoin=0)
	var/slots = medic_slot_formula(get_total_marines())

	if(slots <= total_positions_so_far)
		slots = total_positions_so_far
	else
		total_positions_so_far = slots

	if(latejoin)
		for(var/datum/squad/sq in GLOB.RoleAuthority.squads)
			if(sq)
				sq.max_medics = slots

	return (slots*4)

/datum/job/marine/medic/handle_job_options(option)
	gear_preset = initial(gear_preset)
	if(option == PVT_VARIANT)
		gear_preset = gear_preset_quaternary
	if(option == PFC_VARIANT)
		gear_preset = gear_preset_tertiary
	if(option == LCPL_VARIANT)
		gear_preset = gear_preset_secondary

/datum/job/marine/medic/whiskey
	title = JOB_WO_SQUAD_MEDIC
	flags_startup_parameters = ROLE_ADD_TO_SQUAD
	gear_preset = /datum/equipment_preset/wo/marine/medic

/obj/effect/landmark/start/marine/medic
	name = JOB_SQUAD_MEDIC
	icon_state = "medic_spawn"
	job = /datum/job/marine/medic

/obj/effect/landmark/start/marine/medic/alpha
	icon_state = "medic_spawn_alpha"
	squad = SQUAD_MARINE_1

/obj/effect/landmark/start/marine/medic/bravo
	icon_state = "medic_spawn_bravo"
	squad = SQUAD_MARINE_2

/obj/effect/landmark/start/marine/medic/charlie
	icon_state = "medic_spawn_charlie"
	squad = SQUAD_MARINE_3

/obj/effect/landmark/start/marine/medic/delta
	icon_state = "medic_spawn_delta"
	squad = SQUAD_MARINE_4

/datum/job/marine/medic/ai
	total_positions = 1
	spawn_positions = 1

/datum/job/marine/medic/ai/set_spawn_positions(count)
	return spawn_positions

/datum/job/marine/medic/ai/get_total_positions(latejoin=0)
	return latejoin ? total_positions : spawn_positions

/datum/job/marine/medic/ai/upp
	title = JOB_SQUAD_MEDIC_UPP
	gear_preset = /datum/equipment_preset/uscm/medic/upp
	gear_preset_secondary = /datum/equipment_preset/uscm/medic/upp/corporal
	gear_preset_tertiary = /datum/equipment_preset/uscm/medic/upp/senior_private
	gear_preset_quaternary = /datum/equipment_preset/uscm/medic/upp/private
	job_options = list(PVT_VARIANT = "PVT", SR_PVT_VARIANT = "SrPVT", CPL_VARIANT = "CPL", JSGT_VARIANT = "JrSGT")

/datum/job/marine/medic/ai/upp/handle_job_options(option)
	gear_preset = initial(gear_preset)
	if(option == PVT_VARIANT)
		gear_preset = gear_preset_quaternary
	if(option == SR_PVT_VARIANT)
		gear_preset = gear_preset_tertiary
	if(option == CPL_VARIANT)
		gear_preset = gear_preset_secondary

/datum/job/marine/medic/ai/forecon
	title = JOB_SQUAD_MEDIC_FORECON
	gear_preset = /datum/equipment_preset/uscm/medic/forecon
	gear_preset_secondary = /datum/equipment_preset/uscm/medic/forecon/corporal
	gear_preset_tertiary = /datum/equipment_preset/uscm/medic/forecon/lance_corporal
	gear_preset_quaternary = /datum/equipment_preset/uscm/medic/forecon/pfc
	job_options = list(PFC_VARIANT = "PFC", LCPL_VARIANT = "LCPL", CPL_VARIANT = "CPL", SGT_VARIANT = "SGT")

/datum/job/marine/medic/ai/forecon/handle_job_options(option)
	gear_preset = initial(gear_preset)
	if(option == PFC_VARIANT)
		gear_preset = gear_preset_quaternary
	if(option == LCPL_VARIANT)
		gear_preset = gear_preset_tertiary
	if(option == CPL_VARIANT)
		gear_preset = gear_preset_secondary

/obj/effect/landmark/start/marine/medic/upp
	name = JOB_SQUAD_MEDIC_UPP
	squad = SQUAD_UPP
	job = /datum/job/marine/medic/ai/upp


/datum/job/marine/medic/ai/pmc
	title = JOB_PMCPLAT_MEDIC
	gear_preset = /datum/equipment_preset/uscm/pmc/med
	job_options = null

/obj/effect/landmark/start/marine/medic/pmc
	name = JOB_PMCPLAT_MEDIC
	squad = SQUAD_PMCPLT
	job = /datum/job/marine/medic/ai/pmc

/datum/job/marine/medic/ai/pmc/small
	title = JOB_PMCPLAT_SMALL_MEDIC
	gear_preset = /datum/equipment_preset/uscm/pmc/med
	job_options = null

/obj/effect/landmark/start/marine/medic/pmc/small
	name = JOB_PMCPLAT_SMALL_MEDIC
	squad = SQUAD_PMCPLT_SMALL
	job = /datum/job/marine/medic/ai/pmc/small

/obj/effect/landmark/start/marine/medic/forecon
	name = JOB_SQUAD_MEDIC_FORECON
	squad = SQUAD_LRRP
	job = /datum/job/marine/medic/ai/forecon

//-- RMC Platoon --//
//Medical Assistant//

/datum/job/marine/medic/ai/rmc
	title = JOB_TWE_RMC_MEDIC
	gear_preset = /datum/equipment_preset/uscm/rmc/med
	job_options = null
	supervisors = "班长与突击排指挥官"
	entry_message_body = "你是经过突击队训练的皇家海军医疗勤务部成员，随皇家陆战突击队服役。你负责治疗所辖皇家陆战队员的重伤，让他们保持健康与战斗力。虽然你的医术足以媲美医生，却往往缺乏完整的医疗设备；即便如此，关键时刻，你仍守在生与死之间。<br><b>你记得自己的个人装备和制服存放在更衣室内，医疗装备位于医务室。</b>"

/obj/effect/landmark/start/marine/medic/rmc
	name = JOB_TWE_RMC_MEDIC
	squad = SQUAD_RMC
	job = /datum/job/marine/medic/ai/rmc

#undef SGT_VARIANT
#undef JSGT_VARIANT
#undef CPL_VARIANT
#undef LCPL_VARIANT
#undef PFC_VARIANT
#undef SR_PVT_VARIANT
#undef PVT_VARIANT
