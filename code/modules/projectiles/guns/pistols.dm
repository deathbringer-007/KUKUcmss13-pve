//Base pistol for inheritance/
//--------------------------------------------------

/obj/item/weapon/gun/pistol
	icon_state = "" //should return the honk-error sprite if there's no assigned icon.
	icon = 'icons/obj/items/weapons/guns/guns_by_faction/uscm.dmi'
	mouse_pointer = 'icons/effects/mouse_pointer/pistol_mouse.dmi'

	reload_sound = 'sound/weapons/flipblade.ogg'
	cocked_sound = 'sound/weapons/gun_pistol_cocked.ogg'
	empty_sound = 'sound/weapons/gun_empty.ogg'

	matter = list("metal" = 2000)
	flags_equip_slot = SLOT_WAIST
	w_class = SIZE_MEDIUM
	force = 6
	movement_onehanded_acc_penalty_mult = 3
	wield_delay = WIELD_DELAY_VERY_FAST //If you modify your pistol to be two-handed, it will still be fast to aim
	fire_sound = "m4a3"
	attachable_allowed = list(
		/obj/item/attachable/suppressor,
		/obj/item/attachable/reddot,
		/obj/item/attachable/reflex,
		/obj/item/attachable/flashlight,
		/obj/item/attachable/compensator,
		/obj/item/attachable/lasersight,
		/obj/item/attachable/extended_barrel,
		/obj/item/attachable/heavy_barrel,
		/obj/item/attachable/burstfire_assembly,
	)

	flags_gun_features = GUN_AUTO_EJECTOR|GUN_CAN_POINTBLANK|GUN_ONE_HAND_WIELDED|GUN_AUTO_EJECT_CASINGS //For easy reference.
	gun_category = GUN_CATEGORY_HANDGUN

/obj/item/weapon/gun/pistol/Initialize(mapload, spawn_empty)
	. = ..()
	if(current_mag && current_mag.current_rounds > 0)
		load_into_chamber()

/obj/item/weapon/gun/pistol/unique_action(mob/user)
		cock(user)

/obj/item/weapon/gun/pistol/set_gun_config_values()
	..()
	movement_onehanded_acc_penalty_mult = 3

//-------------------------------------------------------
//M4A3 PISTOL

/obj/item/weapon/gun/pistol/m4a3
	name = "M4A3 制式手枪"
	desc = "刚被替换下来的 USCM 半自动 9mm 制式手枪，凭借轻巧扳机和熟悉手感，仍深受陆战队员欢迎。"
	icon = 'icons/obj/items/weapons/guns/guns_by_faction/uscm.dmi'
	icon_state = "m4a3"
	item_state = "m4a3"
	fire_sound = "vp70"
	current_mag = /obj/item/ammo_magazine/pistol
	flags_gun_features = GUN_AUTO_EJECTOR|GUN_CAN_POINTBLANK|GUN_ONE_HAND_WIELDED|GUN_AUTO_EJECT_CASINGS
	attachable_allowed = list(
		/obj/item/attachable/suppressor,
		/obj/item/attachable/reddot,
		/obj/item/attachable/reflex,
		/obj/item/attachable/flashlight,
		/obj/item/attachable/compensator,
		/obj/item/attachable/lasersight,
		/obj/item/attachable/extended_barrel,
		/obj/item/attachable/heavy_barrel,
		/obj/item/attachable/burstfire_assembly,
	)

/obj/item/weapon/gun/pistol/m4a3/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 28, "muzzle_y" = 20,"rail_x" = 10, "rail_y" = 21, "under_x" = 21, "under_y" = 17, "stock_x" = 21, "stock_y" = 17, "side_rail_x" = 19, "side_rail_y" = 15)


/obj/item/weapon/gun/pistol/m4a3/set_gun_config_values()
	..()
	set_fire_delay(FIRE_DELAY_TIER_12)
	accuracy_mult = BASE_ACCURACY_MULT + HIT_ACCURACY_MULT_TIER_4
	accuracy_mult_unwielded = BASE_ACCURACY_MULT
	scatter = SCATTER_AMOUNT_TIER_6
	burst_scatter_mult = SCATTER_AMOUNT_TIER_6
	scatter_unwielded = SCATTER_AMOUNT_TIER_6
	damage_mult = BASE_BULLET_DAMAGE_MULT


/obj/item/weapon/gun/pistol/m4a3/training
	current_mag = /obj/item/ammo_magazine/pistol/rubber

/obj/item/weapon/gun/pistol/m4a3/unloaded
	current_mag = null

/obj/item/weapon/gun/pistol/m4a3/custom
	name = "M4A3 定制手枪"
	desc = "这把 9mm 手枪采用镍色表面和可能是仿象牙的握把，由门户站一位知名枪匠定制。没有任何战术优势。"
	icon_state = "m4a3c"
	item_state = "m4a3c"

/obj/item/weapon/gun/pistol/m4a3/custom/set_gun_config_values()
	..()
	set_fire_delay(FIRE_DELAY_TIER_12)
	accuracy_mult = BASE_ACCURACY_MULT + HIT_ACCURACY_MULT_TIER_4
	accuracy_mult_unwielded = BASE_ACCURACY_MULT
	scatter = SCATTER_AMOUNT_TIER_6
	burst_scatter_mult = SCATTER_AMOUNT_TIER_6
	scatter_unwielded = SCATTER_AMOUNT_TIER_6
	damage_mult = BASE_BULLET_DAMAGE_MULT


//L54A2, browning hi-power but in space

/obj/item/weapon/gun/pistol/l54
	name = "L54A2 制式手枪"
	desc = "NSPA 制式半自动手枪，使用 9mm 弹药，性能与 USCM 广受欢迎的 M4A3 相当。不久前它还是 RMC 的制式手枪，后被 L165A1 取代。"
	icon = 'icons/obj/items/weapons/guns/guns_by_faction/twe_guns.dmi'
	icon_state = "l54"
	item_state = "l54"
	fire_sound = "vp70"
	current_mag = /obj/item/ammo_magazine/pistol/l54
	flags_gun_features = GUN_AUTO_EJECTOR|GUN_CAN_POINTBLANK|GUN_ONE_HAND_WIELDED|GUN_AUTO_EJECT_CASINGS
	attachable_allowed = null

/obj/item/weapon/gun/pistol/l54/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 28, "muzzle_y" = 20,"rail_x" = 10, "rail_y" = 21, "under_x" = 21, "under_y" = 17, "stock_x" = 21, "stock_y" = 17, "side_rail_x" = 19, "side_rail_y" = 14)

/obj/item/weapon/gun/pistol/l54/set_gun_config_values()
	..()
	set_fire_delay(FIRE_DELAY_TIER_10)
	accuracy_mult = BASE_ACCURACY_MULT + HIT_ACCURACY_MULT_TIER_4
	accuracy_mult_unwielded = BASE_ACCURACY_MULT
	scatter = SCATTER_AMOUNT_TIER_6
	burst_scatter_mult = SCATTER_AMOUNT_TIER_6
	scatter_unwielded = SCATTER_AMOUNT_TIER_6
	damage_mult = BASE_BULLET_DAMAGE_MULT

/obj/item/weapon/gun/pistol/l54/unloaded
	current_mag = null

//VP70

/obj/item/weapon/gun/pistol/vp70
	name = "VP70 M5 制式手枪"
	desc = "USCM 制式半自动手枪，近期取代 M4A3。沿用前代 9mm 口径，同时增加弹匣容量并提供三连发模式。"
	icon = 'icons/obj/items/weapons/guns/guns_by_faction/uscm.dmi'
	icon_state = "vp70"
	item_state = "vp70"
	fire_sound = "vp70"
	reload_sound = 'sound/weapons/gun_vp70_reload.ogg'
	unload_sound = 'sound/weapons/gun_vp70_unload.ogg'
	current_mag = /obj/item/ammo_magazine/pistol/vp70
	force = 8
	flags_gun_features = GUN_AUTO_EJECTOR|GUN_CAN_POINTBLANK|GUN_ONE_HAND_WIELDED|GUN_AUTO_EJECT_CASINGS
	attachable_allowed = list(
		/obj/item/attachable/suppressor,
		/obj/item/attachable/extended_barrel,
		/obj/item/attachable/heavy_barrel,
		/obj/item/attachable/compensator,
		/obj/item/attachable/flashlight,
		/obj/item/attachable/reflex,
		/obj/item/attachable/reddot,
		/obj/item/attachable/burstfire_assembly,
		/obj/item/attachable/lasersight,
		/obj/item/attachable/flashlight/grip,
		/obj/item/attachable/magnetic_harness,
		/obj/item/attachable/stock/vp70,
	)
	start_automatic = TRUE

/obj/item/weapon/gun/pistol/vp70/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 27, "muzzle_y" = 21,"rail_x" = 8, "rail_y" = 22, "under_x" = 21, "under_y" = 18, "stock_x" = 11, "stock_y" = 14, "side_rail_x" = 19, "side_rail_y" = 16)


/obj/item/weapon/gun/pistol/vp70/set_gun_config_values()
	..()
	set_fire_delay(FIRE_DELAY_TIER_11)
	set_burst_amount(BURST_AMOUNT_TIER_3)
	set_burst_delay(FIRE_DELAY_TIER_11)
	accuracy_mult = BASE_ACCURACY_MULT
	accuracy_mult_unwielded = BASE_ACCURACY_MULT
	scatter = SCATTER_AMOUNT_TIER_7
	burst_scatter_mult = SCATTER_AMOUNT_TIER_7
	scatter_unwielded = SCATTER_AMOUNT_TIER_7
	damage_mult = BASE_BULLET_DAMAGE_MULT

/obj/item/weapon/gun/pistol/vp70/unloaded
	current_mag = null
/obj/item/weapon/gun/pistol/vp70/training
	current_mag = /obj/item/ammo_magazine/pistol/vp70/rubber


/obj/item/weapon/gun/pistol/vp70/flashlight/handle_starting_attachment()
	..()
	var/obj/item/attachable/flashlight/flashlight = new(src)
	flashlight.Attach(src)
	update_attachable(flashlight.slot)

//-------------------------------------------------------

/obj/item/weapon/gun/pistol/m1911
	name = "M1911 手枪"
	desc = "虽然从未成为 USCM 正式制式手枪，但 .45 ACP 口径及其与陆战队前身的文化联系，让它始终广受欢迎，甚至长期积压着大量待交付订单。"
	icon = 'icons/obj/items/weapons/guns/guns_by_faction/uscm.dmi'
	icon_state = "m4a345"
	item_state = "m4a3"
	fire_sound = 'sound/weapons/gun_vp78_v2.ogg'
	current_mag = /obj/item/ammo_magazine/pistol/m1911

/obj/item/weapon/gun/pistol/m1911/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 28, "muzzle_y" = 20,"rail_x" = 10, "rail_y" = 22, "under_x" = 21, "under_y" = 17, "stock_x" = 21, "stock_y" = 17, "side_rail_x" = 19, "side_rail_y" = 15)

/obj/item/weapon/gun/pistol/m1911/set_gun_config_values()
	..()
	set_fire_delay(FIRE_DELAY_TIER_9)
	accuracy_mult = BASE_ACCURACY_MULT + HIT_ACCURACY_MULT_TIER_4
	accuracy_mult_unwielded = BASE_ACCURACY_MULT
	scatter = SCATTER_AMOUNT_TIER_6
	scatter_unwielded = SCATTER_AMOUNT_TIER_4
	damage_mult = BASE_BULLET_DAMAGE_MULT + BULLET_DAMAGE_MULT_TIER_5
	recoil_unwielded = RECOIL_AMOUNT_TIER_4

/obj/item/weapon/gun/pistol/m1911/socom
	name = "M48A4 手枪"
	desc = "自第一次世界大战以来的永恒经典，M1911A1 在 USCM 中少量服役，也因可靠性而常被非政府组织用作副武器。这是配有弹药计数器和聚合物握把的现代化版本，编号 M48A4，使用 .45 ACP 弹药。"
	icon_state = "m4a345_s"
	item_state = "m4a3"
	flags_gun_features = GUN_AUTO_EJECTOR|GUN_CAN_POINTBLANK|GUN_ONE_HAND_WIELDED|GUN_AMMO_COUNTER|GUN_AUTO_EJECT_CASINGS

/obj/item/weapon/gun/pistol/m1911/socom/set_gun_config_values()
	..()
	set_fire_delay(FIRE_DELAY_TIER_9)
	accuracy_mult = BASE_ACCURACY_MULT + HIT_ACCURACY_MULT_TIER_4
	accuracy_mult_unwielded = BASE_ACCURACY_MULT + HIT_ACCURACY_MULT_TIER_2
	scatter = SCATTER_AMOUNT_TIER_8
	burst_scatter_mult = SCATTER_AMOUNT_TIER_6
	scatter_unwielded = SCATTER_AMOUNT_TIER_6
	damage_mult = BASE_BULLET_DAMAGE_MULT + BULLET_DAMAGE_MULT_TIER_5

/obj/item/weapon/gun/pistol/m1911/socom/equipped
	starting_attachment_types = list(/obj/item/attachable/suppressor, /obj/item/attachable/lasersight, /obj/item/attachable/reflex)

/obj/item/weapon/gun/pistol/m1911/socom/officer
	name = "\improper M48A5 手枪"
	desc = "自第一次世界大战以来的永恒经典。M1911A1 在美国殖民地陆战队中少量服役，其可靠性也使它常被非政府组织选作副武器。M48A5 由 M48A4 改进而来，强化了弹膛、枪管与套筒，以承受更高膛压。使用 .45 Super 弹药，也可装填普通 .45 ACP 弹药。"
	starting_attachment_types = list(/obj/item/attachable/lasersight)
	current_mag = /obj/item/ammo_magazine/pistol/m1911/super

//.45 MARSHALS PISTOL //Inspired by the Browning Hipower
// rebalanced - singlefire, very strong bullets but slow to fire and heavy recoil
// redesigned - now rejected USCM sidearm model, utilized by Colonial Marshals and other stray groups.

/obj/item/weapon/gun/pistol/highpower
	name = "\improper HG 45“雄鹰”手枪"
	desc = "亨金-加西亚设计的半自动手枪，使用 .45 ACP 弹药，正逐步取代殖民地法警署的“矛头”左轮手枪。"
	icon = 'icons/obj/items/weapons/guns/guns_by_faction/colony.dmi'
	icon_state = "highpower"
	item_state = "highpower"
	fire_sound = 'sound/weapons/gun_vp78_v2.ogg'
	current_mag = /obj/item/ammo_magazine/pistol/highpower
	force = 15
	attachable_allowed = list(
		/obj/item/attachable/suppressor, // Barrel
		/obj/item/attachable/bayonet,
		/obj/item/attachable/bayonet/upp/surplus,
		/obj/item/attachable/bayonet/upp,
		/obj/item/attachable/extended_barrel,
		/obj/item/attachable/heavy_barrel,
		/obj/item/attachable/compensator,
		/obj/item/attachable/reddot, // Rail
		/obj/item/attachable/reflex,
		/obj/item/attachable/flashlight,
		/obj/item/attachable/magnetic_harness,
		/obj/item/attachable/scope,
		/obj/item/attachable/scope/mini,
		/obj/item/attachable/gyro, // Under
		/obj/item/attachable/lasersight,
		/obj/item/attachable/burstfire_assembly,
	)

/obj/item/weapon/gun/pistol/highpower/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 29, "muzzle_y" = 20,"rail_x" = 6, "rail_y" = 22, "under_x" = 20, "under_y" = 15, "stock_x" = 0, "stock_y" = 0, "side_rail_x" = 20, "side_rail_y" = 15)

/obj/item/weapon/gun/pistol/highpower/set_gun_config_values()
	..()
	set_fire_delay(FIRE_DELAY_TIER_7)
	accuracy_mult = BASE_ACCURACY_MULT + HIT_ACCURACY_MULT_TIER_4
	accuracy_mult_unwielded = BASE_ACCURACY_MULT
	scatter = SCATTER_AMOUNT_TIER_6
	scatter_unwielded = SCATTER_AMOUNT_TIER_4
	damage_mult = BASE_BULLET_DAMAGE_MULT + BULLET_DAMAGE_MULT_TIER_5
	recoil_unwielded = RECOIL_AMOUNT_TIER_4

/obj/item/weapon/gun/pistol/highpower/black
	name = "\improper HG 45“海军”手枪"
	current_mag = /obj/item/ammo_magazine/pistol/highpower/black
	icon_state = "highpower_b"
	item_state = "highpower_b"
	desc = "亨金-加西亚设计的半自动手枪，使用 .45 ACP 弹药，正逐步取代殖民地法警署的“矛头”左轮手枪。与更常见的同系型号不同，此型以美国殖民地陆战队为销售对象，成功售出了少量产品。"

/obj/item/weapon/gun/pistol/highpower/automag
	name = "\improper HG 44“自动马格南”手枪"
	desc = "亨金-加西亚设计的半自动手枪，使用 .44 Magnum 弹药。它大多已停产，转而生产使用 .45 ACP 的 HG 45 型。"
	current_mag = /obj/item/ammo_magazine/pistol/highpower/automag
	icon_state = "highpower_tac"
	item_state = "highpower_tac"
	fire_sound = 'sound/weapons/gun_kt42.ogg'
	flags_gun_features = GUN_AUTO_EJECTOR|GUN_CAN_POINTBLANK|GUN_ONE_HAND_WIELDED|GUN_AUTO_EJECT_CASINGS

/obj/item/weapon/gun/pistol/highpower/automag/set_gun_config_values()
	..()
	set_fire_delay(FIRE_DELAY_TIER_6)
	recoil = RECOIL_AMOUNT_TIER_5
	recoil_unwielded = RECOIL_AMOUNT_TIER_3
	damage_mult = BASE_BULLET_DAMAGE_MULT - BULLET_DAMAGE_MULT_TIER_3

/obj/item/weapon/gun/pistol/highpower/automag/tactical
	name = "\improper HG 44“自动马格南”手枪"
	desc = "亨金-加西亚设计的半自动手枪，使用 .44 Magnum 弹药。它大多已停产，转而生产使用 .45 ACP 的 HG 45 型。"
	starting_attachment_types = list(/obj/item/attachable/suppressor, /obj/item/attachable/lasersight, /obj/item/attachable/reflex)
	flags_gun_features = GUN_AUTO_EJECTOR|GUN_CAN_POINTBLANK|GUN_ONE_HAND_WIELDED|GUN_AUTO_EJECT_CASINGS

//-------------------------------------------------------
//NP92 pistol
//Its a makarov

/obj/item/weapon/gun/pistol/np92
	name = "NP92 手枪"
	desc = "UPP 制式副武器。NP92 是小巧多用的手枪，使用 9x18mm 马卡洛夫弹。"
	icon = 'icons/obj/items/weapons/guns/guns_by_faction/upp.dmi'
	icon_state = "np92"
	item_state = "np92"
	fire_sound = "vp70"
	current_mag = /obj/item/ammo_magazine/pistol/np92
	flags_gun_features = GUN_AUTO_EJECTOR|GUN_CAN_POINTBLANK|GUN_ONE_HAND_WIELDED|GUN_AUTO_EJECT_CASINGS
	attachable_allowed = list(
		/obj/item/attachable/suppressor,
		/obj/item/attachable/reddot,
		/obj/item/attachable/reflex,
		/obj/item/attachable/flashlight,
	)

/obj/item/weapon/gun/pistol/np92/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 27, "muzzle_y" = 20,"rail_x" = 13, "rail_y" = 22, "under_x" = 21, "under_y" = 18, "stock_x" = 21, "stock_y" = 18, "side_rail_x" = 19, "side_rail_y" = 15)

/obj/item/weapon/gun/pistol/np92/set_gun_config_values()
	..()
	set_fire_delay(FIRE_DELAY_TIER_12)
	accuracy_mult = BASE_ACCURACY_MULT + HIT_ACCURACY_MULT_TIER_5
	accuracy_mult_unwielded = BASE_ACCURACY_MULT + HIT_ACCURACY_MULT_TIER_5
	scatter = SCATTER_AMOUNT_TIER_6
	burst_scatter_mult = SCATTER_AMOUNT_TIER_6
	scatter_unwielded = SCATTER_AMOUNT_TIER_6
	damage_mult = BASE_BULLET_DAMAGE_MULT + BULLET_DAMAGE_MULT_TIER_3

/obj/item/weapon/gun/pistol/np92/suppressed
	name = "\improper NPZ92 手枪"
	desc = "NP92 的改型，配有一体式消声器，少量配发给突击队。"
	icon = 'icons/obj/items/weapons/guns/guns_by_faction/upp.dmi'
	icon_state = "npz92"
	item_state = "npz92"
	inherent_traits = list(TRAIT_GUN_SILENCED)
	fire_sound = "gun_silenced"
	current_mag = /obj/item/ammo_magazine/pistol/np92/suppressed
	flags_gun_features = GUN_AUTO_EJECTOR|GUN_CAN_POINTBLANK|GUN_ONE_HAND_WIELDED|GUN_AUTO_EJECT_CASINGS
	attachable_allowed = list(
		/obj/item/attachable/reddot,
		/obj/item/attachable/reflex,
		/obj/item/attachable/flashlight,
	)

/obj/item/weapon/gun/pistol/np92/suppressed/tranq
	current_mag = /obj/item/ammo_magazine/pistol/np92/tranq

/obj/item/weapon/gun/pistol/np92/unloaded
	current_mag = null

//-------------------------------------------------------
//Type 73 pistol
//Its a TT

/obj/item/weapon/gun/pistol/t73
	name = "73 式手枪"
	desc = "曾是 UPP 的制式副武器，现已被更小巧的 NP92 取代。使用 7.62x25mm 托卡列夫弹，因额外火力仍受老兵欢迎。"
	icon = 'icons/obj/items/weapons/guns/guns_by_faction/upp.dmi'
	icon_state = "tt"
	item_state = "tt"
	fire_sound = 'sound/weapons/gun_vp78_v2.ogg'
//	fire_sound = 'sound/weapons/gun_tt.ogg'
	current_mag = /obj/item/ammo_magazine/pistol/t73
	flags_gun_features = GUN_AUTO_EJECTOR|GUN_CAN_POINTBLANK|GUN_ONE_HAND_WIELDED|GUN_AUTO_EJECT_CASINGS
	attachable_allowed = list(
		/obj/item/attachable/reddot,
		/obj/item/attachable/reflex,
		/obj/item/attachable/flashlight,
		/obj/item/attachable/lasersight,
		/obj/item/attachable/suppressor,
	)

/obj/item/weapon/gun/pistol/t73/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 28, "muzzle_y" = 20,"rail_x" = 13, "rail_y" = 22, "under_x" = 22, "under_y" = 15, "stock_x" = 21, "stock_y" = 18, "side_rail_x" = 22, "side_rail_y" = 15)

/obj/item/weapon/gun/pistol/t73/set_gun_config_values()
	..()
	set_fire_delay(FIRE_DELAY_TIER_11)
	accuracy_mult = BASE_ACCURACY_MULT + HIT_ACCURACY_MULT_TIER_5
	accuracy_mult_unwielded = BASE_ACCURACY_MULT + HIT_ACCURACY_MULT_TIER_5
	scatter = SCATTER_AMOUNT_TIER_6
	burst_scatter_mult = SCATTER_AMOUNT_TIER_6
	scatter_unwielded = SCATTER_AMOUNT_TIER_6
	damage_mult = BASE_BULLET_DAMAGE_MULT + BULLET_DAMAGE_MULT_TIER_4

/obj/item/weapon/gun/pistol/t73/unloaded
	current_mag = null

/obj/item/weapon/gun/pistol/t73/leader
	name = "\improper 74 式手枪"
	desc = "73 式的特殊改型，配有一体式激光瞄准系统、更舒适的握把，以及多处减重切槽，使它能够使用原来的复进簧发射更高压的弹药。由于随后采用了 NP92，74 式的产量有限，通常只应高级军官的要求配发。"
	icon = 'icons/obj/items/weapons/guns/guns_by_faction/upp.dmi'
	icon_state = "ttb"
	item_state = "ttb"
	current_mag = /obj/item/ammo_magazine/pistol/t73_impact
	flags_gun_features = GUN_AUTO_EJECTOR|GUN_CAN_POINTBLANK|GUN_ONE_HAND_WIELDED|GUN_AUTO_EJECT_CASINGS
	accepted_ammo = list(
		/obj/item/ammo_magazine/pistol/t73,
		/obj/item/ammo_magazine/pistol/t73_impact,
	)

	attachable_allowed = list(
		/obj/item/attachable/reddot,
		/obj/item/attachable/reflex,
		/obj/item/attachable/flashlight,
		/obj/item/attachable/suppressor,
		/obj/item/attachable/heavy_barrel,
	)

/obj/item/weapon/gun/pistol/t73/leader/handle_starting_attachment()
	..()
	var/obj/item/attachable/lasersight/TT = new(src)
	TT.flags_attach_features &= ~ATTACH_REMOVABLE
	TT.hidden = TRUE
	TT.Attach(src)
	update_attachable(TT.slot)

/obj/item/weapon/gun/pistol/t73/leader/set_gun_config_values()
	..()
	set_fire_delay(FIRE_DELAY_TIER_11)
	accuracy_mult = BASE_ACCURACY_MULT + HIT_ACCURACY_MULT_TIER_6
	accuracy_mult_unwielded = BASE_ACCURACY_MULT + HIT_ACCURACY_MULT_TIER_6
	scatter = SCATTER_AMOUNT_TIER_7
	burst_scatter_mult = SCATTER_AMOUNT_TIER_6
	scatter_unwielded = SCATTER_AMOUNT_TIER_7
	damage_mult = BASE_BULLET_DAMAGE_MULT + BULLET_DAMAGE_MULT_TIER_4

//-------------------------------------------------------
//KT-42 //Inspired by the .44 Auto Mag pistol
// rebalanced - slightly worse stats than the 88 mod, but uses heavy pistol bullets.

/obj/item/weapon/gun/pistol/kt42
	name = "KT-42 自动马格南手枪"
	desc = "KT-42 自动马格南是可追溯至数十年前的老旧可靠设计。型号和变体众多，但 42 型最常见。选择这门手炮不会错。"
	icon = 'icons/obj/items/weapons/guns/guns_by_faction/colony.dmi'
	icon_state = "kt42"
	item_state = "kt42"
	fire_sound = 'sound/weapons/gun_kt42.ogg'
	current_mag = /obj/item/ammo_magazine/pistol/kt42

/obj/item/weapon/gun/pistol/kt42/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 32, "muzzle_y" = 20,"rail_x" = 8, "rail_y" = 22, "under_x" = 22, "under_y" = 17, "stock_x" = 22, "stock_y" = 17, "side_rail_x" = 21, "side_rail_y" = 15)

/obj/item/weapon/gun/pistol/kt42/set_gun_config_values()
	..()
	set_fire_delay(FIRE_DELAY_TIER_11)
	accuracy_mult = BASE_ACCURACY_MULT - HIT_ACCURACY_MULT_TIER_1
	accuracy_mult_unwielded = BASE_ACCURACY_MULT - HIT_ACCURACY_MULT_TIER_2
	scatter = SCATTER_AMOUNT_TIER_6
	scatter_unwielded = SCATTER_AMOUNT_TIER_5
	damage_mult = BASE_BULLET_DAMAGE_MULT


//-------------------------------------------------------

/obj/item/weapon/gun/pistol/holdout
	name = "袖珍手枪"
	desc = "适合藏在难以触及部位的微型手枪。最好别问它是从哪里掏出来的。"
	icon = 'icons/obj/items/weapons/guns/guns_by_faction/colony.dmi'
	icon_state = "holdout"
	item_state = "holdout"

	fire_sound = 'sound/weapons/gun_pistol_holdout.ogg'
	current_mag = /obj/item/ammo_magazine/pistol/holdout
	w_class = SIZE_TINY
	force = 2
	attachable_allowed = list(
		/obj/item/attachable/suppressor,
		/obj/item/attachable/flashlight,
		/obj/item/attachable/heavy_barrel,
		/obj/item/attachable/lasersight,
		/obj/item/attachable/burstfire_assembly,
	)


/obj/item/weapon/gun/pistol/holdout/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 25, "muzzle_y" = 20,"rail_x" = 12, "rail_y" = 22, "under_x" = 17, "under_y" = 15, "stock_x" = 22, "stock_y" = 17, "side_rail_x" = 17, "side_rail_y" = 15)

/obj/item/weapon/gun/pistol/holdout/set_gun_config_values()
	..()
	set_fire_delay(FIRE_DELAY_TIER_11)
	accuracy_mult = BASE_ACCURACY_MULT
	accuracy_mult_unwielded = BASE_ACCURACY_MULT
	scatter = SCATTER_AMOUNT_TIER_6
	burst_scatter_mult = SCATTER_AMOUNT_TIER_6
	scatter_unwielded = SCATTER_AMOUNT_TIER_6
	damage_mult = BASE_BULLET_DAMAGE_MULT

/obj/item/weapon/gun/pistol/holdout/flashlight/handle_starting_attachment()
	..()
	var/obj/item/attachable/flashlight/flashlight = new(src)
	flashlight.Attach(src)
	update_attachable(flashlight.slot)

//-------------------------------------------------------
//CLF HOLDOUT PISTOL
/obj/item/weapon/gun/pistol/clfpistol
	name = "蜂鸟手枪"
	desc = "这把使用 .50 AE 弹药的手枪已被压缩到尽可能小的尺寸。据说它由进步人民联盟设计生产，再流入美洲联盟的疆域，为潜伏组织提供能击穿标准 M3 护甲的一次性武器。"
	icon = 'icons/obj/items/weapons/guns/guns_by_faction/colony.dmi'
	icon_state = "m43"
	item_state = "m43"
	flags_gun_features = GUN_AUTO_EJECTOR|GUN_CAN_POINTBLANK|GUN_ONE_HAND_WIELDED|GUN_AUTO_EJECT_CASINGS
	fire_sound = 'sound/weapons/gun_m43.ogg'
	current_mag = /obj/item/ammo_magazine/pistol/clfpistol
	w_class = SIZE_TINY
	force = 5
	attachable_allowed = null

/obj/item/weapon/gun/pistol/clfpistol/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 28, "muzzle_y" = 20,"rail_x" = 10, "rail_y" = 21, "under_x" = 21, "under_y" = 17, "stock_x" = 21, "stock_y" = 17, "side_rail_x" = 20, "side_rail_y" = 15)

/obj/item/weapon/gun/pistol/clfpistol/set_gun_config_values()
	..()
	set_fire_delay(FIRE_DELAY_TIER_12)
	accuracy_mult = BASE_ACCURACY_MULT
	accuracy_mult_unwielded = BASE_ACCURACY_MULT
	scatter = SCATTER_AMOUNT_TIER_6
	burst_scatter_mult = SCATTER_AMOUNT_TIER_5
	scatter_unwielded = SCATTER_AMOUNT_TIER_8
	scatter = SCATTER_AMOUNT_TIER_9
	damage_mult = BASE_BULLET_DAMAGE_MULT + BULLET_DAMAGE_MULT_TIER_10
	recoil = RECOIL_AMOUNT_TIER_2
	recoil_unwielded = RECOIL_AMOUNT_TIER_1

//-------------------------------------------------------

// ES-4 - Basically a CL-exclusive reskin of the 88 mod 4 that only uses less-lethal ammo.

/obj/item/weapon/gun/pistol/es4
	name = "ES-4 静电手枪"
	desc = "维兰公司制造的低致命手枪。ES-4 静电手枪最初产于 2080 年代，以高精度发射带电子弹，但价格昂贵且需频繁清洁，因此并不常见。"
	icon = 'icons/obj/items/weapons/guns/guns_by_faction/wy.dmi'
	icon_state = "es4"
	item_state = "es4"
	fire_sound = 'sound/weapons/gun_es4.ogg'
	reload_sound = 'sound/weapons/gun_vp70_reload.ogg'
	unload_sound = 'sound/weapons/gun_vp70_unload.ogg'
	current_mag = /obj/item/ammo_magazine/pistol/es4
	force = 8
	muzzleflash_iconstate = "muzzle_flash_blue"
	muzzle_flash_color = COLOR_MUZZLE_BLUE
	flags_gun_features = GUN_AUTO_EJECTOR|GUN_CAN_POINTBLANK|GUN_ONE_HAND_WIELDED|GUN_AMMO_COUNTER|GUN_AUTO_EJECT_CASINGS
	attachable_allowed = list(
		/obj/item/attachable/flashlight,
		/obj/item/attachable/reflex,
		/obj/item/attachable/reddot,
		/obj/item/attachable/lasersight,
	)

/obj/item/weapon/gun/pistol/es4/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 27, "muzzle_y" = 21, "rail_x" = 10, "rail_y" = 22, "under_x" = 25, "under_y" = 18, "stock_x" = 18, "stock_y" = 15, "side_rail_x" = 25, "side_rail_y" = 18)


/obj/item/weapon/gun/pistol/es4/set_gun_config_values()
	..()
	fire_delay = FIRE_DELAY_TIER_11
	accuracy_mult = BASE_ACCURACY_MULT
	accuracy_mult_unwielded = BASE_ACCURACY_MULT
	scatter = SCATTER_AMOUNT_TIER_7
	scatter_unwielded = SCATTER_AMOUNT_TIER_7
	damage_mult = BASE_BULLET_DAMAGE_MULT + BULLET_DAMAGE_MULT_TIER_4

/obj/item/weapon/gun/pistol/es4/unloaded
	current_mag = null

//-------------------------------------------------------
//VP78 - High power pistol?

/obj/item/weapon/gun/pistol/vp78
	name = "VP78 手枪"
	desc = "基于伯莱塔武器专利设计的大型强力半自动手枪，使用超压 9mm 弹药。在美洲联盟和三世界帝国宙域都很常见，装备精良的维兰德-汤谷人员常持有它。"
	icon_state = "vp78"
	item_state = "b92fs"
	fire_sound = 'sound/weapons/gun_vp78_v2.ogg'
	reload_sound = 'sound/weapons/gun_vp78_reload.ogg'
	unload_sound = 'sound/weapons/gun_vp78_unload.ogg'
	current_mag = /obj/item/ammo_magazine/pistol/vp78
	force = 8
	flags_gun_features = GUN_AUTO_EJECTOR|GUN_CAN_POINTBLANK|GUN_ONE_HAND_WIELDED|GUN_AUTO_EJECT_CASINGS
	attachable_allowed = list(
		/obj/item/attachable/suppressor,
		/obj/item/attachable/reddot,
		/obj/item/attachable/reflex,
		/obj/item/attachable/flashlight/laser_light_combo,
		/obj/item/attachable/extended_barrel,
	)

/obj/item/weapon/gun/pistol/vp78/handle_starting_attachment()
	..()
	var/obj/item/attachable/flashlight/laser_light_combo/VP = new(src)
	VP.flags_attach_features &= ~ATTACH_REMOVABLE
	VP.hidden = FALSE
	VP.Attach(src)
	update_attachable(VP.slot)

/obj/item/weapon/gun/pistol/vp78/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 29, "muzzle_y" = 21,"rail_x" = 10, "rail_y" = 23, "under_x" = 22, "under_y" = 15, "stock_x" = 18, "stock_y" = 14, "side_rail_x" = 21, "side_rail_y" = 14)


/obj/item/weapon/gun/pistol/vp78/set_gun_config_values()
	..()
	set_fire_delay(FIRE_DELAY_TIER_9)
	set_burst_amount(BURST_AMOUNT_TIER_3)
	set_burst_delay(FIRE_DELAY_TIER_11)
	accuracy_mult = BASE_ACCURACY_MULT + HIT_ACCURACY_MULT_TIER_6
	accuracy_mult_unwielded = BASE_ACCURACY_MULT
	scatter = SCATTER_AMOUNT_TIER_9
	burst_scatter_mult = SCATTER_AMOUNT_TIER_7
	scatter_unwielded = SCATTER_AMOUNT_TIER_5
	damage_mult = BASE_BULLET_DAMAGE_MULT
	recoil = RECOIL_AMOUNT_TIER_5
	recoil_unwielded = RECOIL_AMOUNT_TIER_4

/obj/item/weapon/gun/pistol/vp78/unloaded
	current_mag = null

/obj/item/weapon/gun/pistol/vp78/rmc
	name = "L165A1 制式手枪"
	desc = "皇家陆战突击队制式手枪。现代、利落的半自动手枪，专为 9x19mm 爆破碎甲弹设计。维兰德-汤谷基于伯莱塔武器专利设计的改型，赢得了三世界帝国精锐士兵的信赖，也能正常使用普通 VP78 弹匣。"
	current_mag = /obj/item/ammo_magazine/pistol/vp78/rmc
	start_automatic = TRUE

/obj/item/weapon/gun/pistol/vp78/rmc/unloaded
	current_mag = null

//-------------------------------------------------------
/*
Auto 9 The gun RoboCop uses. A better version of the VP78, with more rounds per magazine. Probably the best pistol around, but takes no attachments.
It is a modified Beretta 93R, and can fire three-round burst or single fire. Whether or not anyone else aside RoboCop can use it is not established.
*/

/obj/item/weapon/gun/pistol/auto9
	name = "\improper Auto-9 手枪"
	desc = "先进的可选射击模式自动手枪，能够三发点射。上次有人见到它时，它还在底特律的罪恶街头清扫犯罪。"
	icon = 'icons/obj/items/weapons/guns/guns_by_faction/event.dmi'
	icon_state = "auto9"
	item_state = "auto9"

	fire_sound = 'sound/weapons/gun_pistol_large.ogg'
	current_mag = /obj/item/ammo_magazine/pistol/auto9
	force = 15

/obj/item/weapon/gun/pistol/auto9/set_gun_config_values()
	..()
	set_fire_delay(FIRE_DELAY_TIER_7)
	set_burst_amount(BURST_AMOUNT_TIER_3)
	set_burst_delay(FIRE_DELAY_TIER_12)
	accuracy_mult = BASE_ACCURACY_MULT
	accuracy_mult_unwielded = BASE_ACCURACY_MULT
	scatter = SCATTER_AMOUNT_TIER_6
	burst_scatter_mult = SCATTER_AMOUNT_TIER_6
	scatter_unwielded = SCATTER_AMOUNT_TIER_6
	damage_mult = BASE_BULLET_DAMAGE_MULT
	recoil = RECOIL_AMOUNT_TIER_5
	recoil_unwielded = RECOIL_AMOUNT_TIER_3


//-------------------------------------------------------
//Beretta 92FS, the gun McClane carries around in Die Hard. Very similar to the service pistol, all around.

/obj/item/weapon/gun/pistol/b92fs
	name = "伯莱塔 92FS M9 手枪"
	desc = "美国陆军的半自动 9mm 制式手枪，在民用市场的执法与私人安保领域也很受欢迎。"
	icon = 'icons/obj/items/weapons/guns/guns_by_faction/colony.dmi'
	icon_state = "b92fs"
	item_state = "b92fs"
	fire_sound = "vp70"
	current_mag = /obj/item/ammo_magazine/pistol/b92fs

/obj/item/weapon/gun/pistol/b92fs/Initialize(mapload, spawn_empty)
	. = ..()
	if(prob(10))
		name = "伯莱塔 93FR 点射手枪"
		desc += "这是一把限量配发警用的伯莱塔 93FR 点射手枪。精度不算高，建议加装配件。"
		var/obj/item/attachable/burstfire_assembly/BFA = new(src)
		BFA.flags_attach_features &= ~ATTACH_REMOVABLE
		BFA.Attach(src)
		update_attachable(BFA.slot)
		add_firemode(GUN_FIREMODE_BURSTFIRE)

/obj/item/weapon/gun/pistol/b92fs/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 28, "muzzle_y" = 20,"rail_x" = 10, "rail_y" = 22, "under_x" = 21, "under_y" = 17, "stock_x" = 21, "stock_y" = 17, "side_rail_x" = 21, "side_rail_y" = 17)

/obj/item/weapon/gun/pistol/b92fs/set_gun_config_values()
	..()
	set_fire_delay(FIRE_DELAY_TIER_12)
	accuracy_mult = BASE_ACCURACY_MULT + HIT_ACCURACY_MULT_TIER_5
	accuracy_mult_unwielded = BASE_ACCURACY_MULT
	scatter = SCATTER_AMOUNT_TIER_7
	burst_scatter_mult = SCATTER_AMOUNT_TIER_5
	scatter_unwielded = SCATTER_AMOUNT_TIER_7
	damage_mult = BASE_BULLET_DAMAGE_MULT

/obj/item/weapon/gun/pistol/b92fs/modded
	starting_attachment_types = list(/obj/item/attachable/suppressor, /obj/item/attachable/lasersight, /obj/item/attachable/reflex)


//-------------------------------------------------------
//DEAGLE //This one is obvious.

/obj/item/weapon/gun/pistol/heavy
	name = "古董沙漠之鹰"
	desc = "一把后坐力惊人的笨重 .50 口径手枪，大概从某家博物馆里拿来的。上面刻着：“以优势火力铸就和平。”"
	icon = 'icons/obj/items/weapons/guns/guns_by_faction/colony.dmi'
	icon_state = "deagle"
	item_state = "deagle"
	fire_sound = 'sound/weapons/gun_DE50.ogg'
	current_mag = /obj/item/ammo_magazine/pistol/heavy
	force = 13

	attachable_allowed = list(
		/obj/item/attachable/reddot,
		/obj/item/attachable/reflex,
		/obj/item/attachable/flashlight,
		/obj/item/attachable/extended_barrel,
		/obj/item/attachable/heavy_barrel,
		/obj/item/attachable/lasersight,
		/obj/item/attachable/compensator,
	)


/obj/item/weapon/gun/pistol/heavy/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 30, "muzzle_y" = 20,"rail_x" = 17, "rail_y" = 21, "under_x" = 20, "under_y" = 17, "stock_x" = 20, "stock_y" = 17, "side_rail_x" = 20, "side_rail_y" = 17)


/obj/item/weapon/gun/pistol/heavy/set_gun_config_values()
	..()
	set_fire_delay(FIRE_DELAY_TIER_5)
	set_burst_amount(BURST_AMOUNT_TIER_2)
	set_burst_delay(FIRE_DELAY_TIER_8)
	accuracy_mult = BASE_ACCURACY_MULT
	accuracy_mult_unwielded = BASE_ACCURACY_MULT - HIT_ACCURACY_MULT_TIER_5
	scatter = SCATTER_AMOUNT_TIER_6
	burst_scatter_mult = SCATTER_AMOUNT_TIER_6
	scatter_unwielded = SCATTER_AMOUNT_TIER_6
	damage_mult = BASE_BULLET_DAMAGE_MULT + BULLET_DAMAGE_MULT_TIER_1
	recoil = RECOIL_AMOUNT_TIER_5
	recoil_unwielded = RECOIL_AMOUNT_TIER_3

/obj/item/weapon/gun/pistol/heavy/co
	name = "抛光古董沙漠之鹰"
	desc = "无需介绍的手炮。.50 口径沙漠之鹰昂贵、笨重，作为手枪而言重得惊人，但能让熊当场倒下的威力弥补了这一切。经典、华丽，最重要的是，极其致命。"
	icon = 'icons/obj/items/weapons/guns/guns_by_faction/colony.dmi'
	icon_state = "c_deagle"
	item_state = "c_deagle"
	base_gun_icon = "c_deagle"
	current_mag = /obj/item/ammo_magazine/pistol/heavy/super/highimpact
	black_market_value = 100

/obj/item/weapon/gun/pistol/heavy/co/set_gun_config_values()
	..()
	set_fire_delay(FIRE_DELAY_TIER_5)
	accuracy_mult = BASE_ACCURACY_MULT + HIT_ACCURACY_MULT_TIER_4
	accuracy_mult_unwielded = BASE_ACCURACY_MULT - HIT_ACCURACY_MULT_TIER_7
	scatter = SCATTER_AMOUNT_TIER_6
	burst_scatter_mult = SCATTER_AMOUNT_TIER_4
	scatter_unwielded = SCATTER_AMOUNT_TIER_3
	damage_mult = BASE_BULLET_DAMAGE_MULT + BULLET_DAMAGE_MULT_TIER_8
	recoil = RECOIL_AMOUNT_TIER_3
	recoil_unwielded = RECOIL_AMOUNT_TIER_2

/obj/item/weapon/gun/pistol/heavy/co/gold
	name = "镀金古董沙漠之鹰"
	desc = "一把经金色阳极氧化处理、配有红木握把的沙漠之鹰。它就是奢华的代名词：耀眼、难用、沉得要命，后坐力像骡子踢人。但若论权力的象征，没有什么能与之相比。"
	icon_state = "g_deagle"
	item_state = "g_deagle"
	base_gun_icon = "g_deagle"

//-------------------------------------------------------
//The first rule of monkey pistol is we don't talk about monkey pistol.

/obj/item/weapon/gun/pistol/chimp
	name = "\improper CHIMP70 手枪"
	desc = "一种威力强大的副武器，主要配发给训练有素的精英亡灵机械刺客特工。"
	icon = 'icons/obj/items/weapons/guns/guns_by_faction/event.dmi'
	icon_state = "c70"
	item_state = "c70"

	current_mag = /obj/item/ammo_magazine/pistol/chimp
	fire_sound = 'sound/weapons/gun_chimp70.ogg'
	w_class = SIZE_MEDIUM
	force = 8
	flags_gun_features = GUN_AUTO_EJECTOR

/obj/item/weapon/gun/pistol/chimp/set_gun_config_values()
	..()
	set_fire_delay(FIRE_DELAY_TIER_9)
	set_burst_delay(FIRE_DELAY_TIER_11)
	set_burst_amount(BURST_AMOUNT_TIER_2)
	accuracy_mult = BASE_ACCURACY_MULT
	accuracy_mult_unwielded = BASE_ACCURACY_MULT
	scatter = SCATTER_AMOUNT_TIER_6
	burst_scatter_mult = SCATTER_AMOUNT_TIER_6
	scatter_unwielded = SCATTER_AMOUNT_TIER_6
	damage_mult = BASE_BULLET_DAMAGE_MULT


//-------------------------------------------------------
//Smartpistol. An IFF pistol, pretty much.

/obj/item/weapon/gun/pistol/smart
	name = "SU-6 智能手枪"
	desc = "SU-6 智能手枪是基于敌我识别系统的副武器，目前正由殖民地陆战队进行实地测试。使用改装 .45 ACP 敌我识别子弹，可点射。"
	icon = 'icons/obj/items/weapons/guns/guns_by_faction/uscm.dmi'
	icon_state = "smartpistol"
	item_state = "smartpistol"
	force = 8
	current_mag = /obj/item/ammo_magazine/pistol/smart
	fire_sound = 'sound/weapons/gun_su6.ogg'
	reload_sound = 'sound/weapons/handling/gun_su6_reload.ogg'
	unload_sound = 'sound/weapons/handling/gun_su6_unload.ogg'
	flags_gun_features = GUN_AUTO_EJECTOR|GUN_CAN_POINTBLANK|GUN_ONE_HAND_WIELDED|GUN_AMMO_COUNTER|GUN_AUTO_EJECT_CASINGS

/obj/item/weapon/gun/pistol/smart/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 28, "muzzle_y" = 20,"rail_x" = 13, "rail_y" = 22, "under_x" = 24, "under_y" = 17, "stock_x" = 24, "stock_y" = 17, "side_rail_x" = 24, "side_rail_y" = 17)

/obj/item/weapon/gun/pistol/smart/set_gun_config_values()
	..()
	set_fire_delay(FIRE_DELAY_TIER_12)
	set_burst_amount(BURST_AMOUNT_TIER_3)
	set_burst_delay(FIRE_DELAY_TIER_11)
	accuracy_mult = BASE_ACCURACY_MULT
	accuracy_mult_unwielded = BASE_ACCURACY_MULT
	scatter = SCATTER_AMOUNT_TIER_6
	burst_scatter_mult = SCATTER_AMOUNT_TIER_6
	scatter_unwielded = SCATTER_AMOUNT_TIER_6
	damage_mult = BASE_BULLET_DAMAGE_MULT
	recoil = RECOIL_AMOUNT_TIER_5
	recoil_unwielded = RECOIL_AMOUNT_TIER_4

/obj/item/weapon/gun/pistol/smart/set_bullet_traits()
	LAZYADD(traits_to_give, list(
		BULLET_TRAIT_ENTRY(/datum/element/bullet_trait_iff)
	))

//-------------------------------------------------------
//SKORPION //Based on the same thing.

/obj/item/weapon/gun/pistol/skorpion
	name = "CZ-81 自动手枪"
	desc = "坚固的 20 世纪枪械，介于手枪和冲锋枪之间。使用 20 发弹匣发射 .32 ACP 子弹。"
	icon = 'icons/obj/items/weapons/guns/guns_by_faction/colony.dmi'
	icon_state = "skorpion"
	item_state = "skorpion"

	fire_sound = 'sound/weapons/gun_skorpion.ogg'
	current_mag = /obj/item/ammo_magazine/pistol/skorpion
	flags_gun_features = GUN_AUTO_EJECTOR|GUN_CAN_POINTBLANK|GUN_ONE_HAND_WIELDED|GUN_AUTO_EJECT_CASINGS
	attachable_allowed = list(
		/obj/item/attachable/reddot, //Rail
		/obj/item/attachable/reflex,
		/obj/item/attachable/flashlight,
		/obj/item/attachable/suppressor, //Muzzle
		/obj/item/attachable/compensator,
		/obj/item/attachable/extended_barrel,
		/obj/item/attachable/heavy_barrel,
		/obj/item/attachable/lasersight, //Underbarrel
		/obj/item/attachable/burstfire_assembly,
	)
	start_semiauto = FALSE
	start_automatic = TRUE

/obj/item/weapon/gun/pistol/skorpion/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 29, "muzzle_y" = 18,"rail_x" = 16, "rail_y" = 21, "under_x" = 23, "under_y" = 15, "stock_x" = 23, "stock_y" = 15, "side_rail_x" = 23, "side_rail_y" = 15)

/obj/item/weapon/gun/pistol/skorpion/set_gun_config_values()
	..()
	set_fire_delay(FIRE_DELAY_TIER_11)
	fa_scatter_peak = 15 //shots
	fa_max_scatter = SCATTER_AMOUNT_TIER_5

	accuracy_mult = BASE_ACCURACY_MULT
	scatter = SCATTER_AMOUNT_TIER_7
	damage_mult = BASE_BULLET_DAMAGE_MULT + BULLET_DAMAGE_MULT_TIER_2
