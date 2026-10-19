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
		to_chat(user, SPAN_DANGER("[src.name]是空的！"))
		return FALSE

	if(HAS_TRAIT(M, TRAIT_CANNOT_EAT))
		to_chat(user, SPAN_DANGER("[user == M ? "你" : "[M]"]无法饮用！"))
		return FALSE

	if(M == user)
		to_chat(M, SPAN_NOTICE("你从[src]中喝了一大口。"))
		if(reagents.total_volume)
			reagents.set_source_mob(user)
			reagents.trans_to_ingest(M, gulp_size)

		playsound(M.loc,'sound/items/drink.ogg', 15, 1)
		return TRUE
	else if(istype(M, /mob/living/carbon/human))

		user.affected_message(M,
			SPAN_HELPFUL("你<b>开始给</b>[user == M ? "自己" : "[M]"]喂<b>[src]</b>。"),
			SPAN_HELPFUL("[user]<b>开始给你喂</b><b>[src]</b>。"),
			SPAN_NOTICE("[user]开始给[user == M ? "自己" : "[M]"]喂[src]。"))

		if(!do_after(user, 30, INTERRUPT_ALL, BUSY_ICON_FRIENDLY, M))
			return FALSE
		user.affected_message(M,
			SPAN_HELPFUL("你<b>给</b>[user == M ? "自己" : "[M]"]<b>喂下了[src]</b>。"),
			SPAN_HELPFUL("[user]<b>给你喂下了[src]</b>。"),
			SPAN_NOTICE("[user]给[user == M ? "自己" : "[M]"]喂下了[src]。"))

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
			to_chat(user, SPAN_DANGER("[target]是空的。"))
			return

		if(reagents.total_volume >= reagents.maximum_volume)
			to_chat(user, SPAN_DANGER("[src]已经装满。"))
			return

		var/trans = target.reagents.trans_to(src, target:amount_per_transfer_from_this)

		if(!trans)
			to_chat(user, SPAN_DANGER("你没能将[target]中的试剂装入[src]。"))
			return

		to_chat(user, SPAN_NOTICE("你将[target]中[trans]单位的内容物装入[src]。"))

	else if(target.is_open_container()) //Something like a glass. Player probably wants to transfer TO it.
		if(!reagents.total_volume)
			to_chat(user, SPAN_DANGER("[src]是空的。"))
			return

		if(target.reagents.total_volume >= target.reagents.maximum_volume)
			to_chat(user, SPAN_DANGER("[target]已经装满。"))
			return

		var/trans = src.reagents.trans_to(target, amount_per_transfer_from_this)
		to_chat(user, SPAN_NOTICE("你向[target]中转移了[trans]单位溶液。"))

	return ..()

/obj/item/reagent_container/food/drinks/get_examine_text(mob/user)
	. = ..()
	if (get_dist(user, src) > 1 && user != loc)
		return
	if(!reagents || reagents.total_volume==0)
		. += SPAN_NOTICE("[src]是空的！")
	else if (reagents.total_volume<=src.volume/4)
		. += SPAN_NOTICE("[src]快空了！")
	else if (reagents.total_volume<=src.volume*0.66)
		. += SPAN_NOTICE("[src]大约半满！")
	else if (reagents.total_volume<=src.volume*0.90)
		. += SPAN_NOTICE("[src]快满了！")
	else
		. += SPAN_NOTICE("[src]已经装满！")


////////////////////////////////////////////////////////////////////////////////
/// Drinks. END
////////////////////////////////////////////////////////////////////////////////

/obj/item/reagent_container/food/drinks/golden_cup
	desc = "一个金杯"
	name = "金杯"
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
	desc = "一个金杯，将颁发给 6 月 26 日比赛的冠军，获胜者的名字会刻在上面。"


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
	name = "巧克力牛奶盒"
	desc = "一盒巧克力牛奶。"
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
	name = "杯装拉面"
	desc = "加 10 毫升水即可自动加热！让人想起学生时代的味道。"
	icon_state = "ramen"
	center_of_mass = "x=16;y=11"

/obj/item/reagent_container/food/drinks/dry_ramen/Initialize()
	. = ..()
	reagents.add_reagent("dry_ramen", 30)


/obj/item/reagent_container/food/drinks/sillycup
	name = "纸杯"
	desc = "一个纸制水杯。"
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
	attack_verb = list("重击", "敲击", "拍击")

/obj/item/reagent_container/food/drinks/cup/attack_self(mob/user)
	. = ..()
	if(user.a_intent == INTENT_HARM)
		user.visible_message(SPAN_WARNING("[user]捏扁了[src]！"), SPAN_WARNING("你捏扁了[src]！"))
		if(reagents.total_volume > 0)
			reagents.clear_reagents()
			playsound(src.loc, 'sound/effects/slosh.ogg', 25, 1, 3)
			to_chat(user, SPAN_WARNING("[src]中的东西洒了出来！"))
		qdel(src)
		var/obj/item/trash/crushed_cup/C = new /obj/item/trash/crushed_cup(user)
		user.equip_to_slot_if_possible(C, (user.hand ? WEAR_L_HAND : WEAR_R_HAND))

/obj/item/trash/crushed_cup
	name = "捏扁的杯子"
	desc = "一个被捏扁毁坏的可怜杯子。现在只剩下无用的垃圾。真浪费。"
	icon = 'icons/obj/items/cup.dmi'
	icon_state = "crushed_solocup"
	throwforce = 0
	w_class = SIZE_TINY
	matter = list("plastic" = 5)
	attack_verb = list("重击", "敲击", "拍击")

//////////////////////////drinkingglass and shaker//
//Note by Darem: This code handles the mixing of drinks. New drinks go in three places: In Chemistry-Reagents.dm (for the drink
// itself), in Chemistry-Recipes.dm (for the reaction that changes the components into the drink), and here (for the drinking glass
// icon states.

/obj/item/reagent_container/food/drinks/shaker
	name = "调酒壶"
	desc = "用于混合饮料的金属调酒壶。"
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
	name = "棕色皮革酒壶"
	desc = "侧面裹有皮带的酒壶，常被粗犷坚毅的侦探装满威士忌随身携带。"
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
	name = "美国殖民地陆战队咖啡杯"
	desc = "印有美国殖民地陆战队徽记的红白蓝三色咖啡杯。爱国又醒目，常被老兵当作纪念品。"
	icon_state = "uscmcup"

/obj/item/reagent_container/food/drinks/coffeecup/wy
	name = "维兰德-汤谷咖啡杯"
	desc = "正面印有维兰德-汤谷标志的哑光灰咖啡杯。可能是公司制式配发品，也可能是热爱公司的人的纪念品。大概是前者。"
	icon_state = "wycup"

/obj/item/reagent_container/food/drinks/plasticcup
	name = "塑料杯"
	icon_state = "plasticcup"
	desc = "大小适中的塑料杯，经得起粗鲁工人的随手摆弄，非常适合在星舰上使用。"
