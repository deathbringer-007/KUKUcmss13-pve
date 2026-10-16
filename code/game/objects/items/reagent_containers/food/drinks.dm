////////////////////////////////////////////////////////////////////////////////
/// Drinks.
////////////////////////////////////////////////////////////////////////////////
/obj/item/reagent_container/food/drinks
	name = "饮品"
	desc = "美味。"
	icon = 'icons/obj/items/drinks.dmi'
	icon_state = null
	flags_atom = FPRINT|OPENCONTAINER
	var/gulp_size = 5 //This is now officially broken ... need to think of a nice way to fix it.
	possible_transfer_amounts = list(5,10,25)
	volume = 50

/obj/item/reagent_container/food/drinks/on_reagent_change()
	if(gulp_size < 5)
		gulp_size = 5
	else gulp_size = max(floor(reagents.total_volume / 5), 5)

/obj/item/reagent_container/food/drinks/flask/on_reagent_change()
	if(gulp_size < 15)
		gulp_size = 15
	else gulp_size = max(floor(reagents.total_volume / 15), 15)

/obj/item/reagent_container/food/drinks/attack(mob/M, mob/user)
	var/datum/reagents/R = src.reagents

	if(!R.total_volume || !R)
		to_chat(user, SPAN_DANGER("The [src.name] is empty!"))
		return FALSE

	if(HAS_TRAIT(M, TRAIT_CANNOT_EAT))
		to_chat(user, SPAN_DANGER("[user == M ? "You are" : "[M] is"] unable to drink!"))
		return FALSE

	if(M == user)
		to_chat(M, SPAN_NOTICE(" You swallow a gulp from \the [src]."))
		if(reagents.total_volume)
			reagents.set_source_mob(user)
			reagents.trans_to_ingest(M, gulp_size)

		playsound(M.loc,'sound/items/drink.ogg', 15, 1)
		return TRUE
	else if(istype(M, /mob/living/carbon/human))

		user.affected_message(M,
			SPAN_HELPFUL("You <b>start feeding</b> [user == M ? "yourself" : "[M]"] <b>[src]</b>."),
			SPAN_HELPFUL("[user] <b>starts feeding</b> you <b>[src]</b>."),
			SPAN_NOTICE("[user] starts feeding [user == M ? "themselves" : "[M]"] [src]."))

		if(!do_after(user, 30, INTERRUPT_ALL, BUSY_ICON_FRIENDLY, M))
			return FALSE
		user.affected_message(M,
			SPAN_HELPFUL("You <b>fed</b> [user == M ? "yourself" : "[M]"] <b>[src]</b>."),
			SPAN_HELPFUL("[user] <b>fed</b> you <b>[src]</b>."),
			SPAN_NOTICE("[user] fed [user == M ? "themselves" : "[M]"] [src]."))

		var/rgt_list_text = get_reagent_list_text()

		M.attack_log += text("\[[time_stamp()]\] <font color='orange'>Has been fed [src.name] by [user.name] ([user.ckey]) Reagents: [rgt_list_text]</font>")
		user.attack_log += text("\[[time_stamp()]\] <font color='red'>Fed [M.name] by [M.name] ([M.ckey]) Reagents: [rgt_list_text]</font>")
		msg_admin_attack("[user.name] ([user.ckey]) fed [M.name] ([M.ckey]) with [src.name] (REAGENTS: [rgt_list_text]) (INTENT: [uppertext(intent_text(user.a_intent))]) in [get_area(src)] ([user.loc.x],[user.loc.y],[user.loc.z]).", user.loc.x, user.loc.y, user.loc.z)

		if(reagents.total_volume)
			reagents.set_source_mob(user)
			reagents.trans_to_ingest(M, gulp_size)

		playsound(M.loc,'sound/items/drink.ogg', 15, 1)
		return TRUE

	return FALSE


/obj/item/reagent_container/food/drinks/afterattack(obj/target, mob/user, proximity)
	if(!proximity) return

	if(istype(target, /obj/structure/reagent_dispensers)) //A dispenser. Transfer FROM it TO us.

		if(!target.reagents.total_volume)
			to_chat(user, SPAN_DANGER("[target] is empty."))
			return

		if(reagents.total_volume >= reagents.maximum_volume)
			to_chat(user, SPAN_DANGER("[src] is full."))
			return

		var/trans = target.reagents.trans_to(src, target:amount_per_transfer_from_this)

		if(!trans)
			to_chat(user, SPAN_DANGER("You fail to fill [src] with reagents from [target]."))
			return

		to_chat(user, SPAN_NOTICE(" You fill [src] with [trans] units of the contents of [target]."))

	else if(target.is_open_container()) //Something like a glass. Player probably wants to transfer TO it.
		if(!reagents.total_volume)
			to_chat(user, SPAN_DANGER("[src] is empty."))
			return

		if(target.reagents.total_volume >= target.reagents.maximum_volume)
			to_chat(user, SPAN_DANGER("[target] is full."))
			return

		var/trans = src.reagents.trans_to(target, amount_per_transfer_from_this)
		to_chat(user, SPAN_NOTICE(" You transfer [trans] units of the solution to [target]."))

	return ..()

/obj/item/reagent_container/food/drinks/get_examine_text(mob/user)
	. = ..()
	if (get_dist(user, src) > 1 && user != loc)
		return
	if(!reagents || reagents.total_volume==0)
		. += SPAN_NOTICE("\The [src] is empty!")
	else if (reagents.total_volume<=src.volume/4)
		. += SPAN_NOTICE("\The [src] is almost empty!")
	else if (reagents.total_volume<=src.volume*0.66)
		. += SPAN_NOTICE("\The [src] is half full!")
	else if (reagents.total_volume<=src.volume*0.90)
		. += SPAN_NOTICE("\The [src] is almost full!")
	else
		. += SPAN_NOTICE("\The [src] is full!")


////////////////////////////////////////////////////////////////////////////////
/// Drinks. END
////////////////////////////////////////////////////////////////////////////////

/obj/item/reagent_container/food/drinks/golden_cup
	desc = "A golden cup"
	name = "golden cup"
	icon_state = "golden_cup"
	item_state = "" //nope :(
	w_class = SIZE_LARGE
	force = 14
	throwforce = 10
	amount_per_transfer_from_this = 20
	possible_transfer_amounts = null
	volume = 150
	flags_atom = FPRINT|CONDUCT|OPENCONTAINER
	black_market_value = 20

/obj/item/reagent_container/food/drinks/golden_cup/tournament_26_06_2011
	desc = "A golden cup. It will be presented to a winner of tournament 26 June and name of the winner will be graved on it."


///////////////////////////////////////////////Drinks
//Notes by Darem: Drinks are simply containers that start preloaded. Unlike condiments, the contents can be ingested directly
// rather then having to add it to something else first. They should only contain liquids. They have a default container size of 50.
// Formatting is the same as food.

/obj/item/reagent_container/food/drinks/milk
	name = "盒装牛奶"
	desc = "一盒脂肪含量 2% 的牛奶。"
	icon_state = "milk"
	item_state = "carton"
	center_of_mass = "x=16;y=9"

/obj/item/reagent_container/food/drinks/milk/Initialize()
	. = ..()
	reagents.add_reagent("milk", 50)

/* Flour is no longer a reagent
/obj/item/reagent_container/food/drinks/flour
	name = "flour sack"
	desc = "A big bag of flour. Good for baking!"
	icon = 'icons/obj/items/food.dmi'
	icon_state = "flour"
	item_state = "flour"

/obj/item/reagent_container/food/drinks/flour/Initialize()
		..()
		reagents.add_reagent("flour", 30)
		src.pixel_x = rand(-10.0, 10)
		src.pixel_y = rand(-10.0, 10)
*/

/obj/item/reagent_container/food/drinks/soymilk
	name = "盒装豆奶"
	desc = "一盒豆奶。"
	icon_state = "soymilk"
	item_state = "carton"
	center_of_mass = "x=16;y=9"

/obj/item/reagent_container/food/drinks/soymilk/Initialize()
	. = ..()
	reagents.add_reagent("soymilk", 50)

/obj/item/reagent_container/food/drinks/chocolatemilk
	name = "chocolate milk carton"
	desc = "A carton of chocolate milk."
	icon_state = "chocmilk"
	item_state = "carton"
	center_of_mass = "x=16;y=9"

/obj/item/reagent_container/food/drinks/chocolatemilk/Initialize()
	. = ..()
	reagents.add_reagent("chocolatemilk", 50)

/obj/item/reagent_container/food/drinks/coffee
	name = "咖啡"
	desc = "小心，你即将享用的饮品非常烫。"
	icon_state = "coffee"
	center_of_mass = "x=15;y=10"

/obj/item/reagent_container/food/drinks/coffee/Initialize()
	. = ..()
	reagents.add_reagent("coffee", 20)

/obj/item/reagent_container/food/drinks/coffee/marine
	desc = "循环水、为最低成本最高产量而基因改造的实验室咖啡植株，以及再次回收的咖啡渣，混成了这廉价得侮辱人的 USCM 餐饮“奇迹”。你只庆幸部队配发的水是免费的。"

/obj/item/reagent_container/food/drinks/tea
	name = "紫公爵茶"
	desc = "侮辱紫公爵就是侮辱太空女王！若你诋毁这款茶，任何正派绅士都会与你决斗。"
	icon_state = "tea"
	item_state = "coffee"
	center_of_mass = "x=16;y=14"

/obj/item/reagent_container/food/drinks/tea/Initialize()
	. = ..()
	reagents.add_reagent("tea", 30)

/obj/item/reagent_container/food/drinks/tea/upp
	name = "保温容器"
	desc = "小巧、可重复使用的保温饮料容器，配有啜饮杯盖。"
	icon_state = "tea_upp"
	item_state = "coffee"
	center_of_mass = "x=16;y=14"

/obj/item/reagent_container/food/drinks/tea/upp/Initialize()
	. = ..()
	reagents.add_reagent("tea", 30)

/obj/item/reagent_container/food/drinks/water
	name = "保温容器"
	desc = "小巧、可重复使用的保温饮料容器，配有啜饮杯盖。"
	icon_state = "tea_upp"
	item_state = "coffee"
	center_of_mass = "x=16;y=14"

/obj/item/reagent_container/food/drinks/water/Initialize()
	. = ..()
	reagents.add_reagent("water", 30)

/obj/item/reagent_container/food/drinks/ice
	name = "冰杯"
	desc = "小心，冰很冷，请勿咀嚼。"
	icon_state = "coffee_nolid"
	item_state = "coffee"
	center_of_mass = "x=15;y=10"

/obj/item/reagent_container/food/drinks/ice/Initialize()
	. = ..()
	reagents.add_reagent("ice", 30)

/obj/item/reagent_container/food/drinks/h_chocolate
	name = "荷兰热可可"
	desc = "太空南美洲制造。"
	icon_state = "hot_coco"
	item_state = "coffee"
	center_of_mass = "x=15;y=13"

/obj/item/reagent_container/food/drinks/h_chocolate/Initialize()
	. = ..()
	reagents.add_reagent("hot_coco", 30)

/obj/item/reagent_container/food/drinks/dry_ramen
	name = "cup ramen"
	desc = "Just add 10ml water, self-heats! A taste that reminds you of your school years."
	icon_state = "ramen"
	center_of_mass = "x=16;y=11"

/obj/item/reagent_container/food/drinks/dry_ramen/Initialize()
	. = ..()
	reagents.add_reagent("dry_ramen", 30)


/obj/item/reagent_container/food/drinks/sillycup
	name = "paper cup"
	desc = "A paper water cup."
	icon_state = "water_cup_e"
	possible_transfer_amounts = null
	volume = 10
	center_of_mass = "x=16;y=12"

/obj/item/reagent_container/food/drinks/sillycup/Initialize()
	. = ..()

/obj/item/reagent_container/food/drinks/sillycup/on_reagent_change()
	if(reagents.total_volume)
		icon_state = "water_cup"
	else
		icon_state = "water_cup_e"

/obj/item/reagent_container/food/drinks/cup
	name = "塑料杯"
	desc = "普通的红色杯子。有人想玩啤酒乒乓吗？"
	icon = 'icons/obj/items/cup.dmi'
	icon_state = "solocup"
	throwforce = 0
	w_class = SIZE_TINY
	matter = list("plastic" = 5)
	attack_verb = list("bludgeoned", "whacked", "slapped")

/obj/item/reagent_container/food/drinks/cup/attack_self(mob/user)
	. = ..()
	if(user.a_intent == INTENT_HARM)
		user.visible_message(SPAN_WARNING("[user] crushes \the [src]!"), SPAN_WARNING("You crush \the [src]!"))
		if(reagents.total_volume > 0)
			reagents.clear_reagents()
			playsound(src.loc, 'sound/effects/slosh.ogg', 25, 1, 3)
			to_chat(user, SPAN_WARNING("The contents of \the [src] spill!"))
		qdel(src)
		var/obj/item/trash/crushed_cup/C = new /obj/item/trash/crushed_cup(user)
		user.equip_to_slot_if_possible(C, (user.hand ? WEAR_L_HAND : WEAR_R_HAND))

/obj/item/trash/crushed_cup
	name = "crushed cup"
	desc = "A sad crushed and destroyed cup. It's now useless trash. What a waste."
	icon = 'icons/obj/items/cup.dmi'
	icon_state = "crushed_solocup"
	throwforce = 0
	w_class = SIZE_TINY
	matter = list("plastic" = 5)
	attack_verb = list("bludgeoned", "whacked", "slapped")

//////////////////////////drinkingglass and shaker//
//Note by Darem: This code handles the mixing of drinks. New drinks go in three places: In Chemistry-Reagents.dm (for the drink
// itself), in Chemistry-Recipes.dm (for the reaction that changes the components into the drink), and here (for the drinking glass
// icon states.

/obj/item/reagent_container/food/drinks/shaker
	name = "shaker"
	desc = "A metal shaker to mix drinks in."
	icon_state = "shaker"
	amount_per_transfer_from_this = 10
	volume = 100
	center_of_mass = "x=17;y=10"

/obj/item/reagent_container/food/drinks/flask
	name = "金属随身水壶"
	desc = "容量不错的金属随身水壶。"
	icon_state = "flask"
	volume = 120
	center_of_mass = "x=17;y=8"

/obj/item/reagent_container/food/drinks/flask/marine
	name = "USCM 随身水壶"
	desc = "压有 USCM 标志的金属水壶，里面多半装着水、机油和医用酒精的混合物。"
	icon_state = "flask_uscm"
	volume = 120
	center_of_mass = "x=17;y=8"

/obj/item/reagent_container/food/drinks/flask/marine/Initialize()
	. = ..()
	reagents.add_reagent("water", 118)
	reagents.add_reagent("hooch", 2)

/obj/item/reagent_container/food/drinks/flask/weylandyutani
	name = "维兰德-汤谷随身水壶"
	desc = "压有维兰德-汤谷经典标志的金属水壶，多半是哪个公司马屁精下令塞进 USS 军舰餐厅售货机的。"
	icon_state = "flask_wy"
	volume = 120
	center_of_mass = "x=17;y=8"

/obj/item/reagent_container/food/drinks/flask/weylandyutani/Initialize()
	. = ..()
	reagents.add_reagent("fruit_beer", 60)

/obj/item/reagent_container/food/drinks/flask/canteen
	name = "军用水壶"
	desc = "坚固的金属合金水壶，可以装不少水……或其他液体。"
	icon_state = "canteen"
	volume = 120
	center_of_mass = "x=17;y=8"

/obj/item/reagent_container/food/drinks/flask/canteen/Initialize()
	. = ..()
	reagents.add_reagent("water", 120)

/obj/item/reagent_container/food/drinks/flask/canteen/empty

/obj/item/reagent_container/food/drinks/flask/canteen/empty/Initialize()
	. = ..()
	reagents.clear_reagents()

/obj/item/reagent_container/food/drinks/flask/detflask
	name = "brown leather flask"
	desc = "A flask with a leather band around the sides, often seen filled with whiskey and carried by rugged, gritty detectives."
	icon_state = "brownflask"
	volume = 120
	center_of_mass = "x=17;y=8"

/obj/item/reagent_container/food/drinks/flask/detflask/Initialize()
	. = ..()
	if(prob(15))
		reagents.add_reagent("whiskey", 30)

/obj/item/reagent_container/food/drinks/flask/barflask
	name = "黑色皮革随身水壶"
	desc = "侧面包着光滑黑色皮革带的随身水壶，适合懒得去酒吧喝酒的人。"
	icon_state = "blackflask"
	volume = 120
	center_of_mass = "x=17;y=7"

/obj/item/reagent_container/food/drinks/flask/vacuumflask
	name = "保温壶"
	desc = "自 1892 年起，让饮品始终保持理想温度。"
	icon_state = "vacuumflask"
	volume = 120
	center_of_mass = "x=15;y=4"

/obj/item/reagent_container/food/drinks/coffeecup
	name = "咖啡杯"
	desc = "陶瓷咖啡杯，几乎注定会摔倒，把滚烫的饮料泼在你的新衬衫上。嘶！"
	icon_state = "coffeecup"
	volume = 30
	center_of_mass = "x=15;y=13"

/obj/item/reagent_container/food/drinks/coffeecup/uscm
	name = "USCM coffee mug"
	desc = "A red, white and blue coffee mug depicting the emblem of the USCM. Patriotic and bold, and commonly seen among veterans as a novelty."
	icon_state = "uscmcup"

/obj/item/reagent_container/food/drinks/coffeecup/wy
	name = "维兰德-汤谷咖啡杯"
	desc = "正面印有维兰德-汤谷标志的哑光灰咖啡杯。可能是公司制式配发品，也可能是热爱公司的人的纪念品。大概是前者。"
	icon_state = "wycup"

/obj/item/reagent_container/food/drinks/plasticcup
	name = "plastic cup"
	icon_state = "plasticcup"
	desc = "A decent sized plastic cup, perfect aboard starships for it's capacity to deal with careless handling by roughnecks."
