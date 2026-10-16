//WALL MOUNTED ~LOCKER~ STORAGE USED TO STORE SPECIFIC ITEMS IN IT
//changed from locker to structure with storage to stop
//littering up floor with opened locker and ramming objects

/obj/structure/vehicle_locker
	name = "壁挂储物柜"
	desc = "供车组成员存放私人物品或武器弹药的小型储物柜。仅限车组成员使用。"
	icon = 'icons/obj/vehicles/interiors/general.dmi'
	icon_state = "locker"
	anchored = TRUE
	density = FALSE
	layer = 3.2

	unacidable = TRUE
	unslashable = TRUE
	indestructible = TRUE

	var/obj/item/storage/internal/container
	var/base_icon

/obj/structure/vehicle_locker/Initialize()
	. = ..()
	base_icon = icon_state
	container = new(src)
	container.storage_slots = null
	container.max_w_class = SIZE_MEDIUM
	container.w_class = SIZE_MASSIVE
	container.max_storage_space = 40
	container.use_sound = null
	container.bypass_w_limit = list(/obj/item/weapon/gun,
									/obj/item/storage/backpack/general_belt,
									/obj/item/storage/large_holster/machete,
									/obj/item/storage/belt,
									/obj/item/storage/pouch,
									/obj/item/device/motiondetector,
									/obj/item/ammo_magazine/hardpoint,
									/obj/item/tool/weldpack,
									/obj/item/ammo_box,
									/obj/item/storage/box,
									/obj/item/storage/toolbox
									)
	flags_atom |= USES_HEARING

/obj/structure/vehicle_locker/verb/empty_storage()
	set name = "清空"
	set category = "物品"
	set src in range(0)

	var/mob/living/carbon/human/H = usr
	if (!ishuman(H) || H.is_mob_restrained())
		return

	empty(get_turf(H), H)

//regular storage's empty() proc doesn't work due to checks, so imitate it
/obj/structure/vehicle_locker/proc/empty(turf/T, mob/living/carbon/human/H)
	if(!container)
		to_chat(H, SPAN_WARNING("未找到内部储物空间。"))
		return

	H.visible_message(SPAN_NOTICE("[H]开始清空[src]……"), SPAN_NOTICE("你开始清空[src]……"))
	if(!do_after(H, 2 SECONDS, INTERRUPT_ALL, BUSY_ICON_GENERIC))
		H.visible_message(SPAN_WARNING("[H]停止清空[src]……"), SPAN_WARNING("你停止清空[src]……"))
		return

	for(var/mob/M in container.content_watchers)
		container.storage_close(M)
	for (var/obj/item/I in container.contents)
		container.remove_from_storage(I, T)
	H.visible_message(SPAN_NOTICE("[H]清空了[src]。"), SPAN_NOTICE("你清空了[src]。"))

	container.empty(H, get_turf(H))

/obj/structure/vehicle_locker/clicked(mob/living/carbon/human/user, list/mods)
	..()
	if(!CAN_PICKUP(user, src))
		return ..()

	if(user.get_active_hand())
		return ..()

	if(Adjacent(user))
		container.open(user)
		return TRUE

//due to how /internal coded, this doesn't work, so we used workaround above
/obj/structure/vehicle_locker/attack_hand(mob/user)
	return

/obj/structure/vehicle_locker/MouseDrop(obj/over_object)
	var/mob/living/carbon/human/user = usr
	if(!istype(user))
		return
	if(user.is_mob_incapacitated())
		return
	if (container.handle_mousedrop(user, over_object))
		..(over_object)

/obj/structure/vehicle_locker/attackby(obj/item/W, mob/living/carbon/human/user)
	if(!Adjacent(user))
		return
	if(user.is_mob_incapacitated())
		return
	if(!istype(user))
		return
	return container.attackby(W, user)

/obj/structure/vehicle_locker/emp_act(severity)
	. = ..()
	container.emp_act(severity)

/obj/structure/vehicle_locker/hear_talk(mob/M, msg)
	container.hear_talk(M, msg)
	..()

//Cosmetically opens/closes the locker when its storage window is accessed or closed. Only makes sound when not already open/closed.
/obj/structure/vehicle_locker/on_pocket_open(first_open)
	if(first_open)
		icon_state = "[initial(icon_state)]_open"
		playsound(src.loc, 'sound/handling/hinge_squeak1.ogg', 25, TRUE, 3)

/obj/structure/vehicle_locker/on_pocket_close(watchers)
	if(!watchers)
		icon_state = "[initial(icon_state)]"
		playsound(src.loc, "toolbox", 25, TRUE, 3)

/obj/structure/vehicle_locker/tank
	name = "储物柜"
	desc = "供车组成员存放私人物品或武器弹药的小型储物柜。仅限车组成员使用。"
	icon = 'icons/obj/vehicles/interiors/tank.dmi'
	icon_state = "locker"

/obj/structure/vehicle_locker/tank/upp
	icon = 'icons/obj/vehicles/interiors/upptank.dmi'
	icon_state = "locker"

/obj/structure/vehicle_locker/tank/upp1
	name = "弹药储存柜"
	icon = 'icons/obj/vehicles/interiors/upptank.dmi'
	icon_state = "storage_ammo"

/obj/structure/vehicle_locker/tank/upp2
	name = "储物柜"
	desc = "供车组成员存放私人物品的小型储物柜。仅限车组成员使用。"
	icon = 'icons/obj/vehicles/interiors/upptank.dmi'
	icon_state = "small_locker"

/obj/structure/vehicle_locker/tank/upp3
	icon = 'icons/obj/vehicles/interiors/upptank.dmi'
	icon_state = "small_locker1"

/obj/structure/vehicle_locker/movie
	name = "储物柜"
	desc = "宽敞的储物柜，可存放各种装备、武器和弹药，用途广泛。"
	icon = 'icons/obj/vehicles/interiors/movie.dmi'
	icon_state = "locker"

/obj/structure/vehicle_locker/med
	name = "壁挂手术器械柜"
	desc = "安全存放一整套手术器械的小型柜子，身份识别锁仅允许外科医生开启。"
	icon_state = "locker_med"

	var/has_tray = TRUE

/obj/structure/vehicle_locker/uppvan
	name = "弹药储存柜"
	icon = 'icons/obj/vehicles/interiors/uppvan.dmi'
	icon_state = "small_storage"

/obj/structure/vehicle_locker/med/on_pocket_open(first_open)
	if(first_open)
		playsound(src.loc, 'sound/handling/hinge_squeak1.ogg', 25, TRUE, 3)

/obj/structure/vehicle_locker/med/on_pocket_close(watchers)
	if(!watchers)
		playsound(src.loc, "toolbox", 25, TRUE, 3)

/obj/structure/vehicle_locker/med/update_icon()
	if(has_tray)
		icon_state = initial(icon_state)
	else
		icon_state = "locker_open"

/obj/structure/vehicle_locker/med/Initialize()
	. = ..()
	container.max_storage_space = 24
	container.can_hold = list(
							/obj/item/tool/surgery,
							/obj/item/stack/medical/advanced/bruise_pack,
							/obj/item/stack/nanopaste
							)

	new /obj/item/tool/surgery/scalpel/pict_system(container)
	new /obj/item/tool/surgery/scalpel(container)
	new /obj/item/tool/surgery/hemostat(container)
	new /obj/item/tool/surgery/retractor(container)
	new /obj/item/stack/medical/advanced/bruise_pack(container)
	new /obj/item/tool/surgery/cautery(container)
	new /obj/item/tool/surgery/circular_saw(container)
	new /obj/item/tool/surgery/surgicaldrill(container)
	new /obj/item/tool/surgery/bonegel(container)
	new /obj/item/tool/surgery/bonesetter(container)
	new /obj/item/tool/surgery/FixOVein(container)
	new /obj/item/tool/surgery/surgical_line(container)
	new /obj/item/stack/nanopaste(container)

/obj/structure/vehicle_locker/med/get_examine_text(mob/user)
	. = ..()
	. += has_tray ? SPAN_HELPFUL("右键点击可从柜子中取出手术托盘。") : SPAN_WARNING("手术托盘已被取出。")

/obj/structure/vehicle_locker/med/attackby(obj/item/W, mob/living/carbon/human/user)
	if(!Adjacent(user))
		return
	if(user.is_mob_incapacitated())
		return
	if(!istype(user))
		return
	if(istype(W, /obj/item/storage/surgical_tray))
		add_tray(user, W)
		return
	if(!has_tray)
		to_chat(user, SPAN_WARNING("[name]中没有安装手术托盘！"))
		return
	return container.attackby(W, user)

/obj/structure/vehicle_locker/med/clicked(mob/living/carbon/human/user, list/mods)
	if(!CAN_PICKUP(user, src))
		return ..()

	if(user.get_active_hand())
		return ..()

	if(!has_tray)
		to_chat(user, SPAN_WARNING("[name]中没有安装手术托盘！"))
		return TRUE

	if(Adjacent(user))
		container.open(user)
		return TRUE

/obj/structure/vehicle_locker/med/MouseDrop(obj/over_object)
	var/mob/living/carbon/human/user = usr
	if(!istype(user))
		return
	if(user.is_mob_incapacitated())
		return
	if(!has_tray)
		to_chat(user, SPAN_WARNING("[name]中没有安装手术托盘！"))
		return
	if (container.handle_mousedrop(user, over_object))
		..(over_object)


/obj/structure/vehicle_locker/med/verb/remove_surgical_tray()
	set name = "取出手术托盘"
	set category = "物品"
	set src in oview(1)

	if(!ishuman(usr))
		return

	var/mob/living/carbon/human/H = usr

	if(H.is_mob_incapacitated())
		return

	remove_tray(H)

/obj/structure/vehicle_locker/med/proc/remove_tray(mob/living/carbon/human/H)
	if(!has_tray)
		to_chat(H, SPAN_WARNING("手术托盘已经被取出了！"))
		return

	H.visible_message(SPAN_NOTICE("[H]开始从[src]中取出手术托盘。"), SPAN_NOTICE("你开始从[src]中取出手术托盘。"))
	if(!do_after(H, 2 SECONDS, INTERRUPT_NO_NEEDHAND, BUSY_ICON_GENERIC))
		H.visible_message(SPAN_NOTICE("[H]停止从[src]中取出手术托盘。"), SPAN_WARNING("你停止从[src]中取出手术托盘。"))
		return

	var/obj/item/storage/surgical_tray/empty/tray = new(loc)
	var/turf/T = get_turf(src)
	for(var/obj/item/O in container.contents)
		container.remove_from_storage(O, T)
		tray.handle_item_insertion(O, TRUE)

	has_tray = FALSE
	update_icon()
	H.put_in_hands(tray)
	container.storage_close(H)
	H.visible_message(SPAN_NOTICE("[H]从[src]中取出了手术托盘。"), SPAN_NOTICE("你从[src]中取出了手术托盘。"))

/obj/structure/vehicle_locker/med/proc/add_tray(mob/living/carbon/human/H, obj/item/storage/surgical_tray/tray)
	if(has_tray)
		to_chat(H, SPAN_WARNING("[src]中已经装有手术托盘！"))
		return

	H.visible_message(SPAN_NOTICE("[H]开始将[tray]装入[src]。"), SPAN_NOTICE("你开始将[tray]装入[src]。"))
	if(!do_after(H, 2 SECONDS, INTERRUPT_NO_NEEDHAND, BUSY_ICON_GENERIC))
		H.visible_message(SPAN_NOTICE("[H]停止将[tray]装入[src]。"), SPAN_WARNING("你停止将[tray]装入[src]。"))
		return

	var/turf/T = get_turf(src)
	for(var/obj/item/O in tray.contents)
		tray.remove_from_storage(O, T)
		container.handle_item_insertion(O, TRUE)
	H.drop_held_item(tray)
	qdel(tray)
	has_tray = TRUE
	update_icon()
	H.visible_message(SPAN_NOTICE("[H]将[tray]装入了[src]。"), SPAN_NOTICE("你将[tray]装入了[src]。"))

// canteen

/obj/structure/vehicle_locker/cabinet
	name = "柜子"
	desc = "牢牢固定在墙上的柜子，可以存放各种小件物品。"
	icon = 'icons/obj/structures/props/almayer_props.dmi'
	icon_state = "cabinet"
	layer = ABOVE_MOB_LAYER

/obj/structure/vehicle_locker/cabinet/Initialize()
	. = ..()
	container = new(src)
	container.storage_slots = 12
	container.max_w_class = SIZE_TINY
	container.w_class = SIZE_MASSIVE
	container.use_sound = null
	container.bypass_w_limit = list(
		/obj/item/reagent_container/glass,
		/obj/item/reagent_container/food,
		/obj/item/tool/kitchen,
	)

/obj/structure/vehicle_locker/cabinet/cups
	name = "杯具柜"

/obj/structure/vehicle_locker/cabinet/cups/Initialize()
	. = ..()
	for(var/i in 1 to 12)
		new /obj/item/reagent_container/food/drinks/plasticcup(container)

/obj/structure/vehicle_locker/cabinet/cups/flip
	icon_state = "cabinet2"

/obj/structure/vehicle_locker/cabinet/utensils
	name = "餐具柜"

/obj/structure/vehicle_locker/cabinet/utensils/Initialize()
	. = ..()
	for(var/i in 1 to 12)
		new /obj/item/tool/kitchen/utensil/fork(container)

/obj/structure/vehicle_locker/cabinet/utensils/flip
	icon_state = "cabinet2"
