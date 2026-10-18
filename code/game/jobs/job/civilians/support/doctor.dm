//job options for doctors surgeon pharmacy technician(preparation of medecine and distribution)

#define DOCTOR_VARIANT "Doctor"
#define SURGEON_VARIANT "Surgeon"

// Doctor
/datum/job/civilian/doctor
	title = JOB_DOCTOR
	total_positions = 5
	spawn_positions = 5
	allow_additional = 1
	scaled = 1
	supervisors = "首席医疗官"
	selection_class = "job_doctor"
	flags_startup_parameters = ROLE_ADD_TO_DEFAULT
	gear_preset = /datum/equipment_preset/uscm_ship/uscm_medical/doctor

	// job option
	job_options = list(DOCTOR_VARIANT = "Doc", SURGEON_VARIANT = "Sur")
	/// If this job is a doctor variant of the doctor role
	var/doctor = TRUE

//check the job option. and change the gear preset
/datum/job/civilian/doctor/handle_job_options(option)
	if(option != SURGEON_VARIANT)
		doctor = TRUE
		gear_preset = /datum/equipment_preset/uscm_ship/uscm_medical/doctor
	else
		doctor = FALSE
		gear_preset = /datum/equipment_preset/uscm_ship/uscm_medical/doctor/surgeon

//check what job option you took and generate the corresponding the good texte.
/datum/job/civilian/doctor/generate_entry_message(mob/living/carbon/human/H)
	if(doctor)
		. = {"你是USCM的一名委任军官，但不在舰船的指挥序列中。<a href='[generate_wiki_link()]'>你是一名医生，负责让陆战队员保持健康与战斗力，通常需要施行手术。</a>你精通多种医疗技能：用药、手术和药物配制。如果不清楚该怎么做，请使用导师求助功能，让导师协助你。"}
	else
		. = {"你是USCM的一名委任军官，但不在舰船的指挥序列中。<a href='[generate_wiki_link()]'>你是一名外科医生，负责让陆战队员保持健康与战斗力，通常需要施行手术。</a>你专精外科手术，同时也擅长药物配制和伤员分诊。如果不清楚该怎么做，请使用导师求助功能，让导师协助你。"}

/datum/job/civilian/doctor/set_spawn_positions(count)
	spawn_positions = doc_slot_formula(count)

/datum/job/civilian/doctor/get_total_positions(latejoin = 0)
	var/positions = spawn_positions
	if(latejoin)
		positions = doc_slot_formula(get_total_marines())
		if(positions <= total_positions_so_far)
			positions = total_positions_so_far
		else
			total_positions_so_far = positions
	else
		total_positions_so_far = positions
	return positions

/obj/effect/landmark/start/doctor
	name = JOB_DOCTOR
	icon_state = "doc_spawn"
	job = /datum/job/civilian/doctor

#undef DOCTOR_VARIANT
#undef SURGEON_VARIANT
