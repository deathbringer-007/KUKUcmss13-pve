/mob/living/simple_animal/hostile/russian
	name = "俄罗斯人"
	desc = "为了祖国！"
	icon_state = "russianmelee"
	icon_living = "russianmelee"
	icon_dead = "russianmelee_dead"
	icon_gib = "syndicate_gib"
	speak_chance = 0
	turns_per_move = 5
	response_help = "戳了戳"
	response_disarm = "猛推"
	response_harm = "击打"
	speed = 4
	stop_automated_movement_when_pulled = 0
	maxHealth = 100
	health = 100
	harm_intent_damage = 5
	melee_damage_lower = 15
	melee_damage_upper = 15
	attacktext = "拳击"
	a_intent = INTENT_HARM
	min_oxy = 5
	max_oxy = 0
	min_tox = 0
	max_tox = 1
	min_co2 = 0
	max_co2 = 5
	min_n2 = 0
	max_n2 = 0
	unsuitable_atoms_damage = 15
	faction = FACTION_UPP
	status_flags = CANPUSH


/mob/living/simple_animal/hostile/russian/ranged
	icon_state = "russianranged"
	icon_living = "russianranged"
	ranged = 1
	projectiletype = /obj/projectile
	projectilesound = 'sound/weapons/Gunshot.ogg'
	casingtype = null


/mob/living/simple_animal/hostile/UPP
	name = "UPP士兵"
	desc = "一名效力于UPP海军的士兵。"
	icon_state = "uppmarine"
	icon_living = "uppmarine"
	icon_dead = "uppmarinedead"
	icon_gib = "syndicate_gib"
	speak_chance = 0
	turns_per_move = 5
	response_help = "戳了戳"
	response_disarm = "猛推"
	response_harm = "击打"
	speed = 4
	stop_automated_movement_when_pulled = 0
	maxHealth = 100
	health = 100
	harm_intent_damage = 5
	melee_damage_lower = 15
	melee_damage_upper = 15
	attacktext = "拳击"
	a_intent = INTENT_HARM
	min_oxy = 5
	max_oxy = 0
	min_tox = 0
	max_tox = 1
	min_co2 = 0
	max_co2 = 5
	min_n2 = 0
	max_n2 = 0
	unsuitable_atoms_damage = 15
	faction = FACTION_UPP
	status_flags = CANPUSH


/mob/living/simple_animal/hostile/UPP/ranged
	ranged = 1
	projectiletype = /obj/projectile
	projectilesound = 'sound/weapons/Gunshot.ogg'
	casingtype = null

