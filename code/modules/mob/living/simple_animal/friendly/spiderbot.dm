/mob/living/simple_animal/spiderbot

	min_oxy = 0
	max_tox = 0
	max_co2 = 0
	minbodytemp = 0
	maxbodytemp = 500

	var/mob/living/silicon/ai/connected_ai = null
	var/obj/item/cell/cell = null
	var/obj/structure/machinery/camera/camera = null
	var/obj/item/device/mmi/mmi = null
	var/list/req_access = list(ACCESS_MARINE_RESEARCH) //Access needed to pop out the brain.

	name = "蜘蛛机器人"
	desc = "四处疾走的机器人朋友！"
	icon = 'icons/mob/robots.dmi'
	icon_state = "spiderbot-chassis"
	icon_living = "spiderbot-chassis"
	icon_dead = "spiderbot-smashed"
	universal_speak = 1 //Temp until these are rewritten.

	wander = 0

	health = 10
	maxHealth = 10

	attacktext = "电击"
	attacktext = "电击"
	melee_damage_lower = 1
	melee_damage_upper = 3

	response_help  = "轻抚"
	response_disarm = "驱赶"
	response_harm   = "踩踏"

	var/obj/item/held_item = null //Storage for single item they can hold.
	speed = -1 //Spiderbots gotta go fast.
	mob_size = MOB_SIZE_SMALL
	speak_emote = list("哔鸣","咔嗒作响","啾鸣")

/mob/living/simple_animal/spiderbot/attackby(obj/item/O as obj, mob/user as mob)

	if(istype(O, /obj/item/device/mmi))
		var/obj/item/device/mmi/B = O
		if(src.mmi) //There's already a brain in it.
			to_chat(user, SPAN_DANGER("[src]里面已经有大脑了！"))
			return
		if(!B.brainmob)
			to_chat(user, SPAN_DANGER("将空的人机接口塞进框架，似乎毫无意义。"))
			return
		if(!B.brainmob.key)
			var/ghost_can_reenter = 0
			if(B.brainmob.mind)
				for(var/mob/dead/observer/G in GLOB.observer_list)
					if(G.can_reenter_corpse && G.mind == B.brainmob.mind)
						ghost_can_reenter = 1
						break
			if(!ghost_can_reenter)
				to_chat(user, SPAN_NOTICE("[O]完全没有反应，没有意义。"))
				return

		if(B.brainmob.stat == DEAD)
			to_chat(user, SPAN_DANGER("[O]已经死了，将它塞进框架似乎毫无意义。"))
			return

		if(jobban_isbanned(B.brainmob, "Cyborg"))
			to_chat(user, SPAN_DANGER("[O]似乎放不进去。"))
			return



		user.drop_inv_item_to_loc(O, src)
		to_chat(user, SPAN_NOTICE("你将[O]装进了[src]！"))
		mmi = O
		transfer_personality(O)
		update_icon()
		return 1

	if (iswelder(O))
		if(!HAS_TRAIT(O, TRAIT_TOOL_BLOWTORCH))
			to_chat(user, SPAN_WARNING("你需要功率更大的焊枪！"))
			return
		var/obj/item/tool/weldingtool/WT = O
		if (WT.remove_fuel(0))
			if(health < maxHealth)
				health += pick(1,1,1,2,2,3)
				if(health > maxHealth)
					health = maxHealth
				add_fingerprint(user)
				for(var/mob/W in viewers(user, null))
					W.show_message(text(SPAN_DANGER("[user]用点焊修复了[src]的部分损伤！")), SHOW_MESSAGE_VISIBLE)
			else
				to_chat(user, SPAN_NOTICE("[src]没有受损！"))
		else
			to_chat(user, "需要更多焊接燃料！")
			return
	else if(istype(O, /obj/item/card/id))
		if (!mmi)
			to_chat(user, SPAN_DANGER("无须刷身份卡——蜘蛛机器人里没有可取出的大脑。"))
			return 0

		var/obj/item/card/id/id_card

		if(istype(O, /obj/item/card/id))
			id_card = O

		if(ACCESS_MARINE_RESEARCH in id_card.access)
			to_chat(user, SPAN_NOTICE("你刷过身份卡，从[src]中弹出了大脑。"))
			eject_brain()

			if(held_item)
				held_item.forceMove(src.loc)
				held_item = null

			return 1
		else
			to_chat(user, SPAN_DANGER("你刷过身份卡，没有任何反应。"))
			return 0
	else
		if(O.force)
			var/damage = O.force
			if (O.damtype == HALLOSS)
				damage = 0
			apply_damage(damage, BRUTE)
			for(var/mob/M as anything in viewers(src, null))
				if ((M.client && !( M.blinded )))
					M.show_message(SPAN_DANGER("[user]用\the [O]攻击了[src]。"), SHOW_MESSAGE_VISIBLE)
		else
			to_chat(usr, SPAN_DANGER("这武器毫无效果，无法造成伤害。"))
			for(var/mob/M as anything in viewers(src, null))
				if ((M.client && !( M.blinded )))
					M.show_message(SPAN_DANGER("[user]用\the [O]轻轻敲了敲[src]。"), SHOW_MESSAGE_VISIBLE)

/mob/living/simple_animal/spiderbot/proc/transfer_personality(obj/item/device/mmi/M as obj)

		src.mind = M.brainmob.mind
		src.mind.key = M.brainmob.key
		src.ckey = M.brainmob.ckey
		if(client) client.change_view(GLOB.world_view_size)
		src.name = "蜘蛛机器人（[M.brainmob.name]）"

/mob/living/simple_animal/spiderbot/proc/explode(cause = "exploding") //When emagged.
	for(var/mob/M as anything in viewers(src, null))
		if ((M.client && !( M.blinded )))
			M.show_message(SPAN_DANGER("[src]发出古怪的颤音，嘶嘶作响，随后爆炸了。"), SHOW_MESSAGE_VISIBLE)
	explosion(get_turf(loc), -1, -1, 3, 5)
	eject_brain()
	death(cause)

/mob/living/simple_animal/spiderbot/proc/update_icon()
	if(mmi)
		if(istype(mmi,/obj/item/device/mmi))
			icon_state = "spiderbot-chassis-mmi"
			icon_living = "spiderbot-chassis-mmi"
	else
		icon_state = "spiderbot-chassis"
		icon_living = "spiderbot-chassis"

/mob/living/simple_animal/spiderbot/proc/eject_brain()
	if(mmi)
		var/turf/T = get_turf(loc)
		if(T)
			mmi.forceMove(T)
		if(mind) mind.transfer_to(mmi.brainmob)
		mmi = null
		src.name = "蜘蛛机器人"
		update_icon()

/mob/living/simple_animal/spiderbot/Destroy()
	eject_brain()
	. = ..()

/mob/living/simple_animal/spiderbot/New()

	camera = new /obj/structure/machinery/camera(src)
	camera.c_tag = "Spiderbot-[real_name]"
	camera.network = list("SS13")

	..()

/mob/living/simple_animal/spiderbot/death()

	GLOB.alive_mob_list -= src
	GLOB.dead_mob_list += src

	if(camera)
		camera.status = 0

	held_item.forceMove(src.loc)
	held_item = null

	robogibs(src.loc, viruses)
	qdel(src)

//Cannibalized from the parrot mob. ~Zuhayr
/mob/living/simple_animal/spiderbot/verb/drop_spider_held_item()
	set name = "放下手持物品"
	set category = "Spiderbot"
	set desc = "放下你拿着的物品。"

	if(stat)
		return

	if(!held_item)
		to_chat(usr, SPAN_DANGER("你没有可放下的物品！"))
		return 0

	if(istype(held_item, /obj/item/explosive/grenade))
		visible_message(SPAN_DANGER("[src]抛出了\the [held_item]！"), SPAN_DANGER("你抛出了\the [held_item]！"), "你听见一阵疾走声和砰的一声！")
		var/obj/item/explosive/grenade/G = held_item
		G.forceMove(loc)
		G.prime()
		held_item = null
		return 1

	visible_message(SPAN_NOTICE("[src]放下了\the [held_item]！"), SPAN_NOTICE("你放下了\the [held_item]！"), "你听见一阵疾走声和轻轻落地的声音。")

	held_item.forceMove(loc)
	held_item = null
	return 1


/mob/living/simple_animal/spiderbot/verb/get_item()
	set name = "拾取物品"
	set category = "Spiderbot"
	set desc = "拾取附近的小件物品。"

	if(stat)
		return -1

	if(held_item)
		to_chat(src, SPAN_DANGER("你已经拿着\the [held_item]了。"))
		return 1

	var/list/items = list()
	for(var/obj/item/I in view(1,src))
		if(I.loc != src && I.w_class <= SIZE_SMALL && I.Adjacent(src) )
			items.Add(I)

	var/obj/selection = tgui_input_list(usr, "选择一件物品。", "拾取", items)

	if(selection)
		for(var/obj/item/I in view(1, src))
			if(selection == I)
				held_item = selection
				selection.forceMove(src)
				visible_message(SPAN_NOTICE("[src]捞起了\the [held_item]！"), SPAN_NOTICE("你抓起了\the [held_item]！"), "你听见一阵疾走声和叮当声。")
				return held_item
		to_chat(src, SPAN_DANGER("\The [selection]离得太远了。"))
		return 0

	to_chat(src, SPAN_DANGER("没有值得拿取的东西。"))
	return 0

/mob/living/simple_animal/spiderbot/get_examine_text(mob/user)
	. = ..()
	if(held_item)
		. += "它正拿着\a [held_item] [icon2html(held_item, user)]。"
