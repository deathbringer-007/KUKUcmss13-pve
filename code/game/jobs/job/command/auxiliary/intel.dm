//Intelligence Officer
/datum/job/command/intel
	title = JOB_INTEL
	total_positions = 3
	spawn_positions = 3
	allow_additional = 1
	scaled = 1
	supervisors = "辅助支援军官"
	flags_startup_parameters = ROLE_ADD_TO_DEFAULT|ROLE_ADD_TO_SQUAD
	gear_preset = "USCM Intelligence Officer (IO) (Cryo)"
	entry_message_body = "<a href='"+WIKI_PLACEHOLDER+"'>你的职责是协助陆战队员收集与当前行动有关的情报</a>，让指挥部更了解对手。你负责收集行动区域内找到的数据磁盘、文件夹和笔记，并将其解密，为USCM争取额外资源。"

/datum/job/command/intel/set_spawn_positions(count)
	spawn_positions = int_slot_formula(count)

/datum/job/command/intel/get_total_positions(latejoin = 0)
	var/positions = spawn_positions
	if(latejoin)
		positions = int_slot_formula(get_total_marines())
		if(positions <= total_positions_so_far)
			positions = total_positions_so_far
		else
			total_positions_so_far = positions
	return positions

/obj/effect/landmark/start/intel
	name = JOB_INTEL
	icon_state = "io_spawn"
	job = /datum/job/command/intel
