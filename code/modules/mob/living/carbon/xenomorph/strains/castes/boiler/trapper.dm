/datum/xeno_strain/trapper
	name = BOILER_TRAPPER
	localized_name = "设陷者"
	description = "你舍弃轰击、酸液长枪和倾泻酸液的能力，换取更高移速，以及制造酸液爆炸并将敌人困在其中的能力。利用远视布置定身陷阱，并放置能伤害敌人和路障的酸液地雷；地雷每命中一个敌人，都会缩短部署陷阱的冷却。酸液霰弹每命中一次便积累一层洞察，达到十层上限后强化下一次陷阱。贴身射击或命中眩晕目标会立即叠满十层。"
	flavor_description = "战场是我的画布，它就是我的画师。让敌人在原地熔化。"

	actions_to_remove = list(
		/datum/action/xeno_action/activable/xeno_spit/bombard,
		/datum/action/xeno_action/onclick/shift_spits/boiler,
		/datum/action/xeno_action/activable/spray_acid/boiler,
		/datum/action/xeno_action/onclick/toggle_long_range/boiler,
		/datum/action/xeno_action/onclick/acid_shroud,
	)
	actions_to_add = list(
		/datum/action/xeno_action/activable/boiler_trap,
		/datum/action/xeno_action/activable/acid_mine,
		/datum/action/xeno_action/activable/acid_shotgun,
		/datum/action/xeno_action/onclick/toggle_long_range/trapper,
	)

	behavior_delegate_type = /datum/behavior_delegate/boiler_trapper

/datum/xeno_strain/trapper/apply_strain(mob/living/carbon/xenomorph/boiler/boiler)
	if(!istype(boiler))
		return FALSE

	if(boiler.is_zoomed)
		boiler.zoom_out()

	boiler.tileoffset = 0
	boiler.viewsize = TRAPPER_VIEWRANGE
	boiler.plasma_types -= PLASMA_NEUROTOXIN
	boiler.armor_modifier -= XENO_ARMOR_MOD_LARGE // no armor
	boiler.health_modifier -= XENO_HEALTH_MOD_MED

	boiler.speed_modifier += XENO_SPEED_SLOWMOD_TIER_5 // compensating for base buffs
	boiler.recalculate_everything()

/datum/behavior_delegate/boiler_trapper
	name = "Boiler Trapper Behavior Delegate"

	// Config
	var/temp_movespeed_amount = 1.25
	var/temp_movespeed_duration = 50
	var/temp_movespeed_cooldown = 200
	var/bonus_damage_shotgun_trapped = 7.5

	// State
	var/temp_movespeed_time_used = 0
	var/temp_movespeed_usable = FALSE
	var/temp_movespeed_messaged = FALSE

/datum/behavior_delegate/boiler_trapper/on_hitby_projectile(ammo)
	if (temp_movespeed_usable)
		temp_movespeed_time_used = world.time
		temp_movespeed_usable = FALSE

		if (isxeno(bound_xeno))
			var/mob/living/carbon/xenomorph/xeno = bound_xeno
			xeno.speed_modifier -= temp_movespeed_amount
			xeno.recalculate_speed()
			addtimer(CALLBACK(src, PROC_REF(remove_speed_buff)), temp_movespeed_duration)

/datum/behavior_delegate/boiler_trapper/ranged_attack_additional_effects_target(atom/target_atom)
	if (!ishuman(target_atom))
		return
	if (!istype(bound_xeno))
		return

	var/mob/living/carbon/human/target_human = target_atom
	var/datum/effects/boiler_trap/found = null
	for (var/datum/effects/boiler_trap/trap in target_human.effects_list)
		if (trap.cause_data?.resolve_mob() == bound_xeno)
			found = trap
			break

	var/datum/action/xeno_action/activable/boiler_trap/trap_ability = get_action(bound_xeno, /datum/action/xeno_action/activable/boiler_trap)
	if (found)
		target_human.apply_armoured_damage(bonus_damage_shotgun_trapped, ARMOR_BIO, BURN)
		trap_ability.empowering_charge_counter = trap_ability.empower_charge_max
	else
		target_human.adjust_effect(2, SLOW)
		trap_ability.empowering_charge_counter++

	if(!trap_ability.empowered && trap_ability.empowering_charge_counter >= trap_ability.empower_charge_max)
		trap_ability.empowered = TRUE
		trap_ability.button.overlays += "+empowered"
		to_chat(bound_xeno, SPAN_XENODANGER("你对猎物已有足够的洞察，下一次[trap_ability.get_display_name()]将得到强化。"))

	if(trap_ability.empowering_charge_counter > trap_ability.empower_charge_max)
		trap_ability.empowering_charge_counter = trap_ability.empower_charge_max

/datum/behavior_delegate/boiler_trapper/on_life()
	if ((temp_movespeed_time_used + temp_movespeed_cooldown) < world.time)
		if (!temp_movespeed_messaged)
			to_chat(bound_xeno, SPAN_XENODANGER("你感到肾上腺重新蓄满了！加速效果可以再次触发。"))
			temp_movespeed_messaged = TRUE
		temp_movespeed_usable = TRUE
		return

/datum/behavior_delegate/boiler_trapper/proc/remove_speed_buff()
	if (isxeno(bound_xeno))
		var/mob/living/carbon/xenomorph/xeno = bound_xeno
		xeno.speed_modifier += temp_movespeed_amount
		xeno.recalculate_speed()
		temp_movespeed_messaged = FALSE
