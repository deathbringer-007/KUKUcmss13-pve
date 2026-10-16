/obj/item/ammo_magazine/hardpoint/primary_flamer
	name = "DRG-N进攻型火焰喷射器燃料箱"
	desc = "DRG-N进攻型火焰喷射器用燃料箱，装有极易燃烧的超稠萘基混合燃料。"
	caliber = "UT-Napthal Fuel" //correlates to flamer mags
	icon_state = "drgn_flametank"
	w_class = SIZE_LARGE
	max_rounds = 60
	gun_type = /obj/item/hardpoint/primary/flamer
	default_ammo = /datum/ammo/flamethrower/tank_flamer

/obj/item/ammo_magazine/hardpoint/primary_flamer/update_icon()
	if(current_rounds > 0)
		icon_state = "drgn_flametank"
	else
		icon_state = "drgn_flametank_empty"
