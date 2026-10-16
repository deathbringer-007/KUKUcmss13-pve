

/mob/living/simple_animal/hostile/carp
	name = "太空鲤鱼"
	desc = "长着獠牙、外形似鱼的凶猛生物。"
	icon_state = "carp"
	icon_living = "carp"
	icon_dead = "carp_dead"
	icon_gib = "carp_gib"
	speak_chance = 0
	turns_per_move = 5
	meat_type = /obj/item/reagent_container/food/snacks/carpmeat
	response_help = "抚摸"
	response_disarm = "轻轻推开"
	response_harm = "击打"
	speed = 4
	maxHealth = 25
	health = 25

	harm_intent_damage = 8
	melee_damage_lower = 15
	melee_damage_upper = 15
	attacktext = "咬"
	attack_sound = 'sound/weapons/bite.ogg'

	//Space carp aren't affected by atmos.
	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
	minbodytemp = 0

	break_stuff_probability = 15

	faction = "carp"

/mob/living/simple_animal/hostile/carp/Process_Spacemove(check_drift = 0)
	return 1 //No drifting in space for space carp! //original comments do not steal

/mob/living/simple_animal/hostile/carp/FindTarget()
	. = ..()
	if(.)
		manual_emote("朝[.]龇牙")

/mob/living/simple_animal/hostile/carp/AttackingTarget()
	. =..()
	var/mob/living/L = .
	if(istype(L))
		if(prob(15))
			L.apply_effect(3, WEAKEN)
			L.visible_message(SPAN_DANGER("[src]撞倒了[L]！"))
