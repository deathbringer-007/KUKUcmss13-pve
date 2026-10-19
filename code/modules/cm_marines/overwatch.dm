#define MAX_SAVED_COORDINATES 3

#define HIDE_ALMAYER 2
#define HIDE_GROUND 1
#define HIDE_NONE 0

/obj/structure/machinery/computer/overwatch
	name = "战术指挥控制台"
	desc = "用于向小队下达命令的先进设备。"
	icon_state = "dummy"
	req_access = list(ACCESS_MARINE_DATABASE)
	unacidable = TRUE

	var/datum/squad/current_squad = null
	var/state = 0
	var/obj/structure/machinery/camera/cam = null
	var/list/network = list(CAMERA_NET_OVERWATCH)
	var/x_supply = 0
	var/y_supply = 0
	var/x_bomb = 0
	var/y_bomb = 0
	var/living_marines_sorting = FALSE
	var/busy = FALSE //The overwatch computer is busy launching an OB/SB, lock controls
	var/dead_hidden = FALSE //whether or not we show the dead marines in the squad
	var/z_hidden = 0 //which z level is ignored when showing marines.
	var/marine_filter = list() // individual marine hiding control - list of string references
	var/marine_filter_enabled = TRUE
	var/faction = FACTION_MARINE

	var/datum/tacmap/tacmap
	var/minimap_type = MINIMAP_FLAG_USCM


	///List of saved coordinates, format of ["x", "y", "comment"]
	var/list/saved_coordinates = list()
	///Currently selected UI theme
	var/ui_theme = "crtblue"


/obj/structure/machinery/computer/overwatch/Initialize()
	. = ..()

	var/datum/squad/main_squad_path = MAIN_SHIP_PLATOON
	if (faction == main_squad_path::faction)
		tacmap = new /datum/tacmap/drawing(src, minimap_type)
	else
		tacmap = new(src, minimap_type) // Non-drawing version

/obj/structure/machinery/computer/overwatch/Destroy()
	QDEL_NULL(tacmap)
	return ..()

/obj/structure/machinery/computer/overwatch/attackby(obj/I as obj, mob/user as mob)  //Can't break or disassemble.
	return

/obj/structure/machinery/computer/overwatch/bullet_act(obj/projectile/Proj) //Can't shoot it
	return FALSE

/obj/structure/machinery/computer/overwatch/attack_remote(mob/user as mob)
	return attack_hand(user)

/obj/structure/machinery/computer/overwatch/attack_hand(mob/user)
	if(..())  //Checks for power outages
		return

	if(istype(src, /obj/structure/machinery/computer/overwatch/almayer/broken))
		return

	if(!isSilicon(usr) && !skillcheck(user, SKILL_OVERWATCH, SKILL_OVERWATCH_TRAINED) && SSmapping.configs[GROUND_MAP].map_name != MAP_WHISKEY_OUTPOST)
		to_chat(user, SPAN_WARNING("你没有接受过使用[src]的训练。"))
		return

	tgui_interact(user)

/obj/structure/machinery/computer/overwatch/get_examine_text(mob/user)
	. = ..()

	. += SPAN_NOTICE("按住Alt点击此机器可切换界面主题。")

/obj/structure/machinery/computer/overwatch/clicked(mob/user, list/mods)

	if(!ishuman(user))
		return ..()
	if(mods[ALT_CLICK]) //Changing UI theme
		var/list/possible_options = list("Blue"= "crtblue", "Green" = "crtgreen", "Yellow" = "crtyellow", "Red" = "crtred")
		var/chosen_theme = localized_input_list(user, "选择界面主题：", "界面主题", list("Blue", "Green", "Yellow", "Red"))
		if(possible_options[chosen_theme])
			ui_theme = possible_options[chosen_theme]
		return TRUE
	. = ..()

/obj/structure/machinery/computer/overwatch/ui_static_data(mob/user)
	var/list/data = list()
	data["mapRef"] = tacmap.map_holder.map_ref
	return data

/obj/structure/machinery/computer/overwatch/tgui_interact(mob/user, datum/tgui/ui)

	if(!tacmap.map_holder)
		var/level = SSmapping.levels_by_trait(tacmap.targeted_ztrait)
		if(!level[1])
			return
		tacmap.map_holder = SSminimaps.fetch_tacmap_datum(level[1], tacmap.allowed_flags)

	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		user.client.register_map_obj(tacmap.map_holder.map)
		ui = new(user, src, "OverwatchConsole", "战术指挥控制台")
		ui.open()

/obj/structure/machinery/computer/overwatch/ui_data(mob/user)
	var/list/data = list()

	data["theme"] = ui_theme

	if(!current_squad)
		data["squad_list"] = list()
		for(var/datum/squad/current_squad in GLOB.RoleAuthority.squads)
			if(current_squad.active && !current_squad.overwatch_officer && current_squad.faction == faction && current_squad.name != "Root")
				data["squad_list"] += current_squad.name
		return data

	data["current_squad"] = current_squad.name

	data["primary_objective"] = current_squad.primary_objective
	data["secondary_objective"] = current_squad.secondary_objective

	data["marines"] = list()

	var/leader_count = 0
	var/ftl_count = 0
	var/spec_count = 0
	var/medic_count = 0
	var/engi_count = 0
	var/smart_count = 0
	var/marine_count = 0

	var/leaders_alive = 0
	var/ftl_alive = 0
	var/spec_alive= 0
	var/medic_alive= 0
	var/engi_alive = 0
	var/smart_alive = 0
	var/marines_alive = 0

	var/specialist_type

	var/SL_z //z level of the Squad Leader
	if(current_squad.squad_leader)
		var/turf/SL_turf = get_turf(current_squad.squad_leader)
		SL_z = SL_turf.z

	for(var/marine in current_squad.marines_list)
		if(!marine)
			continue //just to be safe
		var/mob_name = "unknown"
		var/mob_state = ""
		var/has_helmet = TRUE
		var/role = "unknown"
		var/acting_sl = ""
		var/fteam = ""
		var/distance = "???"
		var/area_name = "???"
		var/is_squad_leader = FALSE
		var/mob/living/carbon/human/marine_human


		if(ishuman(marine))
			marine_human = marine
			if(istype(marine_human.loc, /obj/structure/machinery/cryopod)) //We don't care much for these
				continue
			mob_name = marine_human.real_name
			var/area/current_area = get_area(marine_human)
			var/turf/current_turf = get_turf(marine_human)
			if(!current_turf)
				continue
			if(current_area)
				area_name = sanitize_area(current_area.name)

			switch(z_hidden)
				if(HIDE_ALMAYER)
					if(is_mainship_level(current_turf.z))
						continue
				if(HIDE_GROUND)
					if(is_ground_level(current_turf.z))
						continue

			var/obj/item/card/id/card = marine_human.get_idcard()
			if(marine_human.job)
				role = marine_human.job
			else if(card?.rank) //decapitated marine is mindless,
				role = card.rank

			if(current_squad.squad_leader)
				if(marine_human == current_squad.squad_leader)
					distance = "N/A"
					if(current_squad.name == SQUAD_SOF)
						if(marine_human.job == JOB_MARINE_RAIDER_CMD)
							acting_sl = " (direct command)"
						else if(marine_human.job != JOB_MARINE_RAIDER_SL)
							acting_sl = " (acting TL)"
					else if(marine_human.job != JOB_SQUAD_LEADER)
						acting_sl = " (acting SL)"
					is_squad_leader = TRUE
				else if(current_turf && (current_turf.z == SL_z))
					distance = "[get_dist(marine_human, current_squad.squad_leader)] ([dir2text_short(Get_Compass_Dir(current_squad.squad_leader, marine_human))])"


			switch(marine_human.stat)
				if(CONSCIOUS)
					mob_state = "Conscious"

				if(UNCONSCIOUS)
					mob_state = "Unconscious"

				if(DEAD)
					mob_state = "Dead"

			if(mob_state == "Conscious" && ((locate(/datum/effects/crit) in marine_human.effects_list) && !(marine_human.status_flags & CANKNOCKOUT)))
				mob_state = "Incapacitated"

			if(!marine_has_camera(marine_human))
				has_helmet = FALSE

			if(!marine_human.key || !marine_human.client)
				if(marine_human.stat != DEAD)
					mob_state += " (SSD)"


			if(marine_human.assigned_fireteam)
				fteam = " [marine_human.assigned_fireteam]"

		else //listed marine was deleted or gibbed, all we have is their name
			for(var/datum/data/record/marine_record as anything in GLOB.data_core.general)
				if(marine_record.fields["name"] == marine)
					role = marine_record.fields["real_rank"]
					break
			mob_state = "Dead"
			mob_name = marine


		switch(role)
			if(JOB_SQUAD_LEADER)
				leader_count++
				if(mob_state != "Dead")
					leaders_alive++
			if(JOB_SQUAD_TEAM_LEADER)
				ftl_count++
				if(mob_state != "Dead")
					ftl_alive++
			if(JOB_SQUAD_SPECIALIST)
				spec_count++
				if(marine_human)
					var/obj/item/card/id/card = marine_human.get_idcard()
					if(card?.assignment) //decapitated marine is mindless,
						if(specialist_type)
							specialist_type = "MULTIPLE"
						else
							var/list/spec_type = splittext(card.assignment, "(")
							if(islist(spec_type) && (length(spec_type) > 1))
								specialist_type = splittext(spec_type[2], ")")[1]
				else if(!specialist_type)
					specialist_type = "UNKNOWN"
				if(mob_state != "Dead")
					spec_alive++
			if(JOB_SQUAD_MEDIC)
				medic_count++
				if(mob_state != "Dead")
					medic_alive++
			if(JOB_SQUAD_ENGI)
				engi_count++
				if(mob_state != "Dead")
					engi_alive++
			if(JOB_SQUAD_SMARTGUN)
				smart_count++
				if(mob_state != "Dead")
					smart_alive++
			if(JOB_SQUAD_MARINE)
				marine_count++
				if(mob_state != "Dead")
					marines_alive++

		var/marine_data = list(list("name" = mob_name, "state" = mob_state, "has_helmet" = has_helmet, "role" = role, "role_display" = get_statistic_display_label(role), "acting_sl" = acting_sl, "fteam" = fteam, "distance" = distance, "area_name" = area_name,"ref" = REF(marine)))
		data["marines"] += marine_data
		if(is_squad_leader)
			if(!data["squad_leader"])
				data["squad_leader"] = marine_data[1]

	data["total_deployed"] = leader_count + ftl_count + spec_count + medic_count + engi_count + smart_count + marine_count
	data["living_count"] = leaders_alive + ftl_alive + spec_alive + medic_alive + engi_alive + smart_alive + marines_alive

	data["leader_count"] = leader_count
	data["ftl_count"] = ftl_count
	data["spec_count"] = spec_count
	data["medic_count"] = medic_count
	data["engi_count"] = engi_count
	data["smart_count"] = smart_count

	data["leaders_alive"] = leaders_alive
	data["ftl_alive"] = ftl_alive
	data["spec_alive"] = spec_alive
	data["medic_alive"] = medic_alive
	data["engi_alive"] = engi_alive
	data["smart_alive"] = smart_alive
	data["specialist_type"] = specialist_type ? specialist_type : "NONE"

	data["z_hidden"] = z_hidden

	data["saved_coordinates"] = list()
	for(var/i in 1 to length(saved_coordinates))
		data["saved_coordinates"] += list(list("x" = saved_coordinates[i]["x"], "y" = saved_coordinates[i]["y"], "comment" = saved_coordinates[i]["comment"], "index" = i))

	var/has_supply_pad = FALSE
	var/obj/structure/closet/crate/supply_crate
	if(current_squad.drop_pad)
		supply_crate = locate() in current_squad.drop_pad.loc
		has_supply_pad = TRUE
	data["can_launch_crates"] = has_supply_pad
	data["has_crate_loaded"] = supply_crate
	data["can_launch_obs"] = GLOB.almayer_orbital_cannon
	if(GLOB.almayer_orbital_cannon)
		data["ob_cooldown"] = COOLDOWN_TIMELEFT(GLOB.almayer_orbital_cannon, ob_firing_cooldown)
		data["ob_loaded"] = GLOB.almayer_orbital_cannon.chambered_tray

	data["supply_cooldown"] = COOLDOWN_TIMELEFT(current_squad, next_supplydrop)
	data["operator"] = operator.name

	return data

/obj/structure/machinery/computer/overwatch/ui_state(mob/user)
	return GLOB.not_incapacitated_and_adjacent_strict_state

/obj/structure/machinery/computer/overwatch/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	var/mob/user = ui.user

	if((user.contents.Find(src) || (in_range(src, user) && istype(loc, /turf))) || (isSilicon(user)))
		user.set_interaction(src)

	switch(action)
		if("pick_squad")
			if(current_squad)
				return
			var/datum/squad/selected_squad
			for(var/datum/squad/searching_squad in GLOB.RoleAuthority.squads)
				if(searching_squad.active && !searching_squad.overwatch_officer && searching_squad.faction == faction && searching_squad.name != "Root" && searching_squad.name == params["squad"])
					selected_squad = searching_squad
					break

			if(!selected_squad)
				return

			if(selected_squad.assume_overwatch(user))
				current_squad = selected_squad
				operator = user
				current_squad.send_squad_message("Attention - Your squad has been selected for Overwatch. Check your Status pane for objectives.", displayed_icon = src)
				current_squad.send_squad_message("Your Overwatch officer is: [operator.name].", displayed_icon = src)
				visible_message("[icon2html(src, viewers(src))] [SPAN_BOLDNOTICE("已载入[current_squad]小队的战术数据，全部战术功能已初始化。")]")
				return TRUE
		if("logout")
			if(current_squad?.release_overwatch())
				if(isSilicon(user))
					current_squad.send_squad_message("Attention. [operator.name] has released overwatch system control. Overwatch functions deactivated.", displayed_icon = src)
					to_chat(user, "[icon2html(src, user)] [SPAN_BOLDNOTICE("战术指挥系统的控制覆盖已解除。")]")
				else
					var/mob/living/carbon/human/human_operator = operator
					var/obj/item/card/id/ID = human_operator.get_idcard()
					current_squad.send_squad_message("Attention. [ID ? "[get_statistic_display_label(ID.rank)] ":""][operator ? "[operator.name]":"sysadmin"] is no longer your Overwatch officer. Overwatch functions deactivated.", displayed_icon = src)
					visible_message("[icon2html(src, viewers(src))] [SPAN_BOLDNOTICE("战术指挥系统已关闭。再见，[ID ? "[get_statistic_display_label(ID.rank)] ":""][operator ? "[operator.name]":"系统管理员"]。")]")
			operator = null
			current_squad = null
			if(cam && !isSilicon(user))
				user.reset_view(null)
				user.UnregisterSignal(cam, COMSIG_PARENT_QDELETING)
			cam = null
			ui.close()
			return TRUE

		if("message")
			if(!current_squad)
				return TRUE

			var/input = tgui_input_text(user, "请输入向分队广播的讯息：", "分队讯息")
			if(!input)
				return TRUE

			current_squad.send_message(input, 1) //message, adds username
			current_squad.send_maptext(input, "分队消息：")
			visible_message("[icon2html(src, viewers(src))] [SPAN_BOLDNOTICE("讯息“[input]”已发送给[current_squad]排的全体陆战队员。")]")
			log_overwatch("[key_name(user)] sent '[input]' to platoon [current_squad].")

			var/comm_paygrade = user.get_paygrade()

			for(var/mob/dead/observer/cycled_observer in GLOB.player_list)
				if(cycled_observer.client && cycled_observer.client.prefs && (cycled_observer.client.prefs.toggles_chat & CHAT_GHOSTRADIO))
					var/ghost_message = "<span class='medium'><span class='orange'><span class='name'>[comm_paygrade][user] (<a href='byond://?src=\ref[cycled_observer];track=\ref[user]'>F</a>)</span>向[current_squad]小队发送消息：<span class='body'>\"[input]\"</span></span></span>"
					cycled_observer.show_message(ghost_message)

			return TRUE

		if("sl_message")
			if(!current_squad)
				return TRUE

			var/input = tgui_input_text(user, "请输入发送给分队长的讯息：", "分队长讯息")
			if(!input)
				return TRUE

			current_squad.send_message(input, 1, 1) //message, adds username, only to leader
			current_squad.send_maptext(input, "分队士官消息：", 1)
			visible_message("[icon2html(src, viewers(src))] [SPAN_BOLDNOTICE("讯息“[input]”已发送给[current_squad]排的分队士官[current_squad.squad_leader]。")]")
			log_overwatch("[key_name(user)] sent '[input]' to Section Sergeant [current_squad.squad_leader] of squad [current_squad].")

			var/comm_paygrade = user.get_paygrade()

			for(var/mob/dead/observer/cycled_observer in GLOB.player_list)
				if(cycled_observer.client && cycled_observer.client.prefs && (cycled_observer.client.prefs.toggles_chat & CHAT_GHOSTRADIO))
					var/ghost_message = "<span class='medium'><span class='orange'><span class='name'>[comm_paygrade][user] (<a href='byond://?src=\ref[cycled_observer];track=\ref[user]'>F</a>)</span>向[current_squad]排的排长发送消息：<span class='body'>\"[input]\"</span></span></span>"
					cycled_observer.show_message(ghost_message)

			return TRUE

		if("check_primary")
			if(current_squad) //This is already checked, but ehh.
				if(current_squad.primary_objective)
					visible_message("[icon2html(src, viewers(src))] [SPAN_BOLDNOTICE("已提醒[current_squad]主要目标：[current_squad.primary_objective]。")]")
					current_squad.send_message("你的主要目标是“[current_squad.primary_objective]”。详见状态面板。")
					current_squad.send_maptext(current_squad.primary_objective, "主要目标：")

		if("check_secondary")
			if(current_squad) //This is already checked, but ehh.
				if(current_squad.secondary_objective)
					visible_message("[icon2html(src, viewers(src))] [SPAN_BOLDNOTICE("已提醒[current_squad]次要目标：[current_squad.secondary_objective]。")]")
					current_squad.send_message("你的次要目标是“[current_squad.secondary_objective]”。详见状态面板。")
					current_squad.send_maptext(current_squad.secondary_objective, "次要目标：")

		if("set_primary")
			var/input = sanitize_control_chars(stripped_input(usr, "分队的主要目标是什么？", "主要目标"))
			if(current_squad && input)
				current_squad.primary_objective = "[input] ([worldtime2text()])"
				current_squad.send_message("你的主要目标已改为“[input]”。详见状态面板。")
				current_squad.send_maptext(input, "主要目标已更新：")
				visible_message("[icon2html(src, viewers(src))] [SPAN_BOLDNOTICE("[current_squad]小队的主要目标已设为“[input]”。")]")
				log_overwatch("[key_name(usr)] set [current_squad]'s primary objective to '[input]'.")
				return TRUE

		if("set_secondary")
			var/input = sanitize_control_chars(stripped_input(usr, "分队的次要目标是什么？", "次要目标"))
			if(input)
				current_squad.secondary_objective = input + " ([worldtime2text()])"
				current_squad.send_message("你的次要目标已改为“[input]”。详见状态面板。")
				current_squad.send_maptext(input, "次要目标已更新：")
				visible_message("[icon2html(src, viewers(src))] [SPAN_BOLDNOTICE("[current_squad]小队的次要目标已设为“[input]”。")]")
				log_overwatch("[key_name(usr)] set [current_squad]'s secondary objective to '[input]'.")
				return TRUE
		if("replace_lead")
			if(!params["ref"])
				return
			change_lead(user, params["ref"])

		if("award_medal")
			open_medal_panel(user, src)
			return

		if("insubordination")
			mark_insubordination()
			return

		if("transfer_marine")
			transfer_squad()
			return

		if("change_locations_ignored")
			switch(z_hidden)
				if(HIDE_NONE)
					z_hidden = HIDE_ALMAYER
					to_chat(user, "[icon2html(src, usr)] [SPAN_NOTICE("已隐藏部署舰船上的陆战队员。")]")
				if(HIDE_ALMAYER)
					z_hidden = HIDE_GROUND
					to_chat(user, "[icon2html(src, usr)] [SPAN_NOTICE("已隐藏地面的陆战队员。")]")
				else
					z_hidden = HIDE_NONE
					to_chat(user, "[icon2html(src, usr)] [SPAN_NOTICE("现在不再忽略任何位置。")]")
		if("tacmap_unpin")
			tacmap.tgui_interact(user)
		if("dropbomb")
			if(!params["x"] || !params["y"])
				return
			x_bomb = text2num(params["x"])
			y_bomb = text2num(params["y"])
			if(GLOB.almayer_orbital_cannon.is_disabled)
				to_chat(user, "[icon2html(src, usr)] [SPAN_WARNING("轨道轰炸炮已被禁用！")]")
			else if(!COOLDOWN_FINISHED(GLOB.almayer_orbital_cannon, ob_firing_cooldown))
				to_chat(user, "[icon2html(src, usr)] [SPAN_WARNING("轨道轰炸炮尚未准备好再次开火！请再等[COOLDOWN_TIMELEFT(GLOB.almayer_orbital_cannon, ob_firing_cooldown)/10]秒。")]")
			else
				handle_bombard(user)

		if("dropsupply")
			if(!params["x"] || !params["y"])
				return
			x_supply = text2num(params["x"])
			y_supply = text2num(params["y"])
			if(current_squad)
				if(!COOLDOWN_FINISHED(current_squad, next_supplydrop))
					to_chat(user, "[icon2html(src, user)] [SPAN_WARNING("补给空投尚未准备好再次发射！")]")
				else
					handle_supplydrop()

		if("save_coordinates")
			if(!params["x"] || !params["y"])
				return
			if(length(saved_coordinates) >= MAX_SAVED_COORDINATES)
				popleft(saved_coordinates)
			saved_coordinates += list(list("x" = text2num(params["x"]), "y" = text2num(params["y"])))
			return TRUE
		if("change_coordinate_comment")
			if(!params["index"] || !params["comment"])
				return
			var/index = text2num(params["index"])
			if(length(saved_coordinates) + 1 < index)
				return
			saved_coordinates[index]["comment"] = params["comment"]
			return TRUE

		if("watch_camera")
			if(isRemoteControlling(user))
				to_chat(user, "[icon2html(src, user)] [SPAN_WARNING("无法覆盖控制台的摄像头视角，请改用摄像头追踪。")]")
				return
			if(!params["target_ref"])
				return
			if(current_squad)
				var/mob/cam_target = locate(params["target_ref"])
				var/obj/structure/machinery/camera/new_cam = get_camera_from_target(cam_target)
				if(!new_cam || !new_cam.can_use())
					to_chat(user, "[icon2html(src, user)] [SPAN_WARNING("正在搜索头盔摄像头。未找到这名陆战队员的头盔摄像头！请让你的小队戴上头盔！")]")
				else if(cam && cam == new_cam)//click the camera you're watching a second time to stop watching.
					visible_message("[icon2html(src, viewers(src))] [SPAN_BOLDNOTICE("已停止查看[cam_target]的头盔摄像头。")]")
					user.UnregisterSignal(cam, COMSIG_PARENT_QDELETING)
					cam = null
					user.reset_view(null)
				else if(user.client.view != GLOB.world_view_size)
					to_chat(user, SPAN_WARNING("你正忙于透过双筒望远镜观察。"))
				else
					if(cam)
						user.UnregisterSignal(cam, COMSIG_PARENT_QDELETING)
					cam = new_cam
					user.reset_view(cam)
					user.RegisterSignal(cam, COMSIG_PARENT_QDELETING, TYPE_PROC_REF(/mob, reset_observer_view_on_deletion))
		if("change_operator")
			if(operator != user)
				if(operator && isSilicon(operator))
					visible_message("[icon2html(src, viewers(src))] [SPAN_BOLDNOTICE("人工智能正在接管。访问被拒绝。")]")
					return
				if(!current_squad || current_squad.assume_overwatch(user))
					operator = user
				if(isSilicon(user))
					to_chat(user, "[icon2html(src, usr)] [SPAN_BOLDNOTICE("战术指挥系统人工智能接管协议执行成功。")]")
					current_squad?.send_squad_message("Attention. [operator.name] has engaged overwatch system control override.", displayed_icon = src)
				else
					var/mob/living/carbon/human/H = operator
					var/obj/item/card/id/ID = H.get_idcard()
					visible_message("[icon2html(src, viewers(src))] [SPAN_BOLDNOTICE("基础战术指挥系统已初始化。欢迎，[ID ? "[get_statistic_display_label(ID.rank)] ":""][operator.name]。请选择小队。")]")
					current_squad?.send_squad_message("Attention. Your Overwatch officer is now [ID ? "[get_statistic_display_label(ID.rank)] ":""][operator.name].", displayed_icon = src)


/obj/structure/machinery/computer/overwatch/proc/change_lead(mob/user, sl_ref)
	if(!user)
		return

	if(!current_squad)
		return

	var/mob/living/carbon/human/selected_sl = locate(sl_ref) in current_squad.marines_list
	if(!selected_sl)
		return
	if(!istype(selected_sl))
		return

	if(!istype(selected_sl) || !selected_sl.mind || selected_sl.stat == DEAD) //marines_list replaces mob refs of gibbed marines with just a name string
		to_chat(user, "[icon2html(src, usr)] [SPAN_WARNING("[selected_sl]已阵亡！")]")
		return
	if(selected_sl == current_squad.squad_leader)
		to_chat(user, "[icon2html(src, usr)] [SPAN_WARNING("[selected_sl]已经是小队长了！")]")
		return
	if(jobban_isbanned(selected_sl, JOB_SQUAD_LEADER))
		to_chat(user, "[icon2html(src, usr)] [SPAN_WARNING("[selected_sl]不适合担任指挥！")]")
		return
	if(current_squad.squad_leader)
		current_squad.send_message("注意：[current_squad.squad_leader][current_squad.squad_leader.stat == DEAD ? "卸任" : "被撤职"]。新任小队长为[selected_sl.real_name]。")
		visible_message("[icon2html(src, viewers(src))] [SPAN_BOLDNOTICE("[current_squad]小队长[current_squad.squad_leader]已被[selected_sl.real_name][current_squad.squad_leader.stat == DEAD ? "接替" : "降职并接替"]！正在写入服役档案。")]")
		var/old_lead = current_squad.squad_leader
		current_squad.demote_squad_leader(current_squad.squad_leader.stat != DEAD)
		SStracking.start_tracking(current_squad.tracking_id, old_lead)
	else
		current_squad.send_message("注意：新任小队长为[selected_sl.real_name]。")
		visible_message("[icon2html(src, viewers(src))] [SPAN_BOLDNOTICE("[selected_sl.real_name]已成为[current_squad]的新任小队长！正在写入服役档案。")]")

	to_chat(selected_sl, "[icon2html(src, selected_sl)] <font size='3' color='blue'><B>战术指挥：你已被任命为[current_squad.name]的\'[selected_sl.job == JOB_SQUAD_LEADER ? "小队长" : "代理小队长"]\'。你的耳机已开通指挥频道（:v）。</B></font>")
	to_chat(user, "[icon2html(src, usr)] [selected_sl.real_name]已成为[current_squad]的新任队长！")

	if(selected_sl.assigned_fireteam)
		if(selected_sl == current_squad.fireteam_leaders[selected_sl.assigned_fireteam])
			current_squad.unassign_ft_leader(selected_sl.assigned_fireteam, TRUE, FALSE)
		current_squad.unassign_fireteam(selected_sl, FALSE)

	current_squad.squad_leader = selected_sl
	current_squad.update_squad_leader()
	current_squad.update_free_mar()

	SStracking.set_leader(current_squad.tracking_id, selected_sl)
	SStracking.start_tracking("marine_sl", selected_sl)

	if(selected_sl.job == JOB_SQUAD_LEADER)//a real SL
		selected_sl.comm_title = "SL"
	else //an acting SL
		selected_sl.comm_title = "aSL"
	ADD_TRAIT(selected_sl, TRAIT_LEADERSHIP, TRAIT_SOURCE_SQUAD_LEADER)

	var/obj/item/device/radio/headset/almayer/marine/sl_headset = selected_sl.get_type_in_ears(/obj/item/device/radio/headset/almayer/marine)
	if(sl_headset)
		sl_headset.keys += new /obj/item/device/encryptionkey/squadlead/acting(sl_headset)
		sl_headset.recalculateChannels()
	var/obj/item/card/id/card = selected_sl.get_idcard()
	if(card)
		card.access += ACCESS_MARINE_LEADER
	selected_sl.hud_set_squad()
	selected_sl.update_inv_head() //updating marine helmet leader overlays
	selected_sl.update_inv_wear_suit()


/obj/structure/machinery/computer/overwatch/check_eye(mob/user)
	if(user.is_mob_incapacitated(TRUE) || get_dist(user, src) > 1 || user.blinded) //user can't see - not sure why canmove is here.
		user.unset_interaction()
	else if(!cam || !cam.can_use()) //camera doesn't work, is no longer selected or is gone
		user.unset_interaction()

/obj/structure/machinery/computer/overwatch/on_unset_interaction(mob/user)
	..()
	if(!isRemoteControlling(user))
		if(cam)
			user.UnregisterSignal(cam, COMSIG_PARENT_QDELETING)
		cam = null
		user.reset_view(null)

/obj/structure/machinery/computer/overwatch/ui_close(mob/user)
	..()
	if(!isRemoteControlling(user))
		if(cam)
			user.UnregisterSignal(cam, COMSIG_PARENT_QDELETING)
		cam = null
		user.reset_view(null)

/// checks if the human has an overwatch camera at all
/obj/structure/machinery/computer/overwatch/proc/marine_has_camera(mob/living/carbon/human/marine)
	if(istype(marine.head, /obj/item/clothing/head/helmet/marine) || istype(marine.head, /obj/item/clothing/head/helmet/upp))
		return TRUE
	if(istype(marine.wear_l_ear, /obj/item/device/overwatch_camera) || istype(marine.wear_r_ear, /obj/item/device/overwatch_camera))
		return TRUE
	if(istype(marine.glasses, /obj/item/clothing/glasses/night))
		return TRUE
	return FALSE
/// returns the overwatch camera the human is wearing
/obj/structure/machinery/computer/overwatch/proc/get_camera_from_target(mob/living/carbon/human/marine)
	if(current_squad)
		if(marine && istype(marine))
			if(istype(marine.head, /obj/item/clothing/head/helmet/marine))
				var/obj/item/clothing/head/helmet/marine/helm = marine.head
				return helm.camera
			if(istype(marine.head, /obj/item/clothing/head/helmet/upp))
				var/obj/item/clothing/head/helmet/upp/helm = marine.head
				return helm.camera
			var/obj/item/device/overwatch_camera/cam_gear
			if(istype(marine.wear_l_ear, /obj/item/device/overwatch_camera))
				cam_gear = marine.wear_l_ear
				return cam_gear.camera
			if(istype(marine.wear_r_ear, /obj/item/device/overwatch_camera))
				cam_gear = marine.wear_r_ear
				return cam_gear.camera
			var/obj/item/clothing/glasses/night/hms_cam
			if(istype(marine.glasses, /obj/item/clothing/glasses/night))
				hms_cam = marine.glasses
				return hms_cam.camera

// Alerts all groundside marines about the incoming OB
/obj/structure/machinery/computer/overwatch/proc/alert_ob(turf/target)
	var/area/ob_area = get_area(target)
	if(!ob_area)
		return
	var/ob_type = GLOB.almayer_orbital_cannon.tray.warhead ? GLOB.almayer_orbital_cannon.tray.warhead.warhead_kind : "UNKNOWN"

	for(var/datum/squad/S in GLOB.RoleAuthority.squads)
		if(!S.active)
			continue
		for(var/mob/living/carbon/human/M in S.marines_list)
			if(!is_ground_level(M.z))
				continue
			if(M.stat != CONSCIOUS || !M.client)
				continue
			playsound_client(M.client, 'sound/effects/ob_alert.ogg', M)
			to_chat(M, SPAN_HIGHDANGER("检测到轨道轰炸发射指令！"))
			to_chat(M, SPAN_DANGER("发射指令指定[localized_player_label(ob_type)]弹头。预计落点区域：[ob_area.name]。"))


/obj/structure/machinery/computer/overwatch/proc/mark_insubordination()
	if(!usr)
		return
	if(!current_squad)
		to_chat(usr, "[icon2html(src, usr)] [SPAN_WARNING("未选择小队！")]")
		return
	var/mob/living/carbon/human/wanted_marine = tgui_input_list(usr, "举报陆战队员违抗命令", "标记违抗命令", current_squad.marines_list)
	if(!wanted_marine)
		return
	if(!istype(wanted_marine))//gibbed/deleted, all we have is a name.
		to_chat(usr, "[icon2html(src, usr)] [SPAN_WARNING("[wanted_marine]处于失踪状态。")]")
		return

	var/marine_ref = WEAKREF(wanted_marine)
	for(var/datum/data/record/E in GLOB.data_core.general)
		if(E.fields["ref"] == marine_ref)
			for(var/datum/data/record/R in GLOB.data_core.security)
				if(R.fields["id"] == E.fields["id"])
					if(!findtext(R.fields["ma_crim"],"Insubordination."))
						R.fields["criminal"] = "*Arrest*"
						if(R.fields["ma_crim"] == "None")
							R.fields["ma_crim"] = "Insubordination."
						else
							R.fields["ma_crim"] += "Insubordination."

						var/insub = "[icon2html(src, usr)] [SPAN_BOLDNOTICE("[wanted_marine]已因违抗命令被举报。正在写入服役档案。")]"
						if(isRemoteControlling(usr))
							usr << insub
						else
							visible_message(insub)
						to_chat(wanted_marine, "[icon2html(src, wanted_marine)] <font size='3' color='blue'><B>战术指挥：</b>你的战术指挥官已举报你违抗命令。</font>")
						wanted_marine.sec_hud_set_security_status()
					return

/obj/structure/machinery/computer/overwatch/proc/transfer_squad()
	if(!usr)
		return
	if(!current_squad)
		to_chat(usr, "[icon2html(src, usr)] [SPAN_WARNING("未选择小队！")]")
		return
	var/datum/squad/S = current_squad
	var/mob/living/carbon/human/transfer_marine = tgui_input_list(usr, "选择要调动的陆战队员", "调动陆战队员", current_squad.marines_list)
	if(!transfer_marine || S != current_squad) //don't change overwatched squad, idiot.
		return

	if(!istype(transfer_marine) || !transfer_marine.mind || transfer_marine.stat == DEAD) //gibbed, decapitated, dead
		to_chat(usr, "[icon2html(src, usr)] [SPAN_WARNING("[transfer_marine]已阵亡。")]")
		return

	var/obj/item/card/id/card = transfer_marine.get_idcard()
	if(!card)
		to_chat(usr, "[icon2html(src, usr)] [SPAN_WARNING("调动已取消。[transfer_marine]没有佩戴身份卡。")]")
		return

	var/list/available_squads = list()
	for(var/datum/squad/squad as anything in GLOB.RoleAuthority.squads)
		if(squad.active && !squad.locked && squad.faction == faction && squad.name != "Root")
			available_squads += squad

	var/datum/squad/new_squad = tgui_input_list(usr, "选择该陆战队员的新小队", "选择小队", available_squads)
	if(!new_squad || S != current_squad)
		return

	if(!istype(transfer_marine) || !transfer_marine.mind || transfer_marine.stat == DEAD)
		to_chat(usr, "[icon2html(src, usr)] [SPAN_WARNING("[transfer_marine]已阵亡。")]")
		return

	card = transfer_marine.get_idcard()
	if(!card)
		to_chat(usr, "[icon2html(src, usr)] [SPAN_WARNING("调动已取消。[transfer_marine]没有佩戴身份卡。")]")
		return

	var/datum/squad/old_squad = transfer_marine.assigned_squad
	if(new_squad == old_squad)
		to_chat(usr, "[icon2html(src, usr)] [SPAN_WARNING("[transfer_marine]已经属于[new_squad]！")]")
		return

	if(GLOB.RoleAuthority.check_squad_capacity(transfer_marine, new_squad))
		to_chat(usr, "[icon2html(src, usr)] [SPAN_WARNING("调动已取消。[new_squad]无法再容纳一名[get_statistic_display_label(transfer_marine.job)]。")]")
		return

	. = transfer_marine_to_squad(transfer_marine, new_squad, old_squad, card)
	if(.)
		visible_message("[icon2html(src, viewers(src))] [SPAN_BOLDNOTICE("[transfer_marine]已从[old_squad]小队调至[new_squad]小队。正在写入服役档案。")]")
		to_chat(transfer_marine, "[icon2html(src, transfer_marine)] <font size='3' color='blue'><B>\[战术指挥\]：</b>你已被调至[new_squad]！</font>")
	else
		visible_message("[icon2html(src, viewers(src))] [SPAN_BOLDNOTICE("将[transfer_marine]从[old_squad]小队调至[new_squad]小队的操作失败。")]")

/obj/structure/machinery/computer/overwatch/proc/handle_bombard(mob/user)
	if(!user)
		return

	if(busy)
		to_chat(user, "[icon2html(src, user)] [SPAN_WARNING("[name]正在处理另一个操作！")]")
		return

	if(!current_squad)
		to_chat(user, "[icon2html(src, user)] [SPAN_WARNING("未选择小队！")]")
		return

	if(!GLOB.almayer_orbital_cannon.chambered_tray)
		to_chat(user, "[icon2html(src, user)] [SPAN_WARNING("轨道炮尚未装弹入膛。")]")
		return

	var/x_coord = deobfuscate_x(x_bomb)
	var/y_coord = deobfuscate_y(y_bomb)
	var/z_coord = SSmapping.levels_by_trait(ZTRAIT_GROUND)
	if(length(z_coord))
		z_coord = z_coord[1]
	else
		z_coord = 1 // fuck it

	var/turf/T = locate(x_coord, y_coord, z_coord)

	if(isnull(T) || istype(T, /turf/open/space))
		to_chat(user, "[icon2html(src, user)] [SPAN_WARNING("目标区域似乎超出边界，请检查坐标。")]")
		return

	if(protected_by_pylon(TURF_PROTECTION_OB, T))
		to_chat(user, "[icon2html(src, user)] [SPAN_WARNING("目标区域有强大的生物防护，轨道打击无法到达。")]")
		return

	var/area/A = get_area(T)

	if(istype(A) && CEILING_IS_PROTECTED(A.ceiling, CEILING_DEEP_UNDERGROUND))
		to_chat(user, "[icon2html(src, user)] [SPAN_WARNING("目标区域位于地下深处，轨道打击无法到达。")]")
		return


	//All set, let's do this.
	busy = TRUE
	visible_message("[icon2html(src, viewers(src))] [SPAN_BOLDNOTICE("[current_squad]小队的轨道轰炸请求已接受，轨道炮正在校准。")]")
	playsound(T,'sound/effects/alert.ogg', 25, 1)  //Placeholder
	addtimer(CALLBACK(src, TYPE_PROC_REF(/obj/structure/machinery/computer/overwatch, alert_ob), T), 2 SECONDS)
	addtimer(CALLBACK(src, TYPE_PROC_REF(/obj/structure/machinery/computer/overwatch, begin_fire)), 6 SECONDS)
	addtimer(CALLBACK(src, TYPE_PROC_REF(/obj/structure/machinery/computer/overwatch, fire_bombard), user, T), 6 SECONDS + 6)

/obj/structure/machinery/computer/overwatch/proc/begin_fire()
	for(var/mob/living/carbon/H in GLOB.alive_mob_list)
		if(is_mainship_level(H.z) && !H.stat) //USS Almayer decks.
			to_chat(H, SPAN_WARNING("轨道炮向殖民地开火，[MAIN_SHIP_NAME]的甲板随之震动。"))
			if(H.client)
				shake_camera(H, 10, 1)
	visible_message("[icon2html(src, viewers(src))] [SPAN_BOLDNOTICE("[current_squad]小队的轨道轰炸已发射！即将命中！")]")
	current_squad.send_message("警告！检测到跨大气层弹道发射！立即撤出近距危险区！")

/obj/structure/machinery/computer/overwatch/proc/fire_bombard(mob/user,turf/T)
	if(!T)
		return

	var/ob_name = lowertext(GLOB.almayer_orbital_cannon.tray.warhead.name)
	var/mutable_appearance/warhead_appearance = mutable_appearance(GLOB.almayer_orbital_cannon.tray.warhead.icon, GLOB.almayer_orbital_cannon.tray.warhead.icon_state)
	notify_ghosts(header = "轨道轰炸来袭", message = "以[get_area(T)]为目标的[ob_name]已发射！", source = T, alert_overlay = warhead_appearance, extra_large = TRUE)

	/// Project ARES interface log.
	log_ares_bombardment(user.name, ob_name, "已向[get_area(T)]发射轨道轰炸，坐标X[x_bomb]、Y[y_bomb]。")

	busy = FALSE
	if(istype(T))
		GLOB.almayer_orbital_cannon.fire_ob_cannon(T, user, current_squad)
		user.count_niche_stat(STATISTICS_NICHE_OB)

/obj/structure/machinery/computer/overwatch/proc/handle_supplydrop()
	SHOULD_NOT_SLEEP(TRUE)
	if(!usr)
		return

	if(busy)
		to_chat(usr, "[icon2html(src, usr)] [SPAN_WARNING("[name]正在处理另一个操作！")]")
		return

	var/obj/structure/closet/crate/crate = locate() in current_squad.drop_pad.loc //This thing should ALWAYS exist.
	if(!istype(crate))
		to_chat(usr, "[icon2html(src, usr)] [SPAN_WARNING("空投平台上未检测到补给箱，请联系补给部！")]")
		return

	var/x_coord = deobfuscate_x(x_supply)
	var/y_coord = deobfuscate_y(y_supply)
	var/z_coord = SSmapping.levels_by_trait(ZTRAIT_GROUND)
	if(length(z_coord))
		z_coord = z_coord[1]
	else
		z_coord = 1 // fuck it

	var/turf/T = locate(x_coord, y_coord, z_coord)
	if(!T)
		to_chat(usr, "[icon2html(src, usr)] [SPAN_WARNING("错误：坐标无效。")]")
		return

	var/area/A = get_area(T)
	if(A && CEILING_IS_PROTECTED(A.ceiling, CEILING_PROTECTION_TIER_2))
		to_chat(usr, "[icon2html(src, usr)] [SPAN_WARNING("着陆区位于地下，补给空投无法到达。")]")
		return

	if(istype(T, /turf/open/space) || T.density)
		to_chat(usr, "[icon2html(src, usr)] [SPAN_WARNING("着陆区似乎被遮挡或超出边界，投下的补给包会丢失。")]")
		return

	if(crate.opened)
		to_chat(usr, "[icon2html(src, usr)] [SPAN_WARNING("补给箱未在空投平台上妥善固定，请让补给部关上箱子！")]")
		return

	busy = TRUE
	crate.visible_message(SPAN_WARNING("[crate]正装入发射管，请退开！"))
	SEND_SIGNAL(crate, COMSIG_STRUCTURE_CRATE_SQUAD_LAUNCHED, current_squad)
	COOLDOWN_START(current_squad, next_supplydrop, 500 SECONDS)
	if(ismob(usr))
		var/mob/M = usr
		M.count_niche_stat(STATISTICS_NICHE_CRATES)

	playsound(crate.loc,'sound/effects/bamf.ogg', 50, 1)  //Ehh
	var/obj/structure/droppod/supply/pod = new(null, crate)
	pod.launch(T)
	log_ares_requisition("Supply Drop", "Launch [crate.name] to X[x_supply], Y[y_supply].", usr.real_name)
	log_game("[key_name(usr)] launched supply drop '[crate.name]' to X[x_coord], Y[y_coord].")
	visible_message("[icon2html(src, viewers(src))] [SPAN_BOLDNOTICE("“[crate.name]”补给空投已发射！五分钟后可再次发射。")]")
	busy = FALSE

/obj/structure/machinery/computer/overwatch/almayer
	density = FALSE
	icon = 'icons/obj/structures/machinery/computer.dmi'
	icon_state = "overwatch"

/obj/structure/machinery/computer/overwatch/almayer/broken
	name = "损坏的战术指挥控制台"

/obj/structure/machinery/computer/overwatch/almayer/small
	icon = 'icons/obj/vehicles/interiors/arc.dmi'
	icon_state = "overwatch_computer"

/obj/structure/machinery/computer/overwatch/clf
	faction = FACTION_CLF
/obj/structure/machinery/computer/overwatch/upp
	faction = FACTION_UPP
/obj/structure/machinery/computer/overwatch/pmc
	faction = FACTION_PMC
/obj/structure/machinery/computer/overwatch/twe
	faction = FACTION_TWE
/obj/structure/machinery/computer/overwatch/freelance
	faction = FACTION_FREELANCER

/obj/structure/machinery/computer/overwatch/toc
	name = "战术行动中心战术指挥控制台"
	desc = "战术行动中心的战术指挥控制台，由许多不同屏幕组成。"
	icon = 'icons/obj/structures/machinery/toc.dmi'
	icon_state = "toc"
	bound_width = 64
	bound_height = 32
	layer = ABOVE_TABLE_LAYER
	density = TRUE

/obj/structure/machinery/computer/overwatch/upp/toc
	name = "战术行动中心战术指挥控制台"
	desc = "战术行动中心的战术指挥控制台，由许多不同屏幕组成。"
	icon = 'icons/obj/structures/machinery/toc_upp.dmi'
	icon_state = "toc"
	bound_width = 64
	bound_height = 32
	layer = ABOVE_TABLE_LAYER
	density = TRUE

/obj/structure/supply_drop
	name = "补给空投平台"
	desc = "将箱子放在这里，舰桥的战术指挥军官就能把它空投到别人头上。"
	icon = 'icons/effects/warning_stripes.dmi'
	anchored = TRUE
	density = FALSE
	unslashable = TRUE
	unacidable = TRUE
	plane = FLOOR_PLANE
	layer = 2.1 //It's the floor, man
	var/squad = SQUAD_MARINE_1
	var/sending_package = 0

/obj/structure/supply_drop/ex_act(severity, direction)
	return FALSE

/obj/structure/supply_drop/Initialize(mapload, ...)
	. = ..()
	GLOB.supply_drop_list += src

/obj/structure/supply_drop/Destroy()
	GLOB.supply_drop_list -= src
	return ..()

/obj/structure/supply_drop/alpha
	icon_state = "alphadrop"
	squad = SQUAD_MARINE_1

/obj/structure/supply_drop/alpha/Initialize(mapload, ...)
	. = ..()

	RegisterSignal(SSdcs, COMSIG_GLOB_PLATOON_NAME_CHANGE, PROC_REF(rename_platoon))

/obj/structure/supply_drop/alpha/proc/rename_platoon(datum/source, new_name, old_name)
	SIGNAL_HANDLER

	squad = new_name

/obj/structure/supply_drop/bravo
	icon_state = "bravodrop"
	squad = SQUAD_MARINE_2

/obj/structure/supply_drop/charlie
	icon_state = "charliedrop"
	squad = SQUAD_MARINE_3

/obj/structure/supply_drop/delta
	icon_state = "deltadrop"
	squad = SQUAD_MARINE_4

/obj/structure/supply_drop/echo //extra supply drop pad
	icon_state = "echodrop"
	squad = SQUAD_MARINE_5

#undef HIDE_ALMAYER
#undef HIDE_GROUND
#undef HIDE_NONE
