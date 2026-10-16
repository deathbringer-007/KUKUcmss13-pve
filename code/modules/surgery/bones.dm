//Procedures in this file: Fracture repair surgery
//Steps will only work in a surgery of /datum/surgery/bone_repair or a child of that due to affected_bone var.
//////////////////////////////////////////////////////////////////
// BONE SURGERY //
//////////////////////////////////////////////////////////////////

/datum/surgery/bone_repair
	name = "骨折修复术"
	possible_locs = ALL_LIMBS
	invasiveness = list(SURGERY_DEPTH_SHALLOW)
	required_surgery_skill = SKILL_SURGERY_TRAINED
	pain_reduction_required = PAIN_REDUCTION_HEAVY
	steps = list(
		/datum/surgery_step/mend_bones,
		/datum/surgery_step/set_bones,
	)
	var/affected_bone //Used for messaging.

/datum/surgery/bone_repair/New(surgery_target, surgery_location, surgery_limb)
	..()
	if(affected_limb)
		switch(affected_limb.name)
			if("chest")
				affected_bone = "ribs"
			if("head")
				affected_bone = "skull"
			if("groin")
				affected_bone = "pelvis"

/datum/surgery/bone_repair/can_start(mob/user, mob/living/carbon/patient, obj/limb/L, obj/item/tool)
	return L.status & LIMB_BROKEN

//------------------------------------

/datum/surgery_step/mend_bones
	name = "修复骨折"
	desc = "修复断裂的骨骼"
	tools = SURGERY_TOOLS_BONE_MEND
	time = 3 SECONDS
	preop_sound = 'sound/handling/clothingrustle1.ogg'
	success_sound = 'sound/handling/bandage.ogg'
	failure_sound = 'sound/surgery/organ2.ogg'

//Use materials to repair bones, same as /datum/surgery_step/mend_encased
/datum/surgery_step/mend_bones/extra_checks(mob/living/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery, repeating, skipped)
	. = ..()
	if(istype(tool, /obj/item/tool/surgery/bonegel)) //If bone gel, use some of the gel
		var/obj/item/tool/surgery/bonegel/gel = tool
		if(!gel.use_gel(gel.fracture_fix_cost))
			to_chat(user, SPAN_BOLDWARNING("[gel]已经空了！"))
			return FALSE

	else //Otherwise, use metal rods
		var/obj/item/stack/rods/rods = user.get_inactive_hand()
		if(!istype(rods))
			to_chat(user, SPAN_BOLDWARNING("要用[tool]修复[target]的[surgery.affected_limb.display_name]，你需要在另一只手中拿着金属棒。"))
			return FALSE
		if(!rods.use(2)) //Refunded on failure
			to_chat(user, SPAN_BOLDWARNING("要用[tool]修复[target]的[surgery.affected_limb.display_name]，你还需要更多金属棒。"))
			return FALSE

/datum/surgery_step/mend_bones/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/bone_repair/surgery)
	if(surgery.affected_bone)
		if(tool_type == /obj/item/tool/surgery/bonegel)
			user.affected_message(target,
				SPAN_NOTICE("你开始将[tool]涂在[target]断裂的[surgery.affected_bone]上。"),
				SPAN_NOTICE("[user]开始将[tool]涂在你断裂的[surgery.affected_bone]上。"),
				SPAN_NOTICE("[user]开始将[tool]涂在[target]断裂的[surgery.affected_bone]上。"))

			target.custom_pain("你的[surgery.affected_limb.display_name]内部一阵刺痛！", 1)
		else
			user.affected_message(target,
				SPAN_NOTICE("你开始用[tool]将固定钉打入[target]的[surgery.affected_bone]。"),
				SPAN_NOTICE("[user]开始用[tool]将固定钉打入你的[surgery.affected_bone]。"),
				SPAN_NOTICE("[user]开始用[tool]将固定钉打入[target]的[surgery.affected_bone]。"))

			target.custom_pain("你感觉有什么东西在[surgery.affected_bone]里研磨！", 1)
			playsound(target.loc, 'sound/items/Screwdriver.ogg', 25, TRUE)
	else
		if(tool_type == /obj/item/tool/surgery/bonegel)
			user.affected_message(target,
				SPAN_NOTICE("你开始将[tool]涂在[target]的[surgery.affected_limb.display_name]内断裂的骨骼上。"),
				SPAN_NOTICE("[user]开始将[tool]涂在你的[surgery.affected_limb.display_name]内断裂的骨骼上。"),
				SPAN_NOTICE("[user]开始将[tool]涂在[target]的[surgery.affected_limb.display_name]内断裂的骨骼上。"))

			target.custom_pain("你的[surgery.affected_limb.display_name]内部一阵刺痛！", 1)
		else
			user.affected_message(target,
				SPAN_NOTICE("你开始用[tool]将固定钉打入[target]的[surgery.affected_limb.display_name]内断裂的骨骼。"),
				SPAN_NOTICE("[user]开始用[tool]将固定钉打入你的[surgery.affected_limb.display_name]内断裂的骨骼。"),
				SPAN_NOTICE("[user]开始用[tool]将固定钉打入[target]的[surgery.affected_limb.display_name]内断裂的骨骼。"))

			target.custom_pain("你感觉有什么东西在[surgery.affected_limb.display_name]的骨头里研磨！", 1)

	log_interact(user, target, "[key_name(user)] attempted to begin repairing bones in [key_name(target)]'s [surgery.affected_limb.display_name] with \the [tool].")

/datum/surgery_step/mend_bones/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/bone_repair/surgery)
	var/improvised_desc = pick("器官贩子", "DIY爱好者", "冷冻保存至今的20世纪巫医", "逃跑的黑猩猩")

	if(surgery.affected_bone)
		if(tool_type == /obj/item/tool/surgery/bonegel)
			user.affected_message(target,
				SPAN_NOTICE("你将[tool]厚厚地涂在[target]断裂的[surgery.affected_bone]上。"),
				SPAN_NOTICE("[user]将[tool]厚厚地涂在你断裂的[surgery.affected_bone]上。"),
				SPAN_NOTICE("[user]将[tool]厚厚地涂在[target]断裂的[surgery.affected_bone]上。"))
		else
			user.affected_message(target,
				SPAN_NOTICE("你像[improvised_desc]一样，粗糙地加固了[target]的[surgery.affected_bone]。"),
				SPAN_NOTICE("[user]像[improvised_desc]一样，粗糙地加固了你的[surgery.affected_bone]。"),
				SPAN_NOTICE("[user]像[improvised_desc]一样，粗糙地加固了[target]的[surgery.affected_bone]。"))
	else
		if(tool_type == /obj/item/tool/surgery/bonegel)
			user.affected_message(target,
				SPAN_NOTICE("你将[tool]厚厚地涂在[target]的[surgery.affected_limb.display_name]内断裂的骨骼上。"),
				SPAN_NOTICE("[user]将[tool]厚厚地涂在你的[surgery.affected_limb.display_name]内断裂的骨骼上。"),
				SPAN_NOTICE("[user]将[tool]厚厚地涂在[target]的[surgery.affected_limb.display_name]内断裂的骨骼上。"))
		else
			user.affected_message(target,
				SPAN_NOTICE("你像[improvised_desc]一样，粗糙地加固了[target]的[surgery.affected_limb.display_name]内的骨骼。"),
				SPAN_NOTICE("[user]像[improvised_desc]一样，粗糙地加固了你的[surgery.affected_limb.display_name]内的骨骼。"),
				SPAN_NOTICE("[user]像[improvised_desc]一样，粗糙地加固了[target]的[surgery.affected_limb.display_name]内的骨骼。"))

	log_interact(user, target, "[key_name(user)] successfully began repairing bones in [key_name(target)]'s [surgery.affected_limb.display_name] with \the [tool], starting [surgery].")

/datum/surgery_step/mend_bones/failure(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/bone_repair/surgery)
	if(surgery.affected_bone)
		user.affected_message(target,
			SPAN_WARNING("你手一滑，让[target]的[surgery.affected_bone]损伤得更严重了！"),
			SPAN_WARNING("[user]手一滑，让你的[surgery.affected_bone]损伤得更严重了！"),
			SPAN_WARNING("[user]手一滑，让[target]的[surgery.affected_bone]损伤得更严重了！"))
	else
		user.affected_message(target,
			SPAN_WARNING("你手一滑，让[target]的[surgery.affected_limb.display_name]内的骨骼损伤得更严重了！"),
			SPAN_WARNING("[user]手一滑，让你的[surgery.affected_limb.display_name]内的骨骼损伤得更严重了！"),
			SPAN_WARNING("[user]手一滑，让[target]的[surgery.affected_limb.display_name]内的骨骼损伤得更严重了！"))

	target.apply_damage(10, BRUTE, target_zone)
	log_interact(user, target, "[key_name(user)] failed to begin repairing bones in [key_name(target)]'s [surgery.affected_limb.display_name] with \the [tool], aborting [surgery].")

	if(tool_type != /obj/item/tool/surgery/bonegel)
		to_chat(user, SPAN_NOTICE("用于[target]的[surgery.affected_limb.display_name]上的金属棒从其[surgery.affected_limb]中松脱了。"))
		var/obj/item/stack/rods/rods = new /obj/item/stack/rods(get_turf(target))
		rods.amount = 2 //Refund 2 rods on failure
		rods.update_icon()

	return FALSE

//------------------------------------

/datum/surgery_step/set_bones
	name = "骨骼复位"
	desc = "复位骨骼"
	tools = list(
		/obj/item/tool/surgery/bonesetter = SURGERY_TOOL_MULT_IDEAL,
		/obj/item/tool/wrench = SURGERY_TOOL_MULT_SUBSTITUTE,
		/obj/item/maintenance_jack = SURGERY_TOOL_MULT_BAD_SUBSTITUTE,
	)
	time = 4 SECONDS
	preop_sound = 'sound/surgery/hemostat1.ogg'
	success_sound = 'sound/effects/bone_break6.ogg'
	failure_sound = 'sound/effects/bone_break1.ogg'

/datum/surgery_step/set_bones/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/bone_repair/surgery)
	switch(surgery.affected_limb.name) //Yet another set of different messages because I just have to be Like This.
		if("head")
			user.affected_message(target,
				SPAN_NOTICE("你开始用[tool]拼合[target]的颅骨。"),
				SPAN_NOTICE("[user]开始用[tool]拼合你的颅骨。"),
				SPAN_NOTICE("[user]开始用[tool]拼合[target]的颅骨。"))
		if("chest")
			user.affected_message(target,
				SPAN_NOTICE("你开始用[tool]为[target]断裂的肋骨复位。"),
				SPAN_NOTICE("[user]开始用[tool]为你断裂的肋骨复位。"),
				SPAN_NOTICE("[user]开始用[tool]为[target]断裂的肋骨复位。"))
		if("groin")
			user.affected_message(target,
				SPAN_NOTICE("你开始用[tool]为[target]骨折的骨盆复位。"),
				SPAN_NOTICE("[user]开始用[tool]为你骨折的骨盆复位。"),
				SPAN_NOTICE("[user]开始用[tool]为[target]骨折的骨盆复位。"))
		else
			user.affected_message(target,
				SPAN_NOTICE("你开始用[tool]为[target]的[surgery.affected_limb.display_name]内断裂的骨骼复位。"),
				SPAN_NOTICE("[user]开始用[tool]为你的[surgery.affected_limb.display_name]内断裂的骨骼复位。"),
				SPAN_NOTICE("[user]开始用[tool]为[target]的[surgery.affected_limb.display_name]内断裂的骨骼复位。"))

	target.custom_pain("你的[surgery.affected_limb.display_name]痛得快让你昏过去了！", 1)
	log_interact(user, target, "[key_name(user)] attempted to begin setting bones in [key_name(target)]'s [surgery.affected_limb.display_name] with \the [tool].")

/datum/surgery_step/set_bones/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/bone_repair/surgery)
	if(surgery.affected_bone)
		user.affected_message(target,
			SPAN_NOTICE("你为[target]的[surgery.affected_bone]完成了复位。"),
			SPAN_NOTICE("[user]为你的[surgery.affected_bone]完成了复位。"),
			SPAN_NOTICE("[user]为[target]的[surgery.affected_bone]完成了复位。"))
	else
		user.affected_message(target,
			SPAN_NOTICE("你为[target]的[surgery.affected_limb.display_name]内的骨骼完成了复位。"),
			SPAN_NOTICE("[user]为你的[surgery.affected_limb.display_name]内的骨骼完成了复位。"),
			SPAN_NOTICE("[user]为[target]的[surgery.affected_limb.display_name]内的骨骼完成了复位。"))

	user.count_niche_stat(STATISTICS_NICHE_SURGERY_BONES)
	if(surgery.affected_limb.status & LIMB_SPLINTED_INDESTRUCTIBLE)
		new /obj/item/stack/medical/splint/nano(get_turf(target), 1)
	surgery.affected_limb.status &= ~(LIMB_SPLINTED|LIMB_SPLINTED_INDESTRUCTIBLE|LIMB_BROKEN)
	surgery.affected_limb.perma_injury = 0
	target.pain.recalculate_pain()
	log_interact(user, target, "[key_name(user)] successfully set bones in [key_name(target)]'s [surgery.affected_limb.display_name] with \the [tool], ending [surgery].")

/datum/surgery_step/set_bones/failure(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/bone_repair/surgery)
	if(surgery.affected_bone)
		user.affected_message(target,
			SPAN_WARNING("你手一滑，用[tool]损伤了[target]的[surgery.affected_bone]！"),
			SPAN_WARNING("[user]手一滑，用[tool]损伤了你的[surgery.affected_bone]！"),
			SPAN_WARNING("[user]手一滑，用[tool]损伤了[target]的[surgery.affected_bone]！"))
	else
		user.affected_message(target,
			SPAN_WARNING("你手一滑，用[tool]损伤了[target]的[surgery.affected_limb.display_name]内的骨骼！"),
			SPAN_WARNING("[user]手一滑，用[tool]损伤了你的[surgery.affected_limb.display_name]内的骨骼！"),
			SPAN_WARNING("[user]手一滑，用[tool]损伤了[target]的[surgery.affected_limb.display_name]内的骨骼！"))

	target.apply_damage(10, BRUTE, target_zone)
	log_interact(user, target, "[key_name(user)] failed to set bones in [key_name(target)]'s [surgery.affected_limb.display_name] with \the [tool].")
	return FALSE
