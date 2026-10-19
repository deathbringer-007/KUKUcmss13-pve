#define KEYBOARD_SOUND_VOLUME 5

/obj/structure/machinery/computer/shuttle
	name = "穿梭机控制台"
	desc = "一台穿梭机控制计算机。"
	icon_state = "syndishuttle"
	req_access = list( )
// interaction_flags = INTERACT_MACHINE_TGUI
	var/shuttleId
	var/possible_destinations = list()
	var/admin_controlled

/obj/structure/machinery/computer/shuttle/proc/is_disabled()
	return FALSE

/obj/structure/machinery/computer/shuttle/proc/disable()
	return

/obj/structure/machinery/computer/shuttle/proc/enable()
	return

/obj/structure/machinery/computer/shuttle/tgui_interact(mob/user)
	. = ..()
	var/list/options = valid_destinations()
	var/obj/docking_port/mobile/M = SSshuttle.getShuttle(shuttleId)
	var/dat = "状态：[M ? M.getStatusText() : "*未找到*"]<br><br>"
	if(M)
		var/destination_found
		for(var/obj/docking_port/stationary/S in SSshuttle.stationary)
			if(!options.Find(S.id))
				continue
			if(!M.check_dock(S, silent=TRUE))
				continue
			destination_found = TRUE
			dat += "<A href='byond://?src=[REF(src)];move=[S.id]'>派往[localized_player_label(S.name)]</A><br>"
		if(!destination_found)
			dat += "<B>穿梭机已锁定</B><br>"
			if(admin_controlled)
				dat += "仅限授权人员<br>"
				dat += "<A href='byond://?src=[REF(src)];request=1]'>申请授权</A><br>"

	var/datum/browser/popup = new(user, "computer", "<div align='center'>[M ? localized_player_label(M.name) : "穿梭机"]</div>", 300, 200)
	popup.set_content("<center>[dat]</center>")
	popup.open()

/obj/structure/machinery/computer/shuttle/proc/valid_destinations()
	return params2list(possible_destinations)

/obj/structure/machinery/computer/shuttle/Topic(href, href_list)
	. = ..()
	if(.)
		return

	if(!isqueen(usr) && !allowed(usr))
		to_chat(usr, SPAN_DANGER("访问被拒绝。"))
		return TRUE

	if(href_list["move"])
		var/obj/docking_port/mobile/M = SSshuttle.getShuttle(shuttleId)
// if(!(M.shuttle_flags & GAMEMODE_IMMUNE) && world.time < SSticker.round_start_time + SSticker.mode.deploy_time_lock)
// to_chat(usr, SPAN_WARNING("The engines are still refueling."))
// return TRUE
		if(!M.can_move_topic(usr))
			return TRUE
		if(!(href_list["move"] in valid_destinations()))
			log_admin("[key_name(usr)] may be attempting a href dock exploit on [src] with target location \"[href_list["move"]]\"")
// message_admins("[ADMIN_TPMONTY(usr)] may be attempting a href dock exploit on [src] with target location \"[href_list["move"]]\"")
			return TRUE
		var/previous_status = M.mode
		log_game("[key_name(usr)] has sent the shuttle [M] to [href_list["move"]]")
		switch(SSshuttle.moveShuttle(shuttleId, href_list["move"], 1))
			if(DOCKING_SUCCESS)
				if(previous_status != SHUTTLE_IDLE)
					visible_message(SPAN_NOTICE("目的地已更新，正在重新计算航线。"))
				else
					visible_message(SPAN_NOTICE("穿梭机即将出发，请远离舱门。"))
			if(DOCKING_NULL_SOURCE)
				to_chat(usr, SPAN_WARNING("请求的穿梭机无效。"))
				return TRUE
			else
				to_chat(usr, SPAN_NOTICE("无法执行。"))
				return TRUE

/obj/structure/machinery/computer/shuttle/connect_to_shuttle(mapload, obj/docking_port/mobile/port, obj/docking_port/stationary/dock)
	if(port && (shuttleId == initial(shuttleId)))
		shuttleId = port.id

/obj/structure/machinery/computer/shuttle/ert
	name = "运输穿梭机"
	desc = "一台运输穿梭机飞行计算机。"
	icon_state = "syndishuttle"
	req_access = list()
	breakable = FALSE
	unslashable = TRUE
	unacidable = TRUE
	var/disabled = FALSE
	var/compatible_landing_zones = list()

	/// this interface is busy - used in [/obj/structure/machinery/computer/shuttle/ert/proc/launch_home] as this can take a second
	var/spooling

	/// if this shuttle only has the option to return home
	var/must_launch_home = FALSE

	/// if the ERT that used this shuttle has returned home
	var/mission_accomplished = FALSE

/obj/structure/machinery/computer/shuttle/ert/broken
	name = "损坏的穿梭机控制台"
	disabled = TRUE
	desc = "一台运输穿梭机飞行计算机，似乎已经坏了。"

/obj/structure/machinery/computer/shuttle/ert/Initialize(mapload, ...)
	. = ..()
	compatible_landing_zones = get_landing_zones()

/obj/structure/machinery/computer/shuttle/ert/proc/get_landing_zones()
	. = list()
	for(var/obj/docking_port/stationary/emergency_response/dock in SSshuttle.stationary)
		if(!is_mainship_level(dock.z))
			continue

		if(dock.is_external)
			continue

		. += list(dock)

/obj/structure/machinery/computer/shuttle/ert/proc/launch_home()
	if(spooling)
		return

	var/obj/docking_port/mobile/emergency_response/ert = SSshuttle.getShuttle(shuttleId)

	spooling = TRUE
	SStgui.update_uis(src)

	var/datum/turf_reservation/loaded = SSmapping.lazy_load_template(ert.distress_beacon.home_base, force = TRUE)
	var/turf/bottom_left = loaded.bottom_left_turfs[1]
	var/turf/top_right = loaded.top_right_turfs[1]

	var/obj/docking_port/stationary/emergency_response/target
	for(var/obj/docking_port/stationary/emergency_response/shuttle in SSshuttle.stationary)
		if(shuttle.z != bottom_left.z)
			continue
		if(shuttle.x >= top_right.x || shuttle.y >= top_right.y)
			continue
		if(shuttle.x <= bottom_left.x || shuttle.y <= bottom_left.y)
			continue

		target = shuttle
		break

	if(!target)
		spooling = FALSE
		return

	SSshuttle.moveShuttleToDock(ert, target, TRUE)
	target.lockdown_on_land = TRUE

	spooling = FALSE
	must_launch_home = FALSE


/obj/structure/machinery/computer/shuttle/ert/is_disabled()
	return disabled

/obj/structure/machinery/computer/shuttle/ert/disable()
	disabled = TRUE

/obj/structure/machinery/computer/shuttle/ert/enable()
	disabled = FALSE

/obj/structure/machinery/computer/shuttle/ert/tgui_interact(mob/user, datum/tgui/ui)
	var/obj/docking_port/mobile/emergency_response/ert = SSshuttle.getShuttle(shuttleId)

	if(ert.distress_beacon && ishuman(user))
		var/mob/living/carbon/human/human_user = user
		var/obj/item/card/id/id = human_user.get_active_hand()
		if(!istype(id))
			id = human_user.get_inactive_hand()

		if(!istype(id))
			id = human_user.get_idcard()

		if(!id || !HAS_TRAIT_FROM_ONLY(id, TRAIT_ERT_ID, ert.distress_beacon))
			to_chat(user, SPAN_WARNING("你的身份卡无权操作此终端。"))
			balloon_alert(user, "未获授权！")
			return

	ui = SStgui.try_update_ui(user, src, ui)
	if (!ui)
		ui = new(user, src, "NavigationShuttle", "[localized_player_label(ert.name)]导航计算机")
		ui.open()


/obj/structure/machinery/computer/shuttle/ert/ui_status(mob/user, datum/ui_state/state)
	. = ..()
	if(inoperable())
		return UI_CLOSE
	if(disabled)
		return UI_UPDATE


/obj/structure/machinery/computer/shuttle/ert/ui_state(mob/user)
	return GLOB.not_incapacitated_and_adjacent_strict_state

/obj/structure/machinery/computer/shuttle/ert/ui_static_data(mob/user)
	. = ..(user)
	var/obj/docking_port/mobile/shuttle = SSshuttle.getShuttle(shuttleId)
	// we convert the time to seconds for rendering to ui
	.["max_flight_duration"] = shuttle.callTime / 10
	.["max_refuel_duration"] = shuttle.rechargeTime / 10
	.["max_engine_start_duration"] = shuttle.ignitionTime / 10

/obj/structure/machinery/computer/shuttle/ert/ui_data(mob/user)
	var/obj/docking_port/mobile/emergency_response/ert = SSshuttle.getShuttle(shuttleId)
	. = list()
	.["shuttle_mode"] = ert.mode
	.["flight_time"] = ert.timeLeft(0)
	.["is_disabled"] = disabled
	.["spooling"] = spooling
	.["must_launch_home"] = must_launch_home
	.["mission_accomplished"] = mission_accomplished

	var/door_count = length(ert.external_doors)
	var/locked_count = 0
	for(var/obj/structure/machinery/door/airlock/air as anything in ert.external_doors)
		if(air.locked)
			locked_count++
	.["locked_down"] = door_count == locked_count

	.["target_destination"] = localized_player_label(ert.destination?.name)

	.["destinations"] = list()
	for(var/obj/docking_port/stationary/dock in compatible_landing_zones)
		var/dock_reserved = FALSE
		for(var/obj/docking_port/mobile/other_shuttle in SSshuttle.mobile)
			if(dock == other_shuttle.destination)
				dock_reserved = TRUE
				break
		var/can_dock = ert.canDock(dock)
		var/list/dockinfo = list(
			"id" = dock.id,
			"name" = localized_player_label(dock.name),
			"available" = can_dock == SHUTTLE_CAN_DOCK && !dock_reserved,
			"error" = can_dock,
		)
		.["destinations"] += list(dockinfo)

/obj/structure/machinery/computer/shuttle/ert/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
	if(disabled)
		return

	var/obj/docking_port/mobile/emergency_response/ert = SSshuttle.getShuttle(shuttleId)

	switch(action)
		if("button-push")
			playsound(loc, get_sfx("terminal_button"), KEYBOARD_SOUND_VOLUME, 1)
			return FALSE
		if("open")
			if(ert.mode == SHUTTLE_CALL || ert.mode == SHUTTLE_RECALL)
				return TRUE
			ert.control_doors("open", external_only = TRUE)
		if("close")
			if(ert.mode == SHUTTLE_CALL || ert.mode == SHUTTLE_RECALL)
				return TRUE
			ert.control_doors("close", external_only = TRUE)
		if("lockdown")
			if(ert.mode == SHUTTLE_CALL || ert.mode == SHUTTLE_RECALL)
				return TRUE
			ert.control_doors("force-lock", external_only = TRUE)
		if("lock")
			if(ert.mode == SHUTTLE_CALL || ert.mode == SHUTTLE_RECALL)
				return TRUE
			ert.control_doors("lock", external_only = TRUE)
		if("unlock")
			if(ert.mode == SHUTTLE_CALL || ert.mode == SHUTTLE_RECALL)
				return TRUE
			ert.control_doors("unlock", external_only = TRUE)
		if("move")
			if(ert.mode != SHUTTLE_IDLE)
				to_chat(usr, SPAN_WARNING("航行途中无法改换目的地。"))
				return TRUE
			var/dockId = params["target"]
			var/list/local_data = ui_data(usr)
			var/found = FALSE
			playsound(loc, get_sfx("terminal_button"), KEYBOARD_SOUND_VOLUME, 1)
			for(var/destination in local_data["destinations"])
				if(destination["id"] == dockId)
					found = TRUE
					break
			if(!found)
				log_admin("[key_name(usr)] may be attempting a href dock exploit on [src] with target location \"[dockId]\"")
				to_chat(usr, SPAN_WARNING("[dockId]停靠点目前不可用。"))
				return
			var/obj/docking_port/stationary/dock = SSshuttle.getDock(dockId)
			var/dock_reserved = FALSE
			for(var/obj/docking_port/mobile/other_shuttle in SSshuttle.mobile)
				if(dock == other_shuttle.destination)
					dock_reserved = TRUE
					break
			if(dock_reserved)
				to_chat(usr, SPAN_WARNING("[localized_player_label(dock.name)]目前正在使用中。"))
				return TRUE
			SSshuttle.moveShuttle(ert.id, dock.id, TRUE)
			to_chat(usr, SPAN_NOTICE("你启动了前往[localized_player_label(dock.name)]的发射程序。"))
			return TRUE
		if("launch_home")
			if(!must_launch_home)
				return

			if(ert.mode != SHUTTLE_IDLE)
				to_chat(ui.user, SPAN_WARNING("无法返回母港。"))
				balloon_alert(ui.user, "无法返回母港！")
				return

			launch_home()
			return TRUE

/obj/structure/machinery/computer/shuttle/ert/attack_hand(mob/user)
	. = ..(user)
	if(.)
		return TRUE
	tgui_interact(user)

/obj/structure/machinery/computer/shuttle/ert/small
	name = "运输穿梭机"
	desc = "一台运输穿梭机飞行计算机。"
	icon_state = "comm_alt"
	req_access = list()
	breakable = FALSE

/obj/structure/machinery/computer/shuttle/ert/small/get_landing_zones()
	. = list()
	for(var/obj/docking_port/stationary/emergency_response/dock in SSshuttle.stationary)
		if(!is_mainship_level(dock.z))
			continue
		if(istype(dock, /obj/docking_port/stationary/emergency_response/external/hangar_port))
			continue
		if(istype(dock, /obj/docking_port/stationary/emergency_response/external/hangar_starboard))
			continue
		. += list(dock)

/obj/structure/machinery/computer/shuttle/ert/big
	name = "运输穿梭机"
	desc = "一台运输穿梭机飞行计算机。"
	icon_state = "comm_alt"
	req_access = list()
	breakable = FALSE

/obj/structure/machinery/computer/shuttle/ert/big/get_landing_zones()
	. = list()
	for(var/obj/docking_port/stationary/emergency_response/dock in SSshuttle.stationary)
		if(!is_mainship_level(dock.z))
			continue
		. += list(dock)

/obj/structure/machinery/computer/shuttle/lifeboat
	name = "救生艇控制台"
	desc = "一台救生艇控制计算机。"
	icon_state = "terminal"
	req_access = list()
	breakable = FALSE
	unslashable = TRUE
	unacidable = TRUE
	///If true, the lifeboat is in the process of launching, and so the code will not allow another launch.
	var/launch_initiated = FALSE
	///If true, the lifeboat is in the process of having the xeno override removed by the pilot.
	var/override_being_removed = FALSE
	///How long it takes to unlock the console
	var/remaining_time = 180 SECONDS

/obj/structure/machinery/computer/shuttle/lifeboat/ex_act(severity)
	return

/obj/structure/machinery/computer/shuttle/lifeboat/attack_hand(mob/user)
	. = ..()
	var/obj/docking_port/mobile/crashable/lifeboat/lifeboat = SSshuttle.getShuttle(shuttleId)
	if(lifeboat.status == LIFEBOAT_LOCKED)
		if(!skillcheck(user, SKILL_PILOT, SKILL_PILOT_TRAINED))
			to_chat(user, SPAN_WARNING("[src]显示错误信息，要求你联系驾驶员解决问题。"))
			return
		if(user.action_busy || override_being_removed)
			return
		to_chat(user, SPAN_NOTICE("你开始解除锁定。"))
		override_being_removed = TRUE
		user.visible_message(SPAN_NOTICE("[user]开始在[src]上输入。"),
			SPAN_NOTICE("你尝试夺回救生艇的控制权，大约需要[remaining_time / 10]秒。"))
		while(remaining_time > 20 SECONDS)
			if(!do_after(user, 20 SECONDS, INTERRUPT_ALL|INTERRUPT_CHANGED_LYING, BUSY_ICON_HOSTILE, numticks = 20))
				to_chat(user, SPAN_WARNING("你未能解除锁定！"))
				override_being_removed = FALSE
				return
			remaining_time = remaining_time - 20 SECONDS
			if(remaining_time > 0)
				to_chat(user, SPAN_NOTICE("你绕过了部分锁定，只剩[remaining_time / 10]秒。"))
		to_chat(user, SPAN_NOTICE("你成功解除了锁定！"))
		playsound(loc, 'sound/machines/terminal_success.ogg', KEYBOARD_SOUND_VOLUME, 1)
		lifeboat.status = LIFEBOAT_ACTIVE
		lifeboat.available = TRUE
		user.visible_message(SPAN_NOTICE("[src]闪烁蓝色灯光。"),
			SPAN_NOTICE("你成功夺回了救生艇的控制权。"))
		override_being_removed = FALSE
		return
	else if(lifeboat.status == LIFEBOAT_INACTIVE)
		to_chat(user, SPAN_NOTICE("[src]屏幕显示：\"等待撤离命令\"。"))
	else if(lifeboat.status == LIFEBOAT_ACTIVE)
		switch(lifeboat.mode)
			if(SHUTTLE_IDLE)
				if(!istype(user, /mob/living/carbon/human))
					to_chat(user, SPAN_NOTICE("[src]屏幕显示：\"未授权访问，请通知主管\"。"))
					return

				var/mob/living/carbon/human/human_user = user
				var/obj/item/card/id/card = human_user.get_idcard()

				if(!card)
					to_chat(user, SPAN_NOTICE("[src]屏幕显示：\"未授权访问，请通知主管\"。"))
					return

				if(!(ACCESS_MARINE_SENIOR in card.access) && !(ACCESS_MARINE_DROPSHIP in card.access))
					to_chat(user, SPAN_NOTICE("[src]屏幕显示：\"未授权访问，请通知主管\"。"))
					return

				if(SShijack.current_progress < SShijack.early_launch_required_progress)
					to_chat(user, SPAN_NOTICE("[src]屏幕显示：\"燃料不足，无法发射\"。"))
					return

				if(launch_initiated)
					to_chat(user, SPAN_NOTICE("[src]屏幕闪烁，显示：\"发射程序已经启动\"。"))
					return

				var/response = localized_tgui_alert(user, "要发射救生艇吗？", "确认", list("Yes", "No", "Emergency Launch"), 10 SECONDS)
				if(launch_initiated)
					to_chat(user, SPAN_NOTICE("[src]屏幕闪烁，显示：\"发射程序已经启动\"。"))
					return
				switch(response)
					if ("Yes")
						launch_initiated = TRUE
						to_chat(user, "[src]屏幕闪烁，显示：\"发射指令已接受\"。")
						shipwide_ai_announcement("已收到发射指令。[lifeboat.id == MOBILE_SHUTTLE_LIFEBOAT_PORT ? "左舷" : "右舷"]救生艇舱门将在10秒后关闭。")
						addtimer(CALLBACK(lifeboat, TYPE_PROC_REF(/obj/docking_port/mobile/crashable/lifeboat, evac_launch)), 10 SECONDS)
						lifeboat.alarm_sound_loop.start()
						lifeboat.playing_launch_announcement_alarm = TRUE
						return

					if ("Emergency Launch")
						launch_initiated = TRUE
						to_chat(user, "[src]屏幕闪烁，显示：\"紧急发射指令已接受\"。")
						lifeboat.evac_launch()
						shipwide_ai_announcement("已收到紧急发射指令。正在发射[lifeboat.id == MOBILE_SHUTTLE_LIFEBOAT_PORT ? "左舷" : "右舷"]救生艇。")
						return

			if(SHUTTLE_IGNITING)
				to_chat(user, SPAN_NOTICE("[src]屏幕显示：\"引擎点火中\"。"))
			if(SHUTTLE_CALL)
				to_chat(user, SPAN_NOTICE("[src]屏幕滚动显示飞行信息。自动驾驶工作正常。"))

/obj/structure/machinery/computer/shuttle/lifeboat/attack_alien(mob/living/carbon/xenomorph/xeno)
	if(xeno.caste && xeno.caste.is_intelligent)
		var/obj/docking_port/mobile/crashable/lifeboat/lifeboat = SSshuttle.getShuttle(shuttleId)
		if(lifeboat.status == LIFEBOAT_LOCKED)
			to_chat(xeno, SPAN_WARNING("我们已经夺走了这只金属飞鸟的控制权。"))
			return XENO_NO_DELAY_ACTION
		if(lifeboat.mode == SHUTTLE_CALL)
			to_chat(xeno, SPAN_WARNING("太迟了，你无法让金属飞鸟在半空停下。"))
			return XENO_NO_DELAY_ACTION

		xeno_attack_delay(xeno)
		if(do_after(usr, 5 SECONDS, INTERRUPT_ALL, BUSY_ICON_HOSTILE))
			if(lifeboat.status == LIFEBOAT_LOCKED)
				return XENO_NO_DELAY_ACTION
			if(lifeboat.mode == SHUTTLE_CALL)
				to_chat(xeno, SPAN_WARNING("太迟了，你无法让金属飞鸟在半空停下。"))
				return XENO_NO_DELAY_ACTION
			lifeboat.status = LIFEBOAT_LOCKED
			lifeboat.available = FALSE
			lifeboat.set_mode(SHUTTLE_IDLE)
			lifeboat.alarm_sound_loop?.stop()
			lifeboat.playing_launch_announcement_alarm = FALSE
			var/obj/docking_port/stationary/lifeboat_dock/lifeboat_dock = lifeboat.get_docked()
			lifeboat_dock.open_dock()
			xeno_message(SPAN_XENOANNOUNCE("我们夺走了一只金属飞鸟的控制权！它们休想逃跑！"), 3, xeno.hivenumber)
			launch_initiated = FALSE
			remaining_time = initial(remaining_time)
		return XENO_NO_DELAY_ACTION
	else
		return ..()
