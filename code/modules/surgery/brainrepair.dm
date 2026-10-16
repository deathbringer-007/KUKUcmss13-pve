//Procedures in this file: brain damage surgery.
//////////////////////////////////////////////////////////////////
// BRAIN DAMAGE FIXING //
//////////////////////////////////////////////////////////////////

/datum/surgery/brain_repair
	name = "脑部修复手术"
	possible_locs = list("head")
	invasiveness = list(SURGERY_DEPTH_DEEP)
	required_surgery_skill = SKILL_SURGERY_TRAINED
	pain_reduction_required = PAIN_REDUCTION_MEDIUM //Brain doesn't actually have much in the way of nerve endings.
	steps = list(/datum/surgery_step/remove_bone_chips)
	var/dmg_min = 0
	var/dmg_max = BONECHIPS_MAX_DAMAGE

/datum/surgery/brain_repair/can_start(mob/user, mob/living/carbon/human/patient, obj/limb/L, obj/item/tool)
	var/datum/internal_organ/brain/B = patient.internal_organs_by_name["brain"]
	if(!B || B.damage <= dmg_min || B.robotic == ORGAN_ROBOT)
		return FALSE
	if(dmg_max && B.damage > dmg_max)
		return FALSE
	return TRUE

/datum/surgery/brain_repair/heavy //Serious brain damage requires a serious surgery.
	dmg_min = BONECHIPS_MAX_DAMAGE
	dmg_max = FALSE
	steps = list(
		/datum/surgery_step/treat_hematoma,
		/datum/surgery_step/remove_bone_chips,
	)

//------------------------------------

/datum/surgery_step/remove_bone_chips
	name = "取出嵌入的碎骨"
	desc = "取出碎骨"
	tools = SURGERY_TOOLS_PINCH
	time = 5 SECONDS

/datum/surgery_step/remove_bone_chips/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	user.affected_message(target,
		SPAN_NOTICE("你开始用[tool]取出[target]脑中的碎骨。"),
		SPAN_NOTICE("[user]开始用[tool]取出你脑中的碎骨。"),
		SPAN_NOTICE("[user]开始用[tool]取出[target]脑中的碎骨。"))

	log_interact(user, target, "[key_name(user)] started taking bone chips out of [key_name(target)]'s brain with \the [tool], possibly beginning [surgery]")

/datum/surgery_step/remove_bone_chips/success(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	user.affected_message(target,
		SPAN_NOTICE("你取出了[target]脑中的碎骨。"),
		SPAN_NOTICE("[user]取出了你脑中的碎骨。"),
		SPAN_NOTICE("[user]取出了[target]脑中的碎骨。"))

	user.count_niche_stat(STATISTICS_NICHE_SURGERY_BRAIN)

	var/datum/internal_organ/brain/B = target.internal_organs_by_name["brain"]
	if(B)
		B.heal_damage(B.damage)
	target.disabilities &= ~NERVOUS
	target.sdisabilities &= ~DISABILITY_DEAF
	target.sdisabilities &= ~DISABILITY_MUTE
	target.jitteriness = 0
	target.pain.recalculate_pain()

	log_interact(user, target, "[key_name(user)] finished taking bone chips out of [key_name(target)]'s brain with \the [tool], finishing [surgery].")

/datum/surgery_step/remove_bone_chips/failure(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	user.affected_message(target,
		SPAN_WARNING("你手一滑，用[tool]划破了[target]的[surgery.affected_limb.display_name]内的一根血管！"),
		SPAN_WARNING("[user]手一滑，用[tool]划破了你的[surgery.affected_limb.display_name]内的一根血管！"),
		SPAN_WARNING("[user]手一滑，用[tool]划破了[target]的[surgery.affected_limb.display_name]内的一根血管！"))

	log_interact(user, target, "[key_name(user)] failed to take the bone chips out of [key_name(target)]'s brain with \the [tool], possibly aborting [surgery].")

	var/datum/wound/internal_bleeding/I = new (0)
	surgery.affected_limb.add_bleeding(I, TRUE)
	surgery.affected_limb.wounds += I
	target.custom_pain("你感觉[surgery.affected_limb.display_name]里面有什么东西裂开了！", 1)
	return FALSE

//------------------------------------

/datum/surgery_step/treat_hematoma
	name = "处理血肿"
	desc = "处理血肿"
	tools = SURGERY_TOOLS_MEND_BLOODVESSEL
	time = 5 SECONDS

/datum/surgery_step/treat_hematoma/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	user.affected_message(target,
		SPAN_NOTICE("你开始用[tool]处理[target]脑中的血肿。"),
		SPAN_NOTICE("[user]开始用[tool]处理你脑中的血肿。"),
		SPAN_NOTICE("[user]开始用[tool]处理[target]脑中的血肿。"))

	log_interact(user, target, "[key_name(user)] started mending a hematoma in [key_name(target)]'s brain with \the [tool].")

/datum/surgery_step/treat_hematoma/success(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	user.affected_message(target,
		SPAN_NOTICE("你处理好了[target]脑中的血肿。"),
		SPAN_NOTICE("[user]处理好了你脑中的血肿。"),
		SPAN_NOTICE("[user]处理好了[target]脑中的血肿。"))

	log_interact(user, target, "[key_name(user)] finished mending a hematoma in [key_name(target)]'s brain with \the [tool], beginning [surgery].")

	var/datum/internal_organ/brain/B = target.internal_organs_by_name["brain"]
	if(B)
		B.damage = BONECHIPS_MAX_DAMAGE
	target.disabilities &= ~NERVOUS
	target.sdisabilities &= ~DISABILITY_DEAF
	target.sdisabilities &= ~DISABILITY_MUTE

/datum/surgery_step/treat_hematoma/failure(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	user.affected_message(target,
		SPAN_WARNING("你手一滑，用[tool]挫伤了[target]的大脑！"),
		SPAN_WARNING("[user]手一滑，用[tool]挫伤了你的大脑！"),
		SPAN_WARNING("[user]手一滑，用[tool]挫伤了[target]的大脑！"))

	log_interact(user, target, "[key_name(user)] failed to mend the hematoma in [key_name(target)]'s brain with \the [tool], aborting [surgery].")

	target.apply_damage(15, BRUTE, target_zone)
	return FALSE
