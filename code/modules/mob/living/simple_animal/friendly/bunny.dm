//Bunny
/mob/living/simple_animal/bunny
	name = "兔子"
	desc = "一只小白兔，据说喜欢胡萝卜。"
	icon_state = "bunny"
	icon_living = "bunny"
	icon_dead = "bunny_dead"
	emote_hear = list("发出呼噜声", "哼哼", "吱吱叫")
	emote_see = list("扇动耳朵", "嗅了嗅")
	speak_chance = 1
	turns_per_move = 5
	meat_type = /obj/item/reagent_container/food/snacks/meat
	response_help  = "抚摸"
	response_disarm = "轻轻推开"
	response_harm   = "踢"
	friendly = "轻咬"
	black_market_value = 50
	dead_black_market_value = 0

/mob/living/simple_animal/bunny/dave
	name = "戴夫"
	desc = "戴夫，镇上最酷的兔子。"
	icon_state = "dave"
	icon_living = "dave"
	icon_dead = "dave_dead"
