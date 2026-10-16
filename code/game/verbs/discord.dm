/client/verb/discord_connect()
	set name = "Discord 认证"
	set category = "OOC"

	var/total_playtime = get_total_xeno_playtime(skip_cache = TRUE) + get_total_human_playtime(skip_cache = TRUE)

	if(total_playtime < CONFIG_GET(number/certification_minutes))
		to_chat(src, SPAN_ALERTWARNING("你的游戏时长不足，还需要[CONFIG_GET(number/certification_minutes) - total_playtime]分钟。"))
		return

	if(!player_data)
		load_player_data()

	if(player_data.discord_link)
		to_chat(src, SPAN_ALERTWARNING("你已经关联了 Discord 账号。请联系管理员解除关联。"))
		return

	var/datum/view_record/discord_identifier/ident = locate() in DB_VIEW(/datum/view_record/discord_identifier, DB_AND(
		DB_COMP("playerid", DB_EQUALS, player_data.id),
		DB_COMP("realtime", DB_GREATER, world.realtime - 4 HOURS),
		DB_COMP("used", DB_EQUALS, FALSE)
		))

	if(ident)
		to_chat(src, SPAN_ALERTWARNING("现有验证码尚未过期，正在打开弹窗。"))
		show_browser(src, "你的一次性验证码是[ident.identifier]。请使用 [CONFIG_GET(string/bot_prefix)][CONFIG_GET(string/bot_command)] [ident.identifier] 完成认证。", "一次性验证码", "one-time-pass")
		return

	var/datum/entity/discord_identifier/new_identifier = DB_ENTITY(/datum/entity/discord_identifier)

	var/not_unique = TRUE
	var/long_list = GLOB.operation_postfixes + GLOB.operation_prefixes + GLOB.operation_titles
	var/token

	while(not_unique)
		token = replacetext(trim("[pick(long_list)]-[pick(long_list)]-[pick(long_list)]-[pick(long_list)]-[pick(long_list)]-[pick(long_list)]"), " ", "")
		not_unique = locate(/datum/view_record/discord_identifier) in DB_VIEW(/datum/view_record/discord_identifier, DB_COMP("identifier", DB_EQUALS, token))

	new_identifier.identifier = token
	new_identifier.playerid = player_data.id
	new_identifier.save()

	show_browser(src, "你的一次性验证码是[token]。请使用 [CONFIG_GET(string/bot_prefix)][CONFIG_GET(string/bot_command)] [token] 完成认证。", "一次性验证码", "one-time-pass")
