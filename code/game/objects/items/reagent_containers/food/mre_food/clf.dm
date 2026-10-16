//CLF

/obj/item/mre_food_packet/clf
	name = "包好的简易餐食"
	desc = "一份家常饭菜或搜罗来的食物，条件有限，只能尽力而为。"
	icon_state = "clf_mealpack"
	no_packet_label = TRUE
	icon = 'icons/obj/items/food/mre_food/clf.dmi'
	food_list = list(
		/obj/item/reagent_container/food/snacks/mre_food/clf/meatpie,
		/obj/item/reagent_container/food/snacks/mre_food/clf/bananapie,
		/obj/item/reagent_container/food/snacks/mre_food/clf/cheesepizza,
		/obj/item/reagent_container/food/snacks/mre_food/clf/mushroompizza,
		/obj/item/reagent_container/food/snacks/mre_food/clf/vegetablepizza,
		/obj/item/reagent_container/food/snacks/mre_food/clf/meatpizza,
	)

/obj/item/reagent_container/food/snacks/mre_food/clf
	icon = 'icons/obj/items/food/mre_food/clf.dmi'

/obj/item/reagent_container/food/snacks/mre_food/clf/meatpie
	name = "包好的肉馅派"
	icon_state = "clf_meatpie"
	desc = "包好的自制肉馅派，满含心意。"

/obj/item/reagent_container/food/snacks/mre_food/clf/meatpie/Initialize()
	. = ..()
	reagents.add_reagent("bread", 6)
	reagents.add_reagent("meatprotein", 20)
	reagents.add_reagent("sodiumchloride", 4)

/obj/item/reagent_container/food/snacks/mre_food/clf/bananapie
	name = "包好的香蕉派"
	icon_state = "clf_pie"
	desc = "包好的自制香蕉派，香甜绵密，出自一位颇有幽默感的人之手。"

/obj/item/reagent_container/food/snacks/mre_food/clf/bananapie/Initialize()
	. = ..()
	reagents.add_reagent("bread", 10)
	reagents.add_reagent("banana", 16)
	reagents.add_reagent("cream", 5)
	reagents.add_reagent("sugar", 4)

/obj/item/reagent_container/food/snacks/mre_food/clf/cheesepizza
	name = "包好的芝士披萨"
	icon_state = "clf_cheesepizza"
	desc = "包好的小号披萨，上面铺着多种芝士。"

/obj/item/reagent_container/food/snacks/mre_food/clf/cheesepizza/Initialize()
	. = ..()
	reagents.add_reagent("bread", 10)
	reagents.add_reagent("cheese", 16)
	reagents.add_reagent("sodiumchloride", 4)

/obj/item/reagent_container/food/snacks/mre_food/clf/mushroompizza
	name = "包好的蘑菇披萨"
	icon_state = "clf_mushroompizza"
	desc = "包好的小号披萨，配有奶油酱和蘑菇片。"

/obj/item/reagent_container/food/snacks/mre_food/clf/mushroompizza/Initialize()
	. = ..()
	reagents.add_reagent("bread", 8)
	reagents.add_reagent("mushroom", 14)
	reagents.add_reagent("cheese", 4)
	reagents.add_reagent("sodiumchloride", 4)

/obj/item/reagent_container/food/snacks/mre_food/clf/vegetablepizza
	name = "包好的蔬菜披萨"
	icon_state = "clf_vegetablepizza"
	desc = "包好的小号披萨，适合素食者，不过上面还是有些芝士。"

/obj/item/reagent_container/food/snacks/mre_food/clf/vegetablepizza/Initialize()
	. = ..()
	reagents.add_reagent("bread", 8)
	reagents.add_reagent("vegetable", 14)
	reagents.add_reagent("cheese", 4)
	reagents.add_reagent("tomatojuice", 6)
	reagents.add_reagent("sodiumchloride", 4)

/obj/item/reagent_container/food/snacks/mre_food/clf/meatpizza
	name = "包好的肉类披萨"
	icon_state = "clf_meatpizza"
	desc = "包好的小号披萨，上面铺着牛肉片和培根。"

/obj/item/reagent_container/food/snacks/mre_food/clf/meatpizza/Initialize()
	. = ..()
	reagents.add_reagent("bread", 8)
	reagents.add_reagent("meatprotein", 14)
	reagents.add_reagent("cheese", 4)
	reagents.add_reagent("tomatojuice", 6)
	reagents.add_reagent("sodiumchloride", 4)
