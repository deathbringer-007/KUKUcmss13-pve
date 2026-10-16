//The fortune

/obj/item/paper/fortune
	name = "幸运签"
	icon_state = "fortune"

/obj/item/paper/fortune/premade

/obj/item/paper/fortune/premade/proc/assign_fortunes()
	var/list/fortunelist = file2list("strings/fortunes.txt")
	return(pick(fortunelist))

/obj/item/paper/fortune/premade/proc/get_lucky_numbers()
	var/num1 = rand(1,99)
	var/num2 = rand(1,99)
	var/num3 = rand(1,99)
	var/num4 = rand(1,99)
	var/num5 = rand(1,99)
	var/luckynumbers = "[num1]、[num2]、[num3]、[num4]和[num5]"
	return luckynumbers

/obj/item/paper/fortune/premade/Initialize(mapload, message = "Random", numbers = "Random")
	. = ..()
	switch(message)
		if("None")
			message = null
		if("Random")
			message = assign_fortunes()
	if(numbers == "None")
		numbers = null
	else
		numbers = "你的幸运数字是[numbers == "Random" ? get_lucky_numbers() : numbers]。"
	if(message || numbers)
		info = "<p style=\"text-align: center;\"><span style=\"text-align: center; color: #0000ff;\"><b>[message]</b><br/>[numbers]</p></span>"
	else
		error("Fortune cookie code broke! Fortune does not smile upon you today.")

//The cookie

/obj/item/reagent_container/food/snacks/fortunecookie
	name = "幸运饼干"
	desc = "一块金黄酥脆的幸运饼干。有人说里面的纸签甚至能预测未来，谁知道呢。"
	icon_state = "fortune_cookie"
	icon = 'icons/obj/items/food/mre_food/USCM.dmi'
	filling_color = "#E8E79E"
	//If the cookie has been broken open
	var/cookie_broken = FALSE
	//The fortune inside the cookie
	var/cookiefortune

/obj/item/reagent_container/food/snacks/fortunecookie/update_icon()
	. = ..()
	if(cookie_broken)
		icon_state = "fortune_cookie_open"
	else
		icon_state = "fortune_cookie"

/obj/item/reagent_container/food/snacks/fortunecookie/get_examine_text(mob/user)
	. = ..()
	if(cookie_broken)
		. += SPAN_WARNING("它已经裂开了！")
	else
		if(cookiefortune)
			. += SPAN_NOTICE("里面已经有幸运签了。")
		else
			. += SPAN_NOTICE("里面是空的。")

/obj/item/reagent_container/food/snacks/fortunecookie/Initialize()
	. = ..()
	reagents.add_reagent("bread", 3)
	bitesize = 2

/obj/item/reagent_container/food/snacks/fortunecookie/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/paper))
		if(cookie_broken)
			to_chat(user,SPAN_WARNING("[src]已经裂开了！你还怎么把东西塞进去？"))
		else
			if(!cookiefortune)
				to_chat(user, SPAN_NOTICE("你把纸条塞进[src]。"))
				cookiefortune = W
				user.drop_inv_item_to_loc(W, src)
			else
				to_chat(user,SPAN_WARNING("[src]里面已经有幸运签了！"))

//Break open the cookie first before eating it (with use)
/obj/item/reagent_container/food/snacks/fortunecookie/attack_self(mob/user)
	if(!cookie_broken)
		cookie_broken = TRUE
		playsound(user,'sound/effects/pillbottle.ogg',10,TRUE)
		name = "掰开的幸运饼干"
		update_icon()
		if(cookiefortune)
			to_chat(user,SPAN_NOTICE("你掰开幸运饼干，露出里面的幸运签！"))
			user.put_in_hands(cookiefortune)
			cookiefortune = null
		else
			to_chat(user, SPAN_WARNING("你掰开幸运饼干，里面却没有幸运签！真糟糕！"))
	else
		. = ..()

//Override for clicking on yourself too
/obj/item/reagent_container/food/snacks/fortunecookie/attack(mob/M, mob/user)
	if(!cookie_broken)
		cookie_broken = TRUE
		playsound(user,'sound/effects/pillbottle.ogg',10,TRUE)
		name = "掰开的幸运饼干"
		update_icon()
		if(cookiefortune)
			to_chat(user,SPAN_NOTICE("你掰开幸运饼干，露出里面的幸运签！"))
			user.put_in_hands(cookiefortune)
			cookiefortune = null
		else
			to_chat(user, SPAN_WARNING("你掰开幸运饼干，里面却没有幸运签！真糟糕！"))
	else
		. = ..()

/obj/item/reagent_container/food/snacks/fortunecookie/on_stored_atom_del(atom/movable/AM)
	if(AM == cookiefortune)
		cookiefortune = null

/obj/item/reagent_container/food/snacks/fortunecookie/prefilled/Initialize(mapload, fortune, numbers)
	. = ..()
	cookiefortune = new /obj/item/paper/fortune/premade(src, fortune, numbers)
