/mob/living/proc/ventcrawl()
	set name = "钻入通风管"
	set desc = "进入通风口，沿管道系统爬行。"
	set category = "Abilities"
	handle_ventcrawl()
	return

/mob/living/proc/hide()
	set name = "躲藏"
	set desc = "切换躲藏状态，可藏在桌子或某些物品下方。"
	set category = "Abilities"

	if (layer != ANIMAL_HIDING_LAYER)
		layer = ANIMAL_HIDING_LAYER
		to_chat(src, text(SPAN_NOTICE("你躲了起来。")))
	else
		layer = MOB_LAYER
		to_chat(src, text(SPAN_NOTICE("你不再躲藏。")))
