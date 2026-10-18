/datum/xeno_strain/steel_crest
	name = DEFENDER_STEELCREST
	description = "失去扫尾能力，并略微降低爪击伤害，换取更强的头槌击退效果与伤害，以及在固守状态下缓慢移动和施展头槌的能力。你还会获得独特的伤害积蓄能力，可用于恢复少量生命值并重置尾部重击的冷却。"
	flavor_description = "它如同我的意志一样不屈不挠。面对一切违逆者，它将成为我坚不可摧的钢冠。"
	icon_state_prefix = "Steelcrest"

	actions_to_remove = list(
		/datum/action/xeno_action/activable/headbutt,
		/datum/action/xeno_action/activable/fortify,
		/datum/action/xeno_action/onclick/tail_sweep,
	)
	actions_to_add = list(
		/datum/action/xeno_action/activable/headbutt/steel_crest,
		/datum/action/xeno_action/activable/fortify/steel_crest,
		/datum/action/xeno_action/onclick/soak,
	)

/datum/xeno_strain/steel_crest/apply_strain(mob/living/carbon/xenomorph/defender/defender)
	defender.damage_modifier -= XENO_DAMAGE_MOD_VERY_SMALL
	if(defender.fortify)
		defender.ability_speed_modifier += 2.5
	defender.recalculate_stats()
