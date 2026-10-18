// The Order of HEFA has arrived!
/datum/emergency_call/hefa_knight
	name = "HEFA knights"
	localized_name = "HEFA骑士团"
	mob_max = 15
	mob_min = 3
	arrival_message = "“准备向本教团献出汝等的 HEFA 手榴弹！”"
	objectives = "你是 HEFA 教团的一名兄弟！你和其他兄弟必须收集尽可能多的 HEFA 手榴弹！"
	probability = 0
	hostility = TRUE

/datum/emergency_call/hefa_knight/create_member(datum/mind/M, turf/override_spawn_loc)
	var/turf/spawn_loc = override_spawn_loc ? override_spawn_loc : get_spawn_point()

	if(!istype(spawn_loc))
		return //Didn't find a useable spawn point.

	var/mob/living/carbon/human/H = new(spawn_loc)
	M.transfer_to(H, TRUE)

	arm_equipment(H, /datum/equipment_preset/fun/hefa/melee, FALSE, TRUE)
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(to_chat), H, SPAN_BOLD("目标：[objectives]")), 1 SECONDS)
