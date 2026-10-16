/* Weapons
 * Contains:
 * Banhammer
 * Classic Baton
 * Energy Shield
 */

/*
 * Banhammer
 */
/obj/item/weapon/banhammer/attack(mob/M as mob, mob/user as mob)
	to_chat(M, "<font color='red'><b> 你被[user]莫名其妙地封禁了！<b></font>")
	to_chat(user, "<font color='red'> 你<b>封禁</b>了[M]！</font>")


/*
 * Classic Baton
 */
/obj/item/weapon/classic_baton
	name = "警棍"
	desc = "用于殴打犯罪败类的木制警棍。"
	icon = 'icons/obj/items/weapons/weapons.dmi'
	icon_state = "baton"
	item_state = "classic_baton"
	flags_equip_slot = SLOT_WAIST
	force = MELEE_FORCE_NORMAL

/obj/item/weapon/classic_baton/attack(mob/M as mob, mob/living/user as mob)
	if(!..())
		return

	if(M.stuttering < 8)
		M.stuttering = 8

	user.visible_message(SPAN_DANGER("<B>[user]用[src]殴打了[M]！</B>"), SPAN_DANGER("你听见有人倒地的声音。"))

//Telescopic baton
/obj/item/weapon/telebaton
	name = "伸缩警棍"
	desc = "结构紧凑、配重经过调整的个人防卫武器。收拢后便于隐藏。使用伤害意图以外的意图攻击人类时，可将其击倒。"
	icon = 'icons/obj/items/weapons/weapons.dmi'
	icon_state = "telebaton_0"
	item_state = "telebaton_0"
	flags_equip_slot = SLOT_WAIST
	w_class = SIZE_SMALL
	force = MELEE_FORCE_WEAK
	var/on = 0
	var/stun_force = 10

/obj/item/weapon/telebaton/attack(mob/living/carbon/human/target, mob/living/user)
	if(!istype(target) || !on)
		return ..()
	if(user.a_intent == INTENT_HARM || isspeciesyautja(target) || user == target)
		return ..()
	else
		stun(target, user)

/obj/item/weapon/telebaton/attack_self(mob/user as mob)
	..()

	on = !on
	if(on)
		user.visible_message(SPAN_DANGER("[user]手腕一抖，甩开了[src]。"),\
		SPAN_DANGER("你展开了[src]。"),\
		"你听见一声不祥的咔嗒声。")
		icon_state = "telebaton_1"
		item_state = "telebaton_1"
		w_class = SIZE_MEDIUM
		force = MELEE_FORCE_VERY_STRONG
		stun_force = 40
		attack_verb = list("拍击", "击打", "拍打", "殴打")
	else
		user.visible_message(SPAN_NOTICE("[user]动作娴熟而流畅地收起了[src]。"),\
		SPAN_NOTICE("你收起了[src]。"),\
		"你听见一声咔嗒声。")
		icon_state = "telebaton_0"
		item_state = "telebaton_0"
		w_class = SIZE_SMALL
		force = MELEE_FORCE_WEAK
		stun_force = initial(stun_force)
		attack_verb = list("击打", "冲击")

	if(istype(user,/mob/living/carbon/human))
		var/mob/living/carbon/human/H = user
		H.update_inv_l_hand(0)
		H.update_inv_r_hand()

	playsound(user, 'sound/weapons/gun_empty.ogg', 25, sound_range = 5)
	add_fingerprint(user)

	if(blood_overlay && blood_color)
		overlays.Cut()
		add_blood(blood_color)
	return

/obj/item/weapon/telebaton/proc/stun(mob/living/carbon/human/target, mob/living/user)
	if(target.check_shields(src, 0, "[user]'s [name]"))
		return FALSE
	// Visuals and sound
	playsound(target, 'sound/weapons/baton.ogg', 50, TRUE, 7)
	user.animation_attack_on(target)
	user.flick_attack_overlay(target, "punch")
	log_interact(user, target, "[key_name(user)] stunned [key_name(target)] with \the [src]")
	// Hit 'em
	var/final_stun_force = stun_force
	var/datum/skills/user_skills = user.skills
	if(user_skills)
		switch(user_skills.get_skill_level(SKILL_POLICE))
			if(SKILL_POLICE_FLASH)
				final_stun_force *= 1.5
			if(SKILL_POLICE_SKILLED)
				final_stun_force *= 3

	var/target_zone = check_zone(user.zone_selected)
	target.apply_stamina_damage(final_stun_force, target_zone, ARMOR_MELEE)
	if(target.stamina.current_stamina <= 0)
		user.visible_message(SPAN_DANGER("[user]用[src]击倒了[target]！"),\
							SPAN_WARNING("你用[src]击倒了[target]！"))
	else
		user.visible_message(SPAN_DANGER("[user]用[src]重击了[target]！"),\
							SPAN_WARNING("你用[src]殴打了[target]！"))
	return TRUE

/*
 * Energy Shield
 */
/obj/item/weapon/shield/energy/IsShield()
	return active

/obj/item/weapon/shield/energy/attack_self(mob/living/user)
	..()

	active = !active
	if (active)
		force = 10
		icon_state = "eshield[active]"
		w_class = SIZE_LARGE
		playsound(user, 'sound/weapons/saberon.ogg', 25, 1)
		to_chat(user, SPAN_NOTICE("[src]现已启动。"))

	else
		force = 3
		icon_state = "eshield[active]"
		w_class = SIZE_TINY
		playsound(user, 'sound/weapons/saberoff.ogg', 25, 1)
		to_chat(user, SPAN_NOTICE("现在可以将[src]藏起来了。"))

	if(istype(user,/mob/living/carbon/human))
		var/mob/living/carbon/human/H = user
		H.update_inv_l_hand(0)
		H.update_inv_r_hand()

	add_fingerprint(user)
	return
