///FACTION NEUTRAL RATION

/obj/item/mre_food_packet/merc
	icon = 'icons/obj/items/food/mre_food/merc.dmi'

///ENTREE

/obj/item/mre_food_packet/entree/merc
	name = "FSR突击口粮主菜"
	desc = "FSR突击口粮的主菜包，提供主要营养来源。"
	icon = 'icons/obj/items/food/mre_food/merc.dmi'
	icon_state = "entree"
	food_list = list(
		/obj/item/reagent_container/food/snacks/mre_food/uscm/entree/porkribs,
		/obj/item/reagent_container/food/snacks/mre_food/uscm/entree/grilledchicken,
		/obj/item/reagent_container/food/snacks/mre_food/uscm/entree/pizzasquare,
		/obj/item/reagent_container/food/snacks/mre_food/uscm/entree/chickentender,
		/obj/item/reagent_container/food/snacks/mre_food/uscm/entree/pepperonisquare,
		/obj/item/reagent_container/food/snacks/mre_food/uscm/entree/spaghettichunks,
		/obj/item/reagent_container/food/snacks/mre_food/uscm/entree/grilledchickenbreast,
	)

///SIDE

/obj/item/mre_food_packet/merc/side
	name = "FSR突击口粮配菜"
	desc = "FSR突击口粮的配菜包，用于搭配主菜食用。"
	icon_state = "side"
	food_list = list(
		/obj/item/reagent_container/food/snacks/mre_food/uscm/side/cracker,
		/obj/item/reagent_container/food/snacks/mre_food/uscm/side/risotto,
		/obj/item/reagent_container/food/snacks/mre_food/uscm/side/onigiri,
		/obj/item/reagent_container/food/snacks/mre_food/uscm/side/cornbread,
		/obj/item/reagent_container/food/snacks/mre_food/uscm/side/tortillas,
		/obj/item/reagent_container/food/snacks/mre_food/uscm/side/cinnamonappleslices,
	)

///SNACK

/obj/item/mre_food_packet/merc/snack
	name = "FSR突击口粮零食"
	desc = "FSR突击口粮的零食包，适合不太饿时垫垫肚子。"
	icon_state = "snack"
	food_list = list(
		/obj/item/reagent_container/food/snacks/mre_food/uscm/snack/biscuit,
		/obj/item/reagent_container/food/snacks/mre_food/uscm/snack/meatballs,
		/obj/item/reagent_container/food/snacks/mre_food/uscm/snack/pretzels,
		/obj/item/reagent_container/food/snacks/mre_food/uscm/snack/sushi,
		/obj/item/reagent_container/food/snacks/mre_food/uscm/snack/peanuts,
	)

///DESSERT

/obj/item/mre_food_packet/merc/dessert
	name = "FSR突击口粮甜点"
	desc = "FSR突击口粮的甜点包，适合餐后享用（如果你够叛逆，餐前吃也行）。"
	icon_state = "dessert"
	food_list = list(
		/obj/item/reagent_container/food/snacks/mre_food/uscm/dessert/spicedapples,
		/obj/item/reagent_container/food/snacks/mre_food/uscm/dessert/chocolatebrownie,
		/obj/item/reagent_container/food/snacks/mre_food/uscm/dessert/sugarcookie,
		/obj/item/reagent_container/food/snacks/mre_food/uscm/dessert/cocobar,
		/obj/item/reagent_container/food/snacks/mre_food/uscm/dessert/flan,
		/obj/item/reagent_container/food/snacks/mre_food/uscm/dessert/honeyflan,
		/obj/item/reagent_container/food/snacks/cookie,
		/obj/item/reagent_container/food/snacks/mre_food/uscm/dessert/lemonpie,
		/obj/item/reagent_container/food/snacks/mre_food/uscm/dessert/limepie,
	)
