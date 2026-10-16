/datum/xeno_strain/vanguard
	name = PRAETORIAN_VANGUARD
	localized_name = "先锋"
	description = "你舍弃所有酸液技能和部分生命值，换取更高移速，以及能够挡住一次攻击并重新充能的护盾。穿刺能刺穿最远三格外的高大宿主，一次刺穿至少两个目标即可完全恢复护盾。使用冲锋冲过敌群，再次使用可释放最远波及三格的强力范围爪击。你还拥有受护盾强化的劈斩技能，可切换为将目标定身或甩飞。"
	flavor_description = "你无畏地诞生，无畏地效忠，无畏地死去。它将成为我的先锋。"
	icon_state_prefix = "Vanguard"

	actions_to_remove = list(
		/datum/action/xeno_action/activable/xeno_spit,
		/datum/action/xeno_action/activable/pounce/base_prae_dash,
		/datum/action/xeno_action/activable/prae_acid_ball,
		/datum/action/xeno_action/activable/spray_acid/base_prae_spray_acid,
		/datum/action/xeno_action/activable/corrosive_acid,
	)
	actions_to_add = list(
		/datum/action/xeno_action/activable/pierce,
		/datum/action/xeno_action/activable/pounce/prae_dash,
		/datum/action/xeno_action/activable/cleave,
		/datum/action/xeno_action/onclick/toggle_cleave,
	)

	behavior_delegate_type = /datum/behavior_delegate/praetorian_vanguard

/datum/xeno_strain/vanguard/apply_strain(mob/living/carbon/xenomorph/praetorian/prae)
	prae.speed_modifier += XENO_SPEED_FASTMOD_TIER_3
	prae.health_modifier -= XENO_HEALTH_MOD_MED
	prae.claw_type = CLAW_TYPE_SHARP

	prae.recalculate_everything()

/datum/behavior_delegate/praetorian_vanguard
	name = "Praetorian Vanguard Behavior Delegate"

	// Config
	var/shield_recharge_time = 200  // 20 seconds to recharge 1-hit shield
	var/pierce_spin_time = 10   // 1 second to use pierce
	var/shield_decay_cleave_time = 15   // How long you have to buffed cleave after the shield fully decays

	// State
	var/last_combat_time = 0
	var/last_shield_regen_time = 0

/datum/behavior_delegate/praetorian_vanguard/on_life()
	if (last_shield_regen_time <= last_combat_time &&  last_combat_time + shield_recharge_time <= world.time)
		regen_shield()


/datum/behavior_delegate/praetorian_vanguard/on_hitby_projectile(ammo)
	last_combat_time = world.time
	return

/datum/behavior_delegate/praetorian_vanguard/melee_attack_additional_effects_self()
	..()

	last_combat_time = world.time

/datum/behavior_delegate/praetorian_vanguard/proc/next_pierce_spin()
	var/datum/action/xeno_action/activable/pierce/pAction = get_action(bound_xeno, /datum/action/xeno_action/activable/pierce)
	if (istype(pAction))
		pAction.should_spin_instead = TRUE

	addtimer(CALLBACK(src, PROC_REF(next_pierce_normal)), pierce_spin_time)
	return

/datum/behavior_delegate/praetorian_vanguard/proc/next_pierce_normal()
	var/datum/action/xeno_action/activable/pierce/pAction = get_action(bound_xeno, /datum/action/xeno_action/activable/pierce)
	if (istype(pAction))
		pAction.should_spin_instead = FALSE
	return

/datum/behavior_delegate/praetorian_vanguard/proc/regen_shield()
	var/mob/living/carbon/xenomorph/praetorian = bound_xeno
	var/datum/xeno_shield/vanguard/found_shield = null
	last_shield_regen_time = world.time
	for (var/datum/xeno_shield/vanguard/vanguard_shield in praetorian.xeno_shields)
		if (vanguard_shield.shield_source == XENO_SHIELD_SOURCE_VANGUARD_PRAE)
			found_shield = vanguard_shield
			break

	if (found_shield)
		qdel(found_shield)

		praetorian.add_xeno_shield(800, XENO_SHIELD_SOURCE_VANGUARD_PRAE, /datum/xeno_shield/vanguard)

	else
		var/datum/xeno_shield/vanguard/new_shield = praetorian.add_xeno_shield(800, XENO_SHIELD_SOURCE_VANGUARD_PRAE, /datum/xeno_shield/vanguard)
		bound_xeno.explosivearmor_modifier += 1.5*XENO_EXPOSIVEARMOR_MOD_VERY_LARGE
		bound_xeno.recalculate_armor()
		new_shield.explosive_armor_amount = 1.5*XENO_EXPOSIVEARMOR_MOD_VERY_LARGE
		to_chat(praetorian, SPAN_XENOHIGHDANGER("我们感到防御外壳恢复了！它可以抵挡一次攻击！"))

	var/datum/action/xeno_action/activable/cleave/caction = get_action(bound_xeno, /datum/action/xeno_action/activable/cleave)
	if (istype(caction))
		caction.buffed = TRUE
