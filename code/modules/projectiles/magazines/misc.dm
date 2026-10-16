

//Minigun

/obj/item/ammo_magazine/minigun
	name = "旋转弹鼓（7.62x51mm）"
	desc = "供大枪使用的巨大弹鼓。"
	caliber = "7.62x51mm"
	icon = 'icons/obj/items/weapons/guns/ammo_by_faction/event.dmi'
	icon_state = "painless" //PLACEHOLDER

	matter = list("metal" = 10000)
	default_ammo = /datum/ammo/bullet/minigun
	max_rounds = 300
	reload_delay = 24 //Hard to reload.
	gun_type = /obj/item/weapon/gun/minigun
	w_class = SIZE_MEDIUM

/obj/item/ammo_magazine/minigun/upp
	default_ammo = /datum/ammo/bullet/minigun/upp

//-------------------------------------------------------
//M41AE2 HEAVY PULSE RIFLE

/obj/item/ammo_magazine/hpr_box
	name = "\improper M41AE2 弹箱（10x24mm）"
	desc = "供 M41AE2 重型脉冲步枪使用的弹箱。"
	caliber = "10x24mm"
	icon_state = "m41ae2"
	default_ammo = /datum/ammo/bullet/rifle/tracer
	max_rounds = 300
	gun_type = /obj/item/weapon/gun/rifle/lmg
	flags_magazine = AMMUNITION_REFILLABLE|AMMUNITION_SLAP_TRANSFER
	ammo_band_icon = "+m41ae2_band"
	ammo_band_icon_empty = "+m41ae2_band_e"
	w_class = SIZE_MEDIUM
	reload_delay = 5

/obj/item/ammo_magazine/hpr_box/holo_target
	name = "\improper M41AE2 全息标记弹箱（10x24mm）"
	desc = "供 M41AE2 重型脉冲步枪使用的全息标记弹箱。"
	default_ammo = /datum/ammo/bullet/rifle/holo_target/tracer
	max_rounds = 300
	ammo_band_color = AMMO_BAND_COLOR_HOLOTARGETING


/obj/item/ammo_magazine/hpr_box/ap
	name = "\improper M41AE2 穿甲弹箱（10x24mm）"
	desc = "供 M41AE2 重型脉冲步枪使用的钢芯穿甲弹箱。"
	default_ammo = /datum/ammo/bullet/rifle/ap/tracer
	max_rounds = 300
	gun_type = /obj/item/weapon/gun/rifle/lmg
	ammo_band_color = AMMO_BAND_COLOR_HEAP

/obj/item/ammo_magazine/hpr_box/heap
	name = "\improper M41AE2 高爆穿甲弹箱（10x24mm）"
	desc = "供 M41AE2 重型脉冲步枪使用的 M903 高爆穿甲弹箱。"
	default_ammo = /datum/ammo/bullet/rifle/heap/tracer
	max_rounds = 300
	gun_type = /obj/item/weapon/gun/rifle/lmg
	ammo_band_color = AMMO_BAND_COLOR_HEAP

/obj/item/ammo_magazine/hpr_box/recon
	icon_state = "m41ae2_recon"
	bonus_overlay = "m41ae2_recon_overlay"

//M60

/obj/item/ammo_magazine/m60
	name = "Mk70 弹链箱（7.62x51mm）"
	desc = "亨金-加西亚限量复产的旧地球武器配件。供其 M60 通用机枪复刻型号 Mk70 使用的 100 发弹链箱。"
	caliber = "7.62x51mm"
	icon = 'icons/obj/items/weapons/guns/ammo_by_faction/colony.dmi'
	icon_state = "m60" //PLACEHOLDER

	matter = list("metal" = 10000)
	default_ammo = /datum/ammo/bullet/m60
	max_rounds = 100
	reload_delay = 8
	gun_type = /obj/item/weapon/gun/m60

/obj/item/ammo_magazine/pkp
	name = "QYJ-72 高爆穿甲弹箱（10x27mm）"
	desc = "供 UPP 制式通用机枪 QYJ-72 使用的 250 发高爆穿甲弹箱，口径 10x27mm。"
	caliber = "10x27mm"
	icon = 'icons/obj/items/weapons/guns/ammo_by_faction/upp.dmi'
	icon_state = "qjy72"
	ammo_band_icon = "+qjy72_band"
	ammo_band_icon = "+qjy72_band_e"
	matter = list("metal" = 10000)
	default_ammo = /datum/ammo/bullet/rifle/upp/heap/tracer
	max_rounds = 250
	reload_delay = 12
	gun_type = /obj/item/weapon/gun/pkp

/obj/item/ammo_magazine/pkp/verb/turn_into_regular()
	set name = "改为 10x27mm 高爆穿甲弹箱"
	set category = "物品"
	set src in usr
	if(current_rounds < 1)
		var/obj/item/ammo_magazine/pkp/empty_mag = new /obj/item/ammo_magazine/pkp(usr.loc)
		empty_mag.current_rounds = 0
		empty_mag.update_icon()
		qdel(src)
		to_chat(usr, "你调整了[src]内部的弹簧，使其可以装填 10x27mm 高爆穿甲弹。")
	else
		to_chat(usr, "必须先清空[src]，才能将其改为可装填 10x27mm 高爆穿甲弹的配置。")

/obj/item/ammo_magazine/pkp/standard_fmj
	name = "QYJ-72 弹箱（10x27mm）"
	desc = "供 UPP 制式通用机枪 QYJ-72 使用的 250 发弹箱，口径 10x27mm。"
	default_ammo = /datum/ammo/bullet/rifle/upp/tracer

/obj/item/ammo_magazine/pkp/super_tracer
	name = "QYJ-72 镁曳光高爆穿甲弹箱（10x27mm）"
	desc = "供 UPP 制式通用机枪 QYJ-72 使用的 250 发镁曳光高爆穿甲弹箱，口径 10x27mm。弹着点会留下持续发光的光源。"
	default_ammo = /datum/ammo/bullet/rifle/upp/heap/tracer/super_tracer
	ammo_band_color = AMMO_BAND_COLOR_INCENDIARY

/obj/item/ammo_magazine/pkp/penetrating
	name = "QYJ-72 穿墙弹箱（10x27mm）"
	desc = "供 UPP 制式通用机枪 QYJ-72 使用的 250 发穿墙弹箱，口径 10x27mm。"
	default_ammo = /datum/ammo/bullet/rifle/upp/heap/tracer/penetrating
	reload_delay = 6
	ammo_band_color = AMMO_BAND_COLOR_PENETRATING

//rocket launchers

/obj/item/ammo_magazine/rifle/grenadespawner
	AUTOWIKI_SKIP(TRUE)

	name = "\improper GRENADE SPAWNER AMMO"
	desc = "OH GOD OH FUCK"
	default_ammo = /datum/ammo/grenade_container/rifle
	ammo_band_color = AMMO_BAND_COLOR_LIGHT_EXPLOSIVE

/obj/item/ammo_magazine/rifle/huggerspawner
	AUTOWIKI_SKIP(TRUE)

	name = "\improper HUGGER SPAWNER AMMO"
	desc = "OH GOD OH FUCK"
	default_ammo = /datum/ammo/hugger_container
	ammo_band_color = AMMO_BAND_COLOR_SUPER
