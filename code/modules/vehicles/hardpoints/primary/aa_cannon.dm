/obj/item/hardpoint/primary/aa_quadcannon
	name = "\improper 铅雨RE-RE965防空系统"
	desc = "一座紧凑炮塔，安装有四门20毫米转管炮。通常由载具追踪系统控制，但这座似乎缺少所需的电子设备。"
	icon = 'icons/obj/vehicles/hardpoints/apc.dmi'

	icon_state = "quad_cannon"
	disp_icon = "apc"
	disp_icon_state = "quadcannon"
	activation_sounds = list('sound/weapons/gun_smartgun1.ogg', 'sound/weapons/gun_smartgun2.ogg', 'sound/weapons/gun_smartgun3.ogg')

	damage_multiplier = 0.15

	health = 2000
	firing_arc = 300

	allowed_seat = VEHICLE_GUNNER

	ammo = new /obj/item/ammo_magazine/hardpoint/m56_cupola/quad_cannon
	max_clips = 2

	use_muzzle_flash = TRUE
	angle_muzzleflash = FALSE
	muzzleflash_icon_state = "muzzle_flash_double"

	muzzle_flash_pos = list(
		"1" = list(1, 5),
		"2" = list(1, -30),
		"4" = list(17, 3),
		"8" = list(-17, 3)
	)

	scatter = 2
	gun_firemode = GUN_FIREMODE_AUTOMATIC
	gun_firemode_list = list(
		GUN_FIREMODE_AUTOMATIC,
	)
	fire_delay = 0.02 SECONDS

/obj/item/hardpoint/primary/aa_quadcannon/set_bullet_traits()
	..()
	LAZYADD(traits_to_give, list(
		BULLET_TRAIT_ENTRY(/datum/element/bullet_trait_iff)
	))
