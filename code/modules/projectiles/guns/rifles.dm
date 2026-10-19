//-------------------------------------------------------

/obj/item/weapon/gun/rifle
	reload_sound = 'sound/weapons/gun_rifle_reload.ogg'
	cocked_sound = 'sound/weapons/gun_cocked2.ogg'

	flags_equip_slot = SLOT_BACK
	w_class = SIZE_LARGE
	force = 5
	flags_gun_features = GUN_AUTO_EJECTOR|GUN_CAN_POINTBLANK|GUN_AUTO_EJECT_CASINGS
	gun_category = GUN_CATEGORY_RIFLE
	aim_slowdown = SLOWDOWN_ADS_RIFLE
	wield_delay = WIELD_DELAY_NORMAL

/obj/item/weapon/gun/rifle/Initialize(mapload, spawn_empty)
	. = ..()
	if(current_mag && current_mag.current_rounds > 0) load_into_chamber()

/obj/item/weapon/gun/rifle/set_gun_config_values()
	..()
	set_fire_delay(FIRE_DELAY_TIER_5)
	set_burst_amount(BURST_AMOUNT_TIER_3)
	set_burst_delay(FIRE_DELAY_TIER_11)
	accuracy_mult = BASE_ACCURACY_MULT
	accuracy_mult_unwielded = BASE_ACCURACY_MULT - HIT_ACCURACY_MULT_TIER_7
	scatter = SCATTER_AMOUNT_TIER_6
	scatter_unwielded = SCATTER_AMOUNT_TIER_2
	damage_mult = BASE_BULLET_DAMAGE_MULT
	recoil_unwielded = RECOIL_AMOUNT_TIER_2

/obj/item/weapon/gun/rifle/unique_action(mob/user)
	cock(user)

//-------------------------------------------------------
//M41A PULSE RIFLE

/obj/item/weapon/gun/rifle/m41a
	name = "M41A 脉冲步枪 MK2"
	desc = "殖民地陆战队制式步枪，大多数战斗人员都会携带。使用 10x24mm 无壳弹。"
	icon = 'icons/obj/items/weapons/guns/guns_by_faction/uscm.dmi'
	icon_state = "m41a"
	item_state = "m41a"
	fire_sound = "gun_pulse"
	reload_sound = 'sound/weapons/handling/m41_reload.ogg'
	unload_sound = 'sound/weapons/handling/m41_unload.ogg'
	current_mag = /obj/item/ammo_magazine/rifle
	attachable_allowed = list(
		/obj/item/attachable/suppressor,
		/obj/item/attachable/bayonet,
		/obj/item/attachable/bayonet/upp,
		/obj/item/attachable/bayonet/co2,
		/obj/item/attachable/reddot,
		/obj/item/attachable/reflex,
		/obj/item/attachable/verticalgrip,
		/obj/item/attachable/angledgrip,
		/obj/item/attachable/lasersight,
		/obj/item/attachable/gyro,
		/obj/item/attachable/flashlight,
		/obj/item/attachable/bipod,
		/obj/item/attachable/extended_barrel,
		/obj/item/attachable/heavy_barrel,
		/obj/item/attachable/magnetic_harness,
		/obj/item/attachable/stock/rifle,
		/obj/item/attachable/stock/rifle/collapsible,
		/obj/item/attachable/attached_gun/grenade/mk1,
		/obj/item/attachable/attached_gun/flamer,
		/obj/item/attachable/attached_gun/flamer/advanced,
		/obj/item/attachable/attached_gun/shotgun,
		/obj/item/attachable/attached_gun/extinguisher,
		/obj/item/attachable/scope,
		/obj/item/attachable/scope/mini,
	)
	flags_gun_features = GUN_AUTO_EJECTOR|GUN_CAN_POINTBLANK|GUN_AMMO_COUNTER
	starting_attachment_types = list(/obj/item/attachable/attached_gun/grenade/mk1, /obj/item/attachable/stock/rifle/collapsible)
	map_specific_decoration = TRUE
	start_automatic = TRUE

/obj/item/weapon/gun/rifle/m41a/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 32, "muzzle_y" = 18,"rail_x" = 12, "rail_y" = 23, "under_x" = 24, "under_y" = 13, "stock_x" = 24, "stock_y" = 13, "side_rail_x" = 26, "side_rail_y" = 17)


/obj/item/weapon/gun/rifle/m41a/set_gun_config_values()
	..()
	set_fire_delay(FIRE_DELAY_TIER_11)
	set_burst_amount(BURST_AMOUNT_TIER_3)
	set_burst_delay(FIRE_DELAY_TIER_11)
	accuracy_mult = BASE_ACCURACY_MULT + HIT_ACCURACY_MULT_TIER_4 + 2*HIT_ACCURACY_MULT_TIER_1
	accuracy_mult_unwielded = BASE_ACCURACY_MULT - HIT_ACCURACY_MULT_TIER_7
	scatter = SCATTER_AMOUNT_TIER_8
	burst_scatter_mult = SCATTER_AMOUNT_TIER_10
	scatter_unwielded = SCATTER_AMOUNT_TIER_2
	damage_mult = BASE_BULLET_DAMAGE_MULT
	recoil_unwielded = RECOIL_AMOUNT_TIER_2


//variant without ugl attachment
/obj/item/weapon/gun/rifle/m41a/stripped
	starting_attachment_types = list()


/obj/item/weapon/gun/rifle/m41a/training
	current_mag = /obj/item/ammo_magazine/rifle/rubber


/obj/item/weapon/gun/rifle/m41a/tactical
	current_mag = /obj/item/ammo_magazine/rifle/ap
	starting_attachment_types = list(/obj/item/attachable/magnetic_harness, /obj/item/attachable/suppressor, /obj/item/attachable/angledgrip, /obj/item/attachable/stock/rifle/collapsible)
//-------------------------------------------------------
//NSG 23 ASSAULT RIFLE - RMC PRIMARY RIFLE

/obj/item/weapon/gun/rifle/nsg23
	name = "NSG 23 脉冲步枪"
	desc = "各类 W-Y 人员使用的脉冲式 8.5x33mm 无壳突击步枪，性能与阿玛特 M41A 系列相近，操控性稍好。"
	icon = 'icons/obj/items/weapons/guns/guns_by_faction/wy.dmi'
	icon_state = "nsg23"
	item_state = "nsg23"
	fire_sound = "gun_nsg23"
	reload_sound = 'sound/weapons/handling/m41_reload.ogg'
	unload_sound = 'sound/weapons/handling/m41_unload.ogg'
	cocked_sound = 'sound/weapons/handling/nsg23_cocked.ogg'
	aim_slowdown = SLOWDOWN_ADS_QUICK
	wield_delay = WIELD_DELAY_VERY_FAST
	flags_gun_features = GUN_AUTO_EJECTOR|GUN_CAN_POINTBLANK|GUN_AMMO_COUNTER|GUN_WY_RESTRICTED
	start_automatic = TRUE
	current_mag = /obj/item/ammo_magazine/rifle/nsg23
	attachable_allowed = list(
		/obj/item/attachable/suppressor,
		/obj/item/attachable/bayonet/rmc,
		/obj/item/attachable/reddot,
		/obj/item/attachable/reflex,
		/obj/item/attachable/flashlight,
		/obj/item/attachable/stock/nsg23,
		/obj/item/attachable/stock/nsg23/rmc,
		/obj/item/attachable/scope/mini/nsg23,
		/obj/item/attachable/attached_gun/grenade/nsg,
	)

	starting_attachment_types = list(
		/obj/item/attachable/scope/mini/nsg23,
		/obj/item/attachable/stock/nsg23,
	)

/obj/item/weapon/gun/rifle/nsg23/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 32, "muzzle_y" = 16,"rail_x" = 13, "rail_y" = 20, "under_x" = 19, "under_y" = 11, "stock_x" = 5, "stock_y" = 17, "side_rail_x" = 24, "side_rail_y" = 16)

/obj/item/weapon/gun/rifle/nsg23/set_gun_config_values()
	..()
	set_fire_delay(FIRE_DELAY_TIER_10)
	set_burst_amount(BURST_AMOUNT_TIER_3)
	set_burst_delay(FIRE_DELAY_TIER_10)
	accuracy_mult = BASE_ACCURACY_MULT + HIT_ACCURACY_MULT_TIER_10
	accuracy_mult_unwielded = BASE_ACCURACY_MULT - HIT_ACCURACY_MULT_TIER_7
	scatter = SCATTER_AMOUNT_TIER_10
	burst_scatter_mult = SCATTER_AMOUNT_TIER_10
	scatter_unwielded = SCATTER_AMOUNT_TIER_2
	damage_mult = BASE_BULLET_DAMAGE_MULT + BULLET_DAMAGE_MULT_TIER_5
	recoil_unwielded = RECOIL_AMOUNT_TIER_2
	damage_falloff_mult = 0
	fa_max_scatter = SCATTER_AMOUNT_TIER_7

/obj/item/weapon/gun/rifle/nsg23/no_lock
	flags_gun_features = GUN_AUTO_EJECTOR|GUN_CAN_POINTBLANK|GUN_AMMO_COUNTER

/obj/item/weapon/gun/rifle/nsg23/no_lock/pve
	starting_attachment_types = list(
		/obj/item/attachable/scope/mini/nsg23,
		/obj/item/attachable/stock/nsg23,
		/obj/item/attachable/attached_gun/flamer/advanced,
	)

/obj/item/weapon/gun/rifle/nsg23/no_lock/pve/heap
	current_mag = /obj/item/ammo_magazine/rifle/nsg23/heap

/obj/item/weapon/gun/rifle/nsg23/rmc
	name = "\improper NSG L23A1 脉冲步枪"
	desc = "皇家陆战突击队使用的 8.5×33 毫米无壳脉冲突击步枪，每位突击队员的贴身伙伴。拥有半自动与点射模式，配有一体式 30 毫米榴弹发射器，除膛内一发外还能储备两发榴弹。"
	icon = 'icons/obj/items/weapons/guns/guns_by_faction/twe_guns.dmi'
	icon_state = "rmc_nsg23"
	item_state = "rmc_nsg23"
	flags_gun_features = GUN_AUTO_EJECTOR|GUN_CAN_POINTBLANK|GUN_AMMO_COUNTER
	start_automatic = FALSE
	start_burstfire = TRUE
	starting_attachment_types = list(
		/obj/item/attachable/scope/mini/nsg23/rmc,
		/obj/item/attachable/attached_gun/grenade/nsg,
		/obj/item/attachable/stock/nsg23/rmc,
	)

/obj/item/weapon/gun/rifle/nsg23/rmc/set_gun_config_values()
	..()
	set_fire_delay(FIRE_DELAY_TIER_10)
	set_burst_amount(BURST_AMOUNT_TIER_3)
	set_burst_delay(FIRE_DELAY_TIER_12)
	accuracy_mult = BASE_ACCURACY_MULT + HIT_ACCURACY_MULT_TIER_10
	accuracy_mult_unwielded = BASE_ACCURACY_MULT - HIT_ACCURACY_MULT_TIER_7
	scatter = SCATTER_AMOUNT_TIER_9
	burst_scatter_mult = SCATTER_AMOUNT_TIER_10
	scatter_unwielded = SCATTER_AMOUNT_TIER_2
	damage_mult = BASE_BULLET_DAMAGE_MULT
	recoil_unwielded = RECOIL_AMOUNT_TIER_2
	damage_falloff_mult = 0
	fa_max_scatter = SCATTER_AMOUNT_TIER_5

/obj/item/weapon/gun/rifle/nsg23/rmc/Initialize(mapload, spawn_empty)
	. = ..()
	if(current_mag && current_mag.current_rounds > 0) load_into_chamber()

/obj/item/weapon/gun/rifle/nsg23/rmc/unloaded
	current_mag = null
	flags_gun_features = GUN_AUTO_EJECTOR|GUN_CAN_POINTBLANK|GUN_AMMO_COUNTER|GUN_TRIGGER_SAFETY

/obj/item/weapon/gun/rifle/nsg23/rmc/preloaded
	starting_attachment_types = list(
		/obj/item/attachable/scope/mini/nsg23/rmc,
		/obj/item/attachable/attached_gun/grenade/nsg/preloaded,
		/obj/item/attachable/stock/nsg23/rmc,
	)

/obj/item/weapon/gun/rifle/nsg23/rmc/preloaded/tactical
	starting_attachment_types = list(
		/obj/item/attachable/scope/mini/nsg23/rmc,
		/obj/item/attachable/attached_gun/grenade/nsg/preloaded,
		/obj/item/attachable/stock/nsg23/rmc,
		/obj/item/attachable/suppressor,
	)


//M40-SD AKA SOF RIFLE FROM HELL (It's actually an M41A, don't tell!)

/obj/item/weapon/gun/rifle/m41aMK1/xm40
	name = "\improper XM40 脉冲步枪"
	desc = "M41 系列的实验性前身之一，除精英陆战队单位外从未大规模采用。在美国殖民地陆战队仍在生产的步枪中，只有它配备一体式消声器。点射模式极其致命。"
	icon_state = "m40sd"
	item_state = "m40sd"
	reload_sound = 'sound/weapons/handling/m40sd_reload.ogg'
	unload_sound = 'sound/weapons/handling/m40sd_unload.ogg'
	unacidable = TRUE
	indestructible = TRUE

	current_mag = /obj/item/ammo_magazine/rifle/xm40/heap
	flags_gun_features = GUN_AUTO_EJECTOR|GUN_CAN_POINTBLANK|GUN_AMMO_COUNTER
	aim_slowdown = SLOWDOWN_ADS_QUICK
	wield_delay = WIELD_DELAY_FAST
	map_specific_decoration = FALSE
	starting_attachment_types = list()
	accepted_ammo = list(
		/obj/item/ammo_magazine/rifle/xm40,
		/obj/item/ammo_magazine/rifle/xm40/heap,
	)
	attachable_allowed = list(
		/obj/item/attachable/suppressor/xm40_integral,//no rail attachies
		/obj/item/attachable/verticalgrip,
		/obj/item/attachable/angledgrip,
		/obj/item/attachable/lasersight,
		/obj/item/attachable/gyro,
		/obj/item/attachable/bipod,
		/obj/item/attachable/burstfire_assembly,
		/obj/item/attachable/magnetic_harness,
		/obj/item/attachable/attached_gun/grenade,
		/obj/item/attachable/attached_gun/flamer,
		/obj/item/attachable/attached_gun/flamer/advanced,
		/obj/item/attachable/attached_gun/shotgun,
		/obj/item/attachable/attached_gun/extinguisher,
		)

	random_spawn_chance = 0

/obj/item/weapon/gun/rifle/m41a/elite/xm40/handle_starting_attachment()
	..()
	var/obj/item/attachable/suppressor/xm40_integral/S = new(src)
	S.flags_attach_features &= ~ATTACH_REMOVABLE
	S.hidden = FALSE
	S.Attach(src)
	update_attachable(S.slot)

	var/obj/item/attachable/magnetic_harness/H = new(src)//integrated mag harness, no rail attachies
	H.flags_attach_features &= ~ATTACH_REMOVABLE
	H.hidden = TRUE
	H.Attach(src)
	update_attachable(H.slot)

/obj/item/weapon/gun/rifle/m41a/elite/xm40/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 32, "muzzle_y" = 17,"rail_x" = 12, "rail_y" = 23, "under_x" = 24, "under_y" = 13, "stock_x" = 24, "stock_y" = 13, "side_rail_x" = 25, "side_rail_y" = 17)

/obj/item/weapon/gun/rifle/m41a/elite/xm40/set_gun_config_values()
	..()
	set_fire_delay(FIRE_DELAY_TIER_11)
	set_burst_amount(BURST_AMOUNT_TIER_3)
	set_burst_delay(FIRE_DELAY_TIER_12)
	accuracy_mult = BASE_ACCURACY_MULT + HIT_ACCURACY_MULT_TIER_10
	accuracy_mult_unwielded = BASE_ACCURACY_MULT - HIT_ACCURACY_MULT_TIER_4
	scatter = SCATTER_AMOUNT_TIER_10
	burst_scatter_mult = SCATTER_AMOUNT_TIER_10
	scatter_unwielded = SCATTER_AMOUNT_TIER_4

/obj/item/weapon/gun/rifle/m41a/elite/xm40/ap
	current_mag = /obj/item/ammo_magazine/rifle/xm40
//-------------------------------------------------------
//M41A TRUE AND ORIGINAL

/obj/item/weapon/gun/rifle/m41aMK1
	name = "M41A 脉冲步枪"
	desc = "USCMC 的脉冲式 10x24mm 无壳突击步枪，每位陆战队员的亲密伙伴。内置 30mm 榴弹发射器和可存放四枚备用榴弹的弹药管。"
	icon = 'icons/obj/items/weapons/guns/guns_by_faction/uscm.dmi'
	icon_state = "m41amk1" //Placeholder.
	item_state = "m41amk1" //Placeholder.
	fire_sound = "gun_pulse"
	reload_sound = 'sound/weapons/handling/m41_reload.ogg'
	unload_sound = 'sound/weapons/handling/m41_unload.ogg'
	current_mag = /obj/item/ammo_magazine/rifle/m41aMK1
	attachable_allowed = list(
		/obj/item/attachable/suppressor,
		/obj/item/attachable/reddot,
		/obj/item/attachable/magnetic_harness,
		/obj/item/attachable/flashlight,
		/obj/item/attachable/reflex,
		/obj/item/attachable/scope/pve,
		/obj/item/attachable/attached_gun/grenade/mk1,
		/obj/item/attachable/stock/rifle/collapsible,
		/obj/item/attachable/sling,
	)

	flags_gun_features = GUN_AUTO_EJECTOR|GUN_CAN_POINTBLANK|GUN_AMMO_COUNTER
	starting_attachment_types = list(/obj/item/attachable/attached_gun/grenade/mk1, /obj/item/attachable/stock/rifle/collapsible)
	start_automatic = TRUE

/obj/item/weapon/gun/rifle/m41aMK1/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 32, "muzzle_y" = 18,"rail_x" = 12, "rail_y" = 23, "under_x" = 23, "under_y" = 13, "stock_x" = 24, "stock_y" = 14, "side_rail_x" = 23, "side_rail_y" = 16)


/obj/item/weapon/gun/rifle/m41aMK1/set_gun_config_values()
	..()
	set_fire_delay(FIRE_DELAY_TIER_11)
	set_burst_amount(BURST_AMOUNT_TIER_4)
	set_burst_delay(FIRE_DELAY_TIER_11)
	accuracy_mult = BASE_ACCURACY_MULT + HIT_ACCURACY_MULT_TIER_3
	accuracy_mult_unwielded = BASE_ACCURACY_MULT - HIT_ACCURACY_MULT_TIER_7
	scatter = SCATTER_AMOUNT_TIER_9
	burst_scatter_mult = SCATTER_AMOUNT_TIER_9
	scatter_unwielded = SCATTER_AMOUNT_TIER_2
	damage_mult = BASE_BULLET_DAMAGE_MULT
	damage_falloff_mult = 0
	recoil_unwielded = RECOIL_AMOUNT_TIER_2

/obj/item/weapon/gun/rifle/m41aMK1/ap //for making it start with ap loaded
	current_mag = /obj/item/ammo_magazine/rifle/m41aMK1/ap

/obj/item/weapon/gun/rifle/m41aMK1/unloaded //for making it start unloaded and with the safety on
	current_mag = null
	flags_gun_features = GUN_AUTO_EJECTOR|GUN_CAN_POINTBLANK|GUN_AMMO_COUNTER|GUN_TRIGGER_SAFETY

/obj/item/weapon/gun/rifle/m41aMK1/preloaded
	starting_attachment_types = list(/obj/item/attachable/attached_gun/grenade/mk1/preloaded, /obj/item/attachable/stock/rifle/collapsible)
	current_mag = /obj/item/ammo_magazine/rifle/m41aMK1

/obj/item/weapon/gun/rifle/m41aMK1/tactical
	starting_attachment_types = list(/obj/item/attachable/attached_gun/grenade/mk1/preloaded, /obj/item/attachable/suppressor, /obj/item/attachable/magnetic_harness, /obj/item/attachable/stock/rifle/collapsible)
	current_mag = /obj/item/ammo_magazine/rifle/m41aMK1

/obj/item/weapon/gun/rifle/m41aMK1/forecon
	desc = "美国殖民地陆战队使用的 10×24 毫米无壳脉冲突击步枪，每位陆战队员的贴身伙伴。这把采用新款 Humbrol 76 迷彩涂装，供武装侦察与陆战特战单位使用。"
	icon_state = "reconm41amk1"
	item_state = "reconm41amk1"
	current_mag = /obj/item/ammo_magazine/rifle/m41aMK1/recon
	starting_attachment_types = list(/obj/item/attachable/attached_gun/grenade/mk1/recon, /obj/item/attachable/stock/rifle/collapsible)

/obj/item/weapon/gun/rifle/m41aMK1/forecon/preloaded
	starting_attachment_types = list(/obj/item/attachable/attached_gun/grenade/mk1/recon/preloaded, /obj/item/attachable/stock/rifle/collapsible)

/obj/item/weapon/gun/rifle/m41aMK1/forecon/unloaded
	current_mag = null

/obj/item/weapon/gun/rifle/m41aMK1/army
	desc = "美国陆军使用的 10×24 毫米无壳脉冲突击步枪，每位士兵的贴身伙伴。配有一体式 30 毫米榴弹发射器和可储备四发榴弹的弹管。"
	starting_attachment_types = list(/obj/item/attachable/stock/rifle/collapsible, /obj/item/attachable/reddot, /obj/item/attachable/attached_gun/grenade/mk1/preloaded/army)
	current_mag = /obj/item/ammo_magazine/rifle/m41aMK1

/obj/item/weapon/gun/rifle/m41aMK1/army/masterkey
	desc = "美国陆军使用的 10×24 毫米无壳脉冲突击步枪，每位士兵的贴身伙伴。这把装有 U7 下挂式霰弹枪。"
	starting_attachment_types = list(/obj/item/attachable/stock/rifle/collapsible, /obj/item/attachable/reddot, /obj/item/attachable/attached_gun/shotgun)

/obj/item/weapon/gun/rifle/m41aMK1/navy //m41amk1_navy
	name = "\improper GUU-71/A 脉冲步枪"
	desc = "美国航空航天部队安保人员和军械士采用的 M41A 脉冲步枪改型。配有一体式 30 毫米榴弹发射器和可储备四发榴弹的弹管。"
	icon_state = "m41amk1_navy"
	item_state = "m41amk1_navy"
	starting_attachment_types = list(/obj/item/attachable/attached_gun/grenade/mk1/preloaded, /obj/item/attachable/stock/rifle/collapsible)
	current_mag = /obj/item/ammo_magazine/rifle/m41aMK1

/obj/item/weapon/gun/rifle/m41aMK1/navy/tactical
	name = "\improper GUU-71/B 脉冲步枪"
	desc = "为经常离舰执行任务的美国航空航天部队人员配备的 M41A 脉冲步枪改型。配有一体式 30 毫米榴弹发射器、消焰消声器，以及安装在提把上的磁力固定夹。"
	starting_attachment_types = list(/obj/item/attachable/attached_gun/grenade/mk1/preloaded, /obj/item/attachable/suppressor, /obj/item/attachable/magnetic_harness, /obj/item/attachable/stock/rifle/collapsible)

/obj/item/weapon/gun/rifle/m41aMK1/elite
	name = "M41A2 脉冲步枪"
	desc = "重新设计的 M41A 脉冲步枪，重量与操控性更佳，精密的两连发系统带来很高的精度。"
	icon_state = "m41a2"
	item_state = "m41a2"
	current_mag = /obj/item/ammo_magazine/rifle/m41aMK1
	aim_slowdown = SLOWDOWN_ADS_QUICK
	wield_delay = WIELD_DELAY_FAST
	map_specific_decoration = FALSE
	starting_attachment_types = list(/obj/item/attachable/stock/rifle/collapsible,/obj/item/attachable/attached_gun/grenade/mk1)
	random_spawn_chance = 100
	random_spawn_rail = list(
		/obj/item/attachable/reddot,
		/obj/item/attachable/reflex,
	)
/obj/item/weapon/gun/rifle/m41aMK1/elite/set_gun_config_values()
	set_fire_delay(FIRE_DELAY_TIER_11)
	set_burst_amount(BURST_AMOUNT_TIER_2)
	set_burst_delay(FIRE_DELAY_TIER_12)
	accuracy_mult = BASE_ACCURACY_MULT + HIT_ACCURACY_MULT_TIER_10
	accuracy_mult_unwielded = BASE_ACCURACY_MULT - HIT_ACCURACY_MULT_TIER_4
	scatter = SCATTER_AMOUNT_TIER_10
	burst_scatter_mult = SCATTER_AMOUNT_TIER_10
	scatter_unwielded = SCATTER_AMOUNT_TIER_4

/obj/item/weapon/gun/rifle/m41aMK1/elite/unloaded
	current_mag = null

/obj/item/weapon/gun/rifle/m41aMK1/elite/unloaded/platoon
	starting_attachment_types = list(/obj/item/attachable/stock/rifle/collapsible)
	attachable_allowed = list(
		/obj/item/attachable/suppressor,
		/obj/item/attachable/reddot,
		/obj/item/attachable/magnetic_harness,
		/obj/item/attachable/flashlight,
		/obj/item/attachable/reflex,
		/obj/item/attachable/scope/pve,
		/obj/item/attachable/attached_gun/grenade/mk1,
		/obj/item/attachable/stock/rifle/collapsible,
		/obj/item/attachable/sling,
		/obj/item/attachable/verticalgrip,
		/obj/item/attachable/lasersight,
	)
	random_rail_chance = 50
	random_spawn_rail = list(
		/obj/item/attachable/reddot,
		/obj/item/attachable/reflex,
	)
	random_under_chance = 100
	random_spawn_under = list(
		/obj/item/attachable/verticalgrip,
		/obj/item/attachable/lasersight,
		/obj/item/attachable/angledgrip,
	)
	random_muzzle_chance = 50
	random_spawn_muzzle = list(
		/obj/item/attachable/suppressor,
	)

//AG80 pulse rifle (UPP MK1 equivalent)
//=================================================
//=================================================

/obj/item/weapon/gun/rifle/ag80
	name = "AG80 脉冲步枪"
	desc = "UPPAC 海军步兵的脉冲式 9.7x16mm 无壳突击步枪，最近才服役，尚未全面整合。设计定位更像与 71 式步枪互补的卡宾枪，而非直接替代品。"
	icon = 'icons/obj/items/weapons/guns/guns_by_faction/upp.dmi'
	icon_state = "ag80"
	item_state = "ag80"
	fire_sound = "gun_pulse"
	reload_sound = 'sound/weapons/handling/m41_reload.ogg'
	unload_sound = 'sound/weapons/handling/m41_unload.ogg'
	current_mag = /obj/item/ammo_magazine/rifle/ag80
	attachable_allowed = list(
		/obj/item/attachable/suppressor,
		/obj/item/attachable/reddot/upp,
		/obj/item/attachable/flashlight,
		/obj/item/attachable/reflex/upp,
		/obj/item/attachable/scope/pve,
		/obj/item/attachable/scope/upp,
		/obj/item/attachable/scope/mini/upp,
		/obj/item/attachable/stock/rifle/collapsible,
		/obj/item/attachable/attached_gun/grenade/type71/ag80,
		/obj/item/attachable/attached_gun/grenade/type71/ag80/preloaded,
	)

	flags_gun_features = GUN_AUTO_EJECTOR|GUN_CAN_POINTBLANK|GUN_AMMO_COUNTER
	starting_attachment_types = list(/obj/item/attachable/stock/rifle/ag80/collapsible, /obj/item/attachable/attached_gun/grenade/type71/ag80)
	start_automatic = TRUE

/obj/item/weapon/gun/rifle/ag80/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 32, "muzzle_y" = 18,"rail_x" = 12, "rail_y" = 22, "under_x" = 21, "under_y" = 14, "stock_x" = 22, "stock_y" = 14)

/obj/item/weapon/gun/rifle/ag80/set_gun_config_values()
	..()
	set_fire_delay(FIRE_DELAY_TIER_10)
	set_burst_amount(BURST_AMOUNT_TIER_3)
	set_burst_delay(FIRE_DELAY_TIER_10)
	accuracy_mult = BASE_ACCURACY_MULT + HIT_ACCURACY_MULT_TIER_10
	accuracy_mult_unwielded = BASE_ACCURACY_MULT - HIT_ACCURACY_MULT_TIER_4
	scatter = SCATTER_AMOUNT_TIER_10
	burst_scatter_mult = SCATTER_AMOUNT_TIER_10
	scatter_unwielded = SCATTER_AMOUNT_TIER_4

/obj/item/weapon/gun/rifle/ag80/preloaded
	starting_attachment_types = list(/obj/item/attachable/stock/rifle/ag80/collapsible, /obj/item/attachable/attached_gun/grenade/type71/ag80/preloaded)

/obj/item/weapon/gun/rifle/ag80/unloaded
	flags_gun_features = GUN_AUTO_EJECTOR|GUN_CAN_POINTBLANK|GUN_AMMO_COUNTER|GUN_TRIGGER_SAFETY
	current_mag = null

//M20A Harrington rifle
//=================================================
//=================================================

/obj/item/weapon/gun/rifle/m20a
	name = "\improper M20A 脉冲步枪"
	desc = "M41A 的前身，仍被美洲联盟殖民地卫队及其他组织使用。除同样使用 10×24 毫米弹药外，这把“哈灵顿”步枪几乎处处与 M41A 相反：老式三发点射、较小弹匣，以及一体式霰弹枪配件。"
	icon = 'icons/obj/items/weapons/guns/guns_by_faction/uscm.dmi'
	icon_state = "m20a"
	item_state = "m20a"
	reload_sound = 'sound/weapons/handling/l42_reload.ogg'
	unload_sound = 'sound/weapons/handling/l42_unload.ogg'
	fire_sound = "gun_oldpulse"
	current_mag = /obj/item/ammo_magazine/rifle/m20a
	attachable_allowed = list(
		/obj/item/attachable/suppressor,
		/obj/item/attachable/bayonet,
		/obj/item/attachable/bayonet/upp,
		/obj/item/attachable/bayonet/co2,
		/obj/item/attachable/reddot,
		/obj/item/attachable/reflex,
		/obj/item/attachable/flashlight,
		/obj/item/attachable/lasersight,
		/obj/item/attachable/stock/m20a,
		/obj/item/attachable/attached_gun/shotgun,
	)

	flags_gun_features = GUN_AUTO_EJECTOR|GUN_CAN_POINTBLANK|GUN_AMMO_COUNTER
	wield_delay = WIELD_DELAY_NORMAL
	aim_slowdown = SLOWDOWN_ADS_RIFLE
	starting_attachment_types = list(/obj/item/attachable/stock/m20a,/obj/item/attachable/attached_gun/shotgun/m20a)
	map_specific_decoration = FALSE

/obj/item/weapon/gun/rifle/m20a/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 32, "muzzle_y" = 19,"rail_x" = 12, "rail_y" = 20, "under_x" = 18, "under_y" = 15, "stock_x" = 22, "stock_y" = 15, "side_rail_x" = 23, "side_rail_y" = 16)

/obj/item/weapon/gun/rifle/m20a/set_gun_config_values()
	..()
	set_fire_delay(FIRE_DELAY_TIER_9)
	set_burst_amount(BURST_AMOUNT_TIER_3)
	set_burst_delay(FIRE_DELAY_TIER_10)
	accuracy_mult = BASE_ACCURACY_MULT + HIT_ACCURACY_MULT_TIER_5
	accuracy_mult_unwielded = BASE_ACCURACY_MULT - HIT_ACCURACY_MULT_TIER_4
	damage_mult = BASE_BULLET_DAMAGE_MULT
	recoil_unwielded = RECOIL_AMOUNT_TIER_4
	damage_falloff_mult = 0
	scatter = SCATTER_AMOUNT_TIER_8
	burst_scatter_mult = SCATTER_AMOUNT_TIER_8

/obj/item/weapon/gun/rifle/m20a/unloaded
	flags_gun_features = GUN_AUTO_EJECTOR|GUN_CAN_POINTBLANK|GUN_AMMO_COUNTER|GUN_TRIGGER_SAFETY
	current_mag = null
	starting_attachment_types = list(/obj/item/attachable/stock/m20a,/obj/item/attachable/attached_gun/shotgun/m20a/unloaded)

/obj/item/weapon/gun/rifle/m20a/merc
	name = "\improper M20CW 脉冲卡宾枪"
	desc = "深度改装的黑市 M20A，常用于冲锋枪火力不足的近距离战斗。下挂霰弹枪被一体式握把取代，枪管缩短，枪托拆除，而且现在还能全自动射击！"
	icon = 'icons/obj/items/weapons/guns/guns_by_faction/colony.dmi'
	icon_state = "m20a_tactical"
	item_state = "m20a_tactical"
	attachable_allowed = list(
		/obj/item/attachable/suppressor,
		/obj/item/attachable/bayonet,
		/obj/item/attachable/bayonet/upp,
		/obj/item/attachable/bayonet/co2,
		/obj/item/attachable/reddot,
		/obj/item/attachable/reflex,
		/obj/item/attachable/flashlight,
		/obj/item/attachable/lasersight,
		/obj/item/attachable/sling,
	)
	starting_attachment_types = list(/obj/item/attachable/sling)
	start_automatic = TRUE

/obj/item/weapon/gun/rifle/m20a/merc/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 28, "muzzle_y" = 19,"rail_x" = 12, "rail_y" = 20, "under_x" = 14, "under_y" = 15, "stock_x" = 22, "stock_y" = 15, "side_rail_x" = 23, "side_rail_y" = 16)

/obj/item/weapon/gun/rifle/m20a/merc/set_gun_config_values()
	..()
	set_fire_delay(FIRE_DELAY_TIER_8)
	set_burst_amount(BURST_AMOUNT_TIER_1)
	damage_mult = BASE_BULLET_DAMAGE_MULT + BULLET_DAMAGE_MULT_TIER_2
	scatter = SCATTER_AMOUNT_TIER_9
	accuracy_mult = BASE_ACCURACY_MULT + HIT_ACCURACY_MULT_TIER_7

/obj/item/weapon/gun/rifle/m20a/merc/tactical
	starting_attachment_types = list(/obj/item/attachable/sling, /obj/item/attachable/suppressor, /obj/item/attachable/lasersight)

/obj/item/weapon/gun/rifle/m20a/merc/unloaded
	current_mag = null

//----------------------------------------------
//Experimental ARMAT side-grade to the M41A, not standard issue, only used by MARSOC

/obj/item/weapon/gun/rifle/m46c
	name = "XM46A 脉冲步枪"
	desc = "阿玛特对 M41A 的实验性改进型号 XM46，采用六边形膛线枪管、改进补偿机构、优化人体工学，以及主打的智能火控系统。试验认为其相对现役武器提升有限，成本却高得离谱，零件通用性也低得可疑。除特种任务单位外极少见到，即便在那里也不常见。"
	icon = 'icons/obj/items/weapons/guns/guns_by_faction/uscm.dmi'
	icon_state = "m46c"
	item_state = "m46c"
	fire_sound = "gun_pulse"
	reload_sound = 'sound/weapons/handling/m41_reload.ogg'
	unload_sound = 'sound/weapons/handling/m41_unload.ogg'
	current_mag = /obj/item/ammo_magazine/rifle/m41aMK1

	accepted_ammo = list(
		/obj/item/ammo_magazine/rifle/m41aMK1,
		/obj/item/ammo_magazine/rifle/m41aMK1/recon,
		/obj/item/ammo_magazine/rifle/m41aMK1/ap,
		/obj/item/ammo_magazine/rifle/m41aMK1/incendiary,
		/obj/item/ammo_magazine/rifle/m41aMK1/heap,
		/obj/item/ammo_magazine/rifle/m41aMK1/toxin,
		/obj/item/ammo_magazine/rifle/m41aMK1/penetrating,
		/obj/item/ammo_magazine/rifle/m41aMK1/tracer,
	)
	attachable_allowed = list(
		/obj/item/attachable/suppressor, // Muzzle
		/obj/item/attachable/extended_barrel,
		/obj/item/attachable/reddot, // Rail
		/obj/item/attachable/magnetic_harness,
		/obj/item/attachable/reflex,
		/obj/item/attachable/scope/pve,
		/obj/item/attachable/sling,
		/obj/item/attachable/scope/mini,
		/obj/item/attachable/verticalgrip, // Under
		/obj/item/attachable/angledgrip,
		/obj/item/attachable/attached_gun/grenade/mk1,
		/obj/item/attachable/attached_gun/grenade/mk1/recon,
		/obj/item/attachable/attached_gun/shotgun,
		/obj/item/attachable/stock/rifle/collapsible, // Stock
		/obj/item/attachable/flashlight, // Side Rail
		/obj/item/attachable/lasersight,
	)
	flags_gun_features = GUN_AUTO_EJECTOR|GUN_CAN_POINTBLANK|GUN_AMMO_COUNTER
	starting_attachment_types = list(/obj/item/attachable/attached_gun/grenade/mk1/recon, /obj/item/attachable/stock/rifle/collapsible)
	start_automatic = TRUE
	map_specific_decoration = FALSE

	var/iff_enabled = TRUE

/obj/item/weapon/gun/rifle/m46c/Initialize(mapload, ...)
	LAZYADD(actions_types, /datum/action/item_action/m46c/toggle_lethal_mode)
	. = ..()
	recalculate_attachment_bonuses()

/obj/item/weapon/gun/rifle/m46c/set_bullet_traits()
	LAZYADD(traits_to_give, list(
		BULLET_TRAIT_ENTRY_ID("iff", /datum/element/bullet_trait_iff)
	))
	AddComponent(/datum/component/iff_fire_prevention)

/obj/item/weapon/gun/rifle/m46c/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 32, "muzzle_y" = 17, "rail_x" = 11, "rail_y" = 19, "under_x" = 24, "under_y" = 12, "stock_x" = 24, "stock_y" = 13, "side_rail_x" = 26, "side_rail_y" = 17)

/obj/item/weapon/gun/rifle/m46c/set_gun_config_values()
	..()
	set_fire_delay(FIRE_DELAY_TIER_11)
	set_burst_amount(BURST_AMOUNT_TIER_3)
	set_burst_delay(FIRE_DELAY_TIER_12)
	accuracy_mult = BASE_ACCURACY_MULT + HIT_ACCURACY_MULT_TIER_4
	accuracy_mult_unwielded = BASE_ACCURACY_MULT - HIT_ACCURACY_MULT_TIER_8
	scatter = SCATTER_AMOUNT_TIER_8
	burst_scatter_mult = SCATTER_AMOUNT_TIER_8
	scatter_unwielded = SCATTER_AMOUNT_TIER_2
	damage_mult = BASE_BULLET_DAMAGE_MULT
	recoil_unwielded = RECOIL_AMOUNT_TIER_2
	fa_max_scatter = SCATTER_AMOUNT_TIER_8


//---ability actions--\\

/datum/action/item_action/m46c/action_activate()
	. = ..()
	var/obj/item/weapon/gun/rifle/m46c/smartrifle = holder_item
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/user = owner
	if(user.is_mob_incapacitated() || smartrifle.get_active_firearm(user, FALSE) != holder_item)
		return

/datum/action/item_action/m46c/update_button_icon()
	return

/datum/action/item_action/m46c/toggle_lethal_mode/New(Target, obj/item/holder)
	. = ..()
	name = "Toggle IFF"
	action_icon_state = "iff_toggle_on"
	button.name = "切换敌我识别"
	button.overlays.Cut()
	button.overlays += image('icons/mob/hud/actions.dmi', button, action_icon_state)

/datum/action/item_action/m46c/toggle_lethal_mode/action_activate()
	. = ..()
	var/obj/item/weapon/gun/rifle/m46c/smartrifle = holder_item
	smartrifle.toggle_iff(usr)
	if(smartrifle.iff_enabled)
		action_icon_state = "iff_toggle_on"
	else
		action_icon_state = "iff_toggle_off"
	button.overlays.Cut()
	button.overlays += image('icons/mob/hud/actions.dmi', button, action_icon_state)

// -- ability actions procs -- \\

/obj/item/weapon/gun/rifle/m46c/proc/toggle_iff(mob/user)
	iff_enabled = !iff_enabled
	to_chat(usr, SPAN_NOTICE("[icon2html(src, usr)]你[iff_enabled? "启用": "停用"]了[src]的敌我识别功能。"))
	playsound(loc,'sound/machines/click.ogg', 25, 1)

	if(iff_enabled)
		add_bullet_trait(BULLET_TRAIT_ENTRY_ID("iff", /datum/element/bullet_trait_iff))
	else
		remove_bullet_trait("iff")
	SEND_SIGNAL(src, COMSIG_GUN_IFF_TOGGLED, iff_enabled)

//-------------------------------------------------------
//MAR-40 AK CLONE //AK47 and FN FAL together as one.


/obj/item/weapon/gun/rifle/mar40
	name = "MAR-40 战斗步枪"
	desc = "使用 8.8x29mm 弹药的廉价可靠突击步枪，常见于罪犯、雇佣兵、UPP 或 CLF 手中。"
	icon = 'icons/obj/items/weapons/guns/guns_by_faction/colony.dmi'
	icon_state = "mar40"
	item_state = "mar40"
	fire_sound = 'sound/weapons/gun_mar40.ogg'
	reload_sound = 'sound/weapons/handling/gun_mar40_reload.ogg'
	unload_sound = 'sound/weapons/handling/gun_mar40_unload.ogg'

	current_mag = /obj/item/ammo_magazine/rifle/mar40
	attachable_allowed = list(
		/obj/item/attachable/suppressor,
		/obj/item/attachable/bayonet,
		/obj/item/attachable/bayonet/upp,
		/obj/item/attachable/reddot,
		/obj/item/attachable/reflex,
		/obj/item/attachable/gyro,
		/obj/item/attachable/flashlight,
		/obj/item/attachable/bipod,
		/obj/item/attachable/extended_barrel,
		/obj/item/attachable/compensator,
		/obj/item/attachable/burstfire_assembly,
		/obj/item/attachable/magnetic_harness,
		/obj/item/attachable/attached_gun/grenade,
		/obj/item/attachable/attached_gun/flamer,
		/obj/item/attachable/attached_gun/flamer/advanced,
		/obj/item/attachable/attached_gun/extinguisher,
		/obj/item/attachable/attached_gun/shotgun,
		/obj/item/attachable/scope/slavic,
	)
	flags_gun_features = GUN_AUTO_EJECTOR|GUN_CAN_POINTBLANK|GUN_AUTO_EJECT_CASINGS
	start_automatic = TRUE



/obj/item/weapon/gun/rifle/mar40/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 28, "muzzle_y" = 17,"rail_x" = 16, "rail_y" = 20, "under_x" = 24, "under_y" = 15, "stock_x" = 24, "stock_y" = 13, "side_rail_x" = 25, "side_rail_y" = 17)


/obj/item/weapon/gun/rifle/mar40/set_gun_config_values()
	..()
	set_fire_delay(FIRE_DELAY_TIER_7)
	set_burst_amount(BURST_AMOUNT_TIER_4)
	set_burst_delay(FIRE_DELAY_TIER_11)
	accuracy_mult = BASE_ACCURACY_MULT
	accuracy_mult_unwielded = BASE_ACCURACY_MULT - HIT_ACCURACY_MULT_TIER_7
	scatter = SCATTER_AMOUNT_TIER_6
	burst_scatter_mult = SCATTER_AMOUNT_TIER_8
	scatter_unwielded = SCATTER_AMOUNT_TIER_2
	damage_mult = BASE_BULLET_DAMAGE_MULT
	recoil_unwielded = RECOIL_AMOUNT_TIER_2
	recoil = RECOIL_AMOUNT_TIER_5

/obj/item/weapon/gun/rifle/mar40/tactical
	desc = "廉价可靠的 8.8×29 毫米突击步枪，常见于罪犯、雇佣兵、进步人民联盟或殖民地解放阵线手中。这把加装了第三方弹药计数器。"
	starting_attachment_types = list(/obj/item/attachable/angledgrip, /obj/item/attachable/suppressor, /obj/item/attachable/magnetic_harness)
	flags_gun_features = GUN_AMMO_COUNTER|GUN_AUTO_EJECTOR|GUN_CAN_POINTBLANK|GUN_AUTO_EJECT_CASINGS

/obj/item/weapon/gun/rifle/mar40/carbine
	name = "MAR-30 战斗卡宾枪"
	desc = "使用 8.8x29mm 弹药的廉价可靠卡宾枪，常见于罪犯或雇佣兵手中。"
	icon_state = "mar30"
	item_state = "mar30"
	fire_sound = 'sound/weapons/gun_mar40.ogg'
	reload_sound = 'sound/weapons/handling/gun_mar40_reload.ogg'
	unload_sound = 'sound/weapons/handling/gun_mar40_unload.ogg'

	aim_slowdown = SLOWDOWN_ADS_QUICK //Carbine is more lightweight
	wield_delay = WIELD_DELAY_FAST
	attachable_allowed = list(
		/obj/item/attachable/suppressor,
		/obj/item/attachable/bayonet,
		/obj/item/attachable/bayonet/upp,
		/obj/item/attachable/reddot,
		/obj/item/attachable/reflex,
		/obj/item/attachable/verticalgrip,
		/obj/item/attachable/angledgrip,
		/obj/item/attachable/lasersight,
		/obj/item/attachable/flashlight,
		/obj/item/attachable/bipod,
		/obj/item/attachable/extended_barrel,
		/obj/item/attachable/heavy_barrel,
		/obj/item/attachable/magnetic_harness,
		/obj/item/attachable/attached_gun/grenade,
		/obj/item/attachable/attached_gun/flamer,
		/obj/item/attachable/attached_gun/flamer/advanced,
		/obj/item/attachable/attached_gun/extinguisher,
		/obj/item/attachable/attached_gun/shotgun,
		/obj/item/attachable/scope,
		/obj/item/attachable/scope/mini,
	)

/obj/item/weapon/gun/rifle/mar40/carbine/set_gun_config_values()
	..()
	set_fire_delay(FIRE_DELAY_TIER_9)
	accuracy_mult_unwielded = BASE_ACCURACY_MULT - HIT_ACCURACY_MULT_TIER_4
	damage_mult = BASE_BULLET_DAMAGE_MULT
	scatter_unwielded = SCATTER_AMOUNT_TIER_4
	recoil_unwielded = RECOIL_AMOUNT_TIER_3

/obj/item/weapon/gun/rifle/mar40/carbine/tactical
	desc = "廉价可靠的 8.8×29 毫米卡宾枪，常见于罪犯或雇佣兵手中。这把加装了第三方弹药计数器。"
	starting_attachment_types = list(/obj/item/attachable/verticalgrip, /obj/item/attachable/suppressor, /obj/item/attachable/magnetic_harness)
	flags_gun_features = GUN_AMMO_COUNTER|GUN_AUTO_EJECTOR|GUN_CAN_POINTBLANK|GUN_AUTO_EJECT_CASINGS

/obj/item/weapon/gun/rifle/mar40/lmg
	name = "\improper MAR-50 轻机枪"
	desc = "廉价可靠的 8.8×29 毫米轻机枪，常见于手头稍宽裕的罪犯。"
	icon_state = "mar50"
	item_state = "mar50"
	mouse_pointer = 'icons/effects/mouse_pointer/lmg_mouse.dmi'

	fire_sound = 'sound/weapons/gun_mar40.ogg'
	reload_sound = 'sound/weapons/handling/gun_mar40_reload.ogg'
	unload_sound = 'sound/weapons/handling/gun_mar40_unload.ogg'

	starting_attachment_types = list(/obj/item/attachable/mar50barrel)

	current_mag = /obj/item/ammo_magazine/rifle/mar40/lmg
	attachable_allowed = list(
		/obj/item/attachable/reddot,
		/obj/item/attachable/reflex,
		/obj/item/attachable/flashlight,
		/obj/item/attachable/bipod,
		/obj/item/attachable/magnetic_harness,
		/obj/item/attachable/scope/slavic,
	)
	random_spawn_chance = 38
	random_spawn_rail = list(
		/obj/item/attachable/reddot,
		/obj/item/attachable/reflex,
		/obj/item/attachable/scope/slavic,
		/obj/item/attachable/magnetic_harness,
	)

	flags_gun_features = GUN_CAN_POINTBLANK|GUN_WIELDED_FIRING_ONLY|GUN_AUTO_EJECT_CASINGS

/obj/item/weapon/gun/rifle/mar40/lmg/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 32, "muzzle_y" = 16,"rail_x" = 16, "rail_y" = 20, "under_x" = 26, "under_y" = 16, "stock_x" = 24, "stock_y" = 13, "side_rail_x" = 25, "side_rail_y" = 17)

/obj/item/weapon/gun/rifle/mar40/lmg/set_gun_config_values()
	..()
	set_fire_delay(FIRE_DELAY_TIER_LMG)
	set_burst_amount(BURST_AMOUNT_TIER_5)
	set_burst_delay(FIRE_DELAY_TIER_LMG)
	accuracy_mult = BASE_ACCURACY_MULT
	accuracy_mult_unwielded = BASE_ACCURACY_MULT - HIT_ACCURACY_MULT_TIER_7
	scatter = SCATTER_AMOUNT_TIER_6
	burst_scatter_mult = SCATTER_AMOUNT_TIER_8
	scatter_unwielded = SCATTER_AMOUNT_TIER_2
	damage_mult = BASE_BULLET_DAMAGE_MULT
	recoil_unwielded = RECOIL_AMOUNT_TIER_2
	recoil = RECOIL_AMOUNT_TIER_5

/obj/item/weapon/gun/rifle/mar40/lmg/tactical
	desc = "廉价可靠的 8.8×29 毫米枪械，常见于手头稍宽裕的罪犯。这把加装了第三方弹药计数器。"
	starting_attachment_types = list(/obj/item/attachable/mar50barrel, /obj/item/attachable/bipod, /obj/item/attachable/magnetic_harness)
	flags_gun_features = GUN_AMMO_COUNTER|GUN_CAN_POINTBLANK|GUN_WIELDED_FIRING_ONLY|GUN_AUTO_EJECT_CASINGS
//-------------------------------------------------------
//M16 RIFLE

/obj/item/weapon/gun/rifle/m16
	name = "M16 步枪"
	desc = "厂家宣称它是经典 16 型突击步枪。自 AR-15 专利在一个多世纪前到期后，边疆遍地都是此类仿制品。使用 5.56x45mm 弹药，深受边疆家庭防卫者与猎人欢迎。如果你愿意捡弹壳，老式有壳弹还能反复复装，直到弹壳散架。"
	icon = 'icons/obj/items/weapons/guns/guns_by_faction/colony.dmi'
	icon_state = "m16"
	item_state = "m16"

	fire_sound = 'sound/weapons/gun_m16.ogg'
	reload_sound = 'sound/weapons/handling/gun_m16_reload.ogg'
	unload_sound = 'sound/weapons/handling/gun_m16_unload.ogg'

	current_mag = /obj/item/ammo_magazine/rifle/m16
	attachable_allowed = list(
		/obj/item/attachable/suppressor,
		/obj/item/attachable/bayonet,
		/obj/item/attachable/bayonet/upp,
		/obj/item/attachable/reddot,
		/obj/item/attachable/reflex,
		/obj/item/attachable/scope/mini,
		/obj/item/attachable/verticalgrip,
		/obj/item/attachable/angledgrip,
		/obj/item/attachable/gyro,
		/obj/item/attachable/flashlight,
		/obj/item/attachable/bipod,
		/obj/item/attachable/extended_barrel,
		/obj/item/attachable/compensator,
		/obj/item/attachable/burstfire_assembly,
		/obj/item/attachable/attached_gun/grenade,
		/obj/item/attachable/attached_gun/flamer,
		/obj/item/attachable/attached_gun/flamer/advanced,
		/obj/item/attachable/attached_gun/extinguisher,
		/obj/item/attachable/attached_gun/shotgun,
		/obj/item/attachable/lasersight,
		/obj/item/attachable/stock/m16,
	)
	random_spawn_chance = 42
	random_spawn_rail = list(
		/obj/item/attachable/reddot,
		/obj/item/attachable/reflex/,
		/obj/item/attachable/scope/mini,
	)
	random_spawn_under = list(
		/obj/item/attachable/angledgrip,
		/obj/item/attachable/verticalgrip,
		/obj/item/attachable/gyro,
		/obj/item/attachable/burstfire_assembly,
		/obj/item/attachable/bipod,
		/obj/item/attachable/attached_gun/extinguisher,
		/obj/item/attachable/attached_gun/shotgun,
	)
	random_spawn_muzzle = list(
		/obj/item/attachable/suppressor,
		/obj/item/attachable/bayonet,
		/obj/item/attachable/compensator,
		/obj/item/attachable/extended_barrel,
	)
	random_spawn_siderail = list(
		/obj/item/attachable/lasersight,
		/obj/item/attachable/flashlight,
	)

	flags_gun_features = GUN_CAN_POINTBLANK|GUN_ANTIQUE|GUN_AUTO_EJECT_CASINGS

/obj/item/weapon/gun/rifle/m16/handle_starting_attachment()
	..()
	var/obj/item/attachable/stock/m16/S = new(src)
	S.hidden = FALSE
	S.flags_attach_features &= ~ATTACH_REMOVABLE
	S.Attach(src)
	update_attachable(S.slot)

/obj/item/weapon/gun/rifle/m16/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 32, "muzzle_y" = 17,"rail_x" = 9, "rail_y" = 20, "under_x" = 22, "under_y" = 14, "stock_x" = 15, "stock_y" = 14, "side_rail_x" = 25, "side_rail_y" = 16)

/obj/item/weapon/gun/rifle/m16/set_gun_config_values()
	..()
	set_fire_delay(FIRE_DELAY_TIER_11)
	set_burst_amount(BURST_AMOUNT_TIER_3)
	set_burst_delay(FIRE_DELAY_TIER_11)
	accuracy_mult = BASE_ACCURACY_MULT + HIT_ACCURACY_MULT_TIER_7
	accuracy_mult_unwielded = BASE_ACCURACY_MULT - HIT_ACCURACY_MULT_TIER_7
	scatter = SCATTER_AMOUNT_TIER_10
	burst_scatter_mult = SCATTER_AMOUNT_TIER_10
	scatter_unwielded = SCATTER_AMOUNT_TIER_2
	damage_mult = BASE_BULLET_DAMAGE_MULT
	recoil_unwielded = RECOIL_AMOUNT_TIER_2

/obj/item/weapon/gun/rifle/m16/grenadier
	name = "\improper M16 掷弹兵步枪"
	desc = "下机匣上磨损褪色的小贴纸声称它是“野马特制，小伙伴版”。说白了，就是一把装有不可拆卸 M203 下挂榴弹发射器的 M16 复刻枪。40 毫米口径，注意枪口朝向。"
	icon_state = "m16g"
	item_state = "m16"
	fire_sound = 'sound/weapons/gun_m16.ogg'
	reload_sound = 'sound/weapons/handling/gun_m16_reload.ogg'
	unload_sound = 'sound/weapons/handling/gun_m16_unload.ogg'
	current_mag = /obj/item/ammo_magazine/rifle/m16
	attachable_allowed = list(
		/obj/item/attachable/suppressor,
		/obj/item/attachable/bayonet,
		/obj/item/attachable/scope/mini,
		/obj/item/attachable/scope,
		/obj/item/attachable/magnetic_harness,
		/obj/item/attachable/reddot,
		/obj/item/attachable/reflex,
		/obj/item/attachable/flashlight,
		/obj/item/attachable/extended_barrel,
		/obj/item/attachable/compensator,
		/obj/item/attachable/attached_gun/grenade/m203,
	)
	random_spawn_chance = 42
	random_spawn_rail = list(
		/obj/item/attachable/reddot,
		/obj/item/attachable/reflex/,
		/obj/item/attachable/scope/mini,
	)
	random_spawn_muzzle = list(
		/obj/item/attachable/suppressor,
		/obj/item/attachable/bayonet,
		/obj/item/attachable/compensator,
		/obj/item/attachable/extended_barrel,
	)

/obj/item/weapon/gun/rifle/m16/grenadier/handle_starting_attachment()
	..()
	var/obj/item/attachable/attached_gun/grenade/m203/integrated = new(src)
	integrated.flags_attach_features &= ~ATTACH_REMOVABLE
	integrated.hidden = FALSE
	integrated.Attach(src)
	update_attachable(integrated.slot)

//-------------------------------------------------------
//XM177 carbine
//awesome vietnam era special forces carbine version of the M16

/obj/item/weapon/gun/rifle/xm177
	name = "\improper XM177 卡宾枪"
	desc = "5.56×45 毫米卡宾枪。可能是极廉价的老 XM177 仿制品，也可能是谁胡乱手改的东西，或者真是能让博物馆花上几千元收藏的古董。谁知道呢？"
	icon = 'icons/obj/items/weapons/guns/guns_by_faction/colony.dmi'
	icon_state = "xm177"
	item_state = "m16"
	current_mag = /obj/item/ammo_magazine/rifle/m16

	flags_gun_features = GUN_CAN_POINTBLANK|GUN_ANTIQUE|GUN_AUTO_EJECT_CASINGS

	fire_sound = 'sound/weapons/gun_m16.ogg'
	reload_sound = 'sound/weapons/handling/gun_m16_reload.ogg'
	unload_sound = 'sound/weapons/handling/gun_m16_unload.ogg'
	accepted_ammo = list(
		/obj/item/ammo_magazine/rifle/m16,
		/obj/item/ammo_magazine/rifle/m16/ap,
	)

	attachable_allowed = list(
		/obj/item/attachable/reddot,
		/obj/item/attachable/reflex,
		/obj/item/attachable/scope/mini,
		/obj/item/attachable/verticalgrip,
		/obj/item/attachable/flashlight,
		/obj/item/attachable/lasersight,
		/obj/item/attachable/stock/m16/xm177,
	)

	random_spawn_chance = 75
	random_spawn_rail = list(
		/obj/item/attachable/reddot,
		/obj/item/attachable/reflex/,
	)
	random_spawn_under = list(
		/obj/item/attachable/verticalgrip,
	)
	random_spawn_siderail = list(
		/obj/item/attachable/lasersight,
		/obj/item/attachable/flashlight,
	)

/obj/item/weapon/gun/rifle/xm177/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 30, "muzzle_y" = 18,"rail_x" = 9, "rail_y" = 20, "under_x" = 19, "under_y" = 13, "stock_x" = 15, "stock_y" = 14, "side_rail_x" = 21, "side_rail_y" = 16)

/obj/item/weapon/gun/rifle/xm177/handle_starting_attachment()
	..()
	var/obj/item/attachable/stock/m16/xm177/integrated = new(src)
	integrated.hidden = FALSE
	integrated.flags_attach_features &= ~ATTACH_REMOVABLE
	integrated.Attach(src)
	update_attachable(integrated.slot)

/obj/item/weapon/gun/rifle/xm177/set_gun_config_values()
	..()
	set_fire_delay(FIRE_DELAY_TIER_SMG)
	set_burst_amount(BURST_AMOUNT_TIER_3)
	set_burst_delay(FIRE_DELAY_TIER_SMG)
	accuracy_mult = BASE_ACCURACY_MULT + HIT_ACCURACY_MULT_TIER_6
	accuracy_mult_unwielded = BASE_ACCURACY_MULT - HIT_ACCURACY_MULT_TIER_3
	scatter = SCATTER_AMOUNT_TIER_8
	burst_scatter_mult = SCATTER_AMOUNT_TIER_7
	scatter_unwielded = SCATTER_AMOUNT_TIER_4
	damage_mult = BASE_BULLET_DAMAGE_MULT
	recoil_unwielded = RECOIL_AMOUNT_TIER_2

//-------------------------------------------------------
//AR10 rifle
//basically an early M16

/obj/item/weapon/gun/rifle/ar10
	name = "\improper AR10 步枪"
	desc = "比更常见的 M16 还早的步枪型号，被视为二十世纪步枪之父。它为何会出现在这里，本身就是一个谜。使用 7.62×51 毫米弹药。"
	desc_lore = "AR10 最初由阿玛莱特公司于二十世纪五十年代生产，该公司于 2002 年被维兰德-汤谷收购。它是首批融合多项创新设计的量产步枪之一，例如导气式枪机与枪机框系统。总共仅生产一万把，只有葡萄牙和苏丹曾以国家名义采用。自二十世纪末起，这些步枪与更常见的 M16、AR15 一同流转于太空中较为蛮荒的地区，将罕见的有壳弹药散布在丛林与殖民地地面上——自脉冲弹药出现后，这类弹药已很少见。这把枪侧面刻着“萨拉查”。"
	icon = 'icons/obj/items/weapons/guns/guns_by_faction/colony.dmi'
	icon_state = "ar10"
	item_state = "ar10"
	fire_sound = 'sound/weapons/gun_ar10.ogg'
	reload_sound = 'sound/weapons/handling/gun_m16_reload.ogg'
	unload_sound = 'sound/weapons/handling/gun_ar10_unload.ogg'
	cocked_sound = 'sound/weapons/handling/gun_ar10_cocked.ogg'

	current_mag = /obj/item/ammo_magazine/rifle/ar10
	attachable_allowed = list(
		/obj/item/attachable/suppressor,
		/obj/item/attachable/bayonet,
		/obj/item/attachable/bayonet/upp,
		/obj/item/attachable/reddot,
		/obj/item/attachable/reflex,
		/obj/item/attachable/scope/mini,
		/obj/item/attachable/verticalgrip,
		/obj/item/attachable/angledgrip,
		/obj/item/attachable/flashlight,
		/obj/item/attachable/bipod,
		/obj/item/attachable/extended_barrel,
		/obj/item/attachable/compensator,
		/obj/item/attachable/stock/ar10,
	)
	random_spawn_chance = 10
	random_spawn_rail = list(
		/obj/item/attachable/reddot,
		/obj/item/attachable/reflex/,
		/obj/item/attachable/scope/mini,
	)
	random_spawn_under = list(
		/obj/item/attachable/angledgrip,
		/obj/item/attachable/verticalgrip,
		/obj/item/attachable/bipod,
	)
	random_spawn_muzzle = list(
		/obj/item/attachable/suppressor,
		/obj/item/attachable/bayonet,
		/obj/item/attachable/compensator,
		/obj/item/attachable/extended_barrel,
	)

	flags_gun_features = GUN_CAN_POINTBLANK|GUN_ANTIQUE|GUN_AUTO_EJECT_CASINGS

/obj/item/weapon/gun/rifle/ar10/handle_starting_attachment()
	..()
	var/obj/item/attachable/stock/ar10/S = new(src)
	S.hidden = FALSE
	S.flags_attach_features &= ~ATTACH_REMOVABLE
	S.Attach(src)
	update_attachable(S.slot)

/obj/item/weapon/gun/rifle/ar10/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 32, "muzzle_y" = 17,"rail_x" = 8, "rail_y" = 20, "under_x" = 22, "under_y" = 14, "stock_x" = 15, "stock_y" = 14, "side_rail_x" = 27, "side_rail_y" = 16)

/obj/item/weapon/gun/rifle/ar10/set_gun_config_values()
	..()
	set_fire_delay(FIRE_DELAY_TIER_7)
	set_burst_amount(BURST_AMOUNT_TIER_3)
	set_burst_delay(FIRE_DELAY_TIER_7)
	accuracy_mult = BASE_ACCURACY_MULT + HIT_ACCURACY_MULT_TIER_8
	accuracy_mult_unwielded = BASE_ACCURACY_MULT - HIT_ACCURACY_MULT_TIER_10
	scatter = SCATTER_AMOUNT_TIER_9
	burst_scatter_mult = SCATTER_AMOUNT_TIER_9
	scatter_unwielded = SCATTER_AMOUNT_TIER_2
	damage_mult = BASE_BULLET_DAMAGE_MULT
	recoil_unwielded = RECOIL_AMOUNT_TIER_3

//-------------------------------------------------------
//DUTCH'S GEAR

/obj/item/weapon/gun/rifle/m16/dutch
	name = "\improper 达奇的 M16A1"
	desc = "达奇十二人组雇佣兵使用的改装 M16，侧面贴着“隐身猎手杀手”的标签，使用 5.56×45 毫米弹药。"
	icon_state = "m16a1"
	current_mag = /obj/item/ammo_magazine/rifle/m16/ap
	starting_attachment_types = list(/obj/item/attachable/bayonet)

	random_spawn_rail = list(
		/obj/item/attachable/reddot,
		/obj/item/attachable/reflex/,
	)
	random_spawn_under = list(
		/obj/item/attachable/angledgrip,
		/obj/item/attachable/verticalgrip,
		/obj/item/attachable/burstfire_assembly,
		/obj/item/attachable/attached_gun/extinguisher,
		/obj/item/attachable/attached_gun/shotgun,
		/obj/item/attachable/lasersight,
	)
	random_spawn_muzzle = list(
		/obj/item/attachable/suppressor,
		/obj/item/attachable/bayonet,
		/obj/item/attachable/extended_barrel,
	)

/obj/item/weapon/gun/rifle/m16/dutch/set_gun_config_values()
	..()
	damage_mult = BASE_BULLET_DAMAGE_MULT

/obj/item/weapon/gun/rifle/m16/grenadier/dutch
	name = "\improper 达奇的掷弹兵 M16A1"
	desc = "达奇十二人组雇佣兵使用的改装 M16，侧面贴着“隐身猎手杀手”的标签，使用 5.56×45 毫米弹药。装有不可拆卸的 M203 榴弹发射器，每次容纳一发专用 40 毫米榴弹。它没有现代敌我识别系统，榴弹会在命中第一个目标时爆炸。让你的小伙伴登场吧。"
	current_mag = /obj/item/ammo_magazine/rifle/m16/ap
	starting_attachment_types = list(/obj/item/attachable/scope/mini, /obj/item/attachable/bayonet)

/obj/item/weapon/gun/rifle/m16/grenadier/dutch/set_gun_config_values()
	..()
	damage_mult = BASE_BULLET_DAMAGE_MULT

/obj/item/weapon/gun/rifle/xm177/dutch
	name = "\improper 达奇的 XM177E2 卡宾枪"
	desc = "达奇十二人组雇佣兵使用的改装 XM177，侧面贴着“隐身猎手杀手”的标签，使用 5.56×45 毫米弹药。枪身短小，无法安装大多数下挂配件，枪口调节器也使它不能安装任何枪口装置。"
	desc_lore = "与 M16A1 相似的卡宾枪，拥有伸缩枪托和独特消焰器。机匣上刻着“柯尔特 AR-15——美国政府财产——XM177E2——口径 5.56 毫米”。机匣上方粗略刻着某种面具图案？旁边还有“隐身猎手杀手”字样及七道计数刻痕。\nXM177 的设计源自越南战争，也称柯尔特突击队或 GAU-5/A，是对 CAR-15 607 型的改进，解决了 607 型在特种部队少量服役时暴露的多项问题。它主要由执行突击任务的陆军特种部队和海军海豹部队使用。\n它为何会出现在这里，仍是一个谜。"
	icon_state = "xm177"
	current_mag = /obj/item/ammo_magazine/rifle/m16/ap

/obj/item/weapon/gun/rifle/xm177/dutch/set_gun_config_values()
	..()
	set_fire_delay(FIRE_DELAY_TIER_SMG)
	set_burst_amount(BURST_AMOUNT_TIER_3)
	set_burst_delay(FIRE_DELAY_TIER_SMG)
	accuracy_mult = BASE_ACCURACY_MULT + HIT_ACCURACY_MULT_TIER_6
	accuracy_mult_unwielded = BASE_ACCURACY_MULT - HIT_ACCURACY_MULT_TIER_3
	scatter = SCATTER_AMOUNT_TIER_8
	burst_scatter_mult = SCATTER_AMOUNT_TIER_7
	scatter_unwielded = SCATTER_AMOUNT_TIER_4
	damage_mult = BASE_BULLET_DAMAGE_MULT
	recoil_unwielded = RECOIL_AMOUNT_TIER_2


//-------------------------------------------------------
//M41AE2 HEAVY PULSE RIFLE

/obj/item/weapon/gun/rifle/lmg
	name = "M41AE2 重型脉冲步枪"
	desc = "M41A 的重枪管高容量变体，持续火力和总载弹量更强，代价是移除榴弹发射器并降低操控性。"
	icon = 'icons/obj/items/weapons/guns/guns_by_faction/uscm.dmi'
	icon_state = "m41ae2"
	item_state = "m41ae2"
	mouse_pointer = 'icons/effects/mouse_pointer/lmg_mouse.dmi'

	reload_sound = 'sound/weapons/handling/hpr_reload.ogg'
	unload_sound = 'sound/weapons/handling/hpr_unload.ogg'
	fire_sound = "gun_pulse"
	aim_slowdown = SLOWDOWN_ADS_LMG
	accepted_ammo = list(
		/obj/item/ammo_magazine/hpr_box,
		/obj/item/ammo_magazine/hpr_box/ap,
		/obj/item/ammo_magazine/hpr_box/heap,
		/obj/item/ammo_magazine/hpr_box/holo_target,
		/obj/item/ammo_magazine/hpr_box/recon,
		/obj/item/ammo_magazine/rifle/m41aMK1,
		/obj/item/ammo_magazine/rifle/m41aMK1/recon,
		/obj/item/ammo_magazine/rifle/m41aMK1/rubber,
		/obj/item/ammo_magazine/rifle/m41aMK1/ap,
		/obj/item/ammo_magazine/rifle/m41aMK1/incendiary,
		/obj/item/ammo_magazine/rifle/m41aMK1/heap,
		/obj/item/ammo_magazine/rifle/m41aMK1/toxin,
		/obj/item/ammo_magazine/rifle/m41aMK1/penetrating,
		/obj/item/ammo_magazine/rifle/m41aMK1/tracer,
	)
	current_mag = /obj/item/ammo_magazine/hpr_box
	attachable_allowed = list(
		/obj/item/attachable/suppressor,
		/obj/item/attachable/reddot,
		/obj/item/attachable/reflex,
		/obj/item/attachable/flashlight,
		/obj/item/attachable/bipod/integral,
		/obj/item/attachable/stock/rifle/collapsible,
		/obj/item/attachable/heavy_barrel,
		/obj/item/attachable/compensator,
		/obj/item/attachable/burstfire_assembly,
		/obj/item/attachable/magnetic_harness,
		/obj/item/attachable/scope/pve,
		/obj/item/attachable/sling,
	)
	starting_attachment_types = list(
		/obj/item/attachable/bipod/integral,
		/obj/item/attachable/stock/rifle/collapsible,
	)

	flags_gun_features = GUN_CAN_POINTBLANK|GUN_AMMO_COUNTER
	gun_category = GUN_CATEGORY_HEAVY
	start_automatic = TRUE
	bonus_overlay_x = -1
	bonus_overlay_y = -1

/obj/item/weapon/gun/rifle/lmg/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 33, "muzzle_y" = 19,"rail_x" = 10, "rail_y" = 23, "under_x" = 26, "under_y" = 16, "stock_x" = 24, "stock_y" = 13, "side_rail_x" = 27, "side_rail_y" = 18)

/obj/item/weapon/gun/rifle/lmg/set_gun_config_values()
	..()
	set_fire_delay(FIRE_DELAY_TIER_LMG)
	set_burst_amount(BURST_AMOUNT_TIER_4)
	set_burst_delay(FIRE_DELAY_TIER_LMG)
	//hopefully, this will give it some reason to not just hold down trigger? Long lethal bursts.
	fa_scatter_peak = FULL_AUTO_SCATTER_PEAK_TIER_2
	fa_max_scatter = SCATTER_AMOUNT_TIER_1
	accuracy_mult = BASE_ACCURACY_MULT
	accuracy_mult_unwielded = BASE_ACCURACY_MULT - HIT_ACCURACY_MULT_TIER_2
	scatter = SCATTER_AMOUNT_TIER_4
	burst_scatter_mult = -SCATTER_AMOUNT_TIER_10
	scatter_unwielded = SCATTER_AMOUNT_TIER_1
	damage_mult = BASE_BULLET_DAMAGE_MULT + BULLET_DAMAGE_MULT_TIER_2
	recoil_unwielded = RECOIL_AMOUNT_TIER_5
	aim_slowdown = SLOWDOWN_ADS_LMG
	wield_delay = WIELD_DELAY_SLOW

/obj/item/weapon/gun/rifle/lmg/tactical
	desc = "改装型号的再改装。将两脚架换成握把，使它更接近原本的突击步枪形态。"
	current_mag = /obj/item/ammo_magazine/hpr_box/ap
	attachable_allowed = list(
		/obj/item/attachable/suppressor,
		/obj/item/attachable/reddot,
		/obj/item/attachable/reflex,
		/obj/item/attachable/flashlight,
		/obj/item/attachable/angledgrip,
		/obj/item/attachable/stock/rifle/collapsible,
		/obj/item/attachable/heavy_barrel,
		/obj/item/attachable/compensator,
		/obj/item/attachable/burstfire_assembly,
		/obj/item/attachable/magnetic_harness,
		/obj/item/attachable/scope/pve,
		/obj/item/attachable/sling,
	)
	starting_attachment_types = list(
		/obj/item/attachable/magnetic_harness,
		/obj/item/attachable/suppressor,
		/obj/item/attachable/stock/rifle/collapsible,
		/obj/item/attachable/angledgrip,
	)

/obj/item/weapon/gun/rifle/lmg/tactical/set_gun_config_values()
	..()
	damage_mult = BASE_BULLET_DAMAGE_MULT + BULLET_DAMAGE_MULT_TIER_2//equal to m41a dmg

/obj/item/weapon/gun/rifle/lmg/tactical/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 33, "muzzle_y" = 19,"rail_x" = 10, "rail_y" = 23, "under_x" = 26, "under_y" = 13, "stock_x" = 24, "stock_y" = 13)

/obj/item/weapon/gun/rifle/lmg/army
	desc = "美国陆军采用的 M41AE2 加装了更长枪管和改进固定系统，承担更传统的机枪职责。"
	current_mag = /obj/item/ammo_magazine/hpr_box/ap
	starting_attachment_types = list(
		/obj/item/attachable/magnetic_harness,
		/obj/item/attachable/extended_barrel,
		/obj/item/attachable/stock/rifle/collapsible,
		/obj/item/attachable/bipod/integral,
	)

/obj/item/weapon/gun/rifle/lmg/army/set_gun_config_values()
	..()
	damage_mult = BASE_BULLET_DAMAGE_MULT + BULLET_DAMAGE_MULT_TIER_2//equal to m41a dmg

/obj/item/weapon/gun/rifle/lmg/recon
	desc = "M41A 的重枪管大容量改型。持续火力与携弹量更高，但去掉了榴弹发射器，操控性也更差。这把采用新款 Humbrol 76 迷彩涂装，供武装侦察单位使用，以垂直握把取代一体式两脚架。"
	icon_state = "m41ae2_recon"
	item_state = "m41ae2_recon"
	attachable_allowed = list(
		/obj/item/attachable/suppressor,
		/obj/item/attachable/reddot,
		/obj/item/attachable/reflex,
		/obj/item/attachable/flashlight,
		/obj/item/attachable/verticalgrip,
		/obj/item/attachable/stock/rifle/collapsible,
		/obj/item/attachable/heavy_barrel,
		/obj/item/attachable/compensator,
		/obj/item/attachable/burstfire_assembly,
		/obj/item/attachable/magnetic_harness,
		/obj/item/attachable/scope/pve,
		/obj/item/attachable/sling,
	)
	starting_attachment_types = list(
		/obj/item/attachable/stock/rifle/collapsible,
		/obj/item/attachable/verticalgrip,
	)

/obj/item/weapon/gun/rifle/lmg/recon/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 33, "muzzle_y" = 19,"rail_x" = 10, "rail_y" = 23, "under_x" = 24, "under_y" = 11, "stock_x" = 24, "stock_y" = 13)
//-------------------------------------------------------


//-------------------------------------------------------
//UPP TYPE 71 RIFLE

/obj/item/weapon/gun/rifle/type71
	name = "71 式脉冲步枪"
	desc = "UPP 制式 71 式脉冲步枪，轻便且符合人体工学，使用 10x27mm 弹药。威力强于 USCM M41A，弥补了较低射速。精度虽一般，集成后坐抑制机构却让点射出乎意料地好控制。"
	icon = 'icons/obj/items/weapons/guns/guns_by_faction/upp.dmi'
	icon_state = "type71"
	item_state = "type71"

	fire_sound = 'sound/weapons/gun_type71.ogg'
	reload_sound = 'sound/weapons/handling/m41_reload.ogg'
	unload_sound = 'sound/weapons/handling/m41_unload.ogg'
	current_mag = /obj/item/ammo_magazine/rifle/type71
	wield_delay = WIELD_DELAY_FAST
	attachable_allowed = list(
		/obj/item/attachable/magnetic_harness, // Rail
		/obj/item/attachable/scope,
		/obj/item/attachable/scope/pve,
		/obj/item/attachable/scope/upp,
		/obj/item/attachable/scope/mini,
		/obj/item/attachable/scope/mini/upp,
		/obj/item/attachable/reddot,
		/obj/item/attachable/reddot/upp,
		/obj/item/attachable/reflex,
		/obj/item/attachable/reflex/upp,
		/obj/item/attachable/suppressor, // Muzzle
		/obj/item/attachable/bayonet,
		/obj/item/attachable/bayonet/upp,
		/obj/item/attachable/extended_barrel,
		/obj/item/attachable/heavy_barrel,
		/obj/item/attachable/verticalgrip, // Underbarrel
		/obj/item/attachable/verticalgrip/upp,
		/obj/item/attachable/flashlight/grip/upp,
		/obj/item/attachable/burstfire_assembly,
		/obj/item/attachable/attached_gun/flamer,
		/obj/item/attachable/attached_gun/flamer/advanced,
		/obj/item/attachable/attached_gun/extinguisher,
		/obj/item/attachable/attached_gun/grenade/type71,
		/obj/item/attachable/attached_gun/grenade/type71/preloaded,
		/obj/item/attachable/lasersight, // Side Rail
		/obj/item/attachable/lasersight/upp,
		/obj/item/attachable/flashlight,
		)
	starting_attachment_types = list(/obj/item/attachable/stock/type71, /obj/item/attachable/attached_gun/grenade/type71)
	flags_gun_features = GUN_AUTO_EJECTOR|GUN_CAN_POINTBLANK|GUN_AMMO_COUNTER
	flags_equip_slot = SLOT_BACK
	start_automatic = TRUE

/obj/item/weapon/gun/rifle/type71/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 33, "muzzle_y" = 17,"rail_x" = 10, "rail_y" = 23, "under_x" = 20, "under_y" = 13, "stock_x" = 11, "stock_y" = 13, "side_rail_x" = 23, "side_rail_y" = 16)

/obj/item/weapon/gun/rifle/type71/set_gun_config_values()
	..()
	set_fire_delay(FIRE_DELAY_TIER_9)
	set_burst_amount(BURST_AMOUNT_TIER_4)
	set_burst_delay(FIRE_DELAY_TIER_9)
	accuracy_mult = BASE_ACCURACY_MULT + HIT_ACCURACY_MULT_TIER_4
	accuracy_mult_unwielded = BASE_ACCURACY_MULT - HIT_ACCURACY_MULT_TIER_7
	scatter = SCATTER_AMOUNT_TIER_8
	burst_scatter_mult = SCATTER_AMOUNT_TIER_10
	scatter_unwielded = SCATTER_AMOUNT_TIER_4
	damage_mult = BASE_BULLET_DAMAGE_MULT
	recoil_unwielded = RECOIL_AMOUNT_TIER_3


/obj/item/weapon/gun/rifle/type71/preloaded
	starting_attachment_types = list(/obj/item/attachable/stock/type71, /obj/item/attachable/attached_gun/grenade/type71/preloaded)

/obj/item/weapon/gun/rifle/type71/unloaded
	current_mag = null
	flags_gun_features = GUN_AUTO_EJECTOR|GUN_CAN_POINTBLANK|GUN_AMMO_COUNTER|GUN_TRIGGER_SAFETY

/obj/item/weapon/gun/rifle/type71/carbine
	name = "\improper 71 式“突击队”脉冲步枪"
	desc = "罕见得多的 71 式改型，配有一体式消声器、瞄准镜，并进行了大量精细调校。许多零件都经过替换、锉修和改进，因此很少出现在突击队之外。"
	icon_state = "type73"
	item_state = "type73"
	fire_sound = "gun_silenced"
	wield_delay = 0 //Ends up being .5 seconds due to scope
	wield_delay = WIELD_DELAY_VERY_FAST
	inherent_traits = list(TRAIT_GUN_SILENCED)
	bonus_overlay_x = 2
	force = 20 //integrated melee mod from stock, which doesn't fit on the gun but is still clearly there on the sprite
	attachable_allowed = list(
		/obj/item/attachable/verticalgrip,
		/obj/item/attachable/verticalgrip/upp,
	)
	random_spawn_chance = 0
	random_spawn_rail = list()
	random_spawn_muzzle = list()
	bonus_overlay_x = 1
	bonus_overlay_y = 0
	starting_attachment_types = list(/obj/item/attachable/stock/type71, /obj/item/attachable/type73suppressor, /obj/item/attachable/scope/mini/upp)

/obj/item/weapon/gun/rifle/type71/carbine/set_gun_config_values()
	..()
	set_fire_delay(FIRE_DELAY_TIER_11)
	set_burst_delay(FIRE_DELAY_TIER_12)
	accuracy_mult = BASE_ACCURACY_MULT + HIT_ACCURACY_MULT_TIER_7
	accuracy_mult_unwielded = BASE_ACCURACY_MULT - HIT_ACCURACY_MULT_TIER_4
	scatter = SCATTER_AMOUNT_TIER_8
	damage_mult = BASE_BULLET_DAMAGE_MULT
	scatter_unwielded = SCATTER_AMOUNT_TIER_5
	recoil_unwielded = RECOIL_AMOUNT_TIER_4

/obj/item/weapon/gun/rifle/type71/carbine/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 35, "muzzle_y" = 17,"rail_x" = 10, "rail_y" = 22, "under_x" = 23, "under_y" = 14, "stock_x" = 21, "stock_y" = 18, "side_rail_x" = 24, "side_rail_y" = 17)

/obj/item/weapon/gun/rifle/lw317
	name = "\improper LW-317 脉冲卡宾枪"
	desc = "317 式轻武器，源于中国与亚洲国家合作体被吞并前的诺康军工，曾是联盟的近战武器。前联盟士兵也因其容易上手而青睐它。"
	desc_lore = "尽管进步人民联盟竭力销毁犬战遗留的中国与亚洲国家合作体武器库，中国武器仍常在黑市出现。它是各类叛军的可靠选择，更受主张复国的中国与亚洲国家合作体复仇主义者喜爱。"
	icon = 'icons/obj/items/weapons/guns/guns_by_faction/upp.dmi'
	icon_state = "lw317"
	item_state = "lw317"
	fire_sound = 'sound/weapons/gun_lw317.ogg'
	current_mag = /obj/item/ammo_magazine/rifle/lw317
	attachable_allowed = list(
		/obj/item/attachable/scope, // Rail
		/obj/item/attachable/scope/upp,
		/obj/item/attachable/scope/mini,
		/obj/item/attachable/scope/mini/upp,
		/obj/item/attachable/reddot,
		/obj/item/attachable/reddot/upp,
		/obj/item/attachable/reflex,
		/obj/item/attachable/reflex/upp,
		/obj/item/attachable/suppressor, // Muzzle
		/obj/item/attachable/extended_barrel,
		/obj/item/attachable/heavy_barrel,
		/obj/item/attachable/bayonet/canc,
		/obj/item/attachable/verticalgrip, // Underbarrel
		/obj/item/attachable/verticalgrip/upp,
		/obj/item/attachable/flashlight/grip/upp,
		)

	flags_gun_features = GUN_AUTO_EJECTOR|GUN_CAN_POINTBLANK|GUN_AMMO_COUNTER
	flags_equip_slot = SLOT_BACK
	start_automatic = TRUE

/obj/item/weapon/gun/rifle/lw317/set_gun_config_values()
	..()
	set_fire_delay(FIRE_DELAY_TIER_10)
	accuracy_mult_unwielded = BASE_ACCURACY_MULT - HIT_ACCURACY_MULT_TIER_4
	damage_mult = BASE_BULLET_DAMAGE_MULT
	scatter = SCATTER_AMOUNT_TIER_6
	scatter_unwielded = SCATTER_AMOUNT_TIER_4
	recoil_unwielded = RECOIL_AMOUNT_TIER_3

/obj/item/weapon/gun/rifle/lw317/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 33, "muzzle_y" = 17,"rail_x" = 16, "rail_y" = 23, "under_x" = 25, "under_y" = 12, "stock_x" = 21, "stock_y" = 18, "side_rail_x" = 24, "side_rail_y" = 17)

/obj/item/weapon/gun/rifle/lw317/dmr
	name = "\improper LW/RS-317 脉冲卡宾枪"
	desc = "317 式轻型狙击步枪。由 317 式卡宾枪改装的非传统精确射手步枪，旨在为游击队提供远程支援。改进内部机构提高了精度，但严重降低了射速。"
	current_mag = /obj/item/ammo_magazine/rifle/lw317/ap
	start_automatic = FALSE
	attachable_allowed = list(
		/obj/item/attachable/scope/variable_zoom/canc,
		/obj/item/attachable/lw317barrel,
		/obj/item/attachable/verticalgrip, // Underbarrel
		/obj/item/attachable/verticalgrip/upp,
		/obj/item/attachable/flashlight/grip/upp,
		)

/obj/item/weapon/gun/rifle/lw317/dmr/set_gun_config_values()
	..()
	set_fire_delay(FIRE_DELAY_TIER_SNIPER)
	set_burst_amount(BURST_AMOUNT_TIER_1)
	accuracy_mult = BASE_ACCURACY_MULT * 3
	scatter = SCATTER_AMOUNT_TIER_8
	damage_mult = BASE_BULLET_DAMAGE_MULT
	recoil = RECOIL_AMOUNT_TIER_5
	damage_falloff_mult = 0

/obj/item/weapon/gun/rifle/lw317/dmr/handle_starting_attachment()
	..()
	var/obj/item/attachable/barrel = new /obj/item/attachable/lw317barrel(src)
	barrel.flags_attach_features &= ~ATTACH_REMOVABLE
	barrel.Attach(src)
	update_attachable(barrel.slot)

	var/obj/item/attachable/scope/variable_zoom/canc/scope = new(src)
	scope.flags_attach_features &= ~ATTACH_REMOVABLE
	scope.Attach(src)
	update_attachable(scope.slot)

	//-------------------------------------------------------

//M49A Battle Rifle, standard USCM DMR

/obj/item/weapon/gun/rifle/m49a
	name = "M49A 战斗步枪"
	desc = "M49A 是 USCM 服役中的精确射手战斗步枪。无托布局使它非常适合侦察与火力支援小组。\n仅接受非高速型 M49A 弹匣。"
	icon_state = "m49a"
	item_state = "m49a"
	mouse_pointer = 'icons/effects/mouse_pointer/sniper_mouse.dmi'

	fire_sound = 'sound/weapons/gun_m49a.ogg'
	reload_sound = 'sound/weapons/handling/l42_reload.ogg'
	unload_sound = 'sound/weapons/handling/l42_unload.ogg'

	current_mag = /obj/item/ammo_magazine/rifle/m49a
	attachable_allowed = list(
		/obj/item/attachable/suppressor, // Barrel
		/obj/item/attachable/bayonet,
		/obj/item/attachable/bayonet/upp,
		/obj/item/attachable/bayonet/co2,
		/obj/item/attachable/extended_barrel,
		/obj/item/attachable/reddot, // Rail
		/obj/item/attachable/reflex,
		/obj/item/attachable/magnetic_harness,
		/obj/item/attachable/scope,
		/obj/item/attachable/scope/mini,
		/obj/item/attachable/scope/mini/army,
		/obj/item/attachable/scope/pve,
		/obj/item/attachable/scope/mini_iff,
		/obj/item/attachable/sling,
		/obj/item/attachable/bipod, // Under
		/obj/item/attachable/verticalgrip,
		/obj/item/attachable/angledgrip,
		/obj/item/attachable/attached_gun/shotgun,
		/obj/item/attachable/attached_gun/grenade/mk1,
		/obj/item/attachable/attached_gun/grenade/mk1/recon,
		/obj/item/attachable/lasersight, // Side Rail
		/obj/item/attachable/flashlight,
	)

	flags_gun_features = GUN_AUTO_EJECTOR|GUN_CAN_POINTBLANK|GUN_AMMO_COUNTER
	wield_delay = WIELD_DELAY_VERY_FAST
	aim_slowdown = SLOWDOWN_ADS_QUICK
	//map_specific_decoration = TRUE

/obj/item/weapon/gun/rifle/m49a/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 43, "muzzle_y" = 17,"rail_x" = 22, "rail_y" = 21, "under_x" = 30, "under_y" = 13, "stock_x" = 24, "stock_y" = 13, "side_rail_x" = 31, "side_rail_y" = 18, "special_x" = 37, "special_y" = 16)

/obj/item/weapon/gun/rifle/m49a/set_gun_config_values()
	..()
	set_fire_delay(FIRE_DELAY_TIER_4)
	set_burst_amount(0)
	accuracy_mult = BASE_ACCURACY_MULT + HIT_ACCURACY_MULT_TIER_5
	accuracy_mult_unwielded = BASE_ACCURACY_MULT - HIT_ACCURACY_MULT_TIER_4
	damage_mult = BASE_BULLET_DAMAGE_MULT
	recoil_unwielded = RECOIL_AMOUNT_TIER_1
	recoil = RECOIL_AMOUNT_TIER_4
	damage_falloff_mult = 0
	scatter = SCATTER_AMOUNT_TIER_8

/obj/item/weapon/gun/rifle/m49a/handle_starting_attachment()
	..()
	var/obj/item/attachable/m49a_barrel/integrated = new(src)
	integrated.flags_attach_features &= ~ATTACH_REMOVABLE
	integrated.Attach(src)
	update_attachable(integrated.slot)

/obj/item/weapon/gun/rifle/m49a/training
	current_mag = /obj/item/ammo_magazine/rifle/m49a/rubber

/obj/item/weapon/gun/rifle/m49a/tactical
	current_mag = /obj/item/ammo_magazine/rifle/m49a/ext
	starting_attachment_types = list(/obj/item/attachable/magnetic_harness, /obj/item/attachable/suppressor, /obj/item/attachable/angledgrip)

/obj/item/weapon/gun/rifle/m49a/marksman
	starting_attachment_types = list(/obj/item/attachable/scope/variable_zoom, /obj/item/attachable/extended_barrel)

/obj/item/weapon/gun/rifle/m49a/army
	desc = "M49A 战斗步枪是美洲联盟武装部队多个军种使用的精确射手步枪。无托布局使其十分适合侦察及火力支援小组。"
	current_mag = /obj/item/ammo_magazine/rifle/m49a/ap
	starting_attachment_types = list(/obj/item/attachable/scope/mini/army, /obj/item/attachable/extended_barrel, /obj/item/attachable/angledgrip)

/obj/item/weapon/gun/rifle/m49a/forecon
	name = "\improper M49A2 战斗步枪"
	desc = "M49A 精确射手步枪的早期改型，A2 调整了导气系统与击发组件，射速更高，并可两发点射。几乎只配发美国殖民地陆战队武装侦察单位。这把采用新款 Humbrol 76 迷彩涂装。"
	current_mag = /obj/item/ammo_magazine/rifle/m49a/ext
	starting_attachment_types = list(/obj/item/attachable/reddot, /obj/item/attachable/extended_barrel, /obj/item/attachable/verticalgrip)
	map_specific_decoration = FALSE
	icon = 'icons/obj/items/weapons/guns/guns_by_map/jungle/guns_obj.dmi'
	item_icons = list(
		WEAR_L_HAND = 'icons/obj/items/weapons/guns/guns_by_map/jungle/guns_lefthand.dmi',
		WEAR_R_HAND = 'icons/obj/items/weapons/guns/guns_by_map/jungle/guns_righthand.dmi',
		WEAR_BACK = 'icons/obj/items/weapons/guns/guns_by_map/jungle/back.dmi'
	)

/obj/item/weapon/gun/rifle/m49a/forecon/set_gun_config_values()
	..()
	set_fire_delay(FIRE_DELAY_TIER_5)
	set_burst_amount(BURST_AMOUNT_TIER_2)
	set_burst_delay(FIRE_DELAY_TIER_8)

/obj/item/weapon/gun/rifle/m49a/forecon/handle_starting_attachment()
	..()
	var/obj/item/attachable/m49a_barrel/forecon/integrated = new(src)
	integrated.flags_attach_features &= ~ATTACH_REMOVABLE
	var/obj/item/attachable/old_barrel = attachments[integrated.slot]
	if(old_barrel)
		old_barrel.Detach(detaching_gub = src, drop_attachment = FALSE)
		qdel(old_barrel)
	integrated.Attach(src)
	update_attachable(integrated.slot)

// pve - kinda weird icon usage, uses urban M49A sprite w/ custom attachie sprite
/obj/item/weapon/gun/rifle/m49a/pve
	name = "\improper M49A6 战斗步枪"
	desc = "阿玛特改进计划催生的强化 M49A，产量不大。最大卖点是可发射威力惊人的<b>A19 贫铀弹</b>，其过度穿透能力和对幸存者的毒性影响声名狼藉。当然，加厚枪管也可正常发射标准弹和普通高速弹。"
	desc_lore = "美国殖民地陆战队对未经验证的手持等离子武器兴趣不大。在最终采用 XM99A 之前，他们先寻求传统的班组便携精确穿甲武器，委托阿玛特改进 M49A 平台，以发射先进穿甲弹。他们算是成功了。<BR><BR>A6 被否决有多个原因：它既是杀器，也是废物。后坐力太强，精密瞄具无法保持归零；过大的枪口装置让本已很长的枪管更长。A19 弹药原本就昂贵，其规格又把价格推得离谱。贫铀很贵，而让 M49A 枪管寿命减半则更加昂贵。<BR><BR>不过，已经造出的枪仍可服役，因此在 XM99A 刚开始生产、供应不足的地方仍有配发。"
	icon = 'icons/obj/items/weapons/guns/guns_by_map/urban/guns_obj.dmi'
	icon_state = "m49a"
	item_state = "m49a"
	fire_sound = 'sound/weapons/gun_m49a.ogg'
	reload_sound = 'sound/weapons/handling/l42_reload.ogg'
	unload_sound = 'sound/weapons/handling/l42_unload.ogg'

	accepted_ammo = list(
		/obj/item/ammo_magazine/rifle/m49a,
		/obj/item/ammo_magazine/rifle/m49a/ap,
		/obj/item/ammo_magazine/rifle/m49a/ext,
		/obj/item/ammo_magazine/rifle/m49a/rubber,
		/obj/item/ammo_magazine/rifle/m49a/incendiary,
		/obj/item/ammo_magazine/rifle/m49a/heap,
		/obj/item/ammo_magazine/rifle/m49a/penetrating,
		/obj/item/ammo_magazine/rifle/m49a/custom,
		/obj/item/ammo_magazine/rifle/m49a/custom/incendiary,
		/obj/item/ammo_magazine/rifle/m49a/custom/explosive,
		/obj/item/ammo_magazine/rifle/m49a/custom/pve,
	)

	current_mag = /obj/item/ammo_magazine/rifle/m49a/custom/pve

	flags_gun_features = GUN_AUTO_EJECTOR|GUN_CAN_POINTBLANK|GUN_AMMO_COUNTER
	wield_delay = WIELD_DELAY_VERY_FAST
	aim_slowdown = SLOWDOWN_ADS_QUICK
	map_specific_decoration = FALSE

/obj/item/weapon/gun/rifle/m49a/pve/set_gun_config_values()
	..()
	set_fire_delay(FIRE_DELAY_TIER_4)
	damage_mult = BASE_BULLET_DAMAGE_MULT + BULLET_DAMAGE_MULT_TIER_1 //Chunky barrel for better muzzle velocity, but not as good as the custom one
	recoil_unwielded = RECOIL_AMOUNT_TIER_1
	recoil = RECOIL_AMOUNT_TIER_3

// obnoxiously enough, need to do this manually...
	item_icons = list(
		WEAR_L_HAND = 'icons/obj/items/weapons/guns/guns_by_map/urban/guns_lefthand.dmi',
		WEAR_R_HAND = 'icons/obj/items/weapons/guns/guns_by_map/urban/guns_righthand.dmi',
		WEAR_BACK = 'icons/obj/items/weapons/guns/guns_by_map/urban/back.dmi'
	)

/obj/item/weapon/gun/rifle/m49a/pve/handle_starting_attachment()
	..()
	var/obj/item/attachable/m49a_barrel/pve/integrated = new(src)
	integrated.flags_attach_features &= ~ATTACH_REMOVABLE
	var/obj/item/attachable/old_barrel = attachments[integrated.slot]
	if(old_barrel)
		old_barrel.Detach(detaching_gub = src, drop_attachment = FALSE)
		qdel(old_barrel)
	integrated.Attach(src)
	update_attachable(integrated.slot)

/obj/item/weapon/gun/rifle/m49a/pve/unloaded
	current_mag = null
	flags_gun_features = GUN_AUTO_EJECTOR|GUN_CAN_POINTBLANK|GUN_AMMO_COUNTER|GUN_TRIGGER_SAFETY

//-------------------------------------------------------

//L42A Battle Rifle

/obj/item/weapon/gun/rifle/l42a
	name = "L42A 脉冲步枪"
	desc = "L42A 脉冲步枪虽已老旧，却仍是美洲联盟民间常见的“运动”步枪，也是不少雇佣兵替代现代步枪的可靠选择。"
	icon = 'icons/obj/items/weapons/guns/guns_by_faction/uscm.dmi'
	icon_state = "l42mk1"
	item_state = "l42mk1"
	fire_sound = 'sound/weapons/gun_m39.ogg'
	reload_sound = 'sound/weapons/handling/l42_reload.ogg'
	unload_sound = 'sound/weapons/handling/l42_unload.ogg'
	current_mag = /obj/item/ammo_magazine/rifle/l42a
	attachable_allowed = list(
		/obj/item/attachable/suppressor,
		/obj/item/attachable/bayonet,
		/obj/item/attachable/bayonet/upp,
		/obj/item/attachable/bayonet/co2,
		/obj/item/attachable/reddot,
		/obj/item/attachable/reflex,
		/obj/item/attachable/flashlight,
		/obj/item/attachable/extended_barrel,
		/obj/item/attachable/magnetic_harness,
		/obj/item/attachable/stock/carbine,
		/obj/item/attachable/stock/carbine/wood,
		/obj/item/attachable/bipod,
		/obj/item/attachable/lasersight,
		/obj/item/attachable/scope,
		/obj/item/attachable/scope/mini,
		/obj/item/attachable/scope/mini_iff,
		/obj/item/attachable/flashlight/grip,
	)

	flags_gun_features = GUN_AUTO_EJECTOR|GUN_CAN_POINTBLANK|GUN_AMMO_COUNTER
	wield_delay = WIELD_DELAY_VERY_FAST
	aim_slowdown = SLOWDOWN_ADS_QUICK
	starting_attachment_types = list(/obj/item/attachable/stock/carbine)
	map_specific_decoration = FALSE

/obj/item/weapon/gun/rifle/l42a/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 32, "muzzle_y" = 19,"rail_x" = 12, "rail_y" = 20, "under_x" = 18, "under_y" = 15, "stock_x" = 22, "stock_y" = 10, "side_rail_x" = 22, "side_rail_y" = 17)

/obj/item/weapon/gun/rifle/l42a/set_gun_config_values()
	..()
	set_fire_delay(FIRE_DELAY_TIER_7)
	set_burst_amount(0)
	accuracy_mult = BASE_ACCURACY_MULT
	accuracy_mult_unwielded = BASE_ACCURACY_MULT - HIT_ACCURACY_MULT_TIER_8
	damage_mult = BASE_BULLET_DAMAGE_MULT
	recoil_unwielded = RECOIL_AMOUNT_TIER_3
	damage_falloff_mult = 0
	scatter = SCATTER_AMOUNT_TIER_8

/obj/item/weapon/gun/rifle/l42a/training
	current_mag = /obj/item/ammo_magazine/rifle/l42a/rubber

//-------------------------------------------------------
//-------------------------------------------------------
//ABR-40 hunting rifle

// Civilian version of the L42A, used for hunting, and also by undersupplied paramilitary groups.

/obj/item/weapon/gun/rifle/l42a/abr40
	name = "ABR-40 猎枪"
	desc = "L42A 战斗步枪的民用版本，几乎完全相同，甚至兼容 L42 弹匣。就是别把枪托拆了……"
	desc_lore = "ABR-40 与 L42A 同期开发，是面向民用市场的猎枪。它采用仿木制护木和法律规定的十二发弹匣，仍然精准而致命，深受经验丰富的猎人及退役陆战队员喜爱。不过，它只能安装导轨配件，配件选择非常有限；其结构与 L42 的差异也导致单手持枪时姿势十分别扭。不建议拆下枪托。"
	icon = 'icons/obj/items/weapons/guns/guns_by_faction/colony.dmi'
	icon_state = "abr40"
	item_state = "abr40"
	current_mag = /obj/item/ammo_magazine/rifle/l42a/abr40
	attachable_allowed = list(
		//Barrel,
		/obj/item/attachable/bayonet,
		/obj/item/attachable/bayonet/upp,
		/obj/item/attachable/bayonet/co2,
		//Rail,
		/obj/item/attachable/reddot,
		/obj/item/attachable/reflex,
		/obj/item/attachable/magnetic_harness,
		/obj/item/attachable/scope,
		/obj/item/attachable/scope/mini,
		/obj/item/attachable/scope/mini/hunting,
		//Stock,
		/obj/item/attachable/stock/carbine,
		/obj/item/attachable/stock/carbine/wood,
		/obj/item/attachable/stock/carbine/wood/tactical,
	)
	flags_gun_features = GUN_AUTO_EJECTOR|GUN_CAN_POINTBLANK|GUN_WIELDED_FIRING_ONLY|GUN_AMMO_COUNTER
	wield_delay = WIELD_DELAY_FAST
	starting_attachment_types = list(/obj/item/attachable/stock/carbine/wood, /obj/item/attachable/scope/mini/hunting)
	map_specific_decoration = FALSE
	civilian_usable_override = TRUE

// Identical to the L42 in stats, *except* for extra recoil and scatter that are nulled by keeping the stock on.
/obj/item/weapon/gun/rifle/l42a/abr40/set_gun_config_values()
	..()
	accuracy_mult = (BASE_ACCURACY_MULT + HIT_ACCURACY_MULT_TIER_5) - HIT_ACCURACY_MULT_TIER_10
	recoil = RECOIL_AMOUNT_TIER_4
	scatter = (SCATTER_AMOUNT_TIER_8) + SCATTER_AMOUNT_TIER_5


/obj/item/weapon/gun/rifle/l42a/abr40/tactical
	desc = "陆战队员常用 L42A 战斗步枪的民用版本，几乎完全相同，连 L42 弹匣都能通用，但别拆枪托。这把似乎装有独特的蓝黑色战术外装及其他第三方改件。"
	desc_lore = "L42 战斗步枪作为民用猎枪大受欢迎后，ABR-40 应运而生。凭借流畅简单的操控和对 L42A 弹匣的兼容性，它自然又流入许多资金不足的准军事组织及叛军手中。"
	icon_state = "abr40_tac"
	item_state = "abr40_tac"
	current_mag = /obj/item/ammo_magazine/rifle/l42a/ap
	attachable_allowed = list(
		//Barrel,
		/obj/item/attachable/suppressor,
		/obj/item/attachable/bayonet,
		/obj/item/attachable/bayonet/upp,
		/obj/item/attachable/bayonet/co2,
		//Rail,
		/obj/item/attachable/reddot,
		/obj/item/attachable/reflex,
		/obj/item/attachable/magnetic_harness,
		/obj/item/attachable/scope,
		/obj/item/attachable/scope/mini,
		/obj/item/attachable/scope/mini/hunting,
		//Under,
		/obj/item/attachable/flashlight/grip,
		//Stock,
		/obj/item/attachable/stock/carbine,
		/obj/item/attachable/stock/carbine/wood,
		/obj/item/attachable/stock/carbine/wood/tactical,
	)
	starting_attachment_types = list(/obj/item/attachable/stock/carbine/wood/tactical, /obj/item/attachable/suppressor)
	random_spawn_chance = 100
	random_spawn_rail = list(
		/obj/item/attachable/reflex,
		/obj/item/attachable/magnetic_harness,
		/obj/item/attachable/scope,
		/obj/item/attachable/scope/mini/hunting,
	)
	random_under_chance = 50
	random_spawn_under = list(/obj/item/attachable/flashlight/grip)

/obj/item/weapon/gun/rifle/l42a/abr40/tactical/assassin
	starting_attachment_types = list(/obj/item/attachable/stock/carbine/wood/tactical, /obj/item/attachable/scope/mini/hunting, /obj/item/attachable/suppressor)

//=OLD ROYAL MARINES RIFLES=\\

/obj/item/weapon/gun/rifle/rmc_f90
	name = "F903A1 步枪"
	desc = "皇家陆战队的旧制式步枪，如今常见于私人军事承包商或叛乱组织手中。在采用 L23A1 之前，皇家陆战队是唯一不使用脉冲武器的现代军队。使用 10x24mm 无壳弹。"
	icon = 'icons/obj/items/weapons/guns/guns_by_faction/twe_guns.dmi'
	icon_state = "aug"
	item_state = "aug"
	fire_sound = "gun_pulse"
	reload_sound = 'sound/weapons/handling/m41_reload.ogg'
	unload_sound = 'sound/weapons/handling/m41_unload.ogg'
	current_mag = /obj/item/ammo_magazine/rifle/rmc_f90
	flags_equip_slot = NO_FLAGS
	attachable_allowed = list(
		/obj/item/attachable/suppressor,
		/obj/item/attachable/bayonet,
		/obj/item/attachable/bayonet/upp,
		/obj/item/attachable/bayonet/co2,
		/obj/item/attachable/reddot,
		/obj/item/attachable/reflex,
		/obj/item/attachable/flashlight,
		/obj/item/attachable/extended_barrel,
		/obj/item/attachable/heavy_barrel,
		/obj/item/attachable/magnetic_harness,
	)
	flags_gun_features = GUN_AUTO_EJECTOR|GUN_CAN_POINTBLANK|GUN_AMMO_COUNTER
	map_specific_decoration = FALSE
	aim_slowdown = SLOWDOWN_ADS_QUICK

/obj/item/weapon/gun/rifle/rmc_f90/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 33, "muzzle_y" = 16,"rail_x" = 15, "rail_y" = 21, "under_x" = 24, "under_y" = 13, "stock_x" = 24, "stock_y" = 13, "side_rail_x" = 25, "side_rail_y" = 16)


/obj/item/weapon/gun/rifle/rmc_f90/set_gun_config_values()
	..()
	fire_delay = FIRE_DELAY_TIER_11
	burst_amount = BURST_AMOUNT_TIER_3
	burst_delay = FIRE_DELAY_TIER_11
	accuracy_mult = BASE_ACCURACY_MULT + HIT_ACCURACY_MULT_TIER_4 + 2*HIT_ACCURACY_MULT_TIER_1
	accuracy_mult_unwielded = BASE_ACCURACY_MULT - HIT_ACCURACY_MULT_TIER_7
	scatter = SCATTER_AMOUNT_TIER_8
	burst_scatter_mult = SCATTER_AMOUNT_TIER_10
	scatter_unwielded = SCATTER_AMOUNT_TIER_2
	damage_mult = BASE_BULLET_DAMAGE_MULT
	recoil_unwielded = RECOIL_AMOUNT_TIER_2

/obj/item/weapon/gun/rifle/rmc_f90/a_grip
	name = "F903A2 步枪"
	desc = "皇家陆战队旧制式步枪的变体，如今常见于私人军事承包商或叛乱组织手中。在采用 L23A1 之前，皇家陆战队是唯一不使用脉冲武器的现代军队。使用 10x24mm 无壳弹。"
	icon_state = "aug_com"
	item_state = "aug_com"
	attachable_allowed = list(
		/obj/item/attachable/suppressor,
		/obj/item/attachable/reddot,
		/obj/item/attachable/reflex,
		/obj/item/attachable/extended_barrel,
	)

/obj/item/weapon/gun/rifle/rmc_f90/a_grip/handle_starting_attachment()
	..()
	var/obj/item/attachable/angledgrip/f90_agrip = new(src)
	f90_agrip.flags_attach_features &= ~ATTACH_REMOVABLE
	f90_agrip.hidden = TRUE
	f90_agrip.Attach(src)
	update_attachable(f90_agrip.slot)

/obj/item/weapon/gun/rifle/rmc_f90/scope
	name = "F903A1 精确射手步枪"
	desc = "皇家陆战队旧制式步枪的变体，如今常见于私人军事承包商或叛乱组织手中。在采用 L23A1 之前，皇家陆战队是唯一不使用脉冲武器的现代军队。仅接受较小的 20 发 10x24mm 无壳弹匣。"
	icon_state = "aug_dmr"
	item_state = "aug_dmr"
	attachable_allowed = null
	current_mag = /obj/item/ammo_magazine/rifle/rmc_f90/marksman

/obj/item/weapon/gun/rifle/rmc_f90/scope/set_gun_config_values()
	..()
	fire_delay = FIRE_DELAY_TIER_11
	burst_amount = 0
	accuracy_mult = BASE_ACCURACY_MULT + HIT_ACCURACY_MULT_TIER_4 + 2*HIT_ACCURACY_MULT_TIER_1
	accuracy_mult_unwielded = BASE_ACCURACY_MULT - HIT_ACCURACY_MULT_TIER_7
	scatter = SCATTER_AMOUNT_TIER_8
	scatter_unwielded = SCATTER_AMOUNT_TIER_2
	damage_mult = BASE_BULLET_DAMAGE_MULT
	recoil_unwielded = RECOIL_AMOUNT_TIER_2
	damage_falloff_mult = 0

/obj/item/weapon/gun/rifle/rmc_f90/scope/handle_starting_attachment()
	..()
	var/obj/item/attachable/scope/mini/f90/f90_scope = new(src)
	var/obj/item/attachable/angledgrip/f90_agrip = new(src)
	var/obj/item/attachable/f90_dmr_barrel/f90_dmr_barrel = new(src)
	f90_scope.flags_attach_features &= ~ATTACH_REMOVABLE
	f90_agrip.flags_attach_features &= ~ATTACH_REMOVABLE
	f90_dmr_barrel.flags_attach_features &= ~ATTACH_REMOVABLE
	f90_scope.hidden = TRUE
	f90_agrip.hidden = TRUE
	f90_dmr_barrel.hidden = FALSE
	f90_agrip.Attach(src)
	f90_scope.Attach(src)
	f90_dmr_barrel.Attach(src)
	update_attachable(f90_agrip.slot)
	update_attachable(f90_scope.slot)
	update_attachable(f90_dmr_barrel.slot)

/obj/item/weapon/gun/rifle/rmc_f90/shotgun
	name = "F903A1/B“破门者”步枪"
	desc = "装有下挂霰弹枪的皇家陆战队旧制式步枪变体，如今常见于私人军事承包商或叛乱组织手中。在采用 L23A1 之前，皇家陆战队是唯一不使用脉冲武器的现代军队。使用 10x24mm 无壳弹。"
	icon_state = "aug_mkey"
	item_state = "aug_mkey"
	attachable_allowed = list(
		/obj/item/attachable/reddot,
		/obj/item/attachable/reflex,
	)

/obj/item/weapon/gun/rifle/rmc_f90/shotgun/set_gun_config_values()
	..()
	fire_delay = FIRE_DELAY_TIER_11
	burst_amount = BURST_AMOUNT_TIER_3
	burst_delay = FIRE_DELAY_TIER_11
	accuracy_mult = BASE_ACCURACY_MULT + HIT_ACCURACY_MULT_TIER_4 + 2*HIT_ACCURACY_MULT_TIER_1
	accuracy_mult_unwielded = BASE_ACCURACY_MULT - HIT_ACCURACY_MULT_TIER_2
	scatter = SCATTER_AMOUNT_TIER_8
	burst_scatter_mult = SCATTER_AMOUNT_TIER_10
	scatter_unwielded = SCATTER_AMOUNT_TIER_2
	damage_mult = BASE_BULLET_DAMAGE_MULT
	recoil_unwielded = RECOIL_OFF

/obj/item/weapon/gun/rifle/rmc_f90/shotgun/handle_starting_attachment()
	..()
	var/obj/item/attachable/attached_gun/shotgun/f90_shotgun = new(src)
	var/obj/item/attachable/f90_dmr_barrel/f90_shotgun_barrel = new(src)
	f90_shotgun.flags_attach_features &= ~ATTACH_REMOVABLE
	f90_shotgun_barrel.flags_attach_features &= ~ATTACH_REMOVABLE
	f90_shotgun_barrel.hidden = FALSE
	f90_shotgun.hidden = TRUE
	f90_shotgun.Attach(src)
	f90_shotgun_barrel.Attach(src)
	update_attachable(f90_shotgun.slot)
	update_attachable(f90_shotgun_barrel.slot)

//Intermediate Support Rifle
//=================================================
//=================================================

/obj/item/weapon/gun/rifle/isr
	name = "\improper MK.7 中型支援轻机枪"
	desc = "中型支援步枪，简称 ISR，是在使用 MAR 枪械平台的承包商抱怨其缺点后开发的。虽然技术上比标准 MAR 高一档……但也没高多少。"
	icon = 'icons/obj/items/weapons/guns/guns_by_faction/colony.dmi'
	icon_state = "isr"
	item_state = "isr"
	reload_sound = 'sound/weapons/handling/l42_reload.ogg'
	unload_sound = 'sound/weapons/handling/l42_unload.ogg'
	fire_sound = "gun_oldpulse"
	current_mag = /obj/item/ammo_magazine/rifle/isr
	starting_attachment_types = list(/obj/item/attachable/stock/isr, /obj/item/attachable/isr_barrel)
	attachable_allowed = list(
		/obj/item/attachable/reddot,
		/obj/item/attachable/flashlight,
		/obj/item/attachable/lasersight,
		/obj/item/attachable/isr_barrel,
		/obj/item/attachable/stock/isr,
	)

	flags_gun_features = GUN_CAN_POINTBLANK|GUN_WIELDED_FIRING_ONLY|GUN_AUTO_EJECT_CASINGS
	wield_delay = WIELD_DELAY_NORMAL
	map_specific_decoration = FALSE
	start_automatic = TRUE


/obj/item/weapon/gun/rifle/isr/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 33, "muzzle_y" = 16,"rail_x" = 12, "rail_y" = 22, "under_x" = 24, "under_y" = 13, "stock_x" = 5, "stock_y" = 20, "side_rail_x" = 20, "side_rail_y" = 16)

/obj/item/weapon/gun/rifle/isr/set_gun_config_values()
	..()
	set_fire_delay(FIRE_DELAY_TIER_LMG)
	set_burst_amount(BURST_AMOUNT_TIER_3)
	set_burst_delay(FIRE_DELAY_TIER_LMG)
	accuracy_mult = BASE_ACCURACY_MULT - HIT_ACCURACY_MULT_TIER_8
	accuracy_mult_unwielded = BASE_ACCURACY_MULT - HIT_ACCURACY_MULT_TIER_8
	scatter = SCATTER_AMOUNT_TIER_8
	burst_scatter_mult = SCATTER_AMOUNT_TIER_10
	scatter_unwielded = SCATTER_AMOUNT_TIER_5
	damage_mult = BASE_BULLET_DAMAGE_MULT + BULLET_DAMAGE_MULT_TIER_4
	recoil_unwielded = RECOIL_AMOUNT_TIER_2
	recoil = RECOIL_AMOUNT_TIER_5

/obj/item/weapon/gun/rifle/isr/modded
	starting_attachment_types = list(/obj/item/attachable/stock/isr, /obj/item/attachable/isr_barrel, /obj/item/attachable/flashlight, /obj/item/attachable/reddot)
