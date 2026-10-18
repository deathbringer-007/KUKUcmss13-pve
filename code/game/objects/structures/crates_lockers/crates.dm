//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:32

/obj/structure/closet/crate
	name = "箱子"
	desc = "一个长方形钢箱。"
	icon = 'icons/obj/structures/crates.dmi'
	icon_state = "closed_basic"
	icon_opened = "open_basic"
	icon_closed = "closed_basic"
	climbable = 1
	anchored = FALSE
	throwpass = 1 //prevents moving crates by hurling things at them
	store_mobs = FALSE
	var/rigged = 0
	/// Types this crate can be made into
	var/list/crate_customizing_types = list(
		"Plain" = /obj/structure/closet/crate,
		"Plain (Green)" = /obj/structure/closet/crate/green,
		"Weapons" = /obj/structure/closet/crate/weapon,
		"Supply" = /obj/structure/closet/crate/supply,
		"Ammo" = /obj/structure/closet/crate/ammo,
		"Ammo (Black)" = /obj/structure/closet/crate/ammo/alt,
		"Ammo (Flame)" = /obj/structure/closet/crate/ammo/alt/flame,
		"Construction" = /obj/structure/closet/crate/construction,
		"Science" = /obj/structure/closet/crate/science,
		"Hydroponics" = /obj/structure/closet/crate/hydroponics,
		"Medical" = /obj/structure/closet/crate/medical,
		"Internals" = /obj/structure/closet/crate/internals,
		"Explosives" = /obj/structure/closet/crate/explosives,
		"Alpha" = /obj/structure/closet/crate/alpha,
		"Bravo" = /obj/structure/closet/crate/bravo,
		"Charlie" = /obj/structure/closet/crate/charlie,
		"Delta" = /obj/structure/closet/crate/delta,
	)

/obj/structure/closet/crate/initialize_pass_flags(datum/pass_flags_container/PF)
	..()
	if (PF)
		PF.flags_can_pass_all = PASS_OVER|PASS_AROUND

/obj/structure/closet/crate/can_open()
	return 1

/obj/structure/closet/crate/can_close()
	for(var/mob/living/L in get_turf(src)) //Can't close if someone is standing inside it. This is to prevent "crate traps" (let someone step in, close, open for 30 damage)
		return 0
	return 1

/obj/structure/closet/crate/BlockedPassDirs(atom/movable/mover, target_dir)
	for(var/obj/structure/S in get_turf(mover))
		if(S && S.climbable && !(S.flags_atom & ON_BORDER) && climbable && isliving(mover)) //Climbable non-border objects allow you to universally climb over others
			return NO_BLOCKED_MOVEMENT
	if(opened) //Open crate, you can cross over it
		return NO_BLOCKED_MOVEMENT

	return ..()

/obj/structure/closet/crate/open()
	if(opened)
		return 0
	if(!can_open())
		return 0

	if(rigged && locate(/obj/item/device/radio/electropack) in src)
		if(isliving(usr))
			var/mob/living/L = usr
			if(L.electrocute_act(17, src))
				var/datum/effect_system/spark_spread/s = new /datum/effect_system/spark_spread
				s.set_up(5, 1, src)
				s.start()
				return 2

	playsound(src.loc, 'sound/machines/click.ogg', 15, 1)
	for(var/obj/O in src)
		O.forceMove(get_turf(src))
	opened = 1
	update_icon()
	if(climbable)
		structure_shaken()
		climbable = 0 //Open crate is not a surface that works when climbing around
	return 1

/obj/structure/closet/crate/close()
	if(!opened)
		return 0
	if(!can_close())
		return 0

	playsound(src.loc, 'sound/machines/click.ogg', 15, 1)
	var/itemcount = 0
	for(var/obj/O in get_turf(src))
		if(itemcount >= storage_capacity)
			break
		if(O.density || O.anchored || istype(O, /obj/structure/closet) || istype(O, /obj/effect))
			continue
		if(istype(O, /obj/structure/bed)) //This is only necessary because of rollerbeds and swivel chairs.
			var/obj/structure/bed/B = O
			if(B.buckled_mob)
				continue
		if(istype(O, /obj/item/handset))
			continue
		O.forceMove(src)
		itemcount++

	opened = 0
	climbable = 1
	update_icon()
	return 1

/obj/structure/closet/crate/attackby(obj/item/W as obj, mob/user as mob)
	if(W.flags_item & ITEM_ABSTRACT) return
	if(opened)
		user.drop_inv_item_to_loc(W, loc)
	else if(istype(W, /obj/item/packageWrap) || istype(W, /obj/item/stack/fulton))
		return
	else if(istype(W, /obj/item/stack/cable_coil))
		var/obj/item/stack/cable_coil/C = W
		if(rigged)
			to_chat(user, SPAN_NOTICE("[src]已经被改装过了！"))
			return
		if (C.use(1))
			to_chat(user, SPAN_NOTICE("你改装了[src]。"))
			rigged = 1
			return
	else if(istype(W, /obj/item/device/radio/electropack))
		if(rigged)
			to_chat(user, SPAN_NOTICE("你将[W]装在了[src]上。"))
			user.drop_held_item()
			W.forceMove(src)
			return
	else if(HAS_TRAIT(W, TRAIT_TOOL_WIRECUTTERS))
		if(rigged)
			to_chat(user, SPAN_NOTICE("你剪掉了电线。"))
			playsound(loc, 'sound/items/Wirecutter.ogg', 25, 1)
			rigged = 0
			return
	else return attack_hand(user)

/obj/structure/closet/crate/ex_act(severity)
	switch(severity)
		if(0 to EXPLOSION_THRESHOLD_LOW)
			if(prob(50))
				deconstruct(FALSE)
			return
		if(EXPLOSION_THRESHOLD_LOW to EXPLOSION_THRESHOLD_MEDIUM)
			contents_explosion(severity)
			deconstruct(FALSE)
			return
		if(EXPLOSION_THRESHOLD_MEDIUM to INFINITY)
			contents_explosion(severity)
			deconstruct(FALSE)
			return

/obj/structure/closet/crate/alpha
	name = "阿尔法小队箱"
	desc = "印有阿尔法小队标志的箱子。"
	icon_state = "closed_alpha"
	icon_opened = "open_alpha"
	icon_closed = "closed_alpha"

/obj/structure/closet/crate/ammo
	name = "弹药箱"
	desc = "一个弹药箱。"
	icon_state = "closed_ammo"
	icon_opened = "open_ammo"
	icon_closed = "closed_ammo"

/obj/structure/closet/crate/ammo/alt
	name = "弹药箱"
	desc = "一个装弹药的箱子，外壳是黑色的。"
	icon_state = "closed_ammo_alt"
	icon_opened = "open_ammo_alt"
	icon_closed = "closed_ammo_alt"

/obj/structure/closet/crate/ammo/alt/flame
	name = "弹药箱"
	desc = "一个黑色箱子。警告：内装易燃物！"
	icon_state = "closed_ammo_alt2"
	icon_opened = "open_ammo_alt"//does not have its own unique icon
	icon_closed = "closed_ammo_alt2"

/obj/structure/closet/crate/green
	name = "绿色箱子"
	desc = "美国殖民地海军陆战队使用的标准绿色储物箱。十分常见，里面可能装着任何东西。"
	icon_state = "closed_green"
	icon_opened = "open_green"
	icon_closed = "closed_green"

/obj/structure/closet/crate/bravo
	name = "布拉沃小队箱"
	desc = "印有布拉沃小队标志的箱子。"
	icon_state = "closed_bravo"
	icon_opened = "open_bravo"
	icon_closed = "closed_bravo"

/obj/structure/closet/crate/charlie
	name = "查理小队箱"
	desc = "印有查理小队标志的箱子。"
	icon_state = "closed_charlie"
	icon_opened = "open_charlie"
	icon_closed = "closed_charlie"

/obj/structure/closet/crate/construction
	name = "建筑材料箱"
	desc = "一个建筑材料箱。"
	icon_state = "closed_construction"
	icon_opened = "open_construction"
	icon_closed = "closed_construction"

/obj/structure/closet/crate/delta
	name = "德尔塔小队箱"
	desc = "印有德尔塔小队标志的箱子。"
	icon_state = "closed_delta"
	icon_opened = "open_delta"
	icon_closed = "closed_delta"

/obj/structure/closet/crate/explosives
	name = "炸药箱"
	desc = "一个炸药箱。"
	icon_state = "closed_explosives"
	icon_opened = "open_explosives"
	icon_closed = "closed_explosives"

/obj/structure/closet/crate/freezer
	name = "冷藏箱"
	desc = "一个冷藏箱。"
	icon_state = "closed_freezer"
	icon_opened = "open_freezer"
	icon_closed = "closed_freezer"
	crate_customizing_types = null
	var/target_temp = T0C - 40
	var/cooling_power = 40

/obj/structure/closet/crate/freezer/cooler
	icon = 'icons/obj/structures/souto_land.dmi'
	desc = "适合存放啤酒和其他饮料的便携冷藏箱。"
	icon_state = "cooler_closed"
	icon_opened = "cooler_open"
	icon_closed = "cooler_closed"
	cooling_power = 10//not nearly as good as the actual freezer crate

/obj/structure/closet/crate/freezer/cooler/oj
	icon_state = "cooler-oj_closed"
	icon_opened = "cooler-oj_open"
	icon_closed = "cooler-oj_closed"


/obj/structure/closet/crate/hydroponics
	name = "水培用品箱"
	desc = "装有清除烦人杂草和害虫所需的用品。"
	icon_state = "closed_hydro"
	icon_opened = "open_hydro"
	icon_closed = "closed_hydro"

/obj/structure/closet/crate/hydroponics/prespawned
	//This exists so the prespawned hydro crates spawn with their contents.

/obj/structure/closet/crate/hydroponics/prespawned/Initialize()
	. = ..()
	new /obj/item/reagent_container/spray/plantbgone(src)
	new /obj/item/reagent_container/spray/plantbgone(src)
	new /obj/item/tool/minihoe(src)

/obj/structure/closet/crate/internals
	name = "供氧设备箱"
	desc = "一个供氧设备箱。"
	icon_state = "closed_oxygen"
	icon_opened = "open_oxygen"
	icon_closed = "closed_oxygen"

/obj/structure/closet/crate/medical
	name = "医疗用品箱"
	desc = "一个医疗用品箱。"
	icon_state = "closed_medical"
	icon_opened = "open_medical"
	icon_closed = "closed_medical"

/obj/structure/closet/crate/plastic
	name = "塑料箱"
	desc = "一个长方形塑料箱。"
	icon_state = "closed_plastic"
	icon_opened = "open_plastic"
	icon_closed = "closed_plastic"

/obj/structure/closet/crate/rcd
	name = "快速建造器箱"
	desc = "用于存放快速建造器的箱子。"

/obj/structure/closet/crate/freezer/rations //Fpr use in the escape shuttle
	desc = "一箱应急口粮。"
	name = "应急口粮"

/obj/structure/closet/crate/freezer/rations/Initialize()
	. = ..()
	new /obj/item/storage/box/donkpockets(src)
	new /obj/item/storage/box/donkpockets(src)

/obj/structure/closet/crate/radiation
	name = "防辐射装备箱"
	desc = "印有辐射警告标志的箱子。"
	icon_state = "closed_radioactive"
	icon_opened = "open_radioactive"
	icon_closed = "closed_radioactive"

/obj/structure/closet/crate/radiation/Initialize()
	. = ..()
	new /obj/item/clothing/suit/radiation(src)
	new /obj/item/clothing/head/radiation(src)
	new /obj/item/clothing/suit/radiation(src)
	new /obj/item/clothing/head/radiation(src)
	new /obj/item/clothing/suit/radiation(src)
	new /obj/item/clothing/head/radiation(src)
	new /obj/item/clothing/suit/radiation(src)
	new /obj/item/clothing/head/radiation(src)

/obj/structure/closet/crate/science
	name = "科研用品箱"
	desc = "一个科研用品箱。"
	icon_state = "closed_science"
	icon_opened = "open_science"
	icon_closed = "closed_science"

/obj/structure/closet/crate/supply
	name = "补给箱"
	desc = "一个补给箱。"
	icon_state = "closed_supply"
	icon_opened = "open_supply"
	icon_closed = "closed_supply"

/obj/structure/closet/crate/trashcart
	name = "垃圾推车"
	desc = "一辆带轮子的沉重金属垃圾车。"
	icon_state = "closed_trashcart"
	icon_opened = "open_trashcart"
	icon_closed = "closed_trashcart"

/obj/structure/closet/crate/weapon
	name = "武器箱"
	desc = "一个武器箱。"
	icon_state = "closed_weapons"
	icon_opened = "open_weapons"
	icon_closed = "closed_weapons"
	var/obj/item/weapon_type
	var/obj/item/ammo_type
	var/ammo_count = 5

/obj/structure/closet/crate/weapon/Initialize()
	. = ..()
	if(ammo_type)
		for(var/t=0,t<ammo_count,t++)
			new ammo_type(src)
	if(weapon_type)
		new weapon_type(src)

/obj/structure/closet/crate/empexplosives
	name = "电磁脉冲炸药箱"
	desc = "装有电磁脉冲手榴弹的炸药箱。"
	icon_state = "closed_explosives"
	icon_opened = "open_explosives"
	icon_closed = "closed_explosives"

/obj/structure/closet/crate/empexplosives/Initialize()
	. = ..()
	new /obj/item/explosive/grenade/empgrenade(src)
	new /obj/item/explosive/grenade/empgrenade(src)
	new /obj/item/explosive/grenade/empgrenade(src)
	new /obj/item/explosive/grenade/empgrenade(src)
	new /obj/item/explosive/grenade/empgrenade(src)
	new /obj/item/explosive/grenade/empgrenade(src)

	/* * * * * * * * * * * * * *
	 * Training weapon crates. *
	 * * * * * * * * * * * * * */

/obj/structure/closet/crate/weapon/training/m41a
	name = "M41A MK2训练装备箱"
	desc = "装有M41A MK2步枪和非致命弹药的箱子，用于战斗演习。"
	weapon_type = /obj/item/weapon/gun/rifle/m41a/training
	ammo_type = /obj/item/ammo_magazine/rifle/rubber

/obj/structure/closet/crate/weapon/training/m49a
	name = "M49A训练装备箱"
	desc = "装有M49A战斗步枪和非致命弹药的箱子，用于战斗演习。"
	weapon_type = /obj/item/weapon/gun/rifle/m49a/training
	ammo_type = /obj/item/ammo_magazine/rifle/m49a/rubber

/obj/structure/closet/crate/weapon/training/l42a
	name = "L42A训练装备箱"
	desc = "装有L42A战斗步枪和非致命弹药的箱子，用于战斗演习。"
	weapon_type = /obj/item/weapon/gun/rifle/l42a/training
	ammo_type = /obj/item/ammo_magazine/rifle/l42a/rubber

/obj/structure/closet/crate/weapon/training/m39
	name = "M39训练装备箱"
	desc = "装有M39冲锋枪和非致命弹药的箱子，用于战斗演习。"
	weapon_type = /obj/item/weapon/gun/smg/m39/training
	ammo_type = /obj/item/ammo_magazine/smg/m39/rubber

/obj/structure/closet/crate/weapon/training/m4a3
	name = "M4A3训练装备箱"
	desc = "装有M4A3手枪和非致命弹药的箱子，用于战斗演习。"
	weapon_type = /obj/item/weapon/gun/pistol/m4a3/training
	ammo_type = /obj/item/ammo_magazine/pistol/rubber

/obj/structure/closet/crate/weapon/training/vp70
	name = "VP70训练装备箱"
	desc = "装有VP70手枪和非致命弹药的箱子，用于战斗演习。"
	weapon_type = /obj/item/weapon/gun/pistol/vp70/training
	ammo_type = /obj/item/ammo_magazine/pistol/vp70/rubber

/obj/structure/closet/crate/weapon/training/grenade
	name = "M15橡胶弹丸手榴弹箱"
	desc = "装有多枚非致命M15手榴弹的箱子，用于战斗演习和防暴。"
	ammo_type = /obj/item/explosive/grenade/high_explosive/m15/rubber
	ammo_count = 6


/obj/structure/closet/crate/miningcar
	name = "\improper 矿车"
	desc = "基本上就是一个装着轮子的大铁桶，这辆带有现代塑料罩壳。"
	icon_state = "closed_mcart"
	density = TRUE
	icon_opened = "open_mcart"
	icon_closed = "closed_mcart"

/obj/structure/closet/crate/miningcar/yellow
	name = "\improper 矿车"
	desc = "基本上就是一个装着轮子的大铁桶，这辆带有现代塑料罩壳。"
	icon_state = "closed_mcart_y"
	density = TRUE
	icon_opened = "open_mcart_y"
	icon_closed = "closed_mcart_y"

/obj/structure/closet/crate/upp
	name = "安全军用箱"
	desc = "一个安全军用箱。"
	icon_state = "closed_uppcrate"
	density = TRUE
	icon_opened = "open_uppcrate"
	icon_closed =  "close_uppcrate"
