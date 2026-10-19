//Procedures in this file: Robotic limbs recalibration
//////////////////////////////////////////////////////////////////
// ROBOLIMB REPAIR //
//////////////////////////////////////////////////////////////////

/datum/surgery/prosthetic_recalibration
	name = "重新校准义肢"
	steps = list(/datum/surgery_step/recalibrate_prosthesis)
	possible_locs = EXTREMITY_LIMBS
	invasiveness = list(SURGERY_DEPTH_SURFACE)
	required_surgery_skill = SKILL_SURGERY_NOVICE
	pain_reduction_required = NONE
	requires_bodypart = TRUE
	requires_bodypart_type = LIMB_ROBOT
	lying_required = FALSE

/datum/surgery/prosthetic_recalibration/can_start(mob/user, mob/living/carbon/patient, obj/limb/L, obj/item/tool)
	if(L.status & LIMB_UNCALIBRATED_PROSTHETIC)
		return TRUE
	return FALSE

//------------------------------------

/datum/surgery_step/recalibrate_prosthesis
	name = "重新校准义肢"
	desc = "重新校准义肢"
	accept_hand = TRUE
	time = 2.5 SECONDS
	tools = SURGERY_TOOLS_PINCH
	preop_sound = 'sound/items/Screwdriver.ogg'
	success_sound = 'sound/handling/click_2.ogg'
	failure_sound = 'sound/items/Screwdriver2.ogg'

/datum/surgery_step/recalibrate_prosthesis/preop(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	var/nerves = (target.species && (target.species.flags & IS_SYNTHETIC)) ? "控制线路" : "神经系统"
	user.affected_message(target,
		SPAN_NOTICE("你开始重新校准[target]的义肢，使其与[nerves]协调。"),
		SPAN_NOTICE("[user]开始重新校准你的义肢，使其与你的[nerves]协调。"),
		SPAN_NOTICE("[user]开始重新校准[target]的义肢，使其与[nerves]协调。"))

	log_interact(user, target, "[key_name(user)] began recalibrating a prosthesis on [key_name(target)]'s [surgery.affected_limb.display_name].")

/datum/surgery_step/recalibrate_prosthesis/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	user.affected_message(target,
		SPAN_NOTICE("你完成了[target]的义肢校准，义肢再次能够听从控制了。"),
		SPAN_NOTICE("[user]完成了你的义肢校准，义肢再次能够听从你的控制了。"),
		SPAN_NOTICE("[user]完成了[target]的义肢校准，义肢再次能够听从控制了。"))

	log_interact(user, target, "[key_name(user)] recalibrated a prosthesis on [key_name(target)]'s [surgery.affected_limb.display_name], ending [surgery].")
	if(surgery.affected_limb.parent.status & LIMB_UNCALIBRATED_PROSTHETIC)
		surgery.affected_limb.parent.calibrate_prosthesis()
	else
		surgery.affected_limb.calibrate_prosthesis()

/datum/surgery_step/recalibrate_prosthesis/failure(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	var/failure_mode
	if(target_zone in HANDLING_LIMBS) //Arm/hand
		failure_mode = pick("疯狂挥舞起来", "做出粗鲁的手势", "试图掐住主人的脖子")
	else //Leg/foot
		failure_mode = pick("疯狂乱踢起来", "以非人的姿态扭曲起来", "差点用脚趾夹碎了什么东西")

	user.affected_message(target,
		SPAN_WARNING("你在重新校准义肢（[localized_player_label(parse_zone(target_zone))]）时出了差错，它[failure_mode]！"),
		SPAN_WARNING("[user]在重新校准义肢（[localized_player_label(parse_zone(target_zone))]）时出了差错，它[failure_mode]！"),
		SPAN_WARNING("[user]在重新校准义肢（[localized_player_label(parse_zone(target_zone))]）时出了差错，它[failure_mode]！"))

	log_interact(user, target, "[key_name(user)] failed to recalibrate a prosthesis on [key_name(target)]'s [surgery.affected_limb.display_name].")
	return FALSE

//------------------------------------
