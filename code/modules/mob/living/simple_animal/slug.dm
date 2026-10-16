/mob/living/simple_animal/alien_slug
	name = "古怪蛞蝓"
	desc = "一种长着细小肢体、外形古怪的蛞蝓状生物。"
	icon = 'icons/mob/animal.dmi'
	icon_state = "slug_movement"
	icon_living = "slug_movement"
	icon_dead = "slug_dead"
	speak = list("咕噜。","咕嘟。","咕噜！")
	speak_emote = list("咕噜叫")
	emote_hear = list("咕噜叫")
	emote_see = list("扭动身体")
	attacktext = "咬"
	response_help  = "抚摸"
	response_disarm = "驱赶"
	response_harm   = "踩踏"
	speak_chance = 1
	turns_per_move = 5
	see_in_dark = 6
	maxHealth = 5
	health = 5
	density = FALSE
	universal_speak = 0
	universal_understand = 1
	squeeze_under = TRUE

/mob/living/simple_animal/alien_slug/Life(delta_time)
	. = ..()
	if(!ckey && stat == CONSCIOUS && prob(0.5))
		set_stat(UNCONSCIOUS)
		icon_state = "slug_resting"
		wander = 0
		speak_chance = 0
	else if(ckey || (stat == UNCONSCIOUS && prob(1)))
		set_stat(CONSCIOUS)
		icon_state = "slug_movement"
		wander = 1

/mob/living/simple_animal/alien_slug/Initialize()
	. = ..()
	add_verb(src, list(
		/mob/living/proc/ventcrawl,
		/mob/living/proc/hide,
	))

/mob/living/simple_animal/alien_slug/start_pulling(atom/movable/AM)//Prevents it from pulling things
	to_chat(src, SPAN_WARNING("你太小了，拉不动任何东西。"))
	return
