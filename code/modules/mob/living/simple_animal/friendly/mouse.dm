/mob/living/simple_animal/mouse
	name = "老鼠"
	real_name = "老鼠"
	desc = "一只携带多种疾病的小型啮齿动物。"
	icon_state = "mouse_gray"
	icon_living = "mouse_gray"
	icon_dead = "mouse_gray_dead"
	speak = list("吱！","吱吱！","吱？")
	speak_emote = list("吱吱叫","吱吱叫","吱吱叫")
	emote_hear = list("吱吱叫","吱吱叫","吱吱叫")
	emote_see = list("原地转圈", "抖动身体", "抓挠着什么")
	mob_size = MOB_SIZE_SMALL
	speak_chance = 1
	turns_per_move = 5
	maxHealth = 5
	health = 5
	meat_type = /obj/item/reagent_container/food/snacks/meat
	response_help  = "抚摸"
	response_disarm = "轻轻推开"
	response_harm   = "踩踏"
	density = FALSE
	var/body_color //brown, gray and white, leave blank for random
	layer = ABOVE_LYING_MOB_LAYER
	min_oxy = 16 //Require at least 16kPA oxygen
	minbodytemp = 223 //Below -50 Degrees Celcius
	maxbodytemp = 323 //Above 50 Degrees Celcius
	holder_type = /obj/item/holder/mouse
	squeeze_under = TRUE

/mob/living/simple_animal/mouse/Life(delta_time)
	..()
	if(!stat && prob(speak_chance))
		FOR_DVIEW(var/mob/M, world.view, src, HIDE_INVISIBLE_OBSERVER)
			M << 'sound/effects/mousesqueek.ogg'
		FOR_DVIEW_END

	if(!ckey && stat == CONSCIOUS && prob(0.5))
		set_stat(UNCONSCIOUS)
		icon_state = "mouse_[body_color]_sleep"
		wander = 0
		speak_chance = 0
		//snuffles
	else if(stat == UNCONSCIOUS)
		if(ckey || prob(1))
			set_stat(CONSCIOUS)
			icon_state = "mouse_[body_color]"
			wander = 1
		else if(prob(5))
			INVOKE_ASYNC(src, PROC_REF(emote), "snuffles")

/mob/living/simple_animal/mouse/New()
	..()

	add_verb(src, list(
		/mob/living/proc/ventcrawl,
		/mob/living/proc/hide,
	))
	if(!name)
		name = "[name] ([rand(1, 1000)])"
	if(!body_color)
		body_color = pick( list("brown","gray","white") )
	icon_state = "mouse_[body_color]"
	icon_living = "mouse_[body_color]"
	icon_dead = "mouse_[body_color]_dead"
	if(!desc)
		desc = "一只[list("brown" = "棕色", "gray" = "灰色", "white" = "白色")[body_color] || body_color]的小型啮齿动物，经常躲在维修区里惹麻烦。"

/mob/living/simple_animal/mouse/initialize_pass_flags(datum/pass_flags_container/PF)
	..()
	if (PF)
		PF.flags_pass = PASS_FLAGS_CRAWLER

/mob/living/simple_animal/mouse/splat(mob/killer)
	src.health = 0
	src.set_stat(DEAD)
	src.icon_dead = "mouse_[body_color]_splat"
	src.icon_state = "mouse_[body_color]_splat"
	layer = ABOVE_LYING_MOB_LAYER
	set_body_position(LYING_DOWN)
	if(client)
		client.time_died_as_mouse = world.time

/mob/living/simple_animal/mouse/start_pulling(atom/movable/AM)//Prevents mouse from pulling things
	to_chat(src, SPAN_WARNING("你太小了，拉不动任何东西。"))
	return

/mob/living/simple_animal/mouse/Crossed(AM as mob|obj)
	if( ishuman(AM) )
		if(!ckey && stat == UNCONSCIOUS)
			set_stat(CONSCIOUS)
			icon_state = "mouse_[body_color]"
			wander = 1
		else if(!stat && prob(5))
			var/mob/M = AM
			to_chat(M, SPAN_NOTICE(" [icon2html(src, M)] 吱！"))
			M << 'sound/effects/mousesqueek.ogg'
	..()

/mob/living/simple_animal/mouse/death()
	layer = ABOVE_LYING_MOB_LAYER
	if(client)
		client.time_died_as_mouse = world.time
	..()

/mob/living/simple_animal/mouse/MouseDrop(atom/over_object)
	if(!CAN_PICKUP(usr, src))
		return ..()
	var/mob/living/carbon/H = over_object
	if(!istype(H) || !Adjacent(H) || H != usr) return ..()

	if(H.a_intent == INTENT_HELP)
		get_scooped(H)
		return
	else
		return ..()

/mob/living/simple_animal/mouse/get_scooped(mob/living/carbon/grabber)
	if (stat >= DEAD)
		return
	..()

/*
 * Mouse types
 */

/mob/living/simple_animal/mouse/white
	body_color = "white"
	icon_state = "mouse_white"
	desc = "一只小小的实验鼠。"
	holder_type = /obj/item/holder/mouse/white

/mob/living/simple_animal/mouse/gray
	body_color = "gray"
	icon_state = "mouse_gray"
	holder_type = /obj/item/holder/mouse/gray

/mob/living/simple_animal/mouse/brown
	body_color = "brown"
	icon_state = "mouse_brown"
	holder_type = /obj/item/holder/mouse/brown

/mob/living/simple_animal/mouse/white/Doc
	name = "博士"
	desc = "阿尔迈耶号的资深研究员，喜欢奶酪、实验和爆炸。"
	gender = MALE
	response_help  = "抚摸"
	response_disarm = "轻轻推开"
	response_harm   = "踩踏"
	holder_type = /obj/item/holder/mouse/white/Doc

//TOM IS ALIVE! SQUEEEEEEEE~K :)
/mob/living/simple_animal/mouse/brown/Tom
	name = "汤姆"
	desc = "猫咪杰瑞对此很不高兴。"
	response_help  = "抚摸"
	response_disarm = "轻轻推开"
	response_harm   = "拍扁"
	holder_type = /obj/item/holder/mouse/brown/Tom
