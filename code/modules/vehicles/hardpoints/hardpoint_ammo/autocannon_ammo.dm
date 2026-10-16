/obj/item/ammo_magazine/hardpoint/ace_autocannon
	name = "AC3-E自动炮弹箱"
	desc = "装有100发40毫米埋头弹的弹箱，供AC3-E自动炮使用。"
	caliber = "40mm"
	icon_state = "ace_autocannon"
	w_class = SIZE_LARGE
	default_ammo = /datum/ammo/bullet/tank/flak
	max_rounds = 100
	gun_type = /obj/item/hardpoint/primary/autocannon

/obj/item/ammo_magazine/hardpoint/ace_autocannon/update_icon()
	if(current_rounds > 0)
		icon_state = "ace_autocannon"
	else
		icon_state = "ace_autocannon_empty"
