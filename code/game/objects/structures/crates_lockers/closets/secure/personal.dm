/obj/structure/closet/secure_closet/personal
	desc = "供人员使用的上锁储物柜，第一张刷过的卡将取得控制权。"
	name = "个人储物柜"
	req_access = list(ACCESS_CIVILIAN_PUBLIC)
	var/registered_name = null

/obj/structure/closet/secure_closet/personal/patient
	name = "病人储物柜"

/obj/structure/closet/secure_closet/personal/patient/Initialize()
	. = ..()
	contents = list()
	new /obj/item/clothing/under/color/white( src )
	new /obj/item/clothing/shoes/white( src )



/obj/structure/closet/secure_closet/personal/cabinet
	icon_state = "cabinetdetective_locked"
	icon_closed = "cabinetdetective"
	icon_locked = "cabinetdetective_locked"
	icon_opened = "cabinetdetective_open"
	icon_broken = "cabinetdetective_broken"
	icon_off = "cabinetdetective_broken"

/obj/structure/closet/secure_closet/personal/cabinet/update_icon()
	if(broken)
		icon_state = icon_broken
	else
		if(!opened)
			if(locked)
				icon_state = icon_locked
			else
				icon_state = icon_closed
		else
			icon_state = icon_opened

/obj/structure/closet/secure_closet/personal/attackby(obj/item/W as obj, mob/user as mob)
	if (src.opened)
		return ..()
	if(istype(W, /obj/item/card/id))
		if(src.broken)
			to_chat(user, SPAN_DANGER("它似乎坏了。"))
			return
		var/obj/item/card/id/I = W
		if(!I || !I.registered_name) return
		if(src.allowed(user) || !src.registered_name || (istype(I) && (src.registered_name == I.registered_name)))
			//they can open all lockers, or nobody owns this, or they own this locker
			src.locked = !( src.locked )
			if(src.locked) src.icon_state = src.icon_locked
			else src.icon_state = src.icon_closed

			if(!src.registered_name)
				src.registered_name = I.registered_name
				src.desc = "归[I.registered_name]所有。"
		else
			to_chat(user, SPAN_DANGER("拒绝访问"))
	else
		to_chat(user, SPAN_DANGER("拒绝访问"))
	return

/obj/structure/closet/secure_closet/personal/verb/reset()
	set src in oview(1) // One square distance
	set category = "物品"
	set name = "重置锁具"
	if(usr.is_mob_incapacitated()) // Don't use it if you're not able to! Checks for stuns, ghost and restrain
		return
	if(ishuman(usr))
		src.add_fingerprint(usr)
		if (src.locked || !src.registered_name)
			to_chat(usr, SPAN_DANGER("你需要先解锁它。"))
		else if (src.broken)
			to_chat(usr, SPAN_DANGER("它似乎坏了。"))
		else
			if (src.opened)
				if(!src.close())
					return
			src.locked = 1
			src.icon_state = src.icon_locked
			src.registered_name = null
			src.desc = "供人员使用的上锁储物柜，第一张刷过的卡将取得控制权。"
	return
