/obj/item/stack/medical
	name = "医疗包"
	singular_name = "医疗包"
	icon = 'icons/obj/items/items.dmi'
	amount = 10
	max_amount = 10
	w_class = SIZE_SMALL
	throw_speed = SPEED_VERY_FAST
	throw_range = 20
	attack_speed = 3
	flags_human_ai = HEALING_ITEM
	var/heal_brute = 0
	var/heal_burn = 0
	var/alien = FALSE

/obj/item/stack/medical/attack_self(mob/user)
	..()
	attack(user, user)

/obj/item/stack/medical/attack(mob/living/carbon/M as mob, mob/user as mob)
	if(!istype(M))
		to_chat(user, SPAN_DANGER("无法对[M]使用[src]！"))
		return 1

	if(!ishuman(user))
		to_chat(user, SPAN_WARNING("你的肢体不够灵活，无法进行此操作！"))
		return 1

	var/mob/living/carbon/human/H = M
	var/obj/limb/affecting = H.get_limb(user.zone_selected)

	if(HAS_TRAIT(H, TRAIT_FOREIGN_BIO) && !alien)
		to_chat(user, SPAN_WARNING("[src]不适用于[H]的生理结构！"))
		return TRUE

	if(!affecting)
		to_chat(user, SPAN_WARNING("[H]没有[parse_zone(user.zone_selected)]！"))
		return 1

	if(affecting.display_name == "head")
		if(H.head && istype(H.head,/obj/item/clothing/head/helmet/space))
			to_chat(user, SPAN_WARNING("[H.head]挡住了部位，无法使用[src]！"))
			return 1
	else
		if(H.wear_suit && istype(H.wear_suit,/obj/item/clothing/suit/space))
			to_chat(user, SPAN_WARNING("[H.wear_suit]挡住了部位，无法使用[src]！"))
			return 1

	if(affecting.status & (LIMB_ROBOT|LIMB_SYNTHSKIN))
		to_chat(user, SPAN_WARNING("这对机械肢体毫无作用。"))
		return 1

	H.UpdateDamageIcon()

/obj/item/stack/medical/bruise_pack
	name = "医用纱布卷"
	singular_name = "医用纱布"
	desc = "用于包扎出血的断肢残端和撕裂伤的无菌纱布。"
	icon_state = "brutepack"

	stack_id = "bruise pack"

/obj/item/stack/medical/bruise_pack/attack(mob/living/carbon/M as mob, mob/user as mob)
	if(..())
		return 1

	if (istype(M, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = M

		var/obj/limb/affecting = H.get_limb(user.zone_selected)

		if(user.skills)
			if(!skillcheck(user, SKILL_MEDICAL, SKILL_MEDICAL_MEDIC))
				if(!do_after(user, 10, INTERRUPT_NO_NEEDHAND, BUSY_ICON_FRIENDLY, M, INTERRUPT_MOVED, BUSY_ICON_MEDICAL))
					return 1

		if(affecting.get_incision_depth())
			to_chat(user, SPAN_NOTICE("[M]的[affecting.display_name]已被切开，光靠绷带可不够！"))
			return TRUE

		var/possessive = "[user == M ? "你的" : "[M]的"]"
		var/possessive_their = "[user == M ? user.gender == MALE ? "他自己的" : "她自己的" : "[M]的"]"
		//Packing Arterial Bleeding
		var/time_to_take = 4 SECONDS
		for(var/datum/effects/bleeding/internal/I in affecting.bleeding_effects_list)
			if(!I.has_been_bandaged)
				if(M == user)
					user.visible_message(SPAN_WARNING("[user]笨手笨脚地摆弄着[src]。"), SPAN_WARNING("你笨手笨脚地摆弄着[src]……"))
					time_to_take = 10 SECONDS
				if(do_after(user, time_to_take * user.get_skill_duration_multiplier(SKILL_MEDICAL), INTERRUPT_NO_NEEDHAND, BUSY_ICON_FRIENDLY, M, INTERRUPT_MOVED, BUSY_ICON_MEDICAL))
					if(I.has_been_bandaged)
						return
					possessive = "[user == M ? "你的" : "[M]的"]"
					possessive_their = "[user == M ? user.gender == MALE ? "他自己的" : "她自己的" : "[M]的"]"
					user.affected_message(M,
					SPAN_HELPFUL("你对[possessive]<b>[affecting.display_name]</b>中受损的动脉进行<b>填塞止血</b>，<b>减缓了出血。</b>"),
					SPAN_HELPFUL("[user]对你的<b>[affecting.display_name]</b>中受损的动脉进行<b>填塞止血</b>，<b>减缓了出血。</b>"),
					SPAN_NOTICE("[user]对[possessive_their][affecting.display_name]中受损的动脉进行填塞止血，<b>减缓了出血。</b>"))
					I.has_been_bandaged = TRUE
					use(1)
					return FALSE


		switch(affecting.bandage())
			if(WOUNDS_BANDAGED)
				user.affected_message(M,
					SPAN_HELPFUL("你<b>包扎了</b>[possessive]<b>[affecting.display_name]</b>。"),
					SPAN_HELPFUL("[user]<b>包扎了</b>你的<b>[affecting.display_name]</b>。"),
					SPAN_NOTICE("[user]包扎了[possessive_their][affecting.display_name]。"))
				use(1)
				playsound(user, 'sound/handling/bandage.ogg', 25, 1, 2)
			if(WOUNDS_ALREADY_TREATED)
				to_chat(user, SPAN_WARNING("[possessive][affecting.display_name]上的伤口已经处理过了。"))
				return TRUE
			else
				to_chat(user, SPAN_WARNING("[possessive][affecting.display_name]上没有伤口。"))
				return TRUE

/obj/item/stack/medical/bruise_pack/ai_use(mob/living/carbon/human/user, datum/human_ai_brain/ai_brain, mob/living/carbon/human/target)
	for(var/obj/limb/limb as anything in target.limbs)
		if(QDELETED(src))
			return

		if(locate(/datum/effects/bleeding/external) in limb.bleeding_effects_list)
			user.zone_selected = limb.name
			attack(target, user)
			sleep(ai_brain.short_action_delay)

/obj/item/stack/medical/bruise_pack/two
	amount = 2

/obj/item/stack/medical/ointment
	name = "烧伤药膏"
	desc = "用于治疗烧伤、感染的伤口，以及缓解某些特殊部位的瘙痒。"
	gender = PLURAL
	singular_name = "烧伤药膏"
	icon_state = "ointment"
	heal_burn = 5

	stack_id = "ointment"

/obj/item/stack/medical/ointment/attack(mob/living/carbon/M as mob, mob/user as mob)
	if(..())
		return 1

	if (istype(M, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = M

		var/obj/limb/affecting = H.get_limb(user.zone_selected)

		if(user.skills)
			if(!skillcheck(user, SKILL_MEDICAL, SKILL_MEDICAL_MEDIC))
				if(!do_after(user, 10, INTERRUPT_NO_NEEDHAND, BUSY_ICON_FRIENDLY, M, INTERRUPT_MOVED, BUSY_ICON_MEDICAL))
					return 1

		if(affecting.get_incision_depth())
			to_chat(user, SPAN_NOTICE("[M]的[affecting.display_name]已被切开，光靠药膏可不够！"))
			return TRUE

		var/possessive = "[user == M ? "你的" : "[M]的"]"
		var/possessive_their = "[user == M ? user.gender == MALE ? "他自己的" : "她自己的" : "[M]的"]"
		switch(affecting.salve())
			if(WOUNDS_BANDAGED)
				user.affected_message(M,
					SPAN_HELPFUL("你给[possessive]<b>[affecting.display_name]</b>上的<b>烧伤涂上了药膏</b>。"),
					SPAN_HELPFUL("[user]给你的<b>[affecting.display_name]</b>上的<b>烧伤涂上了药膏</b>。"),
					SPAN_NOTICE("[user]给[possessive_their][affecting.display_name]上的烧伤涂上了药膏。"))
				affecting.heal_damage(burn = heal_burn)
				use(1)
				playsound(user, 'sound/handling/ointment_spreading.ogg', 25, 1, 2)
			if(WOUNDS_ALREADY_TREATED)
				to_chat(user, SPAN_WARNING("[possessive][affecting.display_name]上的烧伤已经处理过了。"))
				return TRUE
			else
				to_chat(user, SPAN_WARNING("[possessive][affecting.display_name]上没有烧伤。"))
				return TRUE

/obj/item/stack/medical/advanced/bruise_pack
	name = "创伤治疗包"
	singular_name = "创伤治疗包"
	desc = "用于治疗重伤的创伤治疗包。"
	icon_state = "traumakit"
	heal_brute = 12

	stack_id = "advanced bruise pack"

/obj/item/stack/medical/advanced/bruise_pack/attack(mob/living/carbon/M, mob/user)
	if(..())
		return 1

	if (istype(M, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = M

		var/obj/limb/affecting = H.get_limb(user.zone_selected)
		var/heal_amt = heal_brute
		if(user.skills)
			if(!skillcheck(user, SKILL_MEDICAL, SKILL_MEDICAL_MEDIC)) //untrained marines have a hard time using it
				to_chat(user, SPAN_WARNING("你开始笨手笨脚地摆弄[src]。"))
				if(!do_after(user, 30, INTERRUPT_NO_NEEDHAND, BUSY_ICON_FRIENDLY, M, INTERRUPT_MOVED, BUSY_ICON_MEDICAL))
					return
				heal_amt = 3 //non optimal application means less healing

		if(affecting.get_incision_depth())
			to_chat(user, SPAN_NOTICE("[M]的[affecting.display_name]已被切开，光靠创伤治疗包可不够！"))
			return TRUE

		var/possessive = "[user == M ? "你的" : "[M]的"]"
		var/possessive_their = "[user == M ? user.gender == MALE ? "他自己的" : "她自己的" : "[M]的"]"
		//Packing Arterial Bleeding
		var/time_to_take = 2.5 SECONDS
		for(var/datum/effects/bleeding/internal/I in affecting.bleeding_effects_list)
			if(!I.has_been_bandaged)
				if(M == user)
					user.visible_message(SPAN_WARNING("[user]笨手笨脚地摆弄着[src]。"), SPAN_WARNING("你笨手笨脚地摆弄着[src]……"))
					time_to_take = 5 SECONDS
				if(do_after(user, time_to_take * user.get_skill_duration_multiplier(SKILL_MEDICAL), INTERRUPT_NO_NEEDHAND, BUSY_ICON_FRIENDLY, M, INTERRUPT_MOVED, BUSY_ICON_MEDICAL))
					possessive = "[user == M ? "你的" : "[M]的"]"
					possessive_their = "[user == M ? user.gender == MALE ? "他自己的" : "她自己的" : "[M]的"]"
					user.affected_message(M,
					SPAN_HELPFUL("你对[possessive]<b>[affecting.display_name]</b>中受损的动脉进行<b>填塞止血</b>，<b>减缓了出血。</b>"),
					SPAN_HELPFUL("[user]对你的<b>[affecting.display_name]</b>中受损的动脉进行<b>填塞止血</b>，<b>减缓了出血。</b>"),
					SPAN_NOTICE("[user]对[possessive_their][affecting.display_name]中受损的动脉进行填塞止血，<b>减缓了出血。</b>"))
					I.has_been_bandaged = TRUE
					use(1)
					return FALSE


		switch(affecting.bandage(TRUE))
			if(WOUNDS_BANDAGED)
				user.affected_message(M,
					SPAN_HELPFUL("你用生物胶<b>清理并封合了</b>[possessive]<b>[affecting.display_name]</b>上的伤口。"),
					SPAN_HELPFUL("[user]用生物胶<b>清理并封合了</b>你的<b>[affecting.display_name]</b>上的伤口。"),
					SPAN_NOTICE("[user]用生物胶清理并封合了[possessive_their][affecting.display_name]上的伤口。"))
				//If a suture datum exists, apply half the damage as sutures. This ensures consistency in healing amounts.
				if(SEND_SIGNAL(affecting, COMSIG_LIMB_ADD_SUTURES, TRUE, FALSE, heal_amt * 0.5))
					heal_amt *= 0.5
				affecting.heal_damage(brute = heal_amt)
				use(1)
			if(WOUNDS_ALREADY_TREATED)
				to_chat(user, SPAN_WARNING("[possessive][affecting.display_name]上的伤口已经处理过了。"))
				return TRUE
			else
				to_chat(user, SPAN_WARNING("[possessive][affecting.display_name]上没有伤口。"))
				return TRUE

/obj/item/stack/medical/advanced/bruise_pack/ai_can_use(mob/living/carbon/human/user, datum/human_ai_brain/ai_brain, mob/living/carbon/human/target)
	if(issynth(target))
		return FALSE

	for(var/obj/limb/limb as anything in target.limbs)
		if(locate(/datum/effects/bleeding/external) in limb.bleeding_effects_list)
			return TRUE

		for(var/datum/wound/wound in limb.wounds)
			if(wound.internal || wound.damage_type == BURN)
				continue

			if(!(wound.bandaged & (WOUND_BANDAGED|WOUND_SUTURED)))
				return TRUE
	return FALSE

/obj/item/stack/medical/advanced/bruise_pack/ai_use(mob/living/carbon/human/user, datum/human_ai_brain/ai_brain, mob/living/carbon/human/target)
	for(var/obj/limb/limb as anything in target.limbs)
		if(QDELETED(src))
			return

		if(locate(/datum/effects/bleeding/external) in limb.bleeding_effects_list)
			user.zone_selected = limb.name
			attack(target, user)
			sleep(ai_brain.short_action_delay)
			continue

		for(var/datum/wound/wound in limb.wounds)
			if(wound.internal || wound.damage_type == BURN)
				continue

			if(QDELETED(src))
				return

			if(!(wound.bandaged & (WOUND_BANDAGED|WOUND_SUTURED)))
				user.zone_selected = limb.name
				attack(target, user)
				sleep(ai_brain.short_action_delay)

/obj/item/stack/medical/advanced/bruise_pack/predator
	name = "愈伤草药"
	singular_name = "愈伤草药"
	desc = "由柔软叶片制成的敷药，用于涂抹瘀伤。"
	icon = 'icons/obj/items/hunter/pred_gear.dmi'
	icon_state = "brute_herbs"
	heal_brute = 15
	stack_id = "mending herbs"
	alien = TRUE

/obj/item/stack/medical/advanced/ointment/predator
	name = "舒缓草药"
	singular_name = "舒缓草药"
	desc = "由冰凉的蓝色花瓣制成的敷药，用于涂抹烧伤。"
	icon = 'icons/obj/items/hunter/pred_gear.dmi'
	icon_state = "burn_herbs"
	heal_burn = 15
	stack_id = "soothing herbs"
	alien = TRUE

/obj/item/stack/medical/advanced/ointment
	name = "烧伤治疗包"
	singular_name = "烧伤治疗包"
	desc = "用于治疗严重烧伤的医疗包。"
	icon_state = "burnkit"
	heal_burn = 12

	stack_id = "burn kit"

/obj/item/stack/medical/advanced/ointment/attack(mob/living/carbon/M as mob, mob/user as mob)
	if(..())
		return 1

	if(istype(M, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = M

		var/heal_amt = heal_burn
		var/obj/limb/affecting = H.get_limb(user.zone_selected)
		if(user.skills)
			if(!skillcheck(user, SKILL_MEDICAL, SKILL_MEDICAL_MEDIC)) //untrained marines have a hard time using it
				to_chat(user, SPAN_WARNING("你开始笨手笨脚地摆弄[src]。"))
				if(!do_after(user, 30, INTERRUPT_NO_NEEDHAND, BUSY_ICON_FRIENDLY, M, INTERRUPT_MOVED, BUSY_ICON_MEDICAL))
					return
				heal_amt = 3 //non optimal application means less healing

		if(affecting.get_incision_depth())
			to_chat(user, SPAN_NOTICE("[M]的[affecting.display_name]已被切开，光靠烧伤治疗包可不够！"))
			return TRUE

		var/possessive = "[user == M ? "你的" : "[M]的"]"
		var/possessive_their = "[user == M ? user.gender == MALE ? "他自己的" : "她自己的" : "[M]的"]"
		switch(affecting.salve(TRUE))
			if(WOUNDS_BANDAGED)
				user.affected_message(M,
					SPAN_HELPFUL("你用再生膜<b>覆盖了</b>[possessive]<b>[affecting.display_name]</b>上的<b>烧伤</b>。"),
					SPAN_HELPFUL("[user]用再生膜<b>覆盖了</b>你的<b>[affecting.display_name]</b>上的<b>烧伤</b>。"),
					SPAN_NOTICE("[user]用再生膜覆盖了[possessive_their][affecting.display_name]上的烧伤。"))
				//If a suture datum exists, apply half the damage as grafts. This ensures consistency in healing amounts.
				if(SEND_SIGNAL(affecting, COMSIG_LIMB_ADD_SUTURES, FALSE, TRUE, heal_amt * 0.5))
					heal_amt *= 0.5
				affecting.heal_damage(burn = heal_amt)
				use(1)
			if(WOUNDS_ALREADY_TREATED)
				to_chat(user, SPAN_WARNING("[possessive][affecting.display_name]上的烧伤已经处理过了。"))
				return TRUE
			else
				to_chat(user, SPAN_WARNING("[possessive][affecting.display_name]上没有烧伤。"))
				return TRUE

/obj/item/stack/medical/advanced/ointment/ai_can_use(mob/living/carbon/human/user, datum/human_ai_brain/ai_brain, mob/living/carbon/human/target)
	if(issynth(target))
		return FALSE

	for(var/obj/limb/limb as anything in target.limbs)
		for(var/datum/wound/wound in limb.wounds)
			if(wound.internal || wound.damage_type == BRUTE)
				continue

			if(!(wound.bandaged & (WOUND_BANDAGED|WOUND_SUTURED)))
				return TRUE
	return FALSE

/obj/item/stack/medical/advanced/ointment/ai_use(mob/living/carbon/human/user, datum/human_ai_brain/ai_brain, mob/living/carbon/human/target)
	for(var/obj/limb/limb as anything in target.limbs)
		for(var/datum/wound/wound in limb.wounds)
			if(wound.internal || wound.damage_type == BRUTE)
				continue

			if(QDELETED(src))
				return

			if(!(wound.bandaged & (WOUND_BANDAGED|WOUND_SUTURED)))
				user.zone_selected = limb.name
				attack(target, user)
				sleep(ai_brain.short_action_delay)

/obj/item/stack/medical/splint
	name = "医用夹板"
	singular_name = "医用夹板"
	desc = "一套不同规格的夹板和固定纱布。怎么，你以为在这里就只会摔断腿吗？"
	icon_state = "splint"
	amount = 5
	max_amount = 5
	stack_id = "splint"

	var/indestructible_splints = FALSE

/obj/item/stack/medical/splint/attack(mob/living/carbon/M, mob/user, mob/living/carbon/target)
	if(..()) return 1

	if(user.action_busy)
		return

	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		var/obj/limb/affecting = H.get_limb(user.zone_selected)
		var/limb = affecting.display_name

		if(!(affecting.name in list("l_arm", "r_arm", "l_leg", "r_leg", "r_hand", "l_hand", "r_foot", "l_foot", "chest", "groin", "head")))
			to_chat(user, SPAN_WARNING("那个部位不能上夹板！"))
			return

		if(affecting.status & LIMB_DESTROYED)
			var/message = SPAN_WARNING("[user == M ? "你" : "[M]"]没有[limb]！")
			to_chat(user, message)
			return

		if(affecting.status & LIMB_SPLINTED)
			var/message = "[user == M ? "你的" : "[M]的"]"
			to_chat(user, SPAN_WARNING("[message][limb]已经上过夹板了！"))
			return

		if(M != user)
			var/possessive = "[user == M ? "你的" : "[M]的"]"
			var/possessive_their = "[user == M ? user.gender == MALE ? "他自己的" : "她自己的" : "[M]的"]"
			user.affected_message(M,
				SPAN_HELPFUL("你<b>开始给</b>[possessive]<b>[affecting.display_name]上夹板</b>。"),
				SPAN_HELPFUL("[user]<b>开始给</b>你的<b>[affecting.display_name]上夹板</b>。"),
				SPAN_NOTICE("[user]开始给[possessive_their][affecting.display_name]上夹板。"))
		else
			if((!user.hand && (affecting.name in list("r_arm", "r_hand"))) || (user.hand && (affecting.name in list("l_arm", "l_hand"))))
				to_chat(user, SPAN_WARNING("你不能给当前正在使用的\
					[affecting.name == "r_hand"||affecting.name == "l_hand" ? "手":"手臂"]上夹板！"))
				return
			// Self-splinting
			user.affected_message(M,
				SPAN_HELPFUL("你<b>开始给</b>自己的<b>[affecting.display_name]上夹板</b>。"),
				,
				SPAN_NOTICE("[user]开始给自己的[affecting.display_name]上夹板。"))

		if(affecting.apply_splints(src, user, M, indestructible_splints)) // Referenced in external organ helpers.
			use(1)
			playsound(user, 'sound/handling/splint1.ogg', 25, 1, 2)


/obj/item/stack/medical/splint/ai_use(mob/living/carbon/human/user, datum/human_ai_brain/ai_brain, mob/living/carbon/human/target)
	for(var/obj/limb/limb as anything in target.limbs)
		if(QDELETED(src))
			return

		if(limb.is_broken())
			user.zone_selected = limb.name
			attack(target, user)
			sleep(ai_brain.short_action_delay)
			continue
