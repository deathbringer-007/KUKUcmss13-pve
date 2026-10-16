/obj/item/reagent_container/food/snacks/honeycomb
	name = "蜂巢蜜"
	icon_state = "honeycomb"
	desc = "甜蜜的蜂蜜正一滴滴往下流。"

/obj/item/reagent_container/food/snacks/honeycomb/Initialize()
	. = ..()
	reagents.add_reagent("honey",10)
	reagents.add_reagent("nutriment", 0.5)
	reagents.add_reagent("sugar", 2)
	bitesize = 2

