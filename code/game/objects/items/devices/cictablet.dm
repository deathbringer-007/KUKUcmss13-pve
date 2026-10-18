/obj/item/device/cotablet
	icon = 'icons/obj/items/devices.dmi'
	name = "指挥平板"
	desc = "高级军官使用的便携式指挥终端，能远程向连接的计算机发送指令。坚固得足以承受核弹爆炸。"
	suffix = "\[3\]"
	icon_state = "Cotablet"
	item_state = "Cotablet"
	unacidable = TRUE
	indestructible = TRUE
	req_access = list(ACCESS_MARINE_SENIOR)
	var/on = TRUE // 0 for off
	var/cooldown_between_messages = COOLDOWN_COMM_MESSAGE

	var/tablet_name = "指挥官平板"

	var/announcement_title = COMMAND_ANNOUNCE
	var/announcement_faction = FACTION_MARINE
	var/add_pmcs = TRUE

	var/datum/tacmap/tacmap
	var/minimap_type = MINIMAP_FLAG_USCM

	COOLDOWN_DECLARE(announcement_cooldown)
	COOLDOWN_DECLARE(distress_cooldown)

/obj/item/device/cotablet/Initialize()
	tacmap = new /datum/tacmap/drawing(src, minimap_type)
	if(SSticker.mode && MODE_HAS_FLAG(MODE_FACTION_CLASH))
		add_pmcs = FALSE
	else if(SSticker.current_state < GAME_STATE_PLAYING)
		RegisterSignal(SSdcs, COMSIG_GLOB_MODE_PRESETUP, PROC_REF(disable_pmc))
	return ..()

/obj/item/device/cotablet/Destroy()
	QDEL_NULL(tacmap)
	return ..()

/obj/item/device/cotablet/proc/disable_pmc()
	if(MODE_HAS_FLAG(MODE_FACTION_CLASH))
		add_pmcs = FALSE
	UnregisterSignal(SSdcs, COMSIG_GLOB_MODE_PRESETUP)

/obj/item/device/cotablet/attack_self(mob/living/carbon/human/user as mob)
	..()

	var/obj/item/card/id/card = user.get_idcard()
	if(allowed(user) && card?.check_biometrics(user))
		tgui_interact(user)
	else
		to_chat(user, SPAN_DANGER("访问被拒绝。"))

/obj/item/device/cotablet/ui_static_data(mob/user)
	var/list/data = list()

	data["faction"] = announcement_faction
	data["cooldown_message"] = cooldown_between_messages
	data["distresstimelock"] = DISTRESS_TIME_LOCK

	return data

/obj/item/device/cotablet/ui_data(mob/user)
	var/list/data = list()

	data["alert_level"] = GLOB.security_level
	data["evac_status"] = SShijack.evac_status
	data["endtime"] = announcement_cooldown
	data["distresstime"] = distress_cooldown
	data["worldtime"] = world.time

	return data

/obj/item/device/cotablet/ui_status(mob/user, datum/ui_state/state)
	. = ..()
	if(!allowed(user))
		return UI_UPDATE
	if(!on)
		return UI_DISABLED

/obj/item/device/cotablet/ui_state(mob/user)
	return GLOB.inventory_state

/obj/item/device/cotablet/tgui_interact(mob/user, datum/tgui/ui, datum/ui_state/state)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "CommandTablet", "指挥平板")
		ui.open()

/obj/item/device/cotablet/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
	var/mob/user = ui.user
	switch(action)
		if("announce")
			if(user.client.prefs.muted & MUTE_IC)
				to_chat(user, SPAN_DANGER("你无法发布公告（已被禁言）。"))
				return

			if(!COOLDOWN_FINISHED(src, announcement_cooldown))
				to_chat(user, SPAN_WARNING("请等待 [COOLDOWN_TIMELEFT(src, announcement_cooldown)/10] 秒后再发布下一条公告。"))
				return FALSE

			var/input = stripped_multiline_input(user, "请输入要向[MAIN_SHIP_NAME]的舰员及全体地面人员发布的公告。", "优先公告", "")
			if(!input || !COOLDOWN_FINISHED(src, announcement_cooldown) || !(user in dview(1, src)))
				return FALSE

			var/signed = null
			if(ishuman(user))
				var/mob/living/carbon/human/human_user = user
				var/obj/item/card/id/id = human_user.get_idcard()
				if(id)
					var/paygrade = get_paygrades(id.paygrade, FALSE, human_user.gender)
					signed = "[paygrade] [id.registered_name]"

			marine_announcement(input, announcement_title, faction_to_display = announcement_faction, add_PMCs = add_pmcs, signature = signed)
			message_admins("[key_name(user)] has made a command announcement.")
			log_announcement("[key_name(user)] has announced the following: [input]")
			COOLDOWN_START(src, announcement_cooldown, cooldown_between_messages)
			. = TRUE

		if("award")
			if(announcement_faction != FACTION_MARINE)
				return
			open_medal_panel(user, src)
			. = TRUE

		if("mapview")
			tacmap.tgui_interact(user)
			. = TRUE

		if("evacuation_start")
			if(announcement_faction != FACTION_MARINE)
				return

			if(GLOB.security_level < SEC_LEVEL_RED)
				to_chat(user, SPAN_WARNING("舰船必须处于红色警报状态才能启动疏散程序。"))
				return FALSE

			if(SShijack.evac_admin_denied)
				to_chat(user, SPAN_WARNING("USCM 已锁定逃生舱部署权限。"))
				return FALSE

			if(!SShijack.initiate_evacuation())
				to_chat(user, SPAN_WARNING("现在无法启动疏散程序！"))
				return FALSE

			log_game("[key_name(user)] has called for an emergency evacuation.")
			message_admins("[key_name_admin(user)] has called for an emergency evacuation.")
			log_ares_security("启动疏散", "已下令紧急疏散。", user)
			. = TRUE

		if("distress")
			if(!SSticker.mode)
				return FALSE //Not a game mode?

			if(GLOB.security_level == SEC_LEVEL_DELTA)
				to_chat(user, SPAN_WARNING("舰船已在执行自毁程序！"))
				return FALSE

			for(var/client/C in GLOB.admins)
				if((R_ADMIN|R_MOD) & C.admin_holder.rights)
					playsound_client(C,'sound/effects/sos-morse-code.ogg',10)
			SSticker.mode.request_ert(user)
			to_chat(user, SPAN_NOTICE("已向 USCM 中央司令部发送求救信标请求。"))
			COOLDOWN_START(src, distress_cooldown, COOLDOWN_COMM_REQUEST)
			return TRUE

/obj/item/device/cotablet/pmc
	desc = "公司私人军事承包商主管使用的专用设备。"

	tablet_name = "基地主管平板"

	announcement_title = PMC_COMMAND_ANNOUNCE
	announcement_faction = FACTION_PMC

	minimap_type = MINIMAP_FLAG_PMC

/obj/item/device/cotablet/upp

	desc = "UPP 战地指挥官使用的专用设备。"

	tablet_name = "UPP战地指挥官平板"

	announcement_title = UPP_COMMAND_ANNOUNCE
	announcement_faction = FACTION_UPP
	req_access = list(ACCESS_UPP_LEADERSHIP)

	minimap_type = MINIMAP_FLAG_UPP

/obj/item/device/cotablet/rmc

	desc = "皇家陆战突击队战地指挥官使用的专用设备。"

	tablet_name = "皇家海军陆战队战地指挥官平板"

	announcement_title = TWE_COMMAND_ANNOUNCE
	announcement_faction = FACTION_TWE
	req_access = list(ACCESS_TWE_LEADERSHIP)
	minimap_type = MINIMAP_FLAG_TWE
