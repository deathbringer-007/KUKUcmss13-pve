

//Flame thrower.

/obj/item/ammo_magazine/flamer_tank
	name = "喷火器燃料罐"
	desc = "为 M240 焚烧器储存燃料的燃料罐。请小心操作。"
	icon = 'icons/obj/items/weapons/guns/ammo_by_faction/uscm.dmi'
	icon_state = "flametank_custom"
	item_state = "flametank"
	max_rounds = 100
	default_ammo = /datum/ammo/flamethrower //doesn't actually need bullets. But we'll get null ammo error messages if we don't
	w_class = SIZE_MEDIUM //making sure you can't sneak this onto your belt.
	gun_type = /obj/item/weapon/gun/flamer
	caliber = "UT-Napthal Fuel" //Ultra Thick Napthal Fuel, from the lore book.
	var/custom = FALSE //accepts custom fuels if true

	var/flamer_chem = "utnapthal"
	flags_magazine = AMMUNITION_HIDE_AMMO

	var/max_intensity = 40
	var/max_range = 5
	var/max_duration = 30

	var/fuel_pressure = 1 //How much fuel is used per tile fired
	var/max_pressure = 10

/obj/item/ammo_magazine/flamer_tank/empty
	flamer_chem = null

/obj/item/ammo_magazine/flamer_tank/Initialize(mapload, ...)
	. = ..()
	create_reagents(max_rounds)

	if(flamer_chem)
		reagents.add_reagent(flamer_chem, max_rounds)

	reagents.min_fire_dur = 1
	reagents.min_fire_int = 1
	reagents.min_fire_rad = 1

	reagents.max_fire_dur = max_duration
	reagents.max_fire_rad = max_range
	reagents.max_fire_int = max_intensity

	update_icon()

/obj/item/ammo_magazine/flamer_tank/verb/remove_reagents()
	set name = "清空燃料罐"
	set category = "物品"

	set src in usr

	if(usr.get_active_hand() != src)
		return

	if(alert(usr, "确定要清空[src]吗？", "清空燃料罐", "是", "否") != "是")
		return

	reagents.clear_reagents()

	playsound(loc, 'sound/effects/refill.ogg', 25, 1, 3)
	to_chat(usr, SPAN_NOTICE("你清空了[src]。"))
	update_icon()

/obj/item/ammo_magazine/flamer_tank/on_reagent_change()
	. = ..()
	update_icon()

	if(isgun(loc))
		var/obj/item/weapon/gun/G = loc
		if(G.current_mag == src)
			G.update_icon()

/obj/item/ammo_magazine/flamer_tank/afterattack(obj/target, mob/user , flag) //refuel at fueltanks when we run out of ammo.
	if(get_dist(user,target) > 1)
		return ..()
	if(!istype(target, /obj/structure/reagent_dispensers/fueltank) && !istype(target, /obj/item/tool/weldpack) && !istype(target, /obj/item/storage/backpack/marine/engineerpack))
		return ..()

	if(!target.reagents || length(target.reagents.reagent_list) < 1)
		to_chat(user, SPAN_WARNING("[target]是空的！"))
		return

	if(!reagents)
		create_reagents(max_rounds)

	var/datum/reagent/to_add = target.reagents.reagent_list[1]

	if(!istype(to_add) || (length(reagents.reagent_list) && flamer_chem != to_add.id) || length(target.reagents.reagent_list) > 1)
		to_chat(user, SPAN_WARNING("不能混合不同的燃料配方！"))
		return

	if(istype(to_add, /datum/reagent/generated) && !custom)
		to_chat(user, SPAN_WARNING("[src]不能使用自配燃料！"))
		return

	if(!to_add.intensityfire && to_add.id != "stablefoam" && !istype(src, /obj/item/ammo_magazine/flamer_tank/smoke))
		to_chat(user, SPAN_WARNING("这种化学品的效力不足以用作喷火器燃料！"))
		return

	var/fuel_amt_to_remove = clamp(to_add.volume, 0, max_rounds - reagents.get_reagent_amount(to_add.id))
	if(!fuel_amt_to_remove)
		if(!max_rounds)
			to_chat(user, SPAN_WARNING("[target]是空的！"))
		return

	target.reagents.remove_reagent(to_add.id, fuel_amt_to_remove)
	reagents.add_reagent(to_add.id, fuel_amt_to_remove)
	playsound(loc, 'sound/effects/refill.ogg', 25, 1, 3)
	caliber = to_add.name
	flamer_chem = to_add.id

	to_chat(user, SPAN_NOTICE("你用[caliber]重新加满了[src]。"))
	update_icon()

/obj/item/ammo_magazine/flamer_tank/update_icon()
	overlays.Cut()

	var/image/I = image(icon, icon_state="[icon_state]_strip")

	if(reagents)
		I.color = mix_color_from_reagents(reagents.reagent_list)

	overlays += I

/obj/item/ammo_magazine/flamer_tank/get_ammo_percent()
	if(!reagents)
		return 0

	return 100 * (reagents.total_volume / max_rounds)

/obj/item/ammo_magazine/flamer_tank/get_examine_text(mob/user)
	. = ..()
	. += SPAN_NOTICE("内含：")
	if(reagents && length(reagents.reagent_list))
		for(var/datum/reagent/R in reagents.reagent_list)
			. += SPAN_NOTICE("[R.name]：[R.volume] 单位。")
	else
		. += SPAN_NOTICE("空无一物。")

/obj/item/ammo_magazine/flamer_tank/upp
	icon = 'icons/obj/items/weapons/guns/ammo_by_faction/upp.dmi'
	icon_state = "LPO80"
	item_state = "LPO80"

/obj/item/ammo_magazine/flamer_tank/upp/gellied
	name = "喷火器燃料罐（B 型凝胶）"
	desc = "装满特制 B 型凝胶 UT-Napthal 燃料的燃料罐。与液态配方不同，这种凝胶状凝固汽油容易被扑灭，但射程较远，会黏附在地面上，并与无机材料反应使其分解。请格外小心操作。"
	icon = 'icons/obj/items/weapons/guns/ammo_by_faction/upp.dmi'
	icon_state = "LPO80"
	item_state = "LPO80"
	caliber = "Napalm Gel"
	flamer_chem = "napalmgel"
	max_rounds = 200

	max_range = 7
	max_duration = 50

// This is gellie fuel. Green Flames.
/obj/item/ammo_magazine/flamer_tank/gellied
	name = "喷火器燃料罐（B 型凝胶）"
	desc = "装满特制 B 型凝胶 UT-Napthal 燃料的燃料罐。与液态配方不同，这种凝胶状凝固汽油容易被扑灭，但射程较远，会黏附在地面上，并与无机材料反应使其分解。请格外小心操作。"
	caliber = "Napalm Gel"
	flamer_chem = "napalmgel"
	max_rounds = 200

	max_range = 7
	max_duration = 50

/obj/item/ammo_magazine/flamer_tank/EX
	name = "喷火器燃料罐（EX 型）"
	desc = "供 M240-T 焚烧器使用的 EX 型 UT-Napthal 燃料罐。这种黏稠易燃液体的燃烧温度极高，足以熔穿阻燃材料。请小心操作。"
	caliber = "Napalm EX"
	flamer_chem = "napalmex"

	max_range = 7

/obj/item/ammo_magazine/flamer_tank/weak
	name = "喷火器燃料罐（低纯度）"
	desc = "装满低纯度凝固汽油的燃料罐，燃烧温度明显较低。"
	caliber = "Impure Napalm"
	flamer_chem = "weaknapalm"
	max_range = 5

/obj/item/ammo_magazine/flamer_tank/custom
	name = "定制喷火器燃料罐"
	desc = "为 M240 焚烧器储存燃料的燃料罐，经过改装，配有压力调节器和内置推进剂罐。"
	matter = list("metal" = 3750)
	flamer_chem = null
	max_rounds = 100
	max_range = 5
	fuel_pressure = 1
	custom = TRUE

/obj/item/ammo_magazine/flamer_tank/custom/verb/set_fuel_pressure()
	set name = "调整燃料压力"
	set category = "物品"

	set src in usr

	if(usr.get_active_hand() != src)
		return

	var/set_pressure = clamp(tgui_input_number(usr, "将燃料压力设为：（最大值：[max_pressure]）", "燃料压力", fuel_pressure, 10, 1), 1 ,max_pressure)
	if(!set_pressure)
		to_chat(usr, SPAN_WARNING("调节器上没有这个档位！"))
	else
		to_chat(usr, SPAN_NOTICE("你将压力调节器设为每格 [set_pressure] 单位。"))
		fuel_pressure = set_pressure

/obj/item/ammo_magazine/flamer_tank/custom/get_examine_text(mob/user)
	. = ..()
	. += SPAN_NOTICE("压力调节器当前设为每格 [src.fuel_pressure] 单位。")

// Pyro regular flamer tank just bigger than the base flamer tank.
/obj/item/ammo_magazine/flamer_tank/large
	name = "大型喷火器燃料罐"
	desc = "为 M240-T 焚烧器储存燃料的大型燃料罐。请小心操作。"
	icon_state = "flametank_large_custom"
	item_state = "flametank_large"
	max_rounds = 250
	gun_type = /obj/item/weapon/gun/flamer/M240T

	max_intensity = 80
	max_range = 6
	max_duration = 50

/obj/item/ammo_magazine/flamer_tank/large/empty
	flamer_chem = null



// This is the green flamer fuel for the pyro.
/obj/item/ammo_magazine/flamer_tank/large/B
	name = "大型喷火器燃料罐（B 型）"
	desc = "供 M240-T 焚烧器使用的 B 型 UT-Napthal 大型燃料罐。这种特殊凝固汽油容易被扑灭，却能在大范围内扩散并缓慢燃烧。其成分会与无机材料反应使其分解，造成严重损伤。请小心操作。"
	caliber = "Napalm B"
	flamer_chem = "napalmb"
	max_rounds = 300

	max_range = 7

// This is the blue flamer fuel for the pyro.
/obj/item/ammo_magazine/flamer_tank/large/X
	name = "大型喷火器燃料罐（X 型）"
	desc = "供 M240-T 焚烧器使用的 X 型 UT-Napthal 大型燃料罐，内含燃烧温度极高的黏稠易燃液体。请小心操作。"
	caliber = "Napalm X"
	flamer_chem = "napalmx"

	max_range = 7

/obj/item/ammo_magazine/flamer_tank/large/EX
	name = "大型喷火器燃料罐（EX 型）"
	desc = "供 M240-T 焚烧器使用的 EX 型 UT-Napthal 大型燃料罐。这种黏稠易燃液体的燃烧温度极高，足以熔穿阻燃材料。请小心操作。"
	caliber = "Napalm EX"
	flamer_chem = "napalmex"

	max_range = 7

//Custom pyro tanks
/obj/item/ammo_magazine/flamer_tank/custom/large
	name = "大型定制喷火器燃料罐"
	desc = "供 M240-T 焚烧器使用的大型燃料罐，经过改装，配有压力调节器和大型内置推进剂罐。必须手动安装。"
	gun_type = /obj/item/weapon/gun/flamer/M240T
	max_rounds = 250

	max_intensity = 60
	max_range = 8
	max_duration = 50

/obj/item/ammo_magazine/flamer_tank/smoke
	name = "定制喷火器烟雾罐"
	desc = "装有烟雾粉剂的罐子，粉剂遇明火后膨胀，并携带混入其中的化学品一同散布。"
	matter = list("metal" = 3750)
	flamer_chem = null
	custom = TRUE

//tanks printable by the research biomass machine
/obj/item/ammo_magazine/flamer_tank/custom/upgraded
	name = "升级型定制喷火器燃料罐"
	desc = "为 M240 焚烧器储存燃料的燃料罐，经过改装，配有更大、更精密的内置推进剂罐，容量更大，并能使用更强力的燃料。"
	matter = list("metal" = 50) // no free metal
	flamer_chem = null
	max_rounds = 200
	max_range = 7
	fuel_pressure = 1
	max_duration = 50
	max_intensity = 60
	custom = TRUE

/obj/item/ammo_magazine/flamer_tank/smoke/upgraded
	name = "大型定制喷火器烟雾罐"
	desc = "装有烟雾粉剂的罐子，粉剂遇明火后膨胀，并携带混入其中的化学品一同散布。此罐配有升级型内置压缩机，容量更大。"
	matter = list("metal" = 50) //no free metal
	flamer_chem = null
	custom = TRUE
	max_rounds = 150
