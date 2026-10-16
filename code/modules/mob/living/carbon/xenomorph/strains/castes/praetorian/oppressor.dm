/datum/xeno_strain/oppressor
	// Dread it, run from it, destiny still arrives... or should I say, I do
	name = PRAETORIAN_OPPRESSOR
	localized_name = "压迫者"
	description = "你舍弃所有酸液技能、疾冲、部分移速及少量爪击伤害，换取对小型爆炸的抗性、对倒地目标更高的爪击伤害，以及强力钩拽技能。该技能最多将三个敌人拉向你并减速，效果随拉中的敌人数量变化。你还获得一记强力拳击，能缩短其他技能的冷却、穿透护甲，并对减速目标造成双倍伤害和定身。新的尾鞭可以击退并减速敌人，专属尾刺则能迅速抓住高大宿主，使其减速并将其拉向你。"
	flavor_description = "我的触及之处没有尽头。它将把苍穹拖下。"
	icon_state_prefix = "Oppressor"

	actions_to_remove = list(
		/datum/action/xeno_action/activable/tail_stab,
		/datum/action/xeno_action/activable/xeno_spit,
		/datum/action/xeno_action/activable/pounce/base_prae_dash,
		/datum/action/xeno_action/activable/prae_acid_ball,
		/datum/action/xeno_action/activable/spray_acid/base_prae_spray_acid,
		/datum/action/xeno_action/activable/corrosive_acid,
	)
	actions_to_add = list(
		/datum/action/xeno_action/activable/tail_stab/tail_seize,
		/datum/action/xeno_action/activable/prae_abduct,
		/datum/action/xeno_action/activable/oppressor_punch,
		/datum/action/xeno_action/activable/tail_lash,
	)

	behavior_delegate_type = /datum/behavior_delegate/oppressor_praetorian

/datum/xeno_strain/oppressor/apply_strain(mob/living/carbon/xenomorph/praetorian/prae)
	prae.damage_modifier -= XENO_DAMAGE_MOD_SMALL
	prae.explosivearmor_modifier += XENO_EXPOSIVEARMOR_MOD_SMALL
	prae.small_explosives_stun = FALSE
	prae.speed_modifier += XENO_SPEED_SLOWMOD_TIER_5
	prae.plasma_types = list(PLASMA_NEUROTOXIN, PLASMA_CHITIN)
	prae.claw_type = CLAW_TYPE_SHARP

	prae.recalculate_everything()

/datum/behavior_delegate/oppressor_praetorian
	name = "Oppressor Praetorian Behavior Delegate"
	var/tearing_damage = 15

/datum/behavior_delegate/oppressor_praetorian/melee_attack_additional_effects_target(mob/living/carbon/target_carbon)
	if(target_carbon.stat == DEAD)
		return

	// impaired in some capacity
	if(!(target_carbon.mobility_flags & MOBILITY_STAND) || !(target_carbon.mobility_flags & MOBILITY_MOVE) || target_carbon.slowed)
		target_carbon.apply_armoured_damage(get_xeno_damage_slash(target_carbon, tearing_damage), ARMOR_MELEE, BRUTE, bound_xeno.zone_selected ? bound_xeno.zone_selected : "chest")
		target_carbon.visible_message(SPAN_DANGER("[bound_xeno]狠狠撕开了[target_carbon]的身体！"))
		playsound(bound_xeno, 'sound/weapons/alien_tail_attack.ogg', 25, TRUE)
