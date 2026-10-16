/obj/item/hardpoint/secondary/t60p3m
	name = "\improper T6OP-3M“鵟”遥控武器站"
	desc = "进步人民联盟坦克用遥控副武器系统，采用老式机枪。"
	desc_lore = "“猎豹”2A使用的一种经现代化改进的老式遥控机枪，由俄罗斯与波兰联合研发，具备可靠的自主射击能力，过去常用于拦截低威胁弹体。不过，随着大多数载具采用更先进的主动和被动防御系统，坦克兵现在更喜欢直接用它攻击步兵和软目标。它有个恼人的毛病：在某些高温环境下容易偏离目标。"

	icon = 'icons/obj/vehicles/hardpoints/upptank.dmi'
	icon_state = "t60p3m"
	disp_icon = "upptank"
	disp_icon_state = "t60p3m"
	activation_sounds = list('sound/weapons/gun_smartgun1.ogg', 'sound/weapons/gun_smartgun2.ogg', 'sound/weapons/gun_smartgun3.ogg', 'sound/weapons/gun_smartgun4.ogg')

	health = 2000
	firing_arc = 120

	ammo = new /obj/item/ammo_magazine/hardpoint/t60p3m
	max_clips = 1

	use_muzzle_flash = FALSE
	angle_muzzleflash = FALSE
	muzzleflash_icon_state = "muzzle_flash"

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

/obj/item/hardpoint/secondary/t60p3m/set_bullet_traits()
	..()
	LAZYADD(traits_to_give, list(
		BULLET_TRAIT_ENTRY(/datum/element/bullet_trait_iff)
	))
