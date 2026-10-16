/obj/structure/closet/crate/secure
	desc = "一个带锁的箱子。"
	name = "安全储物箱"
	icon_state = "secure_locked_basic"
	icon_opened = "secure_open_basic"
	icon_closed = "secure_locked_basic"
	crate_customizing_types = null
	var/icon_locked = "secure_locked_basic"
	var/icon_unlocked = "secure_unlocked_basic"
	var/sparks = "securecratesparks"
	var/emag = "securecrateemag"
	var/broken = 0
	var/locked = 1

/obj/structure/closet/crate/secure/Initialize()
	. = ..()
	update_icon()


/obj/structure/closet/crate/secure/update_icon()
	overlays.Cut()
	if(opened)
		icon_state = icon_opened
	else if(locked)
		icon_state = icon_locked
	else
		icon_state = icon_unlocked
	if(welded)
		overlays += "welded"


/obj/structure/closet/crate/secure/can_open()
	return !locked

/obj/structure/closet/crate/secure/proc/togglelock(mob/user as mob)
	if(src.opened)
		to_chat(user, SPAN_NOTICE("先把箱子关上。"))
		return
	if(src.broken)
		to_chat(user, SPAN_WARNING("箱子似乎坏了。"))
		return
	if(src.allowed(user))
		src.locked = !src.locked
		for(var/mob/O in viewers(user, 3))
			if((O.client && !( O.blinded )))
				to_chat(O, SPAN_NOTICE("[user]已将箱子[locked ? "锁定" : "解锁"]。"))
		icon_state = locked ? icon_locked : icon_unlocked
	else
		to_chat(user, SPAN_NOTICE("拒绝访问"))

/obj/structure/closet/crate/secure/verb/verb_togglelock()
	set src in oview(1) // One square distance
	set category = "Object"
	set name = "切换锁定"

	if(usr.is_mob_incapacitated()) // Don't use it if you're not able to! Checks for stuns, ghost and restrain
		return

	if(ishuman(usr))
		src.add_fingerprint(usr)
		src.togglelock(usr)
	else
		to_chat(usr, SPAN_WARNING("此类角色无法使用这个操作。"))

/obj/structure/closet/crate/secure/attack_hand(mob/user as mob)
	src.add_fingerprint(user)
	if(locked)
		src.togglelock(user)
	else
		src.toggle(user)

/obj/structure/closet/crate/secure/attackby(obj/item/W as obj, mob/user as mob)
	if(isxeno(user))
		var/mob/living/carbon/xenomorph/opener = user
		src.attack_alien(opener)
		return
	if(is_type_in_list(W, list(/obj/item/packageWrap, /obj/item/stack/cable_coil, /obj/item/device/radio/electropack, /obj/item/tool/wirecutters, /obj/item/tool/weldingtool)))
		return ..()
	if(!opened)
		src.togglelock(user)
		return
	return ..()

/obj/structure/closet/crate/secure/break_open()
	broken = TRUE
	locked = FALSE
	..()

/obj/structure/closet/crate/secure/emp_act(severity)
	. = ..()
	for(var/obj/O in src)
		O.emp_act(severity)
	if(!broken && !opened  && prob(50/severity))
		if(!locked)
			locked = 1
		else
			overlays.Cut()
			overlays += emag
			overlays += sparks
			spawn(6) overlays -= sparks //Tried lots of stuff but nothing works right. so i have to use this *sadface*
			playsound(src.loc, 'sound/effects/sparks4.ogg', 25, 1)
			locked = 0
		update_icon()
	if(!opened && prob(20/severity))
		if(!locked)
			open()
		else
			src.req_access = list()
			src.req_access += pick(get_access(ACCESS_LIST_MARINE_MAIN))


//------------------------------------
// Secure Crates
//------------------------------------

/obj/structure/closet/crate/secure/ammo
	name = "安全弹药箱"
	desc = "一个带锁的弹药箱。"
	icon_state = "secure_locked_ammo"
	icon_opened = "secure_open_ammo"
	icon_locked = "secure_locked_ammo"
	icon_unlocked = "secure_unlocked_ammo"

/obj/structure/closet/crate/secure/upp
	name = "安全储物箱"
	desc = "进步人民联盟联合武装力量所有的电子锁储物箱，正面的两颗大星星表明了它的归属。"
	icon_state = "secure_locked_uppcrate"
	icon_opened = "secure_open_uppcrate"
	icon_locked = "secure_locked_uppcrate"
	icon_unlocked = "secure_unlocked_uppcrate"

/obj/structure/closet/crate/secure/upp/alt

	icon_state = "secure_locked_uppcratealt"
	icon_opened = "secure_open_uppcratealt"
	icon_locked = "secure_locked_uppcratealt"
	icon_unlocked = "secure_unlocked_uppcratealt"

/obj/structure/closet/crate/secure/explosives
	name = "爆炸物箱"
	desc = "一个爆炸物箱。"
	icon_state = "secure_locked_explosives"
	icon_opened = "secure_open_explosives"
	icon_locked = "secure_locked_explosives"
	icon_unlocked = "secure_unlocked_explosives"

// Needs to be converted to new system that does not use overlays
// using default secure crate for now
/obj/structure/closet/crate/secure/phoron
	name = "弗燃素箱"
	desc = "一个带锁的弗燃素箱。"

// Needs to be converted to new system that does not use overlays
// using Wayland crate for now
/obj/structure/closet/crate/secure/gear
	name = "装备箱"
	desc = "一个带锁的装备箱。"
	icon_state = "secure_locked_ammo"
	icon_opened = "secure_open_ammo"
	icon_locked = "secure_locked_ammo"
	icon_unlocked = "secure_unlocked_ammo"

/obj/structure/closet/crate/secure/hydrosec
	name = "安全水培用品箱"
	desc = "带锁的箱子，涂装采用站内植物学家的配色。"
	icon_state = "secure_locked_hydro"
	icon_opened = "secure_open_hydro"
	icon_locked = "secure_locked_hydro"
	icon_unlocked = "secure_unlocked_hydro"

/obj/structure/closet/crate/secure/surgery
	name = "手术用品箱"
	desc = "一个手术用品箱。"
	icon_state = "secure_locked_surgery"
	icon_opened = "secure_open_surgery"
	icon_locked = "secure_locked_surgery"
	icon_unlocked = "secure_unlocked_surgery"

/obj/structure/closet/crate/secure/weapon
	name = "武器箱"
	desc = "一个带锁的武器箱。"
	icon_state = "secure_locked_weapons"
	icon_opened = "secure_open_weapons"
	icon_locked = "secure_locked_weapons"
	icon_unlocked = "secure_unlocked_weapons"

/obj/structure/closet/crate/secure/weyland
	name = "维兰德-汤谷安全储物箱"
	desc = "印有维兰德-汤谷标志的带锁箱子。"
	icon_state = "secure_locked_weyland"
	icon_opened = "secure_open_weyland"
	icon_locked = "secure_locked_weyland"
	icon_unlocked = "secure_unlocked_weyland"

/obj/structure/closet/crate/secure/vulture
	name = "M707安全储物箱"
	desc = "带锁的箱子，内装一支M707反器材步枪。"
	icon_state = "secure_locked_vulture"
	icon_opened = "secure_open_vulture"
	icon_locked = "secure_locked_vulture"
	icon_unlocked = "secure_unlocked_vulture"

/obj/structure/closet/crate/secure/vulture/Initialize()
	. = ..()
	new /obj/item/storage/box/guncase/vulture(src)

/obj/structure/closet/crate/secure/rmcnvg
	name = "皇家陆战突击队夜视面罩安全储物箱"
	desc = "带锁的箱子，内装多副可安装于Mk16战术头盔和Mk12精确射手头盔的面罩。"
	icon_state = "secure_locked_vulture"
	icon_opened = "secure_open_vulture"
	icon_locked = "secure_locked_vulture"
	icon_unlocked = "secure_unlocked_vulture"

/obj/structure/closet/crate/secure/rmcnvg/Initialize()
	. = ..()
	new /obj/item/device/helmet_visor/night_vision/marine_raider/rmc(src)
	new /obj/item/device/helmet_visor/night_vision/marine_raider/rmc(src)
	new /obj/item/device/helmet_visor/night_vision/marine_raider/rmc(src)
	new /obj/item/device/helmet_visor/night_vision/marine_raider/rmc(src)
	new /obj/item/device/helmet_visor/night_vision/marine_raider/rmc(src)
	new /obj/item/device/helmet_visor/night_vision/marine_raider/rmc(src)
	new /obj/item/device/helmet_visor/night_vision/marine_raider/rmc(src)
	new /obj/item/device/helmet_visor/night_vision/marine_raider/rmc(src)
	new /obj/item/device/helmet_visor/night_vision/marine_raider/rmc(src)
	new /obj/item/device/helmet_visor/night_vision/marine_raider/rmc(src)
	new /obj/item/device/helmet_visor/night_vision/marine_raider/rmc(src)
	new /obj/item/device/helmet_visor/night_vision/marine_raider/rmc(src)
	new /obj/item/device/helmet_visor/night_vision/marine_raider/rmc(src)
	new /obj/item/device/helmet_visor/night_vision/marine_raider/rmc(src)
	new /obj/item/device/helmet_visor/night_vision/marine_raider/rmc(src)

//special version, able to store OB fuel and warheads only
/obj/structure/closet/crate/secure/ob
	name = "轨道轰炸弹药安全储物箱"
	desc = "能储存轨道轰炸弹头和燃料的带锁箱子。"
	icon_state = "secure_locked_ob"
	icon_opened = "secure_open_ob"
	icon_locked = "secure_locked_ob"
	icon_unlocked = "secure_unlocked_ob"

/obj/structure/closet/crate/secure/ob/close()
	if(!opened)
		return FALSE
	if(!can_close())
		return FALSE

	playsound(src.loc, 'sound/machines/click.ogg', 15, 1)
	var/itemcount = 0
	for(var/obj/O in get_turf(src))
		if(itemcount >= storage_capacity)
			break
		//Only OB warheads and fuel gets in this boi
		if(!istype(O, /obj/structure/ob_ammo))
			continue
		O.forceMove(src)
		itemcount++

	opened = FALSE
	climbable = TRUE
	update_icon()
	return TRUE
