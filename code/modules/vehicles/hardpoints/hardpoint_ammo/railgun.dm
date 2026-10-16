/obj/item/ammo_magazine/hardpoint/railgun
	name = "轨道炮弹箱"
	desc = "装有先进复合脱壳弹的弹箱，供实验武器系统使用。"
	icon = 'icons/obj/items/weapons/guns/ammo_by_faction/upp.dmi'
	caliber = "93mm" //Making this unique on purpose
	icon_state = "railgun_4"
	w_class = SIZE_LARGE //Heavy
	default_ammo = /datum/ammo/rocket/ap/railgun
	max_rounds = 4
	gun_type = /obj/item/hardpoint/primary/cannon/railgun

/obj/item/ammo_magazine/hardpoint/railgun/update_icon()
	icon_state = "railgun_[current_rounds]"

