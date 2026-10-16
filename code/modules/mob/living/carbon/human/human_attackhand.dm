/mob/living/carbon/human/var/cpr_attempt_timer
/mob/living/carbon/human/attack_hand(mob/living/carbon/human/attacking_mob)
	if(..())
		return TRUE

	SEND_SIGNAL(attacking_mob, COMSIG_LIVING_ATTACKHAND_HUMAN, src)

	if((attacking_mob != src) && check_shields(0, attacking_mob.name))
		visible_message(SPAN_DANGER("<B>[attacking_mob]试图触碰[src]！</B>"), null, null, 5)
		return FALSE

	switch(attacking_mob.a_intent)
		if(INTENT_HELP)

			if(on_fire && attacking_mob != src)
				adjust_fire_stacks(-10, min_stacks = 0)
				playsound(src.loc, 'sound/weapons/thudswoosh.ogg', 25, 1, 7)
				attacking_mob.visible_message(SPAN_DANGER("[attacking_mob]试图扑灭[src]身上的火！"), \
					SPAN_WARNING("你试图扑灭[src]身上的火！"), null, 5)
				if(fire_stacks <= 0)
					attacking_mob.visible_message(SPAN_DANGER("[attacking_mob]成功扑灭了[src]身上的火！"), \
						SPAN_NOTICE("你扑灭了[src]身上的火。"), null, 5)
				return 1

			// If unconscious with oxygen damage, do CPR. If dead, we do CPR
			if(!((stat == UNCONSCIOUS || ((locate(/datum/effects/crit) in effects_list) && (status_flags & CANKNOCKOUT))) && getOxyLoss() > 0) && !(stat == DEAD))
				help_shake_act(attacking_mob)
				return 1

			if(attacking_mob.head && (attacking_mob.head.flags_inventory & COVERMOUTH) && !(attacking_mob.head.flags_inventory & ALLOWCPR) || attacking_mob.wear_mask && (attacking_mob.wear_mask.flags_inventory & COVERMOUTH) && !(attacking_mob.wear_mask.flags_inventory & ALLOWCPR))
				to_chat(attacking_mob, SPAN_NOTICE("<B>先摘下你的面罩！</B>"))
				return 0
			if(head && (head.flags_inventory & COVERMOUTH) && !(head.flags_inventory & ALLOWCPR) || wear_mask && (wear_mask.flags_inventory & COVERMOUTH) && !(wear_mask.flags_inventory & ALLOWCPR))
				to_chat(attacking_mob, SPAN_NOTICE("<B>先摘下[src.gender==MALE?"他的":"她的"]面罩！</B>"))
				return 0
			if(cpr_attempt_timer >= world.time)
				to_chat(attacking_mob, SPAN_NOTICE("<B>已经有人在为[src]进行心肺复苏了！</B>"))
				return 0

			//CPR
			if(attacking_mob.action_busy)
				return 1

			attacking_mob.visible_message(SPAN_NOTICE("<b>[attacking_mob]</b>开始为<b>[src]</b>进行<b>心肺复苏</b>。"),
				SPAN_HELPFUL("你开始为<b>[src]</b><b>进行心肺复苏</b>。"))

			cpr_attempt_timer = world.time + HUMAN_STRIP_DELAY * attacking_mob.get_skill_duration_multiplier(SKILL_MEDICAL)
			if(do_after(attacking_mob, HUMAN_STRIP_DELAY * attacking_mob.get_skill_duration_multiplier(SKILL_MEDICAL), INTERRUPT_ALL, BUSY_ICON_GENERIC, src, INTERRUPT_MOVED, BUSY_ICON_MEDICAL))
				affected_message(attacking_mob,
					SPAN_HELPFUL("你感到一口<b>新鲜空气</b>进入肺部，舒服多了。"),
					SPAN_HELPFUL("你为<b>[src]</b><b>进行了心肺复苏</b>。"),
					SPAN_NOTICE("<b>[attacking_mob]</b>为<b>[src]</b>进行了<b>心肺复苏</b>。"))
				if(stat != DEAD)
					var/suff = min(getOxyLoss(), 10) //Pre-merge level, less healing, more prevention of dieing.
					apply_damage(-suff, OXY)
					updatehealth()
			cpr_attempt_timer = 0
			return 1

		if(INTENT_GRAB)
			if(attacking_mob == src)
				check_for_injuries()
				return 1

			if(anchored)
				return 0

			if(w_uniform)
				w_uniform.add_fingerprint(attacking_mob)

			attacking_mob.start_pulling(src)
			return 1

		if(INTENT_HARM)
			// See if they can attack, and which attacks to use.
			var/datum/unarmed_attack/attack = attacking_mob.species.unarmed
			if(!attack.is_usable(attacking_mob))
				attack = attacking_mob.species.secondary_unarmed
				return

			last_damage_data = create_cause_data("fisticuffs", attacking_mob)
			attacking_mob.attack_log += text("\[[time_stamp()]\] <font color='red'>[pick(attack.attack_verb)]ed [key_name(src)]</font>")
			attack_log += text("\[[time_stamp()]\] <font color='orange'>Has been [pick(attack.attack_verb)]ed by [key_name(attacking_mob)]</font>")
			msg_admin_attack("[key_name(attacking_mob)] [pick(attack.attack_verb)]ed [key_name(src)] in [get_area(src)] ([src.loc.x],[src.loc.y],[src.loc.z]).", src.loc.x, src.loc.y, src.loc.z)

			attacking_mob.animation_attack_on(src)
			attacking_mob.flick_attack_overlay(src, "punch")

			var/extra_cqc_dmg = 0 //soft maximum of 5, this damage is added onto the final value depending on how much cqc skill you have
			if(attacking_mob.skills)
				extra_cqc_dmg = attacking_mob.skills?.get_skill_level(SKILL_CQC)
			var/raw_damage = 0 //final value, gets absorbed by the armor and then deals the leftover to the mob

			var/obj/limb/affecting = get_limb(rand_zone(attacking_mob.zone_selected, 70))
			var/armor = getarmor(affecting, ARMOR_MELEE)

			playsound(loc, attack.attack_sound, 25, 1)

			visible_message(SPAN_DANGER("[attacking_mob]对[src]使出了[pick(attack.attack_verb)]！"), null, null, 5)

			raw_damage = attack.damage + extra_cqc_dmg
			var/final_damage = armor_damage_reduction(GLOB.marine_melee, raw_damage, armor, FALSE) // no penetration from punches
			apply_damage(final_damage, BRUTE, affecting, sharp=attack.sharp, edge = attack.edge)

		if(INTENT_DISARM)
			if(attacking_mob == src)
				check_for_injuries()
				return 1

			attacking_mob.attack_log += text("\[[time_stamp()]\] <font color='red'>Disarmed [key_name(src)]</font>")
			src.attack_log += text("\[[time_stamp()]\] <font color='orange'>Has been disarmed by [key_name(attacking_mob)]</font>")

			attacking_mob.animation_attack_on(src)
			attacking_mob.flick_attack_overlay(src, "disarm")

			msg_admin_attack("[key_name(attacking_mob)] disarmed [key_name(src)] in [get_area(src)] ([src.loc.x],[src.loc.y],[src.loc.z]).", src.loc.x, src.loc.y, src.loc.z)

			if(w_uniform)
				w_uniform.add_fingerprint(attacking_mob)

			//Accidental gun discharge
			if(!skillcheck(attacking_mob, SKILL_CQC, SKILL_CQC_SKILLED))
				if (isgun(r_hand) || isgun(l_hand))
					var/obj/item/weapon/gun/held_weapon = null
					var/chance = 0

					if (isgun(l_hand))
						held_weapon = l_hand
						chance = hand ? 40 : 20

					if (isgun(r_hand))
						held_weapon = r_hand
						chance = !hand ? 40 : 20

					if (prob(chance))
						visible_message(SPAN_DANGER("[attacking_mob]在扭打中意外触发了[src]的[held_weapon.name]！"), SPAN_DANGER("你在扭打中意外触发了[src]的[held_weapon.name]！"), null, 5)
						var/list/turfs = list()
						for(var/turf/T in view())
							turfs += T
						var/turf/target = pick(turfs)
						count_niche_stat(STATISTICS_NICHE_DISCHARGE)

						attack_log += "\[[time_stamp()]\] <b>[key_name(src)]</b> accidentally fired <b>[held_weapon.name]</b> in [get_area(src)] triggered by <b>[key_name(attacking_mob)]</b>."
						attacking_mob.attack_log += "\[[time_stamp()]\] <b>[key_name(src)]</b> accidentally fired <b>[held_weapon.name]</b> in [get_area(src)] triggered by <b>[key_name(attacking_mob)]</b>."
						msg_admin_attack("[key_name(src)] accidentally fired <b>[held_weapon.name]</b> in [get_area(attacking_mob)] ([attacking_mob.loc.x],[attacking_mob.loc.y],[attacking_mob.loc.z]) triggered by <b>[key_name(attacking_mob)]</b>.", attacking_mob.loc.x, attacking_mob.loc.y, attacking_mob.loc.z)

						return held_weapon.afterattack(target,src)

			var/disarm_chance = rand(1, 100)
			var/attacker_skill_level = attacking_mob.skills ? attacking_mob.skills.get_skill_level(SKILL_CQC) : SKILL_CQC_MAX // No skills, so assume max
			var/defender_skill_level = skills ? skills.get_skill_level(SKILL_CQC) : SKILL_CQC_MAX // No skills, so assume max
			disarm_chance -= 5 * attacker_skill_level
			disarm_chance += 5 * defender_skill_level

			if(disarm_chance <= 25)
				var/strength = 2 + max((attacker_skill_level - defender_skill_level), 0)
				KnockDown(strength)
				Stun(strength)
				playsound(loc, 'sound/weapons/thudswoosh.ogg', 25, 1, 7)
				var/shove_text = attacker_skill_level > 1 ? "扑倒" : pick("推搡", "猛推")
				visible_message(SPAN_DANGER("<B>[attacking_mob]对[src]进行了[shove_text]！</B>"), null, null, 5)
				return

			if(disarm_chance <= 60)
				//BubbleWrap: Disarming breaks a pull
				if(pulling)
					visible_message(SPAN_DANGER("<b>[attacking_mob]挣脱了[src]对[pulling]的抓握！</B>"), null, null, 5)
					stop_pulling()
				else
					drop_held_item()
					visible_message(SPAN_DANGER("<B>[attacking_mob]缴了[src]的械！</B>"), null, null, 5)
				playsound(loc, 'sound/weapons/punchmiss.ogg', 25, 1, 7)
				return

			playsound(loc, 'sound/weapons/punchmiss.ogg', 25, 1, 7)
			visible_message(SPAN_DANGER("<B>[attacking_mob]试图缴[src]的械！</B>"), null, null, 5)

/mob/living/carbon/human/proc/afterattack(atom/target as mob|obj|turf|area, mob/living/user as mob|obj, inrange, params)
	return

/mob/living/carbon/human/help_shake_act(mob/living/carbon/M)
	//Target is us
	if(src == M)
		check_for_injuries()
		return

	//Target is not us
	var/t_him = "它"
	if (gender == MALE)
		t_him = "他"
	else if (gender == FEMALE)
		t_him = "她"
	if (w_uniform)
		w_uniform.add_fingerprint(M)

	if(HAS_TRAIT(src, TRAIT_FLOORED) || HAS_TRAIT(src, TRAIT_KNOCKEDOUT) || body_position == LYING_DOWN || sleeping)
		if(client)
			sleeping = max(0,src.sleeping-5)
		if(!sleeping)
			if(is_dizzy)
				to_chat(M, SPAN_WARNING("[src]看起来头晕目眩。也许你应该让[t_him]多休息一会儿。"))
			else
				set_resting(FALSE)
		M.visible_message(SPAN_NOTICE("[M]摇晃[src]，试图将[t_him]唤醒！"), \
			SPAN_NOTICE("你摇晃[src]，试图将[t_him]唤醒！"), null, 4)
	else if(HAS_TRAIT(src, TRAIT_INCAPACITATED))
		M.visible_message(SPAN_NOTICE("[M]摇晃[src]，试图让[t_him]从恍惚中清醒！"), \
			SPAN_NOTICE("你摇晃[src]，试图让[t_him]从恍惚中清醒！"), null, 4)
	else
		var/mob/living/carbon/human/H = M
		if(istype(H))
			H.species.hug(H, src, H.zone_selected)
		else
			M.visible_message(SPAN_NOTICE("[M]拍了拍[src]的背，试图让[t_him]好受一些！"), \
				SPAN_NOTICE("你拍了拍[src]的背，试图让[t_him]好受一些！"), null, 4)
			playsound(src.loc, 'sound/weapons/thudswoosh.ogg', 25, 1, 5)
		return

	adjust_effect(-6, PARALYZE)
	adjust_effect(-6, STUN)
	adjust_effect(-6, WEAKEN)

	playsound(loc, 'sound/weapons/thudswoosh.ogg', 25, 1, 7)

/mob/living/carbon/human/proc/check_for_injuries()
	visible_message(SPAN_NOTICE("[src]检查了[gender==MALE?"他自己":"她自己"]。"), \
	SPAN_NOTICE("你检查自己有没有受伤。"), null, 3)

	var/list/limb_message = list()
	for(var/obj/limb/org in limbs)
		var/list/status = list()
		var/brutedamage = org.brute_dam
		var/burndamage = org.burn_dam
		if(org.status & LIMB_DESTROYED)
			status += "缺失！"
		else if(org.status & (LIMB_ROBOT|LIMB_SYNTHSKIN))
			switch(brutedamage)
				if(1 to 20)
					status += "凹陷"
				if(20 to 40)
					status += "严重受损"
				if(40 to INFINITY)
					status += "残破不堪"

			switch(burndamage)
				if(1 to 10)
					status += "轻度烧伤"
				if(10 to 40)
					status += "烧伤"
				if(40 to INFINITY)
					status += "焦黑"

		else
			if(org.status & LIMB_MUTATED)
				status += "形状异常"
			if(halloss > 0)
				status += "刺痛"
			switch(brutedamage)
				if(1 to 20)
					status += "瘀伤"
				if(20 to 40)
					status += "严重受损"
				if(40 to INFINITY)
					status += "残破不堪"

			switch(burndamage)
				if(1 to 10)
					status += "麻木"
				if(10 to 40)
					status += "起泡"
				if(40 to INFINITY)
					status += "皮肤剥落"

		if(org.get_incision_depth()) //Unindented because robotic and severed limbs may also have surgeries performed upon them.
			status += "已切开"

		for(var/datum/effects/bleeding/external/E in org.bleeding_effects_list)
			status += "正在流血"
			break

		var/limb_surgeries = org.get_active_limb_surgeries()
		if(limb_surgeries)
			status += "正在接受[limb_surgeries]"

		if(!length(status))
			status += "正常"

		var/postscript
		if(org.status & LIMB_UNCALIBRATED_PROSTHETIC)
			postscript += " <b>（无法使用）</b>"
		if(org.status & LIMB_BROKEN)
			postscript += " <b>（骨折）</b>"
		if(org.status & LIMB_SPLINTED_INDESTRUCTIBLE)
			postscript += " <b>（纳米夹板固定）</b>"
		else if(org.status & LIMB_SPLINTED)
			postscript += " <b>（夹板固定）</b>"
		for(var/datum/effects/bleeding/internal/I in org.bleeding_effects_list)
			postscript += " <b>存在搏动性出血。</b> "
			if(I.has_been_bandaged)
				postscript += " <b>（已填塞止血）</b> "

		if(postscript)
			limb_message += "\t 我的[org.display_name]：[SPAN_WARNING("[english_list(status, final_comma_text = ",")]。[postscript]")]"
		else
			limb_message += "\t 我的[org.display_name]：[status[1] == "正常" ? SPAN_NOTICE("状况良好。") : SPAN_WARNING("[english_list(status, final_comma_text = ",")]。")]"
	to_chat(src, examine_block(limb_message.Join("\n")))
