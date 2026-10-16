//USCM

/obj/item/mre_food_packet/hdr
	icon = 'icons/obj/items/food/mre_food/hdr.dmi'

///ENTREE

/obj/item/mre_food_packet/entree/hdr
	name = "\improper HDR救济口粮主菜"
	desc = "HDR人道主义救济口粮的两份主菜之一，最好与另一份混合食用。"
	icon = 'icons/obj/items/food/mre_food/hdr.dmi'
	icon_state = "entree"
	food_list = list(
		/obj/item/reagent_container/food/snacks/mre_food/hdr/entree/beanstomato,
		/obj/item/reagent_container/food/snacks/mre_food/hdr/entree/splitpea,
	)

/obj/item/mre_food_packet/entree/hdr/two
	food_list = list(
		/obj/item/reagent_container/food/snacks/mre_food/hdr/entree/yellowrice,
		/obj/item/reagent_container/food/snacks/mre_food/hdr/entree/herbrice,
	)

/obj/item/reagent_container/food/snacks/mre_food/hdr
	icon = 'icons/obj/items/food/mre_food/hdr.dmi'

/obj/item/reagent_container/food/snacks/mre_food/hdr/entree/beanstomato
	name = "茄汁豆"
	icon_state = "beans tomato sauce"
	desc = "浸在浓稠番茄酱中的红豆。来自美洲联盟人民的食物馈赠！"

/obj/item/reagent_container/food/snacks/mre_food/hdr/entree/beanstomato/Initialize()
	. = ..()
	reagents.add_reagent("vegetable", 20)
	reagents.add_reagent("tomatojuice", 5)
	reagents.add_reagent("sodiumchloride", 2)

/obj/item/reagent_container/food/snacks/mre_food/hdr/entree/splitpea
	name = "豌豆浓汤"
	icon_state = "split pea soup"
	desc = "卖相虽然不怎么样，却相当美味管饱。来自美洲联盟人民的食物馈赠！"

/obj/item/reagent_container/food/snacks/mre_food/hdr/entree/splitpea/Initialize()
	. = ..()
	reagents.add_reagent("vegetable", 25)
	reagents.add_reagent("sodiumchloride", 2)

/obj/item/reagent_container/food/snacks/mre_food/hdr/entree/yellowrice
	name = "黄米饭"
	icon_state = "yellow rice"
	desc = "加入少许藏红花调味的白米饭。来自美洲联盟人民的食物馈赠！"

/obj/item/reagent_container/food/snacks/mre_food/hdr/entree/yellowrice/Initialize()
	. = ..()
	reagents.add_reagent("rice", 25)
	reagents.add_reagent("sodiumchloride", 2)

/obj/item/reagent_container/food/snacks/mre_food/hdr/entree/herbrice
	name = "香草米饭"
	icon_state = "herb rice"
	desc = "加入香草调味的白米饭。来自美洲联盟人民的食物馈赠！"

/obj/item/reagent_container/food/snacks/mre_food/hdr/entree/herbrice/Initialize()
	. = ..()
	reagents.add_reagent("rice", 20)
	reagents.add_reagent("vegetable", 5)
	reagents.add_reagent("sodiumchloride", 2)

/obj/item/mre_food_packet/hdr/side
	name = "\improper HDR救济口粮配菜"
	desc = "HDR人道主义救济口粮的配餐部分，内含搭配主菜食用的配菜。"
	icon_state = "side"
	food_list = list(
		/obj/item/reagent_container/food/snacks/mre_food/hdr/side/shortbread,
		/obj/item/reagent_container/food/snacks/mre_food/hdr/side/vegetablecrackers,
	)

/obj/item/reagent_container/food/snacks/mre_food/hdr/side/shortbread
	name = "黄油酥饼"
	icon_state = "shortbread"
	desc = "普通的黄油酥饼。拿两块互相敲击，还能打出不错的节奏。来自美洲联盟人民的食物馈赠！"

/obj/item/reagent_container/food/snacks/mre_food/hdr/side/shortbread/Initialize()
	. = ..()
	reagents.add_reagent("bread", 8)
	reagents.add_reagent("sodiumchloride", 2)

/obj/item/reagent_container/food/snacks/mre_food/hdr/side/vegetablecrackers
	name = "蔬菜薄脆饼干"
	icon_state = "vegetable crackers"
	desc = "撒有脱水蔬菜的方形烤薄饼。来自美洲联盟人民的食物馈赠！"

/obj/item/reagent_container/food/snacks/mre_food/hdr/side/vegetablecrackers/Initialize()
	. = ..()
	reagents.add_reagent("bread", 6)
	reagents.add_reagent("vegetable", 2)
	reagents.add_reagent("sodiumchloride", 2)

/obj/item/mre_food_packet/hdr/dessert
	name = "\improper HDR救济口粮甜点"
	desc = "HDR人道主义救济口粮的配餐部分，内含餐后甜点；如果你够叛逆，也可以餐前吃。"
	icon_state = "dessert"
	food_list = list(
		/obj/item/reagent_container/food/snacks/mre_food/uscm/dessert/spicedapples,
		/obj/item/reagent_container/food/snacks/mre_food/hdr/dessert/figbar,
	)

/obj/item/reagent_container/food/snacks/mre_food/hdr/dessert/figbar
	name = "无花果夹心糕"
	icon_state = "figbar"
	desc = "内馅为无花果酱的糕点。"

/obj/item/reagent_container/food/snacks/mre_food/hdr/dessert/figbar/Initialize()
	. = ..()
	reagents.add_reagent("bread", 2)
	reagents.add_reagent("coco", 2)
	reagents.add_reagent("sprinkles", 1)


/obj/item/reagent_container/food/drinks/cans/spread/sunflowerbutter
	name = "抹酱包（葵花籽酱）"
	icon = 'icons/obj/items/food/mre_food/hdr.dmi'
	icon_state = "spread_hdr"
	desc = "用加工过的葵花籽制成的绵密抹酱，带有坚果香。低致敏配方！"
	flavor = "sunflower butter"

/obj/item/reagent_container/food/drinks/cans/spread/sunflowerbutter/Initialize()
	. = ..()
	reagents.add_reagent("nutriment", 4) //gigaprocessed!
	reagents.add_reagent("sugar", 2)

/obj/item/reagent_container/food/drinks/cans/spread/strawberryjam
	name = "抹酱包（草莓酱）"
	icon = 'icons/obj/items/food/mre_food/hdr.dmi'
	icon_state = "spread_hdr"
	desc = "甜甜的草莓酱，里面带着一些籽。幼儿也可以放心食用！"
	flavor = "strawberry jam"

/obj/item/reagent_container/food/drinks/cans/spread/strawberryjam/Initialize()
	. = ..()
	reagents.add_reagent("strawberryjam", 4)
	reagents.add_reagent("sugar", 2)
