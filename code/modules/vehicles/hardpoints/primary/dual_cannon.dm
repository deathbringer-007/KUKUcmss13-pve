// APC cannons
/obj/item/hardpoint/primary/dualcannon
	name = "\improper PARS-159“博雅尔”双联炮"
	desc = "M577装甲运兵车的双管主炮，发射支持敌我识别的40毫米埋头弹。"
	icon = 'icons/obj/vehicles/hardpoints/apc.dmi'

	icon_state = "dual_cannon"
	disp_icon = "apc"
	disp_icon_state = "dualcannon"
	activation_sounds = list('sound/weapons/vehicles/dual_autocannon_fire.ogg')

	damage_multiplier = 0.15

	health = 1500
	firing_arc = 60

	origins = list(0, 1)

	allowed_seat = VEHICLE_DRIVER

	ammo = new /obj/item/ammo_magazine/hardpoint/boyars_dualcannon
	max_clips = 2

	use_muzzle_flash = TRUE
	angle_muzzleflash = FALSE
	muzzleflash_icon_state = "muzzle_flash_double"

	muzzle_flash_pos = list(
		"1" = list(11, -35),
		"2" = list(-11, 16),
		"4" = list(-20, 9),
		"8" = list(20, 9)
	)

	scatter = 1
	gun_firemode = GUN_FIREMODE_AUTOMATIC
	gun_firemode_list = list(
		GUN_FIREMODE_AUTOMATIC,
	)
	fire_delay = 0.3 SECONDS

/obj/item/hardpoint/primary/dualcannon/set_bullet_traits()
	..()
	LAZYADD(traits_to_give, list(
		BULLET_TRAIT_ENTRY(/datum/element/bullet_trait_iff)
	))
