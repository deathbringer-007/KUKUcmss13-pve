

/mob/verb/mode()
	set name = "使用手持物品"
	set category = "Object"
	set src = usr

	if (usr.is_mob_incapacitated())
		return

	if(hand)
		var/obj/item/W = l_hand
		if (W)
			W.attack_self(src)
			update_inv_l_hand()
	else
		var/obj/item/W = r_hand
		if (W)
			W.attack_self(src)
			update_inv_r_hand()
	if(next_move < world.time)
		next_move = world.time + 2
	return

/mob/verb/toggle_normal_throw()
	set name = "切换普通投掷"
	set category = "IC"
	set hidden = TRUE
	set src = usr

	to_chat(usr, SPAN_DANGER("此类角色无法投掷物品。"))
	return

/mob/verb/view_stats()
	set category = "OOC.Records"
	set name = "查看游玩时长"
	set desc = "查看你的游玩时长。"
	if(!SSentity_manager.ready)
		to_chat(src, "数据库仍在启动，请稍候。")
		return
	if(client && client.player_entity)
		client.player_data.tgui_interact(src)

/mob/verb/toggle_high_toss()
	set name = "切换高抛"
	set category = "IC"
	set hidden = TRUE
	set src = usr

	to_chat(usr, SPAN_DANGER("此类角色无法投掷物品。"))
	return

/mob/proc/point_to(atom/target in view())
	//set name = "Point To"
	//set category = "Object"

	if(!isturf(src.loc) || !(target in view(src)))//target is no longer visible to us
		return FALSE

	if(!target.mouse_opacity)//can't click it? can't point at it.
		return FALSE

	if(is_mob_incapacitated() || (status_flags & FAKEDEATH)) //incapacitated, can't point
		return FALSE

	var/tile = get_turf(target)
	if(!tile)
		return FALSE

	if(recently_pointed_to > world.time)
		return FALSE

	if(SEND_SIGNAL(src, COMSIG_MOB_TRY_POINT, target) & COMPONENT_OVERRIDE_POINT)
		return FALSE

	next_move = world.time + 2

	point_to_atom(target, tile)
	return TRUE

/mob/verb/memory()
	set name = "笔记"
	set category = "IC"
	if(mind)
		mind.show_memory(src)
	else
		to_chat(src, "游戏似乎丢失了你的心智数据，无法显示笔记。")

/mob/verb/add_memory(msg as message)
	set name = "添加笔记"
	set category = "IC"

	msg = copytext(msg, 1, MAX_MESSAGE_LEN)
	msg = sanitize(msg)

	if(mind)
		if(length(mind.memory) < 4000)
			mind.store_memory(msg)
		else
			message_admins("[key_name(usr)] warned for attempting to exceed mob memory limit.]", loc.x, loc.y, loc.z)
			to_chat(src, "你已达到笔记容量上限！")
	else
		to_chat(src, "游戏似乎丢失了你的心智数据，无法显示笔记。")

/mob/verb/abandon_mob()
	set name = "重生"
	set category = "OOC"

	var/is_admin = 0
	if(client.admin_holder && (client.admin_holder.rights & R_ADMIN))
		is_admin = 1

	if (!CONFIG_GET(flag/respawn) && !is_admin)
		to_chat(usr, SPAN_NOTICE("重生已禁用。"))
		return
	if (stat != 2)
		to_chat(usr, SPAN_NOTICE("<B>必须死亡后才能使用此操作！</B>"))
		return
	if (SSticker.mode && (SSticker.mode.name == "meteor" || SSticker.mode.name == "epidemic")) //BS12 EDIT
		to_chat(usr, SPAN_NOTICE("当前回合类型已禁用重生。"))
		return
	else
		var/deathtime = world.time - src.timeofdeath
		var/deathtimeminutes = floor(deathtime / 600)
		var/pluralcheck = "分钟"
		if(deathtimeminutes == 0)
			pluralcheck = ""
		else if(deathtimeminutes == 1)
			pluralcheck = "[deathtimeminutes]分钟零"
		else if(deathtimeminutes > 1)
			pluralcheck = "[deathtimeminutes]分钟零"
		var/deathtimeseconds = round((deathtime - deathtimeminutes * 600) / 10,1)
		to_chat(usr, "你已经死亡[pluralcheck][deathtimeseconds]秒。")

	if(alert("确定要重生吗？",,"是","否") != "是")
		return

	log_game("[usr.name]/[usr.key] used abandon mob.")

	to_chat(usr, SPAN_NOTICE("<B>请使用不同的角色，并认真进行角色扮演！</B>"))

	if(!client)
		log_game("[usr.key] AM failed due to disconnect.")
		return
	client.screen.Cut()
	if(!client)
		log_game("[usr.key] AM failed due to disconnect.")
		return

	var/mob/new_player/M = new /mob/new_player()
	if(!client)
		log_game("[usr.key] AM failed due to disconnect.")
		qdel(M)
		return

	M.key = key
	if(M.client) M.client.change_view(GLOB.world_view_size)
// M.Login() //wat
	return

/mob/dead/observer/verb/observe()
	set name = "观察"
	set category = "Ghost"

	reset_perspective(null)

	var/mob/target = tgui_input_list(usr, "请选择一名人类角色：", "观察", GLOB.human_mob_list)
	if(!target)
		return

	do_observe(target)

/mob/verb/cancel_camera()
	set name = "退出摄像视角"
	set category = "Object"
	reset_view(null)
	unset_interaction()
	if(istype(src, /mob/living))
		var/mob/living/M = src
		if(M.cameraFollow)
			M.cameraFollow = null

/mob/verb/eastface()
	set hidden = TRUE
	return face_dir(EAST)

/mob/verb/westface()
	set hidden = TRUE
	return face_dir(WEST)

/mob/verb/northface()
	set hidden = TRUE
	return face_dir(NORTH)

/mob/verb/southface()
	set hidden = TRUE
	return face_dir(SOUTH)


/mob/verb/northfaceperm()
	set hidden = TRUE
	set_face_dir(NORTH)

/mob/verb/southfaceperm()
	set hidden = TRUE
	set_face_dir(SOUTH)

/mob/verb/eastfaceperm()
	set hidden = TRUE
	set_face_dir(EAST)

/mob/verb/westfaceperm()
	set hidden = TRUE
	set_face_dir(WEST)



/mob/verb/stop_pulling_verb()

	set name = "停止拖拽"
	set category = "IC"

	stop_pulling()
