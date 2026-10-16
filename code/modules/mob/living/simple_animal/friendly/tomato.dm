/mob/living/simple_animal/tomato
	name = "番茄怪"
	desc = "这颗牛排番茄大得吓人，而且真的长了肉！"
	icon_state = "tomato"
	icon_living = "tomato"
	icon_dead = "tomato_dead"
	speak_chance = 0
	turns_per_move = 5
	maxHealth = 15
	health = 15
	meat_type = /obj/item/reagent_container/food/snacks/tomatomeat
	response_help  = "戳了戳"
	response_disarm = "推开"
	response_harm   = "拍打"
	harm_intent_damage = 5
	melee_damage_upper = 15
	melee_damage_lower = 10
	attacktext = "撕咬"
