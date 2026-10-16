/obj/item/hardpoint/secondary/frontalcannon
	name = "\improper 铅雨RE-RE700前置炮"
	desc = "铅雨公司的市场部想让你相信RE-RE700是原创设计。然而，撬开外壳的专家发现，里面的东西与流行的M56车顶机枪惊人地相似。至今没人知道它为什么有两根炮管。"
	icon = 'icons/obj/vehicles/hardpoints/apc.dmi'

	icon_state = "front_cannon"
	disp_icon = "apc"
	disp_icon_state = "frontalcannon"
	activation_sounds = list('sound/weapons/gun_smartgun1.ogg', 'sound/weapons/gun_smartgun2.ogg', 'sound/weapons/gun_smartgun3.ogg')

	damage_multiplier = 0.15

	health = 2000
	firing_arc = 120

	origins = list(0, -1)

	allowed_seat = VEHICLE_DRIVER

	ammo = new /obj/item/ammo_magazine/hardpoint/m56_cupola/frontal_cannon
	max_clips = 2

	use_muzzle_flash = TRUE
	angle_muzzleflash = FALSE
	muzzleflash_icon_state = "muzzle_flash_double"

	muzzle_flash_pos = list(
		"1" = list(-14, 52),
		"2" = list(15, -82),
		"4" = list(68, -26),
		"8" = list(-68, -26)
	)

	scatter = 1
	gun_firemode = GUN_FIREMODE_AUTOMATIC
	gun_firemode_list = list(
		GUN_FIREMODE_AUTOMATIC,
	)
	fire_delay = 0.1 SECONDS

/obj/item/hardpoint/secondary/frontalcannon/set_bullet_traits()
	..()
	LAZYADD(traits_to_give, list(
		BULLET_TRAIT_ENTRY(/datum/element/bullet_trait_iff)
	))
