/datum/surgery/mcomp_wounds
	name = "处理伤口"
	possible_locs = DEFENSE_ZONES_LIVING //all hud aiming locations are suitable for yautja to target.
	invasiveness = list(SURGERY_DEPTH_SURFACE)
	required_surgery_skill = SKILL_SURGERY_TRAINED
	var/required_trait = TRAIT_YAUTJA_TECH// Only predators can do this

	pain_reduction_required = 0
	steps = list(
		/datum/surgery_step/mstabilize_wounds,
		/datum/surgery_step/mtend_wounds,
		/datum/surgery_step/cauterize/mclamp_wound,
				)
	lying_required = FALSE
	self_operable = TRUE

/datum/surgery/mcomp_wounds/can_start(mob/living/carbon/human/user, mob/living/carbon/human/patient, obj/limb/limb, obj/item/tool)
	var/list/surgery_limbs = DEFENSE_ZONES_LIVING //Creates a list of all targetable locations
	surgery_limbs -= user.zone_selected //Removes the zone you are currently targeting

	for(var/zone in surgery_limbs) //Loops through the limbs of the patient
		if(istype(patient.active_surgeries[zone], /datum/surgery/mcomp_wounds)) //Checks if there is already a surgery of this type existing elsewhere.
			to_chat(user, SPAN_WARNING("[localized_player_label(parse_zone(zone))]上的操作尚未完成，你得先完成它！"))//gives a message to the person trying to perform the action
			return FALSE

	if(istype(user) && HAS_TRAIT(user, TRAIT_YAUTJA_TECH))
		if (patient.getBruteLoss() || patient.getFireLoss()) //Heals brute or burn
			return TRUE
		for(var/datum/internal_organ/organ in limb.internal_organs) //Heals damaged organs
			if(organ.damage && organ.robotic != ORGAN_ROBOT)
				return TRUE
	return FALSE

//For closing an open incision first.
/datum/surgery/mcomp_wounds/open
	invasiveness = list(SURGERY_DEPTH_SHALLOW)
	steps = list(
		/datum/surgery_step/mtend_wounds,
		/datum/surgery_step/cauterize/mclamp_wound,
	)
//------------------------------------

/datum/surgery_step/mstabilize_wounds
	name = "稳定伤口"
	desc = "稳定伤口"
	tools = SURGERY_TOOLS_MEDICOMP_STABILIZE_WOUND
	time = 5 SECONDS
	preop_sound = 'sound/handling/clothingrustle1.ogg'
	success_sound = 'sound/surgery/cautery2.ogg'
	failure_sound = 'sound/surgery/organ1.ogg'

/datum/surgery_step/mstabilize_wounds/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	if(user == target)
		user.visible_message(SPAN_NOTICE("[user]开始用[tool]稳定自己身上的伤口。"),
		SPAN_HELPFUL("你开始用[tool]稳定自己的伤口。"))
	else
		user.affected_message(target,
		SPAN_HELPFUL("你开始用[tool]稳定[target]身上的伤口。"),
		SPAN_HELPFUL("[user]开始用[tool]稳定你身上的伤口。"),
		SPAN_NOTICE("[user]开始用[tool]稳定[target]身上的伤口。"))

/datum/surgery_step/mstabilize_wounds/success(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	target.heal_overall_damage(40,40)

	if(isspeciesyautja(target))
		target.emote("click2")
	else
		target.emote("pain")

	if(user == target)
		user.visible_message(SPAN_NOTICE("[user]用[tool]完成了自己身上伤口的稳定处理。"),
			SPAN_HELPFUL("你用[tool]完成了自己伤口的稳定处理。"))
	else
		user.affected_message(target,
			SPAN_HELPFUL("你用[tool]完成了[target]伤口的稳定处理。"),
			SPAN_HELPFUL("[user]用[tool]完成了你伤口的稳定处理。"),
			SPAN_NOTICE("[user]用[tool]完成了[target]伤口的处理。"))

	log_interact(user, target, "[key_name(user)] stabilized some of [key_name(target)]'s wounds with [tool].")

/datum/surgery_step/mstabilize_wounds/failure(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	log_interact(user, target, "[key_name(user)] failed to stabilize [key_name(target)]'s wounds with [tool], possibly ending [surgery].")
	return FALSE

/datum/surgery_step/mtend_wounds
	name = "处理伤口"
	desc = "处理伤口"
	tools = SURGERY_TOOLS_MEDICOMP_MEND_WOUND
	time = 15 SECONDS
	preop_sound = 'sound/surgery/retractor1.ogg'
	success_sound = 'sound/surgery/retractor2.ogg'
	failure_sound = 'sound/surgery/organ2.ogg'

/datum/surgery_step/mtend_wounds/extra_checks(mob/living/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery, repeating, skipped)
	var/obj/item/tool/surgery/healing_gun/gun = tool
	if(!gun.loaded)
		to_chat(user, SPAN_WARNING("治疗枪里没有胶囊，你无法治疗自己！"))
		return FALSE
	return TRUE

/datum/surgery_step/mtend_wounds/preop(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	playsound(target,'sound/misc/heal_gun.ogg',25)

	if(user == target)
		user.visible_message(SPAN_NOTICE("[user]开始用[tool]治疗自己身上已稳定的伤口。"),
		SPAN_HELPFUL("你开始用[tool]治疗自己已稳定的伤口。"))
	else
		user.affected_message(target,
			SPAN_HELPFUL("你开始用[tool]治疗[target]身上已稳定的伤口。"),
			SPAN_HELPFUL("[user]开始用[tool]治疗你身上已稳定的伤口。"),
			SPAN_NOTICE("[user]开始用[tool]治疗[target]身上已稳定的伤口。"))

	target.custom_pain("你感觉身上正被针刺扎——因为确实如此！")
	log_interact(user, target, "[key_name(user)] began tending wounds on [key_name(target)] with [tool], starting [surgery].")

/datum/surgery_step/mtend_wounds/success(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	target.heal_overall_damage(65,65)

	for(var/datum/internal_organ/organ in target.internal_organs) //Fixes all organs
		organ.rejuvenate()

	if(isspeciesyautja(target))
		target.emote("click")
	else
		target.emote("pain")

	if(user == target)
		user.visible_message(SPAN_NOTICE("[user]用[tool]完成了自己身上已稳定伤口的治疗。"),
			SPAN_HELPFUL("你用[tool]完成了自己身上已稳定伤口的治疗。"))
	else
		user.affected_message(target,
			SPAN_HELPFUL("你用[tool]完成了[target]身上已稳定伤口的治疗。"),
			SPAN_HELPFUL("[user]用[tool]完成了你身上已稳定伤口的治疗。"),
			SPAN_NOTICE("[user]用[tool]完成了[target]身上已稳定伤口的治疗。"))

	if(!istype(tool, /obj/item/tool/surgery/healing_gun))
		return
	var/obj/item/tool/surgery/healing_gun/gun = tool
	gun.loaded = FALSE

	log_interact(user, target, "[key_name(user)] Treated some of [key_name(target)]'s wounds with [tool].")

/datum/surgery_step/mtend_wounds/failure(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	log_interact(user, target, "[key_name(user)] failed to tend [key_name(target)]'s wounds with [tool], possibly ending [surgery].")
	return FALSE

/datum/surgery_step/cauterize/mclamp_wound
	name = "夹合伤口"
	desc = "夹合伤口"
	tools = SURGERY_TOOLS_MEDICOMP_CLAMP_WOUND
	time = 10 SECONDS

/datum/surgery_step/cauterize/mclamp_wound/tool_check(mob/user, obj/item/tool, datum/surgery/surgery)
	. = ..()
	if((. in tools_lit) && !tool.heat_source)
		return FALSE

/datum/surgery_step/cauterize/mclamp_wound/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	if(user == target)
		user.visible_message(SPAN_NOTICE("[user]开始用[tool]闭合自己身上处理过的伤口。"),
			SPAN_HELPFUL("你开始用[tool]闭合自己处理过的伤口。"))
	else
		user.affected_message(target,
			SPAN_HELPFUL("你开始用[tool]闭合[target]身上处理过的伤口。"),
			SPAN_HELPFUL("[user]开始用[tool]夹合你身上处理过的伤口。"),
			SPAN_NOTICE("[user]开始用[tool]夹合[target]身上处理过的伤口。"))

/datum/surgery_step/cauterize/mclamp_wound/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	target.heal_overall_damage(65,65) //makes sure that all damage is healed

	if(user == target)
		user.visible_message(SPAN_NOTICE("[user]用[tool]完成了自己身上已处理伤口的闭合。"),
			SPAN_HELPFUL("你用[tool]完成了自己身上已处理伤口的闭合。"))
	else
		user.affected_message(target,
			SPAN_HELPFUL("你用[tool]完成了[target]身上已处理伤口的闭合。"),
			SPAN_HELPFUL("[user]用[tool]完成了你身上已处理伤口的闭合。"),
			SPAN_NOTICE("[user]用[tool]完成了[target]身上已处理伤口的闭合。"))

	if(isyautja(target))
		target.emote("loudroar")
	else
		target.emote("pain")

	target.incision_depths[target_zone] = SURGERY_DEPTH_SURFACE
	target.pain.recalculate_pain()
	log_interact(user, target, "[key_name(user)] clamped a wound in [key_name(target)]'s [surgery.affected_limb.display_name], ending [surgery].")

/datum/surgery_step/cauterize/mclamp_wound/failure(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	log_interact(user, target, "[key_name(user)] failed to tend [key_name(target)]'s wounds with [tool], possibly ending [surgery].")
	return FALSE
