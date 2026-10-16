
/datum/action/xeno_action/activable/pounce/crusher_charge/additional_effects_always()
	var/mob/living/carbon/xenomorph/X = owner
	if (!istype(X))
		return

	for (var/mob/living/carbon/H in orange(1, get_turf(X)))
		if(X.can_not_harm(H))
			continue

		new /datum/effects/xeno_slow(H, X, null, null, 3.5 SECONDS)
		to_chat(H, SPAN_XENODANGER("[X]的冲击震动了地面，让你慢了下来！"))

/datum/action/xeno_action/activable/pounce/crusher_charge/additional_effects(mob/living/L)
	if (!isxeno_human(L))
		return

	var/mob/living/carbon/H = L
	if (H.stat == DEAD)
		return

	var/mob/living/carbon/xenomorph/X = owner
	if (!istype(X))
		return

	X.emote("roar")
	L.apply_effect(2, WEAKEN)
	X.visible_message(SPAN_XENODANGER("[X]冲过[H]，将其残忍地践踏在脚下！"), SPAN_XENODANGER("我们将[H]踩在脚下，残忍碾压！"))

	H.apply_armoured_damage(get_xeno_damage_slash(H, direct_hit_damage), ARMOR_MELEE, BRUTE)
	X.throw_carbon(H, X.dir, 3)

	H.last_damage_data = create_cause_data(X.caste_type, X)
	return

/datum/action/xeno_action/activable/pounce/crusher_charge/pre_windup_effects()
	RegisterSignal(owner, COMSIG_XENO_PRE_CALCULATE_ARMOURED_DAMAGE_PROJECTILE, PROC_REF(check_directional_armor))

	var/mob/living/carbon/xenomorph/xeno_owner = owner
	if(!istype(xeno_owner))
		return

	var/datum/behavior_delegate/crusher_base/crusher_delegate = xeno_owner.behavior_delegate
	if(!istype(crusher_delegate))
		return

	crusher_delegate.is_charging = TRUE
	xeno_owner.update_icons()

/datum/action/xeno_action/activable/pounce/crusher_charge/post_windup_effects(interrupted)
	..()
	UnregisterSignal(owner, COMSIG_XENO_PRE_CALCULATE_ARMOURED_DAMAGE_PROJECTILE)
	var/mob/living/carbon/xenomorph/xeno_owner = owner
	if(!istype(xeno_owner))
		return

	var/datum/behavior_delegate/crusher_base/crusher_delegate = xeno_owner.behavior_delegate
	if(!istype(crusher_delegate))
		return

	addtimer(CALLBACK(src, PROC_REF(undo_charging_icon)), 0.5 SECONDS) // let the icon be here for a bit, it looks cool

/datum/action/xeno_action/activable/pounce/crusher_charge/proc/undo_charging_icon()
	var/mob/living/carbon/xenomorph/xeno_owner = owner
	if(!istype(xeno_owner))
		return

	var/datum/behavior_delegate/crusher_base/crusher_delegate = xeno_owner.behavior_delegate
	if(!istype(crusher_delegate))
		return

	crusher_delegate.is_charging = FALSE
	xeno_owner.update_icons()

/datum/action/xeno_action/activable/pounce/crusher_charge/proc/check_directional_armor(mob/living/carbon/xenomorph/X, list/damagedata)
	SIGNAL_HANDLER
	var/projectile_direction = damagedata["direction"]
	if(X.dir & REVERSE_DIR(projectile_direction))
		// During the charge windup, crusher gets an extra 15 directional armor in the direction its charging
		damagedata["armor"] += frontal_armor


// This ties the pounce/throwing backend into the old collision backend
/mob/living/carbon/xenomorph/crusher/pounced_obj(obj/O)
	var/datum/action/xeno_action/activable/pounce/crusher_charge/CCA = get_action(src, /datum/action/xeno_action/activable/pounce/crusher_charge)
	if (istype(CCA) && !CCA.action_cooldown_check() && !(O.type in CCA.not_reducing_objects))
		CCA.reduce_cooldown(50)

	gain_plasma(10)

	if (!handle_collision(O)) // Check old backend
		obj_launch_collision(O)

/mob/living/carbon/xenomorph/crusher/pounced_turf(turf/T)
	T.ex_act(EXPLOSION_THRESHOLD_VLOW, , create_cause_data(caste_type, src))
	..(T)

/datum/action/xeno_action/onclick/crusher_stomp/use_ability(atom/A)
	var/mob/living/carbon/xenomorph/xeno_owner = owner
	if (!istype(xeno_owner))
		return

	if (!action_cooldown_check())
		return

	if (!xeno_owner.check_state())
		return

	if (!check_and_use_plasma_owner())
		return

	playsound(get_turf(xeno_owner), 'sound/voice/alien_crusher_spawn.ogg', 75)
	apply_cooldown()

	ADD_TRAIT(xeno_owner, TRAIT_IMMOBILIZED, TRAIT_SOURCE_ABILITY("Stomp"))
	xeno_owner.anchored = TRUE

	if (!do_after(xeno_owner, windup_duration, INTERRUPT_NO_NEEDHAND, BUSY_ICON_HOSTILE))
		REMOVE_TRAIT(xeno_owner, TRAIT_IMMOBILIZED, TRAIT_SOURCE_ABILITY("Stomp"))
		xeno_owner.anchored = FALSE
		return

	REMOVE_TRAIT(xeno_owner, TRAIT_IMMOBILIZED, TRAIT_SOURCE_ABILITY("Stomp"))
	xeno_owner.anchored = FALSE

	playsound(get_turf(xeno_owner), 'sound/effects/alien_footstep_charge3.ogg', 75)
	xeno_owner.visible_message(SPAN_XENODANGER("[xeno_owner]猛击地面！"), SPAN_XENODANGER("我们猛击地面！"))
	xeno_owner.create_stomp()

	for(var/mob/living/carbon/carbon_in_range in range(distance, get_turf(xeno_owner)))
		if(xeno_owner.can_not_harm(carbon_in_range))
			continue

		var/distance_to_target = get_dist(carbon_in_range, xeno_owner)

		to_chat(carbon_in_range, SPAN_XENOHIGHDANGER("[xeno_owner]使你失去平衡，摔倒在地！"))
		shake_camera(carbon_in_range, (6 - distance_to_target), 2)

		var/weaken_time = 2.5 - (distance_to_target / 2)

		carbon_in_range.apply_effect(weaken_time, WEAKEN)

		if(distance_to_target == 0)
			carbon_in_range.apply_armoured_damage(damage, ARMOR_MELEE, BRUTE)
			carbon_in_range.last_damage_data = create_cause_data(xeno_owner.caste_type, xeno_owner)
			to_chat(carbon_in_range, SPAN_XENOHIGHDANGER("[xeno_owner]一脚踏在你身上，将你碾压！"))
			continue

		if(distance_to_target <= 2)
			INVOKE_ASYNC(xeno_owner, TYPE_PROC_REF(/mob/living/carbon/xenomorph, throw_carbon), carbon_in_range, get_dir(xeno_owner, carbon_in_range), (6 - (distance_to_target * 2)), FALSE)
			to_chat(carbon_in_range, SPAN_XENOHIGHDANGER("[xeno_owner]沉重的冲击将你甩飞！"))
			continue

	return ..()

/datum/action/xeno_action/onclick/crusher_shield/use_ability(atom/Target)
	var/mob/living/carbon/xenomorph/xeno = owner

	if (!istype(xeno))
		return

	if (!action_cooldown_check())
		return

	if (!xeno.check_state())
		return

	if (!check_and_use_plasma_owner())
		return

	xeno.visible_message(SPAN_XENOWARNING("[xeno]伏低身体，加强防御！"), SPAN_XENOHIGHDANGER("我们伏低身体，加强防御！"))
	button.icon_state = "template_active"

	xeno.create_crusher_shield()

	xeno.add_xeno_shield(shield_amount, XENO_SHIELD_SOURCE_CRUSHER, /datum/xeno_shield/crusher)
	xeno.overlay_shields()

	xeno.explosivearmor_modifier += 1000
	xeno.recalculate_armor()

	addtimer(CALLBACK(src, PROC_REF(remove_explosion_immunity)), 25, TIMER_UNIQUE|TIMER_OVERRIDE)
	addtimer(CALLBACK(src, PROC_REF(remove_shield)), 70, TIMER_UNIQUE|TIMER_OVERRIDE)

	apply_cooldown()
	return ..()

/datum/action/xeno_action/onclick/crusher_shield/proc/remove_explosion_immunity()
	var/mob/living/carbon/xenomorph/xeno = owner
	if (!istype(xeno))
		return

	xeno.explosivearmor_modifier -= 1000
	xeno.recalculate_armor()
	to_chat(xeno, SPAN_XENODANGER("我们对爆炸伤害的免疫结束了！"))

/datum/action/xeno_action/onclick/crusher_shield/proc/remove_shield()
	var/mob/living/carbon/xenomorph/xeno = owner
	if (!istype(xeno))
		return

	var/datum/xeno_shield/found
	for (var/datum/xeno_shield/shield in xeno.xeno_shields)
		if (shield.shield_source == XENO_SHIELD_SOURCE_CRUSHER)
			found = shield
			break

	if (istype(found))
		found.on_removal()
		qdel(found)
		to_chat(xeno, SPAN_XENOHIGHDANGER("我们感到强化护盾消退了！"))
		button.icon_state = "template"

	xeno.overlay_shields()

/datum/action/xeno_action/onclick/charger_charge/use_ability(atom/Target)
	var/mob/living/carbon/xenomorph/Xeno = owner

	activated = !activated
	var/will_charge = "[activated ? "会" : "不再"]"
	to_chat(Xeno, SPAN_XENONOTICE("我们移动时[will_charge]冲锋。"))
	if(activated)
		RegisterSignal(Xeno, COMSIG_MOVABLE_MOVED, PROC_REF(handle_movement))
		RegisterSignal(Xeno, COMSIG_LIVING_SET_BODY_POSITION, PROC_REF(handle_position_change))
		RegisterSignal(Xeno, COMSIG_ATOM_DIR_CHANGE, PROC_REF(handle_dir_change))
		RegisterSignal(Xeno, COMSIG_XENO_RECALCULATE_SPEED, PROC_REF(update_speed))
		RegisterSignal(Xeno, COMSIG_XENO_STOP_MOMENTUM, PROC_REF(stop_momentum))
		RegisterSignal(Xeno, COMSIG_MOVABLE_ENTERED_RIVER, PROC_REF(handle_river))
		RegisterSignal(Xeno, COMSIG_LIVING_PRE_COLLIDE, PROC_REF(handle_collision))
		RegisterSignal(Xeno, COMSIG_XENO_START_CHARGING, PROC_REF(start_charging))
		button.icon_state = "template_active"
	else
		stop_momentum()
		UnregisterSignal(Xeno, list(
			COMSIG_MOVABLE_MOVED,
			COMSIG_LIVING_SET_BODY_POSITION,
			COMSIG_ATOM_DIR_CHANGE,
			COMSIG_XENO_RECALCULATE_SPEED,
			COMSIG_MOVABLE_ENTERED_RIVER,
			COMSIG_LIVING_PRE_COLLIDE,
			COMSIG_XENO_STOP_MOMENTUM,
			COMSIG_XENO_START_CHARGING,
		))
		button.icon_state = "template"
	return ..()

/datum/action/xeno_action/activable/fling/charger/check_and_use_plasma_owner(plasma_to_use)
	if (!check_plasma_owner(plasma_to_use))
		return FALSE

	flick("Normal Crusher Charging", owner)
	use_plasma_owner(plasma_to_use)
	return TRUE

/datum/action/xeno_action/activable/tumble/use_ability(atom/Target)
	if(!action_cooldown_check())
		return
	var/mob/living/carbon/xenomorph/Xeno = owner
	if (!Xeno.check_state())
		return
	if(Xeno.plasma_stored <= plasma_cost)
		return
	var/target_dist = get_dist(Xeno, Target)
	var/dir_between = get_dir(Xeno, Target)
	var/target_dir
	for(var/perpen_dir in get_perpen_dir(Xeno.dir))
		if(dir_between & perpen_dir)
			target_dir = perpen_dir
			break

	if(!target_dir)
		return

	Xeno.visible_message(SPAN_XENOWARNING("[Xeno]向侧面翻滚！"), SPAN_XENOHIGHDANGER("我们向侧面翻滚！"))
	Xeno.spin(5,1) // note: This spins the sprite and DOES NOT affect directional armor
	var/start_charging = HAS_TRAIT(Xeno, TRAIT_CHARGING)
	SEND_SIGNAL(Xeno, COMSIG_XENO_STOP_MOMENTUM)
	Xeno.flags_atom |= DIRLOCK
	playsound(Xeno,"alien_tail_swipe", 50, 1)

	Xeno.use_plasma(plasma_cost)

	var/target = get_step(get_step(Xeno, target_dir), target_dir)
	var/list/collision_callbacks = list(/mob/living/carbon/human = CALLBACK(src, PROC_REF(handle_mob_collision)))
	var/list/end_throw_callbacks = list(CALLBACK(src, PROC_REF(on_end_throw), start_charging))
	Xeno.throw_atom(target, target_dist, SPEED_FAST, launch_type = LOW_LAUNCH, pass_flags = PASS_CRUSHER_CHARGE, end_throw_callbacks = end_throw_callbacks, collision_callbacks = collision_callbacks)

	apply_cooldown()
	return ..()
