// UPP Cannon for upp tank
/obj/item/hardpoint/primary/cannon/railgun
	name = "\improper 轨道炮"
	desc = "进步人民联盟坦克用主武器，发射超高速脱壳弹。"
	desc = "进步人民联盟坦克用主武器，发射超高速脱壳弹。"
	desc_lore = "在太阳系外秘密轨道设施中研发的实验型化学助推轨道炮，用于打击碉堡或专用装甲等坚固目标。先用高效自燃推进剂进行初级加速，再由电磁轨道将弹丸加速至极高速度。由于耗能巨大，炮塔内部进行了大幅改造，以容纳电容器和专用发电机。存在炮管磨穿和热信号难以遮蔽的问题。"

	icon = 'icons/obj/vehicles/hardpoints/upptank.dmi'
	icon_state = "railgun"
	disp_icon = "upptank"
	disp_icon_state = "railgun"
	activation_sounds = list('sound/weapons/vehicles/cannon_fire1.ogg', 'sound/weapons/vehicles/cannon_fire2.ogg')

	health = 2300
	firing_arc = 60

	ammo = new /obj/item/ammo_magazine/hardpoint/railgun
	max_clips = 2

	px_offsets = list(
		"1" = list(-1, 18),
		"2" = list(0, -38),
		"4" = list(17, 12),
		"8" = list(-18, 12)
	)

	use_muzzle_flash = TRUE
	angle_muzzleflash = FALSE
	muzzleflash_icon_state = "muzzle_flash"

	muzzle_flash_pos = list(
		"1" = list(0, 67),
		"2" = list(-1, -88),
		"4" = list(86, -6),
		"8" = list(-86, -6)
	)

	scatter = 0
	fire_delay = 10.0 SECONDS
