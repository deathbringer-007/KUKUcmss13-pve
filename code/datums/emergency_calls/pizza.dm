
//Terrified pizza delivery
/datum/emergency_call/pizza
	name = "Pizza Delivery"
	localized_name = "披萨外送"
	mob_max = 1
	mob_min = 1
	arrival_message = "“一共是……十六份芝士薯条、八个双配料大披萨、九瓶 Four Loko……喂？船上有人吗？你们的披萨快凉了。”"
	objectives = "务必拿到小费！"
	shuttle_id = MOBILE_SHUTTLE_ID_ERT_SMALL
	name_of_spawn = /obj/effect/landmark/ert_spawns/distress_pizza
	home_base = /datum/lazy_template/ert/pizza_station
	probability = 1

/datum/emergency_call/pizza/create_member(datum/mind/M, turf/override_spawn_loc)
	var/turf/spawn_loc = override_spawn_loc ? override_spawn_loc : get_spawn_point()

	if(!istype(spawn_loc))
		return //Didn't find a useable spawn point.

	var/mob/living/carbon/human/H = new(spawn_loc)
	M.transfer_to(H, TRUE)

	arm_equipment(H, /datum/equipment_preset/other/pizza, TRUE, TRUE)

	var/pizzatxt = pick("特惠披萨","披萨王国","老爹披萨", "银河披萨")
	to_chat(H, SPAN_ROLE_HEADER("你是一名披萨外送员！你的雇主是 [pizzatxt] 公司。"))
	to_chat(H, SPAN_ROLE_BODY("你的工作是把披萨送到。你相当肯定就是这里……"))

	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(to_chat), H, SPAN_BOLD("目标：[objectives]")), 1 SECONDS)


/datum/emergency_call/pizza/cryo
	name = "Pizza Delivery (Cryo)"
	localized_name = "披萨外送（冷冻休眠）"
	probability = 0
	name_of_spawn = /obj/effect/landmark/ert_spawns/distress_cryo
	shuttle_id = MOBILE_SHUTTLE_ID_ERT_SMALL

/obj/effect/landmark/ert_spawns/distress_pizza
	name = "Distress_Pizza"
