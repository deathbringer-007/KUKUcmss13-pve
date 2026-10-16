// Van MG
/obj/item/hardpoint/primary/van_mg
	name = "\improper 改装M56车顶机枪"
	desc = "装甲载具用遥控武器系统，采用改装M56机枪。"

	icon_state = "m56_cupola"
	disp_icon = "van"
	disp_icon_state = "van_cupola"
	activation_sounds = list('sound/weapons/gun_smartgun1.ogg', 'sound/weapons/gun_smartgun2.ogg', 'sound/weapons/gun_smartgun3.ogg', 'sound/weapons/gun_smartgun4.ogg')

	health = 300
	firing_arc = 80

	origins = list(0, 0)

	allowed_seat = VEHICLE_DRIVER

	ammo = new /obj/item/ammo_magazine/hardpoint/m56_cupola
	max_clips = 2

	use_muzzle_flash = FALSE

	scatter = 1
	gun_firemode = GUN_FIREMODE_AUTOMATIC
	gun_firemode_list = list(
		GUN_FIREMODE_AUTOMATIC,
	)
	fire_delay = 0.1 SECONDS
