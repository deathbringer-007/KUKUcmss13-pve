//Corgi
/mob/living/simple_animal/corgi
	name = "\improper 柯基犬"
	real_name = "柯基犬"
	desc = "一只柯基犬。"
	icon_state = "corgi"
	icon_living = "corgi"
	icon_dead = "corgi_dead"
	speak = list("汪", "汪！", "汪汪！", "嗷呜——")
	speak_emote = list("汪汪叫", "汪汪叫")
	emote_hear = list("汪汪叫", "汪汪叫", "吠叫","喘着气")
	emote_see = list("摇了摇头", "打了个哆嗦")
	speak_chance = 1
	turns_per_move = 10
	meat_type = /obj/item/reagent_container/food/snacks/meat/corgi
	meat_amount = 3
	response_help  = "抚摸"
	response_disarm = "轻拍"
	response_harm   = "踢"
	see_in_dark = 5
	mob_size = MOB_SIZE_SMALL
	black_market_value = 50
	dead_black_market_value = 0
	var/obj/item/inventory_head
	var/obj/item/inventory_back
	var/facehugger

//IAN! SQUEEEEEEEEE~
/mob/living/simple_animal/corgi/Ian
	name = "伊恩"
	real_name = "伊恩" //Intended to hold the name without altering it.
	gender = MALE
	desc = "一只柯基犬。"
	var/turns_since_scan = 0
	var/obj/movement_target
	response_help  = "抚摸"
	response_disarm = "轻拍"
	response_harm   = "踢"

/mob/living/simple_animal/corgi/Ian/Life(delta_time)
	..()
	INVOKE_ASYNC(src, PROC_REF(look_for_food))

/mob/living/simple_animal/corgi/Ian/proc/look_for_food()
	//Feeding, chasing food, FOOOOODDDD
	if(!stat && !resting && !buckled)
		turns_since_scan++
		if(turns_since_scan > 5)
			turns_since_scan = 0
			if((movement_target) && !(isturf(movement_target.loc) || ishuman(movement_target.loc) ))
				movement_target = null
				stop_automated_movement = 0
			if( !movement_target || !(movement_target.loc in oview(src, 3)) )
				movement_target = null
				stop_automated_movement = 0
				for(var/obj/item/reagent_container/food/snacks/S in oview(src,3))
					if(isturf(S.loc) || ishuman(S.loc))
						movement_target = S
						break
			if(movement_target)
				stop_automated_movement = 1
				step_to(src,movement_target,1)
				sleep(3)
				step_to(src,movement_target,1)
				sleep(3)
				step_to(src,movement_target,1)

				if(movement_target) //Not redundant due to sleeps, Item can be gone in 6 decisecomds
					if (movement_target.loc.x < src.x)
						setDir(WEST)
					else if (movement_target.loc.x > src.x)
						setDir(EAST)
					else if (movement_target.loc.y < src.y)
						setDir(SOUTH)
					else if (movement_target.loc.y > src.y)
						setDir(NORTH)
					else
						setDir(SOUTH)

					if(isturf(movement_target.loc) )
						movement_target.attack_animal(src)
					else if(ishuman(movement_target.loc) )
						if(prob(20))
							INVOKE_ASYNC(src, PROC_REF(emote), "一脸可怜地盯着[movement_target.loc]拿着的[movement_target]")

		if(prob(1))
			INVOKE_ASYNC(src, PROC_REF(emote), pick("蹦蹦跳跳", "追着自己的尾巴转圈"))
			spawn(0)
				for(var/i in list(1,2,4,8,4,2,1,2,4,8,4,2,1,2,4,8,4,2))
					setDir(i)
					sleep(1)

/mob/living/simple_animal/corgi/death()
	. = ..()
	if(!.) return //was already dead
	if(last_damage_data)
		var/mob/user = last_damage_data.resolve_mob()
		if(user)
			user.count_niche_stat(STATISTICS_NICHE_CORGI)

/obj/item/reagent_container/food/snacks/meat/corgi
	name = "柯基肉"
	desc = "尝起来像……嗯，你懂的……"


/mob/living/simple_animal/corgi/attackby(obj/item/O as obj, mob/user as mob)  //Marker -Agouri
	if(istype(O, /obj/item/newspaper))
		if(!stat)
			for(var/mob/M as anything in viewers(user, null))
				if ((M.client && !( M.blinded )))
					M.show_message(SPAN_NOTICE("[user]用卷起来的[O]轻拍[name]的鼻子。"), SHOW_MESSAGE_VISIBLE)
			spawn(0)
				for(var/i in list(1,2,4,8,4,2,1,2))
					setDir(i)
					sleep(1)
	else
		..()

/mob/living/simple_animal/corgi/regenerate_icons()
	overlays = list()

	if(inventory_head)
		var/head_icon_state = inventory_head.icon_state
		if(health <= 0)
			head_icon_state += "2"

		var/icon/head_icon = image('icons/mob/humans/onmob/corgi_head.dmi',head_icon_state)
		if(head_icon)
			overlays += head_icon

	if(inventory_back)
		var/back_icon_state = inventory_back.icon_state
		if(health <= 0)
			back_icon_state += "2"

		var/icon/back_icon = image('icons/mob/humans/onmob/corgi_back.dmi',back_icon_state)
		if(back_icon)
			overlays += back_icon

	if(facehugger)
		if(istype(src, /mob/living/simple_animal/corgi/puppy))
			overlays += image('icons/mob/humans/onmob/mask.dmi',"facehugger_corgipuppy")
		else
			overlays += image('icons/mob/humans/onmob/mask.dmi',"facehugger_corgi")

	return


/mob/living/simple_animal/corgi/puppy
	name = "\improper 柯基幼犬"
	real_name = "柯基犬"
	desc = "一只柯基幼犬。"
	icon_state = "puppy"
	icon_living = "puppy"
	icon_dead = "puppy_dead"

//pupplies cannot wear anything.
/mob/living/simple_animal/corgi/puppy/Topic(href, href_list)
	if(href_list["remove_inv"] || href_list["add_inv"])
		to_chat(usr, SPAN_DANGER("你没法给[src]戴上这个。"))
		return
	..()


//LISA! SQUEEEEEEEEE~
/mob/living/simple_animal/corgi/Lisa
	name = "莉萨"
	real_name = "莉萨"
	gender = FEMALE
	desc = "一只戴着可爱粉色蝴蝶结的柯基犬。"
	icon_state = "lisa"
	icon_living = "lisa"
	icon_dead = "lisa_dead"
	response_help  = "抚摸"
	response_disarm = "轻拍"
	response_harm   = "踢"
	var/turns_since_scan = 0
	var/puppies = 0

//Lisa already has a cute bow!
/mob/living/simple_animal/corgi/Lisa/Topic(href, href_list)
	if(href_list["remove_inv"] || href_list["add_inv"])
		to_chat(usr, SPAN_DANGER("[src]已经戴着一个可爱的蝴蝶结了！"))
		return
	..()

/mob/living/simple_animal/corgi/Lisa/Life(delta_time)
	..()

	if(!stat && !resting && !buckled)
		turns_since_scan++
		if(turns_since_scan > 15)
			turns_since_scan = 0
			var/alone = 1
			var/ian = 0
			for(var/mob/M in oviewers(7, src))
				if(istype(M, /mob/living/simple_animal/corgi/Ian))
					if(M.client)
						alone = 0
						break
					else
						ian = M
				else
					alone = 0
					break
			if(alone && ian && puppies < 4)
				new /mob/living/simple_animal/corgi/puppy(loc)


		if(prob(1))
			INVOKE_ASYNC(src, PROC_REF(emote), pick("蹦蹦跳跳", "追着自己的尾巴转圈"))
			spawn(0)
				for(var/i in list(1,2,4,8,4,2,1,2,4,8,4,2,1,2,4,8,4,2))
					setDir(i)
					sleep(1)
