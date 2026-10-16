//------------------------------------------------------
//------------------------VERBS-------------------------
//This file contains all basic verbs that vehicles contain


//Used to swap which module a position is using
//e.g. swapping primary gunner from the minigun to the smoke launcher
/obj/vehicle/multitile/proc/switch_hardpoint()
	set name = "切换当前挂载模块"
	set category = "载具"

	var/mob/M = usr
	if(!M || !istype(M))
		return

	var/obj/vehicle/multitile/V = M.interactee
	if(!V || !istype(V))
		return

	var/seat = V.get_mob_seat(M)
	if(!seat)
		return

	var/list/usable_hps = V.get_activatable_hardpoints(seat)
	if(!LAZYLEN(usable_hps))
		to_chat(M, SPAN_WARNING("没有可启用的挂载模块，或者它们都已损坏。"))
		return

	var/obj/item/hardpoint/HP = tgui_input_list(usr, "选择一个挂载模块。", "切换挂载模块", usable_hps)
	if(!HP)
		return

	var/obj/item/hardpoint/old_HP = V.active_hp[seat]
	if(old_HP)
		SEND_SIGNAL(old_HP, COMSIG_GUN_INTERRUPT_FIRE) //stop fire when switching away from HP

	V.active_hp[seat] = HP
	var/msg = "你选择了[HP]。"
	if(HP.ammo)
		msg += " 弹药：<b>[SPAN_HELPFUL(HP.ammo.current_rounds)]/[SPAN_HELPFUL(HP.ammo.max_rounds)]</b> | 弹匣：<b>[SPAN_HELPFUL(LAZYLEN(HP.backup_clips))]/[SPAN_HELPFUL(HP.max_clips)]</b>"
	to_chat(M, SPAN_WARNING(msg))

//cycles through hardpoints in a activatable hardpoints list without asking anything
/obj/vehicle/multitile/proc/cycle_hardpoint()
	set name = "循环切换挂载模块"
	set category = "载具"

	var/mob/M = usr
	if(!M || !istype(M))
		return

	var/obj/vehicle/multitile/V = M.interactee
	if(!istype(V))
		return

	var/seat = V.get_mob_seat(M)
	if(!seat)
		return

	var/list/usable_hps = V.get_activatable_hardpoints(seat)
	if(!LAZYLEN(usable_hps))
		to_chat(M, SPAN_WARNING("没有可启用的挂载模块，或者它们都已损坏。"))
		return
	var/new_hp = usable_hps.Find(V.active_hp[seat])
	if(!new_hp)
		new_hp = 0

	new_hp = (new_hp % length(usable_hps)) + 1
	var/obj/item/hardpoint/HP = usable_hps[new_hp]
	if(!HP)
		return

	var/obj/item/hardpoint/old_HP = V.active_hp[seat]
	if(old_HP)
		SEND_SIGNAL(old_HP, COMSIG_GUN_INTERRUPT_FIRE) //stop fire when switching away from HP

	V.active_hp[seat] = HP
	var/msg = "你选择了[HP]。"
	if(HP.ammo)
		msg += " 弹药：<b>[SPAN_HELPFUL(HP.ammo.current_rounds)]/[SPAN_HELPFUL(HP.ammo.max_rounds)]</b> | 弹匣：<b>[SPAN_HELPFUL(LAZYLEN(HP.backup_clips))]/[SPAN_HELPFUL(HP.max_clips)]</b>"
	to_chat(M, SPAN_WARNING(msg))

// Used to lock/unlock the vehicle doors to anyone without proper access
/obj/vehicle/multitile/proc/toggle_door_lock()
	set name = "切换车门锁"
	set category = "载具"

	var/mob/M = usr
	if(!M || !istype(M))
		return

	var/obj/vehicle/multitile/V = M.interactee
	if(!istype(V))
		return

	var/seat = V.get_mob_seat(M)
	if(!seat)
		return
	if(seat == VEHICLE_GUNNER) //Driver and Commander (if present) can control this
		return

	V.door_locked = !V.door_locked
	to_chat(M, SPAN_NOTICE("你[V.door_locked ? "锁上" : "解锁"]了车门。"))

//opens vehicle status window with HP and ammo of hardpoints
/obj/vehicle/multitile/proc/get_status_info()
	set name = "查看状态信息"
	set desc = "在小窗口中显示载具的全部可用信息。"
	set category = "载具"

	var/mob/user = usr
	if(!istype(user))
		return

	var/obj/vehicle/multitile/V = user.interactee
	if(!istype(V))
		return

	var/seat
	for(var/vehicle_seat in V.seats)
		if(V.seats[vehicle_seat] == user)
			seat = vehicle_seat
			break
	if(!seat)
		return

	V.tgui_interact(user)

// BEGIN TGUI \\

/obj/vehicle/multitile/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "VehicleStatus", "[name]")
		ui.open()

/obj/vehicle/multitile/ui_data(mob/user)
	var/list/data = list()

	var/list/resist_name = list("Bio" = "acid", "Slash" = "slash", "Bullet" = "bullet", "Expl" = "explosive", "Blunt" = "blunt")
	var/list/resist_data_list = list()

	for(var/i in resist_name)
		var/resist = 1 - LAZYACCESS(dmg_multipliers, LAZYACCESS(resist_name, i))
		resist_data_list += list(list(
			"name" = i,
			"pct" = resist
		))

	data["resistance_data"] = resist_data_list
	data["integrity"] = floor(100 * health / initial(health))
	data["door_locked"] = door_locked
	data["total_passenger_slots"] = interior.passengers_slots
	data["total_taken_slots"] = interior.passengers_taken_slots

	var/list/passenger_category_data_list = list()

	for(var/datum/role_reserved_slots/RRS in interior.role_reserved_slots)
		passenger_category_data_list += list(list(
			"name" = RRS.category_name,
			"taken" = RRS.taken,
			"total" = RRS.total
		))

	data["passenger_categories_data"] = passenger_category_data_list

	var/list/hps = hardpoints.Copy()
	var/list/hardpoint_data_list = list()

	for(var/obj/item/hardpoint/holder/H in hps)
		hardpoint_data_list += H.get_tgui_info()
		LAZYREMOVE(hps, H)
	for(var/obj/item/hardpoint/H in hps)
		hardpoint_data_list += list(H.get_tgui_info())

	data["hardpoint_data"] = hardpoint_data_list

	return data

/obj/vehicle/multitile/ui_state(mob/user)
	return GLOB.not_incapacitated_state

// END TGUI \\

//opens vehicle controls guide, that contains description of all verbs and shortcuts in it
/obj/vehicle/multitile/proc/open_controls_guide()
	set name = "车辆操作指南"
	set desc = "首次扮演车组成员或版本更新后必读。"
	set category = "载具"

	var/mob/user = usr
	if(!istype(user))
		return

	var/obj/vehicle/multitile/V = user.interactee
	if(!istype(V))
		return

	var/seat
	for(var/vehicle_seat in V.seats)
		if(V.seats[vehicle_seat] == user)
			seat = vehicle_seat
			break
	if(!seat)
		return

	var/dat = "<b><i>通用操作：</i></b><br>1. <b>“A：切换当前挂载模块”</b>——列出你能操作且尚未被摧毁的可启用挂载模块，并允许选择当前模块。点击目标即可使用选中的模块。<font color='#cd6500'><b>务必避免击中陆战队员。</b></font><br>\
	2. <b>“G：命名载具”</b>——为载具添加自定义名称。只能使用一次，最多26个字符。<br> \
	3. <b>“I：查看状态信息”</b>——打开“载具状态信息”窗口，查看载具的全部可用信息。<br> \
	<font color='#cd6500'><b><i>驾驶员操作：</i></b></font><br> 1. <b>“G：鸣笛”</b>——启动载具喇叭。请注意，喇叭非常响，远处的敌我双方都能听到。<br> \
	2. <b>“G：切换车门锁”</b>——切换载具的出入权限限制。车组、禁闭室及指挥权限可绕过限制。<br> \
	<font color=\"red\"><b><i>炮手操作：</i></b></font><br> 1. <b>“A：循环切换挂载模块”</b>——与上面的切换功能类似，但会自动切换到列表中的下一个模块，操作更快捷。<br> \
	2. <b>“G：切换炮塔陀螺稳定器”</b>——切换炮塔陀螺稳定器，使炮塔在车体转向时保持当前朝向。<i>（仅适用于有旋转炮塔的载具，例如M34A2“朗斯特里特”轻型坦克。）</i><br> \
	<font color='#003300'><b><i>支援机枪手操作：</i></b></font><br> 1. <b>“装填射击孔武器”</b>——启动M56射击孔武器的自动装填程序，需要确认。<br> \
	<font color='#cd6500'><b><i>驾驶员快捷键：</i></b></font><br> 1. <b>“CTRL + 单击”</b>——鸣笛。<br> \
	<font color=\"red\"><b><i>炮手快捷键：</i></b></font><br> 1. <b>“ALT + 单击”</b>——切换炮塔陀螺稳定器。<i>（仅适用于有旋转炮塔的载具，例如M34A2“朗斯特里特”轻型坦克。）</i><br>"

	show_browser(user, dat, "车辆操作指南", "vehicle_help", width = 900, height = 500)
	onclose(user, "vehicle_help")
	return

//toggles gyrostabilizer for vehicles that have turret, allowing it to keep direction regardless hull rotations
/obj/vehicle/multitile/proc/toggle_gyrostabilizer()
	set name = "切换炮塔陀螺稳定器"
	set desc = "切换炮塔陀螺稳定器，使炮塔可独立于车体朝向运动。"
	set category = "载具"

	var/mob/M = usr
	if(!M || !istype(M))
		return

	var/obj/vehicle/multitile/V = M.interactee
	if(!istype(V))
		return

	var/obj/item/hardpoint/holder/tank_turret/T = null
	for(var/obj/item/hardpoint/holder/tank_turret/TT in V.hardpoints)
		T = TT
		break
	if(!T)
		return
	T.toggle_gyro(usr)

	var/obj/item/hardpoint/holder/apc_turret/A = null
	for(var/obj/item/hardpoint/holder/apc_turret/AT in V.hardpoints)
		A = AT
		break
	if(!A)
		return
	A.toggle_gyro(usr)

//single use verb that allows VCs to add a nickname in "" at the end of their vehicle name
/obj/vehicle/multitile/proc/name_vehicle()
	set name = "命名载具"
	set desc = "为载具添加自定义名称。只能使用一次，最多26个字符。"
	set category = "载具"

	var/mob/user = usr
	if(!istype(user))
		return

	var/obj/vehicle/multitile/V = user.interactee
	if(!istype(V))
		return

	var/seat
	for(var/vehicle_seat in V.seats)
		if(V.seats[vehicle_seat] == user)
			seat = vehicle_seat
			break
	if(!seat)
		return

	if(V.nickname)
		to_chat(user, SPAN_WARNING("载具已经有了“[V.nickname]”这个昵称。"))
		return

	var/new_nickname = stripped_input(user, "输入一个符合角色扮演设定的独特名称或呼号，添加到载具名称后。最多[MAX_NAME_LEN]个字符。\n\n注意！这是载具在游戏世界中的昵称或呼号，使用网络梗命名会受到处罚。\n只能命名一次。", "命名载具", null, MAX_NAME_LEN)
	if(!new_nickname)
		return
	if(length(new_nickname) > MAX_NAME_LEN)
		alert(user, "名称[new_nickname]超过了[MAX_NAME_LEN]个字符的限制，请重试。", "载具命名失败", "确定")
		return
	if(alert(user, "载具名称将变为[V.name + "\"[new_nickname]\""]。确定吗？", "确认命名", "是", "否") != "是")
		return

	//post-checks
	if(V.seats[seat] != user) //check that we are still in seat
		to_chat(user, SPAN_WARNING("你必须坐在载具座椅上并系好安全带才能这样做。"))
		return

	if(V.nickname) //check again if second VC was faster.
		to_chat(user, SPAN_WARNING("另一位车组成员已经抢先命名了！"))
		return

	V.nickname = new_nickname
	V.name = initial(V.name) + " \"[V.nickname]\""
	to_chat(user, SPAN_NOTICE("你为载具添加了昵称“[V.nickname]”。"))

	message_admins(WRAP_STAFF_LOG(user, "added \"[V.nickname]\" nickname to their [initial(V.name)]. ([V.x],[V.y],[V.z])"), V.x, V.y, V.z)

	V.initialize_cameras(TRUE)

//Activates vehicle horn. Yes, it is annoying.
/obj/vehicle/multitile/proc/activate_horn()
	set name = "鸣笛"
	set desc = "启动载具喇叭。嘀嘀。"
	set category = "载具"

	var/mob/user = usr
	if(!istype(user))
		return

	var/obj/vehicle/multitile/V = user.interactee
	if(!istype(V))
		return

	var/seat
	for(var/vehicle_seat in V.seats)
		if(V.seats[vehicle_seat] == user)
			seat = vehicle_seat
			break
	if(!seat)
		return

	if(world.time < V.next_honk)
		to_chat(user, SPAN_WARNING("你需要等待[(V.next_honk - world.time) / 10]秒。"))
		return

	V.next_honk = world.time + 10 SECONDS
	to_chat(user, SPAN_NOTICE("你按响了载具喇叭。"))
	V.perform_honk()

/obj/vehicle/multitile/proc/perform_honk()
	if(honk_sound)
		playsound(loc, honk_sound, 75, TRUE, 15) //heard within ~15 tiles

//Support gunner verbs

/obj/vehicle/multitile/proc/reload_firing_port_weapon()
	set name = "装填射击孔武器"
	set desc = "启动射击孔武器的自动装填程序。"
	set category = "载具"

	var/mob/user = usr
	if(!user || !istype(user))
		return

	var/obj/vehicle/multitile/V = user.interactee
	if(!istype(V))
		return

	var/seat
	for(var/vehicle_seat in V.seats)
		if(V.seats[vehicle_seat] == user)
			seat = vehicle_seat
			break

	if(!seat)
		return

	if(V.health < initial(V.health) * 0.5)
		to_chat(user, SPAN_WARNING("[V]的车体损坏过于严重，无法操作！"))

	for(var/obj/item/hardpoint/special/firing_port_weapon/FPW in V.hardpoints)
		if(FPW.allowed_seat == seat)
			if(alert(user, "启动M56射击孔武器装填程序吗？需要[FPW.reload_time / 10]秒。", "开始装填", "是", "否") == "是")
				FPW.start_auto_reload(user)
			return

	to_chat(user, SPAN_WARNING("警告：找不到[seat]对应的射击孔武器，请向开发者报告！"))

