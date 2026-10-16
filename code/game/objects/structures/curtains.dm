/obj/structure/curtain
	icon = 'icons/obj/structures/props/curtain.dmi'
	name = "帘子"
	icon_state = "green"
	layer = ABOVE_MOB_LAYER
	opacity = TRUE
	density = FALSE

/obj/structure/curtain/open/New()
	..()
	toggle()

/obj/structure/curtain/bullet_act(obj/projectile/P, def_zone)
	if(P.damage)
		visible_message(SPAN_WARNING("[P]撕碎了[src]！"))
		qdel(src)
	return 0

/obj/structure/curtain/attack_hand(mob/user)
	playsound(get_turf(loc), "rustle", 15, 1, 6)
	toggle()
	..()

/obj/structure/curtain/attack_alien(mob/living/carbon/xenomorph/M)
	M.animation_attack_on(src)
	M.visible_message(SPAN_DANGER("[M]划开了[src]！"), \
	SPAN_DANGER("你划开了[src]！"), null, 5)
	qdel(src)
	return XENO_ATTACK_ACTION

/obj/structure/curtain/proc/toggle()
	opacity = !opacity
	if(opacity)
		icon_state = "[initial(icon_state)]"
		layer = ABOVE_MOB_LAYER
	else
		icon_state = "[initial(icon_state)]-o"
		layer = ABOVE_MOB_LAYER

/obj/structure/curtain/shower
	name = "浴帘"
	color = "#ACD1E9"
	alpha = 200

/obj/structure/curtain/black
	name = "黑色帘子"
	color = "#222222"

/obj/structure/curtain/medical
	name = "塑料帘子"
	color = "#B8F5E3"
	alpha = 200

/obj/structure/curtain/open/shower
	name = "浴帘"
	icon_state = "shower"
	alpha = 200

/obj/structure/curtain/open/black
	name = "黑色帘子"
	color = "#222222"

/obj/structure/curtain/open/medical
	name = "塑料帘子"
	color = "#B8F5E3"
	alpha = 200

/obj/structure/curtain/red
	name = "红色帘子"
	icon_state = "red"

/obj/structure/curtain/red/clean
	icon_state = "red_clean"


/obj/structure/curtain/blue
	name = "蓝色帘子"
	icon_state = "blue_clean"
