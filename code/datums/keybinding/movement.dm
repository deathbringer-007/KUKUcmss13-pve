/datum/keybinding/movement
	category = CATEGORY_MOVEMENT
	weight = WEIGHT_HIGHEST

/datum/keybinding/movement/north
	hotkey_keys = list("W", "North")
	classic_keys = list("W", "North")
	name = "North"
	full_name = "向北移动"
	description = "使角色向北移动。"
	keybind_signal = COMSIG_KB_MOVEMENT_NORTH_DOWN

/datum/keybinding/movement/northface
	hotkey_keys = list("Alt+North", "Alt+W")
	classic_keys = list("Alt+North", "Alt+W")
	name = "face_north"
	full_name = "锁定朝北"
	description = "朝北转身。"
	keybind_signal = COMSIG_KB_MOVEMENT_FACE_NORTH_DOWN

/datum/keybinding/movement/northface/down(client/user)
	. = ..()
	if(.)
		return
	user.mob.northfaceperm()
	return TRUE

/datum/keybinding/movement/south
	hotkey_keys = list("S", "South")
	classic_keys = list("S", "South")
	name = "South"
	full_name = "向南移动"
	description = "使角色向南移动。"
	keybind_signal = COMSIG_KB_MOVEMENT_SOUTH_DOWN

/datum/keybinding/movement/southface
	hotkey_keys = list("Alt+South", "Alt+S")
	classic_keys = list("Alt+South", "Alt+S")
	name = "face_south"
	full_name = "锁定朝南"
	description = "朝南转身。"
	keybind_signal = COMSIG_KB_MOVEMENT_FACE_SOUTH_DOWN

/datum/keybinding/movement/southface/down(client/user)
	. = ..()
	if(.)
		return
	user.mob.southfaceperm()
	return TRUE
/datum/keybinding/movement/west
	hotkey_keys = list("A", "West")
	classic_keys = list("A", "West")
	name = "West"
	full_name = "向西移动"
	description = "使角色向左移动。"
	keybind_signal = COMSIG_KB_MOVEMENT_WEST_DOWN

/datum/keybinding/movement/westface
	hotkey_keys = list("Alt+West", "Alt+A")
	classic_keys = list("Alt+West", "Alt+A")
	name = "face_west"
	full_name = "锁定朝西"
	description = "朝西转身。"
	keybind_signal = COMSIG_KB_MOVEMENT_FACE_WEST_DOWN

/datum/keybinding/movement/westface/down(client/user)
	. = ..()
	if(.)
		return
	user.mob.westfaceperm()
	return TRUE

/datum/keybinding/movement/east
	hotkey_keys = list("D", "East")
	classic_keys = list("D", "East")
	name = "East"
	full_name = "向东移动"
	description = "使角色向东移动。"
	keybind_signal = COMSIG_KB_MOVEMENT_EAST_DOWN

/datum/keybinding/movement/eastface
	hotkey_keys = list("Alt+East", "Alt+D")
	classic_keys = list("Alt+East", "Alt+D")
	name = "face_east"
	full_name = "锁定朝东"
	description = "朝东转身。"
	keybind_signal = COMSIG_KB_MOVEMENT_FACE_EAST_DOWN

/datum/keybinding/movement/eastface/down(client/user)
	. = ..()
	if(.)
		return
	user.mob.eastfaceperm()
	return TRUE
