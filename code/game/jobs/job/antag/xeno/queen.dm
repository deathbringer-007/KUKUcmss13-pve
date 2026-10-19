/datum/job/antag/xenos/queen
	title = JOB_XENOMORPH_QUEEN
	role_ban_alternative = "Queen"
	supervisors = "Queen Mother"
	selection_class = "job_xeno_queen"
	total_positions = 1
	spawn_positions = 1

/datum/job/antag/xenos/queen/set_spawn_positions(count)
	return spawn_positions

/datum/job/antag/xenos/queen/transform_to_xeno(mob/living/carbon/human/human_to_transform, hive_index)
	SSticker.mode.pick_queen_spawn(human_to_transform, hive_index)

/datum/job/antag/xenos/queen/announce_entry_message(mob/new_queen, account, whitelist_status)
	to_chat(new_queen, "<B>你现在是异形女皇！</B>")
	to_chat(new_queen, "<B>你的使命是扩张虫巢。</B>")
	to_chat(new_queen, "<B>你应该先建造虫巢核心。</B>")
	to_chat(new_queen, "使用<strong>;</strong>通过虫巢意志交谈（例如“;你好，我的孩子们！”）。")
