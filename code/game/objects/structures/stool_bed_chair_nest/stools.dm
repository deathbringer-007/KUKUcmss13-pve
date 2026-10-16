/obj/structure/bed/stool
	name = "凳子"
	desc = "把屁股放上来。"
	icon_state = "stool"
	anchored = TRUE
	can_buckle = FALSE
	foldabletype = /obj/item/stool



/obj/item/stool
	name = "凳子"
	desc = "糟糕，酒吧里的火药味越来越浓了。"
	icon = 'icons/obj/objects.dmi'
	icon_state = "stool"
	force = 15
	throwforce = 12
	w_class = SIZE_HUGE

/obj/item/stool/proc/deploy_stool(mob/user)
	new /obj/structure/bed/stool(get_turf(user))
	user.temp_drop_inv_item(src)
	user.visible_message(SPAN_NOTICE("[user]放下了[src]。"), SPAN_NOTICE("你放下了[src]。"))
	qdel(src)

/obj/item/stool/attack_self(mob/user)
	..()
	deploy_stool(user)


