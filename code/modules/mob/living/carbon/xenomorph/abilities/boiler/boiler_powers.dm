/datum/action/xeno_action/activable/acid_lance/use_ability(atom/affected_atom)
	var/mob/living/carbon/xenomorph/xeno = owner

	if (!istype(xeno) || !xeno.check_state())
		return

	if (!activated_once && !action_cooldown_check())
		return

	if(!affected_atom || affected_atom.layer >= FLY_LAYER || !isturf(xeno.loc))
		return

	if (!activated_once)
		// Start our 'charging'

		if (!check_and_use_plasma_owner())
			return

		xeno.create_empower()
		xeno.visible_message(SPAN_XENODANGER("[xeno]开始聚集酸液，准备发动猛烈轰击！"), SPAN_XENODANGER("我们开始聚集酸液，准备发动猛烈轰击！"))
		activated_once = TRUE
		stack()
		addtimer(CALLBACK(src, PROC_REF(timeout)), max_stacks*stack_time + time_after_max_before_end)
		apply_cooldown()
		return ..()

	else
		activated_once = FALSE
		var/range = base_range + stacks*range_per_stack
		var/damage = base_damage + stacks*damage_per_stack
		var/turfs_visited = 0
		for (var/turf/turf in get_line(get_turf(xeno), affected_atom))
			if(turf.density || turf.opacity)
				break

			var/should_stop = FALSE
			for(var/obj/structure/structure in turf)
				if(istype(structure, /obj/structure/window/framed))
					var/obj/structure/window/framed/window_frame = structure
					if(!window_frame.unslashable)
						window_frame.deconstruct(disassembled = FALSE)

				if(structure.opacity)
					should_stop = TRUE
					break

			if (should_stop)
				break

			if (turfs_visited >= range)
				break

			turfs_visited++

			new /obj/effect/xenomorph/acid_damage_delay(turf, damage, 7, FALSE, "You are blasted with a stream of high-velocity acid!", xeno)

		xeno.visible_message(SPAN_XENODANGER("[xeno]向[affected_atom]发射了一大股酸液！"), SPAN_XENODANGER("我们向[affected_atom]发射了一大股酸液！"))
		remove_stack_effects("我们的速度恢复正常了！")
		return TRUE

/datum/action/xeno_action/activable/acid_lance/proc/stack()
	var/mob/living/carbon/xenomorph/xeno = owner
	if (!istype(xeno))
		return

	if (!activated_once)
		return

	stacks = min(max_stacks, stacks + 1)
	if (stacks != max_stacks)
		xeno.speed_modifier += movespeed_per_stack
		movespeed_nerf_applied += movespeed_per_stack
		xeno.recalculate_speed()
		addtimer(CALLBACK(src, PROC_REF(stack)), stack_time)
		return
	else
		to_chat(xeno, SPAN_XENOHIGHDANGER("酸液长枪已经蓄满力量！"))
		return

/datum/action/xeno_action/activable/acid_lance/proc/remove_stack_effects(message = null)
	var/mob/living/carbon/xenomorph/xeno = owner

	if (!istype(xeno))
		return

	if (stacks <= 0)
		return

	if (message)
		to_chat(xeno, SPAN_XENODANGER(message))

	stacks = 0
	xeno.speed_modifier -= movespeed_nerf_applied
	movespeed_nerf_applied = 0
	xeno.recalculate_speed()

/datum/action/xeno_action/activable/acid_lance/proc/timeout()
	if (activated_once)
		activated_once = FALSE
		remove_stack_effects("我们等得太久，已经无法施放酸液长枪了！")


/datum/action/xeno_action/activable/acid_lance/action_cooldown_check()
	return (activated_once || ..())

/datum/action/xeno_action/activable/xeno_spit/bombard/use_ability(atom/affected_atom)
	. = ..()
	var/mob/living/carbon/xenomorph/xeno = owner
	if(!action_cooldown_check()) // activate c/d only if we already spit
		for (var/action_type in action_types_to_cd)
			var/datum/action/xeno_action/xeno_action = get_action(xeno, action_type)
			if (!istype(xeno_action))
				continue

			xeno_action.apply_cooldown_override(cooldown_duration)

/datum/action/xeno_action/onclick/acid_shroud/use_ability(atom/affected_atom)
	var/datum/effect_system/smoke_spread/xeno_acid/spicy_gas
	var/mob/living/carbon/xenomorph/xeno = owner
	if (!isxeno(owner))
		return

	if (!action_cooldown_check())
		return

	if (!xeno.check_state())
		return

	if(sound_play)
		playsound(xeno,"acid_strike", 35, 1)
		sound_play = FALSE
		addtimer(VARSET_CALLBACK(src, sound_play, TRUE), 2 SECONDS)

	if (!do_after(xeno, xeno.ammo.spit_windup/6.5, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_HOSTILE, numticks = 2)) /// 0.7 seconds
		to_chat(xeno, SPAN_XENODANGER("我们决定取消酸雾屏障。"))
		return

	playsound(xeno,"acid_sizzle", 50, 1)

	if(xeno.ammo == GLOB.ammo_list[/datum/ammo/xeno/boiler_gas/acid])
		spicy_gas = new /datum/effect_system/smoke_spread/xeno_acid
	else if(xeno.ammo == GLOB.ammo_list[/datum/ammo/xeno/boiler_gas])
		spicy_gas = new /datum/effect_system/smoke_spread/xeno_weaken
	else
		CRASH("Globber has unknown ammo [xeno.ammo]! Oh no!")
	var/datum/cause_data/cause_data = create_cause_data("acid shroud gas", owner)
	spicy_gas.set_up(1, 0, get_turf(xeno), null, 6, new_cause_data = cause_data)
	spicy_gas.start()
	to_chat(xeno, SPAN_XENOHIGHDANGER("我们从毛孔排出酸液，形成酸雾屏障！"))

	for (var/action_type in action_types_to_cd)
		var/datum/action/xeno_action/xeno_action = get_action(xeno, action_type)
		if (!istype(xeno_action))
			continue

		xeno_action.apply_cooldown_override(cooldown_duration)

	apply_cooldown()
	return ..()

/datum/action/xeno_action/onclick/shift_spits/boiler/use_ability(atom/affected_atom)
	. = ..()
	apply_cooldown()

/////////////////////////////// Trapper boiler powers

/datum/action/xeno_action/activable/boiler_trap/use_ability(atom/affected_atom)
	var/mob/living/carbon/xenomorph/xeno = owner

	if (!istype(xeno))
		return

	if (!action_cooldown_check())
		return

	if (!xeno.check_state())
		return

	if (!can_see(xeno, affected_atom, TRAPPER_VIEWRANGE))
		to_chat(xeno, SPAN_XENODANGER("我们看不到那个位置！"))
		return

	if (!check_and_use_plasma_owner())
		return

	// 5-long line of turfs orthogonal to the line between us and our target as precisely as we can figure it
	var/dir_between = Get_Compass_Dir(xeno, affected_atom)
	var/list/target_turfs = list()
	var/target_turf = get_turf(affected_atom)
	var/left_turf = get_step(target_turf, turn(dir_between, -90))
	var/right_turf = get_step(target_turf, turn(dir_between, 90))
	target_turfs += target_turf
	target_turfs += left_turf
	target_turfs += right_turf
	target_turfs += get_step(left_turf, turn(dir_between, -90))
	target_turfs += get_step(right_turf, turn(dir_between, 90))

	for (var/turf/turf in target_turfs)
		if (!istype(turf) || turf.density)
			continue

		var/trap_found = FALSE
		for (var/obj/effect/alien/resin/boilertrap/boiler_trap in turf)
			trap_found = TRUE
			break

		if (trap_found)
			continue

		var/obj/effect/alien/resin/boilertrap/boiler_trap
		if(empowered)
			boiler_trap = new /obj/effect/alien/resin/boilertrap/empowered(turf, xeno)
		else
			boiler_trap = new /obj/effect/alien/resin/boilertrap(turf, xeno)
		QDEL_IN(boiler_trap, trap_ttl)

	if(empowered)
		empowered = FALSE
		empowering_charge_counter = 0
		button.overlays -= "+empowered"
		var/datum/action/xeno_action/activable/acid_mine/mine = get_action(xeno, /datum/action/xeno_action/activable/acid_mine)
		if(!mine.empowered)
			mine.empowered = TRUE
			mine.button.overlays += "+empowered"
			to_chat(xeno, SPAN_XENODANGER("我们调动储备，准备更强力的[mine.get_display_name()]！"))

	apply_cooldown()
	return ..()

/datum/action/xeno_action/activable/acid_mine/use_ability(atom/affected_atom)
	var/mob/living/carbon/xenomorph/xeno = owner

	if (!istype(xeno))
		return

	if (!xeno.check_state())
		return

	if (!action_cooldown_check())
		return

	if(!affected_atom || affected_atom.layer >= FLY_LAYER || !isturf(xeno.loc))
		return

	if(!check_clear_path_to_target(xeno, affected_atom, TRUE, TRAPPER_VIEWRANGE))
		to_chat(xeno, SPAN_XENOWARNING("有东西挡住了！"))
		return

	if (!check_and_use_plasma_owner())
		return

	var/turf/turf = get_turf(affected_atom)
	var/acid_bolt_message = "一股酸液"
	if(empowered)
		acid_bolt_message = "一股强劲的酸液"

	xeno.visible_message(SPAN_XENODANGER("[xeno]发射了" + acid_bolt_message + "，射向[affected_atom]！"), SPAN_XENODANGER("我们发射了" + acid_bolt_message + "，射向[affected_atom]！"))
	new /obj/effect/xenomorph/acid_damage_delay/boiler_landmine(turf, damage, delay, empowered, "You are blasted with " + acid_bolt_message + "!", xeno)

	for (var/turf/target_turf in orange(1, turf))
		new /obj/effect/xenomorph/acid_damage_delay/boiler_landmine(target_turf, damage, delay, empowered, "You are blasted with a " + acid_bolt_message + "!", xeno)

	if(empowered)
		empowered = FALSE
		button.overlays -= "+empowered"

	apply_cooldown()
	return ..()

/datum/action/xeno_action/activable/acid_shotgun/use_ability(atom/affected_atom)
	var/mob/living/carbon/xenomorph/xeno = owner
	if (!istype(xeno))
		return

	if (!action_cooldown_check())
		return

	if(!affected_atom || affected_atom.layer >= FLY_LAYER || !isturf(xeno.loc) || !xeno.check_state())
		return

	xeno.visible_message(SPAN_XENOWARNING("[xeno]向[affected_atom]发射了一股酸液！"), SPAN_XENOWARNING("我们向[affected_atom]发射了一股酸液！"))

	var/turf/target_turf = locate(affected_atom.x, affected_atom.y, affected_atom.z)
	var/obj/projectile/proj = new(xeno.loc, create_cause_data("acid shotgun", xeno))
	var/datum/ammo/ammoDatum = new ammo_type()

	proj.generate_bullet(ammoDatum)
	proj.fire_at(target_turf, xeno, xeno, ammoDatum.max_range, ammoDatum.shell_speed)

	apply_cooldown()
	return ..()

/datum/ammo/xeno/acid_shotgun
	name = "酸液球"
	ping = null
	flags_ammo_behavior = AMMO_SKIPS_ALIENS|AMMO_STOPPED_BY_COVER|AMMO_IGNORE_ARMOR|AMMO_ACIDIC
	bonus_projectiles_type = /datum/ammo/xeno/acid_shotgun/spread
	hit_effect_color = "#FF0000"

/datum/ammo/xeno/acid_shotgun/New()
	..()
	damage = 10
	max_range = 5
	damage_type = BURN
	accuracy = HIT_ACCURACY_TIER_8
	accuracy_var_low = PROJECTILE_VARIANCE_TIER_6
	accuracy_var_high = PROJECTILE_VARIANCE_TIER_6
	bonus_projectiles_amount = EXTRA_PROJECTILES_TIER_9
	shrapnel_type = /datum/ammo/xeno/acid_shotgun/spread
	shrapnel_chance = 100

/datum/ammo/xeno/acid_shotgun/spread
	name = "酸液球"

/datum/ammo/xeno/acid_shotgun/spread/New()
	..()
	scatter = SCATTER_AMOUNT_TIER_1
	bonus_projectiles_amount = 0
	max_range = 4

/datum/action/xeno_action/activable/tail_stab/boiler/use_ability(atom/affected_atom)
	var/mob/living/carbon/xenomorph/stabbing_xeno = owner
	var/target = ..()
	if(iscarbon(target))
		var/mob/living/carbon/carbon_target = target
		if(stabbing_xeno.ammo == GLOB.ammo_list[/datum/ammo/xeno/boiler_gas/acid])
			carbon_target.reagents.add_reagent("molecularacid", 6)
			carbon_target.reagents.set_source_mob(owner, /datum/reagent/toxin/molecular_acid)
		else if(stabbing_xeno.ammo == GLOB.ammo_list[/datum/ammo/xeno/boiler_gas])
			var/datum/effects/neurotoxin/neuro_effect = locate() in carbon_target.effects_list
			if(!neuro_effect)
				neuro_effect = new(carbon_target, owner)
			neuro_effect.duration += 16
			to_chat(carbon_target,SPAN_HIGHDANGER("[stabbing_xeno]的尾刺向你体内注入了某种东西！"))
		else
			CRASH("Globber has unknown ammo [stabbing_xeno.ammo]! Oh no!")
		return TRUE
