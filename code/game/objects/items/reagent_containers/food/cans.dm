/obj/item/reagent_container/food/drinks/cans
	var/open = FALSE
	//If it needs can opener to be opened
	var/needs_can_opener = FALSE
	var/crushed = FALSE
	//Can be crushed
	var/crushable = TRUE
	//Can open sound
	var/open_sound = 'sound/effects/canopen.ogg'
	//Can open message
	var/open_message = "你打开饮料，发出清脆的噗声！"
	//Eating sound
	var/consume_sound = 'sound/items/drink.ogg'
	//What this object is, used during interactions
	var/object_fluff = "饮料"
	//If can transfer reagents to food
	var/food_interactable = FALSE
	//If can has a dedicated crushed icon
	var/crushed_icon = null
	//If can has a dedicated open icon
	var/has_open_icon = FALSE
	//Should item be deleted on being empty
	var/delete_on_empty = FALSE
	gulp_size = 10
	icon = 'icons/obj/items/drinkcans.dmi'
	item_icons = list(
		WEAR_L_HAND = 'icons/mob/humans/onmob/inhands/items/food_lefthand.dmi',
		WEAR_R_HAND = 'icons/mob/humans/onmob/inhands/items/food_righthand.dmi'
	)

/obj/item/reagent_container/food/drinks/cans/attackby(obj/item/opening_tool as obj, mob/user as mob)
	var/opening_time
	var/opening_sound
	var/hiss = pick("漂亮的嘶声！", "没有嘶声。", "轻微的嘶声。") //i couldn't not include stevemre reference
	if(user.action_busy || open || !needs_can_opener || !(opening_tool.type in CAN_OPENER_EFFECTIVE) && !(opening_tool.type in CAN_OPENER_CRUDE))
		return

	if(opening_tool.type in CAN_OPENER_EFFECTIVE)
		if(istype(opening_tool, /obj/item/tool/kitchen/can_opener/compact))
			var/obj/item/tool/kitchen/can_opener/compact/tool = opening_tool
			if(!tool.active)
				to_chat(user, SPAN_WARNING("你需要先将它展开才能使用。"))
				return
		opening_time = 4 SECONDS
		opening_sound = 'sound/items/can_open2.ogg'
		to_chat(user, SPAN_NOTICE("你开始用开罐器打开罐头。[hiss]"))
	if(opening_tool.type in CAN_OPENER_CRUDE)
		opening_time = 12 SECONDS
		opening_sound = 'sound/items/can_open1.ogg'
		to_chat(user, SPAN_NOTICE("你开始用刀刃粗暴地撬开罐头。[hiss]"))

	playsound(src.loc, opening_sound, 15, FALSE, 5)

	if(!do_after(user, opening_time, INTERRUPT_ALL, BUSY_ICON_GENERIC))
		return
	if(prob(25) && (opening_tool.type in CAN_OPENER_CRUDE))
		to_chat(user, SPAN_WARNING("你没能用[opening_tool]打开[object_fluff]！再试一次！"))
		playsound(src, "sound/items/can_crush.ogg", 20, FALSE, 5)
		return
	playsound(src.loc, open_sound, 15, 1, 5)
	to_chat(user, SPAN_NOTICE(open_message))
	open = TRUE
	if(has_open_icon)
		icon_state += "_open"
	update_icon()
	user.update_inv_l_hand()
	user.update_inv_r_hand()

/obj/item/reagent_container/food/drinks/cans/get_examine_text(mob/user)
	. = ..()
	if(needs_can_opener)
		. += SPAN_NOTICE("罐头完全密封，需要某种开罐器才能打开。")
	if(food_interactable)
		. += SPAN_NOTICE("你可以将这个[object_fluff]中的内容物转移到其他食物上。")

/obj/item/reagent_container/food/drinks/cans/attack_self(mob/user)
	..()

	if(crushed)
		return

	if(open)
		return

	if(needs_can_opener)
		to_chat(user, SPAN_NOTICE("你需要用某种开罐器打开[object_fluff]！"))
		return

	playsound(src.loc, open_sound, 15, 1)
	to_chat(user, SPAN_NOTICE(open_message))
	open = TRUE
	if(has_open_icon)
		icon_state += "_open"
	update_icon()

/obj/item/reagent_container/food/drinks/cans/attack_hand(mob/user)
	if(crushed)
		return ..()

	if (open && !reagents.total_volume)
		if(user.a_intent == INTENT_HARM)
			if(isturf(loc))
				if(user.zone_selected == "r_foot" || user.zone_selected == "l_foot" )
					crush_can(user)
					return FALSE
			else if(loc == user && src == user.get_inactive_hand())
				crush_can(user)
				return FALSE
	return ..()

/obj/item/reagent_container/food/drinks/cans/attack(mob/M, mob/user)
	if(crushed)
		return

	if(!open)
		to_chat(user, SPAN_NOTICE("你需要先打开饮料！"))
		return
	var/datum/reagents/R = src.reagents

	if(!R.total_volume || !R)
		if(M == user && M.a_intent == INTENT_HARM && M.zone_selected == "head" && crushable)
			crush_can(M)
			return
		to_chat(user, SPAN_DANGER("[src.name]是空的！"))
		return 0

	if(M == user)
		to_chat(M, SPAN_NOTICE("你喝了一大口[src]。"))
		if(reagents.total_volume)
			reagents.set_source_mob(user)
			reagents.trans_to_ingest(M, gulp_size)

		playsound(M.loc, consume_sound, 15, 1)
		return 1
	else if( istype(M, /mob/living/carbon/human) )
		if (!open)
			to_chat(user, SPAN_NOTICE("你需要先打开[object_fluff]！"))
			return

		user.affected_message(M,
			SPAN_HELPFUL("你<b>开始给</b>[user == M ? "自己" : "[M]"]喂<b>[src]</b>。"),
			SPAN_HELPFUL("[user]<b>开始给你喂</b><b>[src]</b>。"),
			SPAN_NOTICE("[user]开始给[user == M ? "自己" : "[M]"]喂[src]。"))
		if(!do_after(user, 30, INTERRUPT_ALL, BUSY_ICON_FRIENDLY, M)) return
		user.affected_message(M,
			SPAN_HELPFUL("你<b>给</b>[user == M ? "自己" : "[M]"]<b>喂下了[src]</b>。"),
			SPAN_HELPFUL("[user]<b>给你喂下了[src]</b>。"),
			SPAN_NOTICE("[user]给[user == M ? "自己" : "[M]"]喂下了[src]。"))

		var/rgt_list_text = get_reagent_list_text()

		M.attack_log += text("\[[time_stamp()]\] <font color='orange'>Has been fed [src.name] by [user.name] ([user.ckey]) Reagents: [rgt_list_text]</font>")
		user.attack_log += text("\[[time_stamp()]\] <font color='red'>Fed [M.name] by [M.name] ([M.ckey]) Reagents: [rgt_list_text]</font>")
		msg_admin_attack("[key_name(user)] fed [key_name(M)] with [src.name] (REAGENTS: [rgt_list_text]) (INTENT: [uppertext(intent_text(user.a_intent))]) in [get_area(src)] ([src.loc.x],[src.loc.y],[src.loc.z]).", src.loc.x, src.loc.y, src.loc.z)

		if(reagents.total_volume)
			reagents.set_source_mob(user)
			reagents.trans_to_ingest(M, gulp_size)

		playsound(M.loc,'sound/items/drink.ogg', 15, 1)
		return 1

	return 0


/obj/item/reagent_container/food/drinks/cans/afterattack(obj/target, mob/user, proximity)
	if(crushed || !proximity) return

	if(istype(target, /obj/structure/reagent_dispensers)) //A dispenser. Transfer FROM it TO us.
		if (!open)
			to_chat(user, SPAN_NOTICE("你需要先打开[object_fluff]！"))
			return


	else if(target.is_open_container()) //Something like a glass. Player probably wants to transfer TO it.
		if (!open)
			to_chat(user, SPAN_NOTICE("你需要先打开[object_fluff]！"))
			return

		if (istype(target, /obj/item/reagent_container/food/drinks/cans))
			var/obj/item/reagent_container/food/drinks/cans/cantarget = target
			if(!cantarget.open)
				to_chat(user, SPAN_NOTICE("你需要先打开准备用来接收内容物的[object_fluff]！"))
				return

	else if(istype(target, /obj/item/reagent_container/food/snacks) && food_interactable)
		if (!open)
			to_chat(user, SPAN_NOTICE("你需要先打开[object_fluff]！"))
			return

		if(!reagents.total_volume)
			to_chat(user, SPAN_DANGER("[src]是空的。"))
			return

		if(target.reagents.total_volume >= target.reagents.maximum_volume)
			to_chat(user, SPAN_DANGER("[target]已经装不下更多东西。"))
			return
		var/trans = src.reagents.trans_to(target, amount_per_transfer_from_this)
		to_chat(user, SPAN_NOTICE("你向[target]中转移了[trans]单位内容物。"))

	return ..()

/obj/item/reagent_container/food/drinks/cans/proc/crush_can(mob/user)
	if(!ishuman(user))
		return

	if(user.action_busy)
		return

	var/mob/living/carbon/human/H = user
	var/message
	var/obj/limb/L
	L = H.get_limb(H.zone_selected)

	if(src == H.get_inactive_hand())
		message = "用双手"
		to_chat(user, SPAN_NOTICE("你开始用双手捏扁[name]！"))
		if(!do_after(user, 2 SECONDS, INTERRUPT_ALL, BUSY_ICON_GENERIC)) //crushing with hands takes great effort and might
			return
	else
		switch(user.zone_selected)
			if("head")
				if(!L)
					to_chat(user, SPAN_WARNING("你没有[localized_player_label(H.zone_selected)]，无法在那个部位上捏扁罐子！"))
					return
				message = "用头部"
				L.take_damage(brute = 3) //ouch! but you're a tough badass so it barely hurts
				H.UpdateDamageIcon()
			if("l_foot" , "r_foot")
				if(!L)
					to_chat(user, SPAN_WARNING("你没有[localized_player_label(H.zone_selected)]，无法用那个部位压扁罐子！"))
					return
				message = "用脚"

	crushed = TRUE
	flags_atom &= ~OPENCONTAINER
	desc += "\n它被压扁了！一定有个狠人来过这里……"
	if(!crushed_icon)
		icon_state = "[icon_state]_crushed"
	else
		icon_state = crushed_icon
	user.visible_message(SPAN_BOLDNOTICE("[user][message]压扁了[name]。"), null, null, CHAT_TYPE_FLUFF_ACTION)
	playsound(src,"sound/items/can_crush.ogg", 20, FALSE, 15)

/obj/item/reagent_container/food/drinks/cans/on_reagent_change()
	. = ..()
	if(delete_on_empty && !reagents.total_volume)
		qdel(src)

//SODA

/obj/item/reagent_container/food/drinks/cans/classcola
	name = "可口可乐"
	desc = "可乐战争的胜者，也是美洲联盟和三世界帝国大部分地区最受欢迎的汽水。"
	icon_state = "cola"
	center_of_mass = "x=16;y=10"

/obj/item/reagent_container/food/drinks/cans/classcola/Initialize()
	. = ..()
	reagents.add_reagent("cola", 30)

/obj/item/reagent_container/food/drinks/cans/pepsi
	name = "\improper 百事可乐"
	desc = "虽然在可乐大战中落败，它仍是美洲联盟第二受欢迎的软饮料。"
	icon_state = "pepsi"

/obj/item/reagent_container/food/drinks/cans/pepsi/Initialize()
	. = ..()
	reagents.add_reagent("pepsi", 30)

/obj/item/reagent_container/food/drinks/cans/space_mountain_wind
	name = "激浪"
	desc = "献给讲究的游戏玩家。"
	icon_state = "space_mountain_wind"
	center_of_mass = "x=16;y=10"

/obj/item/reagent_container/food/drinks/cans/space_mountain_wind/Initialize()
	. = ..()
	reagents.add_reagent("spacemountainwind", 30)

/obj/item/reagent_container/food/drinks/cans/thirteenloko
	name = "\improper 十三疯能量饮料"
	desc = "饮用十三疯可能导致癫痫、失明、醉酒，甚至死亡。请适量饮用。"
	desc_lore = "十三疯是一款纯地球原创饮料，在如今的市场上十分罕见。人们普遍认为，只有脑子不太正常的人才愿意喝它，因此得名。这种能量饮料恶名远扬，却也收获了一批狂热拥趸。经过维兰德-汤谷提起的一系列诉讼，配方中的变性眼镜蛇毒液被移除，令消费者大失所望。"
	icon_state = "thirteen_loko"
	center_of_mass = "x=16;y=8"

/obj/item/reagent_container/food/drinks/cans/thirteenloko/Initialize()
	. = ..()
	reagents.add_reagent("thirteenloko", 30)

/obj/item/reagent_container/food/drinks/cans/dr_gibb
	name = "胡椒博士"
	desc = "混合了 23 种口味，证明数量并不代表质量。"
	icon_state = "dr_gibb"
	center_of_mass = "x=16;y=10"

/obj/item/reagent_container/food/drinks/cans/dr_gibb/Initialize()
	. = ..()
	reagents.add_reagent("dr_gibb", 30)

/obj/item/reagent_container/food/drinks/cans/starkist
	name = "\improper 新奇士"
	desc = "喝起来似乎是碳酸橙汁，却完全不含维生素 C。"
	icon_state = "starkist"
	center_of_mass = "x=16;y=10"

/obj/item/reagent_container/food/drinks/cans/starkist/Initialize()
	. = ..()
	reagents.add_reagent("cola", 15)
	reagents.add_reagent("orangejuice", 15)

/obj/item/reagent_container/food/drinks/cans/space_up
	name = "\improper 七喜"
	desc = "许多鸡尾酒的好搭档。"
	icon_state = "space-up"
	center_of_mass = "x=16;y=10"

/obj/item/reagent_container/food/drinks/cans/space_up/Initialize()
	. = ..()
	reagents.add_reagent("space_up", 30)

/obj/item/reagent_container/food/drinks/cans/lemon_lime
	name = "柠檬青柠汽水"
	desc = "你想要橙汁，它却给了你柠檬青柠味。"
	icon_state = "lemon-lime"
	center_of_mass = "x=16;y=10"

/obj/item/reagent_container/food/drinks/cans/lemon_lime/Initialize()
	. = ..()
	reagents.add_reagent("lemon_lime", 30)

/obj/item/reagent_container/food/drinks/cans/iced_tea
	name = "立顿冰茶"
	desc = "比不上外婆做的甜茶，但应急时也能凑合。"
	icon_state = "ice_tea_can"
	center_of_mass = "x=16;y=10"

/obj/item/reagent_container/food/drinks/cans/iced_tea/Initialize()
	. = ..()
	reagents.add_reagent("icetea", 30)

/obj/item/reagent_container/food/drinks/cans/grape_juice
	name = "葡萄汁"
	desc = "一罐大概不是葡萄汁的东西。"
	icon_state = "purple_can"
	center_of_mass = "x=16;y=10"

/obj/item/reagent_container/food/drinks/cans/grape_juice/Initialize()
	. = ..()
	reagents.add_reagent("grapejuice", 30)

/obj/item/reagent_container/food/drinks/cans/tonic
	name = "汤力水"
	desc = "第一步：汤力水，完成。第二步：金酒。"
	icon_state = "tonic"
	center_of_mass = "x=16;y=10"

/obj/item/reagent_container/food/drinks/cans/tonic/Initialize()
	. = ..()
	reagents.add_reagent("tonic", 30)

/obj/item/reagent_container/food/drinks/cans/sodawater
	name = "苏打水"
	desc = "一罐苏打水。据那些欧洲人说，这是自来水更清爽的亲戚。"
	icon_state = "sodawater"
	center_of_mass = "x=16;y=10"

/obj/item/reagent_container/food/drinks/cans/sodawater/Initialize()
	. = ..()
	reagents.add_reagent("sodawater", 30)

//BODA

/obj/item/reagent_container/food/drinks/cans/boda
	name = "波达汽水"
	desc = "国家监管的汽水饮料。同志们，尽情享用。"
	desc_lore = "波达的广告宣传活动始于 2159 年，最初是进步人民联盟为了赢得银河各地殖民者和拓荒者民心而开展的尝试。不久后，随处可见的青色售货机和大批饮料开始出现在美洲联盟各处仓库，来源似乎无人知晓。尽管有人心存疑虑，但初步检测证明库存产品可以安全饮用，而且在受试小组的盲测中出乎意料地受欢迎，因此这批来历不明的波达获准在美洲联盟所属殖民地使用。此后它一度颇受欢迎，但在随后的几十年中，随着供应减少而逐渐淡出人们视野。"
	icon_state = "boda"
	center_of_mass = "x=16;y=10"

/obj/item/reagent_container/food/drinks/cans/boda/Initialize()
	. = ..()
	reagents.add_reagent("sodawater", 30)

/obj/item/reagent_container/food/drinks/cans/bodaplus
	name = "波达加强型汽水"
	desc = "国家监管的汽水饮料，现已添加过剩调味剂。同志们，尽情享用。"
	icon_state = "blank_can"
	center_of_mass = "x=16;y=10"

/obj/item/reagent_container/food/drinks/cans/bodaplus/Initialize()
	. = ..()
	reagents.add_reagent("cola", 30)

//WEYLAND-YUTANI

/obj/item/reagent_container/food/drinks/cans/cola
	name = "果啤"
	desc = "理论上，芒果味根汁汽水听起来挺不错。维兰德-汤谷用最新可乐系列再次推翻了一个理论。由维兰德-汤谷公司罐装。"
	icon_state = "fruit_beer"
	center_of_mass = "x=16;y=10"

/obj/item/reagent_container/food/drinks/cans/cola/Initialize()
	. = ..()
	reagents.add_reagent("fruit_beer", 30)

/obj/item/reagent_container/food/drinks/cans/waterbottle
	name = "山泉"
	desc = "凭借海外大力营销和公司殖民地内部采购合同，成为美洲联盟与三世界帝国宙域最受欢迎的瓶装水品牌之一。"
	icon_state = "water"
	crushed_icon = "water_crushed"
	item_icons = list(
		WEAR_L_HAND = 'icons/mob/humans/onmob/inhands/items/bottles_lefthand.dmi',
		WEAR_R_HAND = 'icons/mob/humans/onmob/inhands/items/bottles_righthand.dmi',
	)
	has_open_icon = TRUE
	center_of_mass = "x=15;y=8"

/obj/item/reagent_container/food/drinks/cans/waterbottle/Initialize()
	. = ..()
	reagents.add_reagent("water", 30)

/obj/item/reagent_container/food/drinks/cans/waterbottle/upp
	name = "\improper 杰罗尔施泰纳瓶装气泡水"
	desc = "德国瓶装气泡水，深受进步人民联盟德语族群喜爱。"
	desc_lore = "杰罗尔施泰纳公司被整合为国有企业后，其产品成了军用口粮等处的常见物品。"
	icon_state = "upp_water"
	crushed_icon = "upp_water_crushed"

/obj/item/reagent_container/food/drinks/cans/coconutmilk
	name = "\improper 维兰德-汤谷瓶装椰奶"
	desc = "富含维生素和人工香料，几口就能解渴。由维兰德-汤谷公司灌装。"
	icon_state = "pmc_cocomilk"
	crushed_icon = "pmc_cocomilk_crushed"
	item_icons = list(
		WEAR_L_HAND = 'icons/mob/humans/onmob/inhands/items/bottles_lefthand.dmi',
		WEAR_R_HAND = 'icons/mob/humans/onmob/inhands/items/bottles_righthand.dmi',
	)
	has_open_icon = TRUE
	center_of_mass = "x=15;y=8"

/obj/item/reagent_container/food/drinks/cans/coconutmilk/Initialize()
	. = ..()
	reagents.add_reagent("coconutmilk", 30)

/obj/item/reagent_container/food/drinks/cans/soylent
	name = "\improper 维兰德-汤谷优质巧克力代餐"
	desc = "一塑料瓶黏稠的巧克力味美味。一瓶的热量足够当午餐，别一口气喝完，最好别冒腹泻的风险。"
	desc_lore = "这款代餐饮料最初于 2173 年为高强度劳动者设计，却因恶心、呕吐、腹泻等胃肠不适报告而多次被召回。虽然后来改良了配方，品牌的名声却已臭了——字面意义上也是如此。因此如今仅作为公司内部的应急食品储备。"
	icon_state = "wy_soylent"
	crushed_icon = "wy_soylent_crushed"
	item_icons = list(
		WEAR_L_HAND = 'icons/mob/humans/onmob/inhands/items/bottles_lefthand.dmi',
		WEAR_R_HAND = 'icons/mob/humans/onmob/inhands/items/bottles_righthand.dmi',
	)
	has_open_icon = TRUE
	center_of_mass = "x=15;y=8"
	volume = 30

/obj/item/reagent_container/food/drinks/cans/soylent/Initialize()
	. = ..()
	reagents.add_reagent("nutriment", 10)
	reagents.add_reagent("soymilk", 10)
	reagents.add_reagent("coco_drink", 10)

/obj/item/reagent_container/food/drinks/cans/bugjuice
	name = "\improper 维兰德-汤谷虫汁蛋白饮料"
	desc = "维兰德-汤谷牌塑料瓶，装满看起来有毒的绿色黏液，喝着像猕猴桃，但你很确定里面一点猕猴桃也没有。"
	desc_lore = "“虫汁”蛋白饮料，通常简称虫汁，是用养殖并加工的蟑螂、黄粉虫和甲虫等昆虫制成的廉价高热量饮料。多家厂商生产，采用纸盒或瓶装，在边疆广为饮用。它既是饮料也是食品，可补充蛋白质和水分。"
	icon_state = "wy_bug_juice"
	crushed_icon = "wy_bug_juice_crushed"
	item_icons = list(
		WEAR_L_HAND = 'icons/mob/humans/onmob/inhands/items/bottles_lefthand.dmi',
		WEAR_R_HAND = 'icons/mob/humans/onmob/inhands/items/bottles_righthand.dmi',
	)
	has_open_icon = TRUE
	center_of_mass = "x=15;y=8"
	volume = 30

/obj/item/reagent_container/food/drinks/cans/bugjuice/Initialize()
	. = ..()
	reagents.add_reagent("bugjuice", 30)

/obj/item/reagent_container/food/drinks/cans/beer
	name = "维兰德-汤谷淡啤"
	desc = "啤酒。目标已经锁定，是时候火力全开了。"
	icon_state = "beer"
	center_of_mass = "x=16;y=12"

/obj/item/reagent_container/food/drinks/cans/beer/Initialize()
	. = ..()
	reagents.add_reagent("beer", 30)

/obj/item/reagent_container/food/drinks/cans/ale
	name = "维兰德-汤谷 IPA"
	desc = "啤酒那位被误解的亲戚。"
	icon_state = "ale"
	item_state = "beer"
	center_of_mass = "x=16;y=10"

/obj/item/reagent_container/food/drinks/cans/ale/Initialize()
	. = ..()
	reagents.add_reagent("ale", 30)

//SOUTO

/obj/item/reagent_container/food/drinks/cans/souto
	name = "索托饮料罐"
	desc = "在哈瓦那罐装。"
	icon_state = "souto_classic"
	item_state = "souto_classic"
	center_of_mass = "x=16;y=10"
	embeddable = 1

/obj/item/reagent_container/food/drinks/cans/souto/diet
	name = "无糖索托"
	desc = "现含 0% 果汁！在哈瓦那罐装。"
	icon_state = "souto_diet_classic"
	item_state = "souto_diet_classic"

/obj/item/reagent_container/food/drinks/cans/souto/classic
	name = "索托经典"
	desc = "罐身大胆宣称这是柑橘味，你却忍不住怀疑它在撒谎。在哈瓦那罐装。"
	icon_state = "souto_classic"
	item_state = "souto_classic"

/obj/item/reagent_container/food/drinks/cans/souto/classic/Initialize()
	. = ..()
	reagents.add_reagent("cornsyrup", 15)
	reagents.add_reagent("sodawater", 15)
	reagents.add_reagent("souto_classic", 20)

/obj/item/reagent_container/food/drinks/cans/souto/diet/classic
	name = "无糖索托"
	desc = "现含 0% 果汁！在哈瓦那罐装。"
	icon_state = "souto_diet_classic"
	item_state = "souto_diet_classic"

/obj/item/reagent_container/food/drinks/cans/souto/diet/classic/Initialize()
	. = ..()
	reagents.add_reagent("sucralose", 15)
	reagents.add_reagent("sodawater", 15)
	reagents.add_reagent("souto_classic", 20)

/obj/item/reagent_container/food/drinks/cans/souto/cherry
	name = "樱桃索托"
	desc = "现在含有更多人工香料！在哈瓦那罐装。"
	icon_state = "souto_cherry"
	item_state = "souto_cherry"

/obj/item/reagent_container/food/drinks/cans/souto/cherry/Initialize()
	. = ..()
	reagents.add_reagent("cornsyrup", 15)
	reagents.add_reagent("sodawater", 15)
	reagents.add_reagent("souto_cherry", 20)

/obj/item/reagent_container/food/drinks/cans/souto/diet/cherry
	name = "无糖樱桃索托"
	desc = "既不无糖，也不是樱桃味。在哈瓦那罐装。"
	icon_state = "souto_diet_cherry"
	item_state = "souto_diet_cherry"

/obj/item/reagent_container/food/drinks/cans/souto/diet/cherry/Initialize()
	. = ..()
	reagents.add_reagent("sucralose", 15)
	reagents.add_reagent("sodawater", 15)
	reagents.add_reagent("souto_cherry", 20)

/obj/item/reagent_container/food/drinks/cans/souto/lime
	name = "青柠索托"
	desc = "不难喝，也不好喝，但至少不难喝。在哈瓦那罐装。"
	icon_state = "souto_lime"
	item_state = "souto_lime"

/obj/item/reagent_container/food/drinks/cans/souto/lime/Initialize()
	. = ..()
	reagents.add_reagent("cornsyrup", 15)
	reagents.add_reagent("sodawater", 15)
	reagents.add_reagent("souto_lime", 20)

/obj/item/reagent_container/food/drinks/cans/souto/diet/lime
	name = "无糖青柠索托"
	desc = "十种酸、两杯代糖、近一整罐二氧化碳和约 210 kPa 压力，全塞进一个铝罐。有谁能不爱呢？在哈瓦那罐装。"
	icon_state = "souto_diet_lime"
	item_state = "souto_diet_lime"

/obj/item/reagent_container/food/drinks/cans/souto/diet/lime/Initialize()
	. = ..()
	reagents.add_reagent("sucralose", 15)
	reagents.add_reagent("sodawater", 15)
	reagents.add_reagent("souto_lime", 20)

/obj/item/reagent_container/food/drinks/cans/souto/grape
	name = "葡萄索托"
	desc = "汽水的经典口味。不过这一罐喝起来像葡萄味止咳糖浆。在哈瓦那罐装。"
	icon_state = "souto_grape"
	item_state = "souto_grape"

/obj/item/reagent_container/food/drinks/cans/souto/grape/Initialize()
	. = ..()
	reagents.add_reagent("cornsyrup", 15)
	reagents.add_reagent("sodawater", 15)
	reagents.add_reagent("souto_grape", 20)

/obj/item/reagent_container/food/drinks/cans/souto/diet/grape
	name = "无糖葡萄索托"
	desc = "你相当肯定这只是葡萄味止咳糖浆兑碳酸水。在哈瓦那罐装。"
	icon_state = "souto_diet_grape"
	item_state = "souto_diet_grape"

/obj/item/reagent_container/food/drinks/cans/souto/diet/grape/Initialize()
	. = ..()
	reagents.add_reagent("sucralose", 15)
	reagents.add_reagent("sodawater", 15)
	reagents.add_reagent("souto_grape", 20)

/obj/item/reagent_container/food/drinks/cans/souto/blue
	name = "蓝树莓索托"
	desc = "喝起来就是蓝色的味道。科技真神奇。在哈瓦那罐装。"
	icon_state = "souto_blueraspberry"
	item_state = "souto_blueraspberry"
	black_market_value = 10 //mendoza likes blue souto

/obj/item/reagent_container/food/drinks/cans/souto/blue/Initialize()
	. = ..()
	reagents.add_reagent("cornsyrup", 15)
	reagents.add_reagent("sodawater", 15)
	reagents.add_reagent("souto_blueraspberry", 20)

/obj/item/reagent_container/food/drinks/cans/souto/diet/blue
	name = "无糖蓝树莓索托"
	desc = "骗子！这根本不是蓝色的味道，最多算青色。在哈瓦那罐装。"
	icon_state = "souto_diet_blueraspberry"
	item_state = "souto_diet_blueraspberry"

/obj/item/reagent_container/food/drinks/cans/souto/diet/blue/Initialize()
	. = ..()
	reagents.add_reagent("sucralose", 15)
	reagents.add_reagent("sodawater", 15)
	reagents.add_reagent("souto_blueraspberry", 20)

/obj/item/reagent_container/food/drinks/cans/souto/peach
	name = "蜜桃索托"
	desc = "一方面，味道确实不错；另一方面，你好像听见一颗桃核在里面咔哒作响。在哈瓦那罐装。"
	icon_state = "souto_peach"
	item_state = "souto_peach"

/obj/item/reagent_container/food/drinks/cans/souto/peach/Initialize()
	. = ..()
	reagents.add_reagent("cornsyrup", 15)
	reagents.add_reagent("sodawater", 15)
	reagents.add_reagent("souto_peach", 20)

/obj/item/reagent_container/food/drinks/cans/souto/diet/peach
	name = "无糖蜜桃索托"
	desc = "一方面，味道确实不错；另一方面，你好像听见半颗桃核在里面咔哒作响。在哈瓦那罐装。"
	icon_state = "souto_diet_peach"
	item_state = "souto_diet_peach"

/obj/item/reagent_container/food/drinks/cans/souto/diet/peach/Initialize()
	. = ..()
	reagents.add_reagent("sucralose", 15)
	reagents.add_reagent("sodawater", 15)
	reagents.add_reagent("souto_peach", 20)

/obj/item/reagent_container/food/drinks/cans/souto/cranberry
	name = "蔓越莓索托"
	desc = "仔细一看，罐身写的是“蔓塞莓索托”。蔓塞莓到底是什么鬼？在哈瓦那罐装。"
	icon_state = "souto_cranberry"
	item_state = "souto_cranberry"

/obj/item/reagent_container/food/drinks/cans/souto/cranberry/Initialize()
	. = ..()
	reagents.add_reagent("cornsyrup", 15)
	reagents.add_reagent("sodawater", 15)
	reagents.add_reagent("souto_cranberry", 20)

/obj/item/reagent_container/food/drinks/cans/souto/diet/cranberry
	name = "无糖蔓越莓索托"
	desc = "喝起来更像西梅而不是蔓越莓。不难喝，就是不对劲。在哈瓦那罐装。"
	icon_state = "souto_diet_cranberry"
	item_state = "souto_diet_cranberry"

/obj/item/reagent_container/food/drinks/cans/souto/diet/cranberry/Initialize()
	. = ..()
	reagents.add_reagent("sucralose", 15)
	reagents.add_reagent("sodawater", 15)
	reagents.add_reagent("souto_cranberry", 20)

/obj/item/reagent_container/food/drinks/cans/souto/vanilla
	name = "香草索托"
	desc = "多数汽水所谓的“香草味”，只是经典口味里加一点香草。索托公司可不这么干，宝贝！这一罐装满了 100% 纯碳酸香草精！难喝透顶。在哈瓦那罐装。"
	icon_state = "souto_vanilla"
	item_state = "souto_canilla"

/obj/item/reagent_container/food/drinks/cans/souto/vanilla/Initialize()
	. = ..()
	reagents.add_reagent("souto_vanilla", 50)

/obj/item/reagent_container/food/drinks/cans/souto/diet/vanilla
	name = "无糖香草索托"
	desc = "一罐稀薄苦涩的香草精。你完全想不出谁会批准这种产品。在哈瓦那罐装。"
	icon_state = "souto_diet_vanilla"
	item_state = "souto_diet_vanilla"

/obj/item/reagent_container/food/drinks/cans/souto/diet/vanilla/Initialize()
	. = ..()
	reagents.add_reagent("sodawater", 25)
	reagents.add_reagent("souto_vanilla", 25)

/obj/item/reagent_container/food/drinks/cans/souto/pineapple
	name = "菠萝索托"
	desc = "喝起来像电池酸液里兑了一整杯玉米糖浆。在哈瓦那罐装。"
	icon_state = "souto_pineapple"
	item_state = "souto_pineapple"

/obj/item/reagent_container/food/drinks/cans/souto/pineapple/Initialize()
	. = ..()
	reagents.add_reagent("cornsyrup", 15)
	reagents.add_reagent("sodawater", 15)
	reagents.add_reagent("souto_pineapple", 20)

/obj/item/reagent_container/food/drinks/cans/souto/diet/pineapple
	name = "无糖菠萝索托"
	desc = "喝起来像电池酸液里兑了一整杯代糖。在哈瓦那罐装。"
	icon_state = "souto_diet_pineapple"
	item_state = "souto_diet_pineapple"

/obj/item/reagent_container/food/drinks/cans/souto/diet/pineapple/Initialize()
	. = ..()
	reagents.add_reagent("cornsyrup", 15)
	reagents.add_reagent("sodawater", 15)
	reagents.add_reagent("souto_pineapple", 20)

//ASPEN

/obj/item/reagent_container/food/drinks/cans/aspen
	name = "维兰德-汤谷阿斯彭啤酒"
	desc = "只要忽略那股尿味，其实还挺不错。由维兰德-汤谷公司罐装。"
	icon_state = "6_pack_1"
	center_of_mass = "x=16;y=10"

/obj/item/reagent_container/food/drinks/cans/aspen/Initialize()
	. = ..()
	reagents.add_reagent("beer", 50)
