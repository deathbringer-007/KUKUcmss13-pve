
/obj/item/storage/box/m56_system
	name = "\improper M56智能机枪系统箱"
	desc = "大号装备箱，内装M56A2智能机枪、M56作战背带、头戴式瞄具和供能背包。\n将箱子的图标拖到自己身上即可打开！注意：物品取出后无法放回箱内。"
	icon = 'icons/obj/items/storage/kits.dmi'
	icon_state = "kit_case"
	w_class = SIZE_HUGE
	storage_slots = 7
	slowdown = 1
	can_hold = list() //Nada. Once you take the stuff out it doesn't fit back in.
	foldable = null

/obj/item/storage/box/m56_system/Initialize()
	. = ..()
	new /obj/item/clothing/suit/storage/marine/smartgunner(src)
	new /obj/item/weapon/gun/smartgun(src)
	new /obj/item/clothing/glasses/night/m56_goggles/no_nightvision(src)
	new /obj/item/smartgun_battery(src)
	for(var/i in 1 to 3)
		new /obj/item/ammo_magazine/smartgun(src)
	update_icon()

/obj/item/storage/box/m56_system/update_icon()
	LAZYCLEARLIST(overlays)
	if(length(contents))
		icon_state = "kit_case"
		overlays += image(icon, "smartgun")
	else
		icon_state = "kit_case_e"

/obj/item/storage/box/m56c_system
	name = "\improper M56C智能机枪系统箱"
	desc = "大号装备箱，内装M56C智能机枪、M56作战背带、头戴式瞄具、M280智能机枪弹鼓腰带和供能背包。\n将箱子的图标拖到自己身上即可打开！注意：物品取出后无法放回箱内。"
	icon = 'icons/obj/items/storage/kits.dmi'
	icon_state = "kit_case"
	w_class = SIZE_HUGE
	storage_slots = 5
	slowdown = 1
	can_hold = list() //Nada. Once you take the stuff out it doesn't fit back in.
	foldable = null

/obj/item/storage/box/m56c_system/Initialize()
	. = ..()
	new /obj/item/clothing/glasses/night/m56_goggles(src)
	new /obj/item/weapon/gun/smartgun/co(src)
	new /obj/item/smartgun_battery(src)
	new /obj/item/clothing/suit/storage/marine/smartgunner(src)
	new /obj/item/storage/belt/marine/smartgunner(src)
	update_icon()

/obj/item/storage/box/m56c_system/update_icon()
	LAZYCLEARLIST(overlays)
	if(length(contents))
		icon_state = "kit_case"
		overlays += image(icon, "smartgun")
	else
		icon_state = "kit_case_e"

/obj/item/storage/box/m56_dirty_system
	name = "\improper M56D“脏活”智能机枪系统箱"
	desc = "大号装备箱，内装M56D“脏活”智能机枪、M56D雇佣兵作战背带和头盔、头戴式瞄具、M280智能机枪弹鼓腰带和供能背包。\n将箱子的图标拖到自己身上即可打开！注意：物品取出后无法放回箱内。"
	icon = 'icons/obj/items/storage/kits.dmi'
	icon_state = "kit_case"
	w_class = SIZE_HUGE
	storage_slots = 6
	slowdown = 1
	can_hold = list() //Nada. Once you take the stuff out it doesn't fit back in.
	foldable = null

/obj/item/storage/box/m56_dirty_system/Initialize()
	. = ..()
	new /obj/item/clothing/glasses/night/m56_goggles(src)
	new /obj/item/weapon/gun/smartgun/dirty(src)
	new /obj/item/smartgun_battery(src)
	new /obj/item/clothing/suit/storage/marine/smartgunner/veteran/pmc(src)
	new /obj/item/clothing/head/helmet/marine/veteran/pmc/gunner(src)
	new /obj/item/storage/belt/gun/smartgunner/pmc/full(src)
	update_icon()

/obj/item/storage/box/m56_dirty_system/update_icon()
	LAZYCLEARLIST(overlays)
	if(length(contents))
		icon_state = "kit_case"
		overlays += image(icon, "smartgun")
	else
		icon_state = "kit_case_e"

/obj/item/storage/box/personalcase
	name = "个人武器箱"
	desc = "带指纹锁的安全箱，装着某人的贵重私人武器。"
	icon = 'icons/obj/items/storage/kits.dmi'
	icon_state = "personalcase"
	w_class = SIZE_HUGE
	storage_slots = 4
	slowdown = 1
	can_hold = list()
	foldable = FALSE
	var/owner
	var/locked = TRUE

/obj/item/storage/box/personalcase/update_icon()
	icon_state = "[initial(icon_state)][locked]"

/obj/item/storage/box/personalcase/attackby(obj/item/W as obj, mob/user)
	if(!locked)
		..()
	else
		to_chat(user, SPAN_DANGER("[src]锁着！"))

/obj/item/storage/box/personalcase/show_to(mob/user as mob)
	if(!locked)
		..()
	else if(user.real_name == owner)
		locked = FALSE
		to_chat(user, SPAN_NOTICE("你解锁了自己的个人武器箱。"))
		..()
	else
		to_chat(user, SPAN_DANGER("[src]锁着！"))

/obj/item/storage/box/personalcase/proc/assign_owner(new_owner)
	owner = new_owner
	name = "\improper [owner]的个人武器箱"
	desc = "带指纹锁的安全箱，装着[owner]的贵重私人武器。"
