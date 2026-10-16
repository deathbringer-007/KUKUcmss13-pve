//Cat
/mob/living/simple_animal/cat
	name = "猫"
	real_name = "猫"
	desc = "一种驯养的猫科宠物，有收养船员的倾向。"
	icon_state = "cat2"
	icon_living = "cat2"
	icon_dead = "cat2_dead"
	speak = list("喵！","咪！","呼噜！","嘶——")
	speak_emote = list("发出呼噜声", "喵喵叫")
	emote_hear = list("喵喵叫","轻声喵叫")
	emote_see = list("摇了摇头", "打了个哆嗦")
	speak_chance = 1
	turns_per_move = 5
	meat_type = /obj/item/reagent_container/food/snacks/meat
	response_help  = "抚摸"
	response_disarm = "轻轻推开"
	response_harm   = "踢"
	status_flags = parent_type::status_flags & ~CANPUSH
	layer = 3.5
	var/turns_since_scan = 0
	/// The target src is moving towards during its hunt.
	var/mob/living/movement_target
	/// The mobs that src will track to hunt and kill.
	var/static/list/hunting_targets = list(
		/mob/living/simple_animal/mouse,
		/mob/living/simple_animal/alien_slug,
		/mob/living/simple_animal/bat,
		/mob/living/simple_animal/parrot,
		/mob/living/simple_animal/chick,
		/mob/living/simple_animal/lizard,
		/mob/living/carbon/xenomorph/facehugger,
		/mob/living/carbon/xenomorph/larva,
	)
	/// The cat will 'play' with dead hunted targets near it until this counter reaches a certain value.
	var/play_counter = 0
	min_oxy = 16 //Require at least 16kPA oxygen
	minbodytemp = 223 //Below -50 Degrees Celcius
	maxbodytemp = 323 //Above 50 Degrees Celcius
	holder_type = /obj/item/holder/cat
	mob_size = MOB_SIZE_SMALL
	black_market_value = 50
	dead_black_market_value = 0
	var/miaow_counter = 0
	var/attack_damage = 25

/mob/living/simple_animal/cat/initialize_pass_flags(datum/pass_flags_container/PF)
	..()
	if (PF)
		PF.flags_pass = PASS_FLAGS_CRAWLER

/mob/living/simple_animal/cat/Destroy()
	movement_target = null
	. = ..()

/mob/living/simple_animal/cat/Life(delta_time)
	//MICE!
	if(stat == DEAD)
		return ..()

	if((src.loc) && isturf(src.loc))
		if(stat != DEAD)
			if(++miaow_counter >= rand(20, 30)) //Increase the meow variable each tick. Play it at random intervals.
				playsound(loc, "cat_meow", 15, 1, 4)
				miaow_counter = 0 //Reset the counter
		if(!stat && !resting && !buckled)
			for(var/mob/prey in view(1,src))
				if(is_type_in_list(prey, hunting_targets) && play_counter < 5 && prey.stat != DEAD)
					var/mob/living/livingprey = prey

					if(livingprey.stat == DEAD) //quick deadcheck
						return

					play_counter++
					visible_message(pick("[src]咬了[livingprey]！","[src]戏弄着[livingprey]。","[src]啃咬着[livingprey]！"))
					movement_target = null
					stop_automated_movement = 0

					animation_attack_on(livingprey)
					flick_attack_overlay(livingprey, "slash")
					if(!livingprey.client) // instakilling players bad
						livingprey.splat(src)
					else
						livingprey.attack_animal(src)
						livingprey.apply_damage(attack_damage,BRUTE)
						livingprey.apply_effect(1,SLOW)
						livingprey.KnockDown(1,1)
					playsound(src.loc, "alien_claw_flesh", 25, 1)
					break

	..()

	for(var/mob/snack in oview(src, 3))
		if(is_type_in_list(snack, hunting_targets) && prob(15) && snack.stat != DEAD)
			visible_message(pick("[src]朝[snack]发出嘶声！", "[src]凶狠地叫着！", "[src]饥肠辘辘地盯着[snack]。"))
		break

	if(!stat && !resting && !buckled)
		handle_movement_target()

/mob/living/simple_animal/cat/death()
	. = ..()
	if(!.) return //was already dead
	if(last_damage_data)
		var/mob/user = last_damage_data.resolve_mob()
		if(user)
			user.count_niche_stat(STATISTICS_NICHE_CAT)

/mob/living/simple_animal/cat/proc/handle_movement_target()
	turns_since_scan++
	if(turns_since_scan > 5)
		walk_to(src,0)
		turns_since_scan = 0

		if((movement_target) && !(isturf(movement_target.loc) || ishuman(movement_target.loc) ))
			movement_target = null
			stop_automated_movement = 0
		if( !movement_target || !(movement_target.loc in oview(src, 4)) )
			movement_target = null
			stop_automated_movement = 0
			for(var/mob/living/snack in oview(src))
				if(isturf(snack.loc) && snack.stat != DEAD && is_type_in_list(snack, hunting_targets))
					setDir(get_dir(src, snack))
					balloon_alert_to_viewers("[src]扑向[snack]")
					movement_target = snack
					play_counter = 0
					break
		if(movement_target)
			stop_automated_movement = 1
			walk_to(src,movement_target,0,3)

/mob/living/simple_animal/cat/MouseDrop(atom/over_object)
	if(!CAN_PICKUP(usr, src))
		return ..()
	var/mob/living/carbon/H = over_object
	if(!istype(H) || !Adjacent(H) || H != usr) return ..()

	if(H.a_intent == INTENT_HELP)
		get_scooped(H)
		return
	else
		return ..()

/mob/living/simple_animal/cat/get_scooped(mob/living/carbon/grabber)
	if (stat >= DEAD)
		return
	..()

//RUNTIME IS ALIVE! SQUEEEEEEEE~
/mob/living/simple_animal/cat/Runtime
	name = "运行时"
	desc = "她的毛皮看起来摸起来都像天鹅绒，尾巴偶尔会颤动。"
	icon_state = "cat"
	icon_living = "cat"
	icon_dead = "cat_dead"
	holder_type = /obj/item/holder/cat/blackcat/Runtime

/mob/living/simple_animal/cat/blackcat
	name = "黑猫"
	desc = "一只猫，现在换成黑色了！"
	icon_state = "cat"
	icon_living = "cat"
	icon_dead = "cat_dead"
	holder_type = /obj/item/holder/cat/blackcat

/mob/living/simple_animal/cat/Jones
	name = "琼斯"
	real_name = "琼斯"
	desc = "一只顽强的老流浪猫，似乎没人知道它的来历。"
	icon_state = "cat2"
	icon_living = "cat2"
	icon_dead = "cat2_dead"
	health = 50
	maxHealth = 50
	holder_type = /obj/item/holder/cat/Jones

/mob/living/simple_animal/cat/kitten
	name = "小猫"
	desc = "哎呀，真可爱！"
	icon_state = "kitten"
	icon_living = "kitten"
	icon_dead = "kitten_dead"
	holder_type = /obj/item/holder/cat/kitten
	gender = NEUTER
