//goat
/mob/living/simple_animal/hostile/retaliate/goat
	name = "山羊"
	desc = "脾气不怎么好。"
	icon_state = "goat"
	icon_living = "goat"
	icon_dead = "goat_dead"
	speak = list("咩咩咩咩","咩？")
	speak_emote = list("咩咩叫")
	emote_hear = list("咩咩叫")
	emote_see = list("摇了摇头", "跺了跺脚", "怒视四周")
	speak_chance = 1
	turns_per_move = 5
	see_in_dark = 6
	meat_type = /obj/item/reagent_container/food/snacks/meat
	meat_amount = 4
	response_help  = "抚摸"
	response_disarm = "轻轻推开"
	response_harm   = "踢"
	faction = "goat"
	attacktext = "踢"
	health = 40
	melee_damage_lower = 1
	melee_damage_upper = 5
	var/datum/reagents/udder = null

/mob/living/simple_animal/hostile/retaliate/goat/Initialize()
	udder = new(50)
	udder.my_atom = src
	. = ..()

/mob/living/simple_animal/hostile/retaliate/goat/Destroy()
	if(udder)
		udder.my_atom = null
	QDEL_NULL(udder)
	return ..()

/mob/living/simple_animal/hostile/retaliate/goat/Life(delta_time)
	. = ..()
	if(.)
		//chance to go crazy and start wacking stuff
		if(!length(enemies) && prob(1))
			Retaliate()

		if(length(enemies) && prob(10))
			enemies = list()
			LoseTarget()
			src.visible_message(SPAN_NOTICE("[src]平静了下来。"))

		if(stat == CONSCIOUS)
			if(udder && prob(5))
				udder.add_reagent("milk", rand(5, 10))

		if(locate(/obj/effect/plantsegment) in loc)
			var/obj/effect/plantsegment/SV = locate(/obj/effect/plantsegment) in loc
			qdel(SV)
			if(prob(10))
				INVOKE_ASYNC(src, PROC_REF(say), "吧唧")

		if(!pulledby)
			for(var/direction in shuffle(list(1,2,4,8,5,6,9,10)))
				var/step = get_step(src, direction)
				if(step)
					if(locate(/obj/effect/plantsegment) in step)
						Move(step)

/mob/living/simple_animal/hostile/retaliate/goat/Retaliate()
	..()
	src.visible_message(SPAN_DANGER("[src]眼中闪过一道凶光。"))

/mob/living/simple_animal/hostile/retaliate/goat/Move()
	..()
	if(!stat)
		if(locate(/obj/effect/plantsegment) in loc)
			var/obj/effect/plantsegment/SV = locate(/obj/effect/plantsegment) in loc
			qdel(SV)
			if(prob(10))
				INVOKE_ASYNC(src, PROC_REF(say), "吧唧")

/mob/living/simple_animal/hostile/retaliate/goat/attackby(obj/item/O as obj, mob/user as mob)
	var/obj/item/reagent_container/glass/G = O
	if(stat == CONSCIOUS && istype(G) && G.is_open_container())
		user.visible_message(SPAN_NOTICE("[user]用[O]给[src]挤奶。"))
		var/transfered = udder.trans_id_to(G, "milk", rand(5,10))
		if(G.reagents.total_volume >= G.volume)
			to_chat(user, SPAN_DANGER("[O]已经满了。"))
		if(!transfered)
			to_chat(user, SPAN_DANGER("奶已经挤完了，再等一会儿吧……"))
	else
		..()
//cow
/mob/living/simple_animal/cow
	name = "奶牛"
	desc = "以产奶闻名，别把它推倒就好。"
	icon_state = "cow"
	icon_living = "cow"
	icon_dead = "cow_dead"
	icon_gib = "cow_gib"
	speak = list("哞？","哞","哞——")
	speak_emote = list("哞哞叫","发出悠长的哞叫")
	emote_hear = list("咩咩叫")
	emote_see = list("摇了摇头")
	speak_chance = 1
	turns_per_move = 5
	see_in_dark = 6
	meat_type = /obj/item/reagent_container/food/snacks/meat
	meat_amount = 6
	response_help  = "抚摸"
	response_disarm = "轻轻推开"
	response_harm   = "踢"
	attacktext = "踢"
	health = 50
	var/datum/reagents/udder = null

/mob/living/simple_animal/cow/New()
	udder = new(50)
	udder.my_atom = src
	..()

/mob/living/simple_animal/cow/Destroy()
	if(udder)
		udder.my_atom = null
	QDEL_NULL(udder)
	return ..()

/mob/living/simple_animal/cow/attackby(obj/item/O as obj, mob/user as mob)
	var/obj/item/reagent_container/glass/G = O
	if(stat == CONSCIOUS && istype(G) && G.is_open_container())
		user.visible_message(SPAN_NOTICE("[user]用[O]给[src]挤奶。"))
		var/transfered = udder.trans_id_to(G, "milk", rand(5,10))
		if(G.reagents.total_volume >= G.volume)
			to_chat(user, SPAN_DANGER("[O]已经满了。"))
		if(!transfered)
			to_chat(user, SPAN_DANGER("奶已经挤完了，再等一会儿吧……"))
	else
		..()

/mob/living/simple_animal/cow/Life(delta_time)
	. = ..()
	if(stat == CONSCIOUS)
		if(udder && prob(5))
			udder.add_reagent("milk", rand(5, 10))

/mob/living/simple_animal/cow/death()
	. = ..()
	if(!.) return //was already dead
	if(last_damage_data)
		var/mob/user = last_damage_data.resolve_mob()
		if(user)
			user.count_niche_stat(STATISTICS_NICHE_COW)

/mob/living/simple_animal/cow/attack_hand(mob/living/carbon/M as mob)
	if(!stat && M.a_intent == INTENT_DISARM && icon_state != icon_dead)
		M.visible_message(SPAN_WARNING("[M]推倒了[src]。"), \
			SPAN_NOTICE("你推倒了[src]。"))
		apply_effect(30, WEAKEN)
		icon_state = icon_dead
		spawn(rand(20,50))
			if(!stat && M)
				icon_state = icon_living
				var/list/responses = list( "[src]用恳求的目光看着你。",
											"[src]哀求地看着你。",
											"[src]无奈地看着你。",
											"[src]似乎认命了。")
				to_chat(M, pick(responses))
	else
		..()

/mob/living/simple_animal/chick
	name = "\improper 小鸡"
	desc = "真可爱！就是叫起来太吵了。"
	icon_state = "chick"
	icon_living = "chick"
	icon_dead = "chick_dead"
	icon_gib = "chick_gib"
	speak = list("啾。","啾？","啾啾。","叽！")
	speak_emote = list("叽叽叫")
	emote_hear = list("叽叽叫")
	emote_see = list("啄着地面","拍打小翅膀")
	speak_chance = 2
	turns_per_move = 2
	meat_type = /obj/item/reagent_container/food/snacks/meat
	meat_amount = 1
	response_help  = "抚摸"
	response_disarm = "轻轻推开"
	response_harm   = "踢"
	attacktext = "踢"
	health = 1
	var/amount_grown = 0
	mob_size = MOB_SIZE_SMALL

/mob/living/simple_animal/chick/New()
	..()
	pixel_x = rand(-6, 6)
	pixel_y = rand(0, 10)

/mob/living/simple_animal/chick/initialize_pass_flags(datum/pass_flags_container/PF)
	..()
	if (PF)
		PF.flags_pass = PASS_UNDER

/mob/living/simple_animal/chick/Life(delta_time)
	. =..()
	if(!.)
		return
	if(!stat)
		amount_grown += rand(1,2)
		if(amount_grown >= 100)
			new /mob/living/simple_animal/chicken(src.loc)
			qdel(src)

GLOBAL_VAR_INIT(MAX_CHICKENS, 50)
GLOBAL_VAR_INIT(chicken_count, 0)

/mob/living/simple_animal/chicken
	name = "\improper 鸡"
	desc = "希望这一季的鸡蛋品质不错。"
	icon_state = "chicken"
	icon_living = "chicken"
	icon_dead = "chicken_dead"
	speak = list("咯咯！","咯——咯咯咯！","咯咯。")
	speak_emote = list("咯咯叫","轻声低鸣")
	emote_hear = list("咯咯叫")
	emote_see = list("啄着地面","猛烈拍打翅膀")
	speak_chance = 2
	turns_per_move = 3
	meat_type = /obj/item/reagent_container/food/snacks/meat
	meat_amount = 2
	response_help  = "抚摸"
	response_disarm = "轻轻推开"
	response_harm   = "踢"
	attacktext = "踢"
	health = 10
	var/eggsleft = 0
	var/body_color
	mob_size = MOB_SIZE_SMALL

/mob/living/simple_animal/chicken/New()
	..()
	if(!body_color)
		body_color = pick( list("brown","black","white") )
	icon_state = "chicken_[body_color]"
	icon_living = "chicken_[body_color]"
	icon_dead = "chicken_[body_color]_dead"
	pixel_x = rand(-6, 6)
	pixel_y = rand(0, 10)
	GLOB.chicken_count++

/mob/living/simple_animal/chicken/initialize_pass_flags(datum/pass_flags_container/PF)
	..()
	if (PF)
		PF.flags_pass = PASS_UNDER

/mob/living/simple_animal/chicken/death()
	..()
	GLOB.chicken_count--
	if(last_damage_data)
		var/mob/user = last_damage_data.resolve_mob()
		if(user)
			user.count_niche_stat(STATISTICS_NICHE_CHICKEN)

/mob/living/simple_animal/chicken/attackby(obj/item/O as obj, mob/user as mob)
	if(istype(O, /obj/item/reagent_container/food/snacks/grown/wheat)) //feedin' dem chickens
		if(!stat && eggsleft < 8)
			user.visible_message(SPAN_NOTICE("[user]把[O]喂给[name]！它高兴地咯咯叫着。"),SPAN_NOTICE("你把[O]喂给[name]！它高兴地咯咯叫着。"))
			user.drop_held_item()
			qdel(O)
			eggsleft += rand(1, 4)
			//world << eggsleft
		else
			to_chat(user, SPAN_NOTICE("[name]看起来并不饿！"))
	else
		..()

/mob/living/simple_animal/chicken/Life(delta_time)
	. =..()
	if(!.)
		return
	if(!stat && prob(3) && eggsleft > 0)
		visible_message("[src][pick("下了一个蛋。","蹲下来轻声低鸣。","开始大声吵闹。","开始嘈杂地咯咯叫。")]")
		eggsleft--
		var/obj/item/reagent_container/food/snacks/egg/E = new(get_turf(src))
		E.pixel_x = rand(-6,6)
		E.pixel_y = rand(-6,6)
		if(GLOB.chicken_count < GLOB.MAX_CHICKENS && prob(10))
			START_PROCESSING(SSobj, E)

/obj/item/reagent_container/food/snacks/egg/var/amount_grown = 0
/obj/item/reagent_container/food/snacks/egg/process()
	if(isturf(loc))
		amount_grown += rand(1,2)
		if(amount_grown >= 100)
			visible_message("[src]伴着轻轻的碎裂声孵化了。")
			new /mob/living/simple_animal/chick(get_turf(src))
			STOP_PROCESSING(SSobj, src)
			qdel(src)
	else
		STOP_PROCESSING(SSobj, src)

/obj/item/reagent_container/food/snacks/egg/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()
