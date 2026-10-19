//toggles
/client/proc/toggle_hear_radio()
	set name = "Show/Hide Radio Chatter"
	set category = "Preferences.Chat"
	set desc = "Toggle seeing radio chatter from radios and speakers"
	if(!admin_holder) return
	prefs.toggles_chat ^= CHAT_RADIO
	prefs.save_preferences()
	to_chat(usr, SPAN_BOLDNOTICE("You will [(prefs.toggles_chat & CHAT_RADIO) ? "now" : "no longer"] see radio chatter from radios or speakers"))

/client/proc/toggleadminhelpsound()
	set name = "Hear/Silence Adminhelps"
	set category = "Preferences.Sound"
	set desc = "Toggle hearing a notification when admin PMs are received"
	if(!admin_holder) return
	prefs.toggles_sound ^= SOUND_ADMINHELP
	prefs.save_preferences()
	to_chat(usr, SPAN_BOLDNOTICE("You will [(prefs.toggles_sound & SOUND_ADMINHELP) ? "now" : "no longer"] hear a sound when adminhelps arrive."))

/client/proc/toggleprayers()
	set name = "Show/Hide Prayers"
	set category = "Preferences.Chat"
	set desc = "Toggles seeing prayers"
	prefs.toggles_chat ^= CHAT_PRAYER
	prefs.save_preferences()
	to_chat(src, SPAN_BOLDNOTICE("You will [(prefs.toggles_chat & CHAT_PRAYER) ? "now" : "no longer"] see prayerchat."))

/client/verb/toggle_observer_announcement_sounds()
	set name = "Hear/Silence Ghost Announcements"
	set category = "Preferences.Sound"
	set desc = "切换观察者是否播放公告提示音。"
	prefs.toggles_sound ^= SOUND_OBSERVER_ANNOUNCEMENTS
	prefs.save_preferences()
	to_chat(usr, SPAN_BOLDNOTICE("作为观察者，你现在[(prefs.toggles_sound & SOUND_OBSERVER_ANNOUNCEMENTS) ? "会" : "不会"]听到公告提示音。"))

/client/verb/toggle_fax_machine_sounds()
	set name = "Hear/Silence Ghost Fax Machines"
	set category = "Preferences.Sound"
	set desc = "切换观察者是否播放传真提示音。"
	prefs.toggles_sound ^= SOUND_FAX_MACHINE
	prefs.save_preferences()
	to_chat(usr, SPAN_BOLDNOTICE("作为观察者，你现在[(prefs.toggles_sound & SOUND_FAX_MACHINE) ? "会" : "不会"]听到传真提示音。"))

/client/verb/toggletitlemusic()
	set name = "Hear/Silence LobbyMusic"
	set category = "Preferences.Sound"
	set desc = "切换游戏大厅音乐。"
	prefs.toggles_sound ^= SOUND_LOBBY
	prefs.save_preferences()
	if(prefs.toggles_sound & SOUND_LOBBY)
		to_chat(src, SPAN_BOLDNOTICE("现在会播放游戏大厅音乐。"))
		if(istype(mob, /mob/new_player))
			playtitlemusic()
	else
		to_chat(src, SPAN_BOLDNOTICE("现在不会播放游戏大厅音乐。"))
		src << sound(null, repeat = 0, wait = 0, volume = 85, channel = SOUND_CHANNEL_LOBBY) // stop the jamsz

/client/verb/togglerebootsound()
	set name = "Hear/Silence Reboot Sound"
	set category = "Preferences.Sound"
	set desc = "切换服务器重启音效。"
	prefs.toggles_sound ^= SOUND_REBOOT
	prefs.save_preferences()
	to_chat(src, "你现在[(prefs.toggles_sound & SOUND_REBOOT) ? "会" : "不会"]听到服务器重启音效。")

/client/verb/togglemidis()
	set name = "Silence Current Admin Sound"
	set category = "Preferences.Sound"
	set desc = "停止当前的管理员音效。也可使用聊天面板上方播放器中的停止图标。"
	tgui_panel?.stop_music()

/client/verb/togglechat()
	set name = "Toggle Abovehead Chat"
	set category = "Preferences.Chat"
	set desc = "切换头顶聊天，效果持续到更换躯体。"

	prefs.lang_chat_disabled = ~prefs.lang_chat_disabled
	prefs.save_preferences()
	to_chat(src,SPAN_BOLDNOTICE( "你现在[(!prefs.lang_chat_disabled) ? "会" : "不会"]看到头顶聊天消息。"))

/client/verb/togglechatemotes()
	set name = "Toggle Abovehead Chat Emotes"
	set category = "Preferences.Chat"
	set desc = "切换头顶聊天中的表情动作显示。"

	prefs.toggles_langchat ^= LANGCHAT_SEE_EMOTES
	prefs.save_preferences()
	to_chat(src,SPAN_BOLDNOTICE( "你现在[(prefs.toggles_langchat & LANGCHAT_SEE_EMOTES) ? "会" : "不会"]在头顶聊天中看到表情动作。"))

/client/verb/toggle_permission_errors()
	set name = "Toggle Permission Errors"
	set category = "Preferences.Chat"
	set desc = "切换权限不足的错误提示。"

	prefs.show_permission_errors = !prefs.show_permission_errors
	prefs.save_preferences()
	to_chat(src, SPAN_BOLDNOTICE("你现在[(prefs.show_permission_errors) ? "会" : "不会"]看到权限错误消息。"))

/client/verb/listen_ooc()
	set name = "Show/Hide OOC"
	set category = "Preferences.Chat"
	set desc = "切换场外聊天显示。"
	prefs.toggles_chat ^= CHAT_OOC
	prefs.save_preferences()
	to_chat(src, SPAN_BOLDNOTICE("你现在[(prefs.toggles_chat & CHAT_OOC) ? "会" : "不会"]看到场外频道消息。"))

/client/verb/listen_looc()
	set name = "Show/Hide LOOC"
	set category = "Preferences.Chat"
	set desc = "切换本地场外聊天显示。"
	prefs.toggles_chat ^= CHAT_LOOC
	prefs.save_preferences()

	to_chat(src, SPAN_BOLDNOTICE("你现在[(prefs.toggles_chat & CHAT_LOOC) ? "会" : "不会"]看到本地场外频道消息。"))

/client/verb/Toggle_Soundscape() //All new ambience should be added here so it works with this verb until someone better at things comes up with a fix that isn't awful
	set name = "Hear/Silence Ambience"
	set category = "Preferences.Sound"
	set desc = "切换环境音效。"
	prefs.toggles_sound ^= SOUND_AMBIENCE
	prefs.save_preferences()
	if(prefs.toggles_sound & SOUND_AMBIENCE)
		to_chat(src,SPAN_BOLDNOTICE( "现在会播放环境音效。"))
		if(soundOutput)
			soundOutput.update_ambience(null, null, TRUE)
	else
		to_chat(src,SPAN_BOLDNOTICE( "现在不会播放环境音效。"))
		src << sound(null, repeat = 0, wait = 0, volume = 0, channel = SOUND_CHANNEL_AMBIENCE)
		src << sound(null, repeat = 0, wait = 0, volume = 0, channel = SOUND_CHANNEL_SOUNDSCAPE)

/client/verb/toggle_roundstart_flash()
	set name = "Toggle Roundstart Flash"
	set category = "Preferences.TaskbarFlashing"
	set desc = "切换回合开始时的任务栏闪烁提示。"

	prefs.toggles_flashing ^= FLASH_ROUNDSTART
	prefs.save_preferences()
	if(prefs.toggles_flashing & FLASH_ROUNDSTART)
		to_chat(src,  SPAN_BOLDNOTICE("回合开始前播放本回合提示时，任务栏图标现在会闪烁。"))
	else
		to_chat(src,  SPAN_BOLDNOTICE("回合开始前播放本回合提示时，任务栏图标现在不会闪烁。"))

/client/verb/toggle_roundend_flash()
	set name = "Toggle Roundend Flash"
	set category = "Preferences.TaskbarFlashing"
	set desc = "切换回合结束时的任务栏闪烁提示。"

	prefs.toggles_flashing ^= FLASH_ROUNDEND
	prefs.save_preferences()
	if(prefs.toggles_flashing & FLASH_ROUNDEND)
		to_chat(src,  SPAN_BOLDNOTICE("回合结束时，任务栏图标现在会闪烁。"))
	else
		to_chat(src, SPAN_BOLDNOTICE( "回合结束时，任务栏图标现在不会闪烁。"))

/client/verb/toggle_corpserevive_flash()
	set name = "Toggle Revival Flash"
	set category = "Preferences.TaskbarFlashing"
	set desc = "切换复活时的任务栏闪烁提示。"

	prefs.toggles_flashing ^= FLASH_CORPSEREVIVE
	prefs.save_preferences()
	if(prefs.toggles_flashing & FLASH_CORPSEREVIVE)
		to_chat(src,  SPAN_BOLDNOTICE("你复活时，任务栏图标现在会闪烁。"))
	else
		to_chat(src, SPAN_BOLDNOTICE( "你复活时，任务栏图标现在不会闪烁。"))

/client/verb/toggle_unnest_flash()
	set name = "Toggle Unnest Flash"
	set category = "Preferences.TaskbarFlashing"
	set desc = "切换脱离异形巢穴、可以重返躯体时的任务栏闪烁提示。"

	prefs.toggles_flashing ^= FLASH_UNNEST
	prefs.save_preferences()
	if(prefs.toggles_flashing & FLASH_UNNEST)
		to_chat(src,  SPAN_BOLDNOTICE("你脱离异形巢穴、可以重返躯体时，任务栏图标现在会闪烁。"))
	else
		to_chat(src, SPAN_BOLDNOTICE( "你脱离异形巢穴、可以重返躯体时，任务栏图标现在不会闪烁。"))

/client/verb/toggle_newlarva_flash()
	set name = "Toggle Larva Unpool Flash"
	set category = "Preferences.TaskbarFlashing"
	set desc = "切换从幼体储备中生成异形幼体时的任务栏闪烁提示。"

	prefs.toggles_flashing ^= FLASH_POOLSPAWN
	prefs.save_preferences()
	if(prefs.toggles_flashing & FLASH_POOLSPAWN)
		to_chat(src,  SPAN_BOLDNOTICE("你作为地底幼体生成时，任务栏图标现在会闪烁。"))
	else
		to_chat(src, SPAN_BOLDNOTICE( "你作为地底幼体生成时，任务栏图标现在不会闪烁。"))


/client/verb/toggle_adminpm_flash()
	set name = "Toggle Admin PM Flash"
	set category = "Preferences.TaskbarFlashing"
	set desc = "切换收到管理员消息时的任务栏闪烁提示。"

	prefs.toggles_flashing ^= FLASH_ADMINPM
	prefs.save_preferences()
	if(prefs.toggles_flashing & FLASH_ADMINPM)
		to_chat(src, SPAN_BOLDNOTICE("收到管理员消息时，任务栏图标现在会闪烁。"))
	else
		to_chat(src, SPAN_BOLDNOTICE("收到管理员消息时，任务栏图标现在不会闪烁。请自行承担漏看消息的后果。"))

//be special
/client/verb/toggle_be_special()
	set name = "Toggle SpecialRole Candidacy"
	set category = "Preferences"
	set desc = "选择事件中愿意候选的特殊角色。"

	var/list/be_special_flags = list(
		"Xenomorph after unrevivable death" = BE_ALIEN_AFTER_DEATH,
		"Agent" = BE_AGENT,
	)
	var/role = localized_input_list(usr, "要切换哪种角色的候选资格？", "选择角色", be_special_flags)
	if(!role)
		return
	var/role_flag = be_special_flags[role]
	prefs.be_special ^= role_flag
	prefs.save_preferences()
	to_chat(src, SPAN_BOLDNOTICE("你现在[(prefs.be_special & role_flag) ? "会" : "不会"]在条件允许时被列为[localized_player_label(role)]事件的候选人。"))

/client/verb/toggle_fullscreen_preference()
	set name = "Toggle Fullscreen Preference"
	set category = "Preferences"
	set desc = "切换游戏窗口使用真正全屏或普通窗口。"

	prefs.toggle_prefs ^= TOGGLE_FULLSCREEN
	prefs.save_preferences()
	update_fullscreen()

/client/verb/toggle_ambient_occlusion()
	set name = "Toggle Ambient Occlusion"
	set category = "Preferences"
	set desc = "切换环境光遮蔽效果。"

	prefs.toggle_prefs ^= TOGGLE_AMBIENT_OCCLUSION
	prefs.save_preferences()
	var/atom/movable/screen/plane_master/game_world/plane_master = locate() in src.screen
	if (!plane_master)
		return
	plane_master.backdrop(src.mob)

/client/verb/toggle_member_publicity()
	set name = "Toggle Membership Publicity"
	set category = "Preferences"
	set desc = "切换是否向其他玩家显示你的 BYOND 会员身份（场外聊天标志）。"

	prefs.toggle_prefs ^= TOGGLE_MEMBER_PUBLIC
	prefs.save_preferences()
	to_chat(src, SPAN_BOLDNOTICE("其他玩家现在[(prefs.toggle_prefs & TOGGLE_MEMBER_PUBLIC) ? "可以" : "无法"]看到你的 BYOND 会员身份。"))

/client/verb/toggle_ooc_country_flag()
	set name = "Toggle Country Flag"
	set category = "Preferences"
	set desc = "切换是否在场外聊天中显示国旗，国家根据连接 IP 所属地确定。"

	if(!(CONFIG_GET(flag/ooc_country_flags)))
		to_chat(src, SPAN_WARNING("当前服务器配置已禁用场外聊天中的国旗显示！"))
		return

	prefs.toggle_prefs ^= TOGGLE_OOC_FLAG
	prefs.save_preferences()
	to_chat(src, SPAN_BOLDNOTICE("你的国旗现在[(prefs.toggle_prefs & TOGGLE_OOC_FLAG) ? "会" : "不会"]显示在场外聊天中的名字前方。"))

/client/verb/toggle_prefs() // Toggle whether anything will happen when you click yourself in non-help intent
	set name = "Toggle Preferences"
	set category = "Preferences"
	set desc = "切换各项可开关的偏好设置。"

	var/list/pref_buttons = list(
		"<a href='byond://?src=\ref[src];action=proccall;procpath=/client/proc/toggle_ignore_self'>切换自伤功能</a><br>",
		"<a href='byond://?src=\ref[src];action=proccall;procpath=/client/proc/toggle_help_intent_safety'>切换帮助意图安全保护</a><br>",
		"<a href='byond://?src=\ref[src];action=proccall;procpath=/client/proc/toggle_auto_eject'>切换枪械自动退匣</a><br>",
		"<a href='byond://?src=\ref[src];action=proccall;procpath=/client/proc/toggle_auto_eject_to_hand'>切换自动退匣到手中</a><br>",
		"<a href='byond://?src=\ref[src];action=proccall;procpath=/client/proc/toggle_ammo_display_type'>切换半自动弹药计数器</a><br>",
		"<a href='byond://?src=\ref[src];action=proccall;procpath=/client/proc/toggle_eject_to_hand'>切换卸弹时将弹匣退至手中</a><br>",
		"<a href='byond://?src=\ref[src];action=proccall;procpath=/client/proc/toggle_automatic_punctuation'>切换自动补全标点</a><br>",
		"<a href='byond://?src=\ref[src];action=proccall;procpath=/client/proc/toggle_ability_deactivation'>切换再次选择以关闭能力</a><br>",
		"<a href='byond://?src=\ref[src];action=proccall;procpath=/client/proc/toggle_clickdrag_override'>切换战斗拖拽点击覆盖</a><br>",
		"<a href='byond://?src=\ref[src];action=proccall;procpath=/client/proc/toggle_pb_override'>切换战斗贴身射击覆盖</a><br>",
		"<a href='byond://?src=\ref[src];action=proccall;procpath=/client/proc/toggle_dualwield'>切换双持交替射击</a><br>",
		"<a href='byond://?src=\ref[src];action=proccall;procpath=/client/proc/toggle_middle_mouse_swap_hands'>切换鼠标中键换手</a><br>",
		"<a href='byond://?src=\ref[src];action=proccall;procpath=/client/proc/toggle_vend_item_to_hand'>切换供应机直接出货到手中</a><br>",
		"<a href='byond://?src=\ref[src];action=proccall;procpath=/client/proc/switch_item_animations'>切换物品动画</a><br>",
		"<a href='byond://?src=\ref[src];action=proccall;procpath=/client/proc/toggle_admin_sound_types'>选择管理员音效类型</a><br>",
		"<a href='byond://?src=\ref[src];action=proccall;procpath=/client/proc/set_eye_blur_type'>设置视线模糊效果</a><br>",
		"<a href='byond://?src=\ref[src];action=proccall;procpath=/client/proc/set_flash_type'>设置闪光遮罩效果</a><br>",
		"<a href='byond://?src=\ref[src];action=proccall;procpath=/client/proc/set_crit_type'>设置濒危遮罩效果</a><br>",
	)

	var/dat = ""
	for (var/pref_button in pref_buttons)
		dat += "[pref_button]\n"

	var/height = 50+24*length(pref_buttons)

	show_browser(src, dat, "偏好开关设置", "togglepreferences", width = 475, height = height)

/client/proc/toggle_ignore_self() // Toggle whether anything will happen when you click yourself in non-help intent
	prefs.toggle_prefs ^= TOGGLE_IGNORE_SELF
	if(prefs.toggle_prefs & TOGGLE_IGNORE_SELF)
		to_chat(src,SPAN_BOLDNOTICE( "现在以非帮助意图点击自己不会产生任何效果。"))
	else
		to_chat(src, SPAN_BOLDNOTICE("现在以非帮助意图点击自己会再次造成伤害。"))
	prefs.save_preferences()

/client/proc/toggle_help_intent_safety() // Toggle whether anything will happen when you click on someone with help intent
	prefs.toggle_prefs ^= TOGGLE_HELP_INTENT_SAFETY
	if(prefs.toggle_prefs & TOGGLE_HELP_INTENT_SAFETY)
		to_chat(src, SPAN_BOLDNOTICE("帮助意图现在完全不会造成伤害。"))
	else
		to_chat(src, SPAN_BOLDNOTICE("帮助意图现在可以再次执行有害动作。"))
	prefs.save_preferences()

/client/proc/toggle_auto_eject() // Toggle whether guns with auto-ejectors will automatically eject magazines
	prefs.toggle_prefs ^= TOGGLE_AUTO_EJECT_MAGAZINE_OFF
	if(prefs.toggle_prefs & TOGGLE_AUTO_EJECT_MAGAZINE_OFF)
		var/msg = "带自动退匣机构的枪械现在不会自动退出弹匣。"
		if (prefs.toggle_prefs & TOGGLE_AUTO_EJECT_MAGAZINE_TO_HAND)
			prefs.toggle_prefs ^= TOGGLE_AUTO_EJECT_MAGAZINE_TO_HAND
			msg += "自动退匣到手中的偏好也已关闭。"
		to_chat(src, msg)
	else
		to_chat(src, SPAN_BOLDNOTICE("带自动退匣机构的枪械现在会自动退出弹匣。"))
	prefs.save_preferences()


/client/proc/toggle_ammo_display_type()
	prefs.toggle_prefs ^= TOGGLE_AMMO_DISPLAY_TYPE
	to_chat(usr, SPAN_NOTICE("半自动模式的枪械现在会[SPAN_BOLD(prefs.toggle_prefs & TOGGLE_AMMO_DISPLAY_TYPE ? "每射击五发子弹，以及弹匣余弹少于15发时" : "每射击一发子弹时")]显示弹药数量。"))
	prefs.save_preferences()

/client/proc/toggle_auto_eject_to_hand() // Toggle whether guns with auto-ejectors will eject their magazines to your offhand
	prefs.toggle_prefs ^= TOGGLE_AUTO_EJECT_MAGAZINE_TO_HAND
	if(prefs.toggle_prefs & TOGGLE_AUTO_EJECT_MAGAZINE_TO_HAND)
		var/msg = "带自动退匣机构的枪械现在会把弹匣退至副手。"
		if (prefs.toggle_prefs & TOGGLE_AUTO_EJECT_MAGAZINE_OFF)
			prefs.toggle_prefs ^= TOGGLE_AUTO_EJECT_MAGAZINE_OFF
			msg += "禁用自动退匣的偏好也已关闭。"
		to_chat(src, SPAN_BOLDNOTICE(msg))
	else
		to_chat(src, SPAN_BOLDNOTICE("带自动退匣机构的枪械现在不会把弹匣退至副手。"))
	prefs.save_preferences()

/client/proc/toggle_eject_to_hand() // Toggle whether unloading a magazine with the 'Unload Weapon' verb will put the magazine in your offhand
	prefs.toggle_prefs ^= TOGGLE_EJECT_MAGAZINE_TO_HAND
	if(prefs.toggle_prefs & TOGGLE_EJECT_MAGAZINE_TO_HAND)
		to_chat(src, SPAN_BOLDNOTICE("“卸下武器弹药（Unload Weapon）”命令现在会把弹匣放入副手。"))
	else
		to_chat(src, SPAN_BOLDNOTICE("“卸下武器弹药（Unload Weapon）”命令现在不会把弹匣放入副手。"))
	prefs.save_preferences()

/client/proc/toggle_automatic_punctuation() // Toggle whether your sentences are automatically punctuated
	prefs.toggle_prefs ^= TOGGLE_AUTOMATIC_PUNCTUATION
	if(prefs.toggle_prefs & TOGGLE_AUTOMATIC_PUNCTUATION)
		to_chat(src, SPAN_BOLDNOTICE("你的消息缺少标点时，现在会自动补全标点。"))
	else
		to_chat(src, SPAN_BOLDNOTICE("你的消息缺少标点时，现在不会自动补全标点。"))
	prefs.save_preferences()

/client/proc/toggle_ability_deactivation() // Toggle whether the current ability can be deactivated when re-selected
	prefs.toggle_prefs ^= TOGGLE_ABILITY_DEACTIVATION_OFF
	if (prefs.toggle_prefs & TOGGLE_ABILITY_DEACTIVATION_OFF)
		to_chat(src, SPAN_NOTICE("再次选择当前能力时，现在不会将其关闭。"))
	else
		to_chat(src, SPAN_NOTICE("再次选择当前能力时，现在可以将其关闭。"))
	prefs.save_preferences()

/client/proc/toggle_clickdrag_override() //Toggle whether mousedown clicks immediately when on disarm or harm intent to prevent click-dragging from 'eating' attacks.
	prefs.toggle_prefs ^= TOGGLE_COMBAT_CLICKDRAG_OVERRIDE
	if(prefs.toggle_prefs & TOGGLE_COMBAT_CLICKDRAG_OVERRIDE)
		to_chat(src,SPAN_BOLDNOTICE( "现在以伤害或缴械意图按下鼠标时，会立即点击目标，即使之后按住不放也一样；拖拽自己、友军或库存中的物品时除外。"))
	else
		to_chat(src,SPAN_BOLDNOTICE( "现在拖拽时不会同时触发点击。"))
	prefs.save_preferences()

/client/proc/toggle_pb_override() //Toggle gun attacks on an adjacent target go to autofire or PB.
	prefs.toggle_prefs ^= TOGGLE_COMBAT_POINTBLANK_OVERRIDE
	if(prefs.toggle_prefs & TOGGLE_COMBAT_POINTBLANK_OVERRIDE)
		to_chat(src,SPAN_BOLDNOTICE( "现在以伤害意图持枪点击身旁目标的图像时，会使用自动射击；缴械意图仍使用贴身射击。"))
	else
		to_chat(src,SPAN_BOLDNOTICE( "现在点击身旁目标的图像时，会使用贴身射击。"))
	prefs.save_preferences()

///Toggle whether dual-wielding fires both guns at once or swaps between them.
/client/proc/toggle_dualwield()
	if(prefs.dual_wield_pref < DUAL_WIELD_NONE)
		prefs.dual_wield_pref++
	else
		prefs.dual_wield_pref = DUAL_WIELD_FIRE

	switch(prefs.dual_wield_pref)
		if(DUAL_WIELD_FIRE)
			to_chat(src, SPAN_BOLDNOTICE("双持时现在会同时发射两把枪。"))
		if(DUAL_WIELD_SWAP)
			to_chat(src, SPAN_BOLDNOTICE("双持时现在会交替使用两把枪，前提是另一把枪有弹药。"))
		if(DUAL_WIELD_NONE)
			to_chat(src, SPAN_BOLDNOTICE("双持现在不会影响射击方式。"))

	prefs.save_preferences()

/client/proc/toggle_middle_mouse_swap_hands() //Toggle whether middle click swaps your hands
	prefs.toggle_prefs ^= TOGGLE_MIDDLE_MOUSE_SWAP_HANDS
	to_chat(src, SPAN_BOLDNOTICE("鼠标中键现在[(prefs.toggle_prefs & TOGGLE_MIDDLE_MOUSE_SWAP_HANDS) ? "会" : "不会"]切换双手。"))
	prefs.save_preferences()

/client/proc/toggle_vend_item_to_hand() //Toggle whether vendors automatically vend to your hands
	prefs.toggle_prefs ^= TOGGLE_VEND_ITEM_TO_HAND
	if(prefs.toggle_prefs & TOGGLE_VEND_ITEM_TO_HAND)
		to_chat(src, SPAN_BOLDNOTICE("大多数供应机现在会直接把物品送到你手中。"))
	else
		to_chat(src, SPAN_BOLDNOTICE("供应机现在不会把物品送到你手中。"))
	prefs.save_preferences()

/client/proc/switch_item_animations() //Switches tg-style item animations on, not-on-same-tile, and off
	switch(prefs.item_animation_pref_level)
		if(SHOW_ITEM_ANIMATIONS_NONE)
			prefs.item_animation_pref_level = SHOW_ITEM_ANIMATIONS_HALF
			to_chat(src, SPAN_BOLDNOTICE("现在显示所有物品动画，但不显示在物品自身所在格内发生的动画。"))
			prefs.save_preferences()
			return "On"

		if(SHOW_ITEM_ANIMATIONS_HALF)
			prefs.item_animation_pref_level = SHOW_ITEM_ANIMATIONS_ALL
			to_chat(src, SPAN_BOLDNOTICE("现在显示所有物品动画。"))
			prefs.save_preferences()
			return "Not Same Tile"

		if(SHOW_ITEM_ANIMATIONS_ALL)
			prefs.item_animation_pref_level = SHOW_ITEM_ANIMATIONS_NONE
			to_chat(src, SPAN_BOLDNOTICE("现在不再显示物品动画。"))
			prefs.save_preferences()
			return "Off"

/client/proc/toggle_admin_sound_types()
	//Entirely for code readability.
	var/meme_toggle = prefs.toggles_sound & SOUND_ADMIN_MEME ? TRUE : FALSE
	var/atmospheric_toggle = prefs.toggles_sound & SOUND_ADMIN_ATMOSPHERIC ? TRUE : FALSE
	var/result = tgui_alert(src, "要切换哪类音效？趣味音效当前[meme_toggle ? "已启用" : "已禁用"]，氛围音效当前[atmospheric_toggle ? "已启用" : "已禁用"]。", "切换 MIDI／网络音效类型", list("趣味", "氛围"))
	if(result == "趣味")
		prefs.toggles_sound ^= SOUND_ADMIN_MEME
		//Update the variables so it doesn't output the outdated toggle.
		meme_toggle = prefs.toggles_sound & SOUND_ADMIN_MEME ? TRUE : FALSE
		to_chat(src, SPAN_NOTICE("现在[meme_toggle ? "会" : "不会"]播放管理员的趣味音效。"))
	if(result == "氛围")
		prefs.toggles_sound ^= SOUND_ADMIN_ATMOSPHERIC
		//Ditto.
		atmospheric_toggle = prefs.toggles_sound & SOUND_ADMIN_ATMOSPHERIC ? TRUE : FALSE
		to_chat(src, SPAN_NOTICE("现在[atmospheric_toggle ? "会" : "不会"]播放管理员的氛围音效。"))

/client/proc/receive_random_tip()
	var/picked_type = preference_input_list(mob, "想阅读哪类提示？", "提示类型", list("Marine", "Meta")) //no memetips for them joker imp
	var/message
	var/static/list/types_to_pick = list(
		"Marine" = "strings/pvetips.txt"
	)
	var/list/tip_list = file2list(types_to_pick[picked_type])
	if(length(types_to_pick[picked_type]))
		message = SAFEPICK(tip_list)
	else
		CRASH("receive_random_tip() failed: empty list")

	if(message)
		to_chat(src, SPAN_PURPLE("<b>随机提示：</b>[html_encode(message)]"))
		return TRUE
	else
		CRASH("receive_random_tip() failed: null message")

/// Toggle in character preferences and toggle preferences to configure what kind of blur overlay is used in game; Either blurry, impaired, or legacy.
/client/proc/set_eye_blur_type()
	var/result = tgui_alert(src, "选择视线模糊效果：", "视线模糊效果", list("模糊", "视野受限", "旧版"))
	if(result == "模糊")
		prefs.pain_overlay_pref_level = PAIN_OVERLAY_BLURRY
		to_chat(src, SPAN_NOTICE("现在使用直接模糊画面的效果。"))
	if(result == "视野受限")
		prefs.pain_overlay_pref_level = PAIN_OVERLAY_IMPAIR
		to_chat(src, SPAN_NOTICE("视线模糊时现在使用限制视野的效果。"))
	if(result == "旧版")
		prefs.pain_overlay_pref_level = PAIN_OVERLAY_LEGACY
		to_chat(src, SPAN_NOTICE("现在使用旧版视线模糊效果。不推荐使用此选项！"))
	prefs.save_preferences()

/// Toggle in character preferences and toggle preferences to configure what kind of flash overlay is used in game; Either white or black.
/client/proc/set_flash_type()
	var/result = tgui_alert(src, "选择闪光遮罩效果：", "闪光遮罩效果", list("白色", "深色"))
	if(result == "白色")
		prefs.flash_overlay_pref = FLASH_OVERLAY_WHITE
		to_chat(src, SPAN_NOTICE("被闪光致盲时，现在会显示白色画面。"))
	else if(result == "深色")
		prefs.flash_overlay_pref = FLASH_OVERLAY_DARK
		to_chat(src, SPAN_NOTICE("被闪光致盲时，现在会显示深色画面。"))
	prefs.save_preferences()

/// Toggle in character preferences and toggle preferences to configure what kind of crit overlay is used in game; Either white or grey.
/client/proc/set_crit_type()
	var/result = tgui_alert(src, "选择濒危遮罩效果：", "濒危遮罩效果", list("白色", "深色"))
	if(result == "白色")
		prefs.crit_overlay_pref = CRIT_OVERLAY_WHITE
		to_chat(src, SPAN_NOTICE("处于濒危状态时，现在会显示白色画面。"))
	else if(result == "深色")
		prefs.crit_overlay_pref = CRIT_OVERLAY_DARK
		to_chat(src, SPAN_NOTICE("处于濒危状态时，现在会显示深色画面。"))
	prefs.save_preferences()

/client/verb/toggle_tgui_say()
	set name = "Toggle Say Input Style"
	set category = "Preferences.UI"
	set desc = "切换发言输入界面的样式。"

	var/result = localized_tgui_alert(src, "要使用哪种输入样式？", "输入样式", list("Modern", "Legacy"))
	if(!result)
		return

	if(result == "Legacy")
		prefs.tgui_say = FALSE
		to_chat(src, SPAN_NOTICE("现在使用旧版界面。"))
	else
		prefs.tgui_say = TRUE
		to_chat(src, SPAN_NOTICE("现在使用新版界面。"))
	prefs.save_preferences()
	update_special_keybinds()

/client/verb/toggle_tgui_say_light_mode()
	set name = "Toggle Say Input Color"
	set category = "Preferences.UI"
	set desc = "切换发言输入界面的颜色。"

	var/result = localized_tgui_alert(src, "要使用哪种输入配色？", "输入配色", list("Darkmode", "Lightmode"))
	if(!result)
		return
	if(result == "Lightmode")
		prefs.tgui_say_light_mode = TRUE
		to_chat(src, SPAN_NOTICE("现在使用浅色发言输入界面。"))
	else
		prefs.tgui_say_light_mode = FALSE
		to_chat(src, SPAN_NOTICE("现在使用深色发言输入界面。"))
	tgui_say?.load()
	prefs.save_preferences()

/client/verb/toggle_custom_cursors()
	set name = "Toggle Custom Cursors"
	set category = "Preferences.UI"
	set desc = "切换自定义鼠标指针。"

	do_toggle_custom_cursors()

/client/proc/do_toggle_custom_cursors(mob/user)
	var/result = tgui_alert(user, "是否启用自定义鼠标指针？", "自定义鼠标指针", list("是", "否"))
	if(!result)
		return
	if(result == "是")
		prefs.custom_cursors = TRUE
		to_chat(src, SPAN_NOTICE("已启用自定义鼠标指针。"))
	else
		prefs.custom_cursors = FALSE
		to_chat(src, SPAN_NOTICE("已禁用自定义鼠标指针。"))
		mouse_pointer_icon = initial(mouse_pointer_icon)

	prefs.save_preferences()

/client/verb/toggle_auto_viewport_fit()
	set name = "Toggle Auto Viewport Fit"
	set category = "Preferences.UI"

	prefs.auto_fit_viewport = !prefs.auto_fit_viewport
	if(prefs.auto_fit_viewport)
		to_chat(src, SPAN_NOTICE("现在会自动适配视口大小。"))
		fit_viewport()
	else
		to_chat(src, SPAN_NOTICE("现在不会自动适配视口大小。"))
	prefs.save_preferences()

/client/verb/toggle_adaptive_zooming()
	set name = "Toggle Adaptive Zooming"
	set category = "Preferences.UI"

	switch(prefs.adaptive_zoom)
		if(0)
			prefs.adaptive_zoom = 1
			to_chat(src, SPAN_BOLDNOTICE("已启用自适应缩放，在 1 倍与 2 倍之间切换。推荐 1080p 显示器使用此设置。"))
			adaptive_zoom()
		if(1)
			prefs.adaptive_zoom = 2
			to_chat(src, SPAN_BOLDNOTICE("已启用自适应缩放，在 2 倍与 4 倍之间切换。"))
			adaptive_zoom()
		if(2)
			prefs.adaptive_zoom = 0
			to_chat(src, SPAN_BOLDNOTICE("已禁用自适应缩放。"))
			adaptive_zoom()
	prefs.save_preferences()

//------------ GHOST PREFERENCES ---------------------------------

/client/proc/show_ghost_preferences() // Shows ghost-related preferences.
	set name = "Show Ghost Prefs"
	set category = "Preferences"
	set desc = "显示幽灵相关偏好设置。"

	add_verb(src, GLOB.ghost_prefs_verbs)
	remove_verb(src, /client/proc/show_ghost_preferences)

/client/proc/hide_ghost_preferences() // Hides ghost-related preferences.
	set name = "Hide Ghost Prefs"
	set category = "Preferences"
	set desc = "隐藏幽灵相关偏好设置。"

	remove_verb(src, GLOB.ghost_prefs_verbs)
	add_verb(src, /client/proc/show_ghost_preferences)

/client/proc/toggle_ghost_hivemind()
	set name = "Toggle GhostHivemind"
	set category = "Preferences.Ghost"
	set desc = "切换异形虫巢意志全部聊天的显示。"
	prefs.toggles_chat ^= CHAT_GHOSTHIVEMIND
	to_chat(src,SPAN_BOLDNOTICE( "作为幽灵，你现在[(prefs.toggles_chat & CHAT_GHOSTHIVEMIND) ? "会看到异形虫巢意志聊天" : "不会看到异形虫巢意志聊天"]。"))
	prefs.save_preferences()

/client/proc/deadchat() // Deadchat toggle is usable by anyone.
	set name = "Toggle Deadchat"
	set category = "Preferences.Ghost"
	set desc ="切换亡者聊天显示。"
	prefs.toggles_chat ^= CHAT_DEAD
	prefs.save_preferences()

	if(src.admin_holder && (admin_holder.rights & R_MOD))
		to_chat(src,SPAN_DANGER( "You will [(prefs.toggles_chat & CHAT_DEAD) ? "now" : "no longer"] see deadchat."))
	else
		to_chat(src,SPAN_BOLDNOTICE( "作为幽灵，你现在[(prefs.toggles_chat & CHAT_DEAD) ? "会" : "不会"]看到亡者聊天。"))

/client/proc/toggle_ghost_ears()
	set name = "Toggle GhostEars"
	set category = "Preferences.Ghost"
	set desc = "切换显示所有生物的发言，或仅显示附近生物的发言。"
	prefs.toggles_chat ^= CHAT_GHOSTEARS
	to_chat(src, SPAN_BOLDNOTICE("作为幽灵，你现在[(prefs.toggles_chat & CHAT_GHOSTEARS) ? "会看到世界中的所有发言" : "只会看到附近生物的发言"]。"))
	prefs.save_preferences()

/client/proc/toggle_ghost_sight()
	set name = "Toggle GhostSight"
	set category = "Preferences.Ghost"
	set desc = "切换显示所有生物的表情动作，或仅显示附近生物的表情动作。"
	prefs.toggles_chat ^= CHAT_GHOSTSIGHT
	to_chat(src, SPAN_BOLDNOTICE("作为幽灵，你现在[(prefs.toggles_chat & CHAT_GHOSTSIGHT) ? "会看到世界中的所有表情动作" : "只会看到附近生物的表情动作"]。"))
	prefs.save_preferences()

/client/proc/toggle_ghost_radio()
	set name = "Toggle GhostRadio"
	set category = "Preferences.Ghost"
	set desc = "切换收听全部无线电聊天，或仅收听附近扬声器的声音。"
	prefs.toggles_chat ^= CHAT_GHOSTRADIO
	to_chat(src,SPAN_BOLDNOTICE( "作为幽灵，你现在[(prefs.toggles_chat & CHAT_GHOSTRADIO) ? "会听到世界中的所有无线电聊天" : "只会听到附近扬声器的声音"]。"))
	prefs.save_preferences()

/client/proc/toggle_ghost_spyradio()
	set name = "Toggle GhostSpyRadio"
	set category = "Preferences.Ghost"
	set desc = "切换是否收听窃听器。"
	prefs.toggles_chat ^= CHAT_LISTENINGBUG
	to_chat(src,SPAN_BOLDNOTICE( "作为幽灵，你现在[(prefs.toggles_chat & CHAT_LISTENINGBUG) ? "会" : "不会"]听到窃听器的声音。"))
	prefs.save_preferences()

/client/proc/toggle_ghost_hud()
	set name = "Toggle Ghost HUDs"
	set category = "Preferences.Ghost"
	set desc = "选择成为观察者时默认启用的抬头显示。"

	var/hud_choice = localized_input_list(usr, "选择要切换的抬头显示", "抬头显示偏好", list("Medical HUD", "Security HUD", "Squad HUD", "Xeno Status HUD", "Faction US Army HUD", "Faction USASF HUD", "Faction CMB HUD", "Faction UPP HUD", "Faction Wey-Yu HUD", "Faction TWE HUD", "Faction CLF HUD"))
	if(!hud_choice)
		return
	prefs.observer_huds[hud_choice] = !prefs.observer_huds[hud_choice]
	prefs.save_preferences()

	to_chat(src, SPAN_BOLDNOTICE("你已将[localized_player_label(hud_choice)]设为观察者默认[prefs.observer_huds[hud_choice] ? "开启" : "关闭"]。"))

	if(!isobserver(usr))
		return
	var/mob/dead/observer/observer_user = usr
	var/datum/mob_hud/H
	switch(hud_choice)
		if("Medical HUD")
			H = GLOB.huds[MOB_HUD_MEDICAL_OBSERVER]
		if("Security HUD")
			H = GLOB.huds[MOB_HUD_SECURITY_ADVANCED]
		if("Squad HUD")
			H = GLOB.huds[MOB_HUD_FACTION_OBSERVER]
		if("Xeno Status HUD")
			H = GLOB.huds[MOB_HUD_XENO_STATUS]
		if("Faction US Army HUD")
			H = GLOB.huds[MOB_HUD_FACTION_ARMY]
		if("Faction USASF HUD")
			H = GLOB.huds[MOB_HUD_FACTION_NAVY]
		if("Faction CMB HUD")
			H = GLOB.huds[MOB_HUD_FACTION_MARSHAL]
		if("Faction UPP HUD")
			H = GLOB.huds[MOB_HUD_FACTION_UPP]
		if("Faction Wey-Yu HUD")
			H = GLOB.huds[MOB_HUD_FACTION_WY]
		if("Faction TWE HUD")
			H = GLOB.huds[MOB_HUD_FACTION_TWE]
		if("Faction CLF HUD")
			H = GLOB.huds[MOB_HUD_FACTION_CLF]
		if("Faction UACG HUD")
			H = GLOB.huds[MOB_HUD_FACTION_UACG]

	observer_user.HUD_toggled[hud_choice] = prefs.observer_huds[hud_choice]
	if(observer_user.HUD_toggled[hud_choice])
		H.add_hud_to(observer_user, observer_user)
	else
		H.remove_hud_from(observer_user, observer_user)

/client/proc/toggle_ghost_health_scan()
	set name = "Toggle Health Scan"
	set category = "Preferences.Ghost"

	prefs.toggles_ghost ^= GHOST_HEALTH_SCAN
	prefs.save_preferences()
	to_chat(usr, "作为幽灵，你现在[prefs.toggles_ghost & GHOST_HEALTH_SCAN ? "可以" : "无法"]通过右键菜单扫描活物的健康状况。")
	if(isobserver(usr))
		if(prefs.toggles_ghost & GHOST_HEALTH_SCAN)
			add_verb(usr, /mob/dead/observer/proc/scan_health)
		else
			remove_verb(usr, /mob/dead/observer/proc/scan_health)

GLOBAL_LIST_INIT(ghost_orbits, list(GHOST_ORBIT_CIRCLE, GHOST_ORBIT_TRIANGLE, GHOST_ORBIT_SQUARE, GHOST_ORBIT_HEXAGON, GHOST_ORBIT_PENTAGON))

/client/proc/pick_ghost_orbit()
	set name = "Pick Ghost Orbit Shape"
	set category = "Preferences.Ghost"
	set desc = "选择幽灵绕生物环行时的轨迹形状。"
	var/new_orbit = localized_input_list(src, "选择幽灵环绕轨迹：", "幽灵自定义", GLOB.ghost_orbits)
	if(!new_orbit)
		return

	prefs.ghost_orbit = new_orbit
	prefs.save_preferences()

	to_chat(src, SPAN_NOTICE("作为幽灵，你现在将沿[localized_player_label(new_orbit)]轨迹环绕。"))

	if(!isobserver(mob))
		return

	var/mob/dead/observer/O = mob
	O.ghost_orbit = new_orbit

//------------ COMBAT CHAT MESSAGES PREFERENCES ---------------------

//Made all chat combat-related logs added by Neth and several others to be hidden by default and shown when clicked respected verb. Reason: too cluttered preferences.
/client/proc/show_combat_chat_preferences() // Shows additional chat logs preferences.
	set category = "Preferences"
	set name = "Show Combat Chat Prefs"
	set desc = "显示战斗及幽灵消息的更多聊天偏好设置。"

	add_verb(src, GLOB.combat_chat_prefs_verbs)
	remove_verb(src, /client/proc/show_combat_chat_preferences)

/client/proc/hide_combat_chat_preferences() // Hides additional chat logs preferences.
	set category = "Preferences"
	set name = "Hide Combat Chat Prefs"
	set desc = "隐藏战斗及幽灵消息的更多聊天偏好设置。"

	remove_verb(src, GLOB.combat_chat_prefs_verbs)
	add_verb(src, /client/proc/show_combat_chat_preferences)

/client/proc/toggle_chat_shooting()
	set name = "Toggle Firing Messages"
	set category = "Preferences.Combat"
	set desc = "切换武器开火消息。"
	prefs.chat_display_preferences ^= CHAT_TYPE_WEAPON_USE
	to_chat(src,SPAN_BOLDNOTICE( "你现在[(prefs.chat_display_preferences & CHAT_TYPE_WEAPON_USE) ? "会看到武器开火消息" : "不会看到武器开火消息"]。"))
	prefs.save_preferences()

/client/proc/toggle_chat_xeno_attack()
	set name = "Toggle Xeno Attack Messages"
	set category = "Preferences.Combat"
	set desc = "切换异形攻击消息。"
	prefs.chat_display_preferences ^= CHAT_TYPE_XENO_COMBAT
	to_chat(src, SPAN_BOLDNOTICE("你现在[(prefs.chat_display_preferences & CHAT_TYPE_XENO_COMBAT) ? "会看到异形攻击消息" : "不会看到异形攻击消息"]。"))
	prefs.save_preferences()

/client/proc/toggle_chat_xeno_armor()
	set name = "Toggle Xeno Armor Messages"
	set category = "Preferences.Combat"
	set desc = "切换异形护甲消息。"
	prefs.chat_display_preferences ^= CHAT_TYPE_ARMOR_DAMAGE
	to_chat(src, SPAN_BOLDNOTICE("你现在[(prefs.chat_display_preferences & CHAT_TYPE_ARMOR_DAMAGE) ? "会看到异形护甲消息" : "不会看到异形护甲消息"]。"))
	prefs.save_preferences()

/client/proc/toggle_chat_someone_hit()
	set name = "Toggle Someone Hit Messages"
	set category = "Preferences.Combat"
	set desc = "切换他人被击中的消息。"
	prefs.chat_display_preferences ^= CHAT_TYPE_TAKING_HIT
	to_chat(src,SPAN_BOLDNOTICE( "你现在[(prefs.chat_display_preferences & CHAT_TYPE_TAKING_HIT) ? "会看到他人被击中消息" : "不会看到他人被击中消息"]。"))
	prefs.save_preferences()

/client/proc/toggle_chat_you_hit()
	set name = "Toggle You Hit Messages"
	set category = "Preferences.Combat"
	set desc = "切换你被击中的消息。"
	prefs.chat_display_preferences ^= CHAT_TYPE_BEING_HIT
	to_chat(src,SPAN_BOLDNOTICE( "你现在[(prefs.chat_display_preferences & CHAT_TYPE_BEING_HIT) ? "会看到自己被击中消息" : "不会看到自己被击中消息"]。"))
	prefs.save_preferences()

/client/proc/toggle_chat_you_pain()
	set name = "Toggle Pain Messages"
	set category = "Preferences.Combat"
	set desc = "切换你感到疼痛的消息。"
	prefs.chat_display_preferences ^= CHAT_TYPE_PAIN
	to_chat(src, SPAN_BOLDNOTICE("你现在[(prefs.chat_display_preferences & CHAT_TYPE_PAIN) ? "会看到自己疼痛消息" : "不会看到自己疼痛消息"]。"))
	prefs.save_preferences()

GLOBAL_LIST_INIT(combat_chat_prefs_verbs, list(
	/client/proc/toggle_chat_shooting,
	/client/proc/toggle_chat_xeno_attack,
	/client/proc/toggle_chat_xeno_armor,
	/client/proc/toggle_chat_someone_hit,
	/client/proc/toggle_chat_you_hit,
	/client/proc/toggle_chat_you_pain,
	/client/proc/hide_combat_chat_preferences))

GLOBAL_LIST_INIT(ghost_prefs_verbs, list(
	/client/proc/toggle_ghost_ears,
	/client/proc/toggle_ghost_sight,
	/client/proc/toggle_ghost_radio,
	/client/proc/toggle_ghost_spyradio,
	/client/proc/toggle_ghost_hivemind,
	/client/proc/deadchat,
	/client/proc/toggle_ghost_hud,
	/client/proc/toggle_ghost_health_scan,
	/client/proc/pick_ghost_orbit,
	/client/proc/hide_ghost_preferences))
