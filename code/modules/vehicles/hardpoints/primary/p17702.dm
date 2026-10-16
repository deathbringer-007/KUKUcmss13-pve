// UPP Cannon for upp tank
/obj/item/hardpoint/primary/cannon/p17702
	name = "\improper P-177-02 93毫米火炮"
	desc = "坦克主炮，发射93毫米高爆反坦克弹。"
	desc_lore = "由越南研发，是中国、柬埔寨和老挝等国参与的多国项目成果。这门93毫米滑膛炮用于多种进步人民联盟轻型载具和防御工事，其中最著名的是作为“猎豹”2A的标准主炮。它坚固可靠，无论深海沟壑、无大气卫星、外星沼泽还是难以穿行的丛林，都能在最恶劣的环境中运作。"

	icon = 'icons/obj/vehicles/hardpoints/upptank.dmi'
	icon_state = "p17702"
	disp_icon = "upptank"
	disp_icon_state = "p17702"
	activation_sounds = list('sound/weapons/vehicles/cannon_fire1.ogg', 'sound/weapons/vehicles/cannon_fire2.ogg')

	health = 2000
	firing_arc = 60

	ammo = new /obj/item/ammo_magazine/hardpoint/p17702
	max_clips = 4

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
	fire_delay = 4 SECONDS
