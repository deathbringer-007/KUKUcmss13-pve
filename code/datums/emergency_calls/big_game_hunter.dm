
//A big-game hunter, willing to hunt anything that moves.
/datum/emergency_call/van_bandolier
	name = "Fun - Big Game Hunter (solo)"
	mob_max = 1
	mob_min = 1
	probability = 0
	objectives = "收集一些上好的战利品。猎物越危险越好！"
	hostility = TRUE

/datum/emergency_call/van_bandolier/New()
	. = ..()
	arrival_message = "“收到你们的求救了，[MAIN_SHIP_NAME]。最好是能挂在我墙上撑场面的猎物，对吧？出猎啦！”"

/datum/emergency_call/van_bandolier/create_member(datum/mind/M, turf/override_spawn_loc)
	var/turf/spawn_loc = override_spawn_loc ? override_spawn_loc : get_spawn_point()

	if(!istype(spawn_loc))
		return //Didn't find a useable spawn point.

	var/mob/living/carbon/human/H = new(spawn_loc)
	M.transfer_to(H, TRUE)

	arm_equipment(H, /datum/equipment_preset/fun/van_bandolier, FALSE, TRUE)

	to_chat(H, SPAN_ROLE_HEADER("你是一名大型猎物猎人！"))
	to_chat(H, SPAN_ROLE_BODY("地上的走兽、天上的飞禽，以及一切爬行之物，你都曾开枪猎取。寻常野兽\
	如今已让你厌倦（那场误会之后，你或许还惹上了几桩小小的偷猎指控），于是你来到这个偏远星区，寻找最危险的\
	猎物。你听说这里有凶残的异形、动辄开枪的士兵，还有嗜血的外星猎人（听起来他们倒很懂狩猎，\
	完全不像那些可怕的大角星人！），可惜你至今猎到的都只是些小角色。\n\n你可以雇当地人来当\
	脚夫、驱猎员和向导，也可以为了消遣把他们当成猎物——全由你决定。他们要是识相，就会带你找到出色的猎物。\n\n"))
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(to_chat), H, SPAN_BOLD("目标：[objectives]")), 1 SECONDS)
