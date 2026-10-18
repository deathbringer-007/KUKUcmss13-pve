//Ordnance Technician
/datum/job/logistics/otech
	title = JOB_ORDNANCE_TECH
	total_positions = 3
	spawn_positions = 3
	allow_additional = 1
	scaled = 1
	supervisors = "总工程师"
	selection_class = "job_ot"
	flags_startup_parameters = ROLE_ADD_TO_DEFAULT
	gear_preset = /datum/equipment_preset/uscm_ship/ordn
	entry_message_body = "<a href='"+WIKI_PLACEHOLDER+"'>你的职责</a>是维护USCM的武器、弹药与装备，包括轨道炮。你可以使用左舷机库的工坊为陆战队制造新武器。不过，你仍是舰上职责较为灵活的人员之一，因此上级也可能安排你处理其他杂务。"

/datum/job/logistics/otech/set_spawn_positions(count)
	spawn_positions = ot_slot_formula(count)

/datum/job/logistics/otech/get_total_positions(latejoin = 0)
	var/positions = spawn_positions
	if(latejoin)
		positions = ot_slot_formula(get_total_marines())
		if(positions <= total_positions_so_far)
			positions = total_positions_so_far
		else
			total_positions_so_far = positions
	else
		total_positions_so_far = positions
	return positions

/obj/effect/landmark/start/otech
	name = JOB_ORDNANCE_TECH
	icon_state = "ot_spawn"
	job = /datum/job/logistics/otech
