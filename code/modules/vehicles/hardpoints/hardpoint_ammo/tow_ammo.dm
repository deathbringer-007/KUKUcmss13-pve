/obj/item/ammo_magazine/hardpoint/towlauncher
	name = "TOW发射器弹箱"
	icon = 'icons/obj/items/weapons/guns/ammo_by_faction/event.dmi'
	desc = "装有激光制导导弹的弹箱，供美洲联盟TOW发射器武器系统使用。"
	caliber = "rocket" //correlates to any rocket mags
	icon_state = "quad_rocket"
	w_class = SIZE_LARGE
	default_ammo = /datum/ammo/rocket/ap/tank_towlauncher
	max_rounds = 10
	gun_type = /obj/item/hardpoint/secondary/towlauncher

/obj/item/ammo_magazine/hardpoint/towlauncher/aa
	name = "M579垂直发射系统弹箱"
	icon = 'icons/obj/items/weapons/guns/ammo_by_faction/event.dmi'
	desc = "装有地对地导弹的弹箱，供M579 ADS-C前置发射系统使用。"
	caliber = "rocket" //correlates to any rocket mags
	icon_state = "quad_rocket"
	w_class = SIZE_LARGE
	default_ammo = /datum/ammo/rocket/ap/tank_towlauncher/aa
	max_rounds = 4
	gun_type = /obj/item/hardpoint/secondary/towlauncher/aa

// HJ-35 FOR UPP APC

/obj/item/ammo_magazine/hardpoint/hj35launcher
	name = "HJ-35发射器弹箱"
	icon = 'icons/obj/items/weapons/guns/ammo_by_faction/upp.dmi'
	desc = "装有激光制导导弹的弹箱，供进步人民联盟HJ-35发射器武器系统使用。"
	caliber = "rocket" //correlates to any rocket mags
	icon_state = "hj35"
	w_class = SIZE_LARGE
	default_ammo = /datum/ammo/rocket/ap/tank_towlauncher/hj35_launcher
	max_rounds = 3
	gun_type = /obj/item/hardpoint/secondary/hj35launcher
