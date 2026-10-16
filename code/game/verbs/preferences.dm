/client/verb/edit_characters()
	set category = "Preferences"
	set name = "编辑角色"
	set desc = "在偏好设置中编辑你的角色。"

	to_chat(usr, SPAN_WARNING("注意：更改可能要到重新出生后才会生效。"))
	prefs.ShowChoices(mob)
