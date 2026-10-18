//Please use mob or src (not usr) in these procs. This way they can be called in the same fashion as procs.
/client/verb/wiki()
	set name = "wiki"
	set desc = "Visit the wiki."
	set hidden = TRUE
	if( CONFIG_GET(string/wikiurl_home_page) || CONFIG_GET(string/wikiurl) )
		if(tgui_alert(src, "这将在浏览器中打开维基。确定继续吗？", "确认", list("Yes", "No")) != "Yes")
			return
		src << link(CONFIG_GET(string/wikiurl_home_page) || CONFIG_GET(string/wikiurl))
	else
		to_chat(src, SPAN_DANGER("服务器配置中尚未设置维基网址。"))
	return

/client/verb/worksheet()
	set name = "Worksheet"
	set desc = "Visit the worksheet."
	set hidden = TRUE
	if( CONFIG_GET(string/forumurl) )
		if(tgui_alert(src, "这将在浏览器中打开工作表。确定继续吗？", "确认", list("Yes", "No")) != "Yes")
			return
		src << link(CONFIG_GET(string/forumurl))
	else
		to_chat(src, SPAN_DANGER("服务器配置中尚未设置论坛网址。"))
	return

/client/verb/changelog()
	set name = "Changelog"
	set category = "OOC"
	if(!GLOB.changelog_tgui)
		GLOB.changelog_tgui = new /datum/changelog()

	GLOB.changelog_tgui.tgui_interact(mob)
	if(prefs.lastchangelog != GLOB.changelog_hash)
		prefs.lastchangelog = GLOB.changelog_hash
		prefs.save_preferences()
		winset(src, "infowindow.changelog", "font-style=;")

/client/verb/discord()
	set name = "Discord"
	set desc = "Join our Discord! Meet and talk with other players in the server."
	set hidden = TRUE

	if(tgui_alert(src, "这将在浏览器中打开 Discord。确定继续吗？", "确认", list("Yes", "No")) != "Yes")
		return

	src << link("[CONFIG_GET(string/discordurl)]")
	return

/client/verb/github()
	set name = "Github"
	set desc = "View our github!."
	set hidden = TRUE

	if(tgui_alert(src, "这将在浏览器中打开 GitHub。确定继续吗？", "确认", list("Yes", "No")) != "Yes")
		return

	src << link(CONFIG_GET(string/githuburl))
	return

/client/verb/set_fps()
	set name = "Set FPS"
	set desc = "Set client FPS. 20 is the default"
	set category = "Preferences"
	var/fps = tgui_input_number(usr,"新的帧率值。0表示与服务器同步，数值越高越容易出现不同步。","设置帧率", 0, MAX_FPS, MIN_FPS)
	if(world.byond_version >= 511 && byond_version >= 511 && fps >= MIN_FPS && fps <= MAX_FPS)
		vars["fps"] = fps
		prefs.fps = fps
		prefs.save_preferences()
	return

/client/verb/edit_hotkeys()
	set name = "Edit Hotkeys"
	set category = "Preferences"
	prefs.macros.tgui_interact(usr)

/client/var/client_keysend_amount = 0
/client/var/next_keysend_reset = 0
/client/var/next_keysend_trip_reset = 0
/client/var/keysend_tripped = FALSE
