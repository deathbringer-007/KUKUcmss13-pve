/obj/item/hardpoint/primary/cannon
	name = "\improper LTB火炮"
	desc = "坦克主炮，发射85毫米高爆反坦克弹，是M22“杰克逊”坦克的标准配备，偶尔也安装在M34“朗斯特里特”上。"

	icon_state = "ltb_cannon"
	disp_icon = "tank"
	disp_icon_state = "ltb_cannon"
	activation_sounds = list('sound/weapons/vehicles/cannon_fire1.ogg', 'sound/weapons/vehicles/cannon_fire2.ogg')

	health = 2000
	firing_arc = 75

	ammo = new /obj/item/ammo_magazine/hardpoint/ltb_cannon
	max_clips = 8

	px_offsets = list(
		"1" = list(0, 21),
		"2" = list(0, -32),
		"4" = list(32, 0),
		"8" = list(-32, 0)
	)

	muzzle_flash_pos = list(
		"1" = list(0, 65),
		"2" = list(0, -80),
		"4" = list(95, -4),
		"8" = list(-95, -4)
	)

	scatter = 0
	fire_delay = 3 SECONDS

/obj/item/hardpoint/primary/cannon/set_bullet_traits()
	..()
	LAZYADD(traits_to_give, list(
		BULLET_TRAIT_ENTRY(/datum/element/bullet_trait_iff),
		BULLET_TRAIT_ENTRY_ID("vehicles", /datum/element/bullet_trait_damage_boost, 300, GLOB.damage_boost_vehicles),
	))
