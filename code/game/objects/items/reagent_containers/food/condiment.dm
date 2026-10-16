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
		to_chat(user, SPAN_DANGER("The [src.name] is empty!"))
		return FALSE

	if(M == user)
		to_chat(M, SPAN_NOTICE("You swallow some of contents of [src]."))

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

	//Something like a glass or a food item. Player probably wants to transfer TO it.
	else if(target.is_open_container() || istype(target, /obj/item/reagent_container/food/snacks))
		if(!reagents.total_volume)
			to_chat(user, SPAN_DANGER("[src] is empty."))
			return
		if(target.reagents.total_volume >= target.reagents.maximum_volume)
			to_chat(user, SPAN_DANGER("You can't add any more to [target]."))
			return
		var/trans = src.reagents.trans_to(target, amount_per_transfer_from_this)
		to_chat(user, SPAN_NOTICE(" You transfer [trans] units of the condiment to [target]."))

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
					desc = "看起来像是[reagents.get_master_reagent_name()]，但你无法确定。"
				else
					desc = "多种调味料的混合物，其中包括[reagents.get_master_reagent_name()]。"
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
	name = "Salt Shaker" // a large one.
	desc = "Salt. From space oceans, presumably."
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
	name = "\improper Cholula bottle"
	desc = "A bottle of Weyland-Yutani brand Cholula hot sauce."
	icon_state = "hotsauce_cholula"
	item_state = "hotsauce_cholula"

/obj/item/reagent_container/food/condiment/hotsauce/franks
	name = "\improper Frank's Red Hot bottle"
	desc = "A bottle of Weyland-Yutani brand Frank's Red Hot hot sauce."
	desc_lore = "Supposedly designed as a middle-ground flavor between ketchup and cayenne, this brand of spicy goodness achieved critical acclaim throughout UA space within both colonies and vessels alike. The sudden and widespread adoption was curiously timed with the near-simultaneous shelving of the original Frank's 'ULTRA' hot sauce."
	icon_state = "hotsauce_franks"
	item_state = "hotsauce_franks"

/obj/item/reagent_container/food/condiment/hotsauce/sriracha
	name = "\improper Sriracha bottle"
	desc = "A bottle of Weyland-Yutani brand Sriracha hot sauce."
	icon_state = "hotsauce_sriracha"
	item_state = "hotsauce_sriracha"

/obj/item/reagent_container/food/condiment/hotsauce/tabasco
	name = "\improper Tabasco bottle"
	desc = "A bottle of Weyland-Yutani brand Tabasco hot sauce."
	icon_state = "hotsauce_tabasco"
	item_state = "hotsauce_tabasco"

/obj/item/reagent_container/food/condiment/hotsauce/franks/macho
	name = "\improper Frank's ULTRA Hot bottle"
	desc = "A bottle of Weyland-Yutani brand Frank's ULTRA Hot sauce, taken off the market after reports of what was described as 'something closer to ignition than digestion' happening to those who drink it."
	icon_state = "hotsauce_franks"
	item_state = "hotsauce_franks"

/obj/item/reagent_container/food/condiment/hotsauce/franks/macho/Initialize()
	. = ..()
	reagents.add_reagent("machosauce", 60)

/obj/item/reagent_container/food/condiment/coldsauce
	name = "Cole's Cold bottle"
	desc = "A bottle of cold sauce locally produced in Shivas Snowball. You probably shouldn't drink this on its own."
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
	name = "Powdered Egg Packet"
	desc = "A small packet of dehydrated egg-whites and egg-yolk powder. Mix with water for a passable alternative to the real deal."
	icon_state = "eggpowder"
	volume = 12
	w_class = SIZE_SMALL

/obj/item/reagent_container/food/condiment/juice/egg/Initialize()
	. = ..()
	reagents.add_reagent("dehydrated_egg_powder", 12)

/obj/item/reagent_container/food/condiment/juice/milk
	name = "Dehydrated Milk Packet"
	desc = "A small packet of dehydrated milk powder. Mix with water for a passable alternative to actual milk."
	icon_state = "milkpowder"
	amount_per_transfer_from_this = 1
	volume = 12
	w_class = SIZE_SMALL

/obj/item/reagent_container/food/condiment/juice/milk/Initialize()
	. = ..()
	reagents.add_reagent("dehydrated_milk_powder", 12)
