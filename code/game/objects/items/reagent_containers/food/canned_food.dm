/obj/item/reagent_container/food/drinks/cans/food
	name = "罐头食品"
	desc = "一罐食物。"
	icon_state = ""
	item_icons = list(
		WEAR_L_HAND = 'icons/mob/humans/onmob/inhands/items/canned_food_lefthand.dmi',
		WEAR_R_HAND = 'icons/mob/humans/onmob/inhands/items/canned_food_righthand.dmi'
	)
	needs_can_opener = TRUE
	crushable = FALSE
	open_sound = 'sound/items/can_opened.ogg'
	open_message = "你伴着金属碰响打开了罐头！"
	consume_sound = 'sound/items/eatfood.ogg'
	object_fluff = "罐头"
	has_open_icon = TRUE
	delete_on_empty = TRUE

/obj/item/reagent_container/food/drinks/cans/food/upp
	icon = 'icons/obj/items/food/mre_food/upp.dmi'

/obj/item/reagent_container/food/drinks/cans/food/upp/meat
	name = "牛肉罐头"
	desc = "号称100%优质牛肉的罐头。至于究竟是牛的哪个部位，还有待商榷。"
	icon_state = "Canned_meat"
	volume = 20

/obj/item/reagent_container/food/drinks/cans/food/upp/meat/Initialize()
	. = ..()
	reagents.add_reagent("meatprotein", 14)
	reagents.add_reagent("sodiumchloride", 2)

/obj/item/reagent_container/food/drinks/cans/food/upp/stew
	name = "炖菜罐头"
	desc = "内含胡萝卜、番茄、蘑菇、肉、豆子，以及天知道还有什么的炖菜罐头。加热后是顿不错的饭。"
	icon_state = "Canned_stew"
	volume = 30

/obj/item/reagent_container/food/drinks/cans/food/upp/stew/Initialize()
	. = ..()
	reagents.add_reagent("vegetable", 6)
	reagents.add_reagent("meatprotein", 6)
	reagents.add_reagent("mushroom", 3)
	reagents.add_reagent("tomatojuice", 5)
	reagents.add_reagent("water", 5)
	reagents.add_reagent("sodiumchloride", 2)

/obj/item/reagent_container/food/drinks/cans/food/upp/speck
	name = "咸肥膘罐头"
	desc = "煮熟腌咸的猪肥膘罐头，也称斯佩克。常用来抹面包，也可以直接吃。"
	icon_state = "Canned_speck"
	food_interactable = TRUE
	volume = 20

/obj/item/reagent_container/food/drinks/cans/food/upp/speck/Initialize()
	. = ..()
	reagents.add_reagent("meatprotein", 14)
	reagents.add_reagent("sodiumchloride", 5)

/obj/item/reagent_container/food/drinks/cans/food/upp/soup
	name = "汤罐头"
	desc = "内含牛肉清汤、土豆、豌豆，以及天知道还有什么的汤罐头。加热后是顿不错的饭。"
	icon_state = "Canned_stew"
	consume_sound = 'sound/items/drink.ogg'
	volume = 25

/obj/item/reagent_container/food/drinks/cans/food/upp/soup/Initialize()
	. = ..()
	reagents.add_reagent("vegetable", 6)
	reagents.add_reagent("meatprotein", 2)
	reagents.add_reagent("potato", 6)
	reagents.add_reagent("water", 5)
	reagents.add_reagent("sodiumchloride", 2)

/obj/item/reagent_container/food/drinks/cans/food/upp/rice
	name = "牛肉米饭罐头"
	desc = "拌有牛肉碎的熟米饭罐头。"
	icon_state = "Canned_rice"
	needs_can_opener = FALSE
	volume = 10

/obj/item/reagent_container/food/drinks/cans/food/upp/rice/Initialize()
	. = ..()
	reagents.add_reagent("rice", 6)
	reagents.add_reagent("meatprotein", 2)
	reagents.add_reagent("sodiumchloride", 2)

/obj/item/reagent_container/food/drinks/cans/food/upp/buckwheat
	name = "猪肉荞麦粥罐头"
	desc = "拌有猪肉碎的荞麦粥罐头。正所谓，多喝粥，长得壮！"
	icon_state = "Canned_buckwheat"
	needs_can_opener = FALSE
	volume = 10

/obj/item/reagent_container/food/drinks/cans/food/upp/buckwheat/Initialize()
	. = ..()
	reagents.add_reagent("buckwheat", 6)
	reagents.add_reagent("meatprotein", 2)
	reagents.add_reagent("sodiumchloride", 2)

/obj/item/reagent_container/food/drinks/cans/food/upp/pasta
	name = "海军肉末面罐头"
	desc = "这道菜起源于一艘发生哗变的俄国无畏舰，其实就是拌着肉末的熟意面。"
	icon_state = "Canned_pasta"
	needs_can_opener = FALSE
	volume = 10

/obj/item/reagent_container/food/drinks/cans/food/upp/pasta/Initialize()
	. = ..()
	reagents.add_reagent("noodles", 6)
	reagents.add_reagent("meatprotein", 2)
	reagents.add_reagent("sodiumchloride", 2)

/obj/item/reagent_container/food/drinks/cans/food/upp/vegetables
	name = "什锦蔬菜罐头"
	desc = "煮熟混合的玉米、茄子、番茄、大蒜、洋葱，可能还有些别的蔬菜。"
	icon_state = "Canned_vegetables"
	needs_can_opener = FALSE
	volume = 10

/obj/item/reagent_container/food/drinks/cans/food/upp/vegetables/Initialize()
	. = ..()
	reagents.add_reagent("vegetable", 6)
	reagents.add_reagent("sodiumchloride", 2)

/obj/item/reagent_container/food/drinks/cans/food/upp/condensed_milk
	name = "炼乳罐头"
	desc = "加糖保存的浓缩牛奶罐头，可以直接吃、加入饮品或用作食材。"
	icon_state = "Canned_condensed_milk"
	food_interactable = TRUE
	volume = 30

/obj/item/reagent_container/food/drinks/cans/food/upp/condensed_milk/Initialize()
	. = ..()
	reagents.add_reagent("sugar", 15)
	reagents.add_reagent("milk", 15)

/obj/item/reagent_container/food/drinks/cans/food/upp/condensed_boiled_milk
	name = "焦糖炼乳罐头"
	desc = "加糖熬煮至焦糖化的牛奶罐头，可以直接吃、加入饮品或用作食材。"
	icon_state = "Canned_boiled_condensed_milk"
	food_interactable = TRUE
	volume = 30

/obj/item/reagent_container/food/drinks/cans/food/upp/condensed_boiled_milk/Initialize()
	. = ..()
	reagents.add_reagent("sugar", 20)
	reagents.add_reagent("milk", 10)
