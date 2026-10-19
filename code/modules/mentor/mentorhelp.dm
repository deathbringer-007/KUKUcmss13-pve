// Represents a mentorhelp thread
/datum/mentorhelp
	// The client/player who initiated (authored) the mentorhelp thread
	var/client/author = null
	// The author's key
	var/author_key = ""

	// The mentor who's responding to this mentorhelp thread
	// If this is null, it means no mentor has responded yet
	var/client/mentor = null

	// If this thread is still open
	var/open = TRUE

/datum/mentorhelp/New(client/thread_author)
	..()

	if(!thread_author)
		qdel(src)
		return

	// They already have a thread open
	if(thread_author.current_mhelp && thread_author.current_mhelp.open)
		qdel(src)
		return

	author = thread_author
	author_key = thread_author.key

/datum/mentorhelp/Destroy()
	author = null
	mentor = null
	return ..()

/*
 * Helpers
 */

// Helper to check that the author is still around
// Closes the thread if they're not
/datum/mentorhelp/proc/check_author()
	if(!author)
		close()
		return FALSE
	return TRUE

// Helper to check that the thread is still open
/datum/mentorhelp/proc/check_open(client/C)
	if(!open)
		to_chat(C, SPAN_NOTICE("这条导师求助会话已关闭！"))
		return FALSE
	return TRUE

// Logs the mentorhelp message to admin logs
/datum/mentorhelp/proc/log_message(msg, from_key, to_key)
	msg = strip_html(msg)
	var/log_msg = msg
	if(from_key && to_key)
		log_msg = "[SPAN_MENTORHELP("[from_key] -> [to_key]:")] [msg]"
	log_mhelp(log_msg)

/datum/mentorhelp/proc/notify(text, to_thread_mentor = TRUE, to_mentors = TRUE, to_staff = TRUE)
	var/list/hitlist = list()
	if(to_thread_mentor && mentor)
		hitlist |= mentor
	for(var/client/candidate in GLOB.admins)
		if(to_mentors && CLIENT_IS_MENTOR(candidate))
			hitlist |= candidate
		else if(to_staff && CLIENT_IS_STAFF(candidate))
			hitlist |= candidate
	var/displaymsg = "[SPAN_MENTORHELP("<span class='prefix'>MENTOR LOG:</span> <span class='message'>[text]</span>")]"
	for(var/client/receiver in hitlist)
		if(istype(receiver))
			to_chat(receiver, displaymsg)

/datum/mentorhelp/proc/broadcast_request(client/opener)
	if(!opener || !open || !check_author())
		return FALSE // Invalid
	if(mentor)
		return TRUE // No need

	var/message = strip_html(input("请输入消息：", "导师求助", null, null) as message|null)
	if(!message)
		return FALSE
	broadcast_unhandled(message, opener)
	return TRUE

/datum/mentorhelp/proc/broadcast_unhandled(msg, client/sender)
	if(!mentor && open)
		message_handlers(msg, sender)
		addtimer(CALLBACK(src, PROC_REF(broadcast_unhandled), msg, sender), 5 MINUTES)

/datum/mentorhelp/proc/message_handlers(msg, client/sender, client/recipient, with_sound = TRUE, staff_only = FALSE, include_keys = TRUE)
	if(!sender || !check_author())
		return

	if(recipient?.key)
		log_message(msg, sender.key, recipient.key)
	else
		log_message(msg, sender.key, "All mentors")

	// Sender feedback
	to_chat(sender, "[SPAN_MENTORHELP("<span class='prefix'>导师求助：</span>发送给[(recipient?.key) ? "<a href='byond://?src=\ref[src];action=message'>[recipient.key]</a>" : "导师"]的讯息：")] [SPAN_MENTORBODY(msg)]")

	// Recipient direct message
	if(recipient)
		if(with_sound && (recipient.prefs?.toggles_sound & SOUND_ADMINHELP))
			sound_to(recipient, 'sound/effects/mhelp.ogg')
		to_chat(recipient, wrap_message(msg, sender))

	for(var/client/admin_client in GLOB.admins)
		var/formatted = msg
		var/soundfile

		if(!admin_client || admin_client == recipient)
			continue

		// Initial broadcast
		else if(!staff_only && !recipient && CLIENT_HAS_RIGHTS(admin_client, R_MENTOR))
			formatted = wrap_message(formatted, sender)
			soundfile = 'sound/effects/mhelp.ogg'

		// Eavesdrop
		else if(CLIENT_HAS_RIGHTS(admin_client, R_MENTOR) && (!staff_only || CLIENT_IS_STAFF(admin_client)) && admin_client != sender)
			if(include_keys)
				formatted = SPAN_MENTORHELP(key_name(sender, TRUE) + " -> " + key_name(recipient, TRUE) + ": ") + msg

		else continue

		if(soundfile && with_sound && (admin_client.prefs?.toggles_sound & SOUND_ADMINHELP))
			sound_to(admin_client, soundfile)
		to_chat(admin_client, formatted)
	return

// Makes the sender input a message and sends it
/datum/mentorhelp/proc/input_message(client/sender)
	if(!sender || !check_open(sender))
		return
	if(sender != author)
		if(!CLIENT_IS_MENTOR(sender))
			return

		// If the mentor forgot to mark the mentorhelp, mark it for them
		if(!mentor)
			mark(sender)

		// Some other mentor is already taking care of this thread
		else if(mentor != sender)
			to_chat(sender, SPAN_MENTORHELP("<b>NOTICE:</b> A mentor is already handling this thread!"))
			return

	var/target = mentor
	if(sender == mentor)
		target = author

	var/message = input("请输入消息：", "导师求助", null, null) as message|null
	if(message)
		message = strip_html(message)
		message_handlers(message, sender, target)
	return

// Sanitizes and wraps the message with some info and links, depending on the sender...?
/datum/mentorhelp/proc/wrap_message(message, client/sender)
	var/message_title = "导师私信"
	var/message_sender_key = "<a href='byond://?src=\ref[src];action=message'>[sender.key]</a>"
	var/message_sender_options = ""

	// The message is being sent to the mentor and should be formatted as a mentorhelp message
	if(sender == author)
		message_title = "导师求助"
		// If there's a mentor, let them mark it. If not, let them unmark it
		message_sender_options = " (<a href='byond://?src=\ref[src];action=mark'>Mark/Unmark</a>"
		message_sender_options += " | <a href='byond://?src=\ref[src];action=close'>Close</a> | <a href='byond://?src=\ref[src];action=autorespond'>AutoResponse</a>)"

	var/message_header = SPAN_MENTORHELP("<span class='prefix'>[localized_player_label(message_title)]，来自[message_sender_key]：</span><span class='message'>[message_sender_options]</span><br>")
	var/message_body = "&emsp;[SPAN_MENTORBODY("<span class='message'>[message]</span>")]<br>"
	// Et voila! Beautiful wrapped mentorhelp messages
	return (message_header + message_body)

/*
 * Marking
 */

// Marks the mentorhelp thread and notifies the author that the thread is being responded to
/datum/mentorhelp/proc/mark(client/thread_mentor)
	if(!check_author())
		return

	if(!check_open(thread_mentor))
		return

	// Already marked
	if(mentor)
		to_chat(thread_mentor, SPAN_MENTORHELP("<b>NOTICE:</b> A mentor is already handling this thread!"))
		return

	if(!thread_mentor)
		return

	// Not a mentor/staff
	if(!CLIENT_IS_MENTOR(thread_mentor))
		return

	mentor = thread_mentor

	log_mhelp("[mentor.key] has marked [author_key]'s mentorhelp")
	notify("<font style='color:red;'>[mentor.key]</font> has marked <font style='color:red;'>[author_key]</font>'s mentorhelp.")
	to_chat(author, SPAN_NOTICE("<b>提示：</b><font style='color:red;'>[mentor.key]</font>已接下你的求助，正准备回复。"))

// Unmarks the mentorhelp thread and notifies the author that the thread is no longer being handled by a mentor
/datum/mentorhelp/proc/unmark(client/thread_mentor)
	if(!check_author())
		return

	if(!check_open(thread_mentor))
		return

	// Already not marked
	if(!mentor)
		return

	// If we're not the thread mentor and not a staff member
	if((!thread_mentor || thread_mentor != mentor) && !CLIENT_IS_STAFF(thread_mentor))
		return

	log_mhelp("[mentor.key] has unmarked [author_key]'s mentorhelp")
	notify("<font style='color:red;'>[mentor.key]</font> has unmarked <font style='color:red;'><a href='byond://?src=\ref[src];action=message'>[author_key]</a></font>'s mentorhelp.")
	to_chat(author, SPAN_NOTICE("<b>提示：</b><font style='color:red;'>[mentor.key]</font>已取消接下你的求助，不再处理这次会话。"))
	mentor = null

/*
 * Misc.
 */

// Closes the thread and notifies the author/mentor that it has been closed
/datum/mentorhelp/proc/close(client/closer)
	if(!open)
		return

	// Thread was closed because the author is gone
	if(!author)
		notify("<font style='color:red;'>[author_key]</font>'s mentorhelp thread has been closed due to the author disconnecting.")
		log_mhelp("[author_key]'s mentorhelp thread was closed because of a disconnection")
		return

	// Make sure it's being closed by staff or the mentor handling the thread
	if(mentor && closer && (closer != mentor) && (closer != author) && !CLIENT_IS_STAFF(closer))
		to_chat(closer, SPAN_MENTORHELP("<b>NOTICE:</b> Another mentor is handling this thread!"))
		return

	open = FALSE
	if(closer)
		log_mhelp("[closer.key] closed [author_key]'s mentorhelp")
		if(closer == author)
			to_chat(author, SPAN_NOTICE("你关闭了自己的导师求助会话。"))
			notify("<font style='color:red;'>[author_key]</font> closed their mentorhelp thread.")
			return
	to_chat(author, SPAN_NOTICE("你的导师求助会话已关闭。"))
	notify("<font style='color:red;'>[author_key]</font>'s mentorhelp thread has been closed.")

/datum/mentorhelp/Topic(href, list/href_list)
	if(!usr)
		return
	var/client/C = usr.client
	if(!istype(C))
		return

	switch(href_list["action"])
		if("message")
			input_message(C)
		if("autorespond")
			autoresponse(C)
		if("mark")
			if(!mentor)
				mark(C)
			else
				unmark(C)
		if("close")
			if(C == author || C == mentor || CLIENT_IS_STAFF(C))
				close(C)

/*
 * Autoresponse
 * Putting this here cause it's long and ugly
 */

// responder is the guy responding to the thread, i.e. the mentor triggering the autoresponse
/datum/mentorhelp/proc/autoresponse(client/responder)
	if(!check_author())
		return

	if(!check_open(responder))
		return

	if(!CLIENT_IS_MENTOR(responder))
		return

	// If the mentor forgot to mark the mentorhelp, mark it for them
	if(!mentor)
		mark(responder)
	else if(mentor != responder)
		to_chat(responder, SPAN_NOTICE("<b>NOTICE:</b> A mentor is already handling this thread!"))
		return

	var/choice = tgui_input_list(usr, "要向玩家发送哪种自动回复？\n\nL：网页链接。\nA：常见问题解答。", "自动回复", list ("L: Discord", "L: Xeno Quickstart Guide", "L: Marine Quickstart Guide", "L: Current Map", "A: No plasma regen", "A: Devour as Xeno", "T: Tunnel", "E: Event in progress", "R: Radios", "B: Binoculars", "D: Joining disabled", "L: Leaving the server", "M: Macros", "C: Changelog", "H: Clear Cache", "O: Combat Click-Drag Override"))
	if(!choice)
		return

	if(!check_author())
		return

	if(!check_open(responder))
		return

	if(!CLIENT_IS_MENTOR(responder))
		return

	// Re-mark if they unmarked it while the dialog was open (???)
	if(!mentor)
		mark(responder)
	else if(mentor != responder)
		to_chat(responder, SPAN_NOTICE("<b>NOTICE:</b> A mentor is already handling this thread!"))
		return

	var/msg = SPAN_MENTORSAY("<span class='prefix'>自动回复：</span><span class='message'>[localized_player_label(choice)]</span>")
	switch(choice)
		if("L: Discord")
			msg += "你可以通过<a href='[CONFIG_GET(string/discordurl)]'>此链接</a>加入我们的Discord服务器！"
		if("L: Xeno Quickstart Guide")
			msg += "我们的维基《异形快速入门指南》中有你需要的答案。<a href='[CONFIG_GET(string/wikiarticleurl)]/[URL_WIKI_XENO_QUICKSTART]'>点击此处查看。</a>"
		if("L: Marine Quickstart Guide")
			msg += "我们的维基《陆战队员快速入门指南》中有你需要的答案。<a href='[CONFIG_GET(string/wikiarticleurl)]/[URL_WIKI_MARINE_QUICKSTART]'>点击此处查看。</a>"
		if("L: Current Map")
			msg += "若需当前回合的地图概览，可在 OOC 标签页使用 Current Map 指令查看地图名，再打开我们的<a href='[CONFIG_GET(string/wikiurl)]'>维基首页</a>，在“地图”部分查找。若没有列出，说明地图较新或罕见，概览尚未完成。"
		if("A: No plasma regen")
			msg += "等离子体恢复缓慢或停止，通常是因为你离开了菌毯，或正在使用被动能力，例如奔跑者的“隐藏”或释放信息素。"
		if("A: Devour as Xeno")
			msg += "吞噬可快速转移失能宿主。先抓住目标（Ctrl＋点击），再点击自己开始吞噬。宿主可能破腹而出，导致你死亡，所以务必确认目标已失能。约一分钟后，宿主会被自动吐出。若要主动放出目标，点击 HUD 上的“吐出”按钮。"
		if("T: Tunnel")
			msg += "点击隧道即可进入。在隧道中，按住 Alt 点击可退出，按住 Ctrl 点击可选择目的地。"
		if("E: Event in progress")
			msg += "当前正在进行特殊事件，许多内容可能变化。但除非工作人员明确另行说明，通常规则仍然适用。"
		if("R: Radios")
			msg += "将耳机拿在手中，点击它或按 Page Down，快捷键模式下也可按 Z。随后会打开列出全部可用频道及频道键的窗口。陆战队耳机用“;”访问所属小队频道，舰员耳机用“;”访问阿尔迈耶公共频道，用“:h”访问所属部门频道。"
		if("B: Binoculars")
			msg += "双筒望远镜能扩大朝向方向的视野。拿在手中，点击它或按 Page Down，快捷键模式下也可按 Z，即可放大。\n测距仪可在放大时照射目标，获得地格经纬坐标，发出绿色激光。按住 Ctrl 点击空地开始照射，按住 Ctrl 点击测距仪可停止照射而不退出放大。参谋军官可用坐标进行补给空投或轨道轰炸；若有工程兵操作迫击炮，也可请求炮击。\n激光指示器还有红色激光模式，用于为运输机飞行员的近距空中支援标记目标。它具有固定编号，会显示在飞行员武器控制台上；检查设备可查看编号。飞行员轰炸指定区域前，应持续保持红色激光。按住 Alt 点击可切换模式，也可在手中右键点击并选择 Toggle Mode。"
		if("D: Joining disabled")
			msg += "工作人员或回合结束时的自动设置已关闭本回合的新玩家加入。你可以旁观，等待下一回合开始。"
		if("L: Leaving the server")
			msg += "陆战队员离服前，应先进入冷冻休眠，或请他人将你送去休眠。异形应先找安全位置休息，再成为幽灵；这样会立即解锁异形身体，供观察者接管。"
		if("M: Macros")
			msg += "这份<a href='[CONFIG_GET(string/wikiarticleurl)]/[URL_WIKI_MACROS]'>指南</a>介绍如何设置宏，并提供常见实用宏的示例。"
		if("C: Changelog")
			msg += "你的问题可以在更新日志中找到答案。点击屏幕右上角的更新日志按钮，即可在游戏内查看。"
		if("H: Clear Cache")
			msg += "清理缓存时，点击 BYOND 客户端右上角齿轮并打开 Preferences，切到 Games 标签页，点击 Clear Cache。有时需要手动删除：切到 Advanced，点击 Open User Directory，再删除其中的“cache”文件夹。"
		if("O: Combat Click-Drag Override")
			msg += "移动鼠标时点击，BYOND 有时会误判为拖拽，即使只按住一瞬间，也会阻止点击生效。\n开启此选项后，在缴械或伤害意图下，按下鼠标就会立即触发点击，无论是否继续按住；但拖拽自己、盟友或自身物品栏内物品时除外。"

	message_handlers(msg, responder, author)
