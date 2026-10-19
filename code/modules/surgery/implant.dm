//Procedures in this file: Putting items in body cavity. Implant removal. Embedded object removal.

//////////////////////////////////////////////////////////////////
// ITEM PLACEMENT SURGERY //
//////////////////////////////////////////////////////////////////

//Implant and removal surgeries allow either removing the implant just inserted or replacing a removed one with a new item.
/datum/surgery/implant
	name = "植入手术"
	priority = SURGERY_PRIORITY_LOW
	possible_locs = list("chest", "head")
	invasiveness = list(SURGERY_DEPTH_DEEP)
	pain_reduction_required = PAIN_REDUCTION_HEAVY
	required_surgery_skill = SKILL_SURGERY_TRAINED
	steps = list(
		/datum/surgery_step/create_cavity,
		/datum/surgery_step/place_item,
		/datum/surgery_step/cauterize/close_cavity,
	)

/datum/surgery/implant/groin
	possible_locs = list("groin")
	invasiveness = list(SURGERY_DEPTH_SHALLOW)

/datum/surgery/implant/can_start(mob/user, mob/living/carbon/patient, obj/limb/L, obj/item/tool)
	return !L.hidden

//------------------------------------

/datum/surgery/implant/removal
	name = "植入物取出手术"
	steps = list(
		/datum/surgery_step/create_cavity,
		/datum/surgery_step/remove_implant,
		/datum/surgery_step/cauterize/close_cavity,
	)

/datum/surgery/implant/removal/groin
	possible_locs = list("groin")
	invasiveness = list(SURGERY_DEPTH_SHALLOW)

/datum/surgery/implant/removal/can_start(mob/user, mob/living/carbon/patient, obj/limb/L, obj/item/tool)
	return L.hidden

//------------------------------------

/datum/surgery_step/create_cavity
	name = "开辟植入腔"
	desc = "开辟一个植入腔"
	tools = list(
		/obj/item/tool/surgery/surgicaldrill = SURGERY_TOOL_MULT_IDEAL,
		/obj/item/tool/pen = SURGERY_TOOL_MULT_SUBSTITUTE,
		/obj/item/stack/rods = SURGERY_TOOL_MULT_AWFUL,
	)
	time = 6 SECONDS

/datum/surgery_step/create_cavity/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	user.affected_message(target,
		SPAN_NOTICE("你开始用[tool]在[target]的[localized_player_label(surgery.affected_limb.cavity)]壁上开辟一个小腔隙。"),
		SPAN_NOTICE("[user]开始用[tool]在你的[localized_player_label(surgery.affected_limb.cavity)]壁上开辟一个小腔隙。"),
		SPAN_NOTICE("[user]开始用[tool]在[target]的[localized_player_label(surgery.affected_limb.cavity)]壁上开辟一个小腔隙。"))

	target.custom_pain("[user]正在你的[localized_player_label(surgery.affected_limb.display_name)]里钻孔！", 1)
	log_interact(user, target, "[key_name(user)] started to make some space in [key_name(target)]'s [surgery.affected_limb.cavity] with \the [tool].")

/datum/surgery_step/create_cavity/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	user.affected_message(target,
		SPAN_NOTICE("你在[target]的[localized_player_label(surgery.affected_limb.cavity)]内开辟了一个植入腔。"),
		SPAN_NOTICE("[user]在你的[localized_player_label(surgery.affected_limb.cavity)]内开辟了一个植入腔。"),
		SPAN_NOTICE("[user]在[target]的[localized_player_label(surgery.affected_limb.cavity)]内开辟了一个植入腔。"))

	log_interact(user, target, "[key_name(user)] made some space in [key_name(target)]'s [surgery.affected_limb.cavity] with \the [tool], beginning [surgery].")

/datum/surgery_step/create_cavity/failure(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	user.affected_message(target,
		SPAN_WARNING("你的手一滑，用[tool]擦伤了[target]的[localized_player_label(surgery.affected_limb.cavity)]内的组织！"),
		SPAN_WARNING("[user]的手一滑，用[tool]擦伤了你的[localized_player_label(surgery.affected_limb.cavity)]内的组织！"),
		SPAN_WARNING("[user]的手一滑，用[tool]擦伤了[target]的[localized_player_label(surgery.affected_limb.cavity)]内的组织！"))

	target.apply_damage(15, BRUTE, target_zone)
	log_interact(user, target, "[key_name(user)] failed to make some space in [key_name(target)]'s [surgery.affected_limb.cavity] with \the [tool], aborting [surgery].")
	return FALSE

//------------------------------------

/datum/surgery_step/place_item
	name = "放入植入物"
	desc = "植入一个物体"
	accept_any_item = TRUE //Any item except a surgery tool or substitute for such.
	time = 5 SECONDS

/datum/surgery_step/place_item/skip_step_criteria(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	return TRUE

/datum/surgery_step/place_item/proc/get_max_wclass(datum/surgery/surgery)
	switch(surgery.affected_limb.name)
		if("head")
			return SIZE_TINY
		if("chest")
			return SIZE_MEDIUM
		if("groin")
			return SIZE_SMALL

/datum/surgery_step/place_item/tool_check(mob/user, obj/item/tool, datum/surgery/surgery)
	. = ..()
	if(.)
		if(is_surgery_tool(tool)) //Make sure you still have all your tools after a surgery.
			return FALSE
		if(HAS_TRAIT(tool, TRAIT_ITEM_NOT_IMPLANTABLE))
			return FALSE
		if(tool.w_class > get_max_wclass(surgery))
			to_chat(user, SPAN_WARNING("[tool]太大，无法植入[surgery.target]的[localized_player_label(surgery.affected_limb.cavity)]！"))
			return FALSE

/datum/surgery_step/place_item/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	user.affected_message(target,
		SPAN_NOTICE("你开始将[tool]植入[target]的[localized_player_label(surgery.affected_limb.cavity)]。"),
		SPAN_NOTICE("[user]开始将[tool]植入你的[localized_player_label(surgery.affected_limb.cavity)]。"),
		SPAN_NOTICE("[user]开始将[tool]植入[target]的[localized_player_label(surgery.affected_limb.cavity)]。"))

	target.custom_pain("你的[localized_player_label(surgery.affected_limb.cavity)]传来地狱般的剧痛！", 1)
	log_interact(user, target, "[key_name(user)] started to put \the [tool] inside [key_name(target)]'s [surgery.affected_limb.cavity].")

/datum/surgery_step/place_item/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	user.affected_message(target,
		SPAN_NOTICE("你将[tool]植入了[target]的[localized_player_label(surgery.affected_limb.cavity)]。"),
		SPAN_NOTICE("[user]将[tool]植入了你的[localized_player_label(surgery.affected_limb.cavity)]。"),
		SPAN_NOTICE("[user]将[tool]植入了[target]的[localized_player_label(surgery.affected_limb.cavity)]。"))

	log_interact(user, target, "[key_name(user)] put \the [tool] inside [key_name(target)]'s [surgery.affected_limb.cavity].")

	if(tool.w_class >= SIZE_SMALL)
		to_chat(user, SPAN_WARNING("你试图把如此笨重的物体塞进腔内，撕裂了一些血管。"))
		log_interact(user, target, "[key_name(user)] damaged some blood vessels while putting \the [tool] inside [key_name(target)]'s [surgery.affected_limb.cavity].")

		var/datum/wound/internal_bleeding/I = new (0)
		surgery.affected_limb.add_bleeding(I, TRUE)
		surgery.affected_limb.wounds += I
		surgery.affected_limb.owner.custom_pain("你感觉[localized_player_label(surgery.affected_limb.display_name)]里有什么东西撕裂了！", 1)

	user.drop_inv_item_to_loc(tool, target)
	surgery.affected_limb.hidden = tool

/datum/surgery_step/place_item/failure(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	user.affected_message(target,
		SPAN_WARNING("你的手一滑，用[tool]擦伤了[target]的[localized_player_label(surgery.affected_limb.cavity)]内的组织！"),
		SPAN_WARNING("[user]的手一滑，用[tool]擦伤了你的[localized_player_label(surgery.affected_limb.cavity)]内的组织！"),
		SPAN_WARNING("[user]的手一滑，用[tool]擦伤了[target]的[localized_player_label(surgery.affected_limb.cavity)]内的组织！"))

	target.apply_damage(10, BRUTE, target_zone)
	log_interact(user, target, "[key_name(user)] failed to implant \the [tool] into [key_name(target)]'s [surgery.affected_limb.cavity].")
	return FALSE

//------------------------------------

/datum/surgery_step/remove_implant
	name = "取出内置植入物"
	desc = "取出一个植入物"
	tools = SURGERY_TOOLS_PINCH
	time = 5 SECONDS

/datum/surgery_step/remove_implant/skip_step_criteria(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	return TRUE

/datum/surgery_step/remove_implant/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	if(surgery.affected_limb.hidden) //Perhaps it self-deleted in the meantime.
		user.affected_message(target,
			SPAN_NOTICE("你试图用[tool]夹住植入[target]的[localized_player_label(surgery.affected_limb.cavity)]内的[surgery.affected_limb.hidden]。"),
			SPAN_NOTICE("[user]试图用[tool]夹住植入你的[localized_player_label(surgery.affected_limb.cavity)]内的[surgery.affected_limb.hidden]。"),
			SPAN_NOTICE("[user]试图用[tool]夹住植入[target]的[localized_player_label(surgery.affected_limb.cavity)]内的[surgery.affected_limb.hidden]。"))
	else
		user.affected_message(target,
			SPAN_NOTICE("你开始用[tool]在[target]的[localized_player_label(surgery.affected_limb.cavity)]内探查。"),
			SPAN_NOTICE("[user]开始用[tool]在你的[localized_player_label(surgery.affected_limb.cavity)]内探查。"),
			SPAN_NOTICE("[user]开始用[tool]在[target]的[localized_player_label(surgery.affected_limb.cavity)]内探查。"))

	target.custom_pain("你的[localized_player_label(surgery.affected_limb.cavity)]内不断受到夹扯，疼痛难忍！", 1)
	log_interact(user, target, "[key_name(user)] started poking around inside the incision on [key_name(target)]'s [surgery.affected_limb.display_name] with \the [tool].")

/datum/surgery_step/remove_implant/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	if(surgery.affected_limb.hidden)
		user.affected_message(target,
			SPAN_NOTICE("你从[target]的[localized_player_label(surgery.affected_limb.cavity)]内取出了[surgery.affected_limb.hidden]。"),
			SPAN_NOTICE("[user]从你的[localized_player_label(surgery.affected_limb.cavity)]内取出了[surgery.affected_limb.hidden]。"),
			SPAN_NOTICE("[user]从[target]的[localized_player_label(surgery.affected_limb.cavity)]内取出了[surgery.affected_limb.hidden]。"))

		log_interact(user, target, "[key_name(user)] removed something from [key_name(target)]'s [surgery.affected_limb.cavity] with \the [tool].")

		surgery.affected_limb.hidden.forceMove(get_turf(target))
		surgery.affected_limb.hidden.blood_color = target.get_blood_color()
		surgery.affected_limb.hidden.update_icon()
		surgery.affected_limb.hidden = null
	else
		user.affected_message(target,
			SPAN_NOTICE("你在[target]的[localized_player_label(surgery.affected_limb.cavity)]内没有找到任何东西。"),
			SPAN_NOTICE("[user]在你的[localized_player_label(surgery.affected_limb.cavity)]内没有找到任何东西。"),
			SPAN_NOTICE("[user]在[target]的[localized_player_label(surgery.affected_limb.cavity)]内没有找到任何东西。"))

		log_interact(user, target, "[key_name(user)] found nothing inside [key_name(target)]'s [surgery.affected_limb.cavity] with \the [tool].")

/datum/surgery_step/remove_implant/failure(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	user.affected_message(target,
		SPAN_WARNING("你的手一滑，用[tool]擦伤了[target]的[localized_player_label(surgery.affected_limb.cavity)]内的组织！"),
		SPAN_WARNING("[user]的手一滑，用[tool]擦伤了你的[localized_player_label(surgery.affected_limb.cavity)]内的组织！"),
		SPAN_WARNING("[user]的手一滑，用[tool]擦伤了[target]的[localized_player_label(surgery.affected_limb.cavity)]内的组织！"))

	log_interact(user, target, "[key_name(user)] damaged the inside of [key_name(target)]'s [surgery.affected_limb.display_name] with \the [tool].")

	target.apply_damage(10, BRUTE, target_zone)
	return FALSE

//------------------------------------

/datum/surgery_step/cauterize/close_cavity
	name = "烧灼封闭植入腔"
	desc = "封闭植入腔"
	time = 5 SECONDS

/datum/surgery_step/cauterize/close_cavity/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	user.affected_message(target,
		SPAN_NOTICE("你开始用[tool]封闭[target]的[localized_player_label(surgery.affected_limb.cavity)]内的植入腔。"),
		SPAN_NOTICE("[user]开始用[tool]封闭你的[localized_player_label(surgery.affected_limb.cavity)]内的植入腔。"),
		SPAN_NOTICE("[user]开始用[tool]封闭[target]的[localized_player_label(surgery.affected_limb.cavity)]内的植入腔。"))

	target.custom_pain("你的[localized_player_label(surgery.affected_limb.cavity)]像着火一样疼！", 1)
	log_interact(user, target, "[key_name(user)] started to mend [key_name(target)]'s [surgery.affected_limb.cavity] wall with \the [tool].")

/datum/surgery_step/cauterize/close_cavity/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	user.affected_message(target,
		SPAN_NOTICE("你修复了[target]的[localized_player_label(surgery.affected_limb.cavity)]壁。"),
		SPAN_NOTICE("[user]修复了你的[localized_player_label(surgery.affected_limb.cavity)]壁。"),
		SPAN_NOTICE("[user]修复了[target]的[localized_player_label(surgery.affected_limb.cavity)]壁。"))

	log_interact(user, target, "[key_name(user)] mended [key_name(target)]'s [surgery.affected_limb.cavity] wall with \the [tool], ending [surgery].")

/datum/surgery_step/cauterize/close_cavity/failure(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	user.affected_message(target,
		SPAN_WARNING("你的手一滑，用[tool]灼伤了[target]的[localized_player_label(surgery.affected_limb.cavity)]壁！"),
		SPAN_WARNING("[user]的手一滑，用[tool]灼伤了你的[localized_player_label(surgery.affected_limb.cavity)]壁！"),
		SPAN_WARNING("[user]的手一滑，用[tool]灼伤了[target]的[localized_player_label(surgery.affected_limb.cavity)]壁！"))

	log_interact(user, target, "[key_name(user)] failed to mend [key_name(target)]'s [surgery.affected_limb.cavity] wall with \the [tool].")

	target.apply_damage(10, BURN, target_zone)
	return FALSE


//////////////////////////////////////////////////////////////////
// EMBEDDED ITEM REMOVAL SURGERY //
//////////////////////////////////////////////////////////////////

/datum/surgery/embedded
	name = "嵌入物取出手术"
	priority = SURGERY_PRIORITY_LOW
	invasiveness = list(SURGERY_DEPTH_SHALLOW, SURGERY_DEPTH_DEEP)
	steps = list(/datum/surgery_step/remove_embedded)
	lying_required = FALSE
	self_operable = TRUE
	pain_reduction_required = PAIN_REDUCTION_LIGHT //This is Yank Object without the damage or IB risk.
	required_surgery_skill = SKILL_SURGERY_NOVICE

/datum/surgery/embedded/can_start(mob/user, mob/living/carbon/patient, obj/limb/L, obj/item/tool)
	return length(L.implants)

//------------------------------------

/datum/surgery_step/remove_embedded
	name = "取出异物"
	desc = "取出一个异物"
	tools = SURGERY_TOOLS_PINCH
	time = 5 SECONDS

/datum/surgery_step/remove_embedded/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	user.affected_message(target,
		SPAN_NOTICE("你开始用[tool]在[target]的[localized_player_label(surgery.affected_limb.display_name)]切口内探查。"),
		SPAN_NOTICE("[user]开始用[tool]在你的[localized_player_label(surgery.affected_limb.display_name)]切口内探查。"),
		SPAN_NOTICE("[user]开始用[tool]在[target]的[localized_player_label(surgery.affected_limb.display_name)]切口内探查。"))

	target.custom_pain("你的[localized_player_label(surgery.affected_limb.display_name)]内被不断戳探、撬动，令人难受。")
	log_interact(user, target, "[key_name(user)] started poking around inside the incision on [key_name(target)]'s [surgery.affected_limb.display_name] with \the [tool].")

/datum/surgery_step/remove_embedded/success(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	if(length(surgery.affected_limb.implants))
		var/list/shrapnel = list()
		for(var/obj/item/shard/shrap in surgery.affected_limb.implants)
			shrapnel += shrap

		if(length(shrapnel))
			user.affected_message(target,
				SPAN_NOTICE("你从[target]的[localized_player_label(surgery.affected_limb.display_name)]内取出了弹片。"),
				SPAN_NOTICE("[user]从你的[localized_player_label(surgery.affected_limb.display_name)]内取出了弹片。"),
				SPAN_NOTICE("[user]从[target]的[localized_player_label(surgery.affected_limb.display_name)]内取出了弹片。"))
			for(var/obj/item/shard/S as anything in shrapnel)
				S.forceMove(target.loc)
				surgery.affected_limb.implants -= S
				target.embedded_items -= S
				for(var/i in 1 to S.count-1)
					user.count_niche_stat(STATISTICS_NICHE_SURGERY_SHRAPNEL)
					var/shrap = new S.type(S.loc)
					QDEL_IN(shrap, 30 SECONDS)
				user.count_niche_stat(STATISTICS_NICHE_SURGERY_SHRAPNEL)
				QDEL_IN(S, 30 SECONDS)
		else
			var/obj/item/obj = surgery.affected_limb.implants[1]

			user.affected_message(target,
				SPAN_NOTICE("你从[target]的[localized_player_label(surgery.affected_limb.display_name)]内取出了[obj]。"),
				SPAN_NOTICE("[user]从你的[localized_player_label(surgery.affected_limb.display_name)]内取出了[obj]。"),
				SPAN_NOTICE("[user]从[target]的[localized_player_label(surgery.affected_limb.display_name)]内取出了[obj]。"))

			surgery.affected_limb.implants -= obj
			obj.forceMove(get_turf(target))

			if(istype(obj, /obj/item/implant))
				var/obj/item/implant/imp = obj
				imp.imp_in = null
				imp.implanted = 0

			if(is_sharp(obj))
				target.embedded_items -= obj
				user.count_niche_stat(STATISTICS_NICHE_SURGERY_SHRAPNEL)

			log_interact(user, target, "[key_name(user)] removed [obj] from [key_name(target)]'s [surgery.affected_limb.display_name] with \the [tool], ending [surgery].")
	else
		user.affected_message(target,
			SPAN_NOTICE("你在[target]的[localized_player_label(surgery.affected_limb.display_name)]内没有找到任何东西。"),
			SPAN_NOTICE("[user]在你的[localized_player_label(surgery.affected_limb.display_name)]内没有找到任何东西。"),
			SPAN_NOTICE("[user]在[target]的[localized_player_label(surgery.affected_limb.display_name)]内没有找到任何东西。"))

		log_interact(user, target, "[key_name(user)] found nothing inside [key_name(target)]'s [surgery.affected_limb.display_name] with \the [tool], ending [surgery].")

/datum/surgery_step/remove_embedded/failure(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	user.affected_message(target,
		SPAN_WARNING("你的手一滑，用[tool]擦伤了[target]的[localized_player_label(surgery.affected_limb.display_name)]内的组织！"),
		SPAN_WARNING("[user]的手一滑，用[tool]擦伤了你的[localized_player_label(surgery.affected_limb.display_name)]内的组织！"),
		SPAN_WARNING("[user]的手一滑，用[tool]擦伤了[target]的[localized_player_label(surgery.affected_limb.display_name)]内的组织！"))

	log_interact(user, target, "[key_name(user)] damaged the inside of [key_name(target)]'s [surgery.affected_limb.display_name] with \the [tool], ending [surgery].")

	target.apply_damage(10, BRUTE, target_zone)
	if(length(surgery.affected_limb.implants) && prob(10 + 100 * (tools[tool_type] - 1)))
		var/obj/item/implant/imp = surgery.affected_limb.implants[1]
		if(istype(imp))
			target.visible_message(SPAN_WARNING("[target]的[localized_player_label(surgery.affected_limb.display_name)]内有什么东西发出了哔哔声！"))
			playsound(target, 'sound/items/countdown.ogg', 25, TRUE)
			addtimer(CALLBACK(imp, TYPE_PROC_REF(/obj/item/implant, activate)), 2.5 SECONDS)
	return FALSE

/datum/surgery/implant_poison_tooth
	name = "毒牙植入手术"
	priority = SURGERY_PRIORITY_LOW
	possible_locs = list("mouth")
	invasiveness = list(SURGERY_DEPTH_SURFACE)
	pain_reduction_required = PAIN_REDUCTION_HEAVY
	required_surgery_skill = SKILL_SURGERY_NOVICE
	steps = list(
		/datum/surgery_step/remove_tooth,
		/datum/surgery_step/add_tooth,
	)
	lying_required = FALSE
	self_operable = TRUE

/datum/surgery/implant_poison_tooth/can_start(mob/user, mob/living/carbon/patient, obj/limb/L, obj/item/tool)
	return !L.hidden

/datum/surgery_step/remove_tooth
	name = "拔牙"
	desc = "拔出牙齿！"
	tools = list(
		/obj/item/tool/surgery/hemostat = SURGERY_TOOL_MULT_IDEAL,
		/obj/item/tool/wirecutters = SURGERY_TOOL_MULT_SUBSTITUTE,
	)
	time = 5 SECONDS
	success_sound = 'sound/surgery/hemostat1.ogg'

/datum/surgery_step/remove_tooth/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	user.affected_message(target,
		SPAN_NOTICE("你开始用[tool]小心地拔除[target]的牙齿。"),
		SPAN_NOTICE("[user]开始用[tool]小心地拔除你的一颗牙齿。"),
		SPAN_NOTICE("[user]开始用[tool]小心地拔除[target]的一颗牙齿。"))

	target.custom_pain("[user]正在拔掉你的一颗牙齿！", 1)
	log_interact(user, target, "[key_name(user)] started to remove a tooth with \the [tool].")

/datum/surgery_step/remove_tooth/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	user.affected_message(target,
		SPAN_NOTICE("你小心地拔除了[target]的牙齿。"),
		SPAN_NOTICE("[user]小心地拔除了你的一颗牙齿。"),
		SPAN_NOTICE("[user]小心地拔除了[target]的一颗牙齿。"))

	log_interact(user, target, "[key_name(user)] removed [target]'s tooth \the [tool], beginning [surgery].")
	new /obj/item/trash/tooth(get_turf(target))

/datum/surgery_step/remove_tooth/failure(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	user.affected_message(target,
		SPAN_WARNING("你的手一滑，用[tool]擦伤了[target]的牙龈！"),
		SPAN_WARNING("[user]的手一滑，用[tool]擦伤了你的牙龈！"),
		SPAN_WARNING("[user]的手一滑，用[tool]擦伤了[target]的牙龈！"))

	target.apply_damage(15, BRUTE, target_zone)
	log_interact(user, target, "[key_name(user)] failed to remove [target]'s tooth with \the [tool], aborting [surgery].")
	return FALSE

/datum/surgery_step/add_tooth
	name = "植牙"
	desc = "植入毒牙！"
	tools = list(/obj/item/implant/poison_tooth = SURGERY_TOOL_MULT_IDEAL)
	time = 2 SECONDS
	success_sound = 'sound/surgery/retractor2.ogg'


/datum/surgery_step/add_tooth/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	user.affected_message(target,
		SPAN_NOTICE("你开始小心地将一颗毒牙植入[target]的牙龈。"),
		SPAN_NOTICE("[user]开始小心地将一颗毒牙植入你的牙龈。"),
		SPAN_NOTICE("[user]开始小心地将一颗毒牙植入[target]的牙龈。"))

	target.custom_pain("[user]戳到了你暴露的神经！", 1)
	log_interact(user, target, "[key_name(user)] started implanting a tooth.")

/datum/surgery_step/add_tooth/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	user.affected_message(target,
		SPAN_NOTICE("你小心地将一颗毒牙植入[target]的牙龈。"),
		SPAN_NOTICE("[user]小心地将一颗毒牙植入你的牙龈。"),
		SPAN_NOTICE("[user]将一颗毒牙植入[target]的牙龈。"))

	log_interact(user, target, "[key_name(user)] inserted a poison tooth into [target]'s gum.")
	var/obj/item/implant/poison_tooth/tooth = tool
	tooth.do_implant(target, "head")
	user.drop_inv_item_to_loc(tooth, target)

/datum/surgery_step/add_tooth/failure(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	user.affected_message(target,
		SPAN_WARNING("你的手一滑，用[tool]擦伤了[target]的牙龈！"),
		SPAN_WARNING("[user]的手一滑，用[tool]擦伤了你的牙龈！"),
		SPAN_WARNING("[user]的手一滑，用[tool]擦伤了[target]的牙龈！"))

	target.apply_damage(5, BRUTE, target_zone)
	log_interact(user, target, "[key_name(user)] failed to insert a tooth into [target]'s mouth.")
	return FALSE
