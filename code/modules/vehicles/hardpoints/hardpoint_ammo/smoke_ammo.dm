/obj/item/ammo_magazine/hardpoint/turret_smoke
	name = "炮塔烟幕弹箱"
	desc = "坦克炮塔用烟幕榴弹弹箱。"
	caliber = "grenade"
	icon_state = "slauncher_1"
	w_class = SIZE_LARGE
	default_ammo = /datum/ammo/grenade_container/smoke
	max_rounds = 10
	gun_type = /obj/item/hardpoint/holder/tank_turret

/obj/item/ammo_magazine/hardpoint/turret_smoke/update_icon()
	icon_state = "slauncher_[current_rounds <= 0 ? "0" : "1"]"

/obj/item/ammo_magazine/hardpoint/turret_smoke/uppapc
	name = "UPP炮塔烟幕弹箱"
	desc = "进步人民联盟装甲运兵车炮塔用烟幕榴弹弹箱。"
	icon = 'icons/obj/items/weapons/guns/ammo_by_faction/upp.dmi'
	icon_state = "upp_slauncher_1"
	default_ammo = /datum/ammo/grenade_container/smoke/upp
	gun_type = /obj/item/hardpoint/holder/apc_turret

/obj/item/ammo_magazine/hardpoint/turret_smoke/incen
	name = "烟幕发射器弹箱"
	desc = "装有改装M60燃烧烟幕弹的弹箱，供全地形车的发射器阵列使用。"
	default_ammo = /datum/ammo/grenade_container/incen
	max_rounds = 8

/obj/item/ammo_magazine/hardpoint/turret_smoke/incen/aev
	desc = "装有改装M60燃烧烟幕弹的弹箱，供装甲工程车的发射器阵列使用。"
	max_rounds = 12
