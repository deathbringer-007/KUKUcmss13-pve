//Procedures in this file: Robotic limbs attachment
//////////////////////////////////////////////////////////////////
// ROBOLIMB SURGERY //
//////////////////////////////////////////////////////////////////

/datum/surgery/prosthetical_replacement
	name = "安装义肢"
	steps = list(
		/datum/surgery_step/connect_prosthesis,
		/datum/surgery_step/strenghten_prosthesis_connection,
		/datum/surgery_step/calibrate_prosthesis,
	)
	possible_locs = EXTREMITY_LIMBS
	invasiveness = list(SURGERY_DEPTH_SURFACE)
	required_surgery_skill = SKILL_SURGERY_NOVICE
	pain_reduction_required = PAIN_REDUCTION_LIGHT
	requires_bodypart = FALSE
	requires_bodypart_type = LIMB_AMPUTATED

//------------------------------------

/datum/surgery_step/connect_prosthesis
	name = "连接义肢"
	desc = "安装义肢"
	tools = list(/obj/item/robot_parts = SURGERY_TOOL_MULT_IDEAL)
	time = 2 SECONDS
	preop_sound = 'sound/handling/clothingrustle1.ogg'
	success_sound = 'sound/handling/clothingrustle5.ogg'
	failure_sound = 'sound/surgery/organ2.ogg'
/datum/surgery_step/connect_prosthesis/tool_check(mob/user, obj/item/robot_parts/tool, datum/surgery/surgery)
	. = ..()
	if(. && (!tool.part || !(user.zone_selected in tool.part)))
		to_chat(user, SPAN_WARNING("[tool]不能用来替代缺失的[parse_zone(user.zone_selected)]。"))
		return FALSE

/datum/surgery_step/connect_prosthesis/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/robot_parts/tool, tool_type, datum/surgery/surgery)
	user.affected_message(target,
		SPAN_NOTICE("你开始将[tool]接到[target]已经处理好的[parse_zone(target_zone)]残端上。"),
		SPAN_NOTICE("[user]开始将[tool]接到你已经处理好的[parse_zone(target_zone)]残端上。"),
		SPAN_NOTICE("[user]开始将[tool]接到[target]已经处理好的[parse_zone(target_zone)]残端上。"))

	log_interact(user, target, "[key_name(user)] attempted to begin attaching a prosthesis to [key_name(target)]'s [surgery.affected_limb.display_name].")

/datum/surgery_step/connect_prosthesis/success(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	user.affected_message(target,
		SPAN_NOTICE("你用[tool]替代了[target]缺失的[parse_zone(target_zone)]。"),
		SPAN_NOTICE("[user]用[tool]替代了你缺失的[parse_zone(target_zone)]。"),
		SPAN_NOTICE("[user]用[tool]替代了[target]缺失的[parse_zone(target_zone)]。"))

	surgery.affected_limb.robotize(surgery_in_progress = TRUE, uncalibrated = TRUE, synth_skin = issynth(target))
	target.update_body()
	target.pain.recalculate_pain()

	user.temp_drop_inv_item(tool)
	qdel(tool)
	log_interact(user, target, "[key_name(user)] successfully began attaching a prosthesis to [key_name(target)]'s [surgery.affected_limb.display_name], starting [surgery].")

/datum/surgery_step/connect_prosthesis/failure(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	user.affected_message(target,
		SPAN_WARNING("你手一滑，弄伤了[target]的残端！"),
		SPAN_WARNING("[user]手一滑，弄伤了你的残端！"),
		SPAN_WARNING("[user]手一滑，弄伤了[target]的残端！"))

	target.apply_damage(10, BRUTE, surgery.affected_limb.parent)
	log_interact(user, target, "[key_name(user)] failed to begin attaching a prosthesis to [key_name(target)]'s [surgery.affected_limb.display_name], aborting [surgery].")
	return FALSE

//------------------------------------

/datum/surgery_step/strenghten_prosthesis_connection
	name = "紧固义肢连接处"
	desc = "紧固义肢"
	accept_hand = TRUE
	time = 3 SECONDS
	tools = SURGERY_TOOLS_PINCH
	preop_sound = 'sound/surgery/hemostat1.ogg'
	success_sound = 'sound/surgery/retractor1.ogg'
	failure_sound = 'sound/surgery/organ2.ogg'

/datum/surgery_step/strenghten_prosthesis_connection/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	user.affected_message(target,
		SPAN_NOTICE("你开始紧固[target]的新义肢（[parse_zone(target_zone)]）与身体的连接处。"),
		SPAN_NOTICE("[user]开始紧固你的新义肢（[parse_zone(target_zone)]）与身体的连接处。"),
		SPAN_NOTICE("[user]开始紧固[target]的新义肢（[parse_zone(target_zone)]）与身体的连接处。"))

	log_interact(user, target, "[key_name(user)] began tightening a prosthesis to [key_name(target)]'s [surgery.affected_limb.display_name].")

/datum/surgery_step/strenghten_prosthesis_connection/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	user.affected_message(target,
		SPAN_NOTICE("你将义肢牢牢固定在[target]身上。"),
		SPAN_NOTICE("[user]将义肢牢牢固定在你身上。"),
		SPAN_NOTICE("[user]将义肢牢牢固定在[target]身上。"))

	log_interact(user, target, "[key_name(user)] finished tightening a prosthesis to [key_name(target)]'s [surgery.affected_limb.display_name].")

/datum/surgery_step/strenghten_prosthesis_connection/failure(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	user.affected_message(target,
		SPAN_WARNING("你在紧固[target]的义肢时手一滑，夹到了残端，造成剧痛！"),
		SPAN_WARNING("[user]在紧固义肢时手一滑，夹到了你的残端，造成剧痛！"),
		SPAN_WARNING("[user]在紧固[target]的义肢时手一滑，夹到了残端，造成剧痛！"))

	log_interact(user, target, "[key_name(user)] failed to tighten a prosthesis to [key_name(target)]'s [surgery.affected_limb.display_name].")
	return FALSE

//------------------------------------

/datum/surgery_step/calibrate_prosthesis
	name = "校准义肢"
	desc = "校准义肢"
	accept_hand = TRUE
	time = 2.5 SECONDS
	tools = SURGERY_TOOLS_PINCH
	preop_sound = 'sound/items/Screwdriver.ogg'
	success_sound = 'sound/handling/click_2.ogg'
	failure_sound = 'sound/items/Screwdriver2.ogg'

/datum/surgery_step/calibrate_prosthesis/preop(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	var/nerves = (target.species && (target.species.flags & IS_SYNTHETIC)) ? "控制线路" : "神经系统"
	user.affected_message(target,
		SPAN_NOTICE("你开始校准[target]的义肢，使其与[nerves]协调。"),
		SPAN_NOTICE("[user]开始校准你的义肢，使其与你的[nerves]协调。"),
		SPAN_NOTICE("[user]开始校准[target]的义肢，使其与[nerves]协调。"))

	log_interact(user, target, "[key_name(user)] began calibrating a prosthesis on [key_name(target)]'s [surgery.affected_limb.display_name].")

/datum/surgery_step/calibrate_prosthesis/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	user.affected_message(target,
		SPAN_NOTICE("你完成了[target]的义肢校准，义肢能够听从控制了。"),
		SPAN_NOTICE("[user]完成了你的义肢校准，义肢能够听从你的控制了。"),
		SPAN_NOTICE("[user]完成了[target]的义肢校准，义肢能够听从控制了。"))

	log_interact(user, target, "[key_name(user)] calibrated a prosthesis on [key_name(target)]'s [surgery.affected_limb.display_name], ending [surgery].")
	surgery.affected_limb.calibrate_prosthesis()

/datum/surgery_step/calibrate_prosthesis/failure(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	var/failure_mode
	if(target_zone in HANDLING_LIMBS) //Arm/hand
		failure_mode = pick("疯狂挥舞起来", "做出粗鲁的手势", "试图掐住主人的脖子")
	else //Leg/foot
		failure_mode = pick("疯狂乱踢起来", "以非人的姿态扭曲起来", "差点用脚趾夹碎了什么东西")

	user.affected_message(target,
		SPAN_WARNING("你在校准义肢（[parse_zone(target_zone)]）时出了差错，它[failure_mode]！"),
		SPAN_WARNING("[user]在校准义肢（[parse_zone(target_zone)]）时出了差错，它[failure_mode]！"),
		SPAN_WARNING("[user]在校准义肢（[parse_zone(target_zone)]）时出了差错，它[failure_mode]！"))

	log_interact(user, target, "[key_name(user)] failed to calibrate a prosthesis on [key_name(target)]'s [surgery.affected_limb.display_name].")
	return FALSE
