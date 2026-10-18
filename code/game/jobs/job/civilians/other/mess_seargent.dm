/datum/job/civilian/chef
	title = JOB_MESS_SERGEANT
	total_positions = 2
	spawn_positions = 1
	allow_additional = TRUE
	scaled = TRUE
	selection_class = "job_ot"
	flags_startup_parameters = ROLE_ADD_TO_DEFAULT
	supervisors = "辅助支援军官"
	gear_preset = /datum/equipment_preset/uscm_ship/chef
	entry_message_body = "<a href='"+WIKI_PLACEHOLDER+"'>你的职责是为陆战队员提供美味佳肴</a>和饮品，并在需要时为舰上人员提供娱乐。你有很大的自由，可以自行决定如何发挥。祝你好运！"

/datum/job/civilian/chef/set_spawn_positions(count)
	spawn_positions = mess_sergeant_slot_formula(count)

/datum/job/civilian/chef/get_total_positions(latejoin = FALSE)
	var/positions = spawn_positions
	if(latejoin)
		positions = mess_sergeant_slot_formula(get_total_marines())
		if(positions <= total_positions_so_far)
			positions = total_positions_so_far
		else
			total_positions_so_far = positions
	else
		total_positions_so_far = positions

	return positions

/obj/effect/landmark/start/chef
	name = JOB_MESS_SERGEANT
	icon_state = "chef_spawn"
	job = /datum/job/civilian/chef
