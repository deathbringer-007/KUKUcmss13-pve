//Procedures in this file: Eye mending surgery
//Steps will only work in a surgery of /datum/surgery/eye_repair or a child of that due to target_eyes var.
//////////////////////////////////////////////////////////////////
// EYE SURGERY //
//////////////////////////////////////////////////////////////////

/datum/surgery/eye_repair
	name = "眼部修复手术"
	possible_locs = list("eyes")
	invasiveness = list(SURGERY_DEPTH_SURFACE)
	required_surgery_skill = SKILL_SURGERY_TRAINED
	pain_reduction_required = PAIN_REDUCTION_LIGHT //Eye doesn't have pain receptors.
	steps = list(
		/datum/surgery_step/separate_cornea,
		/datum/surgery_step/lift_eyes,
		/datum/surgery_step/mend_eyes,
		/datum/surgery_step/cauterize/eyes,
	)
	var/datum/internal_organ/eyes/target_eyes

/datum/surgery/eye_repair/New(surgery_target, surgery_location, surgery_limb)
	..()
	if(target)
		var/mob/living/carbon/human/targethuman = target
		target_eyes = targethuman.internal_organs_by_name["eyes"]

/datum/surgery/eye_repair/can_start(mob/user, mob/living/carbon/human/patient, obj/limb/L, obj/item/tool)
	var/datum/internal_organ/eyes/E = patient.internal_organs_by_name["eyes"]
	return E && E.damage > 0 && E.robotic != ORGAN_ROBOT

//------------------------------------

/datum/surgery_step/separate_cornea
	name = "分离角膜"
	desc = "分离角膜"
	tools = SURGERY_TOOLS_INCISION
	time = 2 SECONDS

/datum/surgery_step/separate_cornea/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	user.affected_message(target,
		SPAN_NOTICE("你开始用[tool]分离[target]双眼的角膜。"),
		SPAN_NOTICE("[user]开始用[tool]分离你双眼的角膜。"),
		SPAN_NOTICE("[user]开始用[tool]分离[target]双眼的角膜。"))

	log_interact(user, target, "[key_name(user)] started to separate the cornea on [key_name(target)]'s eyes with \the [tool].")

/datum/surgery_step/separate_cornea/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	user.affected_message(target,
		SPAN_NOTICE("你分离了[target]的角膜。"),
		SPAN_NOTICE("[user]分离了你的角膜。"),
		SPAN_NOTICE("[user]分离了[target]的角膜。"))

	log_interact(user, target, "[key_name(user)] separated the cornea on [key_name(target)]'s eyes with \the [tool], starting [surgery].")

	target.incision_depths[target_zone] = SURGERY_DEPTH_SHALLOW
	target.disabilities |= NEARSIGHTED // code\#define\mobs.dm

/datum/surgery_step/separate_cornea/failure(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/eye_repair/surgery)
	user.affected_message(target,
		SPAN_WARNING("你手一滑，用[tool]割伤了[target]的眼睛！"),
		SPAN_WARNING("[user]手一滑，用[tool]割伤了你的眼睛！"),
		SPAN_WARNING("[user]手一滑，用[tool]割伤了[target]的眼睛！"))

	log_interact(user, target, "[key_name(user)] failed to separate the cornea on [key_name(target)]'s eyes with \the [tool], aborting [surgery].")

	target.apply_damage(10, BRUTE, target_zone)
	surgery.target_eyes.take_damage(5, FALSE)
	return FALSE

//------------------------------------

/datum/surgery_step/lift_eyes
	name = "掀起角膜"
	desc = "掀起角膜"
	tools = SURGERY_TOOLS_PRY_DELICATE
	time = 2 SECONDS

/datum/surgery_step/lift_eyes/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	user.affected_message(target,
		SPAN_NOTICE("你开始用[tool]掀起[target]双眼的角膜。"),
		SPAN_NOTICE("[user]开始用[tool]掀起你双眼的角膜。"),
		SPAN_NOTICE("[user]开始用[tool]掀起[target]双眼的角膜。"))

	log_interact(user, target, "[key_name(user)] started to lift the cornea from [key_name(target)]'s eyes with \the [tool].")

/datum/surgery_step/lift_eyes/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	user.affected_message(target,
		SPAN_NOTICE("你掀起了[target]的角膜。"),
		SPAN_NOTICE("[user]掀起了你的角膜。"),
		SPAN_NOTICE("[user]掀起了[target]的角膜。"))

	log_interact(user, target, "[key_name(user)] lifted the cornea from [key_name(target)]'s eyes with \the [tool].")

/datum/surgery_step/lift_eyes/failure(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/eye_repair/surgery)
	user.affected_message(target,
		SPAN_WARNING("你手一滑，用[tool]弄伤了[target]的眼睛！"),
		SPAN_WARNING("[user]手一滑，用[tool]弄伤了你的眼睛！"),
		SPAN_WARNING("[user]手一滑，用[tool]弄伤了[target]的眼睛！"))

	log_interact(user, target, "[key_name(user)] failed to lift the cornea from [key_name(target)]'s eyes with \the [tool].")

	target.apply_damage(10, BRUTE, target_zone)
	surgery.target_eyes.take_damage(5, FALSE)
	return FALSE

//------------------------------------

/datum/surgery_step/mend_eyes
	name = "修复眼部神经"
	desc = "修复眼部"
	tools = SURGERY_TOOLS_PINCH
	time = 4 SECONDS

/datum/surgery_step/mend_eyes/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	user.affected_message(target,
		SPAN_NOTICE("你开始用[tool]修复[target]眼中的神经和晶状体。"),
		SPAN_NOTICE("[user]开始用[tool]修复你眼中的神经和晶状体。"),
		SPAN_NOTICE("[user]开始用[tool]修复[target]眼中的神经和晶状体。"))

	log_interact(user, target, "[key_name(user)] started to mend the nerves and lenses in [key_name(target)]'s eyes with \the [tool].")

/datum/surgery_step/mend_eyes/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	user.affected_message(target,
		SPAN_NOTICE("你修好了[target]眼中的神经和晶状体。"),
		SPAN_NOTICE("[user]修好了你眼中的神经和晶状体。"),
		SPAN_NOTICE("[user]修好了[target]眼中的神经和晶状体。"))

	log_interact(user, target, "[key_name(user)] mended the nerves and lenses in [key_name(target)]'s eyes with \the [tool].")

/datum/surgery_step/mend_eyes/failure(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/eye_repair/surgery)
	user.affected_message(target,
		SPAN_WARNING("你手一滑，用[tool]弄伤了[target]的眼睛！"),
		SPAN_WARNING("[user]手一滑，用[tool]弄伤了你的眼睛！"),
		SPAN_WARNING("[user]手一滑，用[tool]弄伤了[target]的眼睛！"))

	log_interact(user, target, "[key_name(user)] failed to mend the nerves and lenses in [key_name(target)]'s eyes with \the [tool].")

	target.apply_damage(10, BRUTE, target_zone, sharp = 1)
	surgery.target_eyes.take_damage(5, FALSE)
	return FALSE

//------------------------------------

/datum/surgery_step/cauterize/eyes
	name = "烧灼眼部切口"
	desc = "烧灼切口"
	time = 3 SECONDS

/datum/surgery_step/cauterize/eyes/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	user.affected_message(target,
		SPAN_NOTICE("你开始用[tool]重新接合[target]的角膜。"),
		SPAN_NOTICE("[user]开始用[tool]重新接合你的角膜。"),
		SPAN_NOTICE("[user]开始用[tool]重新接合[target]的角膜。"))

	log_interact(user, target, "[key_name(user)] began to cauterize the incision around [key_name(target)]'s eyes with \the [tool].")


/datum/surgery_step/cauterize/eyes/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/eye_repair/surgery)
	user.affected_message(target,
		SPAN_NOTICE("你重新接合了[target]的角膜。"),
		SPAN_NOTICE("[user]重新接合了你的角膜。"),
		SPAN_NOTICE("[user]重新接合了[target]的角膜。"))

	log_interact(user, target, "[key_name(user)] cauterized the incision around [key_name(target)]'s eyes with \the [tool], ending [surgery].")

	target.incision_depths[target_zone] = SURGERY_DEPTH_SURFACE
	target.disabilities &= ~NEARSIGHTED
	target.sdisabilities &= ~DISABILITY_BLIND
	surgery.target_eyes.heal_damage(surgery.target_eyes.damage)
	user.count_niche_stat(STATISTICS_NICHE_SURGERY_EYE)
	target.pain.recalculate_pain()

/datum/surgery_step/cauterize/eyes/failure(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/eye_repair/surgery)
	user.affected_message(target,
		SPAN_WARNING("你手一滑，用[tool]灼伤了[target]的眼睛！"),
		SPAN_WARNING("[user]手一滑，用[tool]灼伤了你的眼睛！"),
		SPAN_WARNING("[user]手一滑，用[tool]灼伤了[target]的眼睛！"))

	log_interact(user, target, "[key_name(user)] failed to cauterize the incision around [key_name(target)]'s eyes with \the [tool].")

	target.apply_damage(15, BURN, target_zone)
	surgery.target_eyes.take_damage(10, FALSE)
	return FALSE
