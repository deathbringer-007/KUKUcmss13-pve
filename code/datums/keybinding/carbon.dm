/datum/keybinding/carbon
	category = CATEGORY_CARBON
	weight = WEIGHT_MOB

/datum/keybinding/carbon/can_use(client/user)
	return iscarbon(user.mob)

/datum/keybinding/carbon/toggle_throw_mode
	hotkey_keys = list("R", "Southwest") // END
	classic_keys =list("R", "Southwest")
	name = "toggle_throw_mode"
	full_name = "切换投掷模式"
	description = "切换当前物品的投掷模式。"
	category = CATEGORY_CARBON
	keybind_signal = COMSIG_KB_CARBON_TOGGLETHROWMODE_DOWN
	var/throw_mode = THROW_MODE_NORMAL

/datum/keybinding/carbon/toggle_throw_mode/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/C = user.mob
	C.toggle_throw_mode(throw_mode)
	return TRUE

/datum/keybinding/carbon/toggle_throw_mode/high
	hotkey_keys = list("Ctrl+R", "Ctrl+Southwest") // END
	classic_keys = list("Ctrl+R", "Ctrl+Southwest")
	name = "toggle_high_throw_mode"
	full_name = "切换高抛模式"
	description = "切换当前物品的投掷模式。此项使用高抛。"
	category = CATEGORY_CARBON
	keybind_signal = COMSIG_KB_CARBON_TOGGLETHROWMODE_HIGH_DOWN
	throw_mode = THROW_MODE_HIGH

/datum/keybinding/carbon/cycle_intent
	hotkey_keys = list("Unbound")
	classic_keys = list("Insert")
	name = "cycle_intent"
	full_name = "切换意图"
	description = "循环切换当前选定的意图。"
	category = CATEGORY_CARBON
	keybind_signal = COMSIG_KB_CARBON_CYCLEINTENT_DOWN

/datum/keybinding/carbon/cycle_intent/down(client/user)
	. = ..()
	if(.)
		return
	user.mob?.a_intent_change(NONE)
	return TRUE

/datum/keybinding/carbon/select_help_intent
	hotkey_keys = list("1")
	classic_keys = list("1")
	name = "select_help_intent"
	full_name = "选择帮助意图"
	description = ""
	category = CATEGORY_CARBON
	keybind_signal = COMSIG_KB_CARBON_SELECTHELPINTENT_DOWN

/datum/keybinding/carbon/select_help_intent/down(client/user)
	. = ..()
	if(.)
		return
	user.mob?.a_intent_change(INTENT_HELP)
	return TRUE


/datum/keybinding/carbon/select_disarm_intent
	hotkey_keys = list("2")
	classic_keys = list("2")
	name = "select_disarm_intent"
	full_name = "选择缴械意图"
	description = ""
	category = CATEGORY_CARBON
	keybind_signal = COMSIG_KB_CARBON_SELECTDISARMINTENT_DOWN

/datum/keybinding/carbon/select_disarm_intent/down(client/user)
	. = ..()
	if(.)
		return
	user.mob?.a_intent_change(INTENT_DISARM)
	return TRUE


/datum/keybinding/carbon/select_grab_intent
	hotkey_keys = list("3")
	classic_keys = list("3")
	name = "select_grab_intent"
	full_name = "选择抓取意图"
	description = ""
	category = CATEGORY_CARBON
	keybind_signal = COMSIG_KB_CARBON_SELECTGRABINTENT_DOWN

/datum/keybinding/carbon/select_grab_intent/down(client/user)
	. = ..()
	if(.)
		return
	user.mob?.a_intent_change(INTENT_GRAB)
	return TRUE


/datum/keybinding/carbon/select_harm_intent
	hotkey_keys = list("4")
	classic_keys = list("4")
	name = "select_harm_intent"
	full_name = "选择伤害意图"
	description = ""
	category = CATEGORY_CARBON
	keybind_signal = COMSIG_KB_CARBON_SELECTHARMINTENT_DOWN

/datum/keybinding/carbon/select_harm_intent/down(client/user)
	. = ..()
	if(.)
		return
	user.mob?.a_intent_change(INTENT_HARM)
	return TRUE

/datum/keybinding/carbon/give
	hotkey_keys = list("G")
	classic_keys = list("Unbound")
	name = "Give_Item"
	full_name = "递交物品"
	description = "递出你当前手持的物品。"
	keybind_signal = COMSIG_KB_CARBON_GIVEITEM_DOWN

/datum/keybinding/carbon/give/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/C = user.mob
	C.give()
	return TRUE
