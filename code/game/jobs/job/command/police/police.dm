//Military Police
/datum/job/command/police
	title = JOB_POLICE
	total_positions = 5
	spawn_positions = 5
	allow_additional = 1
	scaled = 1
	selection_class = "job_mp"
	flags_startup_parameters = ROLE_ADD_TO_DEFAULT
	gear_preset = /datum/equipment_preset/uscm_ship/uscm_police/mp
	entry_message_body = "<a href='"+WIKI_PLACEHOLDER+"'>你</a>必须遵守更高标准，除了服务器规则，还须遵守<a href='"+LAW_PLACEHOLDER+"'>陆战队军法</a>，否则可能受到职位封禁或服务器封禁。你的主要职责是维持舰上的和平与秩序。陆战队员在低温休眠数周后可能会变得躁动！此外，你还负责保护包括指挥人员在内的高级人员。务必确保他们安全！"

/datum/job/command/police/set_spawn_positions(count)
	spawn_positions = mp_slot_formula(count)

/datum/job/command/police/get_total_positions(latejoin = 0)
	var/positions = spawn_positions
	if(latejoin)
		positions = mp_slot_formula(get_total_marines())
		if(positions <= total_positions_so_far)
			positions = total_positions_so_far
		else
			total_positions_so_far = positions
	else
		total_positions_so_far = positions
	return positions

/obj/effect/landmark/start/police
	name = JOB_POLICE
	icon_state = "mp_spawn"
	job = /datum/job/command/police
