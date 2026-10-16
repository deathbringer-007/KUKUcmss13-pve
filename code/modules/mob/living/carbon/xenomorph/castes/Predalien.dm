/datum/caste_datum/predalien
	caste_type = XENO_CASTE_PREDALIEN
	display_name = "Abomination"

	melee_damage_lower = XENO_DAMAGE_TIER_4
	melee_damage_upper = XENO_DAMAGE_TIER_5
	melee_vehicle_damage = XENO_DAMAGE_TIER_5
	max_health = XENO_HEALTH_TIER_9
	plasma_max = XENO_NO_PLASMA
	xeno_explosion_resistance = XENO_EXPLOSIVE_ARMOR_TIER_10
	armor_deflection = XENO_ARMOR_TIER_3
	evasion = XENO_EVASION_NONE
	speed = XENO_SPEED_TIER_7

	evolution_allowed = FALSE
	minimum_evolve_time = 0

	tackle_min = 3
	tackle_max = 6
	tacklestrength_min = 6
	tacklestrength_max = 10

	is_intelligent = TRUE
	tier = 1
	attack_delay = -2
	can_be_queen_healed = FALSE

	behavior_delegate_type = /datum/behavior_delegate/predalien_base

	minimap_icon = "predalien"

/mob/living/carbon/xenomorph/predalien
	AUTOWIKI_SKIP(TRUE)

	caste_type = XENO_CASTE_PREDALIEN
	name = "Abomination" //snowflake name
	desc = "一只外形奇特的生物，头部长着肉质长辫。它看起来仿佛装甲与血肉的结合体，表面光滑，却有坚实的甲壳保护。"
	icon = 'icons/mob/xenos/predalien.dmi'
	icon_xeno = 'icons/mob/xenos/predalien.dmi'
	icon_xenonid = 'icons/mob/xenos/predalien.dmi'
	icon_state = "Predalien Walking"
	speaking_noise = 'sound/voice/predalien_click.ogg'
	plasma_types = list(PLASMA_CATECHOLAMINE)
	faction = FACTION_PREDALIEN
	claw_type = CLAW_TYPE_VERY_SHARP
	wall_smash = TRUE
	hardcore = FALSE
	pixel_x = -16
	old_x = -16
	mob_size = MOB_SIZE_BIG
	tier = 1
	organ_value = 20000
	age = XENO_NO_AGE //Predaliens are already in their ultimate form, they don't get even better
	show_age_prefix = FALSE
	small_explosives_stun = FALSE

	base_actions = list(
		/datum/action/xeno_action/onclick/xeno_resting,
		/datum/action/xeno_action/onclick/regurgitate,
		/datum/action/xeno_action/watch_xeno,
		/datum/action/xeno_action/activable/tail_stab,
		/datum/action/xeno_action/onclick/feralrush,
		/datum/action/xeno_action/onclick/predalien_roar,
		/datum/action/xeno_action/activable/feral_smash,
		/datum/action/xeno_action/activable/feralfrenzy,
		/datum/action/xeno_action/onclick/toggle_gut_targeting,
		/datum/action/xeno_action/onclick/tacmap,
	)

	weed_food_icon = 'icons/mob/xenos/weeds_64x64.dmi'
	weed_food_states = list("Predalien_1","Predalien_2","Predalien_3")
	weed_food_states_flipped = list("Predalien_1","Predalien_2","Predalien_3")
	var/smashing = FALSE
	/// If the pred alert/player notif should happen when the predalien spawns
	var/should_announce_spawn = TRUE



/mob/living/carbon/xenomorph/predalien/Initialize(mapload, mob/living/carbon/xenomorph/oldxeno, h_number)
	. = ..()
	if(should_announce_spawn)
		addtimer(CALLBACK(src, PROC_REF(announce_spawn)), 3 SECONDS)
		hunter_data.dishonored = TRUE
		hunter_data.dishonored_reason = "这是对我们全族荣誉的亵渎！"
		hunter_data.dishonored_set = src
		hud_set_hunter()

	AddComponent(/datum/component/footstep, 4, 25, 11, 2, "alien_footstep_medium")

/mob/living/carbon/xenomorph/predalien/proc/announce_spawn()
	if(!loc)
		return FALSE

	to_chat(src, {"
<span class='role_body'>|______________________|</span>
<span class='role_header'>你是铁血战士与异形的混种！</span>
<span class='role_body'>你是从天敌体内诞生的异形。整个铁血战士种族都将你视为亵渎之物，会不惜一切代价杀死你。
但你也继承了宿主的智慧和力量。你有能力与他们抗衡，但并非无敌。与虫巢同伴一起行动，用数量优势压倒敌人。姐妹们为你付出了很多，不要独自游荡、白白送命。
你仍然必须服从女皇。
</span>
<span class='role_body'>|______________________|</span>
"})
	emote("roar")

/mob/living/carbon/xenomorph/predalien/get_organ_icon()
	return "heart_t3"


/mob/living/carbon/xenomorph/predalien/resist_fire()
	..()
	SetKnockDown(0.1 SECONDS)

/mob/living/carbon/xenomorph/predalien/get_examine_text(mob/user)
	. = ..()
	var/datum/behavior_delegate/predalien_base/predalienkills = behavior_delegate
	. += "它已经杀死了[predalienkills.kills]个猎物！"

/mob/living/carbon/xenomorph/predalien/tutorial
	AUTOWIKI_SKIP(TRUE)

	should_announce_spawn = FALSE

/mob/living/carbon/xenomorph/predalien/tutorial/gib(datum/cause_data/cause = create_cause_data("gibbing", src))
	death(cause, gibbed = TRUE)


/datum/behavior_delegate/predalien_base
	name = "Base Predalien Behavior Delegate"

	var/kills = 0
	var/max_kills = 10

/datum/behavior_delegate/predalien_base/append_to_stat()
	. = list()
	. += "击杀数：[kills]/[max_kills]"

/datum/behavior_delegate/predalien_base/on_kill_mob(mob/M)
	. = ..()

	kills = min(kills + 1, max_kills)

/datum/behavior_delegate/predalien_base/melee_attack_modify_damage(original_damage, mob/living/carbon/attacked_mob)
	if(ishuman(attacked_mob))
		var/mob/living/carbon/human/attacked_human = attacked_mob
		if(isspeciesyautja(attacked_human))
			original_damage *= 1.5

	return original_damage + kills * 2.5
