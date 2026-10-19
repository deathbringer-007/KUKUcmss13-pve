
/obj/item/weapon/gun/smg
	mouse_pointer = 'icons/effects/mouse_pointer/pistol_mouse.dmi'
	reload_sound = 'sound/weapons/handling/smg_reload.ogg'
	unload_sound = 'sound/weapons/handling/smg_unload.ogg'
	cocked_sound = 'sound/weapons/gun_cocked2.ogg'
	fire_sound = 'sound/weapons/gun_m39.ogg'

	force = 5
	w_class = SIZE_LARGE
	movement_onehanded_acc_penalty_mult = 4
	aim_slowdown = SLOWDOWN_ADS_QUICK
	wield_delay = WIELD_DELAY_VERY_FAST
	attachable_allowed = list(
		/obj/item/attachable/suppressor,
		/obj/item/attachable/reddot,
		/obj/item/attachable/reflex,
		/obj/item/attachable/flashlight,
		/obj/item/attachable/magnetic_harness,
	)

	flags_gun_features = GUN_AUTO_EJECTOR|GUN_CAN_POINTBLANK|GUN_AUTO_EJECT_CASINGS
	gun_category = GUN_CATEGORY_SMG
	start_automatic = TRUE

/obj/item/weapon/gun/smg/Initialize(mapload, spawn_empty)
	. = ..()
	if(current_mag && current_mag.current_rounds > 0)
		load_into_chamber()

/obj/item/weapon/gun/smg/unique_action(mob/user)
	cock(user)

/obj/item/weapon/gun/smg/set_gun_config_values()
	..()
	movement_onehanded_acc_penalty_mult = 4
	fa_max_scatter = SCATTER_AMOUNT_TIER_5

//-------------------------------------------------------
//M39 SMG

/obj/item/weapon/gun/smg/m39
	name = "毒蛇9 冲锋枪"
	desc = "因美国特勤局采用而走红的阿玛特战场系统 39 型冲锋枪，以“毒蛇9”为商品名，在私人安保公司中很常见。使用 9x19mm 弹药。"
	icon = 'icons/obj/items/weapons/guns/guns_by_faction/uscm.dmi'
	icon_state = "m39"
	item_state = "m39"
	fire_sound = "m4a3"
	flags_equip_slot = SLOT_BACK
	current_mag = /obj/item/ammo_magazine/smg/m39
	attachable_allowed = list(
		/obj/item/attachable/suppressor,
		/obj/item/attachable/reddot,
		/obj/item/attachable/reflex,
		/obj/item/attachable/angledgrip,
		/obj/item/attachable/verticalgrip,
		/obj/item/attachable/flashlight/grip,
		/obj/item/attachable/stock/smg,
		/obj/item/attachable/stock/smg/collapsible,
		/obj/item/attachable/compensator,
		/obj/item/attachable/lasersight,
		/obj/item/attachable/flashlight,
		/obj/item/attachable/extended_barrel,
		/obj/item/attachable/bayonet,
		/obj/item/attachable/bayonet/upp,
		/obj/item/attachable/bayonet/co2,
		/obj/item/attachable/heavy_barrel,
		/obj/item/attachable/scope/mini,
		/obj/item/attachable/magnetic_harness,
		/obj/item/attachable/sling,
		/obj/item/attachable/gyro,
		/obj/item/attachable/stock/smg/collapsible/brace,
	)

	flags_gun_features = GUN_AUTO_EJECTOR|GUN_CAN_POINTBLANK|GUN_AMMO_COUNTER|GUN_AUTO_EJECT_CASINGS
	starting_attachment_types = list(/obj/item/attachable/stock/smg/collapsible)
	map_specific_decoration = FALSE

/obj/item/weapon/gun/smg/m39/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 30, "muzzle_y" = 20,"rail_x" = 14, "rail_y" = 22, "under_x" = 21, "under_y" = 16, "stock_x" = 24, "stock_y" = 15, , "side_rail_x" = 25, "side_rail_y" = 19)

/obj/item/weapon/gun/smg/m39/set_gun_config_values()
	..()
	set_fire_delay(FIRE_DELAY_TIER_SMG)
	set_burst_delay(FIRE_DELAY_TIER_SMG)
	set_burst_amount(BURST_AMOUNT_TIER_3)
	accuracy_mult = BASE_ACCURACY_MULT - HIT_ACCURACY_MULT_TIER_7
	accuracy_mult_unwielded = BASE_ACCURACY_MULT - HIT_ACCURACY_MULT_TIER_5
	scatter = SCATTER_AMOUNT_TIER_4
	burst_scatter_mult = SCATTER_AMOUNT_TIER_8
	scatter_unwielded = SCATTER_AMOUNT_TIER_4
	damage_mult = BASE_BULLET_DAMAGE_MULT
	recoil_unwielded = RECOIL_AMOUNT_TIER_5
	fa_max_scatter = SCATTER_AMOUNT_TIER_10 + 0.5

/obj/item/weapon/gun/smg/m39/forecon
	name = "\improper M39 冲锋枪"
	desc = "少量配发给美国殖民地陆战队武装侦察单位的冲锋枪。M39 常被用作大容量副武器或备用枪械，而非进攻武器。这把采用了新款 Humbrol 76 迷彩涂装，使用 9×19 毫米弹药。"
	icon = 'icons/obj/items/weapons/guns/guns_by_map/jungle/guns_obj.dmi'
	current_mag = /obj/item/ammo_magazine/smg/m39/extended
	item_icons = list(
		WEAR_L_HAND = 'icons/obj/items/weapons/guns/guns_by_map/jungle/guns_lefthand.dmi',
		WEAR_R_HAND = 'icons/obj/items/weapons/guns/guns_by_map/jungle/guns_righthand.dmi',
		WEAR_BACK = 'icons/obj/items/weapons/guns/guns_by_map/jungle/back.dmi',
		WEAR_J_STORE = 'icons/obj/items/weapons/guns/guns_by_map/jungle/suit_slot.dmi'
	)

/obj/item/weapon/gun/smg/m39/training
	current_mag = /obj/item/ammo_magazine/smg/m39/rubber

/obj/item/weapon/gun/smg/m39/solidstock
	starting_attachment_types = list(/obj/item/attachable/stock/smg)

/obj/item/weapon/gun/smg/m39/tactical
	starting_attachment_types = list(/obj/item/attachable/stock/smg/collapsible,/obj/item/attachable/reflex,/obj/item/attachable/verticalgrip,/obj/item/attachable/suppressor)

/obj/item/weapon/gun/smg/m39/tactical/ap
	starting_attachment_types = list(/obj/item/attachable/stock/smg/collapsible,/obj/item/attachable/reflex,/obj/item/attachable/verticalgrip)
	current_mag = /obj/item/ammo_magazine/smg/m39/ap

//-------------------------------------------------------

/obj/item/weapon/gun/smg/m39/elite
	name = "M39B/2 冲锋枪"
	desc = "M-39 冲锋枪的改进版，重新设计以改善重量、操控性和精度，仅配发给精锐单位。"
	icon_state = "m39b2"
	item_state = "m39b2"
	current_mag = /obj/item/ammo_magazine/smg/m39/ap
	flags_gun_features = GUN_AUTO_EJECTOR|GUN_CAN_POINTBLANK|GUN_AMMO_COUNTER|GUN_WY_RESTRICTED|GUN_AUTO_EJECT_CASINGS
	map_specific_decoration = FALSE
	starting_attachment_types = list(/obj/item/attachable/stock/smg/collapsible)

	random_spawn_chance = 100
	random_spawn_rail = list(
		/obj/item/attachable/reddot,
		/obj/item/attachable/reflex,
		/obj/item/attachable/magnetic_harness,
	)
	random_spawn_under = list(
		/obj/item/attachable/angledgrip,
		/obj/item/attachable/flashlight/grip,
	)
	random_spawn_siderail = list(
		/obj/item/attachable/lasersight,
		/obj/item/attachable/flashlight,
	)
	random_spawn_muzzle = list(
		/obj/item/attachable/suppressor,
		/obj/item/attachable/bayonet,
		/obj/item/attachable/extended_barrel,
	)

/obj/item/weapon/gun/smg/m39/elite/set_gun_config_values()
	..()
	set_fire_delay(FIRE_DELAY_TIER_SMG)
	accuracy_mult = BASE_ACCURACY_MULT + HIT_ACCURACY_MULT_TIER_7
	accuracy_mult_unwielded = BASE_ACCURACY_MULT
	scatter = SCATTER_AMOUNT_TIER_9
	burst_scatter_mult = SCATTER_AMOUNT_TIER_10
	scatter_unwielded = SCATTER_AMOUNT_TIER_6
	damage_mult =  BASE_BULLET_DAMAGE_MULT + BULLET_DAMAGE_MULT_TIER_7

/obj/item/weapon/gun/smg/m39/elite/rmc
	name = "\improper L6A2 冲锋枪"
	desc = "皇家陆战队采用的 M39 冲锋枪改型，经重新设计以改善重量、操控性和精度。通常用于清理建筑等近距离战斗，在这些场合 L23A1 显得有些笨重。皇家陆战队员有时称它为“小阿玛特”。"
	icon_state = "m39"
	item_state = "m39"
	fire_sound = 'sound/weapons/gun_m39.ogg'
	current_mag = /obj/item/ammo_magazine/smg/m39/squash
	flags_gun_features = GUN_AUTO_EJECTOR|GUN_CAN_POINTBLANK|GUN_AMMO_COUNTER|GUN_AUTO_EJECT_CASINGS
	map_specific_decoration = FALSE
	starting_attachment_types = list(/obj/item/attachable/stock/smg/collapsible)
	current_mag = /obj/item/ammo_magazine/smg/m39/squash
	random_spawn_chance = 0

/obj/item/weapon/gun/smg/m39/elite/rmc/set_gun_config_values()
	..()
	set_fire_delay(FIRE_DELAY_TIER_SMG2)
	set_burst_delay(FIRE_DELAY_TIER_SMG2)
	set_burst_amount(BURST_AMOUNT_TIER_4)
	accuracy_mult = BASE_ACCURACY_MULT + HIT_ACCURACY_MULT_TIER_7
	accuracy_mult_unwielded = BASE_ACCURACY_MULT
	scatter = SCATTER_AMOUNT_TIER_9
	burst_scatter_mult = SCATTER_AMOUNT_TIER_10
	scatter_unwielded = SCATTER_AMOUNT_TIER_6
	damage_mult =  BASE_BULLET_DAMAGE_MULT + BULLET_DAMAGE_MULT_TIER_7

/obj/item/weapon/gun/smg/m39/elite/pve //duplex round
	name = "\improper M39B/3 冲锋枪"
	desc = "能够发射碎甲双头弹的实验型 M39。它比普通 M39 更重、更难操控，机匣更厚，弹速也更低。仍在少量生产。"
	desc_lore = "L165A1 给公司带来了一笔意外之财：小口径碎甲弹很受客户欢迎。但最初试制步枪口径的碎甲弹时出现了不少问题，其中增加装药导致膛压达到危险水平，引发提前爆炸和射击不准，还只是小问题。<BR><BR>得益于阿玛特的过度设计，M39 可承受的膛压远超高压弹药的水平。维兰德-汤谷退一步就轻松找到了办法：步枪弹压力过高怎么办？改成手枪弹。火力不足怎么办？改成双头弹。"
	current_mag = /obj/item/ammo_magazine/smg/m39/pve
	random_spawn_chance = 0
	fire_sound = 'sound/weapons/gun_m39.ogg'

/obj/item/weapon/gun/smg/m39/elite/whiteout//attachies + heap mag for whiteout.
	starting_attachment_types = list(/obj/item/attachable/stock/smg, /obj/item/attachable/suppressor, /obj/item/attachable/angledgrip, /obj/item/attachable/magnetic_harness)
	current_mag = /obj/item/ammo_magazine/smg/m39/heap

//-------------------------------------------------------
//M5, a classic SMG used in a lot of action movies.

/obj/item/weapon/gun/smg/mp5
	name = "MP5 冲锋枪"
	desc = "旧式 UPP 冲锋枪的仿制品，产自前德国某地，使用 9x19mm 有壳弹。"
	icon = 'icons/obj/items/weapons/guns/guns_by_faction/colony.dmi'
	icon_state = "mp5"
	item_state = "mp5"

	fire_sound = 'sound/weapons/smg_light.ogg'
	current_mag = /obj/item/ammo_magazine/smg/mp5
	attachable_allowed = list(
		/obj/item/attachable/suppressor, // Barrel
		/obj/item/attachable/bayonet,
		/obj/item/attachable/bayonet/upp,
		/obj/item/attachable/bayonet/co2,
		/obj/item/attachable/extended_barrel,
		/obj/item/attachable/heavy_barrel,
		/obj/item/attachable/compensator,
		/obj/item/attachable/reddot, // Rail
		/obj/item/attachable/reflex,
		/obj/item/attachable/magnetic_harness,
		/obj/item/attachable/scope/mini,
		/obj/item/attachable/gyro, // Under
		/obj/item/attachable/bipod,
		/obj/item/attachable/burstfire_assembly,
		/obj/item/attachable/attached_gun/grenade/m203,
		/obj/item/attachable/lasersight, // Side Rail
		/obj/item/attachable/flashlight,
		)

	flags_gun_features = GUN_CAN_POINTBLANK|GUN_ANTIQUE|GUN_AUTO_EJECT_CASINGS



/obj/item/weapon/gun/smg/mp5/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 30, "muzzle_y" = 17,"rail_x" = 12, "rail_y" = 19, "under_x" = 23, "under_y" = 15, "stock_x" = 28, "stock_y" = 17, "side_rail_x" = 27, "side_rail_y" = 17)

/obj/item/weapon/gun/smg/mp5/set_gun_config_values()
	..()
	set_fire_delay(FIRE_DELAY_TIER_11)
	set_burst_delay(FIRE_DELAY_TIER_SMG)
	set_burst_amount(BURST_AMOUNT_TIER_3)

	accuracy_mult = BASE_ACCURACY_MULT + HIT_ACCURACY_MULT_TIER_4
	accuracy_mult_unwielded = BASE_ACCURACY_MULT - HIT_ACCURACY_MULT_TIER_4
	scatter = SCATTER_AMOUNT_TIER_8
	burst_scatter_mult = SCATTER_AMOUNT_TIER_8
	scatter_unwielded = SCATTER_AMOUNT_TIER_5
	damage_mult = BASE_BULLET_DAMAGE_MULT + BULLET_DAMAGE_MULT_TIER_4
	recoil_unwielded = RECOIL_AMOUNT_TIER_5

/obj/item/weapon/gun/smg/mp5/Initialize(mapload, spawn_empty)
	. = ..()
	if(prob(10))
		var/obj/item/attachable/attached_gun/grenade/m203/UGL = new(src)
		UGL.Attach(src)
		update_attachable(UGL.slot)

//-------------------------------------------------------
//MP27, based on the MP27, based on the M7.

/obj/item/weapon/gun/smg/mp27
	name = "MP27 冲锋枪"
	desc = "曾是体面的武器，但设计文件于 67 年泄露后，廉价仿品遍地都是。重量轻、射速快，可几乎所有仿品粗劣的做工都严重拖累了精度。"
	icon = 'icons/obj/items/weapons/guns/guns_by_faction/colony.dmi'
	icon_state = "mp7"
	item_state = "mp7"
	fire_sound = 'sound/weapons/smg_light.ogg'
	current_mag = /obj/item/ammo_magazine/smg/mp27
	attachable_allowed = list(
		/obj/item/attachable/suppressor, // Barrel
		/obj/item/attachable/bayonet,
		/obj/item/attachable/bayonet/upp,
		/obj/item/attachable/bayonet/co2,
		/obj/item/attachable/extended_barrel,
		/obj/item/attachable/heavy_barrel,
		/obj/item/attachable/compensator,
		/obj/item/attachable/reddot, // Rail
		/obj/item/attachable/reflex,
		/obj/item/attachable/magnetic_harness,
		/obj/item/attachable/scope/mini,
		/obj/item/attachable/gyro, // Under
		/obj/item/attachable/bipod,
		/obj/item/attachable/burstfire_assembly,
		/obj/item/attachable/lasersight, // Side Rail
		/obj/item/attachable/flashlight,
		)

	flags_gun_features = GUN_AUTO_EJECTOR|GUN_CAN_POINTBLANK|GUN_AUTO_EJECT_CASINGS
	aim_slowdown = SLOWDOWN_ADS_NONE


/obj/item/weapon/gun/smg/mp27/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 33, "muzzle_y" = 19,"rail_x" = 12, "rail_y" = 20, "under_x" = 23, "under_y" = 16, "stock_x" = 28, "stock_y" = 17, "side_rail_x" = 26, "side_rail_y" = 17)

/obj/item/weapon/gun/smg/mp27/set_gun_config_values()
	..()
	set_fire_delay(FIRE_DELAY_TIER_SMG)
	set_burst_delay(FIRE_DELAY_TIER_SMG)
	set_burst_amount(BURST_AMOUNT_TIER_2)
	accuracy_mult = BASE_ACCURACY_MULT
	accuracy_mult_unwielded = BASE_ACCURACY_MULT - HIT_ACCURACY_MULT_TIER_2
	scatter = SCATTER_AMOUNT_TIER_4 + (SCATTER_AMOUNT_TIER_10 * 0.5)
	burst_scatter_mult = SCATTER_AMOUNT_TIER_8 + (SCATTER_AMOUNT_TIER_10 * 0.5)
	scatter_unwielded = SCATTER_AMOUNT_TIER_4 + SCATTER_AMOUNT_TIER_10
	damage_mult = BASE_BULLET_DAMAGE_MULT
	recoil_unwielded = RECOIL_AMOUNT_TIER_5

//-------------------------------------------------------
//PPSH //Based on the PPSh-41.

#define PPSH_UNJAM_CHANCE 25

/obj/item/weapon/gun/smg/ppsh
	name = "\improper PPSh-17b 冲锋枪"
	desc = "某个第三世界破地方研制的原型冲锋枪，经过仿制再被未经授权地翻制而成。"
	icon = 'icons/obj/items/weapons/guns/guns_by_faction/upp.dmi'
	icon_state = "ppsh17b"
	item_state = "ppsh17b"

	fire_sound = 'sound/weapons/smg_heavy.ogg'
	current_mag = /obj/item/ammo_magazine/smg/ppsh
	flags_gun_features = GUN_CAN_POINTBLANK|GUN_ANTIQUE|GUN_AUTO_EJECT_CASINGS
	starting_attachment_types = list(/obj/item/attachable/stock/ppsh)
	var/jammed = FALSE

/obj/item/weapon/gun/smg/ppsh/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 33, "muzzle_y" = 17,"rail_x" = 15, "rail_y" = 19, "under_x" = 26, "under_y" = 15, "stock_x" = 18, "stock_y" = 15, "side_rail_x" = 18, "side_rail_y" = 16)

/obj/item/weapon/gun/smg/ppsh/set_gun_config_values()
	..()
	set_fire_delay(FIRE_DELAY_TIER_SMG)
	set_burst_delay(FIRE_DELAY_TIER_SMG)
	set_burst_amount(BURST_AMOUNT_TIER_3)
	accuracy_mult = BASE_ACCURACY_MULT
	accuracy_mult_unwielded = BASE_ACCURACY_MULT - HIT_ACCURACY_MULT_TIER_5
	scatter = SCATTER_AMOUNT_TIER_4
	burst_scatter_mult = SCATTER_AMOUNT_TIER_4
	scatter_unwielded = SCATTER_AMOUNT_TIER_4
	damage_mult = BASE_BULLET_DAMAGE_MULT
	recoil_unwielded = RECOIL_AMOUNT_TIER_5
	fa_max_scatter = SCATTER_AMOUNT_TIER_9
	fa_scatter_peak = 1 // Seems a bit funny, but it works pretty well in the end

/obj/item/weapon/gun/smg/ppsh/with_drum_mag
	current_mag = /obj/item/ammo_magazine/smg/ppsh/extended

// Special feature! The PPSH can jam with the drum magazine, and will also receive handling debuffs when using one.

/obj/item/weapon/gun/smg/ppsh/Fire(atom/target, mob/living/user, params, reflex = 0, dual_wield)
	var/obj/item/ammo_magazine/smg/ppsh/ppsh_mag =  current_mag
	if(jammed)
		if(world.time % 3)
			playsound(src, 'sound/weapons/handling/gun_jam_click.ogg', 35, TRUE)
			to_chat(user, SPAN_WARNING("你的枪卡壳了！反复使用“武器特殊操作”来排除故障！"))
			balloon_alert(user, "*卡壳*")
		return NONE
	else if(prob(ppsh_mag?.jam_chance))
		jammed = TRUE
		playsound(src, 'sound/weapons/handling/gun_jam_initial_click.ogg', 50, FALSE)
		user.visible_message(SPAN_DANGER("[src]发出明显的咔嗒声！"), SPAN_HIGHDANGER("[src]突然卡壳，无法开火！反复使用“武器特殊操作”来排除故障。"))
		balloon_alert(user, "*卡壳*")
		return NONE
	else
		return ..()

/obj/item/weapon/gun/smg/ppsh/unique_action(mob/user)
	if(jammed)
		if(prob(PPSH_UNJAM_CHANCE))
			to_chat(user, SPAN_GREEN("你成功排除了[src]的卡壳故障！"))
			playsound(src, 'sound/weapons/handling/gun_jam_rack_success.ogg', 50, FALSE)
			jammed = FALSE
			cock_cooldown += 1 SECONDS //so they dont accidentally cock a bullet away
			balloon_alert(user, "*故障排除！*")
		else
			to_chat(user, SPAN_NOTICE("你开始猛拉[src]的枪机，试图排除卡壳故障！"))
			playsound(src, "gun_jam_rack", 50, FALSE)
			balloon_alert(user, "*拉动枪机*")
		return
	. = ..()

/obj/item/weapon/gun/smg/ppsh/unload(mob/user, reload_override, drop_override, loc_override)
	. = ..()
	aim_slowdown = SLOWDOWN_ADS_QUICK
	wield_delay = WIELD_DELAY_VERY_FAST

/obj/item/weapon/gun/smg/ppsh/reload(mob/user, obj/item/ammo_magazine/magazine)
	var/obj/item/ammo_magazine/smg/ppsh/ppsh_mag = magazine

	if( (ppsh_mag.bonus_mag_aim_slowdown || ppsh_mag.bonus_mag_wield_delay) && user)
		to_chat(user, SPAN_WARNING("装上[magazine]后，[src]明显笨重了许多。操控性大概会比平常差很多。"))

	aim_slowdown = SLOWDOWN_ADS_QUICK + ppsh_mag.bonus_mag_aim_slowdown
	wield_delay = WIELD_DELAY_VERY_FAST + ppsh_mag.bonus_mag_wield_delay
	update_icon()
	. = ..()

/obj/item/weapon/gun/smg/ppsh/update_icon()
	..()
	var/obj/item/ammo_magazine/smg/ppsh/ppsh_mag = current_mag
	if(ppsh_mag && ppsh_mag.new_item_state)
		item_state = ppsh_mag.new_item_state
		ppsh_mag.update_icon()

#undef PPSH_UNJAM_CHANCE

//-------------------------------------------------------
//Type-19,

/obj/item/weapon/gun/smg/pps43
	name = "\improper 19 式冲锋枪" //placeholder
	desc = "产自进步人民联盟的老式冲锋枪，虽然过时，却可靠且威力强大。联盟仍在少量使用，但它更常见于准军事组织或公司安保部队，通常搭配 35 发直弹匣或 71 发弹鼓。"
	icon = 'icons/obj/items/weapons/guns/guns_by_faction/upp.dmi'
	icon_state = "insasu"
	item_state = "insasu"

	fire_sound = 'sound/weapons/smg_heavy.ogg'
	current_mag = /obj/item/ammo_magazine/smg/pps43
	flags_gun_features = GUN_AUTO_EJECTOR|GUN_CAN_POINTBLANK|GUN_AMMO_COUNTER|GUN_AUTO_EJECT_CASINGS
	attachable_allowed = list(
		/obj/item/attachable/suppressor,
		/obj/item/attachable/reddot,
		/obj/item/attachable/reflex,
		/obj/item/attachable/flashlight/grip,
		/obj/item/attachable/verticalgrip,
		/obj/item/attachable/lasersight,
		/obj/item/attachable/flashlight,
		/obj/item/attachable/extended_barrel,
		/obj/item/attachable/magnetic_harness,
	)

/obj/item/weapon/gun/smg/pps43/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 33, "muzzle_y" = 20,"rail_x" = 20, "rail_y" = 24, "under_x" = 25, "under_y" = 17, "stock_x" = 26, "stock_y" = 15, "side_rail_x" = 23, "side_rail_y" = 19)

/obj/item/weapon/gun/smg/pps43/set_gun_config_values()
	..()
	fire_delay = FIRE_DELAY_TIER_SMG
	burst_delay = FIRE_DELAY_TIER_SMG
	burst_amount = BURST_AMOUNT_TIER_3
	accuracy_mult = BASE_ACCURACY_MULT + HIT_ACCURACY_MULT_TIER_3
	accuracy_mult_unwielded = BASE_ACCURACY_MULT - HIT_ACCURACY_MULT_TIER_5
	scatter = SCATTER_AMOUNT_TIER_6
	burst_scatter_mult = SCATTER_AMOUNT_TIER_4
	scatter_unwielded = SCATTER_AMOUNT_TIER_4
	damage_mult = BASE_BULLET_DAMAGE_MULT + BULLET_DAMAGE_MULT_TIER_4
	recoil_unwielded = RECOIL_AMOUNT_TIER_5

/obj/item/weapon/gun/smg/pps43/extended_mag
	current_mag = /obj/item/ammo_magazine/smg/pps43/extended
//-------------------------------------------------------
//Type 64

/obj/item/weapon/gun/smg/bizon
	name = "64 式冲锋枪"
	desc = "UPP 制式冲锋枪，采用少见的 64 发螺旋弹匣，射速高且精度出众。这一把装有仿木握把，表明是民用或出口型号。"
	desc_lore = "64 式冲锋枪不仅落在进步人民联盟士兵手中，也广泛出现在叛军、公司安保、雇佣兵、装备较差的军队，以及几乎所有类似组织和人员手里。"
	icon = 'icons/obj/items/weapons/guns/guns_by_faction/upp.dmi'
	icon_state = "type64"
	item_state = "type64"

	fire_sound = 'sound/weapons/smg_heavy.ogg'
	current_mag = /obj/item/ammo_magazine/smg/bizon
	flags_gun_features = GUN_AUTO_EJECTOR|GUN_CAN_POINTBLANK|GUN_AMMO_COUNTER|GUN_AUTO_EJECT_CASINGS
	wield_delay = WIELD_DELAY_MIN
	attachable_allowed = list(
		/obj/item/attachable/suppressor, // Barrel
		/obj/item/attachable/extended_barrel,
		/obj/item/attachable/heavy_barrel,
		/obj/item/attachable/compensator,
		/obj/item/attachable/reddot, // Rail
		/obj/item/attachable/reflex,
		/obj/item/attachable/reflex/upp,
		/obj/item/attachable/flashlight,
		/obj/item/attachable/scope/mini_iff,
		/obj/item/attachable/scope/pve,
		/obj/item/attachable/lasersight, // Under
		/obj/item/attachable/lasersight/upp,
		/obj/item/attachable/burstfire_assembly,
		)

/obj/item/weapon/gun/smg/bizon/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 33, "muzzle_y" = 20,"rail_x" = 18, "rail_y" = 23, "under_x" = 26, "under_y" = 15, "stock_x" = 26, "stock_y" = 15, "side_rail_x" = 27, "side_rail_y" = 18)

/obj/item/weapon/gun/smg/bizon/set_gun_config_values()
	..()
	fire_delay = FIRE_DELAY_TIER_SMG
	burst_delay = FIRE_DELAY_TIER_SMG
	burst_amount = BURST_AMOUNT_TIER_4
	accuracy_mult = BASE_ACCURACY_MULT + HIT_ACCURACY_MULT_TIER_5
	accuracy_mult_unwielded = BASE_ACCURACY_MULT + HIT_ACCURACY_MULT_TIER_3
	scatter = SCATTER_AMOUNT_TIER_9
	burst_scatter_mult = SCATTER_AMOUNT_TIER_8
	scatter_unwielded = SCATTER_AMOUNT_TIER_4
	damage_mult = BASE_BULLET_DAMAGE_MULT + BULLET_DAMAGE_MULT_TIER_3
	recoil_unwielded = RECOIL_AMOUNT_TIER_5

/obj/item/weapon/gun/smg/bizon/upp
	name = "64 式冲锋枪"
	desc = "进步人民联盟的制式冲锋枪，采用少见的 64 发螺旋弹筒，射速高，却有着出奇的精度。这把配有黑色聚合物握把，表明它属于联盟军队。"
	desc_lore = "64 式并非只有进步人民联盟士兵在用；叛军、公司安保、雇佣兵、装备较差的军队，以及形形色色的人都在使用它。"
	icon_state = "type64_u"
	item_state = "type64"

/obj/item/weapon/gun/smg/bizon/upp/stored
	current_mag = null
	flags_gun_features = /obj/item/weapon/gun/smg/bizon/upp::flags_gun_features | GUN_TRIGGER_SAFETY
	starting_attachment_types = list(/obj/item/attachable/reflex/upp, /obj/item/attachable/flashlight)

//-------------------------------------------------------
//GENERIC UZI //Based on the uzi submachinegun, of course.

/obj/item/weapon/gun/smg/mac15
	name = "MAC-15 冲锋枪"
	desc = "廉价可靠的设计与制造，使这把随处可见的冲锋枪虽已老旧，仍然实用。" //Includes proprietary 'full-auto' mode, banned in several Geneva Suggestions rim-wide.
	icon = 'icons/obj/items/weapons/guns/guns_by_faction/colony.dmi'
	icon_state = "mac15"
	item_state = "mac15"

	fire_sound = 'sound/weapons/gun_mac15.ogg'
	current_mag = /obj/item/ammo_magazine/smg/mac15
	flags_gun_features = GUN_ANTIQUE|GUN_CAN_POINTBLANK|GUN_ONE_HAND_WIELDED|GUN_AUTO_EJECT_CASINGS //|GUN_HAS_FULL_AUTO|GUN_FULL_AUTO_ON|GUN_FULL_AUTO_ONLY commented out until better fullauto code

	attachable_allowed = list(
		/obj/item/attachable/suppressor, // Barrel
		/obj/item/attachable/extended_barrel,
		/obj/item/attachable/heavy_barrel,
		/obj/item/attachable/compensator,
		/obj/item/attachable/reddot, // Rail
		/obj/item/attachable/reflex,
		/obj/item/attachable/flashlight,
		/obj/item/attachable/scope/mini,
		/obj/item/attachable/lasersight, // Under
		/obj/item/attachable/burstfire_assembly,
		)
	wield_delay = WIELD_DELAY_NONE
	aim_slowdown = SLOWDOWN_ADS_NONE

/obj/item/weapon/gun/smg/mac15/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 29, "muzzle_y" = 21,"rail_x" = 13, "rail_y" = 24, "under_x" = 19, "under_y" = 18, "stock_x" = 22, "stock_y" = 16, "side_rail_x" = 22, "side_rail_y" = 20)

/obj/item/weapon/gun/smg/mac15/set_gun_config_values()
	..()

	fa_scatter_peak = FULL_AUTO_SCATTER_PEAK_TIER_7
	fa_max_scatter = SCATTER_AMOUNT_TIER_3
	set_fire_delay(FIRE_DELAY_TIER_12)
	accuracy_mult = BASE_ACCURACY_MULT
	scatter = SCATTER_AMOUNT_TIER_5
	burst_scatter_mult = SCATTER_AMOUNT_TIER_8
	damage_mult = BASE_BULLET_DAMAGE_MULT - BULLET_DAMAGE_MULT_TIER_2

/obj/item/weapon/gun/smg/mac15/extended
	current_mag = /obj/item/ammo_magazine/smg/mac15/extended

//-------------------------------------------------------
// DAS REAL UZI

#define UZI_UNJAM_CHANCE 25

/obj/item/weapon/gun/smg/uzi
	name = "\improper 乌兹冲锋枪"
	desc = "已有近两个世纪历史的古董枪械。9 毫米，全自动。扣下扳机，握紧就行。"
	icon = 'icons/obj/items/weapons/guns/guns_by_faction/colony.dmi'
	icon_state = "uzi"
	item_state = "uzi"
	flags_equip_slot = SLOT_WAIST
	fire_sound = 'sound/weapons/gun_uzi.ogg'
	current_mag = /obj/item/ammo_magazine/smg/uzi
	flags_gun_features = GUN_ANTIQUE|GUN_CAN_POINTBLANK|GUN_ONE_HAND_WIELDED|GUN_AUTO_EJECT_CASINGS //|GUN_HAS_FULL_AUTO|GUN_FULL_AUTO_ON|GUN_FULL_AUTO_ONLY commented out until better fullauto code

	attachable_allowed = list(
		/obj/item/attachable/suppressor, // Barrel
		/obj/item/attachable/extended_barrel,
		/obj/item/attachable/heavy_barrel,
		/obj/item/attachable/compensator,
		/obj/item/attachable/reddot, // Rail
		/obj/item/attachable/reflex,
		/obj/item/attachable/flashlight,
		/obj/item/attachable/scope/mini,
		/obj/item/attachable/lasersight, // Under
		/obj/item/attachable/burstfire_assembly,
		)
	wield_delay = WIELD_DELAY_MIN
	aim_slowdown = SLOWDOWN_ADS_QUICK
	var/jammed = FALSE

/obj/item/weapon/gun/smg/uzi/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 28, "muzzle_y" = 20,"rail_x" = 12, "rail_y" = 22, "under_x" = 22, "under_y" = 16, "stock_x" = 22, "stock_y" = 16, "side_rail_x" = 23, "side_rail_y" = 18)

/obj/item/weapon/gun/smg/uzi/set_gun_config_values()
	..()

	fa_scatter_peak = FULL_AUTO_SCATTER_PEAK_TIER_5
	fa_max_scatter = SCATTER_AMOUNT_TIER_5
	set_fire_delay(FIRE_DELAY_TIER_11)
	accuracy_mult = BASE_ACCURACY_MULT + HIT_ACCURACY_MULT_TIER_2
	accuracy_mult_unwielded = BASE_ACCURACY_MULT - HIT_ACCURACY_MULT_TIER_2
	scatter = SCATTER_AMOUNT_TIER_6
	scatter_unwielded = SCATTER_AMOUNT_TIER_3
	damage_mult = BASE_BULLET_DAMAGE_MULT + BULLET_DAMAGE_MULT_TIER_2
	recoil_unwielded = RECOIL_AMOUNT_TIER_5

// The UZI can also jam, though it's less likely.

/obj/item/weapon/gun/smg/uzi/Fire(atom/target, mob/living/user, params, reflex = 0, dual_wield)
	var/obj/item/ammo_magazine/smg/uzi/uzi_mag = current_mag
	if(jammed)
		if(world.time % 3)
			playsound(src, 'sound/weapons/handling/gun_jam_click.ogg', 35, TRUE)
			to_chat(user, SPAN_WARNING("你的枪卡壳了！反复使用“武器特殊操作”来排除故障！"))
			balloon_alert(user, "*卡壳*")
		return NONE
	else if(prob(uzi_mag.jam_chance))
		jammed = TRUE
		playsound(src, 'sound/weapons/handling/gun_jam_initial_click.ogg', 35, TRUE)
		user.visible_message(SPAN_DANGER("[src]发出明显的咔嗒声！"), SPAN_HIGHDANGER("[src]突然卡壳，无法开火！反复使用“武器特殊操作”来排除故障。"))
		balloon_alert(user, "*卡壳*")
		return NONE
	else
		return ..()

/obj/item/weapon/gun/smg/uzi/unique_action(mob/user)
	if(jammed)
		if(prob(UZI_UNJAM_CHANCE))
			to_chat(user, SPAN_GREEN("你成功排除了[src]的卡壳故障！"))
			playsound(src, 'sound/weapons/handling/gun_jam_rack_success.ogg', 35, TRUE)
			jammed = FALSE
			cock_cooldown += 1 SECONDS //so they dont accidentally cock a bullet away
			balloon_alert(user, "*故障排除！*")
		else
			to_chat(user, SPAN_NOTICE("你开始猛拉[src]的枪机，试图排除卡壳故障！"))
			playsound(src, "gun_jam_rack", 50, FALSE)
			balloon_alert(user, "*拉动枪机*")
		return
	. = ..()

#undef UZI_UNJAM_CHANCE

//-------------------------------------------------------
//FP9000 //Based on the FN P90

/obj/item/weapon/gun/smg/fp9000
	name = "\improper FN FP9000 冲锋枪"
	desc = "设计虽老，却经得起时间考验。一份泄露且未加密的 3D 打印图纸，加上极为坚固且制造成本适中的枪身，使它在一个多世纪里始终是边疆殖民地和私人安保公司的主力武器。"
	icon = 'icons/obj/items/weapons/guns/guns_by_faction/colony.dmi'
	icon_state = "fp9000"
	item_state = "fp9000"

	fire_sound = 'sound/weapons/gun_p90.ogg'
	current_mag = /obj/item/ammo_magazine/smg/fp9000

	attachable_allowed = list(
		/obj/item/attachable/compensator,
		/obj/item/attachable/lasersight,
		/obj/item/attachable/extended_barrel,
		/obj/item/attachable/heavy_barrel,
	)
	random_spawn_chance = 65
	random_spawn_siderail = list(
		/obj/item/attachable/lasersight,
	)
	random_spawn_muzzle = list(
		/obj/item/attachable/compensator,
		/obj/item/attachable/extended_barrel,
	)

	flags_gun_features = GUN_AUTO_EJECTOR|GUN_CAN_POINTBLANK|GUN_AUTO_EJECT_CASINGS

/obj/item/weapon/gun/smg/fp9000/handle_starting_attachment()
	..()
	var/obj/item/attachable/scope/mini/S = new(src)
	S.icon_state = "miniscope_fp9000"
	S.attach_icon = "miniscope_fp9000_a" // Custom
	S.flags_attach_features &= ~ATTACH_REMOVABLE
	S.Attach(src)
	update_attachable(S.slot)

/obj/item/weapon/gun/smg/fp9000/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 33, "muzzle_y" = 18,"rail_x" = 20, "rail_y" = 21, "under_x" = 26, "under_y" = 16, "stock_x" = 22, "stock_y" = 16, "side_rail_x" = 25, "side_rail_y" = 17)

/obj/item/weapon/gun/smg/fp9000/set_gun_config_values()
	..()
	set_fire_delay(FIRE_DELAY_TIER_SMG)
	set_burst_delay(FIRE_DELAY_TIER_SMG)
	set_burst_amount(BURST_AMOUNT_TIER_3)
	accuracy_mult = BASE_ACCURACY_MULT + HIT_ACCURACY_MULT_TIER_5
	accuracy_mult_unwielded = BASE_ACCURACY_MULT - HIT_ACCURACY_MULT_TIER_5
	scatter = SCATTER_AMOUNT_TIER_6
	burst_scatter_mult = SCATTER_AMOUNT_TIER_4
	scatter_unwielded = SCATTER_AMOUNT_TIER_4
	damage_mult = BASE_BULLET_DAMAGE_MULT + BULLET_DAMAGE_MULT_TIER_1
	recoil_unwielded = RECOIL_AMOUNT_TIER_5

/obj/item/weapon/gun/smg/fp9000/pmc
	name = "\improper FN FP9000/2 冲锋枪"
	desc = "设计虽已古老，FN FP9K 凭借极高的可靠性和适应性，仍常见于私人军事公司小队，在各种场合都表现出色。他们使用的还是经过专利授权的官方版本，多年来不断获得改进和调校。"
	icon_state = "fp9000_pmc"
	item_state = "fp9000_pmc"
	random_spawn_chance = 100
	random_spawn_rail = list(
		/obj/item/attachable/reddot,
		/obj/item/attachable/reflex,
		/obj/item/attachable/magnetic_harness,
	)
	random_spawn_siderail = list(
		/obj/item/attachable/lasersight,
		/obj/item/attachable/flashlight,
	)

/obj/item/weapon/gun/smg/fp9000/pmc/set_gun_config_values()
	..()
	damage_mult = BASE_BULLET_DAMAGE_MULT + BULLET_DAMAGE_MULT_TIER_4
	scatter = SCATTER_AMOUNT_TIER_9
	accuracy_mult = BASE_ACCURACY_MULT + HIT_ACCURACY_MULT_TIER_7

/obj/item/weapon/gun/smg/fp9000/tactical
	name = "\improper FN FP9000-X TAC 冲锋枪"
	desc = "高焰制造公司改进了标准 FP9000 的内部机构，再换上新配色，以高价出售。虽然不及官方 FP9000/2，它仍能独当一面，而且弹着散布更容易控制。"
	icon_state = "fp9000_tactical"
	item_state = "fp9000_tactical"
	random_spawn_rail = list(
		/obj/item/attachable/reddot,
		/obj/item/attachable/reflex,
	)
	random_spawn_siderail = list(
		/obj/item/attachable/lasersight,
		/obj/item/attachable/flashlight,
	)

/obj/item/weapon/gun/smg/fp9000/tactical/set_gun_config_values()
	..()
	set_burst_amount(BURST_AMOUNT_TIER_1)
	damage_mult = BASE_BULLET_DAMAGE_MULT + BULLET_DAMAGE_MULT_TIER_2
	scatter = SCATTER_AMOUNT_TIER_8
	burst_scatter_mult = SCATTER_AMOUNT_TIER_10
	scatter_unwielded = SCATTER_AMOUNT_TIER_2
	accuracy_mult = BASE_ACCURACY_MULT + HIT_ACCURACY_MULT_TIER_2
//-------------------------------------------------------

/obj/item/weapon/gun/smg/nailgun
	name = "射钉枪"
	desc = "将钉子打入坚硬表面的木工工具。当然，如果前面没东西，那就是一根高速飞出的尖钉……"
	icon = 'icons/obj/items/weapons/guns/guns_by_faction/colony.dmi'
	icon_state = "nailgun"
	item_state = "nailgun"
	current_mag = /obj/item/ammo_magazine/smg/nailgun

	reload_sound = 'sound/weapons/handling/smg_reload.ogg'
	unload_sound = 'sound/weapons/handling/smg_unload.ogg'
	cocked_sound = 'sound/weapons/gun_cocked2.ogg'

	fire_sound = 'sound/weapons/nailgun_fire.ogg'
	force = 5
	w_class = SIZE_MEDIUM
	movement_onehanded_acc_penalty_mult = 4
	aim_slowdown = SLOWDOWN_ADS_QUICK
	wield_delay = WIELD_DELAY_VERY_FAST
	attachable_allowed = list()

	flags_gun_features = GUN_AUTO_EJECTOR|GUN_CAN_POINTBLANK
	gun_category = GUN_CATEGORY_SMG
	civilian_usable_override = TRUE
	start_automatic = FALSE
	var/nailing_speed = 2 SECONDS //Time to apply a sheet for patching. Also haha name. Try to keep sync with soundbyte duration
	var/repair_sound = 'sound/weapons/nailgun_repair_long.ogg'
	var/material_per_repair = 1

/obj/item/weapon/gun/smg/nailgun/set_gun_config_values()
	..()
	set_fire_delay(FIRE_DELAY_TIER_11)

	accuracy_mult = BASE_ACCURACY_MULT + HIT_ACCURACY_MULT_TIER_5
	accuracy_mult_unwielded = BASE_ACCURACY_MULT + HIT_ACCURACY_MULT_TIER_4
	scatter = SCATTER_AMOUNT_TIER_7
	scatter_unwielded = SCATTER_AMOUNT_TIER_5
	damage_mult = BASE_BULLET_DAMAGE_MULT
	recoil_unwielded = RECOIL_AMOUNT_TIER_5

/obj/item/weapon/gun/smg/nailgun/unique_action(mob/user)
	return //Yeah no.

/obj/item/weapon/gun/smg/nailgun/unload_chamber(mob/user)
	return //Can't remove nails from mags or gun.

/obj/item/weapon/gun/smg/nailgun/compact
	name = "紧凑型射钉枪"
	desc = "将钉子打入坚硬表面的木工工具。由于钉子周围没有气密结构，无法积累发射所需压力，因此不能用射钉攻击。"
	icon_state = "cnailgun"
	item_state = "nailgun"
	w_class = SIZE_SMALL
	flags_gun_features = GUN_AUTO_EJECTOR|GUN_CAN_POINTBLANK|GUN_NO_DESCRIPTION

/obj/item/weapon/gun/smg/nailgun/compact/able_to_fire(mob/living/user)
	. = ..()
	return FALSE

/obj/item/weapon/gun/smg/nailgun/compact/tactical
	name = "战术紧凑型射钉枪"
	desc = "将钉子打入坚硬表面的木工工具。这一款是军用级，橄榄绿色，战术味十足。不能把钉子当作弹丸发射。"
	icon_state = "tnailgun"
	item_state = "tnailgun"
	w_class = SIZE_SMALL
	material_per_repair = 2
