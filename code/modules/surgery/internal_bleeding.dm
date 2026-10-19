//////////////////////////////////////////////////////////////////
// INTERNAL WOUND PATCHING //
//////////////////////////////////////////////////////////////////

/datum/surgery/internal_bleeding
	name = "内出血修复"
	priority = SURGERY_PRIORITY_HIGH
	possible_locs = ALL_LIMBS
	invasiveness = list(SURGERY_DEPTH_SHALLOW, SURGERY_DEPTH_DEEP)
	required_surgery_skill = SKILL_SURGERY_NOVICE
	pain_reduction_required = PAIN_REDUCTION_HEAVY
	steps = list(/datum/surgery_step/fix_vein)

/datum/surgery/internal_bleeding/can_start(mob/user, mob/living/carbon/patient, obj/limb/L, obj/item/tool)
	for(var/datum/wound/W as anything in L.wounds)
		if(W.internal)
			return TRUE
	return FALSE

//------------------------------------

/datum/surgery_step/fix_vein
	name = "修复静脉"
	desc = "修复受损血管"
	tools = SURGERY_TOOLS_MEND_BLOODVESSEL
	time = 7.5 SECONDS
	preop_sound = 'sound/surgery/hemostat1.ogg'
	success_sound = 'sound/surgery/organ1.ogg'
	failure_sound = 'sound/surgery/organ2.ogg'

/datum/surgery_step/fix_vein/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	user.affected_message(target,
		SPAN_NOTICE("你开始用[tool]修补[target]的[localized_player_label(surgery.affected_limb.display_name)]内受损的静脉。"),
		SPAN_NOTICE("[user]开始用[tool]修补你的[localized_player_label(surgery.affected_limb.display_name)]内受损的静脉。"),
		SPAN_NOTICE("[user]开始用[tool]修补[target]的[localized_player_label(surgery.affected_limb.display_name)]内受损的静脉。"))

	target.custom_pain("你的[localized_player_label(surgery.affected_limb.display_name)]痛得难以忍受！", 1)
	log_interact(user, target, "[key_name(user)] began repairing internal bleeding in [key_name(target)]'s [surgery.affected_limb.display_name], beginning [surgery].")

/datum/surgery_step/fix_vein/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	user.count_niche_stat(STATISTICS_NICHE_SURGERY_IB)
	user.life_ib_total++

	user.affected_message(target,
		SPAN_NOTICE("你修好了[target]受损的静脉。"),
		SPAN_NOTICE("[user]修好了你受损的静脉。"),
		SPAN_NOTICE("[user]修好了[target]受损的静脉。"))

	for(var/datum/wound/W as anything in surgery.affected_limb.wounds)
		if(W.internal)
			surgery.affected_limb.wounds -= W
			surgery.affected_limb.remove_all_bleeding(FALSE, TRUE)
			surgery.affected_limb.update_damages()

	if(prob(40))
		user.add_blood(target.get_blood_color(), BLOOD_HANDS)
	target.pain.recalculate_pain()
	log_interact(user, target, "[key_name(user)] successfully repaired internal bleeding in [key_name(target)]'s [surgery.affected_limb.display_name], ending [surgery].")

/datum/surgery_step/fix_vein/failure(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	if(tool_type == /obj/item/tool/surgery/FixOVein)
		user.affected_message(target,
			SPAN_WARNING("你手一滑，将[tool]涂抹在了[target]的[localized_player_label(surgery.affected_limb.display_name)]内！"),
			SPAN_WARNING("[user]手一滑，将[tool]涂抹在了你的[localized_player_label(surgery.affected_limb.display_name)]内！"),
			SPAN_WARNING("[user]手一滑，将[tool]涂抹在了[target]的[localized_player_label(surgery.affected_limb.display_name)]内！"))
	else
		user.affected_message(target,
			SPAN_WARNING("你手一滑，用[tool]弄伤了[target]的[localized_player_label(surgery.affected_limb.display_name)]上的切口！"),
			SPAN_WARNING("[user]手一滑，用[tool]弄伤了你的[localized_player_label(surgery.affected_limb.display_name)]上的切口！"),
			SPAN_WARNING("[user]手一滑，用[tool]弄伤了[target]的[localized_player_label(surgery.affected_limb.display_name)]上的切口！"))

	user.add_blood(target.get_blood_color(), BLOOD_HANDS)
	target.apply_damage(10, BRUTE, target_zone)
	log_interact(user, target, "[key_name(user)] failed to repair internal bleeding in [key_name(target)]'s [surgery.affected_limb.display_name], ending [surgery].")
	return FALSE
