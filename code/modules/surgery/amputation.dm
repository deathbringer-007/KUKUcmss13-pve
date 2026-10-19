//Procedures in this file: Amputations, preparing stumps for prosthetics, including stumps of robotic limbs.
//////////////////////////////////////////////////////////////////
// LIMB SURGERY //
//////////////////////////////////////////////////////////////////

//Sever a limb cleanly.
/datum/surgery/amputate
	name = "截肢手术"
	priority = SURGERY_PRIORITY_LOW
	possible_locs = EXTREMITY_LIMBS
	invasiveness = list(SURGERY_DEPTH_SHALLOW)
	required_surgery_skill = SKILL_SURGERY_TRAINED
	steps = list(
		/datum/surgery_step/cut_muscle,
		/datum/surgery_step/abort_amputation,
		/datum/surgery_step/saw_off_limb,
		/datum/surgery_step/carve_amputation,
		/datum/surgery_step/close_amputation,
	)

//Mend the stump left by a traumatic amputation. Can be performed by medics/nurses. Torn-off limbs should bleed heavily.
/datum/surgery/amputate/repair
	name = "创伤性截肢残端修复"
	priority = SURGERY_PRIORITY_HIGH
	possible_locs = EXTREMITY_LIMBS
	invasiveness = list(SURGERY_DEPTH_SURFACE)
	required_surgery_skill = SKILL_SURGERY_NOVICE
	steps = list(
		/datum/surgery_step/carve_amputation,
		/datum/surgery_step/close_ruptured_veins,
		/datum/surgery_step/close_amputation,
	)
	requires_bodypart = FALSE
	pain_reduction_required = PAIN_REDUCTION_HEAVY

/datum/surgery/amputate/repair/can_start(mob/user, mob/living/carbon/patient, obj/limb/L, obj/item/tool)
	return !(L.status & LIMB_AMPUTATED)

//Mend the stump left by a traumatic amputation of a prosthetic. Needs a doctor, prosthetics are hard.
/datum/surgery/amputate/repair/robot
	name = "移除义肢残端"
	required_surgery_skill = SKILL_SURGERY_TRAINED
	steps = list(
		/datum/surgery_step/sever_prosthetic_clamps,
		/datum/surgery_step/remove_old_prosthetic,
	)
	requires_bodypart_type = LIMB_ROBOT
	pain_reduction_required = NONE

//------------------------------------

/datum/surgery_step/cut_muscle
	name = "切断肌肉组织"
	desc = "开始截肢"
	tools = SURGERY_TOOLS_INCISION
	time = 5 SECONDS
	preop_sound = 'sound/surgery/scalpel1.ogg'
	success_sound = 'sound/surgery/scalpel2.ogg'
	failure_sound = 'sound/surgery/organ2.ogg'

/datum/surgery_step/cut_muscle/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	user.affected_message(target,
		SPAN_NOTICE("你开始用[tool]切断[target]的[localized_player_label(surgery.affected_limb.display_name)]内的肌肉。"),
		SPAN_WARNING("[user]开始切断你的[localized_player_label(surgery.affected_limb.display_name)]内的肌肉！"),
		SPAN_NOTICE("[user]开始用[tool]切断[target]的[localized_player_label(surgery.affected_limb.display_name)]内的肌肉。"))

	target.custom_pain("你的[localized_player_label(surgery.affected_limb.display_name)]正在被撕裂！", 1)

	if(tool.hitsound)
		playsound(target.loc, tool.hitsound, 25, TRUE)
	log_interact(user, target, "[key_name(user)] attempted an amputation on [key_name(target)]'s [surgery.affected_limb.display_name] with [tool ? "\the [tool]" : "their hands"].")

/datum/surgery_step/cut_muscle/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	user.affected_message(target,
		SPAN_NOTICE("你切断了[target]的[localized_player_label(surgery.affected_limb.display_name)]内的肌肉。若改变主意，此时仍能重新缝合；但一旦开始锯骨，就必须完成截肢。"),
		SPAN_WARNING("[user]切断了你的[localized_player_label(surgery.affected_limb.display_name)]内的肌肉！"),
		SPAN_NOTICE("[user]切断了[target]的[localized_player_label(surgery.affected_limb.display_name)]内的肌肉。"))

	log_interact(user, target, "[key_name(user)] successfully began an amputation on [key_name(target)]'s [surgery.affected_limb.display_name] with [tool ? "\the [tool]" : "their hands"], starting [surgery].")

/datum/surgery_step/cut_muscle/failure(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	user.affected_message(target,
		SPAN_WARNING("你的手一滑，切伤了[target]的[localized_player_label(surgery.affected_limb.display_name)]的错误部位！"),
		SPAN_WARNING("[user]的手一滑，切伤了你的[localized_player_label(surgery.affected_limb.display_name)]的错误部位！"),
		SPAN_WARNING("[user]的手一滑，切伤了[target]的[localized_player_label(surgery.affected_limb.display_name)]的错误部位！"))

	target.apply_damage(15, BRUTE, target_zone)
	log_interact(user, target, "[key_name(user)] failed to begin an amputation on [key_name(target)]'s [surgery.affected_limb.display_name] with [tool ? "\the [tool]" : "their hands"], aborting [surgery].")
	return FALSE

//------------------------------------

/datum/surgery_step/abort_amputation
	name = "重新连接肌肉组织（中止手术）"
	desc = "重新连接肌肉并中止截肢"
	tools = SURGERY_TOOLS_SUTURE
	time = 3 SECONDS
	preop_sound = 'sound/surgery/retractor1.ogg'
	success_sound = 'sound/surgery/retractor2.ogg'
	failure_sound = 'sound/surgery/hemostat1.ogg'

/datum/surgery_step/abort_amputation/skip_step_criteria(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	return TRUE //This is an abort pathway to stop people from being locked into a major and irreversible surgery. It is not yet too late for my mercy.

/datum/surgery_step/abort_amputation/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	user.affected_message(target,
		SPAN_NOTICE("你开始用[tool]重新缝合[target]的[localized_player_label(surgery.affected_limb.display_name)]内的肌肉。"),
		SPAN_NOTICE("[user]开始用[tool]重新缝合你的[localized_player_label(surgery.affected_limb.display_name)]内的肌肉。"),
		SPAN_NOTICE("[user]开始用[tool]重新缝合[target]的[localized_player_label(surgery.affected_limb.display_name)]内的肌肉。"))

	target.custom_pain("你的[localized_player_label(surgery.affected_limb.display_name)]疼得难以忍受！", 1)

	log_interact(user, target, "[key_name(user)] attempted to abort an amputation on [key_name(target)]'s [surgery.affected_limb.display_name] with \the [tool].")

/datum/surgery_step/abort_amputation/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	user.affected_message(target,
		SPAN_NOTICE("你完成了[target]的[localized_player_label(surgery.affected_limb.display_name)]内的肌肉连接。"),
		SPAN_NOTICE("[user]重新连接了你的[localized_player_label(surgery.affected_limb.display_name)]内的肌肉。"),
		SPAN_NOTICE("[user]重新连接了[target]的[localized_player_label(surgery.affected_limb.display_name)]内的肌肉。"))

	complete(target, surgery)
	log_interact(user, target, "[key_name(user)] successfully aborted an amputation on [key_name(target)]'s [surgery.affected_limb.display_name] with \the [tool], ending [surgery].")

/datum/surgery_step/abort_amputation/failure(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	user.affected_message(target,
		SPAN_WARNING("你的手一滑，用[tool]损伤了[target]的[localized_player_label(surgery.affected_limb.display_name)]！"),
		SPAN_WARNING("[user]的手一滑，用[tool]损伤了你的[localized_player_label(surgery.affected_limb.display_name)]！"),
		SPAN_WARNING("[user]的手一滑，用[tool]损伤了[target]的[localized_player_label(surgery.affected_limb.display_name)]！"))

	target.apply_damage(10, BRUTE, target_zone)
	log_interact(user, target, "[key_name(user)] failed to abort an amputation on [key_name(target)]'s [surgery.affected_limb.display_name] with \the [tool].")
	return FALSE

//------------------------------------

/datum/surgery_step/saw_off_limb
	name = "切断骨骼"
	desc = "截下肢体"
	tools = SURGERY_TOOLS_SEVER_BONE
	time = 6 SECONDS
	///Tools which cannot instantly hack off a limb when amputating. Bayonet is for sawing, butcher/hatchet are smaller substitutes for machete/fire axe.
	var/list/cannot_hack = list(
		/obj/item/tool/kitchen/knife/butcher,
		/obj/item/tool/hatchet,
		/obj/item/attachable/bayonet
		)
	preop_sound = 'sound/surgery/saw.ogg'
	success_sound = 'sound/surgery/organ1.ogg'
	failure_sound = 'sound/effects/bone_break6.ogg'

/datum/surgery_step/saw_off_limb/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	user.affected_message(target,
		SPAN_NOTICE("你开始用[tool]锯断[target]的[localized_player_label(surgery.affected_limb.display_name)]内的骨骼。"),
		SPAN_WARNING("[user]开始锯断你的[localized_player_label(surgery.affected_limb.display_name)]内的骨骼！"),
		SPAN_NOTICE("[user]开始用[tool]锯断[target]的[localized_player_label(surgery.affected_limb.display_name)]内的骨骼。"))

	target.custom_pain("你的[localized_player_label(surgery.affected_limb.display_name)]正在被砍断！", 1)

	if(tool.hitsound)
		playsound(target.loc, tool.hitsound, 25, TRUE)

	log_interact(user, target, "[key_name(user)] attempted to continue an amputation on [key_name(target)]'s [surgery.affected_limb.display_name] with \the [tool].")

/datum/surgery_step/saw_off_limb/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	user.affected_message(target,
		SPAN_NOTICE("你切断了[target]的[localized_player_label(surgery.affected_limb.display_name)]。"),
		SPAN_WARNING("[user]切断了你的[localized_player_label(surgery.affected_limb.display_name)]！"),
		SPAN_NOTICE("[user]切断了[target]的[localized_player_label(surgery.affected_limb.display_name)]。"))

	user.count_niche_stat(STATISTICS_NICHE_SURGERY_AMPUTATE)
	surgery.affected_limb.droplimb(amputation = TRUE, surgery_in_progress = TRUE)
	target.incision_depths[target_zone] = SURGERY_DEPTH_SURFACE
	log_interact(user, target, "[key_name(user)] successfully severed [key_name(target)]'s [surgery.affected_limb.display_name] with \the [tool].")

/datum/surgery_step/saw_off_limb/failure(mob/living/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)

	if(tool_type in cannot_hack) //Some tools are not cool enough to instantly hack off a limb.
		user.affected_message(target,
			SPAN_WARNING("你的手一滑，切到了[target]的[localized_player_label(surgery.affected_limb.display_name)]的错误部位！"),
			SPAN_WARNING("[user]的手一滑，切到了你的[localized_player_label(surgery.affected_limb.display_name)]的错误部位！"),
			SPAN_WARNING("[user]的手一滑，切到了[target]的[localized_player_label(surgery.affected_limb.display_name)]的错误部位！"))

		surgery.affected_limb.fracture()
		target.apply_damage(20, BRUTE, surgery.affected_limb)
		log_interact(user, target, "[key_name(user)] failed to cut [key_name(target)]'s [surgery.affected_limb.display_name] off with \the [tool].")
		return FALSE

	else
		user.affected_message(target,
			SPAN_WARNING("你砍断了[target]的[localized_player_label(surgery.affected_limb.display_name)]！"),
			SPAN_WARNING("[user]砍断了你的[localized_player_label(surgery.affected_limb.display_name)]！"),
			SPAN_WARNING("[user]砍断了[target]的[localized_player_label(surgery.affected_limb.display_name)]！"))

		user.animation_attack_on(target)
		user.count_niche_stat(STATISTICS_NICHE_SURGERY_AMPUTATE)
		surgery.affected_limb.droplimb() //This will sever the limb messily and reset incision depth. The stump cleanup surgery will have to be done to properly amputate, but doing this saved two seconds. Worth it?
		target.apply_damage(20, BRUTE, surgery.affected_limb.parent)
		log_interact(user, target, "[key_name(user)] hacked [key_name(target)]'s [surgery.affected_limb.display_name] off with \the [tool], ending [surgery].")
		return TRUE

//------------------------------------

/datum/surgery_step/carve_amputation
	name = "切除多余组织"
	desc = "切除残端的多余组织"
	tools = SURGERY_TOOLS_INCISION
	time = 3 SECONDS
	preop_sound = 'sound/surgery/scalpel1.ogg'
	success_sound = 'sound/surgery/scalpel2.ogg'
	failure_sound = 'sound/surgery/organ2.ogg'

/datum/surgery_step/carve_amputation/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	user.affected_message(target,
		SPAN_NOTICE("你开始用[tool]切除[target]的[localized_player_label(surgery.affected_limb.display_name)]残端上不规则的组织。"),
		SPAN_NOTICE("[user]开始从你残存的[localized_player_label(surgery.affected_limb.display_name)]上切下组织。"),
		SPAN_NOTICE("[user]开始用[tool]切除[target]残存的[localized_player_label(surgery.affected_limb.display_name)]上不规则的组织。"))

	target.custom_pain("[user]像切圣诞烤肉一样切割你的残端！", 1)
	log_interact(user, target, "[key_name(user)] attempted to begin cleaning up the stump of [key_name(target)]'s [surgery.affected_limb.display_name] with \the [tool].")

/datum/surgery_step/carve_amputation/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	user.affected_message(target,
		SPAN_NOTICE("你切除了[target]原本的[localized_player_label(surgery.affected_limb.display_name)]处不平整的组织。"),
		SPAN_NOTICE("[user]切除了你原本的[localized_player_label(surgery.affected_limb.display_name)]处不平整的组织。"),
		SPAN_NOTICE("[user]切除了[target]原本的[localized_player_label(surgery.affected_limb.display_name)]处不平整的组织。"))

	log_interact(user, target, "[key_name(user)] successfully began cleaning up the stump of [key_name(target)]'s [surgery.affected_limb.display_name] with \the [tool], possibly starting [surgery].")

/datum/surgery_step/carve_amputation/failure(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	user.affected_message(target,
		SPAN_WARNING("你的手一滑，切开了[target]的[localized_player_label(surgery.affected_limb.parent.display_name)]！"),
		SPAN_WARNING("[user]的手一滑，切开了你的[localized_player_label(surgery.affected_limb.parent.display_name)]！"),
		SPAN_WARNING("[user]的手一滑，切开了[target]的[localized_player_label(surgery.affected_limb.parent.display_name)]！"))

	target.apply_damage(10, BRUTE, surgery.affected_limb.parent)
	log_interact(user, target, "[key_name(user)] failed to clean up the stump of [key_name(target)]'s [surgery.affected_limb.display_name] with \the [tool], possibly aborting [surgery].")
	return FALSE

//------------------------------------

/datum/surgery_step/close_ruptured_veins
	name = "修复破裂血管"
	desc = "修复撕裂的血管"
	tools = SURGERY_TOOLS_MEND_BLOODVESSEL
	time = 4 SECONDS
	success_sound = 'sound/surgery/organ1.ogg'
	failure_sound =	'sound/surgery/organ2.ogg'

/datum/surgery_step/close_ruptured_veins/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	user.affected_message(target,
		SPAN_NOTICE("你开始用[tool]修复[target]残端中撕裂的血管。"),
		SPAN_NOTICE("[user]开始用[tool]修复你残端中撕裂的血管。"),
		SPAN_NOTICE("[user]开始用[tool]修复[target]残端中撕裂的血管。"))

	target.custom_pain("你的[localized_player_label(surgery.affected_limb.display_name)]残端传来怪异而可怕的疼痛！", 1)
	log_interact(user, target, "[key_name(user)] attempted to mend blood vessels in the stump of [key_name(target)]'s [surgery.affected_limb.display_name] with \the [tool].")

/datum/surgery_step/close_ruptured_veins/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	user.affected_message(target,
		SPAN_NOTICE("你修复了[target]残端中的血管。"),
		SPAN_NOTICE("[user]修复了你残端中的血管。"),
		SPAN_NOTICE("[user]修复了[target]残端中的血管。"))

	surgery.affected_limb.remove_all_bleeding()
	log_interact(user, target, "[key_name(user)] mended blood vessels in the stump of [key_name(target)]'s [surgery.affected_limb.display_name] with \the [tool].")

/datum/surgery_step/close_ruptured_veins/failure(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	if(tool_type == /obj/item/tool/surgery/FixOVein)
		user.affected_message(target,
			SPAN_WARNING("你的手一滑，将[tool]戳进了[target]的[localized_player_label(surgery.affected_limb.display_name)]残端！"),
			SPAN_WARNING("[user]的手一滑，将[tool]戳进了你的[localized_player_label(surgery.affected_limb.display_name)]残端！"),
			SPAN_WARNING("[user]的手一滑，将[tool]戳进了[target]的[localized_player_label(surgery.affected_limb.display_name)]残端！"))
	else
		user.affected_message(target,
			SPAN_WARNING("你的手一滑，用[tool]损伤了[target]的[localized_player_label(surgery.affected_limb.display_name)]残端！"),
			SPAN_WARNING("[user]的手一滑，用[tool]损伤了你的[localized_player_label(surgery.affected_limb.display_name)]残端！"),
			SPAN_WARNING("[user]的手一滑，用[tool]损伤了[target]的[localized_player_label(surgery.affected_limb.display_name)]残端！"))

	target.apply_damage(10, BRUTE, surgery.affected_limb.parent)
	log_interact(user, target, "[key_name(user)] failed to mend blood vessels in the stump of [key_name(target)]'s [surgery.affected_limb.display_name] with \the [tool].")
	return FALSE

//------------------------------------

/datum/surgery_step/close_amputation
	name = "封闭残端"
	desc = "缝合封闭残端"
	tools = SURGERY_TOOLS_SUTURE
	time = 3 SECONDS
	preop_sound = 'sound/surgery/retractor1.ogg'
	success_sound = 'sound/surgery/retractor2.ogg'
	failure_sound = 'sound/surgery/hemostat1.ogg'

/datum/surgery_step/close_amputation/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	user.affected_message(target,
		SPAN_NOTICE("你开始用[tool]将[target]残端的组织覆盖在骨骼上并缝合。"),
		SPAN_NOTICE("[user]开始用[tool]将你残端的组织覆盖在骨骼上并缝合。"),
		SPAN_NOTICE("[user]开始用[tool]将[target]残端的组织覆盖在骨骼上并缝合。"))

	target.custom_pain("你的[localized_player_label(surgery.affected_limb.display_name)]疼得难以忍受！", 1)
	log_interact(user, target, "[key_name(user)] attempted to close the stump of [key_name(target)]'s [surgery.affected_limb.display_name] with \the [tool].")

/datum/surgery_step/close_amputation/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	user.affected_message(target,
		SPAN_NOTICE("你完成了[target]的[localized_player_label(surgery.affected_limb.display_name)]残端修复。"),
		SPAN_NOTICE("[user]完成了你的[localized_player_label(surgery.affected_limb.display_name)]残端修复。"),
		SPAN_NOTICE("[user]完成了[target]的[localized_player_label(surgery.affected_limb.display_name)]残端修复。"))

	surgery.affected_limb.setAmputatedTree()
	target.pain.recalculate_pain()
	log_interact(user, target, "[key_name(user)] closed the stump of [key_name(target)]'s [surgery.affected_limb.display_name] with \the [tool], ending [surgery].")

/datum/surgery_step/close_amputation/failure(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	user.affected_message(target,
		SPAN_WARNING("你的手一滑，用[tool]损伤了[target]的[localized_player_label(surgery.affected_limb.display_name)]残端！"),
		SPAN_WARNING("[user]的手一滑，用[tool]损伤了你的[localized_player_label(surgery.affected_limb.display_name)]残端！"),
		SPAN_WARNING("[user]的手一滑，用[tool]损伤了[target]的[localized_player_label(surgery.affected_limb.display_name)]残端！"))

	target.apply_damage(10, BRUTE, surgery.affected_limb.parent)
	log_interact(user, target, "[key_name(user)] failed to close the stump of [key_name(target)]'s [surgery.affected_limb.display_name] with \the [tool].")
	return FALSE

//------------------------------------

/datum/surgery_step/sever_prosthetic_clamps
	name = "切断受损义肢卡箍"
	desc = "切断固定义肢残端的卡死卡箍"
	tools = SURGERY_TOOLS_SEVER_BONE
	time = 5 SECONDS
	success_sound = 'sound/surgery/saw.ogg'
	failure_sound = 'sound/surgery/organ2.ogg'

/datum/surgery_step/sever_prosthetic_clamps/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	user.affected_message(target,
		SPAN_NOTICE("你开始用[tool]小心切断固定[target]的[localized_player_label(surgery.affected_limb.display_name)]义肢残端的卡死卡箍。"),
		SPAN_NOTICE("[user]开始用[tool]小心切断固定你的[localized_player_label(surgery.affected_limb.display_name)]义肢残端的卡死卡箍。"),
		SPAN_NOTICE("[user]开始用[tool]小心切断固定[target]的[localized_player_label(surgery.affected_limb.display_name)]义肢残端的卡死卡箍。"))

	log_interact(user, target, "[key_name(user)] attempted to begin repairing the stump of [key_name(target)]'s severed prosthetic [surgery.affected_limb.display_name] with \the [tool].")

/datum/surgery_step/sever_prosthetic_clamps/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	user.affected_message(target,
		SPAN_NOTICE("你切断了最后一个卡箍。现在可以移除[target]的[localized_player_label(surgery.affected_limb.display_name)]义肢。"),
		SPAN_NOTICE("[user]切断了最后一个卡箍。现在可以移除你的[localized_player_label(surgery.affected_limb.display_name)]义肢。"),
		SPAN_NOTICE("[user]切断了最后一个卡箍。现在可以移除[target]的[localized_player_label(surgery.affected_limb.display_name)]义肢。"))

	log_interact(user, target, "[key_name(user)] successfully began repairing the stump of [key_name(target)]'s severed prosthetic [surgery.affected_limb.display_name] with \the [tool], starting [surgery].")

/datum/surgery_step/sever_prosthetic_clamps/failure(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	user.affected_message(target,
		SPAN_WARNING("你的手一滑，切伤了[target]的[localized_player_label(surgery.affected_limb.display_name)]上的血肉！"),
		SPAN_WARNING("[user]的手一滑，切伤了你的[localized_player_label(surgery.affected_limb.display_name)]上的血肉！"),
		SPAN_WARNING("[user]的手一滑，切伤了[target]的[localized_player_label(surgery.affected_limb.display_name)]上的血肉！"))

	target.apply_damage(20, BRUTE, surgery.affected_limb.parent)
	log_interact(user, target, "[key_name(user)] failed to begin repairing the stump of [key_name(target)]'s severed prosthetic [surgery.affected_limb.display_name] with \the [tool], aborting [surgery].")
	return FALSE

//------------------------------------

/datum/surgery_step/remove_old_prosthetic
	name = "移除受损义肢"
	desc = "移除受损的义肢"
	accept_hand = TRUE
	time = 3 SECONDS
	success_sound = 'sound/surgery/organ1.ogg'
	failure_sound = 'sound/surgery/organ2.ogg'

/datum/surgery_step/remove_old_prosthetic/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	user.affected_message(target,
		SPAN_NOTICE("你开始移除[target]受损的[localized_player_label(surgery.affected_limb.display_name)]义肢残骸。"),
		SPAN_NOTICE("[user]开始移除你受损的[localized_player_label(surgery.affected_limb.display_name)]义肢残骸。"),
		SPAN_NOTICE("[user]开始移除[target]的[localized_player_label(surgery.affected_limb.display_name)]义肢残骸。"))

	log_interact(user, target, "[key_name(user)] attempted to remove the last of [key_name(target)]'s severed prosthetic [surgery.affected_limb.display_name].")

/datum/surgery_step/remove_old_prosthetic/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	user.affected_message(target,
		SPAN_NOTICE("你露出了[target]的[localized_player_label(surgery.affected_limb.display_name)]残端。"),
		SPAN_NOTICE("[user]露出了你的[localized_player_label(surgery.affected_limb.display_name)]残端。"),
		SPAN_NOTICE("[user]露出了[target]的[localized_player_label(surgery.affected_limb.display_name)]残端。"))

	surgery.affected_limb.setAmputatedTree()
	target.pain.recalculate_pain()
	log_interact(user, target, "[key_name(user)] successfully removed the last of [key_name(target)]'s severed prosthetic [surgery.affected_limb.display_name], ending [surgery].")

/datum/surgery_step/remove_old_prosthetic/failure(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	user.affected_message(target,
		SPAN_WARNING("你没能抓牢[target]的义肢。"),
		SPAN_WARNING("[user]没能抓牢你的义肢。"),
		SPAN_WARNING("[user]没能抓牢[target]的义肢。"))

	log_interact(user, target, "[key_name(user)] failed to remove the last of [key_name(target)]'s severed prosthetic [surgery.affected_limb.display_name].")
	return FALSE
