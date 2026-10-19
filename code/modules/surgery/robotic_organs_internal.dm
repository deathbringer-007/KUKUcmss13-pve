/*Procedures in this file: chest + groin organ repair surgery, legacy prosthetic organ repair
and organ transplant code which may come in handy in future but haven't been edited at all.*/
//////////////////////////////////////////////////////////////////
// ORGAN SURGERIES //
//////////////////////////////////////////////////////////////////

/datum/surgery/robotic_organ_repair
	name = "机械器官修复手术"
	priority = SURGERY_PRIORITY_HIGH
	possible_locs = list("chest")
	invasiveness = list(SURGERY_DEPTH_DEEP)
	required_surgery_skill = SKILL_SURGERY_TRAINED
	steps = list(/datum/surgery_step/repair_robotic_organs)

/datum/surgery/robotic_organ_repair/can_start(mob/user, mob/living/carbon/patient, obj/limb/L, obj/item/tool)
	for(var/datum/internal_organ/IO as anything in L.internal_organs)
		if(IO.damage > 0 && IO.robotic == ORGAN_ROBOT)
			return TRUE
	return FALSE

/datum/surgery/robotic_organ_repair/groin
	possible_locs = list("groin")
	invasiveness = list(SURGERY_DEPTH_SHALLOW)

//------------------------------------

/datum/surgery_step/repair_robotic_organs
	name = "修复受损机械器官"
	desc = "修复器官损伤"
	//Tools used to fix damaged organs. Predator herbs may be herbal and organic, but are not as good for surgery.
	tools = list(
		/obj/item/stack/nanopaste = SURGERY_TOOL_MULT_IDEAL,
		/obj/item/stack/cable_coil = SURGERY_TOOL_MULT_SUBSTITUTE,
	)
	time = 3 SECONDS
	repeat_step = TRUE

/datum/surgery_step/repair_robotic_organs/repeat_step_criteria(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	for(var/datum/internal_organ/IO as anything in surgery.affected_limb.internal_organs)
		if(IO.damage > 0 && IO.robotic == ORGAN_ROBOT)
			return TRUE
	return FALSE

/datum/surgery_step/repair_robotic_organs/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	var/list/damaged_organs = list()
	var/toolname
	for(var/datum/internal_organ/IO as anything in surgery.affected_limb.internal_organs)
		if(IO.damage > 0 && IO.robotic == ORGAN_ROBOT)
			damaged_organs += IO

	switch(tool_type)
		if(/obj/item/stack/nanopaste)
			toolname = "纳米修复膏"
		if(/obj/item/stack/cable_coil)
			toolname = "电缆卷"

	if(length(damaged_organs) > 1)
		user.affected_message(target,
			SPAN_NOTICE("你开始用[toolname]修复[target]的[localized_player_label(surgery.affected_limb.display_name)]内受损的器官。"),
			SPAN_NOTICE("[user]开始用[toolname]修复你的[localized_player_label(surgery.affected_limb.display_name)]内受损的器官。"),
			SPAN_NOTICE("[user]开始用[toolname]修复[target]的[localized_player_label(surgery.affected_limb.display_name)]内受损的器官。"))
	else
		user.affected_message(target,
			SPAN_NOTICE("你开始用[toolname]修复[target]受损的[localized_player_label(damaged_organs[1].name)]。"),
			SPAN_NOTICE("[user]开始用[toolname]修复你受损的[localized_player_label(damaged_organs[1].name)]。"),
			SPAN_NOTICE("[user]开始用[toolname]修复[target]受损的[localized_player_label(damaged_organs[1].name)]。"))

	playsound(target.loc, 'sound/handling/bandage.ogg', 25, TRUE)
	log_interact(user, target, "[key_name(user)] began mending organs in [key_name(target)]'s [surgery.affected_limb.display_name], beginning [surgery].")

/datum/surgery_step/repair_robotic_organs/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	log_interact(user, target, "[key_name(user)] mended an organ in [key_name(target)]'s [surgery.affected_limb.display_name], possibly ending [surgery].")
	for(var/datum/internal_organ/I as anything in surgery.affected_limb.internal_organs)
		if(I && I.damage > 0 && I.robotic == ORGAN_ROBOT)
			user.affected_message(target,
				SPAN_NOTICE("你修好了[target]受损的[localized_player_label(I.name)]。"),
				SPAN_NOTICE("[user]修好了你受损的[localized_player_label(I.name)]。"),
				SPAN_NOTICE("[user]修好了[target]受损的[localized_player_label(I.name)]。"))

			user.count_niche_stat(STATISTICS_NICHE_SURGERY_ORGAN_REPAIR)
			I.rejuvenate()
			break

/datum/surgery_step/repair_robotic_organs/failure(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	user.affected_message(target,
		SPAN_WARNING("你手一滑，挫伤了[target]的器官，还污染了[localized_player_label(surgery.affected_limb.cavity)]！"),
		SPAN_WARNING("[user]手一滑，挫伤了你的器官，还污染了你的[localized_player_label(surgery.affected_limb.cavity)]！"),
		SPAN_WARNING("[user]手一滑，挫伤了[target]的器官，还污染了[localized_player_label(surgery.affected_limb.cavity)]！"))

	var/dam_amt = 5
	target.apply_damage(10, TOX)
	target.apply_damage(5, BRUTE, target_zone)

	for(var/datum/internal_organ/I as anything in surgery.affected_limb.internal_organs)
		if(I && I.damage > 0)
			I.take_damage(dam_amt, 0)

	log_interact(user, target, "[key_name(user)] failed to mend organs in [key_name(target)]'s [surgery.affected_limb.display_name], ending [surgery].")
	return FALSE
