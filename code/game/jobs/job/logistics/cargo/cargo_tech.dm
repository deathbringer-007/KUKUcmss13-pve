/datum/job/logistics/cargo
	title = JOB_CARGO_TECH
	total_positions = 2
	spawn_positions = 2
	allow_additional = 1
	scaled = 1
	supervisors = "补给军官"
	selection_class = "job_ct"
	flags_startup_parameters = ROLE_ADD_TO_DEFAULT
	gear_preset = /datum/equipment_preset/uscm_ship/cargo
	entry_message_body = "<a href='"+WIKI_PLACEHOLDER+"'>你的职责</a>是向陆战队员发放补给，包括武器配件。请尽量留在自己的部门，确保陆战队员能随时领取所需物资。注意监听无线电，可能有人通过战场监控系统请求补给空投。"

/datum/job/logistics/cargo/set_spawn_positions(count)
	spawn_positions = ct_slot_formula(count)

/datum/job/logistics/cargo/get_total_positions(latejoin = 0)
	var/positions = spawn_positions
	if(latejoin)
		positions = ct_slot_formula(get_total_marines())
		if(positions <= total_positions_so_far)
			positions = total_positions_so_far
		else
			total_positions_so_far = positions
	else
		total_positions_so_far = positions
	return positions

/obj/effect/landmark/start/cargo
	name = JOB_CARGO_TECH
	icon_state = "ct_spawn"
	job = /datum/job/logistics/cargo

/datum/job/logistics/chief
	title = JOB_CARGO_CHIEF
	gear_preset = /datum/equipment_preset/uscm_ship/qm/lesser_rank

/datum/job/logistics/armorer
	title = JOB_ARMORER
	gear_preset = /datum/equipment_preset/uscm_ship/armorer
