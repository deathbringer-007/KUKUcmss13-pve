/datum/keybinding/living
	category = CATEGORY_HUMAN
	weight = WEIGHT_MOB

/datum/keybinding/living/can_use(client/user)
	return isliving(user.mob)

/datum/keybinding/living/resist
	hotkey_keys = list("B")
	classic_keys = list("Unbound")
	name = "resist"
	full_name = "Resist"
	description = "挣脱当前束缚。被铐住了？着火了？使用抵抗动作！"
	keybind_signal = COMSIG_KB_LIVING_RESIST_DOWN

/datum/keybinding/living/resist/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/living/L = user.mob
	L.resist()
	return TRUE

/datum/keybinding/living/rest
	hotkey_keys = list("Shift+R")
	classic_keys = list("Unbound")
	name = "rest"
	full_name = "Rest"
	description = "躺下或起身。"
	keybind_signal = COMSIG_KB_LIVING_REST_DOWN

/datum/keybinding/living/rest/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/living/living_mob = user.mob
	living_mob.lay_down()
	return TRUE

/datum/keybinding/living/toggle_surgery
	name = "toggle_surgery"
	full_name = "Toggle Surgery Mode"
	hotkey_keys = list("Unbound")
	classic_keys = list("Unbound")
	description = "进入或退出手术准备状态。若原本未设置帮助意图安全模式，此操作也会启用或关闭该模式。"
	keybind_signal = COMSIG_KB_SURGERY_INTENT_DOWN

/datum/keybinding/living/toggle_surgery/down(client/user)
	. = ..()
	if(.)
		return
	var/datum/action/surgery_toggle/surgery_action = locate() in user.mob.actions
	if(surgery_action)
		surgery_action.action_activate()
		return TRUE

/datum/keybinding/living/mov_intent
	hotkey_keys = list("/")
	classic_keys = list("Unbound")
	name = "mov_intent"
	full_name = "Move Intent"
	description = "切换当前移动方式。"
	keybind_signal = COMSIG_KB_MOB_MOVINTENT_DOWN

/datum/keybinding/living/mov_intent/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/living/M = user.mob
	M.toggle_mov_intent()
	return TRUE

/datum/keybinding/living/cancel_camera_view
	hotkey_keys = list("Unbound")
	classic_keys = list("Unbound")
	name = "cancel_camera_view"
	full_name = "Cancel Camera View"
	description = "将视角重置到自己的角色。"
	keybind_signal = COMSIG_KB_LIVING_CANCEL_CAMERA_VIEW

/datum/keybinding/living/cancel_camera_view/down(client/user)
	. = ..()
	if(.)
		return

	var/mob/used_mob = user?.mob
	if(!used_mob)
		return

	used_mob.reset_view(null)
	used_mob.unset_interaction()
	if(isliving(used_mob))
		var/mob/living/living_mob = used_mob
		if(living_mob.cameraFollow)
			living_mob.cameraFollow = null
