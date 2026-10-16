/obj/item/ammo_magazine/hardpoint/arc_sentry
	name = "\improper RE700转管炮弹箱"
	desc = "RE700转管炮用弹箱，装有20毫米弹药。支持敌我识别。"
	caliber = "20mm"
	icon_state = "ace_autocannon"
	w_class = SIZE_LARGE
	default_ammo = /datum/ammo/bullet/re700
	max_rounds = 500
	gun_type = /obj/item/hardpoint/primary/arc_sentry

/obj/item/ammo_magazine/hardpoint/arc_sentry/update_icon()
	if(current_rounds > 0)
		icon_state = "ace_autocannon"
	else
		icon_state = "ace_autocannon_empty"

