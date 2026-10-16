/obj/item/facepaint
	gender = PLURAL
	name = "面部涂彩"
	desc = "用于面部的涂彩，需要时可以用纸擦掉。这款是深沉的森林绿。"
	icon = 'icons/obj/items/items.dmi'
	icon_state = "camo"
	var/paint_type = "green"
	w_class = SIZE_TINY
	var/uses = 10
	/// for lipstick
	var/open = TRUE

//FACEPAINT
/obj/item/facepaint/green
	name = "绿色面部涂彩"
	desc = "用于面部的涂彩。这款绿色涂彩很适合在脸上画出吓人的条纹，需要时可以用纸擦掉。"
	paint_type = "green_camo"
	icon_state = "green_camo"

/obj/item/facepaint/brown
	name = "棕色面部涂彩"
	desc = "用于面部的涂彩。这款棕色涂彩很适合在脸上画出吓人的条纹，需要时可以用纸擦掉。"
	paint_type = "brown_camo"
	icon_state = "brown_camo"

/obj/item/facepaint/black
	name = "黑色面部涂彩"
	desc = "用于面部的涂彩。这款黑色涂彩很适合在眼下画出防眩光黑纹，需要时可以用纸擦掉。"
	paint_type = "black_camo"
	icon_state = "black_camo"

/obj/item/facepaint/sniper
	name = "全身迷彩涂料"
	desc = "用于面部的涂彩。据说能帮助你融入草木之中，但研究至今也没得出确切结论。需要时可以用纸擦掉。"
	paint_type = "full_camo"
	icon_state = "full_camo"

/obj/item/facepaint/skull
	name = "骷髅涂彩"
	desc = "用于面部的涂彩。把骷髅画在脸上，吓得敌人当场需要换条内裤。警告：不适合搭配胡须使用。"
	paint_type = "skull_camo"
	icon_state = "skull_camo"

/obj/item/facepaint/sunscreen_stick
	name= "\improper USCM 配发防晒霜"
	desc = "陆战队好心的高层给你配发的 SPF 50 防晒棒。上一批防晒霜误食有毒，这一批有所改进：只是镉含量严重超标而已。"
	paint_type = "sunscreen_stick"
	icon_state = "sunscreen_stick"

/obj/item/facepaint/attack(mob/M, mob/user)
	if(user.a_intent == INTENT_HARM)
		return ..()

	if(!ismob(M))
		return FALSE

	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		var/mob/living/carbon/human/Huser = user
		Huser.animation_attack_on(H)
		if(!open)
			to_chat(user, SPAN_WARNING("盖子还没打开！"))
			return FALSE

		if(H.lip_style) //if they already have lipstick on
			to_chat(user, SPAN_WARNING("你得先用纸擦掉原来的妆容！"))
			return

		if(H == user)
			paint_face(H, user)
			return TRUE

		else
			to_chat(user, SPAN_NOTICE("你试着给[H]涂上[src]……"))
			to_chat(H, SPAN_NOTICE("[user]正试着往你脸上涂[src]……"))
			if(alert(H,"你同意让[user]给你的脸化妆吗？",,"同意","拒绝") == "同意")
				if( user && loc == user && (user in range(1,H)) ) //Have to be close and hold the thing.
					paint_face(H, user)
					return TRUE

	to_chat(user, SPAN_WARNING("没能成功！"))


/obj/item/facepaint/proc/paint_face(mob/living/carbon/human/H, mob/user)
	if(!H || !user)
		return //In case they're passed as null.
	user.visible_message(SPAN_NOTICE("[user]小心地将[src]涂到[H]的脸上。"), \
						SPAN_NOTICE("你涂上了[src]。"))
	H.lip_style = paint_type
	H.update_body()
	uses--
	if(!uses)
		user.temp_drop_inv_item(src)
		user.update_inv_l_hand(0)
		user.update_inv_r_hand()
		qdel(src)

//you can wipe off lipstick with paper! see code/modules/paperwork/paper.dm, paper/attack()

//LIPSTICK
/obj/item/facepaint/lipstick
	name = "红色口红"
	desc = "口红，涂在嘴唇上的一根小棒。"
	paint_type = "red_lipstick"
	icon_state = "lipstick"
	item_state = "lipstick"
	var/icon_state_open = "lipstick_red"
	var/icon_state_closed = "lipstick"
	open = FALSE

/obj/item/facepaint/lipstick/attack_self(mob/user)
	. = ..()
	if(open)
		open = FALSE
		to_chat(user, SPAN_NOTICE("你盖上了口红盖。"))
		icon_state = icon_state_closed
	else
		open = TRUE
		to_chat(user, SPAN_NOTICE("你取下了盖子。"))
		icon_state = icon_state_open
		playsound(src, "pillbottle", 25, TRUE)

/obj/item/facepaint/lipstick/purple
	name = "紫色口红"
	paint_type = "purp_lipstick"
	icon_state_open = "lipstick_purple"

/obj/item/facepaint/lipstick/maroon
	name = "栗色口红"
	paint_type = "marn_lipstick"
	icon_state_open = "lipstick_maroon"

/obj/item/facepaint/lipstick/jade
	name = "翡翠色口红"
	desc = "口红，涂在嘴唇上的一根小棒。不知为什么，这款看起来很锋利。涂在嘴上的东西为什么会这么锋利？？"
	paint_type = "jade_lipstick"
	icon_state_open = "lipstick_jade"

/obj/item/facepaint/lipstick/jade/attack_self(mob/user) //this is a reference :)
	. = ..()
	if(open)
		sharp = IS_SHARP_ITEM_ACCURATE
		edge = TRUE
		force = MELEE_FORCE_TIER_4
	else
		sharp = FALSE
		edge = FALSE
		force = 0
