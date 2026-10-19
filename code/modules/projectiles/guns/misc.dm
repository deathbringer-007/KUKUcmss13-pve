//-------------------------------------------------------
//This gun is very powerful, but also has a kick.

/obj/item/weapon/gun/minigun
	name = "无痛老伙计"
	desc = "一挺巨大的多管旋转加特林机枪，这家伙的火力毫无疑问会很猛。"
	icon = 'icons/obj/items/weapons/guns/guns_by_faction/event.dmi'
	icon_state = "painless"
	item_state = "painless"
	mouse_pointer = 'icons/effects/mouse_pointer/lmg_mouse.dmi'

	fire_sound = 'sound/weapons/gun_minigun.ogg'
	cocked_sound = 'sound/weapons/gun_minigun_cocked.ogg'
	current_mag = /obj/item/ammo_magazine/minigun
	w_class = SIZE_HUGE
	force = 20
	flags_gun_features = GUN_AUTO_EJECTOR|GUN_WIELDED_FIRING_ONLY|GUN_AMMO_COUNTER|GUN_RECOIL_BUILDUP|GUN_CAN_POINTBLANK|GUN_AUTO_EJECT_CASINGS
	gun_category = GUN_CATEGORY_HEAVY
	start_semiauto = FALSE
	start_automatic = TRUE

/obj/item/weapon/gun/minigun/Initialize(mapload, spawn_empty)
	. = ..()
	if(current_mag && current_mag.current_rounds > 0) load_into_chamber()

/obj/item/weapon/gun/minigun/set_gun_config_values()
	..()
	set_fire_delay(FIRE_DELAY_TIER_12)

	accuracy_mult = BASE_ACCURACY_MULT + HIT_ACCURACY_MULT_TIER_3

	scatter = SCATTER_AMOUNT_TIER_9 // Most of the scatter should come from the recoil

	damage_mult = BASE_BULLET_DAMAGE_MULT
	recoil = RECOIL_AMOUNT_TIER_5
	recoil_buildup_limit = RECOIL_AMOUNT_TIER_3 / RECOIL_BUILDUP_VIEWPUNCH_MULTIPLIER

/obj/item/weapon/gun/minigun/handle_starting_attachment()
	..()
	//invisible mag harness
	var/obj/item/attachable/magnetic_harness/Integrated = new(src)
	Integrated.hidden = TRUE
	Integrated.flags_attach_features &= ~ATTACH_REMOVABLE
	Integrated.Attach(src)
	update_attachable(Integrated.slot)

//Minigun UPP
/obj/item/weapon/gun/minigun/upp
	name = "GSh-7.62 转管机枪"
	desc = "UPP 重装部队使用的导气式转管机枪。巨大的火力密度与载弹量足以压制大规模敌军，需要重武器训练才能控制其后坐力。"
	flags_gun_features = GUN_AUTO_EJECTOR|GUN_SPECIALIST|GUN_WIELDED_FIRING_ONLY|GUN_AMMO_COUNTER|GUN_RECOIL_BUILDUP|GUN_CAN_POINTBLANK|GUN_AUTO_EJECT_CASINGS
	current_mag = /obj/item/ammo_magazine/minigun/upp

/obj/item/weapon/gun/minigun/upp/able_to_fire(mob/living/user)
	. = ..()
	if(!. || !istype(user)) //Let's check all that other stuff first.
		return 0
	if(!skillcheck(user, SKILL_FIREARMS, SKILL_FIREARMS_TRAINED))
		to_chat(user, SPAN_WARNING("你似乎不知道如何使用[src]……"))
		return 0
	if(!skillcheck(user, SKILL_SPEC_WEAPONS, SKILL_SPEC_ALL) && user.skills.get_skill_level(SKILL_SPEC_WEAPONS) != SKILL_SPEC_UPP)
		to_chat(user, SPAN_WARNING("你似乎不知道如何使用[src]……"))
		return 0


//M60
/obj/item/weapon/gun/m60
	name = "H-G Mk70 机枪"
	desc = "亨金-加西亚复刻产品线的一员。Mk70 意外地在边疆殖民地抵御大型凶猛外星野生动物的家园防卫中找到了用途。\n<b>按住 Alt 点击，可打开供弹机盖进行装填。</b>"
	icon = 'icons/obj/items/weapons/guns/guns_by_faction/colony.dmi'
	icon_state = "m60"
	item_state = "m60"
	mouse_pointer = 'icons/effects/mouse_pointer/lmg_mouse.dmi'

	fire_sound = 'sound/weapons/gun_m60.ogg'
	cocked_sound = 'sound/weapons/gun_m60_cocked.ogg'
	current_mag = /obj/item/ammo_magazine/m60
	w_class = SIZE_LARGE
	force = 25
	flags_gun_features = GUN_WIELDED_FIRING_ONLY|GUN_CAN_POINTBLANK|GUN_AUTO_EJECT_CASINGS
	gun_category = GUN_CATEGORY_HEAVY
	attachable_allowed = list(
		/obj/item/attachable/m60barrel,
		/obj/item/attachable/bipod/m60,
	)
	starting_attachment_types = list(
		/obj/item/attachable/m60barrel,
		/obj/item/attachable/bipod/m60,
		/obj/item/attachable/stock/m60,
	)
	start_semiauto = FALSE
	start_automatic = TRUE

	var/cover_open = FALSE //if the gun's feed-cover is open or not.


/obj/item/weapon/gun/m60/Initialize(mapload, spawn_empty)
	. = ..()
	if(current_mag && current_mag.current_rounds > 0)
		load_into_chamber()

/obj/item/weapon/gun/m60/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 37, "muzzle_y" = 16, "rail_x" = 0, "rail_y" = 0, "under_x" = 27, "under_y" = 12, "stock_x" = 10, "stock_y" = 14)

/obj/item/weapon/gun/m60/set_gun_config_values()
	..()
	set_fire_delay(FIRE_DELAY_TIER_12)
	set_burst_amount(BURST_AMOUNT_TIER_5)
	set_burst_delay(FIRE_DELAY_TIER_12)
	accuracy_mult = BASE_ACCURACY_MULT
	accuracy_mult_unwielded = BASE_ACCURACY_MULT
	scatter = SCATTER_AMOUNT_TIER_10
	burst_scatter_mult = SCATTER_AMOUNT_TIER_8
	scatter_unwielded = SCATTER_AMOUNT_TIER_10
	damage_mult = BASE_BULLET_DAMAGE_MULT
	recoil = RECOIL_AMOUNT_TIER_5
	empty_sound = 'sound/weapons/gun_empty.ogg'

/obj/item/weapon/gun/m60/clicked(mob/user, list/mods)
	if(!mods[ALT_CLICK] || !CAN_PICKUP(user, src))
		return ..()
	else
		if(!locate(src) in list(user.get_active_hand(), user.get_inactive_hand()))
			return TRUE
		if(user.get_active_hand() && user.get_inactive_hand())
			to_chat(user, SPAN_WARNING("你的双手都拿着东西，无法这样做！"))
			return TRUE
		if(!cover_open)
			playsound(src.loc, 'sound/handling/smartgun_open.ogg', 50, TRUE, 3)
			to_chat(user, SPAN_NOTICE("你打开了[src]的供弹机盖，现在可以取出弹链。"))
			cover_open = TRUE
		else
			playsound(src.loc, 'sound/handling/smartgun_close.ogg', 50, TRUE, 3)
			to_chat(user, SPAN_NOTICE("你关上了[src]的供弹机盖。"))
			cover_open = FALSE
		update_icon()
		return TRUE

/obj/item/weapon/gun/m60/replace_magazine(mob/user, obj/item/ammo_magazine/magazine)
	if(!cover_open)
		to_chat(user, SPAN_WARNING("[src]的供弹机盖关着，无法装入新弹链！<b>（按住 Alt 点击可打开）</b>"))
		return
	return ..()

/obj/item/weapon/gun/m60/unload(mob/user, reload_override, drop_override, loc_override)
	if(!cover_open)
		to_chat(user, SPAN_WARNING("[src]的供弹机盖关着，无法取出弹链！<b>（按住 Alt 点击可打开）</b>"))
		return
	return ..()

/obj/item/weapon/gun/m60/update_icon()
	. = ..()
	if(cover_open)
		overlays += image("+[base_gun_icon]_cover_open", pixel_x = -2, pixel_y = 8)
	else
		overlays += image("+[base_gun_icon]_cover_closed", pixel_x = -10, pixel_y = 0)

/obj/item/weapon/gun/m60/able_to_fire(mob/living/user)
	. = ..()
	if(.)
		if(cover_open)
			to_chat(user, SPAN_WARNING("[src]的供弹机盖开着，无法开火！<b>（按住 Alt 点击可关闭）</b>"))
			return FALSE


/obj/item/weapon/gun/pkp
	name = "QYJ-72 通用机枪"
	desc = "QYJ-72 是进步人民联盟的制式通用机枪，使用威力强劲的 10x27mm 弹药，射速很高。配备容量达 250 发的巨大弹箱，设计重点是压制火力和以弹量弥补精度。\n按住 Alt 点击，可打开供弹机盖进行装填。"
	icon = 'icons/obj/items/weapons/guns/guns_by_faction/upp.dmi'
	icon_state = "qjy72"
	item_state = "qjy72"

	fire_sound = 'sound/weapons/gun_mg.ogg'
	cocked_sound = 'sound/weapons/gun_m60_cocked.ogg'
	current_mag = /obj/item/ammo_magazine/pkp
	w_class = SIZE_LARGE
	force = 30 //the image of a upp machinegunner beating someone to death with a gpmg makes me laugh
	start_semiauto = FALSE
	start_automatic = TRUE
	flags_gun_features = GUN_WIELDED_FIRING_ONLY|GUN_CAN_POINTBLANK|GUN_AUTO_EJECTOR|GUN_SPECIALIST|GUN_AMMO_COUNTER
	gun_category = GUN_CATEGORY_HEAVY
	attachable_allowed = list(
		/obj/item/attachable/pkpbarrel,
		/obj/item/attachable/stock/pkpstock,
	)
	var/cover_open = FALSE //if the gun's feed-cover is open or not.


/obj/item/weapon/gun/pkp/handle_starting_attachment()
	..()
	var/obj/item/attachable/attachie = new /obj/item/attachable/pkpbarrel(src)
	attachie.flags_attach_features &= ~ATTACH_REMOVABLE
	attachie.Attach(src)
	update_attachable(attachie.slot)

	var/obj/item/attachable/pkpstock = new /obj/item/attachable/stock/pkpstock(src)
	pkpstock.flags_attach_features &= ~ATTACH_REMOVABLE
	pkpstock.Attach(src)
	update_attachable(pkpstock.slot)

	//invisible mag harness
	var/obj/item/attachable/magnetic_harness/Integrated = new(src)
	Integrated.hidden = TRUE
	Integrated.flags_attach_features &= ~ATTACH_REMOVABLE
	Integrated.Attach(src)
	update_attachable(Integrated.slot)

/obj/item/weapon/gun/pkp/Initialize(mapload, spawn_empty)
	. = ..()
	if(current_mag && current_mag.current_rounds > 0)
		load_into_chamber()

/obj/item/weapon/gun/pkp/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 34, "muzzle_y" = 18,"rail_x" = 5, "rail_y" = 5, "under_x" = 39, "under_y" = 7, "stock_x" = 10, "stock_y" = 13)


/obj/item/weapon/gun/pkp/set_gun_config_values()
	..()
	fire_delay = FIRE_DELAY_TIER_LMG
	burst_amount = BURST_AMOUNT_TIER_4
	burst_delay = FIRE_DELAY_TIER_LMG
	accuracy_mult = BASE_ACCURACY_MULT + HIT_ACCURACY_MULT_TIER_4
	accuracy_mult_unwielded = BASE_ACCURACY_MULT
	fa_scatter_peak = FULL_AUTO_SCATTER_PEAK_TIER_4
	fa_max_scatter = SCATTER_AMOUNT_TIER_7
	scatter = SCATTER_AMOUNT_TIER_10
	burst_scatter_mult = SCATTER_AMOUNT_TIER_9
	scatter_unwielded = SCATTER_AMOUNT_TIER_10
	damage_mult = BASE_BULLET_DAMAGE_MULT
	recoil = RECOIL_AMOUNT_TIER_5
	empty_sound = 'sound/weapons/gun_empty.ogg'

/obj/item/weapon/gun/pkp/clicked(mob/user, list/mods)
	if(!mods[ALT_CLICK] || !CAN_PICKUP(user, src))
		return ..()
	else
		if(!locate(src) in list(user.get_active_hand(), user.get_inactive_hand()))
			return TRUE
		if(user.get_active_hand() && user.get_inactive_hand())
			to_chat(user, SPAN_WARNING("你的双手都拿着东西，无法这样做！"))
			return TRUE
		if(!cover_open)
			playsound(src.loc, 'sound/handling/smartgun_open.ogg', 50, TRUE, 3)
			to_chat(user, SPAN_NOTICE("你打开了[src]的供弹机盖，现在可以取出弹链。"))
			cover_open = TRUE
		else
			playsound(src.loc, 'sound/handling/smartgun_close.ogg', 50, TRUE, 3)
			to_chat(user, SPAN_NOTICE("你关上了[src]的供弹机盖。"))
			cover_open = FALSE
		update_icon()
		return TRUE

/obj/item/weapon/gun/pkp/replace_magazine(mob/user, obj/item/ammo_magazine/magazine)
	if(!cover_open)
		to_chat(user, SPAN_WARNING("[src]的供弹机盖关着，无法装入新弹链！<b>（按住 Alt 点击可打开）</b>"))
		return
	return ..()

/obj/item/weapon/gun/pkp/unload(mob/user, reload_override, drop_override, loc_override)
	if(!cover_open)
		to_chat(user, SPAN_WARNING("[src]的供弹机盖关着，无法取出弹链！<b>（按住 Alt 点击可打开）</b>"))
		return
	return ..()

/obj/item/weapon/gun/pkp/update_icon()
	. = ..()
	if(cover_open)
		overlays += "+[base_gun_icon]_cover_open"
	else
		overlays += "+[base_gun_icon]_cover_closed"

/obj/item/weapon/gun/pkp/able_to_fire(mob/living/user)
	. = ..()
	if(.)
		if(cover_open)
			to_chat(user, SPAN_WARNING("[src]的供弹机盖开着，无法开火！<b>（按住 Alt 点击可关闭）</b>"))
			return FALSE
	if(!skillcheck(user, SKILL_FIREARMS, SKILL_FIREARMS_TRAINED))
		to_chat(user, SPAN_WARNING("你似乎不知道如何使用[src]……"))
		return FALSE

/obj/item/weapon/gun/pkp/iff
	name = "\improper QYJ-72-I 通用机枪"
	desc = "QYJ-72-I 是进步人民联盟常见通用机枪的实验改型。它通过逆向研究美国殖民地陆战队智能武器，获得了敌我识别能力。除此之外改动不多：依旧沉重，很快就会过热，却能向远处倾泻空前密集的弹雨。\n<b>按住 Alt 点击即可打开供弹机盖以重新装填。</b>"
	actions_types = list(/datum/action/item_action/toggle_iff_pkp)
	aim_slowdown = SLOWDOWN_ADS_SPECIALIST
	var/iff_enabled = TRUE
	var/requires_harness = TRUE

/obj/item/weapon/gun/pkp/iff/able_to_fire(mob/living/user)
	. = ..()
	if(.)
		if(!ishuman(user))
			return FALSE
		var/mob/living/carbon/human/H = user
		if(requires_harness)
			if(!H.wear_suit || !(H.wear_suit.flags_inventory & SMARTGUN_HARNESS))
				balloon_alert(user, "需要背负装备")
				return FALSE

/obj/item/weapon/gun/pkp/iff/set_bullet_traits()
	LAZYADD(traits_to_give, list(
		BULLET_TRAIT_ENTRY_ID("iff", /datum/element/bullet_trait_iff) //it has no PVE IFF mechanics because its innacurate as hell and is used for suppression and not as assault weapon.
	))
	AddComponent(/datum/component/iff_fire_prevention)

/datum/action/item_action/toggle_iff_pkp/New(Target, obj/item/holder)
	. = ..()
	name = "Toggle IFF"
	action_icon_state = "iff_toggle_on"
	button.name = "切换敌我识别"
	button.overlays.Cut()
	button.overlays += image('icons/mob/hud/actions.dmi', button, action_icon_state)

/datum/action/item_action/toggle_iff_pkp/action_activate()
	. = ..()

	var/obj/item/weapon/gun/pkp/iff/G = holder_item
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/H = owner
	if(H.is_mob_incapacitated() || G.get_active_firearm(H, FALSE) != holder_item)
		return

	G.toggle_lethal_mode(usr)
	if(G.iff_enabled)
		action_icon_state = "iff_toggle_on"
	else
		action_icon_state = "iff_toggle_off"
	button.overlays.Cut()
	button.overlays += image('icons/mob/hud/actions.dmi', button, action_icon_state)

/obj/item/weapon/gun/pkp/iff/proc/toggle_lethal_mode(mob/user)
	to_chat(user, "[icon2html(src, usr)]你[iff_enabled? "<B>停用</b>" : "<B>启用</b>"]了[src]的射击限制。现在会[iff_enabled ? "伤害挡在面前的任何人" : "通过敌我识别系统筛选目标"]。")
	playsound(loc,'sound/machines/click.ogg', 25, 1)
	iff_enabled = !iff_enabled
	if(iff_enabled)
		add_bullet_trait(BULLET_TRAIT_ENTRY_ID("iff", /datum/element/bullet_trait_iff))
	if(!iff_enabled)
		remove_bullet_trait("iff")
	SEND_SIGNAL(src, COMSIG_GUN_IFF_TOGGLED, iff_enabled)

/obj/item/weapon/gun/pkp/iff/standard_fmj
	current_mag = /obj/item/ammo_magazine/pkp/standard_fmj

/obj/effect/syringe_gun_dummy
	name = ""
	desc = ""
	icon = 'icons/obj/items/chemistry.dmi'
	icon_state = null
	anchored = TRUE
	density = FALSE

/obj/effect/syringe_gun_dummy/Initialize()
	create_reagents(15)
	. = ..()


// XM99A, The quintesential phased plasma rifle in the 40 watt range

/obj/item/weapon/gun/XM99
	name = "\improper XM99A 相位等离子脉冲步枪"
	desc = "阿玛特设计的实验型定向能武器系统。XM99A 是发射过热等离子体的远程原型步枪。"
	icon = 'icons/obj/items/weapons/guns/guns_by_faction/uscm.dmi'
	icon_state = "xm99a"
	item_state = "xm99a"
	muzzleflash_iconstate  = "muzzle_flash_blue"
	muzzle_flash_color = COLOR_PURPLE
	muzzle_flash_lum = 5
	w_class = SIZE_LARGE
	flags_equip_slot = SLOT_BACK|SLOT_SUIT_STORE
	unacidable = TRUE
	map_specific_decoration = TRUE
	indestructible = 1
	fire_sound = 'sound/weapons/gun_xm99.ogg'
	reload_sound = 'sound/weapons/handling/nsg23_reload.ogg'
	unload_sound = 'sound/weapons/handling/nsg23_unload.ogg'
	current_mag = /obj/item/ammo_magazine/plasma
	force = 12
	wield_delay = WIELD_DELAY_SLOW
	attachable_allowed = list(
		/obj/item/attachable/reddot,
		/obj/item/attachable/magnetic_harness,
		/obj/item/attachable/flashlight,
		/obj/item/attachable/reflex,
		/obj/item/attachable/scope/mini,
		/obj/item/attachable/scope/pve,
	)
	flags_gun_features = GUN_WIELDED_FIRING_ONLY|GUN_AMMO_COUNTER
	flags_item = TWOHANDED

	var/obj/effect/ebeam/plasma_beam_type = /obj/effect/ebeam/laser/plasma
	///world.time value, to prevent a lightshow without actually firing
	var/beam_cooldown = 0
	///Delay before another beam can start again, in tenths of seconds
	var/beam_delay = 20


// Stolen from the rocket-launcher code to prevent the +1 shot in the plasma rifle
/obj/item/weapon/gun/XM99/load_into_chamber(mob/user)
	return ready_in_chamber()

/obj/item/weapon/gun/XM99/reload_into_chamber(mob/user)
	if(current_mag.current_rounds <= 0)
		playsound(src, empty_sound, 25, 1)
	return TRUE

/obj/item/weapon/gun/XM99/delete_bullet(obj/projectile/projectile_to_fire, refund = 0)
	if(!current_mag)
		return
	qdel(projectile_to_fire)
	if(refund)
		current_mag.current_rounds++
	return TRUE

/obj/item/weapon/gun/XM99/proc/make_battery_drum(mob/user, remaining_rounds = 0)
	if(!current_mag)
		return

	var/obj/item/ammo_magazine/plasma/cell = new current_mag.type()
	if(remaining_rounds <= 0)
		cell.current_rounds = 0
		user.put_in_hands(cell)
	else
		cell.current_rounds = remaining_rounds
		user.put_in_hands(cell)
	cell.update_icon()

/obj/item/weapon/gun/XM99/reload(mob/user, obj/item/ammo_magazine/plasma)
	if(!plasma || !istype(plasma) || !istype(src, plasma.gun_type))
		to_chat(user, SPAN_WARNING("那东西装不进去！"))
		return

	if(current_mag)
		to_chat(user, SPAN_WARNING("[src]已经装填！"))
		return

	if(plasma.current_rounds <= 0)
		to_chat(user, SPAN_WARNING("那个电池鼓已经没电了！"))
		return

	else
		to_chat(user, SPAN_NOTICE("你开始为[src]装填弹药。请保持不动……"))
		if(do_after(user, 20, INTERRUPT_ALL, BUSY_ICON_FRIENDLY))
			user.drop_inv_item_on_ground(plasma)
			current_mag = plasma
			plasma.forceMove(src)
			replace_ammo(,plasma)
			to_chat(user, SPAN_NOTICE("你将新的电池鼓装入[src]。"))
			playsound(user, reload_sound, 25, 1)
		else
			to_chat(user, SPAN_WARNING("你的装填被打断了！"))
			return
	update_icon()
	return TRUE

/obj/item/weapon/gun/XM99/unload(mob/user, reload_override = 0)
	if(user && !current_mag)
		to_chat(user, SPAN_WARNING("[src]已经是空的！"))
		return
	if(user && (current_mag != null))
		to_chat(user, SPAN_NOTICE("你卸下了[src]的弹药。"))
		playsound(user, unload_sound, 25, 1)
		if(current_mag.current_rounds > 0)
			user.visible_message(SPAN_NOTICE("[user]从[src]中卸下[current_mag]。"),
			SPAN_NOTICE("你从[src]中卸下[current_mag]。"))
			make_battery_drum(user, current_mag.current_rounds)
		if(current_mag.current_rounds <= 0)
			user.visible_message(SPAN_NOTICE("[user]从[src]中卸下[current_mag]。"),
			SPAN_NOTICE("你从[src]中卸下[current_mag]。"))
			make_battery_drum(user, current_mag.current_rounds)
		current_mag = null
		update_icon()

/obj/item/weapon/gun/XM99/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 39, "muzzle_y" = 17,"rail_x" = 11, "rail_y" = 21, "under_x" = 19, "under_y" = 14, "stock_x" = 19, "stock_y" = 14, "side_rail_x" = 23, "side_rail_y" = 17)

/obj/item/weapon/gun/XM99/set_gun_config_values()
	..()
	set_fire_delay(FIRE_DELAY_TIER_VULTURE)
	set_burst_amount(BURST_AMOUNT_TIER_1)
	accuracy_mult = BASE_ACCURACY_MULT * 3 //you HAVE to be able to hit
	scatter = SCATTER_AMOUNT_TIER_8
	damage_mult = BASE_BULLET_DAMAGE_MULT
	recoil = RECOIL_AMOUNT_TIER_5

/obj/item/weapon/gun/XM99/set_bullet_traits()
	. = ..()
	LAZYADD(traits_to_give, list(
		BULLET_TRAIT_ENTRY_ID("vehicles", /datum/element/bullet_trait_damage_boost, 75, GLOB.damage_boost_vehicles),
	))


/obj/item/weapon/gun/XM99/handle_fire(atom/target, mob/living/user, params, reflex = FALSE, dual_wield, check_for_attachment_fire, akimbo, fired_by_akimbo)

	var/datum/beam/plasma_beam
	if(!current_mag)
		click_empty(user)
		return
	if(current_mag.current_rounds <= 0)
		return
	plasma_beam = target.beam(user, "light_beam", 'icons/effects/beam.dmi', time = 0.7 SECONDS, maxdistance = 30, beam_type = plasma_beam_type, always_turn = TRUE)
	animate(plasma_beam.visuals, alpha = 255, time = 0.7 SECONDS, color = COLOR_PURPLE, luminosity = 3 , easing = SINE_EASING|EASE_OUT)
	. = ..()

//-------------------------------------------------------
//P9 Sonic Harpoon Artillery Remote Projectile(SHARP) Rifle

/obj/item/weapon/gun/rifle/sharp
	name = "\improper P9 SHARP 步枪"
	desc = "阿玛特系统公司制造的实验型鱼叉发射步枪。使用 10 发弹匣供弹，专用弹药适合区域封锁和干扰。\n<b>切换射击模式</b>可设置延时爆炸飞镖的引信；使用<b>武器特殊操作</b>可追踪被追踪飞镖击中的目标。"
	icon_state = "sharprifle"
	item_state = "sharp"
	fire_sound = 'sound/weapons/gun_sharp.ogg'
	reload_sound = 'sound/weapons/handling/gun_vulture_bolt_close.ogg'
	unload_sound = 'sound/weapons/handling/gun_vulture_bolt_eject.ogg'
	unacidable = TRUE
	indestructible = TRUE
	muzzle_flash = null

	current_mag = /obj/item/ammo_magazine/rifle/sharp/explosive
	attachable_allowed = list(/obj/item/attachable/magnetic_harness, /obj/item/attachable/bayonet, /obj/item/attachable/flashlight)

	aim_slowdown = SLOWDOWN_ADS_SPECIALIST
	wield_delay = WIELD_DELAY_NORMAL
	flags_gun_features = GUN_SPECIALIST|GUN_WIELDED_FIRING_ONLY|GUN_CAN_POINTBLANK|GUN_AMMO_COUNTER

	flags_item = TWOHANDED|NO_CRYO_STORE
	start_semiauto = TRUE
	start_automatic = FALSE


	var/explosion_delay_sharp = FALSE
	var/list/sharp_tracked_mob_list = list()

/obj/item/weapon/gun/rifle/sharp/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 32, "muzzle_y" = 17,"rail_x" = 12, "rail_y" = 24, "under_x" = 23, "under_y" = 13, "stock_x" = 24, "stock_y" = 13)

/obj/item/weapon/gun/rifle/sharp/set_gun_config_values()
	..()
	fire_delay = FIRE_DELAY_TIER_1
	accuracy_mult = BASE_ACCURACY_MULT
	scatter = SCATTER_AMOUNT_NONE
	damage_mult = BASE_BULLET_DAMAGE_MULT
	recoil = RECOIL_OFF

/obj/item/weapon/gun/rifle/sharp/unique_action(mob/user)
	track(user)

/obj/item/weapon/gun/rifle/sharp/proc/track(mob/user)
	var/mob/living/carbon/human/M = user

	var/max_count = 5 //max number of tracking
	var/target
	var/direction = -1
	var/atom/areaLoc = null
	var/output = FALSE

	var/x = sharp_tracked_mob_list.len - max_count
	for(var/i=0,i<x,++i)
		popleft(sharp_tracked_mob_list)

	for(var/mob/living/mob_tracked as mob in sharp_tracked_mob_list)
		if(!QDELETED(mob_tracked))
			if(M.z == mob_tracked.z)
				var/dist = get_dist(M,mob_tracked)
				target = dist
				direction = get_dir(M,mob_tracked)
				areaLoc = loc

			if(target < 900)
				output = TRUE
				var/areaName = get_area_name(areaLoc)
				to_chat(M, SPAN_NOTICE("[mob_tracked]位于<b>[areaName]</b>的<b>[localized_player_label(dir2text(direction))]</b>方向，距离[target > 10 ? "约 <b>[round(target, 10)]</b>" : "<b>[target]</b>"]步。"))
	if(!output)
		to_chat(M, SPAN_NOTICE("当前没有正在追踪的目标。"))

	return

/obj/item/weapon/gun/rifle/sharp/cock()
	return

/obj/item/weapon/gun/rifle/sharp/do_toggle_firemode(datum/source, datum/keybinding, new_firemode)
	explosion_delay_sharp = !explosion_delay_sharp
	playsound(source, 'sound/weapons/handling/gun_burst_toggle.ogg', 15, 1)
	to_chat(source, SPAN_NOTICE("你[explosion_delay_sharp ? SPAN_BOLD("启用") : SPAN_BOLD("停用")]了[src]的延时射击模式。爆炸弹药会在[explosion_delay_sharp ? SPAN_BOLD("五秒") : SPAN_BOLD("一秒")]后爆炸。"))
