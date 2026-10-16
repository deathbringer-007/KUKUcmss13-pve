////////////////////////////////////////////////////////////////////////////////
/// For dilutable items, like tea bags, coffee, etc.

/obj/item/reagent_container/pill/teabag
	name = "速溶茶包"
	icon = 'icons/obj/items/food/mre_food/twe.dmi'
	icon_state = "teabag"
	item_state = null
	volume = 15
	ground_offset_x = 0
	ground_offset_y = 0
	reagent_desc_override = FALSE
	identificable = FALSE
	pill_desc = null
	pill_initial_reagents = list("tea_leaves" = 15)
	fluff_text = "茶包"
	var/list/tea_blends = list("伯爵", "英式早餐", "约克郡", "肯尼亚", "锡兰")

/obj/item/reagent_container/pill/teabag/Initialize(mapload, ...)
	. = ..()
	var/tea_name = pick(tea_blends)
	name = "[tea_name]速溶茶包"
	desc = "一包[tea_name]速溶红茶。连茶袋本身都能完全溶解，估计袋子也是茶做的。无需加热。"

/obj/item/reagent_container/pill/teabag/earl_grey
	tea_blends = list("伯爵")
