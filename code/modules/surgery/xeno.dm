//Research stuff to extract stuff from xenomorphs for goodies. In other words, to extract useful material that could be used to upgrade marines etc.

/datum/surgery/xenomorph
	name = "实验性器官采集术"
	invasiveness = list(SURGERY_DEPTH_SURFACE)
	required_surgery_skill = SKILL_SURGERY_TRAINED
	possible_locs = list("head")
	target_mobtypes = list(/mob/living/carbon/xenomorph)
	steps = list(
		/datum/surgery_step/xenomorph/cut_exoskeleton,
		/datum/surgery_step/xenomorph/open_exoskeleton,
		/datum/surgery_step/xenomorph/severe_connections,
		/datum/surgery_step/xenomorph/remove_organ,
	)
	lying_required = FALSE
	requires_bodypart_type = NONE
	requires_bodypart = FALSE

/datum/surgery/xenomorph/can_start(mob/user, mob/living/carbon/xenomorph/patient, obj/limb/L, obj/item/tool)
	if(islarva(patient) || isfacehugger(patient))
		to_chat(user, SPAN_DANGER("这个种类的体型可能太小，没有值得提取的成熟器官……"))
		return FALSE
	if((patient.tier > 2 || isqueen(patient)) && !istype(tool, /obj/item/tool/surgery/scalpel/laser/advanced))
		to_chat(user, SPAN_DANGER("这种几丁质对普通工具而言太厚了，你需要特殊工具。"))
		return FALSE
	if(patient.stat == DEAD && !patient.organ_removed)
		return TRUE
	return FALSE

/datum/surgery_step/xenomorph/cut_exoskeleton
	name = "切开外骨骼甲壳"
	desc = "切开甲壳"
	tools = list(
		/obj/item/tool/surgery/scalpel/laser/advanced = SURGERY_TOOL_MULT_IDEAL,
		/obj/item/tool/surgery/circular_saw = SURGERY_TOOL_MULT_IDEAL,
		/obj/item/weapon/twohanded/fireaxe = SURGERY_TOOL_MULT_SUBOPTIMAL,
		/obj/item/weapon/sword/machete = SURGERY_TOOL_MULT_SUBOPTIMAL,
		/obj/item/tool/hatchet = SURGERY_TOOL_MULT_SUBSTITUTE,
		/obj/item/tool/kitchen/knife/butcher = SURGERY_TOOL_MULT_SUBSTITUTE,
		/obj/item/attachable/bayonet = SURGERY_TOOL_MULT_BAD_SUBSTITUTE,
	)

	time = 4 SECONDS
	preop_sound = 'sound/handling/clothingrustle1.ogg'
	success_sound = 'sound/handling/bandage.ogg'
	failure_sound = 'sound/surgery/organ2.ogg'

/datum/surgery_step/xenomorph/cut_exoskeleton/preop(mob/living/carbon/human/user, mob/living/carbon/xenomorph/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	if(tool_type == /obj/item/tool/surgery/circular_saw || tool_type == /obj/item/tool/surgery/scalpel/laser/advanced)
		user.affected_message(target,
			SPAN_NOTICE("你开始用[tool]小心切开[localized_player_label(target.caste_type)]的甲壳，尽量避免酸液泄漏。"),
			SPAN_NOTICE("[user]开始用[tool]小心切开你的甲壳，尽量避免酸液泄漏。"),
			SPAN_NOTICE("[user]开始用[tool]小心切开[localized_player_label(target.caste_type)]的甲壳，尽量避免酸液泄漏。"))
	else
		user.affected_message(target,
			SPAN_NOTICE("你开始用[tool]鲁莽地[pick("砸碎", "敲裂", "打破")][localized_player_label(target.caste_type)]的甲壳，酸液溅到了你身上！"),
			SPAN_NOTICE("[user]开始用[tool]鲁莽地[pick("砸碎", "敲裂", "打破")]你的甲壳，酸液四处飞溅！"),
			SPAN_NOTICE("[user]开始用[tool]鲁莽地[pick("砸碎", "敲裂", "打破")][localized_player_label(target.caste_type)]的甲壳，酸液四处飞溅！"))
		//we dont really need log interact since we're working with dead body... I hope

/datum/surgery_step/xenomorph/cut_exoskeleton/success(mob/living/carbon/human/user, mob/living/carbon/xenomorph/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	if(tool_type == /obj/item/tool/surgery/circular_saw)
		user.affected_message(target,
			SPAN_NOTICE("你用[tool]成功切开了[localized_player_label(target.caste_type)]的甲壳。"),
			SPAN_NOTICE("[user]用[tool]成功切开了你的甲壳。"),
			SPAN_NOTICE("[user]用[tool]成功切开了[localized_player_label(target.caste_type)]的甲壳。"))
	else
		user.affected_message(target,
			SPAN_NOTICE("你用[tool]成功将[localized_player_label(target.caste_type)]的甲壳打成了碎片。"),
			SPAN_NOTICE("[user]用[tool]成功将你的甲壳打成了碎片。"),,
			SPAN_NOTICE("[user]用[tool]成功将[localized_player_label(target.caste_type)]的甲壳打成了碎片。"))
	for(var/mob/living/carbon/human/victim in orange(1, target))
		if(istype(victim.wear_suit, /obj/item/clothing/suit/bio_suit) && istype(victim.head, /obj/item/clothing/head/bio_hood))
			continue
		to_chat(victim, SPAN_HIGHDANGER("酸液覆盖了你全身，带来难以忍受的剧痛！"))
		victim.apply_damage(rand(75, 125), BURN) // you WILL wear biosuit.
		playsound(victim, "acid_sizzle", 25, TRUE)
		animation_flash_color(victim, "#FF0000")

/datum/surgery_step/xenomorph/cut_exoskeleton/failure(mob/living/carbon/human/user, mob/living/carbon/xenomorph/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	user.affected_message(target,
		SPAN_WARNING("你手一滑，未能用[tool]切开[localized_player_label(target.caste_type)]的甲壳！"),
		SPAN_WARNING("[user]手一滑，未能用[tool]切开你的甲壳！"),
		SPAN_WARNING("[user]手一滑，未能用[tool]切开[localized_player_label(target.caste_type)]的甲壳！"))
	return FALSE

/datum/surgery_step/xenomorph/open_exoskeleton
	name = "撬开外骨骼"
	desc = "从切口处撬开外骨骼"
	tools = SURGERY_TOOLS_PRY_ENCASED
	time = 2 SECONDS
	preop_sound = 'sound/surgery/retractor1.ogg'
	success_sound = 'sound/surgery/retractor2.ogg'
	failure_sound = 'sound/surgery/organ1.ogg'

/datum/surgery_step/xenomorph/open_exoskeleton/preop(mob/living/carbon/human/user, mob/living/carbon/xenomorph/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
			user.affected_message(target,
				SPAN_NOTICE("你开始用[tool]撬开[localized_player_label(target.caste_type)]的甲壳。"),
				SPAN_NOTICE("[user]开始用[tool]十分小心地撬开你的甲壳。"),
				SPAN_NOTICE("[user]开始用[tool]十分小心地撬开[localized_player_label(target.caste_type)]的甲壳。"))

/datum/surgery_step/xenomorph/open_exoskeleton/success(mob/living/carbon/human/user, mob/living/carbon/xenomorph/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	if(tool_type == /obj/item/tool/surgery/retractor)
		user.affected_message(target,
			SPAN_NOTICE("你用[tool]撑开[localized_player_label(target.caste_type)]的甲壳与外骨骼，暴露出[localized_player_label(target.caste_type)]的重要器官。"),
			SPAN_NOTICE("[user]用[tool]撑开你的甲壳与外骨骼，暴露出[localized_player_label(target.caste_type)]的重要器官。"),
			SPAN_NOTICE("[user]用[tool]撑开[localized_player_label(target.caste_type)]的甲壳与外骨骼，暴露出[localized_player_label(target.caste_type)]的重要器官。"))
	else
		user.affected_message(target,
			SPAN_NOTICE("你像中世纪医生一样用[tool]撑开[localized_player_label(target.caste_type)]的甲壳，暴露出[localized_player_label(target.caste_type)]的重要器官。"),
			SPAN_NOTICE("[user]开始用[tool]十分小心地打开你的甲壳。"),
			SPAN_NOTICE("[user]开始用[tool]十分小心地打开[localized_player_label(target.caste_type)]的甲壳。"))

/datum/surgery_step/xenomorph/open_exoskeleton/failure(mob/living/carbon/human/user, mob/living/carbon/xenomorph/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	user.affected_message(target,
		SPAN_WARNING("你手一滑，松开了[localized_player_label(target.caste_type)]的甲壳与外骨骼，它们猛地合拢，酸液四处飞溅！"),
		SPAN_WARNING("[user]手一滑，松开了[localized_player_label(target.caste_type)]的甲壳与外骨骼，它们猛地合拢，酸液四处飞溅！"),
		SPAN_WARNING("[user]手一滑，松开了[localized_player_label(target.caste_type)]的甲壳与外骨骼，它们猛地合拢，酸液四处飞溅！"))
	for(var/mob/living/carbon/human/victim in orange(1, target))
		if(istype(victim.wear_suit, /obj/item/clothing/suit/bio_suit) && istype(victim.head, /obj/item/clothing/head/bio_hood))
			continue
		to_chat(victim, SPAN_DANGER("从[localized_player_label(target.caste_type)]体内涌出的血液溅了你一身。"))
		victim.apply_damage(rand(50, 75), BURN) // still dangerous
		playsound(victim, "acid_sizzle", 25, TRUE)
		animation_flash_color(victim, "#FF0000")
	return FALSE

/datum/surgery_step/xenomorph/severe_connections
	name = "切断器官连接"
	desc = "断开器官的管道与连接组织"
	tools = list(
		/obj/item/tool/surgery/scalpel = SURGERY_TOOL_MULT_IDEAL,
		/obj/item/tool/surgery/scalpel/pict_system = SURGERY_TOOL_MULT_IDEAL,
		/obj/item/attachable/bayonet = SURGERY_TOOL_MULT_SUBSTITUTE,
		/obj/item/tool/kitchen/knife = SURGERY_TOOL_MULT_SUBSTITUTE,
		/obj/item/shard = SURGERY_TOOL_MULT_AWFUL,
	)
	time = 4 SECONDS
	preop_sound = 'sound/surgery/scalpel1.ogg'
	success_sound = 'sound/surgery/scalpel2.ogg'
	failure_sound = 'sound/surgery/organ2.ogg'

/datum/surgery_step/xenomorph/severe_connections/preop(mob/living/carbon/human/user, mob/living/carbon/xenomorph/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	user.affected_message(target,
		SPAN_NOTICE("你开始用[tool]熟练地切断[localized_player_label(target.caste_type)]的器官连接。"),
		SPAN_NOTICE("[user]开始用[tool]熟练地切断你的器官连接。"),
		SPAN_NOTICE("[user]开始用[tool]熟练地切断[localized_player_label(target.caste_type)]的器官连接。"))

/datum/surgery_step/xenomorph/severe_connections/success(mob/living/carbon/human/user, mob/living/carbon/xenomorph/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	if(tool_type == /obj/item/tool/surgery/scalpel || tool_type == /obj/item/tool/surgery/scalpel/pict_system)
		user.affected_message(target,
			SPAN_NOTICE("你用[tool]切断了[localized_player_label(target.caste_type)]与重要器官相连的连接组织。"),
			SPAN_NOTICE("[user]用[tool]切断了你与重要器官相连的连接组织。"),
			SPAN_NOTICE("[user]用[tool]切断了[localized_player_label(target.caste_type)]与重要器官相连的连接组织。"))
	else
		user.affected_message(target,
			SPAN_NOTICE("你用[tool]扯断了[localized_player_label(target.caste_type)]与重要器官相连的连接组织。"),
			SPAN_NOTICE("[user]用[tool]扯断了你与重要器官相连的连接组织。"),
			SPAN_NOTICE("[user]用[tool]扯断了[localized_player_label(target.caste_type)]与重要器官相连的连接组织。"))

/datum/surgery_step/xenomorph/severe_connections/failure(mob/living/carbon/human/user, mob/living/carbon/xenomorph/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	user.affected_message(target,
		SPAN_WARNING("你手一滑，损伤了[localized_player_label(target.caste_type)]的一条[pick("动脉", "静脉")]，酸血四处喷涌！"),
		SPAN_WARNING("[user]手一滑，损伤了你的一条[pick("动脉", "静脉")]，酸血四处喷涌！"),
		SPAN_WARNING("[user]手一滑，损伤了[localized_player_label(target.caste_type)]的一条[pick("动脉", "静脉")]，酸血四处喷涌！"))
	for(var/mob/living/carbon/human/victim in orange(1, target))
		if(istype(victim.wear_suit, /obj/item/clothing/suit/bio_suit) && istype(victim.head, /obj/item/clothing/head/bio_hood))
			continue
		to_chat(victim, SPAN_DANGER("从[localized_player_label(target.caste_type)]体内涌出的血液溅了你一身。"))
		victim.apply_damage(rand(50, 75), BURN) // not SO dangerous but still is
		playsound(victim, "acid_sizzle", 25, TRUE)
		animation_flash_color(victim, "#FF0000")

/datum/surgery_step/xenomorph/remove_organ
	name = "取出异形器官"
	desc = "抓牢并取出器官"
	accept_hand = TRUE
	tools = list(
		/obj/item/tool/surgery/hemostat = SURGERY_TOOL_MULT_IDEAL,
		/obj/item/tool/wirecutters = SURGERY_TOOL_MULT_SUBOPTIMAL,
		/obj/item/tool/kitchen/utensil/fork = SURGERY_TOOL_MULT_SUBSTITUTE,
	)//shamelessly taken from embryo code
	time = 3 SECONDS
	preop_sound = 'sound/surgery/scalpel1.ogg'
	success_sound = 'sound/surgery/scalpel2.ogg'
	failure_sound = 'sound/surgery/organ2.ogg'

/datum/surgery_step/xenomorph/remove_organ/preop(mob/living/carbon/human/user, mob/living/carbon/xenomorph/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	if(tool)
		user.affected_message(target,
		SPAN_NOTICE("你开始用[tool]牢牢夹住[localized_player_label(target.caste_type)]的器官。"),
		SPAN_NOTICE("[user]开始用[tool]牢牢夹住你的内脏。"),
		SPAN_NOTICE("[user]开始用[tool]牢牢夹住[localized_player_label(target.caste_type)]的器官。"))
	else
		user.affected_message(target,
			SPAN_NOTICE("你开始牢牢抓住[localized_player_label(target.caste_type)]的器官。"),
			SPAN_NOTICE("[user]开始牢牢抓住你的内脏。"),
			SPAN_NOTICE("[user]开始牢牢抓住[localized_player_label(target.caste_type)]的器官。"))

/datum/surgery_step/xenomorph/remove_organ/success(mob/living/carbon/human/user, mob/living/carbon/xenomorph/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	if(tool)
		user.affected_message(target,
			SPAN_NOTICE("你用[tool]取出了[localized_player_label(target.caste_type)]的器官。"),
			SPAN_NOTICE("[user]用[tool]取出了你的器官。"),
			SPAN_NOTICE("[user]用[tool]取出了[localized_player_label(target.caste_type)]的器官。"))
	else
		if(istype(user.wear_suit, /obj/item/clothing/suit/bio_suit))
			user.affected_message(target,
				SPAN_NOTICE("你取出了[localized_player_label(target.caste_type)]的器官！"),
				SPAN_NOTICE("[user]扯出了你的内脏！"),
				SPAN_NOTICE("[user]取出了[localized_player_label(target.caste_type)]的器官。"))
		else
			user.affected_message(target,
				SPAN_NOTICE("你取出[localized_player_label(target.caste_type)]的器官时烫伤了双手！"),
				SPAN_NOTICE("[user]取出你的内脏时烫伤了双手！"),
				SPAN_NOTICE("[user]取出[localized_player_label(target.caste_type)]的器官时烫伤了双手。"))
			user.emote("pain")
			if(user.hand)
				user.apply_damage(rand(30,50), BURN, "l_hand")
			else
				user.apply_damage(rand(30,50), BURN, "r_hand")
			playsound(user, "acid_sizzle", 25, TRUE)
			animation_flash_color(user, "#FF0000")
	var/obj/item/organ/xeno/organ = locate() in target
	if(!isnull(organ))
		organ.forceMove(target.loc)
		target.organ_removed = TRUE
		target.update_wounds()

/datum/surgery_step/xenomorph/remove_organ/failure(mob/living/carbon/human/user, mob/living/carbon/xenomorph/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	if(tool)
		user.affected_message(target,
			SPAN_NOTICE("你未能用[tool]取出[localized_player_label(target.caste_type)]的器官。"),
			SPAN_NOTICE("[user]未能用[tool]取出你的器官。"),
			SPAN_NOTICE("[user]未能用[tool]取出[localized_player_label(target.caste_type)]的器官。"))
	return FALSE

