//Look Sir, free crabs!
/mob/living/simple_animal/crab
	name = "螃蟹"
	desc = "有着坚硬外壳的甲壳动物，似乎对整天无所事事很满意。"
	icon_state = "crab"
	icon_living = "crab"
	icon_dead = "crab_dead"
	mob_size = MOB_SIZE_SMALL
	speak_emote = list("咔哒作响")
	emote_hear = list("咔哒作响")
	emote_see = list("咔嗒作响")
	speak_chance = 1
	turns_per_move = 5
	meat_type = /obj/item/reagent_container/food/snacks/meat
	response_help  = "抚摸"
	response_disarm = "轻轻推开"
	response_harm   = "踩踏"
	stop_automated_movement = 1
	friendly = "pinches"
	black_market_value = 50
	dead_black_market_value = 0
	var/obj/item/inventory_head
	var/obj/item/inventory_mask

/mob/living/simple_animal/crab/Life(delta_time)
	..()
	//CRAB movement
	if(!ckey && !stat)
		if(isturf(src.loc) && !resting && !buckled) //This is so it only moves if it's not inside a closet, gentics machine, etc.
			turns_since_move++
			if(turns_since_move >= turns_per_move)
				Move(get_step(src,pick(4,8)))
				turns_since_move = 0
	regenerate_icons()

//COFFEE! SQUEEEEEEEEE!
/mob/living/simple_animal/crab/Coffee
	name = "咖啡"
	real_name = "咖啡"
	desc = "这是咖啡，另一只宠物！"
	response_help  = "抚摸"
	response_disarm = "轻轻推开"
	response_harm   = "踩踏"
