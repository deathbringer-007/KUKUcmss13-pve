/obj/item/stack/sheet/animalhide/human
	name = "人皮"
	desc = "养殖人类的副产品。"
	singular_name = "人皮片"
	icon_state = "sheet-hide"
	sheettype = "leather"
	stack_id = "human skin"

/obj/item/stack/sheet/animalhide/corgi
	name = "柯基皮"
	desc = "养殖柯基的副产品。"
	singular_name = "柯基皮片"
	icon_state = "sheet-corgi"
	sheettype = "leather"
	stack_id = "corgi hide"

/obj/item/stack/sheet/animalhide/cat
	name = "猫皮"
	desc = "养殖猫的副产品。"
	singular_name = "猫皮片"
	icon_state = "sheet-cat"
	sheettype = "leather"
	stack_id = "cat hide"

/obj/item/stack/sheet/animalhide/monkey
	name = "猴皮"
	desc = "养殖猴子的副产品。"
	singular_name = "猴皮片"
	icon_state = "sheet-monkey"
	sheettype = "leather"
	stack_id = "monkey hide"

/obj/item/stack/sheet/animalhide/lizard
	name = "蜥蜴皮"
	desc = "嘶嘶嘶……"
	singular_name = "蜥蜴皮片"
	icon_state = "sheet-lizard"
	sheettype = "leather"
	stack_id = "lizard skin"

/obj/item/stack/sheet/animalhide/xeno
	name = "异形皮"
	desc = "一种恐怖生物的皮肤。"
	singular_name = "异形皮片"
	icon_state = "sheet-xeno"
	sheettype = "leather"
	stack_id = "alien hide"

/obj/item/stack/sheet/animalhide/xeno/kinghide
	name = "异形王皮"
	desc = "异常品系的皮肤，已经破烂腐朽。"
	color = "#f7897c"

//don't see anywhere else to put these, maybe together they could be used to make the xenos suit?
/obj/item/stack/sheet/xenochitin
	name = "异形几丁质"
	desc = "来自一种恐怖生物的几丁质片。"
	singular_name = "异形皮片"
	icon_state = "chitin"
	sheettype = "chitin"
	stack_id = "alien chitin"

/obj/item/xenos_claw
	name = "异形利爪"
	desc = "一种恐怖生物的利爪。"
	icon_state = "claw"

/obj/item/weed_extract
	name = "菌毯提取物"
	desc = "一块黏滑的浅绿色菌毯。"
	icon_state = "weed_extract"

/obj/item/stack/sheet/hairlesshide
	name = "脱毛生皮"
	desc = "这张生皮已去除毛发，但尚需鞣制。"
	singular_name = "脱毛生皮片"
	icon_state = "sheet-hairlesshide"
	sheettype = "leather"
	stack_id = "hairless hide"

/obj/item/stack/sheet/wetleather
	name = "湿皮革"
	desc = "这块皮革已清洗干净，但尚需晾干。"
	singular_name = "湿皮革片"
	icon_state = "sheet-wetleather"
	sheettype = "leather"
	stack_id = "wet leather"
	var/wetness = 30 //Reduced when exposed to high temperautres
	var/drying_threshold_temperature = 500 //Kelvin to start drying

/obj/item/stack/sheet/leather
	name = "皮革"
	desc = "绞碎生物的副产品。"
	singular_name = "皮革片"
	icon_state = "sheet-leather"
	sheettype = "leather"
	stack_id = "leather"



//Step one - dehairing.

/obj/item/stack/sheet/animalhide/attackby(obj/item/W, mob/user)
	if(W.sharp)
		//visible message on mobs is defined as visible_message(message, self_message, blind_message)
		user.visible_message(SPAN_NOTICE("[usr]开始刮除[src]上的毛发。"), SPAN_NOTICE("你开始刮除[src]上的毛发。"), "你听到了刀刃刮擦皮肉的声音。")
		if(do_after(user,50, INTERRUPT_ALL, BUSY_ICON_HOSTILE))
			to_chat(user, SPAN_NOTICE("你刮掉了这块[src.singular_name]上的毛发。"))
			//Try locating an exisitng stack on the tile and add to there if possible
			for(var/obj/item/stack/sheet/hairlesshide/HS in user.loc)
				if(HS.amount < 50)
					HS.amount++
					src.use(1)
					break
			//If it gets to here it means it did not find a suitable stack on the tile.
			var/obj/item/stack/sheet/hairlesshide/HS = new(usr.loc)
			HS.amount = 1
			src.use(1)
	else
		return ..()


//Step two - washing..... it's actually in washing machine code.

//Step three - drying
/obj/item/stack/sheet/wetleather/fire_act(exposed_temperature, exposed_volume)
	..()
	if(exposed_temperature >= drying_threshold_temperature)
		wetness--
		if(wetness == 0)
			//Try locating an exisitng stack on the tile and add to there if possible
			for(var/obj/item/stack/sheet/leather/HS in src.loc)
				if(HS.amount < 50)
					HS.amount++
					src.use(1)
					wetness = initial(wetness)
					break
			//If it gets to here it means it did not find a suitable stack on the tile.
			var/obj/item/stack/sheet/leather/HS = new(src.loc)
			HS.amount = 1
			wetness = initial(wetness)
			src.use(1)
