//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:33
/mob/new_player
	var/ready = FALSE
	var/spawning = FALSE//Referenced when you want to delete the new_player later on in the code.

	invisibility = 101

	density = FALSE
	anchored = TRUE
	universal_speak = TRUE
	stat = DEAD

/mob/new_player/Initialize()
	. = ..()
	GLOB.new_player_list += src
	GLOB.dead_mob_list -= src
	ADD_TRAIT(src, TRAIT_IMMOBILIZED, TRAIT_SOURCE_INHERENT)

/mob/new_player/Destroy()
	if(ready)
		GLOB.readied_players--
	GLOB.new_player_list -= src
	return ..()

/mob/new_player/verb/new_player_panel()
	set src = usr
	if(client && client.player_entity)
		client.player_entity.update_panel_data(null)
		new_player_panel_proc()


/mob/new_player/proc/new_player_panel_proc(refresh = FALSE)
	if(!client)
		return

	var/tempnumber = rand(1, 999)
	var/postfix_text = (client.xeno_postfix) ? ("-"+client.xeno_postfix) : ""
	var/prefix_text = (client.xeno_prefix) ? client.xeno_prefix : "XX"
	var/xeno_text = "[prefix_text]-[tempnumber][postfix_text]"
	var/round_start = !SSticker || !SSticker.mode || SSticker.current_state <= GAME_STATE_PREGAME

	var/output = "<div align='center'>欢迎，"
	output +="<br><b>[(client.prefs && client.prefs.real_name) ? client.prefs.real_name : client.key]</b>"
	output +="<br><b>[xeno_text]</b>"
	output += "<p><a href='byond://?src=\ref[src];lobby_choice=tutorial'>教程</A></p>"
	output += "<p><a href='byond://?src=\ref[src];lobby_choice=show_preferences'>创建角色</A></p>"

	output += "<p><a href='byond://?src=\ref[src];lobby_choice=show_playtimes'>查看游玩时长</A></p>"

	if(round_start)
		output += "<p>\[ [ready? "<b>已准备</b>":"<a href='byond://?src=\ref[src];lobby_choice=ready'>准备</a>"] | [ready? "<a href='byond://?src=\ref[src];lobby_choice=unready'>取消准备</a>":"<b>未准备</b>"] \]</p>"
		output += "<b>扮演异形：</b> [(client.prefs && (client.prefs.get_job_priority(JOB_XENOMORPH))) ? "是" : "否"]"

	else
		output += "<a href='byond://?src=\ref[src];lobby_choice=manifest'>查看船员名册</A><br><br>"
/*
// commented out tutorial due to their lack of relevance/use on pve
		output += "<a href='byond://?src=\ref[src];lobby_choice=hiveleaders'>View Hive Leaders</A><br><br>"
*/
		output += "<p><a href='byond://?src=\ref[src];lobby_choice=late_join'>加入本回合！</A></p>"
/*
		output += "<p><a href='byond://?src=\ref[src];lobby_choice=late_join_xeno'>Join the Hive!</A></p>"
		if(SSticker.mode.flags_round_type & MODE_PREDATOR)
			if(SSticker.mode.check_predator_late_join(src,0)) output += "<p><a href='byond://?src=\ref[src];lobby_choice=late_join_pred'>Join the Hunt!</A></p>"
*/
	output += "<p><a href='byond://?src=\ref[src];lobby_choice=observe'>旁观</A></p>"

	output += "</div>"
	if (refresh)
		close_browser(src, "playersetup")
	show_browser(src, output, null, "playersetup", "size=240x[round_start ? 500 : 610];can_close=0;can_minimize=0")
	return

/mob/new_player/Topic(href, href_list[])
	. = ..()
	if(.)
		return
	if(!client)
		return

	switch(href_list["lobby_choice"])
		if("show_preferences")
			// Otherwise the preview dummy will runtime
			// because atoms aren't initialized yet
			if(SSticker.current_state < GAME_STATE_PREGAME)
				to_chat(src, "游戏仍在初始化，请稍候。")
				return
			if(!SSentity_manager.ready)
				to_chat(src, "数据库仍在初始化，请稍候。")
				return
			client.prefs.ShowChoices(src)
			return 1

		if("show_playtimes")
			if(!SSentity_manager.ready)
				to_chat(src, "数据库仍在初始化，请稍候。")
				return
			if(client.player_data)
				client.player_data.tgui_interact(src)
			return 1

		if("ready")
			if( (SSticker.current_state <= GAME_STATE_PREGAME) && !ready) // Make sure we don't ready up after the round has started
				ready = TRUE
				GLOB.readied_players++

			new_player_panel_proc()

		if("unready")
			if((SSticker.current_state <= GAME_STATE_PREGAME) && ready) // Make sure we don't ready up after the round has started
				ready = FALSE
				GLOB.readied_players--

			new_player_panel_proc()

		if("refresh")
			new_player_panel_proc(TRUE)

		if("observe")
			if(!SSticker || SSticker.current_state == GAME_STATE_STARTUP)
				to_chat(src, SPAN_WARNING("游戏仍在初始化，请稍后重试。"))
				return
			if(alert(src,"Are you sure you wish to observe? When you observe, you will not be able to join as marine. It might also take some time to become a xeno or responder!","Player Setup","Yes","No") == "Yes")
				if(!client)
					return TRUE
				if(!client.prefs?.preview_dummy)
					client.prefs.update_preview_icon()
				var/mob/dead/observer/observer = new /mob/dead/observer(get_turf(pick(GLOB.latejoin)), client.prefs.preview_dummy)
				observer.set_lighting_alpha_from_pref(client)
				spawning = TRUE
				observer.started_as_observer = TRUE

				close_spawn_windows()

				var/obj/effect/landmark/observer_start/O = SAFEPICK(GLOB.observer_starts)
				if(istype(O))
					to_chat(src, SPAN_NOTICE("正在传送。"))
					observer.forceMove(O.loc)
				else
					to_chat(src, SPAN_DANGER("无法找到观察者出生点。请使用传送指令前往地图。"))
				observer.icon = 'icons/mob/humans/species/r_human.dmi'
				observer.icon_state = "anglo_example"
				observer.alpha = 127

				if(client.prefs.be_random_name)
					client.prefs.real_name = random_name(client.prefs.gender)
				observer.real_name = client.prefs.real_name
				observer.name = observer.real_name

				mind.transfer_to(observer, TRUE)

				if(observer.client)
					observer.client.change_view(GLOB.world_view_size)

				observer.set_huds_from_prefs()

				qdel(src)
				return TRUE

		if("late_join")

			if(SSticker.current_state != GAME_STATE_PLAYING || !SSticker.mode)
				to_chat(src, SPAN_WARNING("回合尚未就绪，或已经结束……"))
				return

			if(SSticker.mode.flags_round_type & MODE_NO_LATEJOIN)
				to_chat(src, SPAN_WARNING("抱歉，[localized_player_label(SSticker.mode.name)]模式不允许中途加入，必须从回合开始时参与。你可以观察，或在允许时尝试作为异形加入。"))
				return

			// commented out tutorial due to its lack of relevance on pve
			//if(client.player_data?.playtime_loaded && (client.get_total_human_playtime() < CONFIG_GET(number/notify_new_player_age)) && !length(client.prefs.completed_tutorials))
				//if(tgui_alert(src, "You have little playtime and haven't completed any tutorials. Would you like to go to the tutorial menu?", "Tutorial", list("Yes", "No")) == "Yes")
					//tutorial_menu()
					//return

			LateChoices()

/*
// commented out tutorial due to their lack of relevance on pve
		if("late_join_xeno")
			if(SSticker.current_state != GAME_STATE_PLAYING || !SSticker.mode)
				to_chat(src, SPAN_WARNING("The round is either not ready, or has already finished..."))
				return

			if(alert(src,"Are you sure you want to attempt joining as a xenomorph?","Confirmation","Yes","No") == "Yes" )
				if(SSticker.mode.check_xeno_late_join(src))
					var/mob/new_xeno = SSticker.mode.attempt_to_join_as_xeno(src, 0)
					if(new_xeno && !istype(new_xeno, /mob/living/carbon/xenomorph/larva))
						SSticker.mode.transfer_xeno(src, new_xeno)
						close_spawn_windows()

		if("late_join_pred")
			if(SSticker.current_state != GAME_STATE_PLAYING || !SSticker.mode)
				to_chat(src, SPAN_WARNING("The round is either not ready, or has already finished..."))
				return

			if(alert(src,"Are you sure you want to attempt joining as a predator?","Confirmation","Yes","No") == "Yes" )
				if(SSticker.mode.check_predator_late_join(src,0))
					close_spawn_windows()
					SSticker.mode.attempt_to_join_as_predator(src)
				else
					to_chat(src, SPAN_WARNING("You are no longer able to join as predator."))
					new_player_panel()
*/

		if("manifest")
			ViewManifest()

		if("hiveleaders")
			ViewHiveLeaders()

		if("SelectedJob")

			if(!GLOB.enter_allowed)
				to_chat(usr, SPAN_WARNING("管理员已暂时锁定加入功能！（运输艇可能撞上了阿尔迈耶号，此状态通常不会超过20分钟。）"))
				return

			AttemptLateSpawn(href_list["job_selected"])
			return

		if("tutorial")
			tutorial_menu()

		else
			new_player_panel()

/mob/new_player/proc/tutorial_menu()
	if(SSticker.current_state <= GAME_STATE_SETTING_UP)
		to_chat(src, SPAN_WARNING("请等待回合开始后再进入教程。"))
		return

	if(SSticker.current_state == GAME_STATE_FINISHED)
		to_chat(src, SPAN_WARNING("本回合已结束，请等待下一回合再进入教程。"))
		return

	if(SSticker.tutorial_disabled)
		to_chat(src, SPAN_WARNING("抱歉，教程因故障暂时停用！"))
		return

	var/datum/tutorial_menu/menu = new(src)
	menu.ui_interact(src)

/mob/new_player/proc/AttemptLateSpawn(rank)
	var/datum/job/player_rank = GLOB.RoleAuthority.roles_for_mode[rank]
	if (src != usr)
		return
	if(SSticker.current_state != GAME_STATE_PLAYING)
		to_chat(usr, SPAN_WARNING("回合尚未就绪，或已经结束！"))
		return
	if(!GLOB.enter_allowed)
		to_chat(usr, SPAN_WARNING("管理员已暂时锁定加入功能！（运输艇可能撞上了阿尔迈耶号，此状态通常不会超过20分钟。）"))
		return
	if(!GLOB.RoleAuthority.assign_role(src, player_rank, 1))
		to_chat(src, alert("[localized_player_label(rank)]职位不可用，请选择其他职位。"))
		return

	spawning = TRUE
	close_spawn_windows()

	var/mob/living/carbon/human/character = create_character(TRUE) //creates the human and transfers vars and mind
	GLOB.RoleAuthority.equip_role(character, player_rank, late_join = TRUE)

	if((GLOB.security_level > SEC_LEVEL_BLUE || SShijack.hijack_status) && player_rank.gets_emergency_kit)
		to_chat(character, SPAN_HIGHDANGER("你踉跄着离开超眠舱，舱室广播响起：“[SShijack.evac_status ? "舰船正在疏散，已提供自卫套件" : "舰船处于高度警戒状态，已提供自卫套件"]。”"))
		character.put_in_hands(new /obj/item/storage/box/kit/cryo_self_defense(character.loc))

	GLOB.data_core.manifest_inject(character)
	SSticker.minds += character.mind//Cyborgs and AIs handle this in the transform proc. //TODO!!!!! ~Carn
	SSticker.mode.latejoin_update(player_rank)
	SSticker.mode.update_gear_scale()

	for(var/datum/squad/sq in GLOB.RoleAuthority.squads)
		if(sq)
			sq.max_engineers = engi_slot_formula(length(GLOB.clients))
			sq.max_medics = medic_slot_formula(length(GLOB.clients))

	var/latejoin_larva_drop = SSticker.mode.latejoin_larva_drop

	if (ROUND_TIME < XENO_ROUNDSTART_PROGRESS_TIME_2)
		latejoin_larva_drop = SSticker.mode.latejoin_larva_drop_early

	if(latejoin_larva_drop && SSticker.mode.latejoin_tally - SSticker.mode.latejoin_larva_used >= latejoin_larva_drop)
		SSticker.mode.latejoin_larva_used += latejoin_larva_drop
		var/datum/hive_status/hive
		for(var/hivenumber in GLOB.hive_datum)
			hive = GLOB.hive_datum[hivenumber]
			if(hive.latejoin_burrowed == TRUE)
				if(length(hive.totalXenos) && (hive.hive_location || ROUND_TIME < XENO_ROUNDSTART_PROGRESS_TIME_2))
					hive.stored_larva++
					hive.hive_ui.update_burrowed_larva()

	if(character.mind && character.mind.player_entity)
		var/datum/entity/player_entity/player = character.mind.player_entity
		if(player.get_playtime(STATISTIC_HUMAN) == 0 && player.get_playtime(STATISTIC_XENO) == 0)
			msg_admin_niche("NEW JOIN: <b>[key_name(character, 1, 1, 0)]</b>. IP: [character.lastKnownIP], CID: [character.computer_id]")
		if(character.client)
			var/client/client = character.client
			if(client.player_data && client.player_data.playtime_loaded && length(client.player_data.playtimes) == 0)
				msg_admin_niche("NEW PLAYER: <b>[key_name(character, 1, 1, 0)]</b>. IP: [character.lastKnownIP], CID: [character.computer_id]")
			if(client.player_data && client.player_data.playtime_loaded && ((round(client.get_total_human_playtime() DECISECONDS_TO_HOURS, 0.1)) <= CONFIG_GET(number/notify_new_player_age)))
				msg_sea("NEW PLAYER: <b>[key_name(character, 0, 1, 0)]</b> only has [(round(client.get_total_human_playtime() DECISECONDS_TO_HOURS, 0.1))] hours as a human. Current role: [get_actual_job_name(character)] - Current location: [get_area(character)]")

	character.client.init_verbs()
	qdel(src)


/mob/new_player/proc/LateChoices()
	var/mills = world.time // 1/10 of a second, not real milliseconds but whatever
	//var/secs = ((mills % 36000) % 600) / 10 //Not really needed, but I'll leave it here for refrence... or something
	var/mins = (mills % 36000) / 600
	var/hours = mills / 36000

	var/dat = "<html><body onselectstart='return false;'><center>"
	dat += "回合时长：[floor(hours)] 小时 [floor(mins)] 分钟<br>"

	if(SShijack)
		switch(SShijack.evac_status)
			if(EVACUATION_STATUS_INITIATED)
				dat += "<font color='red'><b>[MAIN_SHIP_NAME]正在疏散。</b></font><br>"

	var/positions = FALSE
	var/position_dat = "请选择以下空缺职位：<br>"
	var/roles_show = FLAG_SHOW_ALL_JOBS

	for(var/i in GLOB.RoleAuthority.roles_for_mode)
		var/datum/job/J = GLOB.RoleAuthority.roles_for_mode[i]
		if(!GLOB.RoleAuthority.check_role_entry(src, J, TRUE))
			continue
		var/active = 0
		// Only players with the job assigned and AFK for less than 10 minutes count as active
		for(var/mob/M in GLOB.player_list)
			if(M.client && M.job == J.title)
				active++
		if(roles_show & FLAG_SHOW_CIC && GLOB.ROLES_CIC.Find(J.title))
			dat += "指挥部：<br>"
			roles_show ^= FLAG_SHOW_CIC

		else if(roles_show & FLAG_SHOW_AUXIL_SUPPORT && GLOB.ROLES_AUXIL_SUPPORT.Find(J.title))
			dat += "<hr>辅助战斗支援：<br>"
			roles_show ^= FLAG_SHOW_AUXIL_SUPPORT

		else if(roles_show & FLAG_SHOW_MISC && GLOB.ROLES_MISC.Find(J.title))
			dat += "<hr>其他：<br>"
			roles_show ^= FLAG_SHOW_MISC

		else if(roles_show & FLAG_SHOW_POLICE && GLOB.ROLES_POLICE.Find(J.title))
			dat += "<hr>宪兵：<br>"
			roles_show ^= FLAG_SHOW_POLICE

		else if(roles_show & FLAG_SHOW_ENGINEERING && GLOB.ROLES_ENGINEERING.Find(J.title))
			dat += "<hr>工程部：<br>"
			roles_show ^= FLAG_SHOW_ENGINEERING

		else if(roles_show & FLAG_SHOW_REQUISITION && GLOB.ROLES_REQUISITION.Find(J.title))
			dat += "<hr>军需部：<br>"
			roles_show ^= FLAG_SHOW_REQUISITION

		else if(roles_show & FLAG_SHOW_MEDICAL && GLOB.ROLES_MEDICAL.Find(J.title))
			dat += "<hr>医疗部：<br>"
			roles_show ^= FLAG_SHOW_MEDICAL

		else if(roles_show & FLAG_SHOW_MARINES && GLOB.ROLES_MARINES.Find(J.title))
			dat += "<hr>陆战队：<br>"
			roles_show ^= FLAG_SHOW_MARINES

		positions = TRUE
		position_dat += "<a href='byond://?src=\ref[src];lobby_choice=SelectedJob;job_selected=[J.title]'>[localized_player_label(J.disp_title)] ([J.current_positions]) (活跃： [active])</a><br>"

	dat += positions ? position_dat : "暂无空缺职位。本模式每回合的名额有限。请前往 Discord 了解详情及后续开局时间： [CONFIG_GET(string/discordurl)]"

	dat += "</center>"
	show_browser(src, dat, "中途加入", "latechoices", width = 420, height = 700)


/mob/new_player/proc/create_character(is_late_join = FALSE)
	spawning = TRUE
	close_spawn_windows()

	var/mob/living/carbon/human/new_character

	if(!new_character)
		new_character = new(loc)

	new_character.lastarea = get_area(loc)

	setup_human(new_character, src, is_late_join)

	new_character.client?.change_view(GLOB.world_view_size)

	return new_character

/mob/new_player/proc/ViewManifest()
	var/dat = "<html><body>"
	dat += "<h4><center>船员名册：</center></h4>"
	dat += GLOB.data_core.get_manifest(FALSE, TRUE)

	show_browser(src, dat, "船员名册", "manifest", width = 450, height = 750)

/mob/new_player/proc/ViewHiveLeaders()
	if(!GLOB.hive_leaders_tgui)
		GLOB.hive_leaders_tgui = new /datum/hive_leaders()
	GLOB.hive_leaders_tgui.tgui_interact(src)

/datum/hive_leaders/Destroy(force, ...)
	SStgui.close_uis(src)
	return ..()

/datum/hive_leaders/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "HiveLeaders", "虫巢领袖")
		ui.open()
		ui.set_autoupdate(FALSE)

// Player panel
/datum/hive_leaders/ui_data(mob/user)
	var/list/data = list()

	var/datum/hive_status/main_hive = GLOB.hive_datum[XENO_HIVE_NORMAL]
	var/list/queens = list()
	if(main_hive.living_xeno_queen)
		queens += list(list("designation" = main_hive.living_xeno_queen.full_designation, "caste_type" = main_hive.living_xeno_queen.name))
	data["queens"] = queens
	var/list/leaders = list()
	for(var/mob/living/carbon/xenomorph/xeno_leader in main_hive.xeno_leader_list)
		leaders += list(list("designation" = xeno_leader.full_designation, "caste_type" = xeno_leader.caste_type))
	data["leaders"] = leaders
	return data


/datum/hive_leaders/ui_state(mob/user)
	return GLOB.always_state

/mob/new_player/Move()
	return 0

/mob/proc/close_spawn_windows() // Somehow spawn menu stays open for non-newplayers
	close_browser(src, "latechoices") //closes late choices window
	close_browser(src, "playersetup") //closes the player setup window
	src << sound(null, repeat = 0, wait = 0, volume = 85, channel = SOUND_CHANNEL_LOBBY) // Stops lobby music.
	if(src.open_uis)
		for(var/datum/nanoui/ui in src.open_uis)
			if(ui.allowed_user_stat == -1)
				ui.close()
				continue

/mob/new_player/get_gender()
	if(!client || !client.prefs) ..()
	return client.prefs.gender

/mob/new_player/is_ready()
	return ready && ..()

/mob/new_player/hear_say(message, verb = "说道", datum/language/language = null, alt_name = "", italics = 0, mob/speaker = null)
	return

/mob/new_player/hear_radio(message, verb, datum/language/language, part_a, part_b, mob/speaker, hard_to_hear, vname, command, no_paygrade = FALSE)
	return

/mob/new_player/get_status_tab_items()
	. = ..()
	. += ""
	. += "游戏模式：[localized_player_label(GLOB.master_mode)]"

	if(SSticker.HasRoundStarted())
		return

	var/time_remaining = SSticker.GetTimeLeft()
	if(time_remaining > 0)
		. += "开始倒计时：[floor(time_remaining)]秒[SSticker.delay_start ? "（已延迟）" : ""]"
	else if(time_remaining == -10)
		. += "开始倒计时：已延迟"
	else
		. += "开始倒计时：即将开始"

	. += "玩家数：[SSticker.totalPlayers]"
	if(client.admin_holder)
		. += "已准备玩家数：[SSticker.totalPlayersReady]"
