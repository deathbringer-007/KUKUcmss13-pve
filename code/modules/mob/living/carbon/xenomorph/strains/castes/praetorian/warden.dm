/datum/xeno_strain/warden
	// i mean so basically im braum
	name = PRAETORIAN_WARDEN
	localized_name = "守护者"
	description = "你舍弃酸液球、喷洒酸液、疾冲，以及少量爪击伤害和移速，成为高效的治疗者。你获得强力信息素、将陷入危险且倒地或休息的同伴拉到身边的回收技能，以及一个可通过爪击敌人补充的内部生命储备池。你可以消耗储备，为自己或同伴治疗伤势、清除异常状态。"
	flavor_description = "在姐妹们赢得应有的死亡之前，它不许她们死去。战斗，或被遗忘。"
	icon_state_prefix = "Warden"

	actions_to_remove = list(
		/datum/action/xeno_action/activable/xeno_spit,
		/datum/action/xeno_action/activable/pounce/base_prae_dash,
		/datum/action/xeno_action/activable/prae_acid_ball,
		/datum/action/xeno_action/activable/spray_acid/base_prae_spray_acid,
		/datum/action/xeno_action/onclick/tacmap,
	)
	actions_to_add = list(
		/datum/action/xeno_action/onclick/emit_pheromones,
		/datum/action/xeno_action/activable/xeno_spit,
		/datum/action/xeno_action/activable/spray_acid/prae_warden,
		/datum/action/xeno_action/activable/warden_heal,
		/datum/action/xeno_action/activable/prae_retrieve,
		/datum/action/xeno_action/onclick/prae_switch_heal_type,
		/datum/action/xeno_action/onclick/tacmap,
	)

	behavior_delegate_type = /datum/behavior_delegate/praetorian_warden

/datum/xeno_strain/warden/apply_strain(mob/living/carbon/xenomorph/praetorian/prae)
	// Make a 'halftank'
	prae.speed_modifier += XENO_SPEED_SLOWMOD_TIER_5
	prae.damage_modifier -= XENO_DAMAGE_MOD_SMALL

	prae.recalculate_everything()

/datum/behavior_delegate/praetorian_warden
	name = "Praetorian Warden Behavior Delegate"

	// Config
	var/internal_hitpoints_max = 350
	var/internal_hitpoints_per_attack = 50
	var/internal_hp_per_life = 5


	// State
	var/internal_hitpoints = 0
	var/transferred_healing = 0

/datum/behavior_delegate/praetorian_warden/append_to_stat()
	. = list()
	. += "能量储备：[internal_hitpoints]/[internal_hitpoints_max]"
	. += "累计治疗量：[transferred_healing]"

/datum/behavior_delegate/praetorian_warden/on_life()
	internal_hitpoints = min(internal_hitpoints_max, internal_hitpoints + internal_hp_per_life)

	var/mob/living/carbon/xenomorph/praetorian/praetorian = bound_xeno
	var/image/holder = praetorian.hud_list[PLASMA_HUD]
	holder.overlays.Cut()

	if(praetorian.stat == DEAD)
		return

	var/percentage_energy = round((internal_hitpoints / internal_hitpoints_max) * 100, 10)
	if(percentage_energy)
		holder.overlays += image('icons/mob/hud/hud.dmi', "xenoenergy[percentage_energy]")

/datum/behavior_delegate/praetorian_warden/handle_death(mob/M)
	var/image/holder = bound_xeno.hud_list[PLASMA_HUD]
	holder.overlays.Cut()

/datum/behavior_delegate/praetorian_warden/melee_attack_additional_effects_self()
	..()

	add_internal_hitpoints(internal_hitpoints_per_attack)

/datum/behavior_delegate/praetorian_warden/ranged_attack_additional_effects_target(atom/target_atom)
	if(ismob(target_atom))
		add_internal_hitpoints(internal_hitpoints_per_attack)

/datum/behavior_delegate/praetorian_warden/proc/add_internal_hitpoints(amount)
	if (amount > 0)
		if (internal_hitpoints >= internal_hitpoints_max)
			return
		to_chat(bound_xeno, SPAN_XENODANGER("你感到体内的生命储备增加了！"))
	internal_hitpoints = clamp(internal_hitpoints + amount, 0, internal_hitpoints_max)

/datum/behavior_delegate/praetorian_warden/proc/remove_internal_hitpoints(amount)
	add_internal_hitpoints(-1*amount)

/datum/behavior_delegate/praetorian_warden/proc/use_internal_hp_ability(cost)
	if (cost > internal_hitpoints)
		to_chat(bound_xeno, SPAN_XENODANGER("你的生命储备不足！至少需要[cost]才能这样做！"))
		return FALSE
	else
		remove_internal_hitpoints(cost)
		return TRUE
