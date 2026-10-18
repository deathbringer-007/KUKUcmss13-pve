/mob/living/carbon/Initialize()
	. = ..()
	hunter_data = new /datum/huntdata
	hunter_data.name = "[src.real_name]'s Hunter Data"
	hunter_data.owner = src

/mob/living/carbon/Life(delta_time)
	..()

	handle_fire() //Check if we're on fire
	if(SSweather.is_weather_event)
		handle_weather(delta_time)

	if(stat != CONSCIOUS)
		remove_all_indicators()

/mob/living/carbon/Destroy()
	stomach_contents?.Cut()
	view_change_sources = null
	active_transfusions = null
	. = ..()

	QDEL_NULL_LIST(internal_organs)
	QDEL_NULL(handcuffed)
	QDEL_NULL(legcuffed)
	QDEL_NULL(halitem)

	hunter_data?.clean_data()
	hunter_data = null
	halimage = null
	halbody = null


/mob/living/carbon/Move(NewLoc, direct)
	. = ..()
	if(.)
		if(nutrition && stat != DEAD)
			nutrition -= HUNGER_FACTOR/5

/mob/living/carbon/relaymove(mob/user, direction)
	if(user.is_mob_incapacitated(TRUE)) return
	if(user in src.stomach_contents)
		if(user.client)
			user.client.next_movement = world.time + 20
		if(prob(30))
			for(var/mob/M in hearers(4, src))
				if(M.client)
					M.show_message(SPAN_DANGER("你听见[src]的肚子里传来一阵响动……"), SHOW_MESSAGE_AUDIBLE)
		var/obj/item/I = user.get_active_hand()
		if(I && I.force)
			var/d = rand(floor(I.force / 4), I.force)
			if(istype(src, /mob/living/carbon/human))
				var/mob/living/carbon/human/H = src
				var/organ = H.get_limb("chest")
				if(istype(organ, /obj/limb))
					var/obj/limb/temp = organ
					if(temp.take_damage(d, 0))
						H.UpdateDamageIcon()
				H.updatehealth()
			else
				src.take_limb_damage(d)
			for(var/mob/M as anything in viewers(user, null))
				if(M.client)
					M.show_message(text(SPAN_DANGER("<B>[user]用[I.name]攻击[src]的胃壁！</B>")), SHOW_MESSAGE_AUDIBLE)
			user.track_hit(initial(I.name))
			playsound(user.loc, 'sound/effects/attackblob.ogg', 25, 1)

			if(prob(max(4*(100*getBruteLoss()/maxHealth - 75),0))) //4% at 24% health, 80% at 5% health
				last_damage_data = create_cause_data("chestbursting", user)
				gib(last_damage_data)
	else if(!chestburst && (status_flags & XENO_HOST) && islarva(user))
		var/mob/living/carbon/xenomorph/larva/L = user
		L.chest_burst(src)

/mob/living/carbon/ex_act(severity, direction, datum/cause_data/cause_data)

	if(body_position == LYING_DOWN && direction)
		severity *= EXPLOSION_PRONE_MULTIPLIER

	if(severity >= 30)
		flash_eyes()

	last_damage_data = istype(cause_data) ? cause_data : create_cause_data(cause_data)

	if(severity >= health && severity >= EXPLOSION_THRESHOLD_GIB)
		gib(last_damage_data)
		return

	apply_damage(severity, BRUTE)
	updatehealth()

	var/knock_value = min( round( severity*0.1 ,1) ,10)
	if(knock_value > 0)
		apply_effect(knock_value, PARALYZE)
		explosion_throw(severity, direction)

/mob/living/carbon/gib(datum/cause_data/cause = create_cause_data("gibbing", src))
	if(legcuffed)
		drop_inv_item_on_ground(legcuffed)

	for(var/atom/movable/A in stomach_contents)
		stomach_contents.Remove(A)
		A.forceMove(get_turf(loc))
		A.acid_damage = 0 //Reset the acid damage
		if(ismob(A))
			visible_message(SPAN_DANGER("[A]从[src]体内破体而出！"))

	for(var/atom/movable/A in contents_recursive())
		if(isobj(A))
			var/obj/O = A
			if(O.unacidable)
				O.forceMove(get_turf(loc))
				O.throw_atom(pick(range(1, get_turf(loc))), 1, SPEED_FAST)

	. = ..(cause)

/mob/living/carbon/revive()
	if(handcuffed && !initial(handcuffed))
		drop_inv_item_on_ground(handcuffed)
	handcuffed = initial(handcuffed)

	if(legcuffed && !initial(legcuffed))
		drop_inv_item_on_ground(legcuffed)
	legcuffed = initial(legcuffed)
	recalculate_move_delay = TRUE
	..()

/mob/living/carbon/human/attackby(obj/item/W, mob/living/user)
	if(user.mob_flags & SURGERY_MODE_ON)
		switch(user.a_intent)
			if(INTENT_HELP)
				//Attempt to dig shrapnel first, if any. dig_out_shrapnel_check() will fail if user is not human, which may be possible in future.
				if(W.flags_item & CAN_DIG_SHRAPNEL && (locate(/obj/item/shard) in src.embedded_items) && W.dig_out_shrapnel_check(src, user))
					return TRUE
				var/datum/surgery/current_surgery = active_surgeries[user.zone_selected]
				if(current_surgery)
					if(current_surgery.attempt_next_step(user, W))
						return TRUE //Cancel attack.
				else
					var/obj/limb/affecting = get_limb(check_zone(user.zone_selected))
					if(initiate_surgery_moment(W, src, affecting, user))
						return TRUE

			if(INTENT_DISARM) //Same as help but without the shrapnel dig attempt.
				var/datum/surgery/current_surgery = active_surgeries[user.zone_selected]
				if(current_surgery)
					if(current_surgery.attempt_next_step(user, W))
						return TRUE
				else
					var/obj/limb/affecting = get_limb(check_zone(user.zone_selected))
					if(initiate_surgery_moment(W, src, affecting, user))
						return TRUE

	else if(W.flags_item & CAN_DIG_SHRAPNEL && W.dig_out_shrapnel_check(src, user))
		return TRUE

	. = ..()

/mob/living/carbon/attack_hand(mob/M as mob)
	if(!istype(M, /mob/living/carbon)) return

	if(M.mob_flags & SURGERY_MODE_ON && M.a_intent & (INTENT_HELP|INTENT_DISARM))
		var/datum/surgery/current_surgery = active_surgeries[M.zone_selected]
		if(current_surgery)
			if(current_surgery.attempt_next_step(M, null))
				return TRUE
		else
			var/obj/limb/affecting = get_limb(check_zone(M.zone_selected))
			if(affecting && initiate_surgery_moment(null, src, affecting, M))
				return TRUE

	for(var/datum/disease/D in viruses)
		if(D.spread_by_touch())
			M.contract_disease(D, 0, 1, CONTACT_HANDS)

	for(var/datum/disease/D in M.viruses)
		if(D.spread_by_touch())
			contract_disease(D, 0, 1, CONTACT_HANDS)

	M.next_move += 7 //Adds some lag to the 'attack'. Adds up to 11 in combination with click_adjacent.
	return

/mob/living/carbon/electrocute_act(shock_damage, obj/source, siemens_coeff = 1.0, def_zone = null)
	if(status_flags & GODMODE) //godmode
		return FALSE
	shock_damage *= siemens_coeff
	if(shock_damage<1)
		return FALSE

	src.apply_damage(shock_damage, BURN, def_zone, used_weapon="Electrocution")

	playsound(loc, "sparks", 25, 1)
	if(shock_damage > 10)
		src.visible_message(
			SPAN_DANGER("[source]电击了[src]！"), \
			SPAN_DANGER("<B>你感到一股强烈电流贯穿全身！</B>"), \
			SPAN_DANGER("你听见沉重的电击爆响。") \
		)
		if(isxeno(src) && mob_size >= MOB_SIZE_BIG)
			apply_effect(1, STUN)//Sadly, something has to stop them from bumping them 10 times in a second
			apply_effect(1, WEAKEN)
		else
			apply_effect(3, STUN)//This should work for now, more is really silly and makes you lay there forever
			apply_effect(3, WEAKEN)

		count_niche_stat(STATISTICS_NICHE_SHOCK)

	else
		src.visible_message(
			SPAN_DANGER("[source]轻微电击了[src]。"), \
			SPAN_DANGER("你感到一股微弱电流贯穿全身。"), \
			SPAN_DANGER("你听见轻微的电击声。") \
		)

	var/datum/effect_system/spark_spread/s = new /datum/effect_system/spark_spread
	s.set_up(5, 1, loc)
	s.start()

	return shock_damage


/mob/living/carbon/swap_hand()
	var/obj/item/wielded_item = get_active_hand()
	if(wielded_item && (wielded_item.flags_item & WIELDED)) //this segment checks if the item in your hand is twohanded.
		var/obj/item/weapon/twohanded/offhand/offhand = get_inactive_hand()
		if(offhand && (offhand.flags_item & WIELDED))
			to_chat(src, SPAN_WARNING("你的另一只手正忙于握着[offhand.name]。")) //So it's an offhand.
			return
		else
			wielded_item.unwield(src) //Get rid of it.
	if(wielded_item && wielded_item.zoom) //Adding this here while we're at it
		wielded_item.zoom(src)
	..()
	if(hud_used.l_hand_hud_object && hud_used.r_hand_hud_object)
		if(hand) //This being 1 means the left hand is in use
			hud_used.l_hand_hud_object.icon_state = "hand_active"
			hud_used.r_hand_hud_object.icon_state = "hand_inactive"
		else
			hud_used.l_hand_hud_object.icon_state = "hand_inactive"
			hud_used.r_hand_hud_object.icon_state = "hand_active"
	if(l_hand)
		l_hand.hands_swapped(src)
	if(r_hand)
		r_hand.hands_swapped(src)
	return

/mob/living/carbon/proc/activate_hand(selhand) //0 or "r" or "right" for right hand; 1 or "l" or "left" for left hand.

	if(istext(selhand))
		selhand = lowertext(selhand)

		if(selhand == "right" || selhand == "r")
			selhand = 0
		if(selhand == "left" || selhand == "l")
			selhand = 1

	if(selhand != src.hand)
		swap_hand()

/mob/living/carbon/proc/help_shake_act(mob/living/carbon/M)
	if(src == M)
		return
	var/t_him = gender == MALE ? "他" : (gender == FEMALE ? "她" : "其")

	var/shake_action
	if(stat == DEAD || HAS_TRAIT(src, TRAIT_INCAPACITATED) || sleeping) // incap implies also unconscious or knockedout
		shake_action = "将[t_him]唤醒！"
	else if(HAS_TRAIT(src, TRAIT_FLOORED))
		shake_action = "扶[t_him]起来！"

	if(shake_action) // We are incapacitated in some fashion
		if(client)
			sleeping = max(0,sleeping-5)
		M.visible_message(SPAN_NOTICE("[M]摇晃[src]，试图[shake_action]"), \
			SPAN_NOTICE("你摇晃[src]，试图[shake_action]"), null, 4)

	else if(body_position == LYING_DOWN) // We're just chilling on the ground, let us be
		M.visible_message(SPAN_NOTICE("[M]盯着躺在地上的[src]，不耐烦地挥手。"), \
			SPAN_NOTICE("你盯着就这么躺在地上的[src]，挥了挥手。"), null, 4)

	else
		var/mob/living/carbon/human/H = M
		if(istype(H))
			H.species.hug(H, src, H.zone_selected)
		else
			M.visible_message(SPAN_NOTICE("[M]拍了拍[src]的背，试图让[t_him]好受一些！"), \
				SPAN_NOTICE("你拍了拍[src]的背，试图让[t_him]好受一些！"), null, 4)
			playsound(loc, 'sound/weapons/thudswoosh.ogg', 25, 1, 5)
		return

	adjust_effect(-6, PARALYZE)
	adjust_effect(-6, STUN)
	adjust_effect(-6, WEAKEN)

	playsound(loc, 'sound/weapons/thudswoosh.ogg', 25, 1, 5)


//Throwing stuff

/mob/living/carbon/toggle_normal_throw()
	if(!stat && isturf(loc) && !is_mob_restrained())
		toggle_throw_mode(THROW_MODE_NORMAL)

/mob/living/carbon/toggle_high_toss()
	if(!stat && isturf(loc) && !is_mob_restrained())
		toggle_throw_mode(THROW_MODE_HIGH)

/mob/living/carbon/proc/toggle_throw_mode(type)
	if(type == THROW_MODE_OFF || throw_mode == type)
		throw_mode = THROW_MODE_OFF
		if(hud_used && hud_used.throw_icon)
			hud_used.throw_icon.icon_state = "act_throw_off"
		return

	throw_mode = type
	if(!hud_used || !hud_used.throw_icon)
		return

	if(type == THROW_MODE_NORMAL)
		hud_used.throw_icon.icon_state = "act_throw_normal"
	else
		hud_used.throw_icon.icon_state = "act_throw_high"

/mob/proc/throw_item(atom/target)
	return

/mob/living/carbon/throw_item(atom/target)
	var/throw_type = throw_mode
	toggle_throw_mode(THROW_MODE_OFF) // This MUST be at the beginning, or else players will not recognize that throw is not toggled on (especially xenos)

	if(is_ventcrawling) //NOPE
		return
	if(stat || !target)
		return
	if(!istype(loc, /turf)) // In some mob/object (i.e. devoured or tank)
		to_chat(src, SPAN_WARNING("你在[loc.name]里面，无法投掷任何东西。"))
		return
	if(target.type == /atom/movable/screen)
		return

	var/atom/movable/thrown_thing
	var/obj/item/I = get_active_hand()

	if(!I || (I.flags_item & NODROP))
		return

	var/spin_throw = TRUE

	if(istype(I, /obj/item/grab))
		var/obj/item/grab/G = I
		if(ismob(G.grabbed_thing))
			if(grab_level >= GRAB_CARRY) // Carry and choke can only throw
				var/mob/living/M = G.grabbed_thing
				spin_throw = FALSE //thrown mobs don't spin
				thrown_thing = M
				var/turf/start_T = get_turf(loc) //Get the start and target tile for the descriptors
				var/turf/end_T = get_turf(target)
				if(start_T && end_T)
					var/start_T_descriptor = "<font color='#6b5d00'>tile at [start_T.x], [start_T.y], [start_T.z] in area [get_area(start_T)]</font>"
					var/end_T_descriptor = "<font color='#6b4400'>tile at [end_T.x], [end_T.y], [end_T.z] in area [get_area(end_T)]</font>"

					M.attack_log += "\[[time_stamp()]\] <font color='orange'>Has been thrown by [key_name(usr)] from [start_T_descriptor] with the target [end_T_descriptor]</font>"
					usr.attack_log += "\[[time_stamp()]\] <font color='red'>Has thrown [key_name(M)] from [start_T_descriptor] with the target [end_T_descriptor]</font>"
					msg_admin_attack("[key_name(usr)] has thrown [key_name(M)] from [start_T_descriptor] with the target [end_T_descriptor] in [get_area(src)] ([src.loc.x],[src.loc.y],[src.loc.z]).", src.loc.x, src.loc.y, src.loc.z)
			else
				to_chat(src, SPAN_WARNING("你需要抓得更牢！"))

	else //real item in hand, not a grab
		thrown_thing = I



	//actually throw it!
	if(thrown_thing)

		if(!(thrown_thing.try_to_throw(src)))
			return
		visible_message(SPAN_WARNING("[src]扔出了[thrown_thing]。"), null, null, 5)

		if(!lastarea)
			lastarea = get_area(src.loc)
		if(istype(loc, /turf/open/space))
			inertia_dir = get_dir(target, src)
			step(src, inertia_dir)

		if(throw_type == THROW_MODE_HIGH)
			to_chat(src, SPAN_NOTICE("你准备进行高抛。"))
			if(!do_after(src, 1 SECONDS, INTERRUPT_ALL, BUSY_ICON_HOSTILE))
				to_chat(src, SPAN_WARNING("你需要先准备高抛动作！"))
				return
			drop_inv_item_on_ground(I, TRUE)
			thrown_thing.throw_atom(target, thrown_thing.throw_range, SPEED_SLOW, src, spin_throw, HIGH_LAUNCH)
		else
			drop_inv_item_on_ground(I, TRUE)
			thrown_thing.throw_atom(target, thrown_thing.throw_range, thrown_thing.throw_speed, src, spin_throw)

/mob/living/carbon/fire_act(exposed_temperature, exposed_volume)
	..()
	bodytemperature = max(bodytemperature, BODYTEMP_HEAT_DAMAGE_LIMIT+10)
	recalculate_move_delay = TRUE

/**
 * Called by [/mob/dead/observer/proc/do_observe] when a carbon mob is observed by a ghost with [/datum/preferences/var/auto_observe] enabled.
 *
 * Any HUD changes past this point are handled by [/mob/dead/observer/proc/observe_target_screen_add]
 * and [/mob/dead/observer/proc/observe_target_screen_remove].
 *
 * Override on subtype mobs if they have any extra HUD elements/behaviour.
 */
/mob/living/carbon/proc/auto_observed(mob/dead/observer/observer)
	SHOULD_CALL_PARENT(TRUE)

	LAZYINITLIST(observers)
	observers |= observer
	hud_used.show_hud(hud_used.hud_version, observer)

	// Add the player's action buttons (not the actions themselves) to the observer's screen.
	for(var/datum/action/action as anything in actions)
		// Skip any hidden ones (of course).
		if(action.hidden || action.player_hidden)
			continue

		observer.client.add_to_screen(action.button)

//generates realistic-ish pulse output based on preset levels
/mob/living/carbon/proc/get_pulse(method) //method 0 is for hands, 1 is for machines, more accurate
	var/temp = 0 //see setup.dm:694
	switch(src.pulse)
		if(PULSE_NONE)
			return "0"
		if(PULSE_SLOW)
			temp = rand(40, 60)
			return num2text(method ? temp : temp + rand(-10, 10))
		if(PULSE_NORM)
			temp = rand(60, 90)
			return num2text(method ? temp : temp + rand(-10, 10))
		if(PULSE_FAST)
			temp = rand(90, 120)
			return num2text(method ? temp : temp + rand(-10, 10))
		if(PULSE_2FAST)
			temp = rand(120, 160)
			return num2text(method ? temp : temp + rand(-10, 10))
		if(PULSE_THREADY)
			return method ? ">250" : "extremely weak and fast, patient's artery feels like a thread"
// output for machines^ ^^^^^^^output for people^^^^^^^^^

/mob/living/carbon/verb/mob_sleep()
	set name = "Sleep"
	set category = "IC"

	if(sleeping)
		to_chat(usr, SPAN_DANGER("你已经在睡觉了。"))
		return
	if(alert(src,"确定要睡一会儿吗？","睡觉","Yes","No") == "Yes")
		sleeping = 20 //Short nap


/mob/living/carbon/Collide(atom/movable/AM)
	if(now_pushing)
		return
	. = ..()

/mob/living/carbon/slip(slip_source_name, stun_level, weaken_level, run_only, override_noslip, slide_steps)
	set waitfor = 0
	if(buckled) return FALSE //can't slip while buckled
	if(body_position != STANDING_UP) return FALSE //can't slip if already lying down.
	stop_pulling()
	to_chat(src, SPAN_WARNING("你在[slip_source_name? slip_source_name : "地板"]上滑倒了！"))
	playsound(src.loc, 'sound/misc/slip.ogg', 25, 1)
	apply_effect(stun_level, STUN)
	apply_effect(weaken_level, WEAKEN)
	. = TRUE
	if(slide_steps && HAS_TRAIT(src, TRAIT_FLOORED))//lying check to make sure we downed the mob
		var/slide_dir = dir
		for(var/i=1, i<=slide_steps, i++)
			step(src, slide_dir)
			sleep(2)
			if(!HAS_TRAIT(src, TRAIT_FLOORED)) // just watch this break in the most horrible way possible
				break



/mob/living/carbon/on_stored_atom_del(atom/movable/AM)
	..()
	if(length(stomach_contents) && ismob(AM))
		for(var/X in stomach_contents)
			if(AM == X)
				stomach_contents -= AM
				break

/mob/living/carbon/proc/extinguish_mob(mob/living/carbon/C)
	adjust_fire_stacks(-5, min_stacks = 0)
	playsound(src.loc, 'sound/weapons/thudswoosh.ogg', 25, 1, 7)
	C.visible_message(SPAN_DANGER("[C]试图扑灭[src]身上的火！"), \
	SPAN_WARNING("你试图扑灭[src]身上的火！"), null, 5)
	if(fire_stacks <= 0)
		C.visible_message(SPAN_DANGER("[C]成功扑灭了[src]身上的火！"), \
		SPAN_NOTICE("你扑灭了[src]身上的火。"), null, 5)

/mob/living/carbon/resist_buckle()

	if(handcuffed)
		next_move = world.time + 100
		last_special = world.time + 100
		visible_message(SPAN_DANGER("<B>[src]试图解开自身束缚！</B>"),\
		SPAN_DANGER("你试图解开自身束缚。（大约需要2分钟，期间必须保持不动）"))
		if(do_after(src, 1200, INTERRUPT_NO_FLOORED^INTERRUPT_RESIST, BUSY_ICON_HOSTILE))
			if(!buckled)
				return
			visible_message(SPAN_DANGER("<B>[src]成功解开了自身束缚！</B>"),\
						SPAN_NOTICE("你成功解开了自身束缚。"))
			buckled.manual_unbuckle(src)
	else
		buckled.manual_unbuckle(src)

/mob/living/carbon/get_examine_text(mob/user)
	. = ..()
	if(isyautja(user))
		. += SPAN_BLUE("[src]价值[max(life_kills_total, default_honor_value)]点荣誉。")
		if(src.hunter_data.hunted)
			. += SPAN_ORANGE("[src]正在被[src.hunter_data.hunter.real_name]猎杀。")

		if(src.hunter_data.dishonored)
			. += SPAN_RED("[src]因“[src.hunter_data.dishonored_reason]”被标记为不名誉猎物。")
		else if(src.hunter_data.honored)
			. += SPAN_GREEN("[src]因“[src.hunter_data.honored_reason]”获得了荣誉认可。")

		if(src.hunter_data.thralled)
			. += SPAN_GREEN("[src]被[src.hunter_data.thralled_set.real_name]收为仆从，理由是“[src.hunter_data.thralled_reason]”。")
		else if(src.hunter_data.gear)
			. += SPAN_RED("[src]被[src.hunter_data.gear_set]标记为携带铁血装备。")


/mob/living/carbon/on_lying_down(new_lying_angle)
	. = ..()
	if(!buckled || buckled.buckle_lying != 0)
		lying_angle_on_lying_down(new_lying_angle)


/// Special carbon interaction on lying down, to transform its sprite by a rotation.
/mob/living/carbon/proc/lying_angle_on_lying_down(new_lying_angle)
	if(!new_lying_angle)
		set_lying_angle(pick(90, 270))
	else
		set_lying_angle(new_lying_angle)
