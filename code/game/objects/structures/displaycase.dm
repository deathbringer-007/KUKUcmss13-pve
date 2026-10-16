/obj/structure/displaycase
	name = "展示柜"
	icon = 'icons/obj/structures/props/stationobjs.dmi'
	icon_state = "glassbox1"
	desc = "用来展示珍贵藏品的柜子，看着就让人想踢一脚。"
	density = TRUE
	anchored = TRUE
	unacidable = FALSE
	unslashable = TRUE
	health = 30
	var/occupied = 1
	var/destroyed = 0

/obj/structure/displaycase/ex_act(severity)
	switch(severity)
		if(0 to EXPLOSION_THRESHOLD_LOW)
			if (prob(50))
				src.health -= 5
				src.healthcheck()
		if(EXPLOSION_THRESHOLD_LOW to EXPLOSION_THRESHOLD_MEDIUM)
			if (prob(50))
				src.health -= 15
				src.healthcheck()
		if(EXPLOSION_THRESHOLD_MEDIUM to INFINITY)
			deconstruct(FALSE)

/obj/structure/displaycase/deconstruct(disassembled = TRUE)
	if(!disassembled)
		new /obj/item/shard(src.loc)
	if (occupied)
		occupied = 0
	return ..()

/obj/structure/displaycase/bullet_act(obj/projectile/Proj)
	health -= Proj.ammo.damage
	..()
	src.healthcheck()
	return 1

/obj/structure/displaycase/proc/healthcheck()
	if (src.health <= 0)
		if (!( src.destroyed ))
			src.density = FALSE
			src.destroyed = 1
			new /obj/item/shard( src.loc )
			playsound(src, "windowshatter", 25, 1)
			update_icon()
	else
		playsound(src.loc, 'sound/effects/Glasshit.ogg', 25, 1)
	return

/obj/structure/displaycase/update_icon()
	if(src.destroyed)
		src.icon_state = "glassboxb[src.occupied]"
	else
		src.icon_state = "glassbox[src.occupied]"
	return


/obj/structure/displaycase/attackby(obj/item/W as obj, mob/user as mob)
	src.health -= W.force * W.demolition_mod
	src.healthcheck()
	..()
	return

/obj/structure/displaycase/attack_hand(mob/user as mob)
	if (src.destroyed && src.occupied)
		to_chat(user, "\b 你关闭了展示柜内置的悬浮力场。")
		src.occupied = 0
		src.add_fingerprint(user)
		update_icon()
		return
	else
		to_chat(user, SPAN_NOTICE("你踢了展示柜一脚。"))
		for(var/mob/O in oviewers())
			if ((O.client && !( O.blinded )))
				to_chat(O, SPAN_DANGER("[user]踢了展示柜一脚。"))
		src.health -= 2
		healthcheck()
		return

//Quick destroyed case.
/obj/structure/displaycase/destroyed
	icon_state = "glassboxb0"
	unslashable = TRUE
	health = 0
	occupied = 0
	destroyed = 1
