
//-------------------------------------------------------
//ENERGY GUNS/LASER GUNS/ETC



/obj/item/weapon/gun/energy //whoever delegated all behavior to the taser instead of a parent object needs to dig themselves a hole to die in. Fuck you old dev.
	name = "能量手枪"
	desc = "通过内置电池供能发射激光，可在大多数充电设备上充电。"

	icon_state = "stunrevolver"
	item_state = "stunrevolver"
	muzzleflash_iconstate = null//replace at some point
	fire_sound = 'sound/weapons/emitter2.ogg'

	ammo = /datum/ammo/energy
	w_class = SIZE_LARGE
	matter = list("metal" = 2000)

	var/obj/item/cell/high/cell //10000 power.
	var/charge_cost = 350
	var/max_shots //calculated on init, no need to manually fill out
	var/works_in_recharger = TRUE
	var/has_charge_meter = FALSE//do we use the charging overlay system or just have an empty overlay
	var/charge_icon = "+stunrevolver_empty"//define on a per gun basis, used for the meter and empty icon on non meter guns

	flags_gun_features = GUN_UNUSUAL_DESIGN|GUN_CAN_POINTBLANK
	gun_category = GUN_CATEGORY_HANDGUN

/obj/item/weapon/gun/energy/Initialize(mapload, spawn_empty)
	. = ..()
	cell = new /obj/item/cell/high(src)
	update_icon()
	max_shots = round((cell.maxcharge / charge_cost), 1)

/obj/item/weapon/gun/energy/Destroy()
	QDEL_NULL(cell)
	. = ..()

/obj/item/weapon/gun/energy/update_icon()
	. = ..()

	icon_state = "[base_gun_icon]"

	if(!cell)
		return

	if(!has_charge_meter)
		switch(cell.percent())
			if(10 to 100)
				overlays -= charge_icon
			else
				overlays += charge_icon
		return
	else
		switch(cell.percent())
			if(75 to 100)
				overlays += charge_icon + "_100"
			if(50 to 75)
				overlays += charge_icon + "_75"
			if(25 to 50)
				overlays += charge_icon + "_50"
			if(1 to 25)
				overlays += charge_icon + "_25"
			else
				overlays += charge_icon + "_0"

/obj/item/weapon/gun/energy/emp_act(severity)
	. = ..()
	cell.use(floor(cell.maxcharge / severity))
	update_icon()

/obj/item/weapon/gun/energy/load_into_chamber()
	if(!cell || cell.charge < charge_cost)
		return

	cell.charge -= charge_cost
	in_chamber = create_bullet(ammo, initial(name))
	return in_chamber

/obj/item/weapon/gun/energy/has_ammunition()
	if(cell?.charge >= charge_cost)
		return TRUE //Enough charge for a shot.

/obj/item/weapon/gun/energy/Fire(atom/target, mob/living/user, params, reflex, dual_wield)
	. = ..()
	if(.)
		var/to_firer = "你用[name]开火！"
		if(has_charge_meter)
			to_firer = "[round((cell.charge / charge_cost), 1)] / [max_shots] 发剩余"
		user.visible_message(SPAN_DANGER("[user]发射了[src]！"),
		SPAN_DANGER("[to_firer]"), message_flags = CHAT_TYPE_WEAPON_USE)
		return AUTOFIRE_CONTINUE

/obj/item/weapon/gun/energy/reload_into_chamber()
	update_icon()
	return TRUE

/obj/item/weapon/gun/energy/delete_bullet(obj/projectile/projectile_to_fire, refund = 0)
	qdel(projectile_to_fire)
	if(refund) cell.charge += charge_cost
	return TRUE

/obj/item/weapon/gun/energy/get_examine_text(mob/user)
	. = ..()
	if(has_charge_meter && cell)
		. += SPAN_NOTICE("剩余[round((cell.charge / charge_cost), 1)]/[max_shots]发射击次数。")
	else if(cell)
		. += SPAN_NOTICE("剩余电量为[cell.percent()]%。")
	else
		. += SPAN_NOTICE("内部没有电池。")

/obj/item/weapon/gun/energy/rxfm5_eva
	name = "RXF-M5舱外活动手枪"
	desc = "为舱外活动设计的高功率聚焦激光手枪，实际上几乎在任何环境下都能使用。它采用与激光焊机同源的技术，由维兰德-汤谷公司配发，也面向民用市场出售。"
	icon = 'icons/obj/items/weapons/guns/guns_by_faction/colony.dmi'
	icon_state = "rxfm5_eva"
	item_state = "eva"
	muzzleflash_iconstate = "muzzle_laser"
	muzzle_flash_color = COLOR_LASER_RED
	fire_sound = 'sound/weapons/Laser4.ogg'
	w_class = SIZE_MEDIUM
	gun_category = GUN_CATEGORY_HANDGUN
	flags_equip_slot = SLOT_WAIST
	flags_gun_features = GUN_CAN_POINTBLANK|GUN_AMMO_COUNTER|GUN_ONE_HAND_WIELDED
	ammo = /datum/ammo/energy/rxfm_eva
	attachable_allowed = list(/obj/item/attachable/scope/variable_zoom/eva, /obj/item/attachable/eva_doodad)
	starting_attachment_types = list(/obj/item/attachable/scope/variable_zoom/eva, /obj/item/attachable/eva_doodad)
	has_charge_meter = FALSE
	charge_icon = "+rxfm5_empty"

/obj/item/weapon/gun/energy/rxfm5_eva/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 0, "muzzle_y" = 0,"rail_x" = 12, "rail_y" = 21, "under_x" = 16, "under_y" = 10, "stock_x" = 0, "stock_y" = 0)

/obj/item/weapon/gun/energy/rxfm5_eva/set_gun_config_values()
	..()
	set_fire_delay(FIRE_DELAY_TIER_9)
	accuracy_mult = BASE_ACCURACY_MULT - HIT_ACCURACY_MULT_TIER_3
	scatter = SCATTER_AMOUNT_TIER_7
	damage_mult = BASE_BULLET_DAMAGE_MULT
	recoil = RECOIL_AMOUNT_TIER_4
	recoil_unwielded = RECOIL_AMOUNT_TIER_3

// Funny procs to force the item_states to look right.

/obj/item/weapon/gun/energy/rxfm5_eva/update_icon()
	..()
	item_state = "eva"
	for(var/i in attachments)
		if(istype(attachments[i], /obj/item/attachable/scope/variable_zoom/eva))
			item_state += "_s"
		if(istype(attachments[i], /obj/item/attachable/eva_doodad))
			item_state += "_d"

/obj/item/weapon/gun/energy/rxfm5_eva/attach_to_gun(mob/user, obj/item/attachable/attachment)
	. = ..()
	update_icon()
	user.update_inv_r_hand()
	user.update_inv_l_hand()

/obj/item/weapon/gun/energy/rxfm5_eva/on_detach(mob/user, obj/item/attachable/attachment)
	. = ..()
	update_icon()
	user.update_inv_r_hand()
	user.update_inv_l_hand()

/obj/item/weapon/gun/energy/laser_top
	name = "'LAZ-TOP'"
	desc = "“LAZ-TOP”，也就是激光阳极什么什么……"//finish this later

/obj/item/weapon/gun/energy/laz_uzi
	name = "激光乌兹冲锋枪"
	desc = "由经典以色列冲锋枪改装而成，发射激光束。"
	icon = 'icons/obj/items/weapons/guns/guns_by_faction/colony.dmi'
	icon_state = "laz_uzi"
	item_state = "laz_uzi"
	muzzleflash_iconstate = "muzzle_laser"
	muzzle_flash_color = COLOR_LASER_RED
	gun_category = GUN_CATEGORY_SMG
	flags_equip_slot = SLOT_WAIST
	charge_cost = 200
	ammo = /datum/ammo/energy/laz_uzi
	fire_sound = 'sound/weapons/Laser4.ogg'
	has_charge_meter = FALSE
	charge_icon = "+laz_uzi_empty"
	start_automatic = TRUE

/obj/item/weapon/gun/energy/laz_uzi/set_gun_config_values()
	..()
	set_fire_delay(FIRE_DELAY_TIER_SMG)
	set_burst_delay(FIRE_DELAY_TIER_SMG)
	set_burst_amount(BURST_AMOUNT_TIER_2)
	accuracy_mult = BASE_ACCURACY_MULT - HIT_ACCURACY_MULT_TIER_3
	accuracy_mult_unwielded = BASE_ACCURACY_MULT - HIT_ACCURACY_MULT_TIER_7
	scatter = SCATTER_AMOUNT_TIER_5
	burst_scatter_mult = SCATTER_AMOUNT_TIER_5
	scatter_unwielded = SCATTER_AMOUNT_TIER_6
	damage_mult = BASE_BULLET_DAMAGE_MULT
	recoil_unwielded = RECOIL_AMOUNT_TIER_5
	fa_scatter_peak = SCATTER_AMOUNT_TIER_8

//############################ Taser ##################
// Lots of bits for it so splitting off an area
/obj/item/weapon/gun/energy/taser
	name = "失能枪"
	desc = "能够发射电离电球的先进电击装置，用于非致命制服目标。"
	icon = 'icons/obj/items/weapons/guns/guns_by_faction/uscm.dmi'
	icon_state = "taser"
	item_state = "taser"
	muzzleflash_iconstate = null //TO DO.
	fire_sound = 'sound/weapons/Taser.ogg'
	w_class = SIZE_MEDIUM
	ammo = /datum/ammo/energy/taser/precise
	charge_cost = 625 // approx 16 shots.
	has_charge_meter = TRUE
	charge_icon = "+taser"
	black_market_value = 20
	actions_types = list(/datum/action/item_action/taser/change_mode)
	flags_gun_features = GUN_UNUSUAL_DESIGN|GUN_CAN_POINTBLANK|GUN_CANT_EXECUTE
	/// Determines if the taser will hit any target, or if it checks for wanted status. Default is wanted only.
	var/mode = TASER_MODE_P
	var/skilllock = SKILL_POLICE_SKILLED

/obj/item/weapon/gun/energy/taser/set_gun_config_values()
	..()
	set_fire_delay(FIRE_DELAY_TIER_7)
	accuracy_mult = BASE_ACCURACY_MULT
	accuracy_mult_unwielded = BASE_ACCURACY_MULT
	damage_mult = BASE_BULLET_DAMAGE_MULT
	movement_onehanded_acc_penalty_mult = 0
	scatter = 0
	scatter_unwielded = 0

/obj/item/weapon/gun/energy/taser/able_to_fire(mob/living/user)
	. = ..()
	if (. && istype(user)) //Let's check all that other stuff first.
		if(skilllock && !skillcheck(user, SKILL_POLICE, skilllock))
			to_chat(user, SPAN_WARNING("你似乎不知道如何使用[src]……"))
			return FALSE

/obj/item/weapon/gun/energy/taser/unique_action(mob/user)
	change_mode(user)

/obj/item/weapon/gun/energy/taser/get_examine_text(mob/user)
	. = ..()
	switch(mode)
		if(TASER_MODE_P)
			. += SPAN_RED("当前为精准模式，已连接通缉数据库。")
		if(TASER_MODE_F)
			. += SPAN_GREEN("当前为自由模式，不再连接通缉数据库。")

/obj/item/weapon/gun/energy/taser/update_icon()
	. = ..()
	overlays += charge_icon + "_[mode]"

/// Changes between targetting wanted persons or any persons. Originally used by unique_action, made own proc to allow for use in action button too.
/obj/item/weapon/gun/energy/taser/proc/change_mode(mob/user)
	switch(mode)
		if(TASER_MODE_P)
			mode = TASER_MODE_F
			to_chat(user, SPAN_NOTICE("[src]已切换为自由模式。"))
			ammo = GLOB.ammo_list[/datum/ammo/energy/taser]
		if(TASER_MODE_F)
			mode = TASER_MODE_P
			to_chat(user, SPAN_NOTICE("[src]已切换为精准模式。"))
			ammo = GLOB.ammo_list[/datum/ammo/energy/taser/precise]
	var/datum/action/item_action/taser/change_mode/action = locate(/datum/action/item_action/taser/change_mode) in actions
	action.update_icon()
	update_icon()
	playsound(loc,'sound/machines/click.ogg', 25, 1)


/datum/action/item_action/taser/action_activate()
	. = ..()
	var/obj/item/weapon/gun/energy/taser/taser = holder_item
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/humie = owner
	if(humie.is_mob_incapacitated() || taser.get_active_firearm(humie, FALSE) != holder_item)
		return

/datum/action/item_action/taser/change_mode/New(target, obj/item/holder)
	. = ..()
	name = "Change Target Mode"
	action_icon_state = "id_lock_locked"// As the taser mode is based on the wanted database, it can share this icon as it makes sense.
	button.name = "切换瞄准模式"
	button.overlays.Cut()
	button.overlays += image('icons/mob/hud/actions.dmi', button, action_icon_state)

/datum/action/item_action/taser/change_mode/action_activate()
	. = ..()
	var/obj/item/weapon/gun/energy/taser/taser = holder_item
	taser.change_mode(usr)

/// Updates the action button icon dependant on mode.
/datum/action/item_action/taser/change_mode/proc/update_icon()
	var/obj/item/weapon/gun/energy/taser/taser = holder_item
	switch(taser.mode)
		if(TASER_MODE_F)
			action_icon_state = "id_lock_unlocked"
		if(TASER_MODE_P)
			action_icon_state = "id_lock_locked"
	button.overlays.Cut()
	button.overlays += image('icons/mob/hud/actions.dmi', button, action_icon_state)
