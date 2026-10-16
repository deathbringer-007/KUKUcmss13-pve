/mob/living/simple_animal/hostile/tree
	name = "松树"
	desc = "一种怒气冲冲的树形外星生物，似乎被庆祝活动惹恼了……"
	icon = 'icons/obj/structures/props/pinetrees.dmi'
	icon_state = "pine_1"
	icon_living = "pine_1"
	icon_dead = "pine_1"
	icon_gib = "pine_1"
	speak_chance = 0
	turns_per_move = 5
	meat_type = /obj/item/reagent_container/food/snacks/carpmeat
	response_help = "轻拂"
	response_disarm = "推了推"
	response_harm = "击打"
	speed = -1
	maxHealth = 250
	health = 250

	pixel_x = -16

	harm_intent_damage = 5
	melee_damage_lower = 8
	melee_damage_upper = 12
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

	faction = "carp"

/mob/living/simple_animal/hostile/tree/FindTarget()
	. = ..()
	if(.)
		emote("growls at [.]")

/mob/living/simple_animal/hostile/tree/AttackingTarget()
	. =..()
	var/mob/living/L = .
	if(istype(L))
		if(prob(15))
			L.apply_effect(3, WEAKEN)
			L.visible_message(SPAN_DANGER("[src]撞倒了[L]！"))

/mob/living/simple_animal/hostile/tree/death()
	..(null,"被劈成了碎片！")
	new /obj/item/stack/sheet/wood(loc)
	qdel(src)
