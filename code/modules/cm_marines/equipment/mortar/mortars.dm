// The Marine mortar, the M402 Mortar
// Works like a contemporary crew weapon mortar
/obj/structure/mortar
	name = "\improper M402 迫击炮"
	desc = "一套由炮组手动操作的迫击炮系统，向瞄准区域倾泻80毫米的“美好问候”。配备先进的瞄准计算机，装入炮弹即可发射。"
	icon = 'icons/obj/structures/mortar.dmi'
	icon_state = "mortar_m402"
	anchored = TRUE
	unslashable = TRUE
	unacidable = TRUE
	density = TRUE
	// So you can't hide it under corpses
	layer = ABOVE_MOB_LAYER
	flags_atom = RELAY_CLICK
	var/computer_enabled = TRUE
	// Initial target coordinates
	var/targ_x = 0
	var/targ_y = 0
	// Automatic offsets from target
	var/offset_x = 0
	var/offset_y = 0
	/// Number of turfs to offset from target by 1
	var/offset_per_turfs = 20
	// Dial adjustments from target
	var/dial_x = 0
	var/dial_y = 0
	/// Constant, assuming perfect parabolic trajectory. ONLY THE DELAY BEFORE INCOMING WARNING WHICH ADDS 45 TICKS
	var/travel_time = 4.5 SECONDS
	var/busy = FALSE
	/// Used for deconstruction and aiming sanity
	var/firing = FALSE
	/// If set to 1, can't unanchor and move the mortar, used for map spawns and WO
	var/fixed = FALSE
	/// if true, blows up the shell immediately, provided there's a ceiling overhead
	var/ship_side = FALSE

	var/obj/structure/machinery/computer/cameras/mortar/internal_camera

	var/has_camo = TRUE

	var/kit_type = /obj/item/mortar_kit

	var/firesound = 'sound/weapons/gun_mortar_fire.ogg'

	var/warning_text = "炮弹正在落下，方位："
	var/close_warning_text = "炮弹即将落地，方位："

/obj/structure/mortar/Initialize()
	. = ..()
	// Makes coords appear as 0 in UI
	targ_x = deobfuscate_x(0)
	targ_y = deobfuscate_y(0)
	internal_camera = new(loc)

	if(has_camo)
		var/new_icon_state
		switch(SSmapping.configs[GROUND_MAP].camouflage_type)
			if("classic")
				icon_state = new_icon_state ? new_icon_state : "c_" + icon_state
			if("desert")
				icon_state = new_icon_state ? new_icon_state : "d_" + icon_state
			if("snow")
				icon_state = new_icon_state ? new_icon_state : "s_" + icon_state
			if("urban")
				icon_state = new_icon_state ? new_icon_state : "u_" + icon_state

/obj/structure/mortar/Destroy()
	QDEL_NULL(internal_camera)
	return ..()

/obj/structure/mortar/initialize_pass_flags(datum/pass_flags_container/PF)
	..()
	if (PF)
		PF.flags_can_pass_all = PASS_OVER

/obj/structure/mortar/get_projectile_hit_boolean(obj/projectile/P)
	if(P.original == src)
		return TRUE
	else
		return FALSE

/obj/structure/mortar/attack_alien(mob/living/carbon/xenomorph/xeno)
	if(islarva(xeno))
		return XENO_NO_DELAY_ACTION

	if(fixed)
		to_chat(xeno, SPAN_XENOWARNING("[src]的支架已用螺栓和焊接固定在地面上，看起来是要永久留在这里了。"))
		return XENO_NO_DELAY_ACTION

	if(firing)
		xeno.animation_attack_on(src)
		xeno.flick_attack_overlay(src, "slash")
		playsound(src, "acid_hit", 25, 1)
		playsound(xeno, "alien_help", 25, 1)
		xeno.apply_damage(10, BURN)
		xeno.visible_message(SPAN_DANGER("[xeno]试图掀翻滚烫的[src]，却被烫得缩了回去！"),
		SPAN_XENOWARNING("[src]烫得厉害！再等几秒。"))
		return XENO_ATTACK_ACTION

	xeno.visible_message(SPAN_DANGER("[xeno]猛击[src]，将其掀翻了！"),
	SPAN_DANGER("你掀翻了[src]！"))
	xeno.animation_attack_on(src)
	xeno.flick_attack_overlay(src, "slash")
	playsound(loc, 'sound/effects/metalhit.ogg', 25)
	var/obj/item/mortar_kit/MK = new /obj/item/mortar_kit(loc)
	MK.name = name
	qdel(src)

	return XENO_ATTACK_ACTION

/obj/structure/mortar/attack_hand(mob/user)
	if(isyautja(user))
		to_chat(user, SPAN_WARNING("你踢了[src]一脚，却什么也没发生。"))
		return
	if(!skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_NOVICE))
		to_chat(user, SPAN_WARNING("你没有接受过使用[src]的训练。"))
		return
	if(busy)
		to_chat(user, SPAN_WARNING("已经有人在使用[src]了。"))
		return
	if(firing)
		to_chat(user, SPAN_WARNING("[src]的炮管仍然滚烫。停止射击，等几秒再操作。"))
		return
	add_fingerprint(user)

	if(computer_enabled)
		tgui_interact(user)
	else
		var/list/mortar_choices = list("设置目标" = "Target", "微调" = "Dial", "取消" = "Cancel")
		var/choice = mortar_choices[alert(user, "要设置迫击炮的目标坐标，还是进行微调？重新设置坐标会清除当前射击修正。", "迫击炮调整", "设置目标", "微调", "取消")]
		if(choice == "Cancel")
			return
		if(choice == "Target")
			handle_target(user, manual = TRUE)
		if(choice == "Dial")
			handle_dial(user, manual = TRUE)

/obj/structure/mortar/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Mortar", "迫击炮控制界面")
		ui.open()

/obj/structure/mortar/ui_data(mob/user)
	return list(
		"data_target_x" = obfuscate_x(targ_x),
		"data_target_y" = obfuscate_y(targ_y),
		"data_dial_x" = dial_x,
		"data_dial_y" = dial_y
	)

/obj/structure/mortar/ui_act(action, params)
	. = ..()
	if(.)
		return

	var/mob/user = usr
	if(get_dist(user, src) > 1)
		return FALSE

	switch(action)
		if("set_target")
			handle_target(user, text2num(params["target_x"]), text2num(params["target_y"]))
			return TRUE

		if("set_offset")
			handle_dial(user, text2num(params["dial_x"]), text2num(params["dial_y"]))
			return TRUE

		if("operate_cam")
			internal_camera.tgui_interact(user)

/obj/structure/mortar/proc/handle_target(mob/user, temp_targ_x = 0, temp_targ_y = 0, manual = FALSE)
	if(manual)
		temp_targ_x = tgui_input_real_number(user, "输入目标的经度。")
		temp_targ_y = tgui_input_real_number(user, "输入目标的纬度。")

	if(!can_fire_at(user, test_targ_x = deobfuscate_x(temp_targ_x), test_targ_y = deobfuscate_y(temp_targ_y)))
		return

	user.visible_message(SPAN_NOTICE("[user]开始调整[src]的射击角度和距离。"),
	SPAN_NOTICE("你开始调整[src]的射击角度和距离，使其与新坐标对应。"))
	busy = TRUE

	var/soundfile = 'sound/machines/scanning.ogg'
	if(manual)
		soundfile = 'sound/items/Ratchet.ogg'
	playsound(loc, soundfile, 25, 1)

	var/success = do_after(user, 3 SECONDS, INTERRUPT_NO_NEEDHAND, BUSY_ICON_FRIENDLY)
	busy = FALSE
	if(!success)
		return
	user.visible_message(SPAN_NOTICE("[user]完成了[src]的射击角度和距离调整。"),
	SPAN_NOTICE("你完成了[src]的射击角度和距离调整，使其与新坐标对应。"))
	targ_x = deobfuscate_x(temp_targ_x)
	targ_y = deobfuscate_y(temp_targ_y)
	var/offset_x_max = floor(abs((targ_x) - x)/offset_per_turfs) //Offset of mortar shot, grows by 1 every 20 tiles travelled
	var/offset_y_max = floor(abs((targ_y) - y)/offset_per_turfs)
	offset_x = rand(-offset_x_max, offset_x_max)
	offset_y = rand(-offset_y_max, offset_y_max)

	SStgui.update_uis(src)

/obj/structure/mortar/proc/handle_dial(mob/user, temp_dial_x = 0, temp_dial_y = 0, manual = FALSE)
	if(manual)
		temp_dial_x = tgui_input_number(user, "设置经度修正量，范围为-10至10。", "经度", 0, 10, -10)
		temp_dial_y = tgui_input_number(user, "设置纬度修正量，范围为-10至10。", "纬度", 0, 10, -10)

	if(!can_fire_at(user, test_dial_x = temp_dial_x, test_dial_y = temp_dial_y))
		return

	user.visible_message(SPAN_NOTICE("[user]开始微调[src]的射击角度和距离。"),
	SPAN_NOTICE("你开始微调[src]的射击角度和距离，使其与新坐标对应。"))
	busy = TRUE

	var/soundfile = 'sound/machines/scanning.ogg'
	if(manual)
		soundfile = 'sound/items/Ratchet.ogg'
	playsound(loc, soundfile, 25, 1)

	var/success = do_after(user, 1.5 SECONDS, INTERRUPT_NO_NEEDHAND, BUSY_ICON_FRIENDLY)
	busy = FALSE
	if(!success)
		return
	user.visible_message(SPAN_NOTICE("[user]完成了[src]的射击角度和距离微调。"),
	SPAN_NOTICE("你完成了[src]的射击角度和距离微调，使其与新坐标对应。"))
	dial_x = temp_dial_x
	dial_y = temp_dial_y

	SStgui.update_uis(src)

/obj/structure/mortar/attackby(obj/item/item, mob/user)
	if(istype(item, /obj/item/mortar_shell))
		var/obj/item/mortar_shell/mortar_shell = item
		if(!istypestrict(src, mortar_shell.allowed_mortar))
			to_chat(user, SPAN_WARNING("[src]无法发射这枚[mortar_shell]。"))
			return
		var/turf/target_turf = locate(targ_x + dial_x + offset_x, targ_y + dial_y + offset_y, z)
		var/area/target_area = get_area(target_turf)
		if(!skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_NOVICE))
			to_chat(user, SPAN_WARNING("你没有接受过发射[src]的训练。"))
			return
		if(busy)
			to_chat(user, SPAN_WARNING("已经有人在使用[src]了。"))
			return
		if(!ship_side)
			if(targ_x == 0 && targ_y == 0) //Mortar wasn't set
				to_chat(user, SPAN_WARNING("需要先为[src]瞄准。"))
				return
			if(!target_turf)
				to_chat(user, SPAN_WARNING("你无法使用[src]向这个目标射击。"))
				return
			if(!istype(target_area))
				to_chat(user, SPAN_WARNING("这片区域超出了地图边界！"))
				return
			if(CEILING_IS_PROTECTED(target_area.ceiling, CEILING_PROTECTION_TIER_2) || protected_by_pylon(TURF_PROTECTION_MORTAR, target_turf))
				to_chat(user, SPAN_WARNING("你无法命中这个目标，它可能位于地下。"))
				return
			if(SSticker.mode && MODE_HAS_TOGGLEABLE_FLAG(MODE_LZ_PROTECTION) && target_area.is_landing_zone)
				to_chat(user, SPAN_WARNING("你不能炮击着陆区！"))
				return

		var/area/our_area = get_area(src)
		if(ship_side && (CEILING_IS_PROTECTED(our_area.ceiling, CEILING_PROTECTION_TIER_2)))
			var/crash_occurred = (SSticker?.mode?.is_in_endgame)
			if(crash_occurred)
				var/turf/our_turf = get_turf(src)
				target_turf = our_turf
				travel_time = 0.5 SECONDS
			else
				to_chat(user, SPAN_RED("你意识到这个主意有多糟糕，赶紧停了下来。"))
				return
		else
			var/turf/deviation_turf = locate(target_turf.x + pick(-1,0,0,1), target_turf.y + pick(-1,0,0,1), target_turf.z) //Small amount of spread so that consecutive mortar shells don't all land on the same tile
			if(deviation_turf)
				target_turf = deviation_turf

		user.visible_message(SPAN_NOTICE("[user]开始将[mortar_shell.name]装入[src]。"),
		SPAN_NOTICE("你开始将[mortar_shell.name]装入[src]。"))
		playsound(loc, 'sound/weapons/gun_mortar_reload.ogg', 50, 1)
		busy = TRUE
		var/success = do_after(user, 1.5 SECONDS, INTERRUPT_NO_NEEDHAND, BUSY_ICON_HOSTILE)
		busy = FALSE
		if(success)
			user.visible_message(SPAN_NOTICE("[user]将[mortar_shell.name]装入了[src]。"),
			SPAN_NOTICE("你将[mortar_shell.name]装入了[src]。"))
			visible_message("[icon2html(src, viewers(src))] [SPAN_DANGER("[name]开火了！")]")
			user.drop_inv_item_to_loc(mortar_shell, src)
			playsound(loc, firesound, 50, 1)
			busy = FALSE
			firing = TRUE
			flick(icon_state + "_fire", src)
			mortar_shell.cause_data = create_cause_data(initial(mortar_shell.name), user, src)
			mortar_shell.forceMove(src)

			var/turf/mortar_turf = get_turf(src)
			mortar_turf.ceiling_debris_check(2)

			for(var/mob/mob in range(7))
				shake_camera(mob, 3, 1)

			addtimer(CALLBACK(src, PROC_REF(handle_shell), target_turf, mortar_shell), travel_time)

	if(HAS_TRAIT(item, TRAIT_TOOL_WRENCH))
		if(!skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_NOVICE))
			to_chat(user, SPAN_WARNING("你没有接受过收起[src]的训练。"))
			return
		if(fixed)
			to_chat(user, SPAN_WARNING("[src]的支架已用螺栓和焊接固定在地面上，看起来是要永久留在这里了。"))
			return
		if(busy)
			to_chat(user, SPAN_WARNING("已经有人在使用[src]了。"))
			return
		if(firing)
			to_chat(user, SPAN_WARNING("[src]的炮管仍然滚烫。停止射击，等几秒再操作。"))
			return
		playsound(loc, 'sound/items/Ratchet.ogg', 25, 1)
		user.visible_message(SPAN_NOTICE("[user]开始收起[src]。"), \
				SPAN_NOTICE("你开始收起[src]。"))
		if(do_after(user, 4 SECONDS, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
			user.visible_message(SPAN_NOTICE("[user]收起了[src]。"), \
				SPAN_NOTICE("你收起了[src]。"))
			playsound(loc, 'sound/items/Deconstruct.ogg', 25, 1)
			var/obj/item/mortar_kit/mortar = new kit_type(loc)
			mortar.name = src.name
			qdel(src)

	if(HAS_TRAIT(item, TRAIT_TOOL_SCREWDRIVER))
		if(do_after(user, 1 SECONDS, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
			user.visible_message(SPAN_NOTICE("[user]切换了[src]的瞄准计算机开关。"), \
				SPAN_NOTICE("你切换了[src]的瞄准计算机开关。"))
			computer_enabled = !computer_enabled
			playsound(loc, 'sound/machines/switch.ogg', 25, 1)

/obj/structure/mortar/ex_act(severity)
	switch(severity)
		if(EXPLOSION_THRESHOLD_MEDIUM to INFINITY)
			qdel(src)

/obj/effect/mortar_effect
	icon = 'icons/obj/structures/mortar.dmi'
	icon_state = "mortar_ammo_custom"
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	invisibility = INVISIBILITY_MAXIMUM

/obj/structure/mortar/proc/handle_shell(turf/target, obj/item/mortar_shell/shell)
	if(protected_by_pylon(TURF_PROTECTION_MORTAR, target))
		firing = FALSE
		return

	var/area/our_area = get_area(src)
	var/turf/our_turf = get_turf(src)
	if(ship_side && (CEILING_IS_PROTECTED(our_area.ceiling, CEILING_PROTECTION_TIER_2)))
		shell.detonate(our_turf)
		return

	if(istype(shell, /obj/item/mortar_shell/custom)) // big shell warning for ghosts
		var/obj/effect/effect = new /obj/effect/mortar_effect(target)
		QDEL_IN(effect, 5 SECONDS)
		notify_ghosts(header = "自制炮弹", message = "一枚自制迫击炮弹即将在[get_area(target)]落地。", source = effect)

	playsound(target, 'sound/weapons/gun_mortar_travel.ogg', 50, 1)
	var/relative_dir
	for(var/mob/mob in range(15, target))
		if(get_turf(mob) == target)
			relative_dir = 0
		else
			relative_dir = Get_Compass_Dir(mob, target)
		mob.show_message( \
			SPAN_DANGER("[warning_text][SPAN_UNDERLINE(relative_dir ? "你的[localized_player_label(dir2text(relative_dir))]侧" : "你的正上方")]！"), SHOW_MESSAGE_VISIBLE, \
			SPAN_DANGER("你听见有东西正在[SPAN_UNDERLINE(relative_dir ? "你的[localized_player_label(dir2text(relative_dir))]侧" : "你的正上方")]落下！"), SHOW_MESSAGE_AUDIBLE \
		)
	sleep(2.5 SECONDS) // Sleep a bit to give a message
	for(var/mob/mob in range(10, target))
		if(get_turf(mob) == target)
			relative_dir = 0
		else
			relative_dir = Get_Compass_Dir(mob, target)
		mob.show_message( \
			SPAN_HIGHDANGER("[close_warning_text][SPAN_UNDERLINE(relative_dir ? "你的[localized_player_label(dir2text(relative_dir))]侧" : "你的正上方")]！"), SHOW_MESSAGE_VISIBLE, \
			SPAN_HIGHDANGER("你听见有东西正在[SPAN_UNDERLINE(relative_dir ? "你的[localized_player_label(dir2text(relative_dir))]侧" : "你的正上方")]落下，声音近在咫尺！"), SHOW_MESSAGE_AUDIBLE \
		)
	sleep(2 SECONDS) // Wait out the rest of the landing time
	target.ceiling_debris_check(2)
	if(!protected_by_pylon(TURF_PROTECTION_MORTAR, target))
		shell.detonate(target)
	qdel(shell)
	firing = FALSE

/obj/structure/mortar/proc/can_fire_at(mob/user, test_targ_x = targ_x, test_targ_y = targ_y, test_dial_x, test_dial_y)
	var/dialing = test_dial_x || test_dial_y
	if(test_dial_x + test_targ_x > world.maxx || test_dial_x + test_targ_x < 0)
		to_chat(user, SPAN_WARNING("你无法[dialing ? "将射击修正至" : "瞄准"]这个坐标，它超出了作战区域。"))
		return FALSE
	if(test_dial_x < -10 || test_dial_x > 10 || test_dial_y < -10 || test_dial_y > 10)
		to_chat(user, SPAN_WARNING("你无法[dialing ? "将射击修正至" : "瞄准"]这个坐标，它离原目标太远了。"))
		return FALSE
	if(test_dial_y + test_targ_y > world.maxy || test_dial_y + test_targ_y < 0)
		to_chat(user, SPAN_WARNING("你无法[dialing ? "将射击修正至" : "瞄准"]这个坐标，它超出了作战区域。"))
		return FALSE
	if(get_dist(src, locate(test_targ_x + test_dial_x, test_targ_y + test_dial_y, z)) < 10)
		to_chat(user, SPAN_WARNING("你无法[dialing ? "将射击修正至" : "瞄准"]这个坐标，它离迫击炮太近了。"))
		return FALSE
	if(busy)
		to_chat(user, SPAN_WARNING("已经有人在使用这门迫击炮了。"))
		return FALSE
	return TRUE

/obj/structure/mortar/fixed
	desc = "一套由炮组手动操作的迫击炮系统，向瞄准区域倾泻80毫米的“美好问候”。使用手动瞄准刻度盘，装入炮弹即可发射。这一门已用螺栓和焊接固定在地面上。"
	fixed = TRUE

/obj/structure/mortar/wo
	fixed = TRUE
	offset_per_turfs = 50 // The mortar is located at the edge of the map in WO, This to to prevent mass FF

//The portable mortar item
/obj/item/mortar_kit
	name = "M402 迫击炮便携式套件"
	desc = "由炮组手动操作的迫击炮系统，向瞄准区域倾泻 80mm 的“美好问候”。使用前需先放下部署。"
	icon = 'icons/obj/structures/mortar.dmi'
	icon_state = "mortar_m402_carry"
	unacidable = TRUE
	w_class = SIZE_HUGE //No dumping this in a backpack. Carry it, fatso
	var/mortar_type = /obj/structure/mortar
	var/has_camo = TRUE

/obj/item/mortar_kit/Initialize(...)
	. = ..()
	if(has_camo)
		select_gamemode_skin(type)

/obj/item/mortar_kit/ex_act(severity)
	switch(severity)
		if(EXPLOSION_THRESHOLD_MEDIUM to INFINITY)
			deconstruct(FALSE)

/obj/item/mortar_kit/attack_self(mob/user)
	..()
	var/turf/deploy_turf = get_turf(user)
	if(!deploy_turf)
		return
	if(!skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_NOVICE))
		to_chat(user, SPAN_WARNING("你没有接受过部署[src]的训练。"))
		return
	var/area/area = get_area(deploy_turf)
	if(CEILING_IS_PROTECTED(area.ceiling, CEILING_PROTECTION_TIER_1) && is_ground_level(deploy_turf.z))
		to_chat(user, SPAN_WARNING("你大概不该在室内部署[src]。"))
		return
	user.visible_message(SPAN_NOTICE("[user]开始部署[src]。"), \
		SPAN_NOTICE("你开始部署[src]。"))
	playsound(deploy_turf, 'sound/items/Deconstruct.ogg', 25, 1)
	if(do_after(user, 4 SECONDS, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
		var/obj/structure/mortar/mortar = new mortar_type(deploy_turf)
		if(!is_ground_level(deploy_turf.z))
			mortar.ship_side = TRUE
			if(CEILING_IS_PROTECTED(area.ceiling, CEILING_PROTECTION_TIER_2))
				user.visible_message(SPAN_NOTICE("[user]部署了[src]。"), \
					SPAN_NOTICE("你部署了[src]。这可不是个好主意。"))
			else
				user.visible_message(SPAN_NOTICE("[user]部署了[src]。"), \
					SPAN_NOTICE("你部署了[src]。"))
		else
			user.visible_message(SPAN_NOTICE("[user]部署了[src]。"), \
				SPAN_NOTICE("你部署了[src]。"))
		playsound(deploy_turf, 'sound/weapons/gun_mortar_unpack.ogg', 25, 1)
		mortar.name = src.name
		mortar.setDir(user.dir)
		qdel(src)

/obj/structure/mortar/himat
	name = "M112 HIMAT"
	desc = "一具便携式两级导弹发射器。它可以手动发射，但与普通火箭筒真正不同的是内置火控系统。使用底板和两脚架部署后，它会尝试连接当地的殖民地陆战队传感器网络，从而自动跟踪、识别射程内的敌对目标，并请求开火。"
	icon_state = "himat"
	kit_type = /obj/item/mortar_kit/himat
	firesound = 'sound/weapons/gun_rocketlauncher.ogg'
	warning_text = "导弹正在落下，方位："
	close_warning_text = "导弹即将落地，方位："
	travel_time = 2 SECONDS
	has_camo = FALSE
	var/obj/item/mortar_shell/loaded_shell = null
	var/id

/obj/structure/mortar/himat/attackby(obj/item/item, mob/user)
	if(istype(item, /obj/item/mortar_shell))
		var/obj/item/mortar_shell/mortar_shell = item
		if(!skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_NOVICE))
			to_chat(user, SPAN_WARNING("你没有接受过发射[src]的训练。"))
			return
		if(busy)
			to_chat(user, SPAN_WARNING("已经有人在使用[src]了。"))
			return

		var/area/our_area = get_area(src)
		if(ship_side && (CEILING_IS_PROTECTED(our_area.ceiling, CEILING_PROTECTION_TIER_2)))
			var/crash_occurred = (SSticker?.mode?.is_in_endgame)
			if(crash_occurred)
				travel_time = 0.5 SECONDS
			else
				to_chat(user, SPAN_RED("你意识到这个主意有多糟糕，赶紧停了下来。"))
				return
		if(!loaded_shell)
			user.visible_message(SPAN_NOTICE("[user]开始将[mortar_shell.name]装入[src]。"),
			SPAN_NOTICE("你开始将[mortar_shell.name]装入[src]。"))
			playsound(loc, 'sound/weapons/gun_mortar_reload.ogg', 50, 1)
			busy = TRUE
			var/success = do_after(user, 1.5 SECONDS, INTERRUPT_NO_NEEDHAND, BUSY_ICON_HOSTILE)
			busy = FALSE
			if(success)
				user.visible_message(SPAN_NOTICE("[user]将[mortar_shell.name]装入了[src]。"),
				SPAN_NOTICE("你将[mortar_shell.name]装入了[src]。"))
				user.drop_inv_item_to_loc(mortar_shell, src)
				busy = FALSE
				mortar_shell.cause_data = create_cause_data(initial(mortar_shell.name), user, src)
				mortar_shell.forceMove(src)
				loaded_shell = mortar_shell

	if(HAS_TRAIT(item, TRAIT_TOOL_WRENCH))
		if(!skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_NOVICE))
			to_chat(user, SPAN_WARNING("你没有接受过收起[src]的训练。"))
			return
		if(fixed)
			to_chat(user, SPAN_WARNING("[src]的支架已用螺栓和焊接固定在地面上，看起来是要永久留在这里了。"))
			return
		if(busy)
			to_chat(user, SPAN_WARNING("已经有人在使用[src]了。"))
			return
		if(firing)
			to_chat(user, SPAN_WARNING("[src]的炮管仍然滚烫。停止射击，等几秒再操作。"))
			return
		if(loaded_shell)
			to_chat(user, SPAN_WARNING("[src]内装有导弹，请先卸下。"))
			return
		playsound(loc, 'sound/items/Ratchet.ogg', 25, 1)
		user.visible_message(SPAN_NOTICE("[user]开始收起[src]。"), \
				SPAN_NOTICE("你开始收起[src]。"))
		if(do_after(user, 4 SECONDS, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
			user.visible_message(SPAN_NOTICE("[user]收起了[src]。"), \
				SPAN_NOTICE("你收起了[src]。"))
			playsound(loc, 'sound/items/Deconstruct.ogg', 25, 1)
			var/obj/item/mortar_kit/mortar = new kit_type(loc)
			mortar.name = src.name
			qdel(src)

	if(HAS_TRAIT(item, TRAIT_TOOL_SCREWDRIVER))
		if(do_after(user, 1 SECONDS, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
			user.visible_message(SPAN_NOTICE("[user]切换了[src]的瞄准计算机开关。"), \
				SPAN_NOTICE("你切换了[src]的瞄准计算机开关。"))
			computer_enabled = !computer_enabled
			playsound(loc, 'sound/machines/switch.ogg', 25, 1)

	if(HAS_TRAIT(item, TRAIT_TOOL_MULTITOOL))
		var/new_id = tgui_input_text(user, "设置识别码（4个字符）", "HIMAT 识别码", id)
		if(!new_id || !istext(new_id))
			return

		if(length(new_id) != 4)
			to_chat(src, SPAN_NOTICE("识别码必须为4个字符。"))
			return
		id = new_id

	if(istype(item, /obj/item/device/binoculars/range/designator))
		if(!id)
			to_chat(user, SPAN_WARNING("连接前必须为[src]设置识别码。使用多功能工具即可设置。"))
			return

		var/obj/item/device/binoculars/range/designator/desig = item
		if(src in desig.connected_himats)
			to_chat(user, SPAN_WARNING("[src]已经连接到这个目标指示器了。"))
			return
		desig.connected_himats += src
		to_chat(user, SPAN_WARNING("[src]连接成功。识别码：[id]。"))


/obj/structure/mortar/himat/handle_shell(turf/target, obj/item/mortar_shell/shell)
	if(!loaded_shell)
		return FALSE

	var/turf/mortar_turf = get_turf(src)
	mortar_turf.ceiling_debris_check(2)
	playsound(loc, firesound, 50, 1)
	visible_message("[icon2html(src, viewers(src))] [SPAN_DANGER("[name]开火了！")]")

	for(var/mob/mob in range(7, src))
		shake_camera(mob, 3, 1)
		if(ishuman(mob) && !HAS_TRAIT(mob, TRAIT_EAR_PROTECTION))
			var/mob/living/carbon/human/human = mob
			human.SetEarDeafness(max(human.ear_deaf, 25))
			to_chat(human, SPAN_WARNING("啊！！[src]发射时的巨响在你耳边轰鸣！你真该戴上某种听力防护装备……"))
	firing = TRUE
	flick(icon_state + "_fire", src)
	spawn(travel_time+rand(1, 10))
	..()
	loaded_shell = null
	return TRUE

/obj/structure/mortar/himat/attack_hand(mob/user)
	if(loaded_shell)
		visible_message(SPAN_NOTICE("[user]开始从[src]中卸下[loaded_shell]。"))
		if(do_after(user, 5 SECONDS, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
			loaded_shell.forceMove(get_turf(src))
			loaded_shell = null
			visible_message(SPAN_NOTICE("[user]从[src]中卸下了[loaded_shell]。"))

/obj/item/mortar_kit/himat
	name = "\improper M112 HIMAT"
	desc = "已折叠、便于携带的 HIMAT 导弹发射器，可以背在背上。"
	icon_state = "himat_carry"
	flags_equip_slot = SLOT_BACK
	item_state_slots = list(
		WEAR_BACK = "himat",
	)
	mortar_type = /obj/structure/mortar/himat
	has_camo = FALSE

/obj/structure/mortar/rmc
	name = "\improper L53A1 轻型迫击炮"
	desc = "一套由炮组手动操作的轻型迫击炮系统，为皇家陆战队分队提供机动火力支援。配备先进的瞄准计算机，装入炮弹即可发射。"
	icon_state = "mortar_l53a1"
	travel_time = 3 SECONDS //Light mortar, quicker on target
	has_camo = FALSE
	kit_type = /obj/item/mortar_kit/rmc

/obj/item/mortar_kit/rmc
	name = "L53A1 轻型迫击炮便携式套件"
	desc = "由炮组手动操作的轻型迫击炮系统，为皇家陆战队分队提供机动火力支援。使用前需先放下部署。"
	icon_state = "mortar_l53a1_carry"
	item_state = "mortar_l53a1_carry"
	flags_equip_slot = SLOT_BACK
	mortar_type = /obj/structure/mortar/rmc
	has_camo = FALSE
