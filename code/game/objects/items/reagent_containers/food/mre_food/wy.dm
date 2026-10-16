//WY

/obj/item/mre_food_packet/wy
	icon = 'icons/obj/items/food/mre_food/wy.dmi'
	icon_state = null

/obj/item/reagent_container/food/snacks/mre_food/wy
	icon = 'icons/obj/items/food/mre_food/wy.dmi'

///ENTREE

/obj/item/mre_food_packet/entree/wy
	name = "\improper CFR战地作战口粮主菜"
	desc = "战地作战口粮的主菜，烹调精致，采用尖端保鲜技术和大量化学添加剂保存。"
	icon = 'icons/obj/items/food/mre_food/wy.dmi'
	icon_state = "pmc_entree"
	food_list = list(
		/obj/item/reagent_container/food/snacks/mre_food/wy/entree/bakedfish,
		/obj/item/reagent_container/food/snacks/mre_food/wy/entree/smokyribs,
		/obj/item/reagent_container/food/snacks/mre_food/wy/entree/ham,
		/obj/item/reagent_container/food/snacks/mre_food/wy/entree/beefstake,
	)

/obj/item/reagent_container/food/snacks/mre_food/wy/entree/bakedfish
	name = "烤三文鱼"
	icon_state = "baked fish"
	desc = "浸在奶油酱中的烤三文鱼片，额外添加的维生素D3恰好够你未来四天所需。"

/obj/item/reagent_container/food/snacks/mre_food/wy/entree/bakedfish/Initialize()
	. = ..()
	reagents.add_reagent("fish", 14)
	reagents.add_reagent("cream", 2)
	reagents.add_reagent("sodiumchloride", 2)

/obj/item/reagent_container/food/snacks/mre_food/wy/entree/smokyribs
	name = "烟熏肋排"
	icon_state = "smoky ribs"
	desc = "配有黑胡椒苹果酱的烟熏牛肋排，出奇地鲜嫩多汁。"

/obj/item/reagent_container/food/snacks/mre_food/wy/entree/smokyribs/Initialize()
	. = ..()
	reagents.add_reagent("meatprotein", 13)
	reagents.add_reagent("blackpepper", 2)
	reagents.add_reagent("fruit", 1)
	reagents.add_reagent("sodiumchloride", 1)

/obj/item/reagent_container/food/snacks/mre_food/wy/entree/ham
	name = "烤火腿"
	icon_state = "ham"
	desc = "外层裹着胡椒的烤火腿，鲜嫩多汁，风味浓郁。"

/obj/item/reagent_container/food/snacks/mre_food/wy/entree/ham/Initialize()
	. = ..()
	reagents.add_reagent("meatprotein", 14)
	reagents.add_reagent("blackpepper", 2)
	reagents.add_reagent("blood", 1)
	reagents.add_reagent("sodiumchloride", 1)

/obj/item/reagent_container/food/snacks/mre_food/wy/entree/beefstake
	name = "牛排"
	icon_state = "beefstake"
	desc = "火候还算过得去的牛排，淋着橙香百里香酱汁。"

/obj/item/reagent_container/food/snacks/mre_food/wy/entree/beefstake/Initialize()
	. = ..()
	reagents.add_reagent("meatprotein", 14)
	reagents.add_reagent("orangejuice", 3)
	reagents.add_reagent("sodiumchloride", 1)

///SIDE

/obj/item/mre_food_packet/wy/side
	name = "\improper CFR战地作战口粮配菜"
	desc = "战地作战口粮的配餐部分，内含搭配主菜食用的配菜。"
	icon_state = "pmc_side"
	food_list = list(
		/obj/item/reagent_container/food/snacks/mre_food/uscm/side/cracker,
		/obj/item/reagent_container/food/snacks/mre_food/uscm/side/risotto,
		/obj/item/reagent_container/food/snacks/mre_food/uscm/side/onigiri,
		/obj/item/reagent_container/food/snacks/mre_food/twe/side/nigirisushi,
		/obj/item/reagent_container/food/snacks/mre_food/twe/side/tomatochips,
	)

///SNACK

/obj/item/mre_food_packet/wy/snack
	name = "\improper CFR战地作战口粮零食"
	desc = "战地作战口粮的配餐部分，内含餐后甜点；如果你够叛逆，也可以餐前吃。"
	icon_state = "pmc_snack"
	food_list = list(
		/obj/item/reagent_container/food/snacks/mre_food/twe/snack/almond,
		/obj/item/reagent_container/food/snacks/mre_food/uscm/snack/peanuts,
		/obj/item/reagent_container/food/snacks/mre_food/uscm/snack/pretzels,
	)

///DESSERT

/obj/item/mre_food_packet/wy/dessert
	name = "\improper CFR战地作战口粮甜点"
	desc = "战地作战口粮的配餐部分，内含餐后甜点；如果你够叛逆，也可以餐前吃。"
	icon_state = "pmc_dessert"
	food_list = list(
		/obj/item/reagent_container/food/snacks/mre_food/wy/dessert/eclair,
		/obj/item/reagent_container/food/snacks/mre_food/wy/dessert/strawberrycake,
		/obj/item/reagent_container/food/snacks/mre_food/wy/dessert/cherrypie,
		/obj/item/reagent_container/food/snacks/mre_food/wy/dessert/croissant,
		/obj/item/reagent_container/food/snacks/mre_food/wy/dessert/whitecoco,
	)

/obj/item/reagent_container/food/snacks/mre_food/wy/dessert/eclair
	name = "闪电泡芙"
	icon_state = "eclair"
	desc = "口感轻柔的酥皮糕点，填有香草奶油，顶部覆着巧克力糖霜。你已经尝到防腐剂的味道了。"

/obj/item/reagent_container/food/snacks/mre_food/wy/dessert/eclair/Initialize()
	. = ..()
	reagents.add_reagent("bread", 2)
	reagents.add_reagent("cream", 2)
	reagents.add_reagent("coco", 1)
	reagents.add_reagent("sugar", 2)

/obj/item/reagent_container/food/snacks/mre_food/wy/dessert/strawberrycake
	name = "草莓蛋糕"
	icon_state = "strawberry cake"
	desc = "轻盈的香草蛋糕，内有草莓夹心，外覆厚厚的草莓糖霜。"

/obj/item/reagent_container/food/snacks/mre_food/wy/dessert/strawberrycake/Initialize()
	. = ..()
	reagents.add_reagent("berryjuice", 5)
	reagents.add_reagent("cream", 2)
	reagents.add_reagent("bread", 2)
	reagents.add_reagent("sprinkles", 2)

/obj/item/reagent_container/food/snacks/mre_food/wy/dessert/cherrypie
	name = "樱桃派"
	icon_state = "cherry pie"
	desc = "外皮酥脆、内馅为柔软樱桃果冻的派。"

/obj/item/reagent_container/food/snacks/mre_food/wy/dessert/cherrypie/Initialize()
	. = ..()
	reagents.add_reagent("cherryjelly", 2)
	reagents.add_reagent("bread", 2)
	reagents.add_reagent("sugar", 1)

/obj/item/reagent_container/food/snacks/mre_food/wy/dessert/croissant
	name = "巧克力可颂"
	icon_state = "croissant"
	desc = "内馅为黑巧克力的酥脆可颂。"

/obj/item/reagent_container/food/snacks/mre_food/wy/dessert/croissant/Initialize()
	. = ..()
	reagents.add_reagent("bread", 2)
	reagents.add_reagent("coco", 3)
	reagents.add_reagent("sugar", 1)

/obj/item/reagent_container/food/snacks/mre_food/wy/dessert/whitecoco
	name = "白巧克力条"
	icon_state = "white chocolate bar"
	desc = "含有杏仁碎和椰蓉的白巧克力。别让异端说它是假巧克力，享受美味的人可是你。"

/obj/item/reagent_container/food/snacks/mre_food/wy/dessert/whitecoco/Initialize()
	. = ..()
	reagents.add_reagent("coco", 3)
	reagents.add_reagent("milk", 2)
	reagents.add_reagent("nuts", 2)
	reagents.add_reagent("coconutmilk", 2)
	reagents.add_reagent("sugar", 1)

//WY GENERAL RATION

/obj/item/mre_food_packet/entree/wy_colonist
	name = "\improper 维兰德-汤谷牌口粮主菜"
	desc = "大概是这份口粮里最能入口的部分，提供主要的营养。"
	icon = 'icons/obj/items/food/mre_food/wy.dmi'
	icon_state = "wy_main"
	food_list = list(
		/obj/item/reagent_container/food/snacks/mre_food/uscm/entree/porkribs,
		/obj/item/reagent_container/food/snacks/mre_food/uscm/entree/grilledchicken,
		/obj/item/reagent_container/food/snacks/mre_food/uscm/entree/chickentender,
		/obj/item/reagent_container/food/snacks/mre_food/uscm/entree/spaghettichunks,
		/obj/item/reagent_container/food/snacks/mre_food/uscm/entree/grilledchickenbreast,
	)

//WY EMERGENCY RATION

/obj/item/mre_food_packet/wy/cookie_brick
	name = "应急食品包（压缩饼干）"
	desc = "砖块般的饼干，专为在极端条件下长期储存而设计，吃起来仍像压实的黄油饼干。"
	icon_state = "cookie_brick"
	no_packet_label = TRUE
	food_list = list(/obj/item/reagent_container/food/snacks/mre_food/wy_emergency_cookie)

/obj/item/reagent_container/food/snacks/mre_food/wy_emergency_cookie
	name = "\improper 维兰德-汤谷牌应急营养砖"
	desc = "砖块般的饼干，专为在极端条件下长期储存而设计，吃起来仍像压实的黄油饼干。"
	icon = 'icons/obj/items/food/mre_food/wy.dmi'
	icon_state = "cookie_brick_open"

/obj/item/reagent_container/food/snacks/mre_food/wy_emergency_cookie/Initialize()
	. = ..()
	reagents.add_reagent("nutriment", 12)
	reagents.add_reagent("bread", 12)
	reagents.add_reagent("sugar", 4)
