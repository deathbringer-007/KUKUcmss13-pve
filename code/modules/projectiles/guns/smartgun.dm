//-------------------------------------------------------
//SMARTGUN

//Come get some.
/obj/item/weapon/gun/smartgun
	name = "M56A2 智能机枪"
	desc = "M56 智能机枪四件套中的枪械本体，本质上是一挺重型机动机枪。\n可通过特殊动作切换开火限制。\n按住 Alt 点击，可打开供弹机盖进行装填。"
	icon = 'icons/obj/items/weapons/guns/guns_by_faction/uscm.dmi'
	icon_state = "m56"
	item_state = "m56"
	mouse_pointer = 'icons/effects/mouse_pointer/smartgun_mouse.dmi'

	fire_sound = "gun_smartgun"
	reload_sound = 'sound/weapons/handling/gun_sg_reload.ogg'
	unload_sound = 'sound/weapons/handling/gun_sg_unload.ogg'

	current_mag = /obj/item/ammo_magazine/smartgun
	flags_equip_slot = NO_FLAGS
	w_class = SIZE_HUGE
	force = 20
	wield_delay = WIELD_DELAY_FAST
	aim_slowdown = SLOWDOWN_ADS_SMARTGUN
	unacidable = 1
	indestructible = 1

	flags_gun_features = GUN_SPECIALIST|GUN_WIELDED_FIRING_ONLY
	gun_category = GUN_CATEGORY_HEAVY
	starting_attachment_types = list(/obj/item/attachable/smartbarrel)
	auto_retrieval_slot = WEAR_J_STORE
	start_semiauto = FALSE
	start_automatic = TRUE

	attachable_allowed = list(
		/obj/item/attachable/smartbarrel,
		/obj/item/attachable/flashlight,
	)

	ammo = /datum/ammo/bullet/rifle/heavy/tracer
	actions_types = list(
		/datum/action/item_action/smartgun/toggle_accuracy_improvement,
		/datum/action/item_action/smartgun/toggle_ammo_type,
		///datum/action/item_action/smartgun/toggle_auto_fire,
		/datum/action/item_action/smartgun/toggle_lethal_mode,
		///datum/action/item_action/smartgun/toggle_motion_detector,
		/datum/action/item_action/smartgun/toggle_recoil_compensation,
	)

	var/obj/item/smartgun_battery/battery = null
	var/battery_type = /obj/item/smartgun_battery
	/// Whether the smartgun drains the battery (Ignored if requires_battery is false)
	var/requires_power = TRUE
	/// Whether the smartgun requires a battery
	var/requires_battery = TRUE
	/// Whether the smartgun requires a harness to use
	var/requires_harness = TRUE

	var/datum/ammo/ammo_primary = /datum/ammo/bullet/rifle/heavy/tracer //Toggled ammo type
	var/datum/ammo/ammo_secondary = /datum/ammo/bullet/rifle/heavy/ap/tracer //Toggled ammo type
	var/datum/ammo/ammo_tertiary = /datum/ammo/bullet/rifle/heavy/impdet //Toggled ammo type
	var/iff_enabled = TRUE //Begin with the safety on.
	var/recoil_compensation = 0
	var/accuracy_improvement = 0
	var/auto_fire = 0
	var/motion_detector = 0
	var/drain = 75
	var/range = 7
	var/angle = 2
	var/list/angle_list = list(180,135,90,60,30)
	var/obj/item/device/motiondetector/sg/MD
	var/long_range_cooldown = 2
	var/recycletime = 120
	var/cover_open = FALSE

/obj/item/weapon/gun/smartgun/Initialize(mapload, ...)
	ammo_primary = GLOB.ammo_list[ammo_primary] //Gun initialize calls replace_ammo() so we need to set these first.
	ammo_secondary = GLOB.ammo_list[ammo_secondary]
	ammo_tertiary = GLOB.ammo_list[ammo_tertiary]
	ammo = ammo_primary
	MD = new(src)
	battery = new battery_type(src)
	. = ..()
	update_icon()

/obj/item/weapon/gun/smartgun/Destroy()
	ammo_primary = null
	ammo_secondary = null
	ammo_tertiary = null
	QDEL_NULL(MD)
	QDEL_NULL(battery)
	. = ..()

/obj/item/weapon/gun/smartgun/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 33, "muzzle_y" = 16,"rail_x" = 17, "rail_y" = 18, "under_x" = 22, "under_y" = 14, "stock_x" = 22, "stock_y" = 14, , "side_rail_x" = 17, "side_rail_y" = 18)

/obj/item/weapon/gun/smartgun/set_gun_config_values()
	..()
	set_fire_delay(FIRE_DELAY_TIER_SG)
	fa_scatter_peak = FULL_AUTO_SCATTER_PEAK_TIER_8
	fa_max_scatter = SCATTER_AMOUNT_TIER_9
	if(accuracy_improvement)
		accuracy_mult += HIT_ACCURACY_MULT_TIER_3
	else
		accuracy_mult += HIT_ACCURACY_MULT_TIER_1
	if(recoil_compensation)
		scatter = SCATTER_AMOUNT_TIER_10
		recoil = RECOIL_OFF
	else
		scatter = SCATTER_AMOUNT_TIER_6
		recoil = RECOIL_AMOUNT_TIER_3
	damage_mult = BASE_BULLET_DAMAGE_MULT

/obj/item/weapon/gun/smartgun/set_bullet_traits()
	LAZYADD(traits_to_give, list(
		BULLET_TRAIT_ENTRY_ID("iff", /datum/element/bullet_trait_iff)
	))
	AddComponent(/datum/component/iff_fire_prevention)

/obj/item/weapon/gun/smartgun/get_examine_text(mob/user)
	. = ..()
	var/rounds = 0
	if(current_mag && current_mag.current_rounds)
		rounds = current_mag.current_rounds
	var/message = "[rounds ? "Ammo counter shows [rounds] round\s remaining." : "It's dry."]"
	. += message
	. += "射击限制系统已[iff_enabled ? "<B>启用</b>" : "<B>停用</b>"]。"

	if(battery && get_dist(user, src) <= 1)
		. += "[battery]上的小表盘显示：电量 [battery.power_cell.charge] / [battery.power_cell.maxcharge]。"

/obj/item/weapon/gun/smartgun/clicked(mob/user, list/mods)
	if(mods[ALT_CLICK])
		if(!CAN_PICKUP(user, src))
			return ..()
		if(!locate(src) in list(user.get_active_hand(), user.get_inactive_hand()))
			return TRUE
		if(user.get_active_hand() && user.get_inactive_hand())
			to_chat(user, SPAN_WARNING("你的双手都拿着东西，无法这样做！"))
			return TRUE
		if(!cover_open)
			playsound(src.loc, 'sound/handling/smartgun_open.ogg', 50, TRUE, 3)
			to_chat(user, SPAN_NOTICE("你打开了[src]的供弹机盖，现在可以取出弹鼓。"))
			cover_open = TRUE
		else
			playsound(src.loc, 'sound/handling/smartgun_close.ogg', 50, TRUE, 3)
			to_chat(user, SPAN_NOTICE("你关上了[src]的供弹机盖。"))
			cover_open = FALSE
		update_icon()
		return TRUE
	else
		return ..()

/obj/item/weapon/gun/smartgun/attackby(obj/item/attacking_object, mob/user)
	if(istypestrict(attacking_object, battery_type))
		var/obj/item/smartgun_battery/new_cell = attacking_object
		visible_message(SPAN_NOTICE("[user]更换了[src]中的电池。"),
			SPAN_NOTICE("你更换了[src]中的电池，并丢下旧电池。"))
		to_chat(user, SPAN_NOTICE("新电池含有[new_cell.power_cell.charge]电量。"))
		battery.update_icon()
		battery.forceMove(get_turf(user))
		battery = new_cell
		user.drop_inv_item_to_loc(new_cell, src)
		playsound(src, 'sound/machines/click.ogg', 25, 1)
		return

	return ..()

/obj/item/weapon/gun/smartgun/replace_magazine(mob/user, obj/item/ammo_magazine/magazine)
	if(!cover_open)
		to_chat(user, SPAN_WARNING("[src]的供弹机盖关着，无法装入新弹鼓！（按住 Alt 点击可打开）"))
		return
	. = ..()

/obj/item/weapon/gun/smartgun/unload(mob/user, reload_override, drop_override, loc_override)
	if(!cover_open)
		to_chat(user, SPAN_WARNING("[src]的供弹机盖关着，无法取出弹鼓！（按住 Alt 点击可打开）"))
		return
	. = ..()

/obj/item/weapon/gun/smartgun/update_icon()
	. = ..()
	if(cover_open)
		overlays += "+[base_gun_icon]_cover_open"
	else
		overlays += "+[base_gun_icon]_cover_closed"

//---ability actions--\\

/datum/action/item_action/smartgun/action_activate()
	. = ..()
	var/obj/item/weapon/gun/smartgun/G = holder_item
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/H = owner
	if(H.is_mob_incapacitated() || G.get_active_firearm(H, FALSE) != holder_item)
		return

/datum/action/item_action/smartgun/update_button_icon()
	return

/datum/action/item_action/smartgun/toggle_accuracy_improvement/New(Target, obj/item/holder)
	. = ..()
	name = "Toggle Accuracy Improvement"
	action_icon_state = "accuracy_improvement"
	button.name = "切换精度增强"
	button.overlays.Cut()
	button.overlays += image('icons/mob/hud/actions.dmi', button, action_icon_state)

/datum/action/item_action/smartgun/toggle_accuracy_improvement/action_activate()
	. = ..()
	var/obj/item/weapon/gun/smartgun/G = holder_item
	G.toggle_accuracy_improvement(usr)
	if(G.accuracy_improvement)
		button.icon_state = "template_on"
	else
		button.icon_state = "template"

/datum/action/item_action/smartgun/toggle_recoil_compensation/New(Target, obj/item/holder)
	. = ..()
	name = "Toggle Recoil Compensation"
	action_icon_state = "recoil_compensation"
	button.name = "切换后坐力补偿"
	button.overlays.Cut()
	button.overlays += image('icons/mob/hud/actions.dmi', button, action_icon_state)

/datum/action/item_action/smartgun/toggle_recoil_compensation/action_activate()
	. = ..()
	var/obj/item/weapon/gun/smartgun/G = holder_item
	G.toggle_recoil_compensation(usr)
	if(G.recoil_compensation)
		button.icon_state = "template_on"
	else
		button.icon_state = "template"

/datum/action/item_action/smartgun/toggle_lethal_mode/New(Target, obj/item/holder)
	. = ..()
	name = "Toggle IFF"
	action_icon_state = "iff_toggle_on"
	button.name = "切换敌我识别"
	button.overlays.Cut()
	button.overlays += image('icons/mob/hud/actions.dmi', button, action_icon_state)

/datum/action/item_action/smartgun/toggle_lethal_mode/action_activate()
	. = ..()
	var/obj/item/weapon/gun/smartgun/G = holder_item
	G.toggle_lethal_mode(usr)
	if(G.iff_enabled)
		action_icon_state = "iff_toggle_on"
	else
		action_icon_state = "iff_toggle_off"
	button.overlays.Cut()
	button.overlays += image('icons/mob/hud/actions.dmi', button, action_icon_state)

/datum/action/item_action/smartgun/toggle_ammo_type/New(Target, obj/item/holder)
	. = ..()
	name = "Toggle Ammo Type"
	action_icon_state = "ammo_swap_normal"
	button.name = "切换弹药类型"
	button.overlays.Cut()
	button.overlays += image('icons/mob/hud/actions.dmi', button, action_icon_state)

/datum/action/item_action/smartgun/toggle_ammo_type/action_activate()
	. = ..()
	var/obj/item/weapon/gun/smartgun/G = holder_item
	G.toggle_ammo_type(usr)

/datum/action/item_action/smartgun/toggle_ammo_type/proc/update_icon()
	var/obj/item/weapon/gun/smartgun/G = holder_item
	if(G.ammo == G.ammo_primary)
		action_icon_state = "ammo_swap_normal"
	else if(G.ammo == G.ammo_secondary)
		action_icon_state = "ammo_swap_ap"
	else if(G.ammo == G.ammo_tertiary)
		action_icon_state = "ammo_swap_pen"
	else
		action_icon_state = "ammo_swap_normal"
	button.overlays.Cut()
	button.overlays += image('icons/mob/hud/actions.dmi', button, action_icon_state)

//more general procs

/obj/item/weapon/gun/smartgun/able_to_fire(mob/living/user)
	. = ..()
	if(.)
		if(!ishuman(user))
			return FALSE
		var/mob/living/carbon/human/H = user
		if(!skillcheckexplicit(user, SKILL_SPEC_WEAPONS, SKILL_SPEC_SMARTGUN) && !skillcheckexplicit(user, SKILL_SPEC_WEAPONS, SKILL_SPEC_ALL))
			balloon_alert(user, "技能不足")
			return FALSE
		if(requires_harness)
			if(!H.wear_suit || !(H.wear_suit.flags_inventory & SMARTGUN_HARNESS))
				balloon_alert(user, "需要背负装备")
				return FALSE
		if(cover_open)
			to_chat(H, SPAN_WARNING("[src]的供弹机盖开着，无法开火！（按住 Alt 点击可关闭）"))
			balloon_alert(user, "供弹机盖开启，无法开火")
			return FALSE
		if(iff_enabled)
			if(!H.glasses || !(H.glasses.flags_inventory & SMARTGUN_OPTIC))
				balloon_alert(user, "敌我识别追踪需要 M56 耳机")
				return FALSE

/obj/item/weapon/gun/smartgun/unique_action(mob/user)
	if(isobserver(usr) || isxeno(usr))
		return
	toggle_ammo_type(usr)

/obj/item/weapon/gun/smartgun/proc/toggle_ammo_type(mob/user)
	if(!iff_enabled)
		to_chat(user, "[icon2html(src, usr)][src]的射击限制已停用，无法切换弹药类型。")
		return
	if(ammo == ammo_primary)
		ammo = ammo_secondary
		to_chat(user, "[icon2html(src, usr)]你调整了[src]的弹药处理程序。现在发射穿甲弹，比其他弹药更容易击穿装甲目标。")
		balloon_alert(user, "发射穿甲弹")
		drain += 50
	else if(ammo == ammo_secondary)
		ammo = ammo_tertiary
		to_chat(user, "[icon2html(src, usr)]你调整了[src]的弹药处理程序。现在发射触爆弹，命中后可使大多数人类大小的敌人踉跄并减速。")
		balloon_alert(user, "发射触爆弹")
		drain += 10
	else
		ammo = ammo_primary
		to_chat(user, "[icon2html(src, usr)]你调整了[src]的弹药处理程序。现在发射高精度弹药，精度高，耗电也更少。")
		balloon_alert(user, "发射高精度弹")
		drain -= 60
	playsound(loc,'sound/machines/click.ogg', 25, 1)
	var/datum/action/item_action/smartgun/toggle_ammo_type/TAT = locate(/datum/action/item_action/smartgun/toggle_ammo_type) in actions
	TAT.update_icon()

/obj/item/weapon/gun/smartgun/replace_ammo()
	var/old_ammo = ammo
	..()
	if(old_ammo)
		ammo = old_ammo

/obj/item/weapon/gun/smartgun/proc/toggle_lethal_mode(mob/user)
	to_chat(user, "[icon2html(src, usr)]你[iff_enabled? "<B>停用</b>" : "<B>启用</b>"]了[src]的射击限制。现在会[iff_enabled ? "伤害挡在面前的任何人" : "通过敌我识别系统筛选目标"]。")
	playsound(loc,'sound/machines/click.ogg', 25, 1)
	iff_enabled = !iff_enabled
	ammo = ammo_primary
	var/datum/action/item_action/smartgun/toggle_ammo_type/TAT = locate(/datum/action/item_action/smartgun/toggle_ammo_type) in actions
	TAT.update_icon()
	if(iff_enabled)
		add_bullet_trait(BULLET_TRAIT_ENTRY_ID("iff", /datum/element/bullet_trait_iff))
		drain += 10
		MD.iff_signal = initial(MD.iff_signal)
	if(!iff_enabled)
		remove_bullet_trait("iff")
		drain -= 10
		MD.iff_signal = null
	SEND_SIGNAL(src, COMSIG_GUN_IFF_TOGGLED, iff_enabled)

/obj/item/weapon/gun/smartgun/Fire(atom/target, mob/living/user, params, reflex = 0, dual_wield)
	if(!requires_battery)
		return ..()

	if(battery)
		if(!requires_power)
			return ..()
		if(drain_battery())
			return ..()

/obj/item/weapon/gun/smartgun/proc/drain_battery(override_drain)

	var/actual_drain = (rand(drain / 2, drain) / 25)

	if(override_drain)
		actual_drain = (rand(override_drain / 2, override_drain) / 25)

	if(battery && battery.power_cell.charge > 0)
		if(battery.power_cell.charge > actual_drain)
			battery.power_cell.charge -= actual_drain
		else
			battery.power_cell.charge = 0
			to_chat(usr, SPAN_WARNING("[src]发出低电量警报，随即关闭！"))
			return FALSE
		return TRUE
	if(!battery || battery.power_cell.charge == 0)
		balloon_alert(usr, "电量不足")
		return FALSE
	return FALSE

/obj/item/weapon/gun/smartgun/proc/toggle_recoil_compensation(mob/user)
	to_chat(user, "[icon2html(src, usr)]你[recoil_compensation? "<B>停用</b>" : "<B>启用</b>"]了[src]的后坐力补偿。")
	playsound(loc,'sound/machines/click.ogg', 25, 1)
	recoil_compensation = !recoil_compensation
	if(recoil_compensation)
		drain += 50
	else
		drain -= 50
	recalculate_attachment_bonuses() //Includes set_gun_config_values() as well as attachments.

/obj/item/weapon/gun/smartgun/proc/toggle_accuracy_improvement(mob/user)
	to_chat(user, "[icon2html(src, usr)]你[accuracy_improvement? "<B>停用</b>" : "<B>启用</b>"]了[src]的精度增强功能。")
	playsound(loc,'sound/machines/click.ogg', 25, 1)
	accuracy_improvement = !accuracy_improvement
	if(accuracy_improvement)
		drain += 50
	else
		drain -= 50
	recalculate_attachment_bonuses()

/obj/item/weapon/gun/smartgun/empty
	current_mag = null

//CO SMARTGUN
/obj/item/weapon/gun/smartgun/co
	name = "M56C“骑兵”智能机枪"
	desc = "M56C 智能机枪四件套中的枪械本体，只接受预订。除更坚固的机匣、身份锁与华丽涂装外，性能与制式 M56B 相同。\n按住 Alt 点击，可打开供弹机盖进行装填。"
	icon_state = "m56c"
	item_state = "m56c"
	var/mob/living/carbon/human/linked_human
	var/is_locked = TRUE

/obj/item/weapon/gun/smartgun/co/Initialize(mapload, ...)
	LAZYADD(actions_types, /datum/action/item_action/co_sg/toggle_id_lock)
	. = ..()

/obj/item/weapon/gun/smartgun/co/able_to_fire(mob/user)
	. = ..()
	if(is_locked && linked_human && linked_human != user)
		if(linked_human.is_revivable() || linked_human.stat != DEAD)
			to_chat(user, SPAN_WARNING("[icon2html(src, usr)][src]锁定了扳机。未授权用户。"))
			playsound(loc,'sound/weapons/gun_empty.ogg', 25, 1)
			return FALSE

		linked_human = null
		is_locked = FALSE
		UnregisterSignal(linked_human, COMSIG_PARENT_QDELETING)

// ID lock action \\

/datum/action/item_action/co_sg/action_activate()
	. = ..()
	var/obj/item/weapon/gun/smartgun/co/protag_gun = holder_item
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/protagonist = owner
	if(protagonist.is_mob_incapacitated() || protag_gun.get_active_firearm(protagonist, FALSE) != holder_item)
		return

/datum/action/item_action/co_sg/update_button_icon()
	return

/datum/action/item_action/co_sg/toggle_id_lock/New(Target, obj/item/holder)
	. = ..()
	name = "Toggle ID lock"
	action_icon_state = "id_lock_locked"
	button.name = "切换身份锁"
	button.overlays.Cut()
	button.overlays += image('icons/mob/hud/actions.dmi', button, action_icon_state)

/datum/action/item_action/co_sg/toggle_id_lock/action_activate()
	. = ..()
	var/obj/item/weapon/gun/smartgun/co/protag_gun = holder_item
	protag_gun.toggle_lock()
	if(protag_gun.is_locked)
		action_icon_state = "id_lock_locked"
	else
		action_icon_state = "id_lock_unlocked"
	button.overlays.Cut()
	button.overlays += image('icons/mob/hud/actions.dmi', button, action_icon_state)

/obj/item/weapon/gun/smartgun/co/proc/toggle_lock(mob/user)
	if(linked_human && usr != linked_human)
		to_chat(usr, SPAN_WARNING("[icon2html(src, usr)][src]拒绝操作。未授权用户。"))
		return
	else if(!linked_human)
		name_after_co(usr)

	is_locked = !is_locked
	to_chat(usr, SPAN_NOTICE("[icon2html(src, usr)]你[is_locked? "锁定": "解锁"]了[src]。"))
	playsound(loc,'sound/machines/click.ogg', 25, 1)

// action end \\

/obj/item/weapon/gun/smartgun/co/pickup(user)
	if(!linked_human)
		src.name_after_co(user, src)
		to_chat(usr, SPAN_NOTICE("[icon2html(src, usr)]你拾起[src]，将自己登记为持有者。"))
	..()


/obj/item/weapon/gun/smartgun/co/proc/name_after_co(mob/living/carbon/human/H, obj/item/weapon/gun/smartgun/co/I)
	linked_human = H
	RegisterSignal(linked_human, COMSIG_PARENT_QDELETING, PROC_REF(remove_idlock))

/obj/item/weapon/gun/smartgun/co/get_examine_text()
	. = ..()
	if(linked_human)
		if(is_locked)
			. += SPAN_NOTICE("已登记给[linked_human]。")
		else
			. += SPAN_NOTICE("已登记给[linked_human]，但射击限制未锁定。")
	else
		. += SPAN_NOTICE("尚未登记。拾起即可将自己登记为持有者。")
	if(!iff_enabled)
		. += SPAN_WARNING("敌我识别限制已停用。")

/obj/item/weapon/gun/smartgun/co/proc/remove_idlock()
	SIGNAL_HANDLER
	linked_human = null

/obj/item/weapon/gun/smartgun/dirty
	name = "\improper M56A3“脏家伙”智能机枪"
	desc = "四件式 M56A3 智能机枪系统中的枪械。与美洲联盟制式 A2 型相比，区别仅在于更加坚固的电子设备和略轻的枪身。\n使用特殊操作可切换射击限制。\n按住 Alt 点击可打开供弹机盖以装填弹药。"
	flags_gun_features = GUN_WY_RESTRICTED|GUN_SPECIALIST|GUN_WIELDED_FIRING_ONLY
	drain = 30	//Slightly more power effictient than the basic model

/obj/item/weapon/gun/smartgun/dirty/Initialize(mapload, ...)
	. = ..()
	MD.iff_signal = FACTION_PMC


//TERMINATOR SMARTGUN
/obj/item/weapon/gun/smartgun/dirty/elite
	name = "\improper M56A3-T“终结者”智能机枪"
	current_mag = /obj/item/ammo_magazine/smartgun/dirty
	ammo = /obj/item/ammo_magazine/smartgun/dirty
	ammo_primary = /datum/ammo/bullet/rifle/heavy/dirty //Toggled ammo type
	ammo_secondary = /datum/ammo/bullet/rifle/heavy/ap/dirty ///Toggled ammo type
	ammo_tertiary = /datum/ammo/bullet/rifle/heavy/impdet/dirty
	desc = "四件式 M56A3-T 智能机枪系统中的枪械。有了它，挡路的人就要吃足苦头。\n使用特殊操作可切换射击限制。\n按住 Alt 点击可打开供弹机盖以装填弹药。"

/obj/item/weapon/gun/smartgun/dirty/elite/Initialize(mapload, ...)
	. = ..()
	MD.iff_signal = FACTION_WY_DEATHSQUAD

/obj/item/weapon/gun/smartgun/dirty/elite/set_gun_config_values()
	..()
	set_burst_amount(BURST_AMOUNT_TIER_5)
	set_burst_delay(FIRE_DELAY_TIER_12)
	if(!recoil_compensation)
		scatter = SCATTER_AMOUNT_TIER_8
	burst_scatter_mult = SCATTER_AMOUNT_TIER_10
	set_fire_delay(FIRE_DELAY_TIER_12)
	fa_scatter_peak = FULL_AUTO_SCATTER_PEAK_TIER_10
	fa_max_scatter = SCATTER_AMOUNT_NONE


// CLF SMARTGUN

/obj/item/weapon/gun/smartgun/clf
	name = "\improper M56A2“自由”智能机枪"
	desc = "四件式 M56A2 智能机枪系统中的枪械，本质上是一挺重型机动机枪。制造标记被刻上了殖民地解放阵线徽记。\n使用特殊操作可切换射击限制。\n按住 Alt 点击可打开供弹机盖以装填弹药。"

/obj/item/weapon/gun/smartgun/clf/Initialize(mapload, ...)
	. = ..()
	MD.iff_signal = FACTION_CLF

/obj/item/weapon/gun/smartgun/admin
	requires_power = FALSE
	requires_battery = FALSE
	requires_harness = FALSE

/obj/item/smartgun_battery
	name = "DV9 智能机枪电池"
	desc = "制式 9 伏锂干电池，USCMC 最常用它为智能机枪供电。手册称每块可支持最多 50,000 发射击，直接接入只兼容此型号的智能机枪电源插口。各种辅助模式通常会大幅缩短续航。虽不兼容大多数标准电气系统，紧急时仍可使用普通充电器充电。USCMC 智能机枪手往往把它们看得很紧。"

	icon = 'icons/obj/structures/machinery/power.dmi'
	icon_state = "smartguncell"

	force = 5
	throwforce = 5
	throw_speed = SPEED_VERY_FAST
	throw_range = 5
	w_class = SIZE_SMALL

	var/obj/item/cell/high/power_cell

/obj/item/smartgun_battery/Initialize(mapload)
	. = ..()

	power_cell = new(src)

/obj/item/smartgun_battery/get_examine_text(mob/user)
	. = ..()

	. += SPAN_NOTICE("电量指示器显示剩余 [power_cell.charge] / [power_cell.maxcharge] 电量。")

/obj/item/smartgun_battery/upp
	name = "\improper GB-12-U3 电池"
	desc = "进步人民联盟制式 12 伏铅酸电池，联盟武装集体用它给装甲载具以下几乎所有设备供电。这一型似乎专为自动机枪供电设计，也可当作钝器使用。"
	icon_state = "smartguncell_upp"
	force = 15
	throwforce = 25 //pretty aerodynamic
	throw_range = 7

/obj/item/weapon/gun/smartgun/rmc
	name = "\improper L58A3 智能机枪"
	desc = "L58A3“智能”通用机枪系统中的枪械，由美洲联盟 M56 系统大幅改造而来，为三世界帝国皇家陆战突击队分队提供火力支援。\n使用特殊操作可切换射击限制。\n按住 Alt 点击可打开供弹机盖以装填弹药。"
	current_mag = /obj/item/ammo_magazine/smartgun/holo_targeting
	ammo = /obj/item/ammo_magazine/smartgun/holo_targeting
	ammo_primary = /datum/ammo/bullet/rifle/heavy/holo_target //Toggled ammo type
	ammo_secondary = /datum/ammo/bullet/rifle/heavy/holo_target/ap ///Toggled ammo type
	ammo_tertiary = /datum/ammo/bullet/rifle/heavy/holo_target/impdet
	flags_gun_features = GUN_SPECIALIST|GUN_WIELDED_FIRING_ONLY
	zoomdevicename = "gunsight"
	icon = 'icons/obj/items/weapons/guns/guns_by_faction/twe_guns.dmi'
	icon_state = "magsg"
	item_state = "magsg"
	starting_attachment_types = list(/obj/item/attachable/l56a2_smartgun)

/obj/item/weapon/gun/smartgun/rmc/Initialize(mapload, ...)
	. = ..()
	MD.iff_signal = FACTION_TWE

/obj/item/weapon/gun/smartgun/rmc/handle_starting_attachment()
	..()
	var/obj/item/attachable/scope/mini/rmcsg/optic = new(src)
	optic.hidden = TRUE
	optic.flags_attach_features &= ~ATTACH_REMOVABLE
	optic.Attach(src)
	update_attachable(optic.slot)

/obj/item/weapon/gun/smartgun/rmc/set_gun_config_values()
	..()
	set_fire_delay(FIRE_DELAY_TIER_LMG)
	fa_scatter_peak = FULL_AUTO_SCATTER_PEAK_TIER_8
	fa_max_scatter = SCATTER_AMOUNT_TIER_9
	if(accuracy_improvement)
		accuracy_mult += HIT_ACCURACY_MULT_TIER_3
	else
		accuracy_mult += HIT_ACCURACY_MULT_TIER_1
	if(recoil_compensation)
		scatter = SCATTER_AMOUNT_TIER_10
		recoil = RECOIL_OFF
	else
		scatter = SCATTER_AMOUNT_TIER_6
		recoil = RECOIL_AMOUNT_TIER_3
	damage_mult = BASE_BULLET_DAMAGE_MULT

//For the RMC ship, giving them access to weapons early but no ammo
/obj/item/weapon/gun/smartgun/rmc/unloaded
	current_mag = null

/obj/item/weapon/gun/smartgun/silenced
	name = "XM56A4 智能机枪"
	desc = "正在进行战地试用的实验型智能机枪，配有一体式消声器和改进内部机构。"
	starting_attachment_types = list(/obj/item/attachable/smartbarrel/suppressed)

/obj/item/weapon/gun/smartgun/upp
	name = "\improper RVS-37 自动机枪"
	desc = "由俄罗斯主导、越南和西班牙地面部队参与的项目。RVS-37“峡谷”旨在与久经考验的 M56 智能机枪一较高下。"
	icon = 'icons/obj/items/weapons/guns/guns_by_faction/upp.dmi'
	icon_state = "rfvs37"
	item_state = "rfvs37"
	fire_sound = 'sound/weapons/gun_m56d_auto.ogg'
	mouse_pointer = 'icons/effects/mouse_pointer/upp_smartgun_mouse.dmi'
	current_mag = /obj/item/ammo_magazine/smartgun/upp
	ammo = /obj/item/ammo_magazine/smartgun/upp
	ammo_primary = /datum/ammo/bullet/rifle/heavy/upp_smartgun //Toggled ammo type
	ammo_secondary = /datum/ammo/bullet/rifle/heavy/upp_smartgun/ap ///Toggled ammo type
	ammo_tertiary = /datum/ammo/bullet/rifle/heavy/upp_smartgun/flak
	flags_equip_slot = SLOT_BACK|SLOT_BLOCK_SUIT_STORE
	flags_gun_features = GUN_SPECIALIST|GUN_WIELDED_FIRING_ONLY
	flags_item = TWOHANDED|SMARTGUNNER_BACKPACK_OVERRIDE
	starting_attachment_types = list(/obj/item/attachable/upp_smartgun)
	auto_retrieval_slot = WEAR_BACK
	start_semiauto = TRUE
	battery_type = /obj/item/smartgun_battery/upp
	attachable_allowed = list(
		/obj/item/attachable/upp_smartgun,
	)
	actions_types = list(
		/datum/action/item_action/smartgun/toggle_accuracy_improvement,
		/datum/action/item_action/smartgun/toggle_ammo_type,
		/datum/action/item_action/smartgun/toggle_lethal_mode,
		/datum/action/item_action/smartgun/toggle_recoil_compensation,
		/datum/action/item_action/smartgun/toggle_retrieval,
	)

/obj/item/weapon/gun/smartgun/upp/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 36, "muzzle_y" = 16,"rail_x" = 17, "rail_y" = 18, "under_x" = 22, "under_y" = 14, "stock_x" = 22, "stock_y" = 14, , "side_rail_x" = 17, "side_rail_y" = 18)

/obj/item/weapon/gun/smartgun/upp/toggle_ammo_type(mob/user)
	if(!iff_enabled)
		to_chat(user, "[icon2html(src, usr)][src]的射击限制已停用，无法切换弹药类型。")
		return
	if(ammo == ammo_primary)
		ammo = ammo_secondary
		to_chat(user, "[icon2html(src, usr)]你调整了[src]的弹药处理程序。现在发射穿甲弹，比其他弹药更容易击穿装甲目标。")
		balloon_alert(user, "发射穿甲弹")
		drain += 50
	else if(ammo == ammo_secondary)
		ammo = ammo_tertiary
		to_chat(user, "[icon2html(src, usr)]你调整了[src]的弹药处理程序。现在发射破片弹，能够释放密集的重型破片。")
		balloon_alert(user, "发射破片弹")
		drain += 100
	else
		ammo = ammo_primary
		to_chat(user, "[icon2html(src, usr)]你调整了[src]的弹药处理程序。现在发射高精度弹药，精度高，耗电也更少。")
		balloon_alert(user, "发射高精度弹")
		drain -= 150
	playsound(loc,'sound/machines/click.ogg', 25, 1)
	var/datum/action/item_action/smartgun/toggle_ammo_type/TAT = locate(/datum/action/item_action/smartgun/toggle_ammo_type) in actions
	TAT.update_icon()

/obj/item/weapon/gun/smartgun/upp/set_gun_config_values()
	..()
	set_burst_amount(BURST_AMOUNT_TIER_3)
	set_burst_delay(FIRE_DELAY_TIER_8)
	set_fire_delay(FIRE_DELAY_TIER_10)
	fa_scatter_peak = FULL_AUTO_SCATTER_PEAK_TIER_8
	fa_max_scatter = SCATTER_AMOUNT_TIER_9
	if(accuracy_improvement)
		accuracy_mult += HIT_ACCURACY_MULT_TIER_6
	else
		accuracy_mult += HIT_ACCURACY_MULT_TIER_3
	if(recoil_compensation)
		scatter = SCATTER_AMOUNT_TIER_10
		recoil = RECOIL_OFF
	else
		scatter = SCATTER_AMOUNT_TIER_6
		recoil = RECOIL_AMOUNT_TIER_3
	damage_mult = BASE_BULLET_DAMAGE_MULT

/datum/action/item_action/smartgun/toggle_retrieval/New(Target, obj/item/holder)
	. = ..()
	name = "Toggle Retrieval"
	action_icon_state = "retrieve_1"
	button.name = "切换自动回收"
	button.overlays.Cut()
	button.overlays += image('icons/mob/hud/actions.dmi', button, action_icon_state)

/datum/action/item_action/smartgun/toggle_retrieval/action_activate()
	. = ..()
	var/obj/item/weapon/gun/smartgun/gun = holder_item
	if(gun.auto_retrieval_slot)
		gun.auto_retrieval_slot = null
		gun.RemoveElement(/datum/element/drop_retrieval/gun, WEAR_BACK)
		action_icon_state = "retrieve_0"
	else
		gun.auto_retrieval_slot = WEAR_BACK
		gun.AddElement(/datum/element/drop_retrieval/gun, WEAR_BACK)
		action_icon_state = "retrieve_1"
	button.overlays.Cut()
	button.overlays += image('icons/mob/hud/actions.dmi', button, action_icon_state)
