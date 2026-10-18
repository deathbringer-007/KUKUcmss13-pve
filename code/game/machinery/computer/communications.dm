#define STATE_DEFAULT 1
#define STATE_EVACUATION 2
#define STATE_EVACUATION_CANCEL 3
#define STATE_DISTRESS 4
#define STATE_MESSAGELIST 5
#define STATE_VIEWMESSAGE 6
#define STATE_DELMESSAGE 7
#define STATE_STATUSDISPLAY 8
#define STATE_ALERT_LEVEL 9
#define STATE_CONFIRM_LEVEL 10
#define STATE_DESTROY 11
#define STATE_DEFCONLIST 12

//Note: Commented out procs are things I left alone and did not revise. Usually AI-related interactions.

// The communications computer
/obj/structure/machinery/computer/communications
	name = "通信控制台"
	desc = "可用于执行多种重要功能。"
	icon_state = "comm"
	req_access = list(ACCESS_MARINE_COMMAND)
	circuit = /obj/item/circuitboard/computer/communications
	unslashable = TRUE
	unacidable = TRUE

	var/prints_intercept = 1
	var/authenticated = 0
	var/list/messagetitle = list()
	var/list/messagetext = list()
	var/currmsg = 0
	var/aicurrmsg = 0
	var/state = STATE_DEFAULT
	var/aistate = STATE_DEFAULT

	var/cooldown_message = 0 //Based on world.time.

	var/cooldown_request = 0
	var/cooldown_destruct = 0
	var/cooldown_central = 0
	var/tmp_alertlevel = 0

	var/status_display_freq = "1435"
	var/stat_msg1
	var/stat_msg2

	var/datum/tacmap/drawing/tacmap
	var/minimap_type = MINIMAP_FLAG_USCM

	processing = TRUE

/obj/structure/machinery/computer/communications/Initialize()
	. = ..()
	start_processing()
	tacmap = new(src, minimap_type)

/obj/structure/machinery/computer/communications/Destroy()
	QDEL_NULL(tacmap)
	return ..()

/obj/structure/machinery/computer/communications/process()
	if(..() && state != STATE_STATUSDISPLAY)
		updateDialog()

/obj/structure/machinery/computer/communications/Topic(href, href_list)
	if(..()) return FALSE

	usr.set_interaction(src)
	switch(href_list["operation"])
		if("mapview")
			tacmap.tgui_interact(usr)

		if("main") state = STATE_DEFAULT

		if("login")
			if(isRemoteControlling(usr))
				return
			var/mob/living/carbon/human/C = usr
			var/obj/item/card/id/I = C.get_active_hand()
			if(istype(I))
				if(check_access(I)) authenticated = 1
				if(ACCESS_MARINE_SENIOR in I.access)
					authenticated = 2
			else
				I = C.get_idcard()
				if(I)
					if(check_access(I)) authenticated = 1
					if(ACCESS_MARINE_SENIOR in I.access)
						authenticated = 2
		if("logout")
			authenticated = 0

		if("swipeidseclevel")
			var/mob/M = usr
			var/obj/item/card/id/I = M.get_active_hand()
			if(istype(I))
				if((ACCESS_MARINE_SENIOR in I.access) || (ACCESS_MARINE_COMMAND in I.access)) //Let heads change the alert level.
					switch(tmp_alertlevel)
						if(-INFINITY to SEC_LEVEL_GREEN) tmp_alertlevel = SEC_LEVEL_GREEN //Cannot go below green.
						if(SEC_LEVEL_BLUE to INFINITY) tmp_alertlevel = SEC_LEVEL_BLUE //Cannot go above blue.

					var/old_level = GLOB.security_level
					set_security_level(tmp_alertlevel)
					if(GLOB.security_level != old_level)
						//Only notify the admins if an actual change happened
						log_game("[key_name(usr)] has changed the security level to [get_security_level()].")
						message_admins("[key_name_admin(usr)] has changed the security level to [get_security_level()].")
				else
					to_chat(usr, SPAN_WARNING("你无权执行此操作。"))
				tmp_alertlevel = SEC_LEVEL_GREEN //Reset to green.
				state = STATE_DEFAULT
			else
				to_chat(usr, SPAN_WARNING("你需要刷身份卡。"))

		if("announce")
			if(authenticated == 2)
				var/mob/living/carbon/human/human_user = usr
				var/obj/item/card/id/idcard = human_user.get_active_hand()
				var/bio_fail = FALSE
				if(!istype(idcard))
					idcard = human_user.get_idcard()
				if(idcard)
					bio_fail = TRUE
				else if(!idcard.check_biometrics(human_user))
					bio_fail = TRUE
				if(bio_fail)
					to_chat(human_user, SPAN_WARNING("生物特征验证失败！你需要一张通过认证的身份卡才能执行此操作！"))
					return FALSE

				if(usr.client.prefs.muted & MUTE_IC)
					to_chat(usr, SPAN_DANGER("你已被禁言，无法发送公告。"))
					return

				if(world.time < cooldown_message + COOLDOWN_COMM_MESSAGE_LONG)
					to_chat(usr, SPAN_WARNING("两次公告之间至少需要间隔[COOLDOWN_COMM_MESSAGE_LONG*0.1]秒。"))
					return FALSE
				var/input = stripped_multiline_input(usr, "Please write a message to announce to the station crew.", "Priority Announcement", "")
				if(!input || authenticated != 2 || world.time < cooldown_message + COOLDOWN_COMM_MESSAGE_LONG || !(usr in dview(1, src)))
					return FALSE

				marine_announcement(input)
				message_admins("[key_name(usr)] has made a command announcement.")
				log_announcement("[key_name(usr)] has announced the following: [input]")
				cooldown_message = world.time

		if("award")
			open_medal_panel(usr, src)

		if("evacuation_start")
			if(state == STATE_EVACUATION)
				if(GLOB.security_level < SEC_LEVEL_DELTA)
					to_chat(usr, SPAN_WARNING("必须处于德尔塔警报状态，才能启动撤离程序。"))
					return FALSE

				if(SShijack.evac_admin_denied)
					to_chat(usr, SPAN_WARNING("美国殖民地海军陆战队已锁定逃生舱部署功能。"))
					return FALSE

				if(!SShijack.initiate_evacuation())
					to_chat(usr, SPAN_WARNING("你现在无法启动撤离程序！"))
					return FALSE

				log_game("[key_name(usr)] has called for an emergency evacuation.")
				message_admins("[key_name_admin(usr)] has called for an emergency evacuation.")
				log_ares_security("Initiate Evacuation", "Called for an emergency evacuation.", usr)
				return TRUE

			state = STATE_EVACUATION

		if("evacuation_cancel")
			var/mob/living/carbon/human/human_user = usr
			var/obj/item/card/id/idcard = human_user.get_active_hand()
			var/bio_fail = FALSE
			if(!istype(idcard))
				idcard = human_user.get_idcard()
			if(!idcard)
				bio_fail = TRUE
			else if(!idcard.check_biometrics(human_user))
				bio_fail = TRUE
			if(bio_fail)
				to_chat(human_user, SPAN_WARNING("生物特征验证失败！你需要一张通过认证的身份卡才能执行此操作！"))
				return FALSE

			if(state == STATE_EVACUATION_CANCEL)
				if(!SShijack.cancel_evacuation())
					to_chat(usr, SPAN_WARNING("你现在无法取消撤离！"))
					return FALSE

				log_game("[key_name(usr)] has canceled the emergency evacuation.")
				message_admins("[key_name_admin(usr)] has canceled the emergency evacuation.")
				log_ares_security("Cancel Evacuation", "Cancelled the emergency evacuation.", usr)
				return TRUE

			state = STATE_EVACUATION_CANCEL

		if("distress")
			if(state == STATE_DISTRESS)

				//Comment to test
				if(world.time < DISTRESS_TIME_LOCK)
					to_chat(usr, SPAN_WARNING("行动开始时间太短，尚不能发射求救信标。请再等[time_left_until(DISTRESS_TIME_LOCK, world.time, 1 MINUTES)]分钟。"))
					return FALSE

				if(!SSticker.mode)
					return FALSE //Not a game mode?

				if(SSticker.mode.force_end_at == 0)
					to_chat(usr, SPAN_WARNING("阿瑞斯出于行动安全考虑，拒绝了你的请求。"))
					return FALSE

				if(world.time < cooldown_request + COOLDOWN_COMM_REQUEST)
					to_chat(usr, SPAN_WARNING("求救信标刚刚广播过讯息，请稍等。"))
					return FALSE

				if(GLOB.security_level == SEC_LEVEL_DELTA)
					to_chat(usr, SPAN_WARNING("舰船已经开始执行自毁程序！"))
					return FALSE

				for(var/client/C in GLOB.admins)
					if((R_ADMIN|R_MOD) & C.admin_holder.rights)
						C << 'sound/effects/sos-morse-code.ogg'
				SSticker.mode.request_ert(usr)
				to_chat(usr, SPAN_NOTICE("求救信标请求已发送至美国殖民地海军陆战队中央指挥部。"))

				cooldown_request = world.time
				return TRUE

			state = STATE_DISTRESS

		if("destroy")
			if(state == STATE_DESTROY)

				//Comment to test
				if(world.time < DISTRESS_TIME_LOCK)
					to_chat(usr, SPAN_WARNING("行动开始时间太短，尚不能启动自毁。请再等[time_left_until(DISTRESS_TIME_LOCK, world.time, 1 MINUTES)]分钟。"))
					return FALSE

				if(!SSticker.mode)
					return FALSE //Not a game mode?

				if(SSticker.mode.force_end_at == 0)
					to_chat(usr, SPAN_WARNING("阿瑞斯出于行动安全考虑，拒绝了你的请求。"))
					return FALSE

				if(world.time < cooldown_destruct + COOLDOWN_COMM_DESTRUCT)
					to_chat(usr, SPAN_WARNING("自毁请求已经发送至最高指挥部，请等待。"))
					return FALSE

				if(get_security_level() == "delta")
					to_chat(usr, SPAN_WARNING("[MAIN_SHIP_NAME]的自毁系统已经启动。"))
					return FALSE

				for(var/client/C in GLOB.admins)
					if((R_ADMIN|R_MOD) & C.admin_holder.rights)
						C << 'sound/effects/sos-morse-code.ogg'
				message_admins("[key_name(usr)] has requested Self-Destruct! [CC_MARK(usr)] (<A href='byond://?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];destroyship=\ref[usr]'>GRANT</A>) (<A href='byond://?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];sddeny=\ref[usr]'>DENY</A>) [ADMIN_JMP_USER(usr)] [CC_REPLY(usr)]")
				to_chat(usr, SPAN_NOTICE("自毁请求已发送至美国殖民地海军陆战队中央指挥部。"))
				cooldown_destruct = world.time
				return TRUE

			state = STATE_DESTROY

		if("messagelist")
			currmsg = 0
			state = STATE_MESSAGELIST

		if("viewmessage")
			state = STATE_VIEWMESSAGE
			if (!currmsg)
				if(href_list["message-num"]) currmsg = text2num(href_list["message-num"])
				else state = STATE_MESSAGELIST

		if("delmessage")
			state = (currmsg) ? STATE_DELMESSAGE : STATE_MESSAGELIST

		if("delmessage2")
			if(authenticated)
				if(currmsg)
					var/title = messagetitle[currmsg]
					var/text  = messagetext[currmsg]
					messagetitle.Remove(title)
					messagetext.Remove(text)
					if(currmsg == aicurrmsg) aicurrmsg = 0
					currmsg = 0
				state = STATE_MESSAGELIST
			else state = STATE_VIEWMESSAGE


		if("status")
			state = STATE_STATUSDISPLAY

		if("setmsg1")
			stat_msg1 = reject_bad_text(trim(copytext(sanitize(input("第1行", "输入消息内容", stat_msg1) as text|null), 1, 40)), 40)
			updateDialog()

		if("setmsg2")
			stat_msg2 = reject_bad_text(trim(copytext(sanitize(input("第2行", "输入消息内容", stat_msg2) as text|null), 1, 40)), 40)
			updateDialog()

		if("messageUSCM")
			if(authenticated == 2)
				if(world.time < cooldown_central + COOLDOWN_COMM_CENTRAL)
					to_chat(usr, SPAN_WARNING("通信阵列正在重置，请稍候。"))
					return FALSE
				var/input = stripped_input(usr, "请输入要发给美国殖民地海军陆战队的消息。此过程费用高昂，滥用将导致被解职。发送消息不保证得到回复，再次发送前需等待片刻。请言简意赅。", "若要中止，请发送空消息。", "")
				if(!input || !(usr in dview(1, src)) || authenticated != 2 || world.time < cooldown_central + COOLDOWN_COMM_CENTRAL) return FALSE

				high_command_announce(input, usr)
				to_chat(usr, SPAN_NOTICE("讯息已发送。"))
				log_announcement("[key_name(usr)] has made an USCM announcement: [input]")
				cooldown_central = world.time

		if("securitylevel")
			tmp_alertlevel = text2num( href_list["newalertlevel"] )
			if(!tmp_alertlevel) tmp_alertlevel = 0
			state = STATE_CONFIRM_LEVEL

		if("changeseclevel")
			state = STATE_ALERT_LEVEL

		if("selectlz")
			if(!SSticker.mode.active_lz)
				var/lz_choices = list("lz1", "lz2")
				var/new_lz = tgui_input_list(usr, "选择主要着陆区", "选择着陆区", lz_choices)
				if(!new_lz)
					return
				if(new_lz == "lz1")
					SSticker.mode.select_lz(locate(/obj/structure/machinery/computer/shuttle/dropship/flight/lz1))
				else
					SSticker.mode.select_lz(locate(/obj/structure/machinery/computer/shuttle/dropship/flight/lz2))


		else return FALSE

	updateUsrDialog()

/obj/structure/machinery/computer/communications/attack_remote(mob/user as mob)
	return attack_hand(user)

/obj/structure/machinery/computer/communications/attack_hand(mob/user as mob)
	if(..()) return FALSE

	//Should be refactored later, if there's another ship that can appear during a mode with a comm console.
	if(!istype(loc.loc, /area/almayer/command/cic)) //Has to be in the CIC. Can also be a generic CIC area to communicate, if wanted.
		to_chat(usr, SPAN_WARNING("无法建立连接。"))
		return FALSE

	user.set_interaction(src)
	var/dat = "<head><title>通讯控制台</title></head><body>"
	if(SShijack.evac_status == EVACUATION_STATUS_INITIATED)
		dat += "<B>疏散正在进行</B>\n<BR>\n预计抵达时间：[SShijack.get_evac_eta()]<BR>"
	switch(state)
		if(STATE_DEFAULT)
			if(authenticated)
				dat += "<BR><A href='byond://?src=\ref[src];operation=logout'>退出登录</A>"
				dat += "<BR><A href='byond://?src=\ref[src];operation=changeseclevel'>更改警戒等级</A>"
				dat += "<BR><A href='byond://?src=\ref[src];operation=status'>设置状态显示</A>"
				dat += "<BR><A href='byond://?src=\ref[src];operation=messagelist'>消息列表</A>"
				dat += "<BR><A href='byond://?src=\ref[src];operation=mapview'>切换战术地图</A>"
				dat += "<BR><hr>"

				if(authenticated == 2)
					dat += "<BR>主要着陆区"
					if(!isnull(SSticker.mode) && !isnull(SSticker.mode.active_lz) && !isnull(SSticker.mode.active_lz.loc))
						dat += "<BR>[SSticker.mode.active_lz.loc.loc]"
					else
						dat += "<BR><A href='byond://?src=\ref[src];operation=selectlz'>选择主要着陆区</A>"
					dat += "<BR><hr>"
					dat += "<BR><A href='byond://?src=\ref[src];operation=announce'>发布公告</A>"
					dat += length(GLOB.admins) > 0 ? "<BR><A href='byond://?src=\ref[src];operation=messageUSCM'>向USCM发送消息</A>" : "<BR>USCM通讯离线"
					dat += "<BR><A href='byond://?src=\ref[src];operation=award'>授予勋章</A>"
					dat += "<BR><A href='byond://?src=\ref[src];operation=distress'>发送求救信标</A>"
					dat += "<BR><A href='byond://?src=\ref[src];operation=destroy'>启动自毁</A>"
					switch(SShijack.evac_status)
						if(EVACUATION_STATUS_NOT_INITIATED)
							dat += "<BR><A href='byond://?src=\ref[src];operation=evacuation_start'>Initiate emergency evacuation</A>"
						if(EVACUATION_STATUS_INITIATED)
							dat += "<BR><A href='byond://?src=\ref[src];operation=evacuation_cancel'>Cancel emergency evacuation</A>"

			else
				dat += "<BR><A href='byond://?src=\ref[src];operation=login'>LOG IN</A>"

		if(STATE_EVACUATION)
			dat += "Are you sure you want to evacuate the [MAIN_SHIP_NAME]? <A href='byond://?src=\ref[src];operation=evacuation_start'>Confirm</A>"

		if(STATE_EVACUATION_CANCEL)
			dat += "Are you sure you want to cancel the evacuation of the [MAIN_SHIP_NAME]? <A href='byond://?src=\ref[src];operation=evacuation_cancel'>Confirm</A>"

		if(STATE_DISTRESS)
			dat += "Are you sure you want to trigger a distress signal? The signal can be picked up by anyone listening, friendly or not. <A href='byond://?src=\ref[src];operation=distress'>Confirm</A>"

		if(STATE_DESTROY)
			dat += "Are you sure you want to trigger the self-destruct? This would mean abandoning ship. <A href='byond://?src=\ref[src];operation=destroy'>Confirm</A>"

		if(STATE_MESSAGELIST)
			dat += "Messages:"
			for(var/i = 1; i<=length(messagetitle); i++)
				dat += "<BR><A href='byond://?src=\ref[src];operation=viewmessage;message-num=[i]'>[messagetitle[i]]</A>"

		if(STATE_VIEWMESSAGE)
			if (currmsg)
				dat += "<B>[messagetitle[currmsg]]</B><BR><BR>[messagetext[currmsg]]"
				if (authenticated)
					dat += "<BR><BR><A href='byond://?src=\ref[src];operation=delmessage'>Delete"
			else
				state = STATE_MESSAGELIST
				attack_hand(user)
				return FALSE

		if(STATE_DELMESSAGE)
			if (currmsg)
				dat += "Are you sure you want to delete this message? <A href='byond://?src=\ref[src];operation=delmessage2'>OK</A>|<A href='byond://?src=\ref[src];operation=viewmessage'>Cancel</A>"
			else
				state = STATE_MESSAGELIST
				attack_hand(user)
				return FALSE

		if(STATE_STATUSDISPLAY)
			dat += "Set Status Displays<BR>"
			dat += "<A href='byond://?src=\ref[src];operation=setstat;statdisp=blank'>Clear</A><BR>"
			dat += "<A href='byond://?src=\ref[src];operation=setstat;statdisp=time'>Station Time</A><BR>"
			dat += "<A href='byond://?src=\ref[src];operation=setstat;statdisp=shuttle'>Shuttle ETA</A><BR>"
			dat += "<A href='byond://?src=\ref[src];operation=setstat;statdisp=message'>Message</A>"
			dat += "<ul><li> Line 1: <A href='byond://?src=\ref[src];operation=setmsg1'>[ stat_msg1 ? stat_msg1 : "(none)"]</A>"
			dat += "<li> Line 2: <A href='byond://?src=\ref[src];operation=setmsg2'>[ stat_msg2 ? stat_msg2 : "(none)"]</A></ul><br>"
			dat += "\[ Alert: <A href='byond://?src=\ref[src];operation=setstat;statdisp=alert;alert=default'>None</A> |"
			dat += " <A href='byond://?src=\ref[src];operation=setstat;statdisp=alert;alert=redalert'>Red Alert</A> |"
			dat += " <A href='byond://?src=\ref[src];operation=setstat;statdisp=alert;alert=lockdown'>Lockdown</A> |"
			dat += " <A href='byond://?src=\ref[src];operation=setstat;statdisp=alert;alert=biohazard'>Biohazard</A> \]<BR><HR>"

		if(STATE_ALERT_LEVEL)
			dat += "Current alert level: [get_security_level()]<BR>"
			dat += "<A href='byond://?src=\ref[src];operation=securitylevel;newalertlevel=[SEC_LEVEL_BLUE]'>Blue</A><BR>"
			dat += "<A href='byond://?src=\ref[src];operation=securitylevel;newalertlevel=[SEC_LEVEL_GREEN]'>Green</A>"

		if(STATE_CONFIRM_LEVEL)
			dat += "Current alert level: [get_security_level()]<BR>"
			dat += "Confirm the change to: [num2seclevel(tmp_alertlevel)]<BR>"
			dat += "<A href='byond://?src=\ref[src];operation=swipeidseclevel'>Swipe ID</A> to confirm change.<BR>"

	dat += "<BR>[(state != STATE_DEFAULT) ? "<A href='byond://?src=\ref[src];operation=main'>Main Menu</A>|" : ""]<A href='byond://?src=\ref[user];mach_close=communications'>Close</A>"
	show_browser(user, dat, name, "communications")
	onclose(user, "communications")

//A simpler version that doesn't have everything the other one has
/obj/structure/machinery/computer/communications/simple
	circuit = null

/obj/structure/machinery/computer/communications/simple/attack_hand(mob/user as mob)
	user.set_interaction(src)
	var/dat = "<body>"

	switch(state)
		if(STATE_DEFAULT)
			if(authenticated)
				dat += "<BR><A href='byond://?src=\ref[src];operation=logout'>LOG OUT</A>"
				dat += "<BR><A href='byond://?src=\ref[src];operation=messagelist'>Message list</A>"
				dat += "<BR><A href='byond://?src=\ref[src];operation=mapview'>Toggle Tactical Map</A>"
				dat += "<BR><hr>"

				if(authenticated == 2)
					dat += "<BR><A href='byond://?src=\ref[src];operation=announce'>Make an announcement</A>"
					dat += "<BR><A href='byond://?src=\ref[src];operation=award'>Award a medal</A>"

			else
				dat += "<BR><A href='byond://?src=\ref[src];operation=login'>LOG IN</A>"

		if(STATE_MESSAGELIST)
			dat += "Messages:"
			for(var/i = 1; i<=length(messagetitle); i++)
				dat += "<BR><A href='byond://?src=\ref[src];operation=viewmessage;message-num=[i]'>[messagetitle[i]]</A>"

		if(STATE_VIEWMESSAGE)
			if (currmsg)
				dat += "<B>[messagetitle[currmsg]]</B><BR><BR>[messagetext[currmsg]]"
				if (authenticated)
					dat += "<BR><BR><A href='byond://?src=\ref[src];operation=delmessage'>Delete"
			else
				state = STATE_MESSAGELIST
				attack_hand(user)
				return FALSE

		if(STATE_DELMESSAGE)
			if (currmsg)
				dat += "Are you sure you want to delete this message? <A href='byond://?src=\ref[src];operation=delmessage2'>OK</A>|<A href='byond://?src=\ref[src];operation=viewmessage'>Cancel</A>"
			else
				state = STATE_MESSAGELIST
				attack_hand(user)
				return FALSE

	dat += "<BR>[(state != STATE_DEFAULT) ? "<A href='byond://?src=\ref[src];operation=main'>Main Menu</A>|" : ""]<A href='byond://?src=\ref[user];mach_close=communications'>Close</A>"
	show_browser(user, dat, "Communications Console", "communications", width = 400, height = 500)
	onclose(user, "communications")
#undef STATE_DEFAULT
#undef STATE_MESSAGELIST
#undef STATE_VIEWMESSAGE
#undef STATE_DELMESSAGE
#undef STATE_STATUSDISPLAY
#undef STATE_ALERT_LEVEL
#undef STATE_CONFIRM_LEVEL
