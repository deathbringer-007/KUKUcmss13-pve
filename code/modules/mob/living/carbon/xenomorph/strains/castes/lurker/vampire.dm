/datum/xeno_strain/vampire
	name = LURKER_VAMPIRE
	description = "失去所有原有技能，并牺牲部分生命值和伤害，换取大量护甲、少量移速、更快的攻击速度，以及一组刺客技能。用突进扰乱对手，再用连击向前横扫，最多击中并减速三个高个子，每命中一个都能治疗自己。特殊的范围尾部突刺可将高个子击退，直接命中伤害更高；若将其撞向墙壁，还会造成额外伤害和眩晕。最后，可用咬头处决昏迷的高个子，治疗自身伤口。"
	flavor_description = "毫不留情！把他们全部杀光！"
	icon_state_prefix = "Vampire"

	actions_to_remove = list(
		/datum/action/xeno_action/onclick/lurker_invisibility,
		/datum/action/xeno_action/onclick/lurker_assassinate,
		/datum/action/xeno_action/activable/pounce/lurker,
		/datum/action/xeno_action/activable/tail_stab,
	)
	actions_to_add = list(
		/datum/action/xeno_action/activable/pounce/rush,
		/datum/action/xeno_action/activable/flurry,
		/datum/action/xeno_action/activable/tail_jab,
		/datum/action/xeno_action/activable/headbite,
	)

/datum/xeno_strain/vampire/apply_strain(mob/living/carbon/xenomorph/lurker/lurker)
	lurker.plasmapool_modifier = 0
	lurker.health_modifier -= XENO_HEALTH_MOD_MED
	lurker.speed_modifier += XENO_SPEED_FASTMOD_TIER_1
	lurker.armor_modifier += XENO_ARMOR_MOD_LARGE
	lurker.damage_modifier -= XENO_DAMAGE_MOD_VERY_SMALL
	lurker.attack_speed_modifier -= 2

	var/datum/mob_hud/execute_hud = GLOB.huds[MOB_HUD_EXECUTE]
	execute_hud.add_hud_to(lurker, lurker)
	lurker.execute_hud = TRUE

	lurker.recalculate_everything()
