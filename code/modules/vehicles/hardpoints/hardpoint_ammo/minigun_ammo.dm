/obj/item/ammo_magazine/hardpoint/ltaaap_minigun
	name = "LTAA-AP转管机枪弹箱"
	icon = 'icons/obj/items/weapons/guns/ammo_by_faction/uscm.dmi'
	desc = "重型转管机枪用弹箱，装有老旧却依然致命的7.62×51毫米穿甲弹，里面塞满了精度极高的穿甲弹药。"
	caliber = "7.62x51mm" //Correlates to miniguns
	icon_state = "ltaa"
	w_class = SIZE_LARGE //Primary weapon ammo should probably all be the same w_class
	default_ammo = /datum/ammo/bullet/tank/minigun
	max_rounds = 500
	gun_type = /obj/item/hardpoint/primary/minigun

/obj/item/ammo_magazine/hardpoint/Gshk_minigun
	name = "Gshk转管机枪弹箱"
	icon = 'icons/obj/items/weapons/guns/ammo_by_faction/upp.dmi'
	desc = "主武器转管机枪用弹箱。"
	caliber = "7.62x51mm" //Correlates to miniguns
	icon_state = "gshk"
	w_class = SIZE_LARGE //Primary weapon ammo should probably all be the same w_class
	default_ammo = /datum/ammo/bullet/tank/minigun
	max_rounds = 500
	gun_type = /obj/item/hardpoint/primary/minigun
