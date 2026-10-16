/obj/structure/urinal
	name = "小便池"
	desc = "HU-452 型，一款实验性小便池。"
	icon = 'icons/obj/structures/props/watercloset.dmi'
	icon_state = "urinal"
	density = FALSE
	anchored = TRUE

/obj/structure/urinal/attackby(obj/item/I, mob/living/user)
	if(istype(I, /obj/item/grab))
		if(isxeno(user)) return
		var/obj/item/grab/G = I
		if(isliving(G.grabbed_thing))
			var/mob/living/GM = G.grabbed_thing
			if(user.grab_level > GRAB_PASSIVE)
				if(!GM.loc == get_turf(src))
					to_chat(user, SPAN_NOTICE("[GM.name]得先到小便池的位置上。"))
					return
				user.visible_message(SPAN_DANGER("[user]把[GM.name]猛地撞向[src]！"), SPAN_NOTICE("你把[GM.name]猛地撞向[src]！"))
				GM.apply_damage(8, BRUTE)
			else
				to_chat(user, SPAN_NOTICE("你得抓得更紧一点。"))
