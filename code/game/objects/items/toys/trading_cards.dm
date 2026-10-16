/proc/get_trading_card_color_name(color)
	switch(color)
		if("red")
			return "红色"
		if("green")
			return "绿色"
		if("blue")
			return "蓝色"
	return color

/obj/item/toy/trading_card
	name = "维兰德-汤谷军用集换卡"
	icon = 'icons/obj/items/playing_cards.dmi'
	icon_state = "trading_red"
	w_class = SIZE_TINY

	var/trading_card_number = "1"
	var/picture_description = "枪管增压器"
	var/collection_color
	var/is_front = FALSE
	var/back_name = "红色维兰德-汤谷军用集换卡"
	var/front_name = "红色维兰德-汤谷军用集换卡 1 号"
	var/back_description = "一张红色集换卡的背面，印着：维兰德-汤谷军用集换卡！一定要集齐全套！"
	var/front_description = "一张印着美洲联盟旗帜的红色集换卡。这是全套五张红卡中的第一张。"
	var/back_icon_state = "trading_red"
	var/front_icon_state = "trading_red_one"
	var/picture_descriptions = list("5" = list("red" = "狂热的殖民地叛乱分子", "green" = "乔埃尔·德拉克鲁斯海军上将（美洲联盟国防部长）", "blue" = "美洲联盟旗帜"),
									"4" = list("red" = "UPPA 士兵", "green" = "恩佐·加布里埃尔·卢尔德斯空军元帅（拉丁美洲殖民地海军作战部长）", "blue" = "进步人民联盟旗帜"),
									"3" = list("red" = "UPPA 转管机枪手", "green" = "费利克斯·库图尔陆军上将（加拿大殖民地武装部队司令）", "blue" = "三世界帝国旗帜"),
									"2" = list("red" = "UPPA 军官", "green" = "迭戈·德拉马尔焦上将（美国殖民地陆战队司令）", "blue" = "维兰德-汤谷标志"),
									"1" = list("red" = "HEFA 教团信徒", "green" = "德莱拉·S·沃恩上将（美国殖民地陆战队副司令）", "blue" = "独立核心星系殖民地标志",)
									)

/obj/item/toy/trading_card/Initialize()
	. = ..()

	if(istype(loc, /obj/item/storage/fancy/trading_card))
		var/obj/item/storage/fancy/trading_card/packet = loc
		collection_color = packet.collection_color

	if(!collection_color)
		collection_color = pick("red", "green", "blue")
	trading_card_number = pick_weight(list("5" = 25, "4" = 20, "3" = 15, "2" = 10, "1" = 5))
	picture_description = picture_descriptions[trading_card_number][collection_color]

	var/color_name = get_trading_card_color_name(collection_color)
	name = "[color_name]维兰德-汤谷军用集换卡"
	back_name = "[color_name]维兰德-汤谷军用集换卡"
	front_name = "[color_name]维兰德-汤谷军用集换卡 [trading_card_number] 号"

	desc = "一张[color_name]集换卡的背面，印着：维兰德-汤谷军用集换卡！一定要集齐全套！"
	back_description = "一张[color_name]集换卡的背面，印着：维兰德-汤谷军用集换卡！一定要集齐全套！"
	front_description = "一张印着[picture_description]的[color_name]集换卡。这是全套五张[color_name]卡中的第[trading_card_number]张。"

	icon_state = "trading_[collection_color]"
	back_icon_state = "trading_[collection_color]"
	front_icon_state = "trading_[collection_color]_[trading_card_number]"

/obj/item/toy/trading_card/attack_self(mob/user)
	if(loc == user)
		if(is_front)
			name = back_name
			desc = back_description
			icon_state = back_icon_state
			is_front = FALSE
		else
			to_chat(user, SPAN_NOTICE("你翻开了卡片，上面印着[picture_description]！"))
			name = front_name
			desc = front_description
			icon_state = front_icon_state
			is_front = TRUE
	return ..()
