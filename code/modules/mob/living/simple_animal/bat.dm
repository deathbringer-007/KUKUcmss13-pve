/mob/living/simple_animal/bat
	name = "蝙蝠"
	desc = "一只阴森森的蝙蝠！"
	icon = 'icons/mob/animal.dmi'
	icon_state = "bat"
	icon_living = "bat"
	icon_dead = "bat_dead"
	mob_size = MOB_SIZE_SMALL
	speak = list("吱——")
	speak_emote = list("发出尖叫")
	emote_hear = list("发出尖叫")

/mob/living/simple_animal/bat/initialize_pass_flags(datum/pass_flags_container/PF)
	..()
	if (PF)
		PF.flags_pass = PASS_OVER|PASS_FLAGS_CRAWLER

/mob/living/simple_animal/bat/Life(delta_time)
	. = ..()
	if(!ckey && stat == CONSCIOUS && prob(5))
		if(locate(/turf/closed,get_step(src, NORTH)))
			set_stat(UNCONSCIOUS)
			icon_state = "bat_hanging"
			wander = 0
			speak_chance = 0
	else if(ckey || (stat == UNCONSCIOUS && prob(5)))
		set_stat(CONSCIOUS)
		icon_state = "bat"
		wander = 1
