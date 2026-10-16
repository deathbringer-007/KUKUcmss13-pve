

//old style retardo-cart
/obj/structure/bed/chair/janicart
	name = "清洁车"
	icon = 'icons/obj/vehicles/vehicles.dmi'
	icon_state = "pussywagon"
	anchored = FALSE
	density = TRUE
	flags_atom = OPENCONTAINER
	buildstacktype = null //can't be disassembled and doesn't drop anything when destroyed
	//copypaste sorry
	picked_up_item = null
	var/amount_per_transfer_from_this = 5 //shit I dunno, adding this so syringes stop runtime erroring. --NeoFite
	var/obj/item/storage/bag/trash/mybag = null
	var/callme = "拉风座驾" //how do people refer to it?
	var/move_delay = 2

/obj/structure/bed/chair/janicart/Initialize()
	. = ..()
	handle_rotation()
	create_reagents(100)


/obj/structure/bed/chair/janicart/get_examine_text(mob/user)
	. = list()
	. += "[icon2html(src, usr)] 这辆[callme]装有[reagents.total_volume]单位的水！"
	if(mybag)
		. += "[mybag]挂在[callme]上。"


/obj/structure/bed/chair/janicart/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/tool/mop))
		var/obj/item/tool/mop/mop = I
		if(reagents.total_volume > 1)
			reagents.trans_to(mop, mop.max_reagent_volume)
			mop.update_icon()
			to_chat(user, SPAN_NOTICE("你在[callme]里浸湿了[I]。"))
			playsound(loc, 'sound/effects/slosh.ogg', 25, 1)
		else
			to_chat(user, SPAN_NOTICE("这辆[callme]没水了！"))
	else if(istype(I, /obj/item/key))
		to_chat(user, "驾驶这辆[callme]时，一只手必须拿着[I]。")
	else if(istype(I, /obj/item/storage/bag/trash))
		to_chat(user, SPAN_NOTICE("你把垃圾袋挂在[callme]上。"))
		user.drop_held_item()
		I.forceMove(src)
		mybag = I
	else
		. = ..()


/obj/structure/bed/chair/janicart/attack_hand(mob/user)
	if(mybag)
		mybag.forceMove(get_turf(user))
		user.put_in_hands(mybag)
		mybag = null
	else
		..()


/obj/structure/bed/chair/janicart/relaymove(mob/user, direction)
	if(world.time <= l_move_time + move_delay)
		return
	if(user.is_mob_incapacitated(TRUE))
		unbuckle()
	if(istype(user.l_hand, /obj/item/key) || istype(user.r_hand, /obj/item/key))
		step(src, direction)
	else
		to_chat(user, SPAN_NOTICE("你需要一只手拿着钥匙，才能驾驶这辆[callme]。"))


/obj/structure/bed/chair/janicart/send_buckling_message(mob/M, mob/user)
	M.visible_message(\
		SPAN_NOTICE("[M]爬上了[callme]！"),\
		SPAN_NOTICE("你爬上了[callme]！"))


/obj/structure/bed/chair/janicart/handle_rotation()
	if(dir == SOUTH)
		layer = FLY_LAYER
	else
		layer = OBJ_LAYER

	update_mob()


/obj/structure/bed/chair/janicart/proc/update_mob()
	if(buckled_mob)
		buckled_mob.setDir(dir)
		switch(dir)
			if(SOUTH)
				buckled_mob.pixel_x = 0
				buckled_mob.pixel_y = 7
			if(WEST)
				buckled_mob.pixel_x = 13
				buckled_mob.pixel_y = 7
			if(NORTH)
				buckled_mob.pixel_x = 0
				buckled_mob.pixel_y = 4
			if(EAST)
				buckled_mob.pixel_x = -13
				buckled_mob.pixel_y = 7


/obj/structure/bed/chair/janicart/bullet_act(obj/projectile/Proj)
	if(buckled_mob)
		if(prob(85))
			return buckled_mob.bullet_act(Proj)
	visible_message(SPAN_WARNING("[Proj]被[callme]弹开了！"))
	return 1

/obj/item/key
	name = "钥匙"
	desc = "钥匙环上挂着一把小钢钥匙和一个写着“泡妞战车”的粉红色钥匙牌。"
	icon = 'icons/obj/vehicles/vehicles.dmi'
	icon_state = "keys"
	w_class = SIZE_TINY
