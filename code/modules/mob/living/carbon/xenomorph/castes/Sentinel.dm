/datum/caste_datum/sentinel
	caste_type = XENO_CASTE_SENTINEL
	tier = 1

	melee_damage_lower = XENO_DAMAGE_TIER_1
	melee_damage_upper = XENO_DAMAGE_TIER_2
	melee_vehicle_damage = XENO_DAMAGE_TIER_2
	max_health = XENO_HEALTH_TIER_6
	plasma_gain = XENO_PLASMA_GAIN_TIER_5
	plasma_max = XENO_PLASMA_TIER_4
	xeno_explosion_resistance = XENO_EXPLOSIVE_ARMOR_TIER_1
	armor_deflection = XENO_NO_ARMOR
	evasion = XENO_EVASION_NONE
	speed = XENO_SPEED_TIER_7

	caste_desc = "一种较弱的远程作战异形。"
	evolves_to = list(XENO_CASTE_SPITTER)
	deevolves_to = list("Larva")
	acid_level = 1

	tackle_min = 4
	tackle_max = 4
	tackle_chance = 50
	tacklestrength_min = 4
	tacklestrength_max = 4

	behavior_delegate_type = /datum/behavior_delegate/sentinel_base
	minimap_icon = "sentinel"

	minimum_evolve_time = 5 MINUTES

/mob/living/carbon/xenomorph/sentinel
	caste_type = XENO_CASTE_SENTINEL
	name = XENO_CASTE_SENTINEL
	desc = "一种行动滑溜、善于喷吐的异形。"
	icon_size = 48
	icon_state = "Sentinel Walking"
	plasma_types = list(PLASMA_NEUROTOXIN)
	pixel_x = -12
	old_x = -12
	tier = 1
	organ_value = 800
	base_actions = list(
		/datum/action/xeno_action/onclick/xeno_resting,
		/datum/action/xeno_action/onclick/regurgitate,
		/datum/action/xeno_action/watch_xeno,
		/datum/action/xeno_action/activable/tail_stab,
		/datum/action/xeno_action/activable/corrosive_acid/weak,
		/datum/action/xeno_action/activable/slowing_spit, //first macro
		/datum/action/xeno_action/activable/scattered_spit, //second macro
		/datum/action/xeno_action/onclick/paralyzing_slash, //third macro
		/datum/action/xeno_action/onclick/tacmap,
	)
	inherent_verbs = list(
		/mob/living/carbon/xenomorph/proc/vent_crawl,
	)

	icon_xeno = 'icons/mob/xenos/sentinel.dmi'
	icon_xenonid = 'icons/mob/xenonids/sentinel.dmi'

	weed_food_icon = 'icons/mob/xenos/weeds_48x48.dmi'
	weed_food_states = list("Drone_1","Drone_2","Drone_3")
	weed_food_states_flipped = list("Drone_1","Drone_2","Drone_3")

/datum/behavior_delegate/sentinel_base
	name = "Base Sentinel Behavior Delegate"

	// State
	var/next_slash_buffed = FALSE

#define NEURO_TOUCH_DELAY 4 SECONDS

/datum/behavior_delegate/sentinel_base/melee_attack_modify_damage(original_damage, mob/living/carbon/carbon_target)
	if (!next_slash_buffed)
		return original_damage

	if (!isxeno_human(carbon_target))
		return original_damage

	if(skillcheck(carbon_target, SKILL_ENDURANCE, SKILL_ENDURANCE_MAX ))
		carbon_target.visible_message(SPAN_DANGER("[carbon_target]抵抗住了神经毒素！"))
		next_slash_buffed = FALSE
		return original_damage //endurance 5 makes you immune to weak neurotoxin
	if(ishuman(carbon_target))
		var/mob/living/carbon/human/human = carbon_target
		if(human.chem_effect_flags & CHEM_EFFECT_RESIST_NEURO || human.species.flags & NO_NEURO)
			human.visible_message(SPAN_DANGER("[human]抵御了神经毒素的影响！"))
			next_slash_buffed = FALSE
			return //species like zombies or synths are immune to neurotoxin
	if (next_slash_buffed)
		to_chat(bound_xeno, SPAN_XENOHIGHDANGER("我们的攻击附带神经毒素，[carbon_target]即将麻痹倒地！"))
		to_chat(carbon_target, SPAN_XENOHIGHDANGER("[bound_xeno]用涂满神经毒素的利爪划伤了你，你感到自己快要倒下！"))
		carbon_target.sway_jitter(times = 3, steps = floor(NEURO_TOUCH_DELAY/3))
		carbon_target.apply_effect(4, DAZE)
		addtimer(CALLBACK(src, PROC_REF(paralyzing_slash), carbon_target), NEURO_TOUCH_DELAY)
		next_slash_buffed = FALSE
	if(!next_slash_buffed)
		var/datum/action/xeno_action/onclick/paralyzing_slash/ability = get_action(bound_xeno, /datum/action/xeno_action/onclick/paralyzing_slash)
		if (ability && istype(ability))
			ability.button.icon_state = "template"
	return original_damage

#undef NEURO_TOUCH_DELAY

/datum/behavior_delegate/sentinel_base/proc/paralyzing_slash(mob/living/carbon/human/human_target)
	human_target.KnockDown(2)
	human_target.Stun(2)
	to_chat(human_target, SPAN_XENOHIGHDANGER("毒素使你麻痹倒地！"))
