/datum/keybinding/mob
	category = CATEGORY_HUMAN
	weight = WEIGHT_MOB

/datum/keybinding/mob/stop_pulling
	hotkey_keys = list("H", "Delete")
	classic_keys = list("Delete")
	name = "stop_pulling"
	full_name = "停止拖拽"
	description = ""
	keybind_signal = COMSIG_KB_MOB_STOPPULLING_DOWN

/datum/keybinding/mob/stop_pulling/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/M = user.mob
	if(!M.pulling)
		to_chat(user, SPAN_NOTICE("你没有在拖拽任何东西。"))
	else
		M.stop_pulling()
	return TRUE

/datum/keybinding/mob/swap_hands
	hotkey_keys = list("X", "Northeast") // PAGEUP
	classic_keys = list("X", "Northeast")
	name = "swap_hands"
	full_name = "切换双手"
	description = ""
	keybind_signal = COMSIG_KB_MOB_SWAPHANDS_DOWN

/datum/keybinding/mob/swap_hands/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/M = user.mob
	M.swap_hand()
	return TRUE

/datum/keybinding/mob/activate_inhand
	hotkey_keys = list("Z", "Southeast") // Southeast = PAGEDOWN
	classic_keys = list("Y", "Z", "Ctrl+Y", "Ctrl+Z")
	name = "activate_inhand"
	full_name = "使用手持物品"
	description = "使用当前手中持有的物品。"
	keybind_signal = COMSIG_KB_MOB_ACTIVATEINHAND_DOWN

/datum/keybinding/mob/activate_inhand/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/M = user.mob
	M.mode()
	return TRUE

/datum/keybinding/mob/drop_item
	hotkey_keys = list("Q")
	classic_keys = list("Unbound")
	name = "drop_item"
	full_name = "丢弃物品"
	description = ""
	keybind_signal = COMSIG_KB_MOB_DROPITEM_DOWN

/datum/keybinding/mob/drop_item/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/M = user.mob
	var/obj/item/I = M.get_held_item()
	if(!I)
		to_chat(user, SPAN_WARNING("你手里没有可以丢下的东西！"))
	else
		user.mob.drop_held_item(I)
	return TRUE

// Parent type of the bodypart targeting keybinds
/datum/keybinding/mob/target

/datum/keybinding/mob/target/down(client/user)
	. = ..()
	if(. || !user.mob)
		return

	user.mob.select_body_zone(get_target_zone(user))
	return TRUE

/// Returns the body zone which should be targeted when pressing this keybind.
/datum/keybinding/mob/target/proc/get_target_zone(client/user)
	return

/datum/keybinding/mob/target/head_cycle
	hotkey_keys = list("Numpad8")
	classic_keys = list("Numpad8")
	name = "target_head_cycle"
	full_name = "瞄准：切换头部区域"
	description = "按此键瞄准头部，继续按可依次切换至眼睛和嘴部。这会影响你击中的部位，也可用于手术。"
	keybind_signal = COMSIG_KB_MOB_TARGETCYCLEHEAD_DOWN

/datum/keybinding/mob/target/head_cycle/get_target_zone(client/user)
	switch(user.mob.zone_selected)
		if("head")
			return "eyes"
		if("eyes")
			return "mouth"
		else // including if("mouth")
			return "head"

/datum/keybinding/mob/target/r_arm
	hotkey_keys = list("Numpad4")
	classic_keys = list("Numpad4")
	name = "target_r_arm"
	full_name = "瞄准：右臂"
	description = "按此键瞄准右臂。这会影响你击中的部位，也可用于手术。"
	keybind_signal = COMSIG_KB_MOB_TARGETRIGHTARM_DOWN

/datum/keybinding/mob/target/r_arm/get_target_zone(client/user)
	if(user.mob.zone_selected == "r_arm")
		return "r_hand"
	return "r_arm"

/datum/keybinding/mob/target/body_chest
	hotkey_keys = list("Numpad5")
	classic_keys = list("Numpad5")
	name = "target_body_chest"
	full_name = "瞄准：胸部"
	description = "按此键瞄准胸部。这会影响攻击命中的部位，也可用于手术。"
	keybind_signal = COMSIG_KB_MOB_TARGETBODYCHEST_DOWN

/datum/keybinding/mob/target/body_chest/get_target_zone(client/user)
	return "chest"

/datum/keybinding/mob/target/left_arm
	hotkey_keys = list("Numpad6")
	classic_keys = list("Numpad6")
	name = "target_left_arm"
	full_name = "瞄准：左臂"
	description = "按此键瞄准胸部。这会影响攻击命中的部位，也可用于手术。"
	keybind_signal = COMSIG_KB_MOB_TARGETLEFTARM_DOWN

/datum/keybinding/mob/target/left_arm/get_target_zone(client/user)
	if(user.mob.zone_selected == "l_arm")
		return "l_hand"
	return "l_arm"

/datum/keybinding/mob/target/right_leg
	hotkey_keys = list("Numpad1")
	classic_keys = list("Numpad1")
	name = "target_right_leg"
	full_name = "瞄准：右腿"
	description = "按此键瞄准右腿。这会影响攻击命中的部位，也可用于手术。"
	keybind_signal = COMSIG_KB_MOB_TARGETRIGHTLEG_DOWN

/datum/keybinding/mob/target/right_leg/get_target_zone(client/user)
	if(user.mob.zone_selected == "r_leg")
		return "r_foot"
	return "r_leg"

/datum/keybinding/mob/target/body_groin
	hotkey_keys = list("Numpad2")
	classic_keys = list("Numpad2")
	name = "target_body_groin"
	full_name = "瞄准：腹股沟"
	description = "按此键瞄准腹股沟。这会影响攻击命中的部位，也可用于手术。"
	keybind_signal = COMSIG_KB_MOB_TARGETBODYGROIN_DOWN

/datum/keybinding/mob/target/body_groin/get_target_zone(client/user)
	return "groin"

/datum/keybinding/mob/target/left_leg
	hotkey_keys = list("Numpad3")
	classic_keys = list("Numpad3")
	name = "target_left_leg"
	full_name = "瞄准：左腿"
	description = "按此键瞄准左腿。这会影响攻击命中的部位，也可用于手术。"
	keybind_signal = COMSIG_KB_MOB_TARGETLEFTLEG_DOWN

/datum/keybinding/mob/target/left_leg/get_target_zone(client/user)
	if(user.mob.zone_selected == "l_leg")
		return "l_foot"
	return "l_leg"

/datum/keybinding/mob/target/next
	hotkey_keys = list("Numpad7")
	classic_keys = list("Numpad7")
	name = "target_next"
	full_name = "瞄准：下一个部位"
	description = "按此键按顺序瞄准下一个身体部位。这会影响攻击命中的部位，也可用于手术。"
	keybind_signal = COMSIG_KB_MOB_TARGETNEXT_DOWN

/datum/keybinding/mob/target/next/get_target_zone(client/user)
	return next_in_list(user.mob.zone_selected, DEFENSE_ZONES_LIVING)

/datum/keybinding/mob/target/prev
	hotkey_keys = list("Numpad9")
	classic_keys = list("Numpad9")
	name = "target_prev"
	full_name = "瞄准：上一个部位"
	description = "按此键逆序瞄准上一个身体部位。这会影响攻击命中的部位，也可用于手术。"
	keybind_signal = COMSIG_KB_MOB_TARGETPREV_DOWN

/datum/keybinding/mob/target/prev/get_target_zone(client/user)
	return prev_in_list(user.mob.zone_selected, DEFENSE_ZONES_LIVING)

/datum/keybinding/mob/prevent_movement
	hotkey_keys = list("Ctrl", "Alt")
	classic_keys = list("Ctrl", "Alt")
	name = "block_movement"
	full_name = "转向／锁定移动"
	description = "按住时禁止移动"
	keybind_signal = COMSIG_KB_MOB_BLOCKMOVEMENT_DOWN

/datum/keybinding/mob/prevent_movement/down(client/user)
	. = ..()
	if(.)
		return
	user.movement_locked = TRUE

/datum/keybinding/mob/prevent_movement/up(client/user)
	. = ..()
	if(.)
		return
	user.movement_locked = FALSE
