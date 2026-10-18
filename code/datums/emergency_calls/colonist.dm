

//Blank colonist ERT for admin stuff.
/datum/emergency_call/colonist
	name = "Colonists"
	localized_name = "殖民者"
	mob_max = 8
	mob_min = 1
	arrival_message = "“这里是*杂音*。我们正在*杂音*。”"
	objectives = "服从下达给你的命令。"
	probability = 0
	var/preset = /datum/equipment_preset/colonist


/datum/emergency_call/colonist/create_member(datum/mind/M, turf/override_spawn_loc) //Blank ERT with only basic items.
	set waitfor = 0
	var/turf/T = override_spawn_loc ? override_spawn_loc : get_spawn_point()

	if(!istype(T))
		return FALSE

	var/mob/living/carbon/human/H = new(T)
	M.transfer_to(H, TRUE)
	arm_equipment(H, preset, TRUE, TRUE)

	sleep(20)
	if(H && H.loc)
		to_chat(H, SPAN_ROLE_HEADER("你是一名殖民者！"))
		to_chat(H, SPAN_ROLE_BODY("工作人员已将你加入游戏。请遵循工作人员的所有指示。"))

/datum/emergency_call/colonist/engineers
	name = "Colonists - Engineers"
	localized_name = "殖民者：工程师"
	preset = /datum/equipment_preset/colonist/engineer

/datum/emergency_call/colonist/security
	name = "Colonists - Security"
	localized_name = "殖民者：安保人员"
	preset = /datum/equipment_preset/colonist/security

/datum/emergency_call/colonist/doctors
	name = "Colonists - Doctors"
	localized_name = "殖民者：医生"
	preset = /datum/equipment_preset/colonist/doctor
