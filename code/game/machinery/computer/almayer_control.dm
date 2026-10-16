#define COMMAND_SHIP_ANNOUNCE "Command Ship Announcement"

/obj/structure/machinery/computer/almayer_control
	name = "阿尔迈耶号控制台"
	desc = "用于控制舰船及相关功能。"
	icon_state = "comm_alt"
	req_access = list(ACCESS_MARINE_SENIOR)
	unslashable = TRUE
	unacidable = TRUE

	/// requesting a distress beacon
	COOLDOWN_DECLARE(cooldown_request)
	/// requesting evac
	COOLDOWN_DECLARE(cooldown_destruct)
	/// messaging HC (admins)
	COOLDOWN_DECLARE(cooldown_central)
	/// making a ship announcement
	COOLDOWN_DECLARE(cooldown_message)

	var/list/messagetitle = list()
	var/list/messagetext = list()

/obj/structure/machinery/computer/almayer_control/attack_remote(mob/user as mob)
	return attack_hand(user)

/obj/structure/machinery/computer/almayer_control/attack_hand(mob/user as mob)
	if(..() || inoperable())
		return

	if(!allowed(user))
		to_chat(usr, SPAN_WARNING("访问被拒绝。"))
		return FALSE

	if(!istype(loc.loc, /area/almayer/command/cic)) //Has to be in the CIC. Can also be a generic CIC area to communicate, if wanted.
		to_chat(usr, SPAN_WARNING("无法建立连接。"))
		return FALSE

	tgui_interact(user)

// tgui boilerplate \\

/obj/structure/machinery/computer/almayer_control/tgui_interact(mob/user, datum/tgui/ui, datum/ui_state/state)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "AlmayerControl", "[name]")
		ui.open()

/obj/structure/machinery/computer/almayer_control/ui_status(mob/user, datum/ui_state/state)
	. = ..()
	if(!allowed(user))
		return UI_CLOSE
	if(!operable())
		return UI_CLOSE

/obj/structure/machinery/computer/almayer_control/ui_state(mob/user)
	return GLOB.not_incapacitated_and_adjacent_strict_state

// tgui data \\

/obj/structure/machinery/computer/almayer_control/ui_static_data(mob/user)
	var/list/data = list()

	data["cooldown_request"] = COOLDOWN_COMM_REQUEST
	data["cooldown_destruct"] = COOLDOWN_COMM_DESTRUCT
	data["cooldown_central"] = COOLDOWN_COMM_CENTRAL
	data["cooldown_message"] = COOLDOWN_COMM_MESSAGE
	data["distresstimelock"] = DISTRESS_TIME_LOCK

	return data

/obj/structure/machinery/computer/almayer_control/ui_data(mob/user)
	var/list/data = list()
	var/list/messages = list()

	data["alert_level"] = GLOB.security_level

	data["time_request"] = cooldown_request
	data["time_destruct"] = cooldown_destruct
	data["time_central"] = cooldown_central
	data["time_message"] = cooldown_message

	data["worldtime"] = world.time

	data["evac_status"] = SShijack.evac_status
	if(SShijack.evac_status == EVACUATION_STATUS_INITIATED)
		data["evac_eta"] = SShijack.get_evac_eta()

	if(!length(messagetitle))
		data["messages"] = null
	else
		for(var/i in 1 to length(messagetitle))
			var/list/messagedata = list(list(
				"title" = messagetitle[i],
				"text" = messagetext[i],
				"number" = i
			))
			messages += messagedata

		data["messages"] = messages

	return data

// end tgui data \\

// tgui interact \\

/obj/structure/machinery/computer/almayer_control/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
	var/mob/user = ui.user
	switch(action)
		if("award")
			open_medal_panel(user, src)
			. = TRUE

		// evac stuff start \\

		if("evacuation_start")
			if(GLOB.security_level < SEC_LEVEL_RED)
				to_chat(user, SPAN_WARNING("必须处于红色警报状态，才能启动撤离程序。"))
				return FALSE

			if(SShijack.evac_admin_denied)
				to_chat(user, SPAN_WARNING("美国殖民地海军陆战队已锁定逃生舱部署功能。"))
				return FALSE

			if(!SShijack.initiate_evacuation())
				to_chat(user, SPAN_WARNING("你现在无法启动撤离程序！"))
				return FALSE

			log_game("[key_name(user)] has called for an emergency evacuation.")
			message_admins("[key_name_admin(user)] has called for an emergency evacuation.")
			log_ares_security("Initiate Evacuation", "Called for an emergency evacuation.", user)
			. = TRUE

		if("evacuation_cancel")
			var/mob/living/carbon/human/human_user = user
			var/obj/item/card/id/idcard = human_user.get_active_hand()
			var/bio_fail = FALSE
			if(!istype(idcard))
				idcard = human_user.get_idcard()
			if(!istype(idcard))
				bio_fail = TRUE
			else if(!idcard.check_biometrics(human_user))
				bio_fail = TRUE
			if(bio_fail)
				to_chat(human_user, SPAN_WARNING("生物特征验证失败！你需要一张通过认证的身份卡才能执行此操作！"))
				return FALSE

			if(!SShijack.cancel_evacuation())
				to_chat(user, SPAN_WARNING("你现在无法取消撤离！"))
				return FALSE

			log_game("[key_name(user)] has canceled the emergency evacuation.")
			message_admins("[key_name_admin(user)] has canceled the emergency evacuation.")
			log_ares_security("Cancel Evacuation", "Cancelled the emergency evacuation.", user)
			. = TRUE

		// evac stuff end \\

		if("change_sec_level")
			var/list/alert_list = list(num2seclevel(SEC_LEVEL_GREEN), num2seclevel(SEC_LEVEL_BLUE))
			switch(GLOB.security_level)
				if(SEC_LEVEL_GREEN)
					alert_list -= num2seclevel(SEC_LEVEL_GREEN)
				if(SEC_LEVEL_BLUE)
					alert_list -= num2seclevel(SEC_LEVEL_BLUE)
				if(SEC_LEVEL_DELTA)
					return

			var/level_selected = tgui_input_list(user, "要设置为何种警报等级？", "警报等级", alert_list)
			if(!level_selected)
				return

			set_security_level(seclevel2num(level_selected), log = ARES_LOG_NONE)
			log_game("[key_name(user)] has changed the security level to [get_security_level()].")
			message_admins("[key_name_admin(user)] has changed the security level to [get_security_level()].")
			log_ares_security("Manual Security Update", "Changed the security level to [get_security_level()].", user)
			. = TRUE

		if("messageUSCM")
			if(!COOLDOWN_FINISHED(src, cooldown_central))
				to_chat(user, SPAN_WARNING("通信阵列正在重置，请稍候。"))
				return FALSE
			var/input = stripped_input(user, "请填写发送至美国殖民地海军陆战队的讯息。此过程费用高昂，滥用将导致解雇。发送并不保证收到回复，且再次发送前需稍作等待。请表达清楚、简洁。", "发送空白讯息可取消。", "")
			if(!input || !(user in dview(1, src)) || !COOLDOWN_FINISHED(src, cooldown_central))
				return FALSE

			high_command_announce(input, user)
			to_chat(user, SPAN_NOTICE("讯息已发送。"))
			log_announcement("[key_name(user)] has made an USCM announcement: [input]")
			COOLDOWN_START(src, cooldown_central, COOLDOWN_COMM_CENTRAL)
			. = TRUE

		if("ship_announce")
			var/mob/living/carbon/human/human_user = user
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

			if(!COOLDOWN_FINISHED(src, cooldown_message))
				to_chat(user, SPAN_WARNING("两次公告之间至少需要间隔[COOLDOWN_TIMELEFT(src, cooldown_message)/10]秒。"))
				return FALSE
			var/input = stripped_multiline_input(user, "请填写向全体舰员广播的讯息。", "优先公告", "")
			if(!input || !COOLDOWN_FINISHED(src, cooldown_message) || !(user in dview(1, src)))
				return FALSE

			var/signed = null
			var/paygrade = get_paygrades(idcard.paygrade, FALSE, human_user.gender)
			signed = "[paygrade] [idcard.registered_name]"

			COOLDOWN_START(src, cooldown_message, COOLDOWN_COMM_MESSAGE)
			shipwide_ai_announcement(input, COMMAND_SHIP_ANNOUNCE, signature = signed)
			message_admins("[key_name(user)] has made a shipwide annoucement.")
			log_announcement("[key_name(user)] has announced the following to the ship: [input]")
			. = TRUE

		if("distress")
			if(world.time < DISTRESS_TIME_LOCK)
				to_chat(user, SPAN_WARNING("行动开始时间太短，尚不能发射求救信标。请再等[time_left_until(DISTRESS_TIME_LOCK, world.time, 1 MINUTES)]分钟。"))
				return FALSE

			if(!SSticker.mode)
				return FALSE //Not a game mode?

			if(SSticker.mode.force_end_at == 0)
				to_chat(user, SPAN_WARNING("阿瑞斯出于行动安全考虑，拒绝了你的请求。"))
				return FALSE

			if(!COOLDOWN_FINISHED(src, cooldown_request))
				to_chat(user, SPAN_WARNING("求救信标刚刚广播过讯息，请稍等。"))
				return FALSE

			if(GLOB.security_level == SEC_LEVEL_DELTA)
				to_chat(user, SPAN_WARNING("舰船已经开始执行自毁程序！"))
				return FALSE

			for(var/client/admin_client as anything in GLOB.admins)
				if((R_ADMIN|R_MOD) & admin_client.admin_holder.rights)
					admin_client << 'sound/effects/sos-morse-code.ogg'
			SSticker.mode.request_ert(user)
			to_chat(user, SPAN_NOTICE("求救信标请求已发送至美国殖民地海军陆战队中央指挥部。"))

			COOLDOWN_START(src, cooldown_request, COOLDOWN_COMM_REQUEST)
			. = TRUE

	// sd \\

		if("destroy")
			if(world.time < DISTRESS_TIME_LOCK)
				to_chat(user, SPAN_WARNING("行动开始时间太短，尚不能启动自毁。请再等[time_left_until(DISTRESS_TIME_LOCK, world.time, 1 MINUTES)]分钟。"))
				return FALSE

			if(!SSticker.mode)
				return FALSE //Not a game mode?

			if(SSticker.mode.force_end_at == 0)
				to_chat(user, SPAN_WARNING("阿瑞斯出于行动安全考虑，拒绝了你的请求。"))
				return FALSE

			if(!COOLDOWN_FINISHED(src, cooldown_destruct))
				to_chat(user, SPAN_WARNING("自毁请求已经发送至最高指挥部，请等待。"))
				return FALSE

			if(get_security_level() == "delta")
				to_chat(user, SPAN_WARNING("[MAIN_SHIP_NAME]的自毁系统已经启动。"))
				return FALSE

			for(var/client/admin_client as anything in GLOB.admins)
				if((R_ADMIN|R_MOD) & admin_client.admin_holder.rights)
					admin_client << 'sound/effects/sos-morse-code.ogg'
			message_admins("[key_name(user)] has requested Self-Destruct! [CC_MARK(user)] (<A href='byond://?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];destroyship=\ref[user]'>GRANT</A>) (<A href='byond://?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];sddeny=\ref[user]'>DENY</A>) [ADMIN_JMP_USER(user)] [CC_REPLY(user)]")
			to_chat(user, SPAN_NOTICE("自毁请求已发送至美国殖民地海军陆战队中央指挥部。"))
			COOLDOWN_START(src, cooldown_destruct, COOLDOWN_COMM_DESTRUCT)
			. = TRUE

		if("delmessage")
			var/number_of_message = params["number"]
			if(!number_of_message)
				return FALSE
			var/title = messagetitle[number_of_message]
			var/text  = messagetext[number_of_message]
			messagetitle.Remove(title)
			messagetext.Remove(text)
			. = TRUE


// end tgui interact \\

// end tgui \\
