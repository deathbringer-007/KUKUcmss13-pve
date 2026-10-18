
/obj/item/proc/attack_verb_display(verb)
	var/static/list/display_verbs = list(
		"HONKED" = "鸣笛轰击",
		"attacked" = "攻击",
		"bapped" = "拍打",
		"bashed" = "猛砸",
		"battered" = "痛殴",
		"beaten" = "殴打",
		"bludgeoned" = "钝击",
		"carved" = "刻伤",
		"chaired" = "砸击",
		"challenged" = "发起挑战",
		"colored" = "涂色",
		"cracked" = "敲裂",
		"cut" = "割伤",
		"diced" = "切碎",
		"disciplined" = "教训",
		"educated" = "教育",
		"gashed" = "划伤",
		"gored" = "顶穿",
		"hit" = "击中",
		"impaled" = "刺穿",
		"jabbed" = "戳刺",
		"lashed" = "鞭打",
		"pierced" = "刺穿",
		"punctured" = "戳穿",
		"ripped" = "撕裂",
		"scraped" = "刮伤",
		"shredded" = "撕碎",
		"skewered" = "贯穿",
		"slapped" = "掌掴",
		"slashed" = "劈砍",
		"sliced" = "切伤",
		"smacked" = "拍击",
		"smashed" = "砸伤",
		"speared" = "矛刺",
		"stabbed" = "刺伤",
		"struck" = "打击",
		"thwacked" = "敲打",
		"torn" = "扯伤",
		"whacked" = "重击",
		"whipped" = "鞭打",
	)
	return display_verbs[verb] || verb

// Called when the item is in the active hand, and clicked; alternately, there is an 'activate held object' verb or you can hit pagedown.
/obj/item/proc/attack_self(mob/user)
	SHOULD_CALL_PARENT(TRUE)
	SEND_SIGNAL(src, COMSIG_ITEM_ATTACK_SELF, user)
	SEND_SIGNAL(user, COMSIG_MOB_ITEM_ATTACK_SELF, src)

	if(flags_item & CAN_DIG_SHRAPNEL && ishuman(user))
		dig_out_shrapnel(user)

// No comment
/atom/proc/attackby(obj/item/W, mob/living/user, list/mods)
	if(SEND_SIGNAL(src, COMSIG_PARENT_ATTACKBY, W, user, mods) & COMPONENT_NO_AFTERATTACK)
		return TRUE
	SEND_SIGNAL(user, COMSIG_MOB_PARENT_ATTACKBY, src, W)
	return FALSE

/atom/movable/attackby(obj/item/W, mob/living/user)
	. = ..()
	if(W && !.)
		if(!(W.flags_item & NOBLUDGEON))
			visible_message(SPAN_DANGER("[user] 用 [W] 击中了 [src]。"), null, null, 5, CHAT_TYPE_MELEE_HIT)
			user.animation_attack_on(src)
			user.flick_attack_overlay(src, "punch")

/mob/living/attackby(obj/item/I, mob/user)
	/* Commented surgery code, proof of concept. Would need to tweak human attackby to prevent duplication; mob/living don't have separate limb objects.
	if((user.mob_flags & SURGERY_MODE_ON) && user.a_intent & (INTENT_HELP|INTENT_DISARM))
		safety = TRUE
		var/datum/surgery/current_surgery = active_surgeries[user.zone_selected]
		if(current_surgery)
			if(current_surgery.attempt_next_step(user, I))
				return TRUE
		else if(initiate_surgery_moment(I, src, null, user))
			return TRUE
	*/
	if(istype(I) && ismob(user))
		return I.attack(src, user)


// Proximity_flag is 1 if this afterattack was called on something adjacent, in your square, or on your person.
// Click parameters is the params string from byond Click() code, see that documentation.
/obj/item/proc/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	return FALSE


/obj/item/proc/attack(mob/living/target, mob/living/user)
	if((flags_item & NOBLUDGEON) || (MODE_HAS_TOGGLEABLE_FLAG(MODE_NO_ATTACK_DEAD) && target.stat == DEAD && !user.get_target_lock(target.faction_group)))
		return FALSE

	if(SEND_SIGNAL(target, COMSIG_ITEM_ATTEMPT_ATTACK, user, src) & COMPONENT_CANCEL_ATTACK) //Sent by target mob.
		return FALSE

	if(SEND_SIGNAL(src, COMSIG_ITEM_ATTACK, user, target) & COMPONENT_CANCEL_ATTACK) //Sent by source item.
		return FALSE

	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(!H.melee_allowed)
			to_chat(H, SPAN_DANGER("你现在无法攻击。"))
			return FALSE

	var/showname = ""
	if(user)
		if(target == user)
			showname = "（自行操作）"
		else
			showname = "（操作者：[user]）"
	if(!(user in viewers(target, null)))
		showname = ""

	if(user.a_intent == INTENT_HELP && ((user.client?.prefs && user.client?.prefs?.toggle_prefs & TOGGLE_HELP_INTENT_SAFETY) || (user.mob_flags & SURGERY_MODE_ON)))
		playsound(loc, 'sound/effects/pop.ogg', 25, 1)
		user.visible_message(SPAN_NOTICE("[target] 被 [src][showname] 戳了一下。"),\
			SPAN_NOTICE("你用 [src] 戳了[target == user ? "自己":target]一下。"), null, 4)

		return FALSE

	if(ishuman(user) && ishuman_strict(target) && user.a_intent == INTENT_GRAB && user.zone_selected == "mouth")
		var/mob/living/carbon/human/human_target = target
		var/mob/living/carbon/human/human_user = user
		if(force >= MELEE_FORCE_NORMAL && !isnull(sharp) && sharp == IS_SHARP_ITEM_ACCURATE)
			if(!user.get_target_lock(target.faction_group))
				if(human_target.pulledby == human_user)
					if(target.dir == user.dir && target.loc == get_step(user, user.dir) || target.body_position == LYING_DOWN || human_target.handcuffed)
						if(target.stat == DEAD)
							to_chat(target, SPAN_WARNING("对方已经死了。这还有什么意义？"))
							return FALSE
						user.visible_message(SPAN_DANGER("[user] 抓住 [target]，准备用 [src] 割开对方的喉咙。"), SPAN_HIGHDANGER("你抓住 [target] 的头，准备用 [src] 割开对方的喉咙。"))
						to_chat(target, SPAN_HIGHDANGER("[user] 抓住并制住你，将你的头向后扳，露出了喉咙。"))

						throat_slit_stun(target, user)
						switch(get_dir(user, target))
							if(NORTH)
								human_target.pixel_y -= 12
							if(EAST)
								human_target.pixel_x -= 12
							if(SOUTH)
								human_target.pixel_y += 12
							if(WEST)
								human_target.pixel_x += 12
							if(NORTHEAST)
								human_target.pixel_x -= 12
								human_target.pixel_y -= 12
							if(NORTHWEST)
								human_target.pixel_y -= 12
								human_target.pixel_x += 12
							if(SOUTHEAST)
								human_target.pixel_y += 12
								human_target.pixel_x -= 12
							if(SOUTHWEST)
								human_target.pixel_y += 12
								human_target.pixel_x += 12

						if(!do_after(user, 4 SECONDS * human_user.get_skill_duration_multiplier(SKILL_CQC), INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_HOSTILE, target, INTERRUPT_OUT_OF_RANGE, BUSY_ICON_HOSTILE))
							remove_throat_slit_stun(target)
							human_target.pixel_y = 0
							human_target.pixel_x = 0
							return FALSE

						target.visible_message(SPAN_DANGER("[user] 割开了 [target] 的喉咙！鲜血四处喷溅！"), SPAN_HIGHDANGER("[user] 割开了你的喉咙！天哪！"))
						to_chat(user, SPAN_DANGER("你割开了对方的喉咙。对方再也爬不起来了。"))
						playsound(target, 'sound/weapons/slice.ogg', 25, 1)
						target.apply_damage(100, BRUTE, "head")
						target.apply_damage(300, OXYLOSS)

						var/obj/limb/head/head = human_target.get_limb("head")
						ADD_TRAIT(target, TRAIT_FLOORED, THROATSLIT_TRAIT)
						human_target.spray_blood(rand(0,181), head)
						human_target.pixel_y = 0
						human_target.pixel_x = 0

						if(do_after(target, 2 SECONDS, INTERRUPT_NONE))
							target.death(create_cause_data("throat slit"))
							REMOVE_TRAIT(target, TRAIT_FLOORED, THROATSLIT_TRAIT)
							human_target.spray_blood(rand(0,181), head)

						remove_throat_slit_stun(target)
						return TRUE

					else
						to_chat(user, SPAN_WARNING("你必须站在目标正后方，或者目标必须倒地或被束缚住！"))
						return FALSE
				else
					to_chat(user, SPAN_WARNING("你需要先抓住对方才能这么做！"))
					return FALSE
			else
				to_chat(user, SPAN_WARNING("你怎么会想做这种事？你有什么毛病？对方可是自己人！"))
				return FALSE
		else
			to_chat(user, SPAN_HELPFUL("你需要更合适的武器才能这么做！"))
			return FALSE

	/////////////////////////
	user.attack_log += "\[[time_stamp()]\]<font color='red'> Attacked [key_name(target)] with [name] (INTENT: [uppertext(intent_text(user.a_intent))]) (DAMTYE: [uppertext(damtype)])</font>"
	target.attack_log += "\[[time_stamp()]\]<font color='orange'> Attacked by  [key_name(user)] with [name] (INTENT: [uppertext(intent_text(user.a_intent))]) (DAMTYE: [uppertext(damtype)])</font>"
	msg_admin_attack("[key_name(user)] attacked [key_name(target)] with [name] (INTENT: [uppertext(intent_text(user.a_intent))]) (DAMTYE: [uppertext(damtype)]) in [get_area(src)] ([src.loc.x],[src.loc.y],[src.loc.z]).", src.loc.x, src.loc.y, src.loc.z)

	/////////////////////////

	add_fingerprint(user)

	var/power = force
	if(user.skills)
		power = floor(power * (1 + 0.25 * user.skills.get_skill_level(SKILL_MELEE_WEAPONS))) //25% bonus per melee level
	if(!ishuman(target))
		var/used_verb = "attacked"
		if(LAZYLEN(attack_verb))
			used_verb = pick(attack_verb)
		user.visible_message(SPAN_DANGER("[target] 被 [src][showname] [attack_verb_display(used_verb)]了。"), \
			SPAN_DANGER("你用 [src] [attack_verb_display(used_verb)]了[target == user ? "自己":target]。"), null, 5, CHAT_TYPE_MELEE_HIT)

		user.animation_attack_on(target)
		user.flick_attack_overlay(target, "punch")
		if(isxeno(target))
			var/mob/living/carbon/xenomorph/X = target
			power = armor_damage_reduction(GLOB.xeno_melee, power, X.armor_deflection + X.armor_deflection_buff - X.armor_deflection_debuff, 20, 0, 0, X.armor_integrity)
			var/armor_punch = armor_break_calculation(GLOB.xeno_melee, power, X.armor_deflection + X.armor_deflection_buff - X.armor_deflection_debuff, 20, 0, 0, X.armor_integrity)
			X.apply_armorbreak(armor_punch)
		if(hitsound)
			playsound(loc, hitsound, 25, 1)
		switch(damtype)
			if("brute")
				target.apply_damage(power,BRUTE)
			if("fire")
				target.apply_damage(power,BURN)
				to_chat(target, SPAN_WARNING("好烫！"))
		if(power > 5)
			target.last_damage_data = create_cause_data(initial(name), user)
			user.track_hit(initial(name))
			if(user.faction == target.faction)
				user.track_friendly_fire(initial(name))
		target.updatehealth()
	else
		var/mob/living/carbon/human/human_target = target
		var/hit = human_target.attacked_by(src, user)
		if (hit && hitsound)
			playsound(loc, hitsound, 25, 1)
		return hit
	return TRUE

/obj/item/proc/throat_slit_stun(mob/living/target, mob/living/user)
	target.anchored = TRUE
	ADD_TRAIT(target, TRAIT_IMMOBILIZED, THROATSLIT_TRAIT)
	ADD_TRAIT(target, TRAIT_UNDENSE, THROATSLIT_TRAIT)

	playsound(target, 'sound/weapons/thudswoosh.ogg', 25, 1, 7)


/obj/item/proc/remove_throat_slit_stun(mob/living/target)
	target.anchored = FALSE
	REMOVE_TRAIT(target, TRAIT_IMMOBILIZED, THROATSLIT_TRAIT)
	REMOVE_TRAIT(target, TRAIT_UNDENSE, THROATSLIT_TRAIT)
