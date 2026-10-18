//Food.Regrouping all the ASRS crate related to food here.
// crate of random ingredient that you can buy in vendor in kitchen
/datum/supply_packs/ingredient
	name = "surplus boxes of ingredients(x6 boxes)"
	localized_name = "剩余库存食材盒（6盒）"
	randomised_num_contained = 6
	contains = list(
		/obj/item/storage/fancy/egg_box,
		/obj/item/storage/box/fish,
		/obj/item/storage/box/meat,
		/obj/item/storage/box/milk,
		/obj/item/storage/box/soymilk,
		/obj/item/storage/box/enzyme,
		/obj/item/storage/box/flour,
		/obj/item/storage/box/sugar,
		/obj/item/storage/box/apple,
		/obj/item/storage/box/banana,
		/obj/item/storage/box/chanterelle,
		/obj/item/storage/box/cherries,
		/obj/item/storage/box/chili,
		/obj/item/storage/box/cabbage,
		/obj/item/storage/box/carrot,
		/obj/item/storage/box/corn,
		/obj/item/storage/box/eggplant,
		/obj/item/storage/box/lemon,
		/obj/item/storage/box/lime,
		/obj/item/storage/box/orange,
		/obj/item/storage/box/potato,
		/obj/item/storage/box/tomato,
		/obj/item/storage/box/whitebeet,
		/obj/item/reagent_container/food/condiment/hotsauce/cholula,
		/obj/item/reagent_container/food/condiment/hotsauce/franks,
		/obj/item/reagent_container/food/condiment/hotsauce/sriracha,
		/obj/item/reagent_container/food/condiment/hotsauce/tabasco,
		/obj/item/reagent_container/food/drinks/bottle/whiskey,
		/obj/item/reagent_container/food/drinks/bottle/tequila,
		/obj/item/reagent_container/food/drinks/bottle/rum,
		/obj/item/reagent_container/food/drinks/bottle/wine,
	)
	cost = 10
	containertype = /obj/structure/closet/crate/freezer
	containername = "\improper 剩余库存食材箱"
	group = "Food"

//all the finish snacks.

/datum/supply_packs/donuts
	name = "box of donuts (x5)"
	localized_name = "甜甜圈盒（5盒）"
	contains = list(
		/obj/item/storage/donut_box,
		/obj/item/storage/donut_box,
		/obj/item/storage/donut_box,
		/obj/item/storage/donut_box,
		/obj/item/storage/donut_box,
	)
	cost = 10
	containertype = /obj/structure/closet/crate/supply
	containername = "甜甜圈盒（5盒）"
	group = "Food"

/datum/supply_packs/mre
	name = "USCM MRE crate(x2)"
	localized_name = "殖民地陆战队即食军粮箱（2份）"
	contains = list(
		/obj/item/ammo_box/magazine/misc/mre,
		/obj/item/ammo_box/magazine/misc/mre,
	)
	cost = 10
	containertype = /obj/structure/closet/crate/supply
	containername = "\improper 殖民地陆战队即食军粮箱（2份）"
	group = "Food"

/datum/supply_packs/pizzas
	name = "pizza ready-to-eat (x3)"
	localized_name = "即食披萨（3份）"
	contains = list(
		/obj/item/pizzabox/mystery/stack,
	)
	cost = 30
	containertype = /obj/structure/closet/crate/freezer
	containername = "\improper 披萨箱"
	group = "Food"
