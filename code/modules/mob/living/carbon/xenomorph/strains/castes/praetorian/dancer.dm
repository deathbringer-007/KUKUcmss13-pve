/datum/xeno_strain/dancer
	// My name is Cuban Pete, I'm the King of the Rumba Beat
	name = PRAETORIAN_DANCER
	localized_name = "舞者"
	description = "你失去所有酸液技能和少量护甲，换取更高移速、闪避率和无与伦比的灵活性。你能进一步加速、躲避子弹，并穿过敌我单位。爪击敌人会暂时提高移速，并施加一个改变两种新尾部技能效果的标记。对被标记的敌人使用贯穿会命中两次，扫尾绊倒则会将其击倒而非眩晕。"
	flavor_description = "这场演出堪配女皇。它将成为我的死亡乐器。"
	icon_state_prefix = "Dancer"

	actions_to_remove = list(
		/datum/action/xeno_action/activable/xeno_spit,
		/datum/action/xeno_action/activable/pounce/base_prae_dash,
		/datum/action/xeno_action/activable/prae_acid_ball,
		/datum/action/xeno_action/activable/spray_acid/base_prae_spray_acid,
	)
	actions_to_add = list(
		/datum/action/xeno_action/activable/prae_impale,
		/datum/action/xeno_action/onclick/prae_dodge,
		/datum/action/xeno_action/activable/prae_tail_trip,
	)

	behavior_delegate_type = /datum/behavior_delegate/praetorian_dancer

/datum/xeno_strain/dancer/apply_strain(mob/living/carbon/xenomorph/praetorian/prae)
	prae.armor_modifier -= XENO_ARMOR_MOD_VERY_SMALL
	prae.speed_modifier += XENO_SPEED_FASTMOD_TIER_5
	prae.plasma_types = list(PLASMA_CATECHOLAMINE)
	prae.claw_type = CLAW_TYPE_SHARP

	prae.recalculate_everything()

/datum/behavior_delegate/praetorian_dancer
	name = "Praetorian Dancer Behavior Delegate"

	var/evasion_buff_amount = 40
	var/evasion_buff_ttl = 25  // 2.5 seconds seems reasonable

	// State
	var/next_slash_buffed = FALSE
	var/slash_evasion_buffed = FALSE
	var/slash_evasion_timer = TIMER_ID_NULL
	var/dodge_activated = FALSE


/datum/behavior_delegate/praetorian_dancer/melee_attack_additional_effects_target(mob/living/carbon/target_carbon)
	if (!isxeno_human(target_carbon))
		return

	if (target_carbon.stat)
		return

	// Clean up all tags to 'refresh' our TTL
	for (var/datum/effects/dancer_tag/target_tag in target_carbon.effects_list)
		qdel(target_tag)

	new /datum/effects/dancer_tag(target_carbon, bound_xeno, , , 35)

	if(ishuman(target_carbon))
		var/mob/living/carbon/human/target_human = target_carbon
		target_human.update_xeno_hostile_hud()
