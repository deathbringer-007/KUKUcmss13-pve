//////Kitchen Spike

/obj/structure/kitchenspike
	name = "屠宰钎"
	icon = 'icons/obj/structures/machinery/kitchen.dmi'
	icon_state = "spike"
	desc = "用于从动物身上取肉的尖钎。"
	density = TRUE
	anchored = TRUE
	unslashable = TRUE
	var/meat = 0
	var/occupied = 0
	var/meattype = 0 // 0 - Nothing, 1 - Monkey, 2 - Xeno

/obj/structure/kitchenspike/attackby(obj/item/grab/G, mob/user)
	if(!istype(G, /obj/item/grab))
		return
	to_chat(user, SPAN_DANGER("这个目标太大，钎子挂不住，换个小点的！"))

// MouseDrop_T(atom/movable/C, mob/user)
// if(istype(C, /obj/mob/carbon/monkey)
// else if(istype(C, /obj/mob/carbon/alien))
// else if(istype(C, /obj/livestock/spesscarp

/obj/structure/kitchenspike/attack_hand(mob/user as mob)
	if(..())
		return
	if(src.occupied)
		if(src.meattype == 1)
			if(src.meat > 1)
				src.meat--
				new /obj/item/reagent_container/food/snacks/meat/monkey( src.loc )
				to_chat(usr, "你从猴子身上割下了一些肉。")
			else if(src.meat == 1)
				src.meat--
				new /obj/item/reagent_container/food/snacks/meat/monkey(src.loc)
				to_chat(usr, "你从猴子身上割下了最后一块肉！")
				src.icon_state = "spike"
				src.occupied = 0
		else if(src.meattype == 2)
			if(src.meat > 1)
				src.meat--
				new /obj/item/reagent_container/food/snacks/meat/xenomeat( src.loc )
				to_chat(usr, "你从异形身上割下了一些肉。")
			else if(src.meat == 1)
				src.meat--
				new /obj/item/reagent_container/food/snacks/meat/xenomeat(src.loc)
				to_chat(usr, "你从异形身上割下了最后一块肉！")
				src.icon_state = "spike"
				src.occupied = 0
