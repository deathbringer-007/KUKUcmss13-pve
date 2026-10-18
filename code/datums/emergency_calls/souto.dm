//Best ert ever

/datum/emergency_call/souto
	name = "Souto Man"
	mob_max = 1
	mob_min = 1
	objectives = "像在1999年那样尽情狂欢！"
	probability = 0

/datum/emergency_call/souto/New()
	arrival_message = "为那位寄出一万个索托拉环、把我请来的陆战队员鼓掌吧！[MAIN_SHIP_NAME]，索托侠来和你们一起狂欢啦！"
	return ..()

/datum/emergency_call/souto/create_member(datum/mind/M, turf/override_spawn_loc)
	var/turf/spawn_loc = override_spawn_loc ? override_spawn_loc : get_spawn_point()

	if(!istype(spawn_loc))
		return //Didn't find a useable spawn point.

	var/mob/living/carbon/human/H = new(spawn_loc)
	M.transfer_to(H, TRUE)

	arm_equipment(H, /datum/equipment_preset/other/souto, TRUE, TRUE)

	to_chat(H, SPAN_ROLE_HEADER("你是索托侠！你要让更多人了解索托品牌！"))
	to_chat(H, SPAN_ROLE_BODY("你的工作是尽情狂欢、分享索托。别再让这些陆战队员口渴了！"))

	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(to_chat), H, SPAN_BOLD("目标：[objectives]")), 1 SECONDS)

/datum/emergency_call/souto/cryo
	name = "Souto Man (Cryo)"
	probability = 0
	name_of_spawn = /obj/effect/landmark/ert_spawns/distress_cryo
	shuttle_id = ""
