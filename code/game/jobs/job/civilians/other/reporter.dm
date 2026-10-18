#define MILITARY_VARIANT "Military Correspondent"
#define CIVILIAN_VARIANT "Civilian Correspondent"

/datum/job/civilian/reporter
	title = JOB_COMBAT_REPORTER
	total_positions = 1
	spawn_positions = 1
	selection_class = "job_cl"
	supervisors = "现任指挥官"
	gear_preset = /datum/equipment_preset/uscm_ship/reporter
	flags_startup_parameters = ROLE_ADD_TO_DEFAULT
	selection_class = "job_cl"

	job_options = list(CIVILIAN_VARIANT = "Civ", MILITARY_VARIANT = "Mil")
	/// If this job is a military variant of the reporter role
	var/military = FALSE

/datum/job/civilian/reporter/handle_job_options(option)
	if(option != CIVILIAN_VARIANT)
		gear_preset = /datum/equipment_preset/uscm_ship/reporter_uscm
		military = TRUE
	else
		gear_preset = initial(gear_preset)
		military = initial(military)

/datum/job/civilian/reporter/generate_entry_message(mob/living/carbon/human/H)
	if(military)
		. = {"USCM将你派往[MAIN_SHIP_NAME]，以便更好地宣传尼洛德星区的现状。行动起来，让全宇宙看到USCM的卓越成就！"}
	else
		. = {"大新闻！你被派往[MAIN_SHIP_NAME]，调查他们又惹上了什么麻烦，看来麻烦已经找上门了！
这可能是轰动整个星区的报道！“英勇陆战队员回应危险求救信号！”如果带回这样的新闻，办公室里的帕克森先生一定会注意到你！"}

/obj/effect/landmark/start/reporter
	name = JOB_COMBAT_REPORTER
	job = /datum/job/civilian/reporter
