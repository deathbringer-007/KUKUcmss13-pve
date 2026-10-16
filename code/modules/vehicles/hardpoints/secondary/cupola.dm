/obj/item/hardpoint/secondary/m56cupola
	name = "\improper M56车顶机枪"
	desc = "坦克用遥控副武器系统，采用改装M56机枪。"

	icon_state = "m56_cupola"
	disp_icon = "tank"
	disp_icon_state = "m56cupola"
	activation_sounds = list('sound/weapons/gun_smartgun1.ogg', 'sound/weapons/gun_smartgun2.ogg', 'sound/weapons/gun_smartgun3.ogg', 'sound/weapons/gun_smartgun4.ogg')

	health = 2000
	firing_arc = 120

	ammo = new /obj/item/ammo_magazine/hardpoint/m56_cupola
	max_clips = 3

	muzzle_flash_pos = list(
		"1" = list(8, -7),
		"2" = list(-7, -21),
		"4" = list(12, -10),
		"8" = list(-11, 7)
	)

	scatter = 1
	gun_firemode = GUN_FIREMODE_AUTOMATIC
	gun_firemode_list = list(
		GUN_FIREMODE_AUTOMATIC,
	)
	fire_delay = 0.1 SECONDS

/obj/item/hardpoint/secondary/m56cupola/set_bullet_traits()
	..()
	LAZYADD(traits_to_give, list(
		BULLET_TRAIT_ENTRY(/datum/element/bullet_trait_iff)
	))

/obj/item/hardpoint/secondary/m56cupola/aev
	name = "\improper 枢轴式M56遥控武器站"
	desc = "装甲工程车用遥控武器系统，采用改装M56机枪。"
	disp_icon_state = "m56pintle"

	allowed_seat = VEHICLE_DRIVER

	firing_arc = 150

	ammo = new /obj/item/ammo_magazine/hardpoint/m56_cupola/aev
	max_clips = 5

	muzzle_flash_pos = list(
		"1" = list(8, -1),
		"2" = list(-7, -21),
		"4" = list(13, -10),
		"8" = list(-11, 1)
	)

	scatter = 2
