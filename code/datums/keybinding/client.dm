/datum/keybinding/client
	category = CATEGORY_CLIENT
	weight = WEIGHT_HIGHEST


/datum/keybinding/client/admin_help
	hotkey_keys = list("Unbound")
	classic_keys = list("Unbound")
	name = "admin_help"
	full_name = "管理员求助"
	description = "向管理员求助。"
	keybind_signal = COMSIG_KB_CLIENT_GETHELP_DOWN

/datum/keybinding/client/admin_help/down(client/user)
	. = ..()
	if(.)
		return
	user.adminhelp()
	return TRUE


/datum/keybinding/client/screenshot
	hotkey_keys = list("F2")
	classic_keys = list("Unbound")
	name = "screenshot"
	full_name = "截图"
	description = "截取屏幕画面。"
	keybind_signal = COMSIG_KB_CLIENT_SCREENSHOT_DOWN

/datum/keybinding/client/screenshot/down(client/user)
	. = ..()
	if(.)
		return
	winset(user, null, "command=.screenshot [!user.keys_held[SHIFT_CLICK] ? "auto" : ""]")
	return TRUE

/datum/keybinding/client/toggle_fullscreen
	hotkey_keys = list("F11")
	classic_keys = list("F11")
	name = "toggle_fullscreen"
	full_name = "切换全屏"
	description = "在真正的全屏和普通窗口模式之间切换。"
	keybind_signal = COMSIG_KB_CLIENT_TOGGLEFULLSCREEN_DOWN

/datum/keybinding/client/toggle_fullscreen/down(client/user)
	. = ..()
	if(.)
		return
	user.toggle_fullscreen_preference()
	return TRUE

/datum/keybinding/client/minimal_hud
	hotkey_keys = list("F12")
	classic_keys = list("F12")
	name = "minimal_hud"
	full_name = "精简HUD"
	description = "隐藏大部分HUD元素。"
	keybind_signal = COMSIG_KB_CLIENT_MINIMALHUD_DOWN

/datum/keybinding/client/minimal_hud/down(client/user)
	. = ..()
	if(.)
		return
	user.mob.button_pressed_F12()
	return TRUE
