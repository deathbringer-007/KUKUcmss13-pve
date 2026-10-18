/datum/game_decorator/thanksgiving

/datum/game_decorator/thanksgiving/is_active_decor()
	return (text2num(time2text(world.timeofday, "MM")) == 11) && (text2num(time2text(world.timeofday, "DD")) == 23)

/datum/game_decorator/thanksgiving/turkey_meals

/datum/game_decorator/thanksgiving/turkey_meals/decorate()
	. = ..()

	for(var/obj/structure/machinery/cm_vending/sorted/marine_food/cycled_food_vendor in world)
		cycled_food_vendor.listed_products = list(
			list("机械预制餐", -1, null, null),
			list("秋季节日套餐1：火鸡配土豆", 10, /obj/item/reagent_container/food/snacks/mre_pack/thanksgiving, VENDOR_ITEM_REGULAR),
			list("秋季节日套餐2：牛排配土豆", 10, /obj/item/reagent_container/food/snacks/mre_pack/thanksgiving2, VENDOR_ITEM_REGULAR),
			list("秋季节日套餐3：虾仁配米饭", 10, /obj/item/reagent_container/food/snacks/mre_pack/thanksgiving3, VENDOR_ITEM_REGULAR),
			// these spaces are purely for readability. Preemptive Action is an unsubtle reference to First Strike Bars.
			list("先发制人能量棒", -1, null, null),
			list("巧克力味", 50, /obj/item/reagent_container/food/snacks/protein_pack, VENDOR_ITEM_REGULAR),
			list("草莓味", 50, /obj/item/reagent_container/food/snacks/protein_pack2, VENDOR_ITEM_REGULAR),
			list("香草味", 50, /obj/item/reagent_container/food/snacks/protein_pack3, VENDOR_ITEM_REGULAR),
			// I kind of wish there was just a generic sweet mix.
			list("饮料冲剂", -1, null, null),
			list("橙汁冲剂包", 15, /obj/item/reagent_container/food/condiment/juice/orange, VENDOR_ITEM_REGULAR),
			list("苹果汁冲剂包", 15, /obj/item/reagent_container/food/condiment/juice/apple, VENDOR_ITEM_REGULAR),
			list("西瓜汁冲剂包", 15, /obj/item/reagent_container/food/condiment/juice/watermelon, VENDOR_ITEM_REGULAR),
			list("葡萄汁冲剂包", 15, /obj/item/reagent_container/food/condiment/juice/grape, VENDOR_ITEM_REGULAR),
			list("菠萝汁冲剂包", 15, /obj/item/reagent_container/food/condiment/juice/pineapple, VENDOR_ITEM_REGULAR),
			//hopefully this dont screw up nothing.
			list("水壶与酒壶", -1, null, null),
			list("军用水壶", 10, /obj/item/reagent_container/food/drinks/flask/canteen, VENDOR_ITEM_REGULAR),
			list("金属酒壶", 10, /obj/item/reagent_container/food/drinks/flask, VENDOR_ITEM_REGULAR),
			list("USCM酒壶", 5, /obj/item/reagent_container/food/drinks/flask/marine, VENDOR_ITEM_REGULAR),
			list("维兰德-汤谷酒壶", 5, /obj/item/reagent_container/food/drinks/flask/weylandyutani, VENDOR_ITEM_REGULAR)
		)
