///////////////////////////////////////////////Condiments
//Notes by Darem: The condiments food-subtype is for stuff you don't actually eat but you use to modify existing food. They all
// leave empty containers when used up and can be filled/re-filled with other items. Formatting for first section is identical
// to mixed-drinks code. If you want an object that starts pre-loaded, you need to make it in addition to the other code.

//Food items that aren't eaten normally and leave an empty container behind.
/obj/item/reagent_container/food/condiment
	name = "调味料容器"
	desc = "普通的调味料容器。"
	icon = 'icons/obj/items/food.dmi'
	icon_state = "emptycondiment"
	flags_atom = FPRINT|OPENCONTAINER
	possible_transfer_amounts = list(1,5,10)
	center_of_mass = "x=16;y=6"
	volume = 50

/obj/item/reagent_container/food/condiment/attack(mob/M, mob/user)
	if(!reagents?.total_volume)
		to_chat(user, SPAN_DANGER("[src.name]是空的！"))
		return FALSE

	if(M == user)
		to_chat(M, SPAN_NOTICE("你吞下了一些[src]中的东西。"))

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
		user.attack_log += text("\[[time_stamp()]\] <font color='red'>Fed [src.name] by [M.name] ([M.ckey]) Reagents: [rgt_list_text]</font>")
		msg_admin_attack("[user.name] ([user.ckey]) fed [M.name] ([M.ckey]) with [src.name] (REAGENTS: [rgt_list_text]) (INTENT: [uppertext(intent_text(user.a_intent))]) in [get_area(src)] ([src.loc.x],[src.loc.y],[src.loc.z]).", src.loc.x, src.loc.y, src.loc.z)
	else
		return FALSE

	if(reagents.total_volume)
		reagents.set_source_mob(user)
		reagents.trans_to_ingest(M, 10)
	playsound(M.loc,'sound/items/drink.ogg', 15, 1)
	return TRUE

/obj/item/reagent_container/food/condiment/attackby(obj/item/W, mob/living/user, list/mods)
	return

/obj/item/reagent_container/food/condiment/afterattack(obj/target, mob/user , flag)
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

	//Something like a glass or a food item. Player probably wants to transfer TO it.
	else if(target.is_open_container() || istype(target, /obj/item/reagent_container/food/snacks))
		if(!reagents.total_volume)
			to_chat(user, SPAN_DANGER("[src]是空的。"))
			return
		if(target.reagents.total_volume >= target.reagents.maximum_volume)
			to_chat(user, SPAN_DANGER("[target]已经装不下更多东西。"))
			return
		var/trans = src.reagents.trans_to(target, amount_per_transfer_from_this)
		to_chat(user, SPAN_NOTICE("你向[target]中转移了[trans]单位调味料。"))

/obj/item/reagent_container/food/condiment/on_reagent_change()
	if(icon_state == "saltshakersmall" || icon_state == "peppermillsmall" || icon_state == "hotsauce_cholula" || icon_state == "hotsauce_franks" || icon_state == "hotsauce_sriracha" || icon_state == "hotsauce_tabasco" || icon_state == "coldsauce_cole" || icon_state == "eggpowder" || icon_state == "milkpowder" || icon_state == "bjpowder" || icon_state == "ojpowder" || icon_state == "ajpowder" || icon_state == "wjpowder" || icon_state == "gjpowder" || icon_state == "pjpowder")
		return
	if(length(reagents.reagent_list) > 0)
		switch(reagents.get_master_reagent_id())
			if("ketchup")
				name = "番茄沙司"
				desc = "你已经觉得自己更像美国人了。"
				icon_state = "ketchup"
				center_of_mass = "x=16;y=6"
			if("enzyme")
				name = "通用酶"
				desc = "用于烹调各种菜肴。"
				icon_state = "enzyme"
				center_of_mass = "x=16;y=6"
			if("soysauce")
				name = "酱油"
				desc = "咸味的大豆调味汁。"
				icon_state = "soysauce"
				center_of_mass = "x=16;y=6"
			if("frostoil")
				name = "冰辣酱"
				desc = "流过舌头时会留下麻木的感觉。"
				icon_state = "coldsauce"
				center_of_mass = "x=16;y=6"
			if("sodiumchloride")
				name = "盐瓶"
				desc = "盐。大概来自太空海洋吧。"
				icon_state = "saltshaker"
				center_of_mass = "x=16;y=10"
			if("blackpepper")
				name = "胡椒研磨瓶"
				desc = "常用来给食物调味，或让人打喷嚏。"
				icon_state = "peppermill"
				center_of_mass = "x=16;y=10"
			if("cornoil")
				name = "玉米油"
				desc = "烹饪用的美味食用油，由玉米制成。"
				icon_state = "oliveoil"
				center_of_mass = "x=16;y=6"
			if("sugar")
				name = "糖"
				desc = "美味的太空糖！"
				center_of_mass = "x=16;y=6"
			else
				name = "杂项调味料瓶"
				if (length(reagents.reagent_list)==1)
					desc = "看起来像是[reagents.get_master_reagent_display_name()]，但你无法确定。"
				else
					desc = "多种调味料的混合物，其中包括[reagents.get_master_reagent_display_name()]。"
				icon_state = "mixedcondiments"
				center_of_mass = "x=16;y=6"
	else
		icon_state = "emptycondiment"
		name = "调味料瓶"
		desc = "一个空调味料瓶。"
		center_of_mass = "x=16;y=6"
		return

/obj/item/reagent_container/food/condiment/enzyme
	name = "通用酶"
	desc = "用于烹制各种菜肴。"
	icon_state = "enzyme"

/obj/item/reagent_container/food/condiment/enzyme/Initialize()
	. = ..()
	reagents.add_reagent("enzyme", 50)

/obj/item/reagent_container/food/condiment/sugar

/obj/item/reagent_container/food/condiment/sugar/Initialize()
	. = ..()
	reagents.add_reagent("sugar", 50)

/obj/item/reagent_container/food/condiment/saltshaker //Separate from above since it's a small shaker rather then
	name = "盐瓶" // a large one.
	desc = "盐。大概来自太空海洋。"
	icon_state = "saltshakersmall"
	possible_transfer_amounts = list(1,20) //for clown turning the lid off
	amount_per_transfer_from_this = 1
	volume = 20

/obj/item/reagent_container/food/condiment/saltshaker/Initialize()
	. = ..()
	reagents.add_reagent("sodiumchloride", 20)

/obj/item/reagent_container/food/condiment/peppermill
	name = "胡椒研磨瓶"
	desc = "常用来给食物调味，或让人打喷嚏。"
	icon_state = "peppermillsmall"
	possible_transfer_amounts = list(1,20) //for clown turning the lid off
	amount_per_transfer_from_this = 1
	volume = 20

/obj/item/reagent_container/food/condiment/peppermill/Initialize()
	. = ..()
	reagents.add_reagent("blackpepper", 20)

/obj/item/reagent_container/food/condiment/hotsauce
	icon = 'icons/obj/items/food.dmi'
	name = "hotsauce parent object"
	possible_transfer_amounts = list(1,5,60) //60 allows marines to chug the bottle in one go.
	volume = 60

/obj/item/reagent_container/food/condiment/hotsauce/Initialize()
	. = ..()
	reagents.add_reagent("hotsauce", 60)

/obj/item/reagent_container/food/condiment/hotsauce/cholula
	name = "\improper 丘鲁拉辣椒酱瓶"
	desc = "一瓶维兰德-汤谷牌丘鲁拉辣椒酱。"
	icon_state = "hotsauce_cholula"
	item_state = "hotsauce_cholula"

/obj/item/reagent_container/food/condiment/hotsauce/franks
	name = "\improper 弗兰克红辣酱瓶"
	desc = "一瓶维兰德-汤谷牌弗兰克红辣酱。"
	desc_lore = "据说这种风味介于番茄酱与卡宴辣椒之间的辣酱，在美洲联盟疆域的殖民地和舰船上都大获好评。它突然普及的时间，恰巧与原版弗兰克“究极”辣酱下架的时间几乎一致。"
	icon_state = "hotsauce_franks"
	item_state = "hotsauce_franks"

/obj/item/reagent_container/food/condiment/hotsauce/sriracha
	name = "\improper 是拉差辣椒酱瓶"
	desc = "一瓶维兰德-汤谷牌是拉差辣椒酱。"
	icon_state = "hotsauce_sriracha"
	item_state = "hotsauce_sriracha"

/obj/item/reagent_container/food/condiment/hotsauce/tabasco
	name = "\improper 塔巴斯科辣椒酱瓶"
	desc = "一瓶维兰德-汤谷牌塔巴斯科辣椒酱。"
	icon_state = "hotsauce_tabasco"
	item_state = "hotsauce_tabasco"

/obj/item/reagent_container/food/condiment/hotsauce/franks/macho
	name = "\improper 弗兰克究极辣酱瓶"
	desc = "一瓶维兰德-汤谷牌弗兰克究极辣酱。有人喝下后出现了“更像着火而非消化”的反应，因此它已被下架。"
	icon_state = "hotsauce_franks"
	item_state = "hotsauce_franks"

/obj/item/reagent_container/food/condiment/hotsauce/franks/macho/Initialize()
	. = ..()
	reagents.add_reagent("machosauce", 60)

/obj/item/reagent_container/food/condiment/coldsauce
	name = "科尔冰凉酱瓶"
	desc = "一瓶湿婆雪球本地生产的冰凉酱。你大概不该直接喝它。"
	icon_state = "coldsauce_cole"

/obj/item/reagent_container/food/condiment/coldsauce/Initialize()
	. = ..()
	reagents.add_reagent("frostoil", 60)

/obj/item/reagent_container/food/condiment/juice
	name = "果汁冲调包"
	desc = "一小包脱水果汁粉，加水即可调成“美味”饮料。不过这一包似乎缺了标注口味的标签。"
	w_class = SIZE_TINY
	icon_state = "bjpowder"
	amount_per_transfer_from_this = 1
	volume = 6

/obj/item/reagent_container/food/condiment/juice/orange
	name = "橙汁包"
	desc = "一小包用糖醇增甜的橙味冲调饮料。加水冲调效果最佳，请勿直接干吃。"
	icon_state = "ojpowder"

/obj/item/reagent_container/food/condiment/juice/orange/Initialize()
	. = ..()
	reagents.add_reagent("dehydrated_orange_juice", 6)

/obj/item/reagent_container/food/condiment/juice/apple
	name = "苹果果汁冲调包"
	desc = "一小包用糖醇增甜的苹果味冲调饮料。加水冲调效果最佳，请勿直接干吃。"
	icon_state = "ajpowder"

/obj/item/reagent_container/food/condiment/juice/apple/Initialize()
	. = ..()
	reagents.add_reagent("dehydrated_apple_juice", 6)

/obj/item/reagent_container/food/condiment/juice/watermelon
	name = "西瓜果汁冲调包"
	desc = "一小包用糖醇增甜的西瓜味冲调饮料。加水冲调效果最佳，请勿直接干吃。"
	icon_state = "wjpowder"

/obj/item/reagent_container/food/condiment/juice/watermelon/Initialize()
	. = ..()
	reagents.add_reagent("dehydrated_watermelon_juice", 6)

/obj/item/reagent_container/food/condiment/juice/grape
	name = "葡萄果汁冲调包"
	desc = "一小包用糖醇增甜的葡萄味冲调饮料。加水冲调效果最佳，请勿直接干吃。"
	icon_state = "gjpowder"

/obj/item/reagent_container/food/condiment/juice/grape/Initialize()
	. = ..()
	reagents.add_reagent("dehydrated_grape_juice", 6)

/obj/item/reagent_container/food/condiment/juice/pineapple
	name = "菠萝果汁冲调包"
	desc = "一小包用糖醇增甜的菠萝味冲调饮料。加水冲调效果最佳，请勿直接干吃。"
	icon_state = "pjpowder"

/obj/item/reagent_container/food/condiment/juice/pineapple/Initialize()
	. = ..()
	reagents.add_reagent("dehydrated_pineapple_juice", 6)

/obj/item/reagent_container/food/condiment/juice/egg
	name = "蛋粉包"
	desc = "一小包脱水蛋白和蛋黄粉。加水混合后，勉强可以替代真鸡蛋。"
	icon_state = "eggpowder"
	volume = 12
	w_class = SIZE_SMALL

/obj/item/reagent_container/food/condiment/juice/egg/Initialize()
	. = ..()
	reagents.add_reagent("dehydrated_egg_powder", 12)

/obj/item/reagent_container/food/condiment/juice/milk
	name = "奶粉包"
	desc = "一小包脱水奶粉。加水混合后，勉强可以替代鲜奶。"
	icon_state = "milkpowder"
	amount_per_transfer_from_this = 1
	volume = 12
	w_class = SIZE_SMALL

/obj/item/reagent_container/food/condiment/juice/milk/Initialize()
	. = ..()
	reagents.add_reagent("dehydrated_milk_powder", 12)
