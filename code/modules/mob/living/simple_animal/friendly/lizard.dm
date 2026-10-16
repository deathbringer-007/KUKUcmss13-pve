/mob/living/simple_animal/lizard
	name = "蜥蜴"
	desc = "一只可爱的小蜥蜴。"
	icon = 'icons/mob/critter.dmi'
	icon_state = "lizard"
	icon_living = "lizard"
	icon_dead = "lizard-dead"
	mob_size = MOB_SIZE_SMALL
	speak_emote = list("嘶嘶叫")
	health = 5
	maxHealth = 5
	attacktext = "咬"
	attacktext = "咬"
	melee_damage_lower = 1
	melee_damage_upper = 2
	response_help  = "抚摸"
	response_disarm = "驱赶"
	response_harm   = "踩踏"
	black_market_value = 50
	dead_black_market_value = 0
	squeeze_under = TRUE
	status_flags = parent_type::status_flags & ~CANPUSH
	layer = 3.5

/mob/living/simple_animal/lizard/lexi
	name = "莱克茜"
	desc = "阿波斯泰的宠物，也是维兰德-汤谷财力的象征。这只小蜥蜴几年前生病后，换上了一条做工精巧的义肢。公司连宠物身上都舍得花这么多钱，又能给你什么待遇呢？它多半比你的自然寿命还长。"
	icon_state = "lexi"
	icon_living = "lexi"
