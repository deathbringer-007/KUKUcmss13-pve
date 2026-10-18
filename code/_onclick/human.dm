
/*
	Humans:
	Adds an exception for gloves, to allow special glove types like the ninja ones.

	Otherwise pretty standard.
*/

#define HANDLE_CLICK_PASS_THRU -1
#define HANDLE_CLICK_UNHANDLED 0
#define HANDLE_CLICK_HANDLED 1


/mob/living/carbon/human/click(atom/A, list/mods)
	var/use_ability = FALSE
	switch(get_ability_mouse_key())
		if(XENO_ABILITY_CLICK_SHIFT)
			if(mods[SHIFT_CLICK] && mods[LEFT_CLICK])
				use_ability = TRUE
		if(XENO_ABILITY_CLICK_MIDDLE)
			if(mods[MIDDLE_CLICK] && !mods[SHIFT_CLICK])
				use_ability = TRUE
		if(XENO_ABILITY_CLICK_RIGHT)
			if(mods[RIGHT_CLICK])
				use_ability = TRUE

	if(selected_ability && use_ability)
		selected_ability.use_ability(A)
		return TRUE

	if(interactee)
		var/result = interactee.handle_click(src, A, mods)
		if(result != HANDLE_CLICK_PASS_THRU)
			return result

	if (mods[MIDDLE_CLICK] && !mods[SHIFT_CLICK] && ishuman(A) && get_dist(src, A) <= 1)
		var/mob/living/carbon/human/H = A
		H.receive_from(src)
		return TRUE

	return ..()

/mob/living/carbon/human/RestrainedClickOn(atom/A) //chewing your handcuffs
	if (A != src) return ..()
	var/mob/living/carbon/human/H = A

	if (last_chew + 1 > world.time)
		to_chat(H, SPAN_DANGER("你暂时还不能再次咬自己的手……"))
		return


	if (!H.handcuffed) return
	if (H.a_intent != INTENT_HARM) return
	if (H.zone_selected != "mouth") return
	if (H.wear_mask) return
	if (istype(H.wear_suit, /obj/item/clothing/suit/straight_jacket)) return

	var/obj/limb/O = H.get_limb(H.hand?"l_hand":"r_hand")
	if (!O) return

	var/s = SPAN_DANGER("[H.name] 咬着自己的[O.display_name]！")
	H.visible_message(s, SPAN_DANGER("你咬着自己的[O.display_name]！"),null, null, CHAT_TYPE_FLUFF_ACTION)
	H.attack_log += text("\[[time_stamp()]\] <font color='red'>[s] [key_name(H)]</font>")
	log_attack("[s] [key_name(H)]")

	if(O.take_damage(1,0,1,1,"teeth marks"))
		H.UpdateDamageIcon()

	last_chew = world.time

/mob/living/carbon/human/UnarmedAttack(atom/A, proximity, click_parameters)

	if(body_position == LYING_DOWN) //No attacks while laying down
		return 0

	var/obj/item/clothing/gloves/G = gloves // not typecast specifically enough in defines

	// Special glove functions:
	// If the gloves do anything, have them return 1 to stop
	// normal attack_hand() here.
	if(proximity && istype(G) && G.Touch(A, 1))
		return

	var/obj/limb/temp = get_limb(hand ? "l_hand" : "r_hand")
	if(temp && !temp.is_usable())
		to_chat(src, SPAN_NOTICE("你试图移动[temp.display_name]，却做不到！"))
		return

	if(SEND_SIGNAL(A, COMSIG_ATOM_BEFORE_HUMAN_ATTACK_HAND, src, click_parameters) & COMPONENT_CANCEL_HUMAN_ATTACK_HAND)
		return

	SEND_SIGNAL(src, COMSIG_HUMAN_UNARMED_ATTACK, A)
	A.attack_hand(src, click_parameters)

/datum/proc/handle_click(mob/living/carbon/human/user, atom/A, params) //Heres our handle click relay proc thing.
	return HANDLE_CLICK_PASS_THRU

/atom/proc/attack_hand(mob/user)
	SEND_SIGNAL(src, COMSIG_ATOM_ATTACK_HAND, user)
	return

/mob/living/carbon/human/MouseDrop_T(atom/dropping, mob/living/user)
	if(user != src)
		return . = ..()

	if(isxeno(dropping))
		var/mob/living/carbon/xenomorph/xeno = dropping
		if(xeno.back)
			var/obj/item/back_item = xeno.back
			if(xeno.stat != DEAD) // If the Xeno is alive, fight back
				var/mob/living/carbon/carbon_user = user
				if(!carbon_user || !carbon_user.ally_of_hivenumber(xeno.hivenumber))
					carbon_user.KnockDown(rand(xeno.caste.tacklestrength_min, xeno.caste.tacklestrength_max))
					playsound(user.loc, 'sound/weapons/pierce.ogg', 25, TRUE)
					user.visible_message(SPAN_WARNING("\The [user] 试图解开固定在 [xeno] 身上的 \the [back_item]，却被一记扫尾击中了头部！"))
					return
			if(user.get_active_hand())
				to_chat(user, SPAN_WARNING("你双手都拿着东西，无法从 [xeno] 身上解下 \the [back_item]。"))
				return
			user.visible_message(SPAN_NOTICE("\The [user] 开始从 [xeno] 身上解下 \the [back_item]。"), \
			SPAN_NOTICE("你开始从 [xeno] 身上解下 \the [back_item]。"), null, 5, CHAT_TYPE_FLUFF_ACTION)
			if(!do_after(user, HUMAN_STRIP_DELAY * user.get_skill_duration_multiplier(SKILL_CQC), INTERRUPT_ALL, BUSY_ICON_GENERIC, xeno, INTERRUPT_MOVED, BUSY_ICON_GENERIC))
				to_chat(user, SPAN_WARNING("你的操作被打断了！"))
				return

			if(user.get_active_hand())
				return
			if(!user.Adjacent(xeno))
				return
			xeno.drop_inv_item_on_ground(back_item)
			if(!back_item || QDELETED(back_item)) //Might be self-deleted?
				return
			user.put_in_active_hand(back_item)
			return

	if(pulling != dropping || grab_level != GRAB_AGGRESSIVE || !ishuman(dropping) || !(a_intent & INTENT_GRAB))
		return . = ..()

	var/carry_delay = 3 SECONDS
	var/list/carrydata = list("carry_delay" = carry_delay)
	var/signal_flags = SEND_SIGNAL(user, COMSIG_HUMAN_CARRY, carrydata)
	carry_delay = carrydata["carry_delay"]

	if(!skillcheck(src, SKILL_FIREMAN, SKILL_FIREMAN_TRAINED) && !(signal_flags & COMPONENT_CARRY_ALLOW)) // Checking if they have fireman carry as a skill.
		to_chat(src, SPAN_WARNING("你没有接受过背负人员的训练！"))
		return . = ..()

	var/mob/living/carbon/human/target = dropping

	user.visible_message(SPAN_WARNING("[src] 开始把 [target] 背到背上。"),\
	SPAN_WARNING("你开始把 [target] 背到背上。"))

	if(!do_after(src, carry_delay * get_skill_duration_multiplier(SKILL_FIREMAN), INTERRUPT_ALL, BUSY_ICON_HOSTILE, pulling, INTERRUPT_MOVED, BUSY_ICON_HOSTILE))
		return

	user.visible_message(SPAN_WARNING("[src] 把 [target] 背到了背上。"),\
	SPAN_WARNING("你把 [target] 背到了背上。"))

	if(pulling != dropping || !dropping || QDELETED(dropping))
		return . = ..()

	grab_level = GRAB_CARRY

	target.Move(user.loc, get_dir(target.loc, user.loc))
	target.update_transform(TRUE)


