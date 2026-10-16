
////////// BASE RAV POWERS

/datum/action/xeno_action/onclick/empower/use_ability(atom/target)
	var/mob/living/carbon/xenomorph/xeno = owner
	if(!xeno.check_state())
		return

	if(!action_cooldown_check())
		return

	if(!activated_once)
		if (!check_and_use_plasma_owner())
			return

		xeno.visible_message(SPAN_XENODANGER("[xeno]开始强化自身！"), SPAN_XENODANGER("我们开始强化自身！"))
		activated_once = TRUE
		button.icon_state = "template_active"
		get_inital_shield()
		addtimer(CALLBACK(src, PROC_REF(timeout)), time_until_timeout)
		apply_cooldown()
		return ..()
	else
		actual_empower(xeno)
		return TRUE

/datum/action/xeno_action/onclick/empower/proc/actual_empower(mob/living/carbon/xenomorph/xeno)
	var/datum/behavior_delegate/ravager_base/behavior = xeno.behavior_delegate

	activated_once = FALSE
	button.icon_state = "template"
	xeno.visible_message(SPAN_XENOWARNING("[xeno]从周围敌人身上汲取力量，得到强化！"), SPAN_XENOWARNING("我们感到一股力量从周围敌人身上涌来！"))
	xeno.create_empower()

	var/list/mobs_in_range = oviewers(empower_range, xeno)
	// Spook patrol
	xeno.emote("tail")

	var/accumulative_health = 0
	var/list/telegraph_atom_list = list()

	var/empower_targets
	for(var/mob/living/mob in mobs_in_range)
		if(empower_targets >= max_targets)
			break
		if(mob.stat == DEAD || HAS_TRAIT(mob, TRAIT_NESTED))
			continue
		if(xeno.can_not_harm(mob))
			continue

		empower_targets++
		accumulative_health += shield_per_human
		telegraph_atom_list += new /obj/effect/xenomorph/xeno_telegraph/red(mob.loc, 1 SECONDS)
		shake_camera(mob, 2, 1)

	accumulative_health += main_empower_base_shield

	xeno.add_xeno_shield(accumulative_health, XENO_SHIELD_SOURCE_RAVAGER)
	xeno.overlay_shields()
	if(empower_targets >= behavior.super_empower_threshold) //you go in deep you reap the rewards
		super_empower(xeno, empower_targets, behavior)

/datum/action/xeno_action/onclick/empower/proc/super_empower(mob/living/carbon/xenomorph/xeno, empower_targets, datum/behavior_delegate/ravager_base/behavior)
	xeno.visible_message(SPAN_DANGER("[xeno]借助[empower_targets]名敌人的力量进一步强化自身，泛起诡异的红光！"), SPAN_XENOHIGHDANGER("我们借助[empower_targets]名敌人的力量得到强化，开始泛起诡异的红光！"))
	xeno.emote("roar")


	behavior.empower_targets = empower_targets

	var/color = "#FF0000"
	var/alpha = 70
	color += num2text(alpha, 2, 16)
	xeno.add_filter("empower_rage", 1, list("type" = "outline", "color" = color, "size" = 3))

	addtimer(CALLBACK(src, PROC_REF(weaken_superbuff), xeno, behavior), 5 SECONDS)

/datum/action/xeno_action/onclick/empower/proc/weaken_superbuff(mob/living/carbon/xenomorph/xeno, datum/behavior_delegate/ravager_base/behavior)

	xeno.remove_filter("empower_rage")
	var/color = "#FF0000"
	var/alpha = 35
	color += num2text(alpha, 2, 16)
	xeno.add_filter("empower_rage", 1, list("type" = "outline", "color" = color, "size" = 3))

	addtimer(CALLBACK(src, PROC_REF(remove_superbuff), xeno, behavior), 1.5 SECONDS)

/datum/action/xeno_action/onclick/empower/proc/remove_superbuff(mob/living/carbon/xenomorph/xeno, datum/behavior_delegate/ravager_base/behavior)
	behavior.empower_targets = 0

	xeno.visible_message(SPAN_DANGER("[xeno]的光芒逐渐暗淡。"), SPAN_XENOHIGHDANGER("我们的光芒消退，力量正在流失！"))
	xeno.remove_filter("empower_rage")

/datum/action/xeno_action/onclick/empower/proc/get_inital_shield()
	var/mob/living/carbon/xenomorph/xeno = owner

	if(!activated_once)
		return

	xeno.add_xeno_shield(initial_activation_shield, XENO_SHIELD_SOURCE_RAVAGER)
	xeno.overlay_shields()

/datum/action/xeno_action/onclick/empower/proc/timeout()
	if(!activated_once)
		return

	var/mob/living/carbon/xenomorph/xeno = owner
	actual_empower(xeno)

/datum/action/xeno_action/onclick/empower/action_cooldown_check()
	if (cooldown_timer_id == TIMER_ID_NULL)
		return TRUE
	else if (activated_once)
		return TRUE
	else
		return FALSE

// Supplemental behavior for our charge
/datum/action/xeno_action/activable/pounce/charge/additional_effects(mob/living/living)

	var/mob/living/carbon/human/human = living
	var/mob/living/carbon/xenomorph/xeno = owner
	var/datum/behavior_delegate/ravager_base/behavior = xeno.behavior_delegate
	if(behavior.empower_targets < behavior.super_empower_threshold)
		return
	xeno.visible_message(SPAN_XENODANGER("[xeno]冲向[human]，用护盾将其撞击！"), SPAN_XENODANGER("我们冲向[human]，用护盾将其撞击！"))
	human.apply_effect(behavior.knockdown_amount, WEAKEN)
	human.attack_alien(xeno, rand(xeno.melee_damage_lower, xeno.melee_damage_upper))

	var/facing = get_dir(xeno, human)

	xeno.throw_carbon(human, facing, behavior.fling_distance, SPEED_VERY_FAST, shake_camera = FALSE, immobilize = TRUE)

/datum/action/xeno_action/activable/scissor_cut/use_ability(atom/target_atom)
	var/mob/living/carbon/xenomorph/ravager_user = owner

	if (!action_cooldown_check())
		return

	if (!ravager_user.check_state())
		return

	// Determine whether or not we should daze here
	var/should_sslow = FALSE
	var/datum/behavior_delegate/ravager_base/ravager_delegate = ravager_user.behavior_delegate
	if(ravager_delegate.empower_targets >= ravager_delegate.super_empower_threshold)
		should_sslow = TRUE

	// Get line of turfs
	var/list/turf/target_turfs = list()

	var/facing = Get_Compass_Dir(ravager_user, target_atom)
	var/turf/turf = ravager_user.loc
	var/turf/temp = ravager_user.loc
	var/list/telegraph_atom_list = list()

	for (var/step in 0 to 3)
		temp = get_step(turf, facing)
		if(facing in GLOB.diagonals) // check if it goes through corners
			var/reverse_face = GLOB.reverse_dir[facing]

			var/turf/back_left = get_step(temp, turn(reverse_face, 45))
			var/turf/back_right = get_step(temp, turn(reverse_face, -45))
			if((!back_left || back_left.density) && (!back_right || back_right.density))
				break
		if(!temp || temp.density || temp.opacity)
			break

		var/blocked = FALSE
		for(var/obj/structure/structure_blocker in temp)
			if(istype(structure_blocker, /obj/structure/window/framed))
				var/obj/structure/window/framed/framed_window = structure_blocker
				if(!framed_window.unslashable)
					framed_window.deconstruct(disassembled = FALSE)

			if(structure_blocker.opacity)
				blocked = TRUE
				break
		if(blocked)
			break

		turf = temp
		target_turfs += turf
		telegraph_atom_list += new /obj/effect/xenomorph/xeno_telegraph/red(turf, 0.25 SECONDS)

	// Extract our 'optimal' turf, if it exists
	if (length(target_turfs) >= 2)
		ravager_user.animation_attack_on(target_turfs[length(target_turfs)], 15)

	// Hmm today I will kill a marine while looking away from them
	ravager_user.face_atom(target_atom)
	ravager_user.emote("roar")
	ravager_user.visible_message(SPAN_XENODANGER("[ravager_user]用利爪横扫身前！"), SPAN_XENODANGER("我们用利爪横扫身前！"))

	// Loop through our turfs, finding any humans there and dealing damage to them
	for (var/turf/target_turf in target_turfs)
		for (var/mob/living/carbon/carbon_target in target_turf)
			if (carbon_target.stat == DEAD)
				continue

			if(ravager_user.can_not_harm(carbon_target))
				continue
			ravager_user.flick_attack_overlay(carbon_target, "slash")
			carbon_target.apply_armoured_damage(damage, ARMOR_MELEE, BRUTE)
			playsound(get_turf(carbon_target), "alien_claw_flesh", 30, TRUE)

			if(should_sslow)
				new /datum/effects/xeno_slow/superslow(carbon_target, ravager_user, ttl = superslow_duration)

	apply_cooldown()
	return ..()


///////////// BERSERKER POWERS

/datum/action/xeno_action/onclick/apprehend/use_ability(atom/affected_atom)
	var/mob/living/carbon/xenomorph/xeno = owner

	if (!istype(xeno))
		return

	if (!action_cooldown_check())
		return

	if (!xeno.check_state())
		return

	if (!check_and_use_plasma_owner())
		return

	var/datum/behavior_delegate/ravager_berserker/behavior = xeno.behavior_delegate
	if (istype(behavior))
		behavior.next_slash_buffed = TRUE

	to_chat(xeno, SPAN_XENODANGER("我们的下一次爪击将使敌人减速！"))

	addtimer(CALLBACK(src, PROC_REF(unbuff_slash)), buff_duration)

	xeno.speed_modifier -= speed_buff
	xeno.recalculate_speed()

	addtimer(CALLBACK(src, PROC_REF(apprehend_off)), buff_duration, TIMER_UNIQUE)
	xeno.add_filter("apprehend_on", 1, list("type" = "outline", "color" = "#522020ff", "size" = 1)) // Dark red because the berserker is scary in this state

	apply_cooldown()
	return ..()

/datum/action/xeno_action/onclick/apprehend/proc/apprehend_off()
	var/mob/living/carbon/xenomorph/xeno = owner
	xeno.remove_filter("apprehend_on")
	if (istype(xeno))
		xeno.speed_modifier += speed_buff
		xeno.recalculate_speed()
		to_chat(xeno, SPAN_XENOHIGHDANGER("我们的速度慢了下来！"))

/datum/action/xeno_action/onclick/apprehend/proc/unbuff_slash()
	var/mob/living/carbon/xenomorph/xeno = owner
	if (!istype(xeno))
		return
	var/datum/behavior_delegate/ravager_berserker/behavior = xeno.behavior_delegate
	if (istype(behavior))
		// In case slash has already landed
		if (!behavior.next_slash_buffed)
			return
		behavior.next_slash_buffed = FALSE

	to_chat(xeno, SPAN_XENODANGER("我们等得太久，爪击已经无法使敌人减速！"))


/datum/action/xeno_action/activable/clothesline/use_ability(atom/affected_atom)
	var/mob/living/carbon/xenomorph/xeno = owner

	if (!action_cooldown_check())
		return

	if (!xeno.check_state())
		return

	if (!isxeno_human(affected_atom) || xeno.can_not_harm(affected_atom))
		to_chat(xeno, SPAN_XENOWARNING("我们必须以敌人为目标！"))
		return

	if (!xeno.Adjacent(affected_atom))
		to_chat(xeno, SPAN_XENOWARNING("我们必须紧邻目标！"))
		return

	var/mob/living/carbon/carbon = affected_atom
	var/heal_amount = base_heal
	var/fling_distance = fling_dist_base
	var/debilitate = TRUE // Do we apply neg. status effects to the target?

	if (carbon.mob_size >= MOB_SIZE_BIG)
		to_chat(xeno, SPAN_XENOWARNING("这生物体型过大，无法选为目标。"))
		return

	if (carbon.stat == DEAD)
		return

	var/datum/behavior_delegate/ravager_berserker/behavior = xeno.behavior_delegate
	if (behavior.rage >= 2)
		behavior.decrement_rage()
		heal_amount += additional_healing_enraged
	else
		to_chat(xeno, SPAN_XENOWARNING("没有怒气，我们的恢复效果减弱了！"))
		debilitate = FALSE
		fling_distance--

	// Damage
	var/obj/limb/head/head = carbon.get_limb("head")
	if(ishuman(carbon) && head)
		carbon.apply_armoured_damage(damage, ARMOR_MELEE, BRUTE, "head")
	else
		carbon.apply_armoured_damage(get_xeno_damage_slash(carbon, damage), ARMOR_MELEE, BRUTE) // just for consistency

	// Heal
	if(!xeno.on_fire)
		xeno.gain_health(heal_amount)

	// Fling
	var/facing = get_dir(xeno, carbon)
	var/turf/turf = xeno.loc
	var/turf/temp = xeno.loc

	for (var/step in 0 to fling_distance-1)
		temp = get_step(turf, facing)
		if (!temp)
			break
		turf = temp

	carbon.throw_atom(turf, fling_distance, SPEED_VERY_FAST, xeno, TRUE)

	// Negative stat effects
	if (debilitate)
		carbon.AdjustDaze(daze_amount)

	apply_cooldown()
	return ..()

/datum/action/xeno_action/activable/eviscerate/use_ability(atom/affected_atom)
	var/mob/living/carbon/xenomorph/xeno = owner

	if(!action_cooldown_check() || xeno.action_busy)
		return

	if(!xeno.check_state())
		return

	var/damage = base_damage
	var/range = 1
	var/windup_reduction = 0
	var/lifesteal_per_marine = 50
	var/max_lifesteal = 250
	var/lifesteal_range =  1

	var/datum/behavior_delegate/ravager_berserker/behavior = xeno.behavior_delegate
	if (behavior.rage == 0)
		to_chat(xeno, SPAN_XENODANGER("怒气为0时，我们无法开膛！"))
		return
	damage = damage_at_rage_levels[clamp(behavior.rage, 1, behavior.max_rage)]
	range = range_at_rage_levels[clamp(behavior.rage, 1, behavior.max_rage)]
	windup_reduction = windup_reduction_at_rage_levels[clamp(behavior.rage, 1, behavior.max_rage)]
	behavior.decrement_rage(behavior.rage)

	apply_cooldown()

	if (range > 1)
		xeno.visible_message(SPAN_XENOHIGHDANGER("[xeno]开始站稳蓄力，准备发动猛烈打击！"), SPAN_XENOHIGHDANGER("我们开始站稳蓄力，准备发动猛烈打击！"))
	else
		xeno.visible_message(SPAN_XENODANGER("[xeno]开始站稳蓄力，准备发动打击！"), SPAN_XENOHIGHDANGER("我们开始站稳蓄力，准备发动打击！"))

	ADD_TRAIT(xeno, TRAIT_IMMOBILIZED, TRAIT_SOURCE_ABILITY("Eviscerate"))
	xeno.anchored = TRUE

	if (do_after(xeno, (activation_delay - windup_reduction), INTERRUPT_ALL | BEHAVIOR_IMMOBILE, BUSY_ICON_HOSTILE))
		xeno.emote("roar")
		xeno.spin_circle()

		for (var/mob/living/carbon/human in orange(xeno, range))
			if(!isxeno_human(human) || xeno.can_not_harm(human))
				continue

			if (human.stat == DEAD)
				continue

			if(!check_clear_path_to_target(xeno, human))
				continue

			if (range > 1)
				xeno.visible_message(SPAN_XENOHIGHDANGER("[xeno]撕开了[human]的腹部！"), SPAN_XENOHIGHDANGER("我们撕开了[human]的腹部！"))
				human.spawn_gibs()
				playsound(get_turf(human), 'sound/effects/gibbed.ogg', 30, 1)
				human.apply_effect(get_xeno_stun_duration(human, 1), WEAKEN)
			else
				xeno.visible_message(SPAN_XENODANGER("[xeno]抓击[human]！"), SPAN_XENODANGER("我们抓击[human]！"))
				playsound(get_turf(human), "alien_claw_flesh", 30, 1)

			human.apply_armoured_damage(get_xeno_damage_slash(human, damage), ARMOR_MELEE, BRUTE, "chest", 20)

	var/valid_count = 0
	var/list/mobs_in_range = oviewers(lifesteal_range, xeno)

	for(var/mob/mob as anything in mobs_in_range)
		if(mob.stat == DEAD || HAS_TRAIT(mob, TRAIT_NESTED))
			continue

		if(xeno.can_not_harm(mob))
			continue

		valid_count++

	// This is the heal
	if(!xeno.on_fire)
		xeno.gain_health(clamp(valid_count * lifesteal_per_marine, 0, max_lifesteal))

	REMOVE_TRAIT(xeno, TRAIT_IMMOBILIZED, TRAIT_SOURCE_ABILITY("Eviscerate"))
	xeno.anchored = FALSE

	return ..()


////////// HEDGEHOG POWERS

/datum/action/xeno_action/onclick/spike_shield/use_ability(atom/target)
	var/mob/living/carbon/xenomorph/xeno = owner

	if (!action_cooldown_check())
		return

	if (!xeno.check_state())
		return

	var/datum/behavior_delegate/ravager_hedgehog/behavior = xeno.behavior_delegate
	if (!behavior.check_shards(shard_cost))
		to_chat(xeno, SPAN_DANGER("碎片不足！我们还需要[shard_cost - behavior.shards]片！"))
		return
	behavior.use_shards(shard_cost)

	xeno.visible_message(SPAN_XENODANGER("[xeno]竖起骨片尖刺，形成防御外壳！"), SPAN_XENODANGER("我们竖起骨片尖刺，形成防御外壳！"))

	// Add our shield
	var/datum/xeno_shield/hedgehog_shield/shield = xeno.add_xeno_shield(shield_amount, XENO_SHIELD_SOURCE_HEDGE_RAV, /datum/xeno_shield/hedgehog_shield)
	if (shield)
		shield.owner = xeno
		shield.shrapnel_amount = shield_shrapnel_amount
		xeno.overlay_shields()

	xeno.create_shield(shield_duration, "shield2")
	shield_active = TRUE
	button.icon_state = "template_active"
	addtimer(CALLBACK(src, PROC_REF(remove_shield)), shield_duration)

	apply_cooldown()
	return ..()

/datum/action/xeno_action/onclick/spike_shield/action_cooldown_check()
	if (shield_active) // If active shield, return FALSE so that this action does not get carried out
		return FALSE
	else if (cooldown_timer_id == TIMER_ID_NULL)
		var/mob/living/carbon/xenomorph/xeno = owner
		var/datum/behavior_delegate/ravager_hedgehog/behavior = xeno.behavior_delegate
		return behavior.check_shards(shard_cost)
	return FALSE

/datum/action/xeno_action/onclick/spike_shield/proc/remove_shield()
	var/mob/living/carbon/xenomorph/xeno = owner

	if (!shield_active)
		return

	shield_active = FALSE
	button.icon_state = "template"

	for (var/datum/xeno_shield/shield in xeno.xeno_shields)
		if (shield.shield_source == XENO_SHIELD_SOURCE_HEDGE_RAV)
			shield.on_removal()
			qdel(shield)
			break

	to_chat(xeno, SPAN_XENODANGER("我们的碎片护盾消散了！"))
	xeno.overlay_shields()
	return

/datum/action/xeno_action/activable/rav_spikes/use_ability(atom/affected_atom)
	var/mob/living/carbon/xenomorph/xeno = owner

	if (!action_cooldown_check())
		return

	if(!affected_atom || affected_atom.layer >= FLY_LAYER || !isturf(xeno.loc) || !xeno.check_state())
		return

	var/datum/behavior_delegate/ravager_hedgehog/behavior = xeno.behavior_delegate
	if (!behavior.check_shards(shard_cost))
		to_chat(xeno, SPAN_DANGER("碎片不足！我们还需要[shard_cost - behavior.shards]片！"))
		return
	behavior.use_shards(shard_cost)

	xeno.visible_message(SPAN_XENOWARNING("[xeno]向[affected_atom]射出尖刺！"), SPAN_XENOWARNING("我们向[affected_atom]射出尖刺！"))

	var/turf/target = locate(affected_atom.x, affected_atom.y, affected_atom.z)
	var/obj/projectile/projectile = new /obj/projectile(xeno.loc, create_cause_data(initial(xeno.caste_type), xeno))

	var/datum/ammo/ammo_datum = GLOB.ammo_list[ammo_type]

	projectile.generate_bullet(ammo_datum)

	projectile.fire_at(target, xeno, xeno, ammo_datum.max_range, ammo_datum.shell_speed)
	playsound(xeno, 'sound/effects/spike_spray.ogg', 25, 1)

	apply_cooldown()
	return ..()

/datum/action/xeno_action/activable/rav_spikes/action_cooldown_check()
	if(!owner)
		return FALSE
	if (cooldown_timer_id == TIMER_ID_NULL)
		var/mob/living/carbon/xenomorph/xeno = owner
		if(!istype(xeno))
			return FALSE
		var/datum/behavior_delegate/ravager_hedgehog/behavior = xeno.behavior_delegate
		return behavior.check_shards(shard_cost)
	else
		return FALSE

/datum/action/xeno_action/onclick/spike_shed/use_ability(atom/affected_atom)
	var/mob/living/carbon/xenomorph/xeno = owner

	if (!action_cooldown_check())
		return

	if (!xeno.check_state())
		return

	var/datum/behavior_delegate/ravager_hedgehog/behavior = xeno.behavior_delegate
	if (!behavior.check_shards(shard_cost))
		to_chat(xeno, SPAN_DANGER("碎片不足！我们还需要[shard_cost - behavior.shards]片！"))
		return
	behavior.use_shards(shard_cost)
	behavior.lock_shards()

	xeno.visible_message(SPAN_XENOWARNING("[xeno]释放全部尖刺，射向四面八方！"), SPAN_XENOWARNING("我们释放全部尖刺，射向四面八方！"))
	xeno.spin_circle()
	create_shrapnel(get_turf(xeno), shrapnel_amount, null, null, ammo_type, create_cause_data(initial(xeno.caste_type), owner), TRUE)
	playsound(xeno, 'sound/effects/spike_spray.ogg', 25, 1)

	apply_cooldown()
	return ..()

/datum/action/xeno_action/onclick/spike_shed/action_cooldown_check()
	if (cooldown_timer_id == TIMER_ID_NULL)
		var/mob/living/carbon/xenomorph/xeno = owner
		var/datum/behavior_delegate/ravager_hedgehog/behavior = xeno.behavior_delegate
		return behavior.check_shards(shard_cost)
	else
		return FALSE
