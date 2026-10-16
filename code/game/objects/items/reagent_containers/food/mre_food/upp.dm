//UPP

/obj/item/mre_food_packet/upp
	icon = 'icons/obj/items/food/mre_food/upp.dmi'
	icon_state = null

/obj/item/reagent_container/food/snacks/mre_food/upp
	icon = 'icons/obj/items/food/mre_food/upp.dmi'

///SNACK

/obj/item/mre_food_packet/upp/snack
	name = "\improper IRP单兵口粮零食"
	desc = "IRP单兵口粮中的营养零食，适合休息时吃，也可搭配主菜。"
	icon_state = "upp_snack"
	food_list = list(
		/obj/item/reagent_container/food/snacks/mre_food/upp/snack/driedfish,
		/obj/item/reagent_container/food/snacks/mre_food/upp/snack/driedfish/alt,
		/obj/item/reagent_container/food/snacks/mre_food/upp/snack/mashed_potato,
		/obj/item/reagent_container/food/snacks/mre_food/upp/snack/riceball,
	)

/obj/item/reagent_container/food/snacks/mre_food/upp/snack/driedfish
	name = "咸鳕鱼干片"
	icon_state = "driedfish"
	desc = "晒干腌咸的鳕鱼片，配上一口冰啤酒再合适不过。"

/obj/item/reagent_container/food/snacks/mre_food/upp/snack/driedfish/Initialize()
	. = ..()
	reagents.add_reagent("fish", 4)
	reagents.add_reagent("sodiumchloride", 2)

/obj/item/reagent_container/food/snacks/mre_food/upp/snack/driedfish/alt
	name = "塔兰咸鱼干"
	icon_state = "driedfish_2"
	desc = "整条晒干腌咸的塔兰鱼（Rutilus heckelii），配上一口冰啤酒再合适不过。"

/obj/item/reagent_container/food/snacks/mre_food/upp/snack/mashed_potato
	name = "土豆泥"
	icon_state = "mashed potatoes"
	desc = "口感细腻柔软的小份配菜，适合搭配其他食物。"

/obj/item/reagent_container/food/snacks/mre_food/upp/snack/mashed_potato/Initialize()
	. = ..()
	reagents.add_reagent("potato", 4)
	reagents.add_reagent("milk", 2)
	reagents.add_reagent("sodiumchloride", 1)

/obj/item/reagent_container/food/snacks/mre_food/upp/snack/riceball
	name = "饭团"
	icon_state = "riceball"
	desc = "把熟米饭捏成的团子，带有淡淡的黄油味，居然没有散开。"

/obj/item/reagent_container/food/snacks/mre_food/upp/snack/riceball/Initialize()
	. = ..()
	reagents.add_reagent("rice", 4)
	reagents.add_reagent("sodiumchloride", 1)

///DESSERT

/obj/item/mre_food_packet/upp/dessert
	name = "\improper IRP单兵口粮甜点"
	desc = "IRP单兵口粮的配餐部分，内含适合搭配茶或其他热饮的甜点。"
	icon_state = "upp_dessert"
	food_list = list(
		/obj/item/reagent_container/food/snacks/mre_food/upp/dessert/birdmilk,
		/obj/item/reagent_container/food/snacks/mre_food/upp/dessert/toffees,
		/obj/item/reagent_container/food/snacks/mre_food/upp/dessert/hematogen,
		/obj/item/reagent_container/food/snacks/mre_food/upp/dessert/darkchocolate,
		/obj/item/reagent_container/food/snacks/mre_food/upp/dessert/ricecandy,
	)

/obj/item/reagent_container/food/snacks/mre_food/upp/dessert/birdmilk
	name = "鸟乳糖"
	icon_state = "bird milk"
	desc = "鸟乳糖又称ptasie mleczko，是东欧斯拉夫地区流行的糖果。小块的奶油软糖口感类似棉花糖，外面裹着一层巧克力。"

/obj/item/reagent_container/food/snacks/mre_food/upp/dessert/birdmilk/Initialize()
	. = ..()
	reagents.add_reagent("sugar", 4)
	reagents.add_reagent("cream", 3)
	reagents.add_reagent("coco", 3)

/obj/item/reagent_container/food/snacks/mre_food/upp/dessert/toffees
	name = "太妃糖"
	icon_state = "toffees"
	desc = "将炼乳和糖一起熬至焦糖化制成的硬糖。"

/obj/item/reagent_container/food/snacks/mre_food/upp/dessert/toffees/Initialize()
	. = ..()
	reagents.add_reagent("sugar", 6)
	reagents.add_reagent("milk", 4)

/obj/item/reagent_container/food/snacks/mre_food/upp/dessert/hematogen
	name = "血源营养糖条"
	icon_state = "hematogen"
	desc = "一种起源可追溯到苏联时期的糖条。它宣称能够促进造血和血液循环，原料包括牛血、炼乳、蜂蜜和抗坏血酸。"

/obj/item/reagent_container/food/snacks/mre_food/upp/dessert/hematogen/Initialize()
	. = ..()
	reagents.add_reagent("iron", 8)
	reagents.add_reagent("sugar", 3)
	reagents.add_reagent("blood", 4)
	reagents.add_reagent("milk", 4)
	reagents.add_reagent("honey", 3)

/obj/item/reagent_container/food/snacks/mre_food/upp/dessert/darkchocolate
	name = "黑巧克力条"
	icon_state = "dark chocolate"
	desc = "可可含量56%的纯正黑巧克力，风味浓郁经典，适合搭配热饮和其他零食。"

/obj/item/reagent_container/food/snacks/mre_food/upp/dessert/darkchocolate/Initialize()
	. = ..()
	reagents.add_reagent("coco", 8)
	reagents.add_reagent("sugar", 2)

/obj/item/reagent_container/food/snacks/mre_food/upp/dessert/ricecandy
	name = "巧克力米糖"
	icon_state = "rice candies"
	desc = "各式裹着白巧克力的米糖，外层顺滑，内里酥脆。"

/obj/item/reagent_container/food/snacks/mre_food/upp/dessert/ricecandy/Initialize()
	. = ..()
	reagents.add_reagent("coco", 4)
	reagents.add_reagent("rice", 2)
