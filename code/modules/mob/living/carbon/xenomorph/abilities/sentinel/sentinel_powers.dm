/datum/action/xeno_action/activable/slowing_spit/use_ability(atom/target)
	var/mob/living/carbon/xenomorph/xeno = owner
	if(!xeno.check_state())
		return

	if(!action_cooldown_check())
		to_chat(src, SPAN_WARNING("我们必须等待喷吐腺重新蓄满。"))
		return

	var/turf/current_turf = get_turf(xeno)

	if(!current_turf)
		return

	if (!check_and_use_plasma_owner())
		return

	xeno.visible_message(SPAN_XENOWARNING("[xeno]朝[target]喷吐！"), \
	SPAN_XENOWARNING("你朝[target]喷吐！") )
	var/sound_to_play = pick(1, 2) == 1 ? 'sound/voice/alien_spitacid.ogg' : 'sound/voice/alien_spitacid2.ogg'
	playsound(xeno.loc, sound_to_play, 25, 1)

	xeno.ammo = GLOB.ammo_list[/datum/ammo/xeno/toxin]
	var/obj/projectile/projectile = new /obj/projectile(current_turf, create_cause_data(initial(xeno.caste_type), xeno))
	projectile.generate_bullet(xeno.ammo)
	projectile.permutated += xeno
	projectile.def_zone = xeno.get_limbzone_target()
	projectile.fire_at(target, xeno, xeno, xeno.ammo.max_range, xeno.ammo.shell_speed)

	apply_cooldown()
	return ..()

/datum/action/xeno_action/activable/scattered_spit/use_ability(atom/target)
	var/mob/living/carbon/xenomorph/xeno = owner
	if(!xeno.check_state())
		return

	if(!action_cooldown_check())
		to_chat(src, SPAN_WARNING("我们必须等待喷吐腺重新蓄满。"))
		return

	var/turf/current_turf = get_turf(xeno)

	if(!current_turf)
		return

	if (!check_and_use_plasma_owner())
		return

	xeno.visible_message(SPAN_XENOWARNING("[xeno]朝[target]喷吐！"), \
	SPAN_XENOWARNING("你朝[target]喷吐！") )
	var/sound_to_play = pick(1, 2) == 1 ? 'sound/voice/alien_spitacid.ogg' : 'sound/voice/alien_spitacid2.ogg'
	playsound(xeno.loc, sound_to_play, 25, 1)

	xeno.ammo = GLOB.ammo_list[/datum/ammo/xeno/toxin/shotgun]
	var/obj/projectile/projectile = new /obj/projectile(current_turf, create_cause_data(initial(xeno.caste_type), xeno))
	projectile.generate_bullet(xeno.ammo)
	projectile.permutated += xeno
	projectile.def_zone = xeno.get_limbzone_target()
	projectile.fire_at(target, xeno, xeno, xeno.ammo.max_range, xeno.ammo.shell_speed)

	apply_cooldown()
	return ..()

/datum/action/xeno_action/onclick/paralyzing_slash/use_ability(atom/target)
	var/mob/living/carbon/xenomorph/xeno = owner

	if (!istype(xeno))
		return

	if (!action_cooldown_check())
		return

	if (!check_and_use_plasma_owner())
		return

	var/datum/behavior_delegate/sentinel_base/behavior = xeno.behavior_delegate
	if (istype(behavior))
		behavior.next_slash_buffed = TRUE

	to_chat(xeno, SPAN_XENOHIGHDANGER("我们的下一次爪击将附带神经毒素！"))
	button.icon_state = "template_active"

	addtimer(CALLBACK(src, PROC_REF(unbuff_slash)), buff_duration)

	apply_cooldown()
	return ..()

/datum/action/xeno_action/onclick/paralyzing_slash/proc/unbuff_slash()
	var/mob/living/carbon/xenomorph/xeno = owner
	if (!istype(xeno))
		return
	var/datum/behavior_delegate/sentinel_base/behavior = xeno.behavior_delegate
	if (istype(behavior))
		// In case slash has already landed
		if (!behavior.next_slash_buffed)
			return
		behavior.next_slash_buffed = FALSE

	to_chat(xeno, SPAN_XENODANGER("我们等待得太久，爪击不再附带神经毒素！"))
	button.icon_state = "template"
