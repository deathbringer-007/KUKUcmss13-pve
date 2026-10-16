
//Procedures in this file: larva removal surgery
//////////////////////////////////////////////////////////////////
// LARVA SURGERY //
//////////////////////////////////////////////////////////////////

/datum/surgery/chestburster_removal
	name = "实验性异形寄生体移除术"
	priority = SURGERY_PRIORITY_MAXIMUM
	possible_locs = list("chest")
	invasiveness = list(SURGERY_DEPTH_DEEP)
	pain_reduction_required = PAIN_REDUCTION_FULL
	required_surgery_skill = SKILL_SURGERY_TRAINED
	steps = list(
		/datum/surgery_step/cut_larval_pseudoroots,
		/datum/surgery_step/remove_larva,
	)

/datum/surgery/chestburster_removal/can_start(mob/user, mob/living/carbon/patient, obj/limb/L, obj/item/tool)
	if(!locate(/obj/structure/machinery/optable) in get_turf(patient))
		return FALSE

	return locate(/obj/item/alien_embryo) in patient

//------------------------------------

/datum/surgery_step/cut_larval_pseudoroots
	name = "切断幼体假根"
	desc = "切断异形幼体的假根"
	//Similar to INCISION, but including the PICT also. Using the PICT prevents acid spray.
	tools = list(
		/obj/item/tool/surgery/scalpel = SURGERY_TOOL_MULT_IDEAL,
		/obj/item/tool/surgery/scalpel/pict_system = SURGERY_TOOL_MULT_IDEAL,
		/obj/item/attachable/bayonet = SURGERY_TOOL_MULT_SUBSTITUTE,
		/obj/item/tool/kitchen/knife = SURGERY_TOOL_MULT_SUBSTITUTE,
		/obj/item/shard = SURGERY_TOOL_MULT_AWFUL,
	)
	time = 5 SECONDS
	preop_sound = 'sound/surgery/scalpel1.ogg'
	success_sound = 'sound/surgery/scalpel2.ogg'
	failure_sound = 'sound/surgery/organ2.ogg'

/datum/surgery_step/cut_larval_pseudoroots/proc/larva_blood_spray(mob/living/carbon/human/user, mob/living/carbon/human/patient) //Mostly check_blood_splash().
	var/i = 0 //Tally up our victims.
	var/splash_chance
	for(var/mob/living/carbon/human/victim in orange(1, patient)) //Loop through all nearby victims, excepting patient.
		var/distance = get_dist(patient, victim)
		splash_chance = 80 - (i * 5)
		if(victim.loc == patient.loc) splash_chance += 30 //Same tile? BURN
		splash_chance += distance * -15
		if(victim.species && victim.species.name == "Yautja")
			splash_chance -= 70 //Preds know to avoid the splashback.
		if(splash_chance > 0 && prob(splash_chance)) //Success!
			i++
			victim.visible_message(SPAN_DANGER("[victim]被嘶嘶作响的绿色血液灼伤了！"), \
			SPAN_DANGER("滚烫的血液溅了你一身！好烫！"))
			if(prob(60) && !victim.stat && victim.pain.feels_pain)
				INVOKE_ASYNC(victim, TYPE_PROC_REF(/mob, emote), "scream") //Topkek
			victim.take_limb_damage(0, 12) //Sizzledam! This automagically burns a random existing body part.
			victim.add_blood(BLOOD_COLOR_XENO, BLOOD_BODY)
			playsound(victim, "acid_sizzle", 25, TRUE)
			animation_flash_color(victim, "#FF0000") //pain hit flicker

/datum/surgery_step/cut_larval_pseudoroots/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	user.affected_message(target,
		SPAN_NOTICE("你开始用[tool]小心地将幼体假根与[target]的重要器官分离。"),
		SPAN_NOTICE("[user]开始用[tool]小心切断连接异形幼体与你重要器官的管道。"),
		SPAN_NOTICE("[user]开始用[tool]小心切断连接异形幼体与[target]重要器官的管道。"))

	log_interact(user, target, "[key_name(user)] began cutting the roots of a larva in [key_name(target)]'s [surgery.affected_limb.display_name] with \the [tool], attempting to begin [surgery].")

/datum/surgery_step/cut_larval_pseudoroots/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	if(tool_type == /obj/item/tool/surgery/scalpel/pict_system)
		user.visible_message(SPAN_NOTICE("[user]用[tool]切断了最后的假根，没有洒出幼体的酸血。"),
			SPAN_NOTICE("你用[tool]切断了最后的假根，没有洒出幼体的酸血。"))
	else
		user.visible_message(SPAN_WARNING("[user]切断幼体管道时，受压的酸液四处喷溅！"),
			SPAN_WARNING("你切断幼体假根时，酸液喷向空中，积在[target]的[surgery.affected_limb.cavity]内，又嘶嘶作响地流过内脏！"))

		if(target.stat == CONSCIOUS)
			to_chat(target, SPAN_HIGHDANGER("你的器官正在融化！"))
			target.emote("scream")

		larva_blood_spray(user, target)
		target.apply_damage(15, BURN, target_zone)

		/*10-30 dam across 1-3 organs. This may shred one organ, but will most likely scatter a decent amount of damage across several.
		Xeno acid can melt steel beams, and y'all just spilled it in his thoracic cavity.
		You're also right there with the ribs cracked to fix it, so you can use the 3-9 seconds you spend on that to think about using the PICT next time.*/
		for(var/I in 1 to rand(2,6))
			var/datum/internal_organ/O = pick(surgery.affected_limb.internal_organs)
			O.take_damage(5, I == 1)

	log_interact(user, target, "[key_name(user)] cut the roots of a larva in [key_name(target)]'s [surgery.affected_limb.display_name] with \the [tool], starting [surgery].")

/datum/surgery_step/cut_larval_pseudoroots/failure(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	user.visible_message(SPAN_WARNING("[user]手一滑，用[tool]切到了幼体，一股酸液喷了出来！"),
		SPAN_WARNING("你手一滑，用[tool]切到了幼体，一股酸液喷了出来！"))

	if(target.stat == CONSCIOUS)
		target.emote("scream")

	larva_blood_spray(user, target)
	target.apply_damage(15, BURN, target_zone)
	log_interact(user, target, "[key_name(user)] failed to cut the roots of a larva in [key_name(target)]'s [surgery.affected_limb.display_name] with \the [tool], aborting [surgery].")
	return FALSE

//------------------------------------

/datum/surgery_step/remove_larva
	name = "取出幼体"
	desc = "取出异形幼体"
	accept_hand = TRUE
	/*Using the hands to forcefully rip out the larva will be faster at the cost of damaging both the doctor and the patient, with the addition of organ damage.
	Unlike before, the hemostat is now the best tool for removing removing the larva, as opposed to wirecutters and the fork.*/
	tools = list(
		/obj/item/tool/surgery/hemostat = 1.5 * SURGERY_TOOL_MULT_IDEAL,
		/obj/item/tool/wirecutters = 1.5 * SURGERY_TOOL_MULT_SUBOPTIMAL,
		/obj/item/tool/kitchen/utensil/fork = 1.5 * SURGERY_TOOL_MULT_SUBSTITUTE
		)
	time = 6 SECONDS
	preop_sound = 'sound/surgery/hemostat1.ogg'
	success_sound = 'sound/surgery/organ2.ogg'
	failure_sound = 'sound/effects/acid_sizzle2.ogg'

/datum/surgery_step/remove_larva/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	if(tool)
		user.affected_message(target,
			SPAN_NOTICE("你试图用[tool]从[target]胸腔中取出幼体。"),
			SPAN_NOTICE("[user]试图用[tool]从你的胸腔中取出幼体。"),
			SPAN_NOTICE("[user]试图用[tool]从[target]胸腔中取出幼体。"))
	else
		user.affected_message(target,
			SPAN_NOTICE("你试图徒手将幼体从[target]胸腔中强行扯出。"),
			SPAN_NOTICE("[user]试图将幼体从你的胸腔中强行扯出。"),
			SPAN_NOTICE("[user]试图将幼体从[target]胸腔中强行扯出。"))

	target.custom_pain("你的胸腔里一阵剧痛！",1)
	log_interact(user, target, "[key_name(user)] started to remove an embryo from [key_name(target)]'s ribcage.")

/datum/surgery_step/remove_larva/success(mob/living/carbon/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	var/obj/item/alien_embryo/A = locate() in target
	if(A)
		if(tool)
			user.affected_message(target,
				SPAN_WARNING("你从[target]胸腔中取出了一只蠕动的寄生体！"),
				SPAN_WARNING("[user]从[target]胸腔中取出了一只蠕动的寄生体！"),
				SPAN_WARNING("[user]从[target]胸腔中取出了一只蠕动的寄生体！"))
		else
			user.affected_message(target,
				SPAN_WARNING("你将蠕动的寄生体从[target]胸腔中强行扯出，酸液灼伤了你的双手和病人的内脏！"),
				SPAN_WARNING("[user]将蠕动的寄生体从你的胸腔中扯出，双手被酸液灼伤了！"),
				SPAN_WARNING("[user]将蠕动的寄生体从[target]胸腔中扯出，双手被酸液灼伤了！"))
			var/datum/internal_organ/impacted_organ = pick(surgery.affected_limb.internal_organs)
			impacted_organ.take_damage(5, FALSE)
			if(target.stat == CONSCIOUS)
				target.emote("scream")
			target.apply_damage(15, BURN, target_zone)

			play_failure_sound(user, target, target_zone, tool, surgery)
			user.emote("pain")

			if(user.hand)
				user.apply_damage(15, BURN, "l_hand")
			else
				user.apply_damage(15, BURN, "r_hand")

		user.count_niche_stat(STATISTICS_NICHE_SURGERY_LARVA)
		var/mob/living/carbon/xenomorph/larva/L = locate() in target //the larva was fully grown, ready to burst.
		if(L)
			L.forceMove(target.loc)
			qdel(A)
		else
			A.forceMove(target.loc)
			target.status_flags &= ~XENO_HOST

		log_interact(user, target, "[key_name(user)] removed an embryo from [key_name(target)]'s ribcage with [tool ? "\the [tool]" : "their hands"], ending [surgery].")

/datum/surgery_step/remove_larva/failure(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	user.affected_message(target,
		SPAN_WARNING("你手一滑，挫伤了[target]的器官，酸液洒进了[surgery.affected_limb.cavity]内！"),
		SPAN_WARNING("[user]手一滑，挫伤了你的器官，酸液洒进了你的[surgery.affected_limb.cavity]内！"),
		SPAN_WARNING("[user]手一滑，挫伤了[target]的器官，酸液洒进了[surgery.affected_limb.cavity]内！"))

	var/datum/internal_organ/I = pick(surgery.affected_limb.internal_organs)
	I.take_damage(5,0)
	if(target.stat == CONSCIOUS)
		target.emote("scream")
	target.apply_damage(15, BURN, target_zone)
	log_interact(user, target, "[key_name(user)] failed to remove an embryo from [key_name(target)]'s ribcage with [tool ? "\the [tool]" : "their hands"].")
	return FALSE
