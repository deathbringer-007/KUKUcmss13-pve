/obj/item/ammo_magazine/hardpoint/flare_launcher
	name = "M-87F照明弹发射器弹箱"
	desc = "支援武器用榴弹弹箱，装有封装在一次性弹壳中的照明弹。"
	caliber = "flare"
	icon_state = "slauncher_1"
	w_class = SIZE_LARGE
	default_ammo = /datum/ammo/flare
	max_rounds = 90
	gun_type = /obj/item/hardpoint/support/flare_launcher

/obj/item/ammo_magazine/hardpoint/flare_launcher/update_icon()
	icon_state = "slauncher_[current_rounds <= 0 ? "0" : "1"]"
