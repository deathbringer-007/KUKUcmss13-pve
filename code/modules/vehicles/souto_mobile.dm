/obj/vehicle/souto
	name = "\improper 索托座驾"
	icon_state = "soutomobile"
	desc = "离宇宙最佳座驾只差一点点，但终究还差那么一点。"
	move_delay = 3 //The speed of a fed but shoeless pajamarine, or a bit slower than a heavy-armor marine.
	buckling_y = 4
	layer = ABOVE_LYING_MOB_LAYER //Allows it to drive over people, but is below the driver.

/obj/vehicle/souto/Initialize()
	. = ..()
	var/image/I = new(icon = 'icons/obj/vehicles/vehicles.dmi', icon_state = "soutomobile_overlay", layer = ABOVE_MOB_LAYER) //over mobs
	overlays += I

/obj/vehicle/souto/manual_unbuckle(mob/user)
	if(buckled_mob && buckled_mob != user)
		if(do_after(user, 20, INTERRUPT_ALL, BUSY_ICON_GENERIC))
			..()
	else ..()

/obj/vehicle/souto/relaymove(mob/user, direction)
	if(user.is_mob_incapacitated()) return
	if(world.time > l_move_time + move_delay)
		. = step(src, direction)

/obj/vehicle/souto/super
	desc = "宇宙最佳座驾，专属于独一无二的索托侠！"
	health = 1000
	locked = FALSE
	unacidable = TRUE
	indestructible = TRUE

/obj/vehicle/souto/super/explode()
	for(var/mob/M as anything in viewers(7, src))
		M.show_message("不知为何，[src]仍像一罐崭新的经典索托那样光鲜亮丽。", SHOW_MESSAGE_VISIBLE)
	health = initial(health) //Souto Man never dies, and neither does his bike.

/obj/vehicle/souto/super/buckle_mob(mob/M, mob/user)
	if(!locked) //Vehicle is unlocked until first being mounted, since the Soutomobile is faction-locked and otherwise Souto Man cannot automatically buckle in on spawn as his equipment is spawned before his ID.
		locked = TRUE
	else if(M == user && M.faction != FACTION_SOUTO && locked == TRUE) //Are you a cool enough dude to drive this bike? Nah, nobody's THAT cool.
		to_chat(user, SPAN_WARNING("当你握住车把时，[src]竟然像是在瞪你。你退了回去。哥们，谁也没说要骑闹鬼的摩托车啊。"))
		return
	..()
