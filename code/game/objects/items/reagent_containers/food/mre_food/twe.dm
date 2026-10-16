//TWE

/obj/item/mre_food_packet/twe
	icon = 'icons/obj/items/food/mre_food/twe.dmi'
	icon_state = null

/obj/item/reagent_container/food/snacks/mre_food/twe
	icon = 'icons/obj/items/food/mre_food/twe.dmi'

///ENTREE

/obj/item/mre_food_packet/entree/twe
	name = "\improper ORP作战口粮主菜"
	desc = "作战口粮包的主菜，按三世界帝国菜式精心烹调，颇为奢华，采用高科技保鲜技术保存。"
	icon = 'icons/obj/items/food/mre_food/twe.dmi'
	icon_state = "twe_entree"
	food_list = list(
		/obj/item/reagent_container/food/snacks/mre_food/twe/entree/bacon,
		/obj/item/reagent_container/food/snacks/mre_food/twe/entree/tomatobeans,
		/obj/item/reagent_container/food/snacks/mre_food/twe/entree/fishnrice,
		/obj/item/reagent_container/food/snacks/mre_food/twe/entree/ricenoodles,
		/obj/item/reagent_container/food/snacks/mre_food/twe/entree/fishnchips,
	)

/obj/item/reagent_container/food/snacks/mre_food/twe/entree/bacon
	name = "培根"
	icon_state = "bacon"
	desc = "英式早餐的又一经典组成部分，煎得酥脆的培根，搭配吐司很合适。"

/obj/item/reagent_container/food/snacks/mre_food/twe/entree/bacon/Initialize()
	. = ..()
	reagents.add_reagent("meatprotein", 14)
	reagents.add_reagent("sodiumchloride", 2)

/obj/item/reagent_container/food/snacks/mre_food/twe/entree/tomatobeans
	name = "茄汁豆"
	icon_state = "tomato beans"
	desc = "英式早餐的经典组成部分，番茄酱焗豆，搭配吐司很合适。"

/obj/item/reagent_container/food/snacks/mre_food/twe/entree/tomatobeans/Initialize()
	. = ..()
	reagents.add_reagent("vegetable", 14)
	reagents.add_reagent("tomatojuice", 8)
	reagents.add_reagent("sodiumchloride", 2)

/obj/item/reagent_container/food/snacks/mre_food/twe/entree/fishnrice
	name = "炸鱼配米饭"
	icon_state = "fish n rice"
	desc = "诞生于日本的菜式。最初，驻帝国亚洲地区的英联邦水手缺少土豆，于是想到可以用米饭代替。"

/obj/item/reagent_container/food/snacks/mre_food/twe/entree/fishnrice/Initialize()
	. = ..()
	reagents.add_reagent("fish", 6)
	reagents.add_reagent("rice", 6)
	reagents.add_reagent("cornoil", 2)
	reagents.add_reagent("sodiumchloride", 2)

/obj/item/reagent_container/food/snacks/mre_food/twe/entree/ricenoodles
	name = "日式米粉汤"
	icon_state = "rice noodles"
	desc = "日式米粉汤，加入了不少辣酱，还能找到些许胡萝卜和葱花。"

/obj/item/reagent_container/food/snacks/mre_food/twe/entree/ricenoodles/Initialize()
	. = ..()
	reagents.add_reagent("noodles", 6)
	reagents.add_reagent("rice", 6)
	reagents.add_reagent("vegetable", 2)
	reagents.add_reagent("capsaicin", 4)
	reagents.add_reagent("hotsauce", 4)

/obj/item/reagent_container/food/snacks/mre_food/twe/entree/fishnchips
	name = "炸鱼薯条"
	icon_state = "fish n chips"
	desc = "英式经典美食。鱼条裹上面包糠炸至酥脆，吃完满手都是油。"

/obj/item/reagent_container/food/snacks/mre_food/twe/entree/fishnchips/Initialize()
	. = ..()
	reagents.add_reagent("fish", 5)
	reagents.add_reagent("vegetable", 5)
	reagents.add_reagent("potato", 3)
	reagents.add_reagent("bread", 2)
	reagents.add_reagent("cornoil", 2)
	reagents.add_reagent("sodiumchloride", 2)

///SIDE

/obj/item/mre_food_packet/twe/side
	name = "\improper ORP作战口粮配菜"
	desc = "作战口粮包的配餐部分，内含搭配主菜食用的配菜。"
	icon_state = "twe_side"
	food_list = list(
		/obj/item/reagent_container/food/snacks/mre_food/twe/side/nutpatty,
		/obj/item/reagent_container/food/snacks/mre_food/twe/side/nigirisushi,
		/obj/item/reagent_container/food/snacks/mre_food/twe/side/nutpatty,
		/obj/item/reagent_container/food/snacks/mre_food/twe/side/tomatochips,
		/obj/item/reagent_container/food/snacks/mre_food/twe/side/bean_stew,
		/obj/item/reagent_container/food/snacks/mre_food/twe/side/mushroom_soup,
	)

/obj/item/reagent_container/food/snacks/mre_food/twe/side/nutpatty
	name = "鹰嘴豆饼"
	icon_state = "nut patty"
	desc = "鹰嘴豆制成的素饼，裹上面包糠油炸，不知为何让你想起炸鱼条。"

/obj/item/reagent_container/food/snacks/mre_food/twe/side/nutpatty/Initialize()
	. = ..()
	reagents.add_reagent("vegetable", 2)
	reagents.add_reagent("bread", 2)
	reagents.add_reagent("plantmatter", 2)
	reagents.add_reagent("sodiumchloride", 1)

/obj/item/reagent_container/food/snacks/mre_food/twe/side/mushroom_soup
	name = "蘑菇汤"
	icon_state = "mushroom_soup"
	desc = "营养丰富的蔬菜蘑菇汤，加热后能让你暖和好一阵。"

/obj/item/reagent_container/food/snacks/mre_food/twe/side/mushroom_soup/Initialize()
	. = ..()
	reagents.add_reagent("mushroom", 3)
	reagents.add_reagent("vegetable", 3)
	reagents.add_reagent("water", 5)
	reagents.add_reagent("sodiumchloride", 1)

/obj/item/reagent_container/food/snacks/mre_food/twe/side/bean_stew
	name = "炖豆"
	icon_state = "bean_soup"
	desc = "营养丰富的茄汁炖豆，加热后能让你暖和好一阵。"

/obj/item/reagent_container/food/snacks/mre_food/twe/side/bean_stew/Initialize()
	. = ..()
	reagents.add_reagent("vegetable", 6)
	reagents.add_reagent("water", 2)
	reagents.add_reagent("tomatojuice", 4)
	reagents.add_reagent("sodiumchloride", 1)

/obj/item/reagent_container/food/snacks/mre_food/twe/side/nigirisushi
	name = "握寿司"
	icon_state = "nigiri sushi"
	desc = "熟米饭团上覆着一片三文鱼，再裹上一条海苔，入口即化。"

/obj/item/reagent_container/food/snacks/mre_food/twe/side/nigirisushi/Initialize()
	. = ..()
	reagents.add_reagent("fish", 3)
	reagents.add_reagent("rice", 2)
	reagents.add_reagent("plantmatter", 1)
	reagents.add_reagent("soysauce", 1)

/obj/item/reagent_container/food/snacks/mre_food/twe/side/tomatochips
	name = "番茄脆片"
	icon_state = "tomato chips"
	desc = "极为酥脆，带着淡淡的罗勒香，很适合下酒。"

/obj/item/reagent_container/food/snacks/mre_food/twe/side/tomatochips/Initialize()
	. = ..()
	reagents.add_reagent("vegetable", 6)
	reagents.add_reagent("tomatojuice", 4)
	reagents.add_reagent("blackpepper", 2)
	reagents.add_reagent("sodiumchloride", 2)

///SNACK

/obj/item/mre_food_packet/twe/snack
	name = "\improper ORP作战口粮零食"
	desc = "作战口粮包中的轻食零食，适合不太饿的时候吃。"
	icon_state = "twe_snack"
	food_list = list(
		/obj/item/reagent_container/food/snacks/mre_food/twe/snack/cheese,
		/obj/item/reagent_container/food/snacks/mre_food/twe/snack/almond,
	)

/obj/item/reagent_container/food/snacks/mre_food/twe/snack/almond
	name = "杏仁"
	icon_state = "almond"
	desc = "烘干的杏仁，富含维生素，香味浓郁，口感酥脆。你一直渴望的奢侈享受。"

/obj/item/reagent_container/food/snacks/mre_food/twe/snack/almond/Initialize()
	. = ..()
	reagents.add_reagent("nuts", 4)
	reagents.add_reagent("sodiumchloride", 1)

/obj/item/reagent_container/food/snacks/mre_food/twe/snack/cheese
	name = "脱水奶酪块"
	icon_state = "cheese"
	desc = "冻干的切达奶酪块，非常干，但风味浓缩，是不错的零食。"

/obj/item/reagent_container/food/snacks/mre_food/twe/snack/cheese/Initialize()
	. = ..()
	reagents.add_reagent("cheese", 4)
	reagents.add_reagent("sodiumchloride", 1)

///DESSERT

/obj/item/mre_food_packet/twe/dessert
	name = "\improper ORP作战口粮甜点"
	desc = "作战口粮包的配餐部分，内含餐后甜点；如果你够叛逆，也可以餐前吃。"
	icon_state = "twe_dessert"
	food_list = list(
		/obj/item/reagent_container/food/snacks/mre_food/twe/dessert/chocobar,
		/obj/item/reagent_container/food/snacks/mre_food/twe/dessert/tinyapplepie,
		/obj/item/reagent_container/food/snacks/mre_food/twe/dessert/tinycheesecake,
		/obj/item/reagent_container/food/snacks/mre_food/twe/dessert/tinypancakes,
	)

/obj/item/reagent_container/food/snacks/mre_food/twe/dessert/chocobar
	name = "黑巧克力条"
	icon_state = "tiny chocolate bar"
	desc = "可可含量56%的纯正黑巧克力，风味浓郁经典，适合搭配热饮。"

/obj/item/reagent_container/food/snacks/mre_food/twe/dessert/chocobar/Initialize()
	. = ..()
	reagents.add_reagent("coco", 8)
	reagents.add_reagent("sugar", 2)

/obj/item/reagent_container/food/snacks/mre_food/twe/dessert/tinyapplepie
	name = "迷你苹果派"
	icon_state = "tiny applepie"
	desc = "内有多汁的肉桂风味苹果片。"

/obj/item/reagent_container/food/snacks/mre_food/twe/dessert/tinyapplepie/Initialize()
	. = ..()
	reagents.add_reagent("bread", 2)
	reagents.add_reagent("fruit", 2)
	reagents.add_reagent("sugar", 1)

/obj/item/reagent_container/food/snacks/mre_food/twe/dessert/tinycheesecake
	name = "迷你芝士蛋糕"
	icon_state = "tiny cheesecake"
	desc = "绵密轻盈，香甜的奶酪搭配美味的香草蛋糕底。"

/obj/item/reagent_container/food/snacks/mre_food/twe/dessert/tinycheesecake/Initialize()
	. = ..()
	reagents.add_reagent("bread", 2)
	reagents.add_reagent("cream", 2)
	reagents.add_reagent("milk", 2)

/obj/item/reagent_container/food/snacks/mre_food/twe/dessert/tinypancakes
	name = "迷你松饼"
	icon_state = "tiny pancakes"
	desc = "淋有蜂蜜的黄油小蛋糕。"

/obj/item/reagent_container/food/snacks/mre_food/twe/dessert/tinypancakes/Initialize()
	. = ..()
	reagents.add_reagent("bread", 2)
	reagents.add_reagent("honey", 2)
	reagents.add_reagent("sugar", 1)

///PASTE TUBE

/obj/item/reagent_container/food/drinks/cans/tube
	name = "营养膏管"
	icon = 'icons/obj/items/food/mre_food/twe.dmi'
	icon_state = "paste1"
	desc = "太空食品。"
	open_sound = 'sound/effects/pillbottle.ogg'
	open_message = "你拧开了管子的盖子。"
	volume = 15
	food_interactable = TRUE
	possible_transfer_amounts = list(1, 2, 3, 5)
	crushable = FALSE
	gulp_size = 5
	object_fluff = "管子"
	var/flavor = "paste_vegemite"

/obj/item/reagent_container/food/drinks/cans/tube/attack_self(mob/user)
	. = ..()
	update_icon()

/obj/item/reagent_container/food/drinks/cans/tube/Initialize()
	. = ..()
	update_icon()

/obj/item/reagent_container/food/drinks/cans/tube/on_reagent_change()
	. = ..()
	update_icon()

/obj/item/reagent_container/food/drinks/cans/tube/update_icon()
	overlays.Cut()
	if(open && reagents.total_volume)
		overlays += mutable_appearance(icon, flavor)

	if(!open)
		overlays += mutable_appearance(icon, "paste_cap")

	var/percent = floor((reagents.total_volume / volume) * 100)
	if(reagents && reagents.total_volume)
		switch(percent)
			if(1 to 32)
				icon_state = "paste3"
			if(33 to 65)
				icon_state = "paste2"
			if(66 to INFINITY)
				icon_state = "paste1"
	else
		icon_state = "paste3"

/obj/item/reagent_container/food/drinks/cans/tube/vegemite
	name = "ORP抹酱管（维吉麦）"
	desc = "装着非常咸的食品抹酱，很适合夹三明治，但不是每个人都喜欢它的味道和卖相。"

/obj/item/reagent_container/food/drinks/cans/tube/vegemite/Initialize()
	. = ..()
	reagents.add_reagent("vegemite", 20)

/obj/item/reagent_container/food/drinks/cans/tube/strawberry
	name = "ORP抹酱管（草莓）"
	desc = "装着草莓抹酱，很适合夹三明治。"
	flavor = "paste_strawberry"

/obj/item/reagent_container/food/drinks/cans/tube/strawberry/Initialize()
	. = ..()
	reagents.add_reagent("berryjuice", 15)
	reagents.add_reagent("sugar", 5)

/obj/item/reagent_container/food/drinks/cans/tube/blackberry
	name = "ORP抹酱管（黑莓）"
	desc = "装着黑莓抹酱，很适合夹三明治。"
	flavor = "paste_blackberry"

/obj/item/reagent_container/food/drinks/cans/tube/blackberry/Initialize()
	. = ..()
	reagents.add_reagent("berryjuice", 15)
	reagents.add_reagent("sugar", 5)

///LEMON DROP CANDY

/obj/item/reagent_container/food/snacks/lemondrop
	name = "柠檬酸糖"
	desc = "裹糖的柠檬味硬糖，酸甜可口，起源于英格兰，在三世界帝国很受欢迎。"
	icon_state = "lemondrop"
	icon = 'icons/obj/items/food/mre_food/twe.dmi'
	filling_color = "#e3f218"

/obj/item/reagent_container/food/snacks/lemondrop/Initialize()
	. = ..()
	reagents.add_reagent("lemonjuice", 3)
	reagents.add_reagent("sugar", 1)
