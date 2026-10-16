//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:32

/obj/item/storage/lockbox
	name = "锁箱"
	desc = "一个上锁的盒子。"
	icon = 'icons/obj/items/storage/briefcases.dmi'
	icon_state = "lockbox+l"
	item_state = "syringe_kit"
	w_class = SIZE_LARGE
	max_w_class = SIZE_MEDIUM
	max_storage_space = 14 //The sum of the w_classes of all the items in this storage item.
	storage_slots = 4
	req_access = list(ACCESS_MARINE_SENIOR)
	var/locked = 1
	var/broken = 0
	var/icon_locked = "lockbox+l"
	var/icon_closed = "lockbox"
	var/icon_broken = "lockbox+b"


/obj/item/storage/lockbox/attackby(obj/item/W as obj, mob/user as mob)
	if (istype(W, /obj/item/card/id))
		if(src.broken)
			to_chat(user, SPAN_DANGER("它似乎坏了。"))
			return
		if(src.allowed(user))
			src.locked = !( src.locked )
			if(src.locked)
				src.icon_state = src.icon_locked
				to_chat(user, SPAN_DANGER("你锁上了[src.name]！"))
				return
			else
				src.icon_state = src.icon_closed
				to_chat(user, SPAN_DANGER("你解锁了[src.name]！"))
				return
		else
			to_chat(user, SPAN_DANGER("权限不足"))
	if(!locked)
		..()
	else
		to_chat(user, SPAN_DANGER("它锁着！"))
	return


/obj/item/storage/lockbox/show_to(mob/user as mob)
	if(locked)
		to_chat(user, SPAN_DANGER("它锁着！"))
	else
		..()
	return


/obj/item/storage/lockbox/loyalty
	name = "维兰德-汤谷装备锁箱"
	req_access = null
	req_one_access = list(ACCESS_WY_EXEC, ACCESS_WY_SECURITY)

/obj/item/storage/lockbox/loyalty/fill_preset_inventory()
	new /obj/item/ammo_magazine/pistol/es4(src)
	new /obj/item/ammo_magazine/pistol/es4(src)
	new /obj/item/ammo_magazine/pistol/es4(src)

/obj/item/storage/lockbox/cluster
	name = "集束闪光弹锁箱"
	desc = "你对打开它有种不祥的预感。"
	req_access = list(ACCESS_MARINE_BRIG)

/obj/item/storage/lockbox/clusterbang/fill_preset_inventory()
	new /obj/item/explosive/grenade/flashbang/cluster(src)
