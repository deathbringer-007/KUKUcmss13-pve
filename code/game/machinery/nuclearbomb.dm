GLOBAL_VAR_INIT(bomb_set, FALSE)
/obj/structure/machinery/nuclearbomb
	name = "\improper 核裂变爆炸装置"
	desc = "从轨道核平整个区域，只有这样才能确保万无一失。可惜我们没有轨道核弹。"
	icon = 'icons/obj/structures/machinery/nuclearbomb.dmi'
	icon_state = "nuke"
	density = TRUE
	unslashable = TRUE
	unacidable = TRUE
	anchored = FALSE
	var/timing = FALSE
	var/deployable = FALSE
	var/explosion_time = null
	var/timeleft = 8 MINUTES
	var/safety = TRUE
	var/being_used = FALSE
	var/end_round = TRUE
	var/timer_announcements_flags = NUKE_SHOW_TIMER_ALL
	pixel_x = -16
	use_power = USE_POWER_NONE
	req_access = list()
	flags_atom = FPRINT
	var/command_lockout = FALSE //If set to TRUE, only command staff would be able to disable the nuke

/obj/structure/machinery/nuclearbomb/Initialize(mapload, ...)
	. = ..()

	update_minimap_icon()

/obj/structure/machinery/nuclearbomb/proc/update_minimap_icon()
	if(!is_ground_level(z))
		return

	SSminimaps.remove_marker(src)
	SSminimaps.add_marker(src, z, MINIMAP_FLAG_ALL, "nuke[timing ? "_on" : "_off"]", 'icons/ui_icons/map_blips_large.dmi')

/obj/structure/machinery/nuclearbomb/update_icon()
	overlays.Cut()
	if(anchored)
		var/image/I = image(icon, "+deployed")
		overlays += I
	if(!safety)
		var/image/I = image(icon, "+unsafe")
		overlays += I
	if(timing)
		var/image/I = image(icon, "+timing")
		overlays += I
	if(timing == -1)
		var/image/I = image(icon, "+activation")
		overlays += I

/obj/structure/machinery/nuclearbomb/power_change()
	return

/obj/structure/machinery/nuclearbomb/process()
	. = ..()
	if(!timing)
		update_minimap_icon()
		return PROCESS_KILL

	GLOB.bomb_set = TRUE //So long as there is one nuke timing, it means one nuke is armed.
	timeleft = explosion_time - world.time
	if(world.time >= explosion_time)
		explode()
		return
	//3 warnings: 1. Halfway through, 2. 1 minute left, 3. 10 seconds left.
	//this structure allows varedits to var/timeleft without losing or spamming warnings.
	if(!timer_announcements_flags)
		return

	if(timer_announcements_flags & NUKE_SHOW_TIMER_HALF)
		if(timeleft <= initial(timeleft) / 2 && timeleft >= initial(timeleft) / 2 - 30)
			announce_to_players(NUKE_SHOW_TIMER_HALF)
			timer_announcements_flags &= ~NUKE_SHOW_TIMER_HALF
			return
	if(timer_announcements_flags & NUKE_SHOW_TIMER_MINUTE)
		if(timeleft <= 600 && timeleft >= 570)
			announce_to_players(NUKE_SHOW_TIMER_MINUTE)
			timer_announcements_flags = NUKE_SHOW_TIMER_TEN_SEC
			return
	if(timer_announcements_flags & NUKE_SHOW_TIMER_TEN_SEC)
		if(timeleft <= 100 && timeleft >= 70)
			announce_to_players(NUKE_SHOW_TIMER_TEN_SEC)
			timer_announcements_flags = 0
			return

/obj/structure/machinery/nuclearbomb/attack_alien(mob/living/carbon/xenomorph/M)
	INVOKE_ASYNC(src, TYPE_PROC_REF(/atom, attack_hand), M)
	return XENO_ATTACK_ACTION

/obj/structure/machinery/nuclearbomb/attackby(obj/item/O as obj, mob/user as mob)
	if(anchored && timing && GLOB.bomb_set && HAS_TRAIT(O, TRAIT_TOOL_WIRECUTTERS))
		user.visible_message(SPAN_INFO("[user]开始拆除[src]。"), SPAN_INFO("你开始拆除[src]。这需要一些时间……"))
		if(do_after(user, 150 * user.get_skill_duration_multiplier(SKILL_ENGINEER), INTERRUPT_NO_NEEDHAND, BUSY_ICON_HOSTILE))
			disable()
			playsound(loc, 'sound/items/Wirecutter.ogg', 100, 1)
		return
	..()

/obj/structure/machinery/nuclearbomb/attack_hand(mob/user as mob)
	if(user.is_mob_incapacitated() || get_dist(src, user) > 1 || isRemoteControlling(user))
		return

	if(isyautja(user))
		to_chat(usr, SPAN_YAUTJABOLD("人类的净化装置。原始而笨重，却十分有效。你没时间研究这些违背直觉的控制按钮，最好在它引爆前离开猎场。"))

	if(deployable)
		if(!ishuman(user) && !isqueen(user))
			to_chat(usr, SPAN_INFO("你的手不够灵巧，无法这样做！"))
			return

		if(isqueen(user))
			if(timing && GLOB.bomb_set)
				user.visible_message(SPAN_INFO("[user]开始用树脂包裹[src]。"), SPAN_INFO("你开始反刍树脂，将[src]包裹起来以阻止电子设备运转……这需要一些时间……"))
				if(do_after(user, 5 SECONDS, INTERRUPT_NO_NEEDHAND, BUSY_ICON_HOSTILE))
					disable()
			return
		tgui_interact(user)

	else
		make_deployable()


// TGUI \\

/obj/structure/machinery/nuclearbomb/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "NuclearBomb", "[src.name]")
		ui.open()

/obj/structure/machinery/nuclearbomb/ui_state(mob/user)
	if(being_used)
		return UI_CLOSE
	return GLOB.not_incapacitated_and_adjacent_state

/obj/structure/machinery/nuclearbomb/ui_status(mob/user)
	. = ..()
	if(inoperable())
		return UI_CLOSE

/obj/structure/machinery/nuclearbomb/ui_data(mob/user)
	var/list/data = list()

	var/allowed = allowed(user)

	data["anchor"] = anchored
	data["safety"] = safety
	data["timing"] = timing
	data["timeleft"] = duration2text_sec(timeleft)
	data["command_lockout"] = command_lockout
	data["allowed"] = allowed
	data["being_used"] = being_used
	data["decryption_complete"] = TRUE //this is overridden by techweb nuke UI_data later, this just makes it default to true

	return data

/obj/structure/machinery/nuclearbomb/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	var/area/A = get_area(src)
	switch(action)
		if("toggleNuke")
			if(timing == -1)
				return

			if(!ishuman(ui.user))
				return

			if(!allowed(ui.user))
				to_chat(ui.user, SPAN_INFO("访问被拒绝！"))
				return

			if(!anchored)
				to_chat(ui.user, SPAN_INFO("先展开锚固装置！"))
				return

			if(safety)
				to_chat(ui.user, SPAN_INFO("保险仍未关闭。"))
				return

			if(!A.can_build_special)
				to_chat(ui.user, SPAN_INFO("你不能在这里部署[src]！"))
				return

			if(ui.user.action_busy)
				return

			ui.user.visible_message(SPAN_WARNING("[ui.user]开始[timing ? "解除" : "启动"][src]！"), SPAN_WARNING("你开始[timing ? "解除" : "启动"][src]。"))
			being_used = TRUE
			ui = SStgui.try_update_ui(ui.user, src, ui)
			if(do_after(ui.user, 50, INTERRUPT_NO_NEEDHAND, BUSY_ICON_HOSTILE))
				timing = !timing
				if(timing)
					if(!safety)
						GLOB.bomb_set = TRUE
						explosion_time = world.time + timeleft
						update_minimap_icon()
						start_processing()
						announce_to_players()
						message_admins("\The [src] has been activated by [key_name(ui.user, 1)] [ADMIN_JMP_USER(ui.user)]")
					else
						GLOB.bomb_set = FALSE
				else
					disable()
					message_admins("\The [src] has been deactivated by [key_name(ui.user, 1)] [ADMIN_JMP_USER(ui.user)]")
				playsound(loc, 'sound/effects/thud.ogg', 100, 1)
			being_used = FALSE
			. = TRUE

		if("toggleSafety")
			if(!allowed(ui.user))
				to_chat(ui.user, SPAN_INFO("访问被拒绝！"))
				return
			if(timing)
				to_chat(ui.user, SPAN_INFO("请先解除启动状态！"))
				return
			if(!A.can_build_special)
				to_chat(ui.user, SPAN_INFO("你不能在这里部署[src]！"))
				return
			if(ui.user.action_busy)
				return
			ui.user.visible_message(SPAN_WARNING("[ui.user]开始[safety ? "关闭" : "开启"][src]的保险！"), SPAN_WARNING("你开始[safety ? "关闭" : "开启"][src]的保险。"))
			being_used = TRUE
			ui = SStgui.try_update_ui(ui.user, src, ui)
			if(do_after(ui.user, 50, INTERRUPT_NO_NEEDHAND, BUSY_ICON_HOSTILE))
				safety = !safety
				playsound(loc, 'sound/items/poster_being_created.ogg', 100, 1)
			being_used = FALSE
			if(safety)
				timing = FALSE
				GLOB.bomb_set = FALSE
			. = TRUE

		if("toggleCommandLockout")
			if(!ishuman(ui.user))
				return
			if(!allowed(ui.user))
				to_chat(ui.user, SPAN_INFO("访问被拒绝！"))
				return
			if(command_lockout)
				command_lockout = FALSE
				req_one_access = list()
				to_chat(ui.user, SPAN_INFO("指挥锁定已解除。"))
			else
				//Check if they have command access
				var/list/acc = list()
				var/mob/living/carbon/human/H = ui.user
				if(H.wear_id)
					acc += H.wear_id.GetAccess()
				if(H.get_active_hand())
					acc += H.get_active_hand().GetAccess()
				if(!(ACCESS_MARINE_COMMAND in acc))
					to_chat(ui.user, SPAN_INFO("访问被拒绝！"))
					return

				command_lockout = TRUE
				req_one_access = list(ACCESS_MARINE_COMMAND)
				to_chat(ui.user, SPAN_INFO("指挥锁定已启用。"))
			. = TRUE

		if("toggleAnchor")
			if(timing)
				to_chat(ui.user, SPAN_INFO("请先解除启动状态！"))
				return
			if(!A.can_build_special)
				to_chat(ui.user, SPAN_INFO("你不能在这里部署[src]！"))
				return
			if(ui.user.action_busy)
				return
			being_used = TRUE
			ui = SStgui.try_update_ui(ui.user, src, ui)
			if(do_after(ui.user, 50, INTERRUPT_NO_NEEDHAND, BUSY_ICON_HOSTILE))
				if(!anchored)
					visible_message(SPAN_INFO("随着金属撞击声，螺栓从[src]中滑出，将其固定在地板上。"))
				else
					visible_message(SPAN_INFO("锚固螺栓缩回[src]内部。"))
				playsound(loc, 'sound/items/Deconstruct.ogg', 100, 1)
				anchored = !anchored
			being_used = FALSE
			. = TRUE

	update_icon()
	add_fingerprint(ui.user)

/obj/structure/machinery/nuclearbomb/verb/make_deployable()
	set category = "Object"
	set name = "调整部署状态"
	set src in oview(1)

	if(usr.is_mob_incapacitated() || being_used || timing)
		return

	if(!ishuman(usr))
		to_chat(usr, SPAN_INFO("你的手不够灵巧，无法这样做！"))
		return

	var/area/A = get_area(src)
	if(!A.can_build_special)
		to_chat(usr, SPAN_INFO("你不想在这里部署它！"))
		return

	usr.visible_message(SPAN_WARNING("[usr]开始[deployable ? "合上" : "调整"]几块面板，使[src][deployable ? "无法部署" : "可以部署"]。"), SPAN_WARNING("你开始[deployable ? "合上" : "调整"]几块面板，使[src][deployable ? "无法部署" : "可以部署"]。"))
	being_used = TRUE
	if(do_after(usr, 50, INTERRUPT_NO_NEEDHAND, BUSY_ICON_HOSTILE))
		if(deployable)
			deployable = FALSE
			anchored = FALSE
		else
			deployable = TRUE
			anchored = TRUE
		playsound(loc, 'sound/items/Deconstruct.ogg', 100, 1)
	being_used = FALSE
	update_icon()

//unified all announcements to one proc
/obj/structure/machinery/nuclearbomb/proc/announce_to_players(timer_warning)

	var/list/humans_other = GLOB.human_mob_list + GLOB.dead_mob_list
	var/list/humans_uscm = list()
	for(var/mob/current_mob as anything in humans_other)
		if(current_mob.stat != CONSCIOUS || isyautja(current_mob))
			humans_other -= current_mob
			continue
		if(current_mob.faction == FACTION_MARINE || current_mob.faction == FACTION_SURVIVOR) //separating marines from other factions. Survs go here too
			humans_uscm += current_mob
			humans_other -= current_mob

	if(timer_warning) //we check for timer warnings first
		announcement_helper("WARNING.\n\nDETONATION IN [floor(timeleft/10)] SECONDS.", "[MAIN_AI_SYSTEM] Nuclear Tracker", humans_uscm, 'sound/misc/notice1.ogg')
		announcement_helper("WARNING.\n\nDETONATION IN [floor(timeleft/10)] SECONDS.", "HQ Intel Division", humans_other, 'sound/misc/notice1.ogg')
		//preds part
		var/t_left = duration2text_sec(floor(rand(timeleft - timeleft / 10, timeleft + timeleft / 10)))
		yautja_announcement(SPAN_YAUTJABOLDBIG("警告！\n\n距离人类净化装置启动还剩约[t_left]秒，请立即撤离猎场。"))
		//xenos part
		var/warning
		if(timer_warning & NUKE_SHOW_TIMER_HALF)
			warning = "感受到末日逼近，我们的甲壳不禁颤抖……巢群毁灭者的准备进程已经过半！"
		else if(timer_warning & NUKE_SHOW_TIMER_MINUTE)
			warning = "我们所有的感官都在尖叫……巢群毁灭者即将引爆！"
		else
			warning = "阻止它！立刻！"
		var/datum/hive_status/hive
		for(var/hivenumber in GLOB.hive_datum)
			hive = GLOB.hive_datum[hivenumber]
			if(!length(hive.totalXenos))
				return
			xeno_announcement(SPAN_XENOANNOUNCE(warning), hive.hivenumber, XENO_GENERAL_ANNOUNCE)
		return

	var/datum/hive_status/hive
	if(timing)
		announcement_helper("ALERT.\n\nNUCLEAR EXPLOSIVE ORDNANCE ACTIVATED.\n\nDETONATION IN [floor(timeleft/10)] SECONDS.", "[MAIN_AI_SYSTEM] Nuclear Tracker", humans_uscm, 'sound/misc/notice1.ogg')
		announcement_helper("ALERT.\n\nNUCLEAR EXPLOSIVE ORDNANCE ACTIVATED.\n\nDETONATION IN [floor(timeleft/10)] SECONDS.", "HQ Nuclear Tracker", humans_other, 'sound/misc/notice1.ogg')
		var/t_left = duration2text_sec(floor(rand(timeleft - timeleft / 10, timeleft + timeleft / 10)))
		yautja_announcement(SPAN_YAUTJABOLDBIG("警告！<br>检测到人类净化装置。距离启动还剩约[t_left]，请撤离猎场。"))
		for(var/hivenumber in GLOB.hive_datum)
			hive = GLOB.hive_datum[hivenumber]
			if(!length(hive.totalXenos))
				continue
			xeno_announcement(SPAN_XENOANNOUNCE("高个子宿主在[get_area_name(loc)]部署了灭巢装置！不惜一切代价阻止它！"), hive.hivenumber, XENO_GENERAL_ANNOUNCE)
	else
		announcement_helper("ALERT.\n\nNUCLEAR EXPLOSIVE ORDNANCE DEACTIVATED.", "[MAIN_AI_SYSTEM] Nuclear Tracker", humans_uscm, 'sound/misc/notice1.ogg')
		announcement_helper("ALERT.\n\nNUCLEAR EXPLOSIVE ORDNANCE DEACTIVATED.", "HQ Intel Division", humans_other, 'sound/misc/notice1.ogg')
		yautja_announcement(SPAN_YAUTJABOLDBIG("警告！<br>人类净化装置的信号消失了。"))
		for(var/hivenumber in GLOB.hive_datum)
			hive = GLOB.hive_datum[hivenumber]
			if(!length(hive.totalXenos))
				continue
			xeno_announcement(SPAN_XENOANNOUNCE("灭巢装置已停用！欢呼吧！"), hive.hivenumber, XENO_GENERAL_ANNOUNCE)
	return

/obj/structure/machinery/nuclearbomb/ex_act(severity)
	return

/obj/structure/machinery/nuclearbomb/proc/disable()
	timing = FALSE
	GLOB.bomb_set = FALSE
	timeleft = initial(timeleft)
	explosion_time = null
	announce_to_players()

/obj/structure/machinery/nuclearbomb/proc/explode()
	if(safety)
		timing = FALSE
		update_minimap_icon()
		stop_processing()
		update_icon()
		return FALSE
	timing = -1
	update_icon()
	safety = TRUE

	playsound(src, 'sound/machines/Alarm.ogg', 75, 0, 30)
	world << pick('sound/theme/nuclear_klaxon.ogg')

	var/list/humans_other = GLOB.human_mob_list + GLOB.dead_mob_list
	var/list/humans_uscm = list()
	for(var/mob/current_mob as anything in humans_other)
		if(current_mob.stat != CONSCIOUS || isyautja(current_mob))
			humans_other -= current_mob
			continue
		if(current_mob.faction == FACTION_MARINE || current_mob.faction == FACTION_SURVIVOR) //separating marines from other factions. Survs go here too
			humans_uscm += current_mob
			humans_other -= current_mob
	announcement_helper("IMMINENT NUCLEAR DETONATION.", "[MAIN_AI_SYSTEM] Nuclear Tracker", humans_uscm, 'sound/effects/ob_alert.ogg')
	announcement_helper("IMMINENT NUCLEAR BLAST, DUCK AND COVER IMMEDIATELY.", "Colony Alert System", humans_other, 'sound/effects/ob_alert.ogg')

	sleep(10 SECONDS)

	var/list/mob/alive_mobs = list() //Everyone who will be destroyed on the zlevel(s).
	var/list/mob/dead_mobs = list() //Everyone that needs embryos cleared
	for(var/mob/current_mob as anything in GLOB.mob_list)
		var/turf/current_turf = get_turf(current_mob)
		if(current_turf?.z == z)
			if(current_mob.stat == DEAD)
				dead_mobs |= current_mob
				continue
			alive_mobs |= current_mob

	for(var/datum/interior/interior in SSinterior.interiors)
		if(!interior.exterior || interior.exterior.z != z)
			continue

		for(var/mob/living/passenger in interior.get_passengers())
			if(!(passenger in (alive_mobs + dead_mobs)))
				if(passenger.stat != DEAD)
					passenger.death(create_cause_data("nuclear explosion"))
				for(var/obj/item/alien_embryo/embryo in passenger)
					qdel(embryo)

	for(var/mob/current_mob in alive_mobs)
		if(istype(current_mob.loc, /obj/structure/closet/secure_closet/freezer/fridge))
			continue
		current_mob.death(create_cause_data("nuclear explosion"))

	for(var/mob/living/current_mob in (alive_mobs + dead_mobs))
		if(istype(current_mob.loc, /obj/structure/closet/secure_closet/freezer/fridge))
			continue
		for(var/obj/item/alien_embryo/embryo in current_mob)
			qdel(embryo)

	cell_explosion(loc, 500, 10, EXPLOSION_FALLOFF_SHAPE_LINEAR, null, create_cause_data(initial(name)))
	announcement_helper("NUCLEAR DETONATION DETECTED.", "[MAIN_AI_SYSTEM] Nuclear Tracker", humans_uscm, 'sound/misc/notice1.ogg')
	announcement_helper("NUCLEAR DETONATION DETECTED.", "Colony Alert System", humans_other, 'sound/misc/notice1.ogg')
	qdel(src)
	return TRUE

/obj/structure/machinery/nuclearbomb/Destroy()
	GLOB.bomb_set = FALSE
	SSminimaps.remove_marker(src)
	return ..()

/obj/structure/machinery/nuclearbomb/tech
	var/decryption_time = 10 MINUTES
	var/decryption_end_time = null
	var/decrypting = FALSE

	timeleft = 1 MINUTES
	timer_announcements_flags = NUKE_DECRYPT_SHOW_TIMER_ALL

	var/list/linked_decryption_towers

/obj/structure/machinery/nuclearbomb/tech/Initialize(mapload)
	. = ..()

	linked_decryption_towers = list()

	return INITIALIZE_HINT_LATELOAD

/obj/structure/machinery/nuclearbomb/tech/LateInitialize()
	. = ..()

	for(var/obj/structure/machinery/telecomms/relay/preset/tower/mapcomms/possible_telecomm in GLOB.all_static_telecomms_towers)
		if(is_ground_level(possible_telecomm.z))
			linked_decryption_towers += possible_telecomm

	RegisterSignal(SSdcs, COMSIG_GLOB_GROUNDSIDE_TELECOMM_TURNED_OFF, PROC_REF(connected_comm_shutdown))

/obj/structure/machinery/nuclearbomb/tech/ui_data(mob/user)
	. = ..()

	.["decrypting"] = decrypting
	.["decryption_time"] = duration2text_sec(decryption_time)

	.["decryption_complete"] = decryption_time ? FALSE : TRUE

/obj/structure/machinery/nuclearbomb/tech/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	if(..())
		return

	switch(action)
		if("toggleEncryption")
			if(!ishuman(ui.user))
				return

			if(!allowed(ui.user))
				to_chat(ui.user, SPAN_INFO("访问被拒绝！"))
				return

			if(!anchored)
				to_chat(ui.user, SPAN_INFO("先展开锚固装置！"))
				return

			var/area/current_area = get_area(src)
			if(!current_area.can_build_special)
				to_chat(ui.user, SPAN_INFO("你不能在这里部署[src]！"))
				return

			if(is_ground_level(z))
				for(var/obj/structure/machinery/telecomms/relay/preset/tower/mapcomms/telecomm_unit in linked_decryption_towers)
					if(!telecomm_unit.on)
						to_chat(ui.user, SPAN_INFO("必须先启动地面通信中继站！"))
						return

			if(ui.user.action_busy)
				return

			if(being_used)
				return

			ui.user.visible_message(SPAN_WARNING("[ui.user]开始[decrypting ? "停止解密过程" : "进行解密"]！"), SPAN_WARNING("你开始[decrypting ? "停止解密过程" : "进行解密"]。"))
			being_used = TRUE
			ui = SStgui.try_update_ui(ui.user, src, ui)
			if(do_after(ui.user, 50, INTERRUPT_NO_NEEDHAND, BUSY_ICON_HOSTILE))
				decrypting = !decrypting
				if(decrypting)
					//add signal handlers
					decryption_end_time = world.time + decryption_time
					start_processing()
					announce_to_players()
					message_admins("[src]'s encryption process has been started by [key_name(ui.user, 1)] [ADMIN_JMP_USER(ui.user)]")
				else
					//remove signal handlers
					decryption_end_time = null
					announce_to_players()
					message_admins("[src]'s encryption process has been deactivated by [key_name(ui.user, 1)] [ADMIN_JMP_USER(ui.user)]")
				playsound(loc, 'sound/effects/thud.ogg', 100, 1)
			being_used = FALSE
			return TRUE

/obj/structure/machinery/nuclearbomb/tech/process()
	if(!decrypting)
		return ..()

	decryption_time = decryption_end_time - world.time

	if(world.time > decryption_end_time)
		decrypting = FALSE
		decryption_time = 0
		announce_to_players(NUKE_DECRYPT_SHOW_TIMER_COMPLETE)
		timer_announcements_flags &= ~NUKE_DECRYPT_SHOW_TIMER_COMPLETE
		return PROCESS_KILL

	if(!timer_announcements_flags)
		return

	if(timer_announcements_flags & NUKE_DECRYPT_SHOW_TIMER_HALF)
		if(decryption_time <= initial(decryption_time) / 2 && decryption_time >= initial(decryption_time) / 2 - 30)
			announce_to_players(NUKE_DECRYPT_SHOW_TIMER_HALF)
			timer_announcements_flags &= ~NUKE_DECRYPT_SHOW_TIMER_HALF
			return
	if(timer_announcements_flags & NUKE_DECRYPT_SHOW_TIMER_MINUTE)
		if(decryption_time <= 600 && decryption_time >= 570)
			announce_to_players(NUKE_DECRYPT_SHOW_TIMER_MINUTE)
			timer_announcements_flags &= ~NUKE_DECRYPT_SHOW_TIMER_MINUTE
			return

/obj/structure/machinery/nuclearbomb/tech/announce_to_players(timer_warning)
	if(!decryption_time && (timer_warning != NUKE_DECRYPT_SHOW_TIMER_COMPLETE))
		return ..()

	var/list/humans_other = GLOB.human_mob_list + GLOB.dead_mob_list
	var/list/humans_uscm = list()
	for(var/mob/current_mob as anything in humans_other)
		var/mob/living/carbon/human/current_human = current_mob
		if(istype(current_human)) //if it's unconsious human or yautja, we remove them
			if(current_human.stat != CONSCIOUS || isyautja(current_human))
				humans_other -= current_mob
				continue
		if(current_mob.faction == FACTION_MARINE || current_mob.faction == FACTION_SURVIVOR)
			humans_uscm += current_mob
			humans_other -= current_mob

	if(timer_warning)
		if(timer_warning == NUKE_DECRYPT_SHOW_TIMER_COMPLETE)
			announcement_helper("DECRYPTION COMPLETE", "[MAIN_AI_SYSTEM] Nuclear Tracker", humans_uscm, 'sound/misc/notice1.ogg')
			announcement_helper("DECRYPTION COMPLETE", "HQ Intel Division", humans_other, 'sound/misc/notice1.ogg')

			yautja_announcement(SPAN_YAUTJABOLDBIG("警告！\n\n人类净化装置现在可以启动了。"))

			var/datum/hive_status/hive
			for(var/hivenumber in GLOB.hive_datum)
				hive = GLOB.hive_datum[hivenumber]
				if(!length(hive.totalXenos))
					return
				xeno_announcement(SPAN_XENOANNOUNCE("我们感到末日将至……灭巢装置已准备好启动。"), hive.hivenumber, XENO_GENERAL_ANNOUNCE)
			return

		announcement_helper("DECRYPTION IN [floor(decryption_time/10)] SECONDS.", "[MAIN_AI_SYSTEM] Nuclear Tracker", humans_uscm, 'sound/misc/notice1.ogg')
		announcement_helper("DECRYPTION IN [floor(decryption_time/10)] SECONDS.", "HQ Intel Division", humans_other, 'sound/misc/notice1.ogg')

		//preds part
		var/time_left = duration2text_sec(floor(rand(decryption_time - decryption_time / 10, decryption_time + decryption_time / 10)))
		yautja_announcement(SPAN_YAUTJABOLDBIG("警告！\n\n距离人类净化装置可以启动还剩约[time_left]秒，请撤离猎场。"))

		//xenos part
		var/warning = "We are almost out of time, STOP THEM."
		if(timer_warning & NUKE_DECRYPT_SHOW_TIMER_HALF)
			warning = "The Hive grows restless! it's halfway done..."

		var/datum/hive_status/hive
		for(var/hivenumber in GLOB.hive_datum)
			hive = GLOB.hive_datum[hivenumber]
			if(!length(hive.totalXenos))
				return
			xeno_announcement(SPAN_XENOANNOUNCE(warning), hive.hivenumber, XENO_GENERAL_ANNOUNCE)
		return

	var/datum/hive_status/hive
	if(decrypting)
		announcement_helper("ALERT.\n\nNUCLEAR EXPLOSIVE ORDNANCE DECRYPTION STARTED.\n\nDECRYPTION IN [floor(decryption_time/10)] SECONDS.", "[MAIN_AI_SYSTEM] Nuclear Tracker", humans_uscm, 'sound/misc/notice1.ogg')
		announcement_helper("ALERT.\n\nNUCLEAR EXPLOSIVE ORDNANCE DECRYPTION STARTED.\n\nDECRYPTION IN [floor(decryption_time/10)] SECONDS.", "HQ Nuclear Tracker", humans_other, 'sound/misc/notice1.ogg')
		var/time_left = duration2text_sec(floor(rand(decryption_time - decryption_time / 10, decryption_time + decryption_time / 10)))
		yautja_announcement(SPAN_YAUTJABOLDBIG("警告！<br>检测到人类净化装置。其初始阶段还将在约[time_left]后完成。"))
		for(var/hivenumber in GLOB.hive_datum)
			hive = GLOB.hive_datum[hivenumber]
			if(!length(hive.totalXenos))
				continue
			xeno_announcement(SPAN_XENOANNOUNCE("高个子宿主在[get_area_name(loc)]启动了灭巢装置的初始阶段！摧毁它们的通信中继站！"), hive.hivenumber, XENO_GENERAL_ANNOUNCE)
		return

	announcement_helper("ALERT.\n\nNUCLEAR EXPLOSIVE DECRYPTION HALTED.", "[MAIN_AI_SYSTEM] Nuclear Tracker", humans_uscm, 'sound/misc/notice1.ogg')
	announcement_helper("ALERT.\n\nNUCLEAR EXPLOSIVE DECRYPTION HALTED.", "HQ Intel Division", humans_other, 'sound/misc/notice1.ogg')
	yautja_announcement(SPAN_YAUTJABOLDBIG("警告！<br>人类净化装置的信号消失了。"))
	for(var/hivenumber in GLOB.hive_datum)
		hive = GLOB.hive_datum[hivenumber]
		if(!length(hive.totalXenos))
			continue
		xeno_announcement(SPAN_XENOANNOUNCE("灭巢装置的初始阶段已被中止！欢呼吧！"), hive.hivenumber, XENO_GENERAL_ANNOUNCE)

/obj/structure/machinery/nuclearbomb/tech/proc/connected_comm_shutdown(obj/structure/machinery/telecomms/relay/preset/tower/telecomm_unit)
	SIGNAL_HANDLER

	if(!decrypting)
		return

	decrypting = FALSE
	announce_to_players()

/obj/structure/machinery/nuclearbomb/ADM
	name = "\improper 战术原子爆破弹"
	desc = "通常称作“核地雷”，也因圆柱外形被俗称为“亨氏”。Mk-214战术原子爆破弹用于在行动区隐蔽部署，彻底清除爆心周围数英里范围内的一切。"
	icon = 'icons/obj/items/marine-items.dmi'
	icon_state = "adm"
	pixel_x = 0
	var/source_type = /obj/item/ADM

/obj/structure/machinery/nuclearbomb/ADM/attackby(obj/item/item, mob/user)
	if(HAS_TRAIT(item, TRAIT_TOOL_MULTITOOL))
		if(user.action_busy)
			return
		if(!skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_NOVICE))
			to_chat(user, SPAN_WARNING("你不知道如何用安全访问调谐器收起[src]……"))
			return
		user.visible_message(SPAN_NOTICE("[user]开始收起[src]。"), \
			SPAN_NOTICE("你开始收起[src]……"))
		playsound(loc, 'sound/items/Crowbar.ogg', 25, 1)
		if(do_after(user, 5 SECONDS, INTERRUPT_NO_NEEDHAND, BUSY_ICON_FRIENDLY, src))
			collapse(usr)
		else
			to_chat(user, SPAN_WARNING("你停止收起[src]。"))
	return ..()

/obj/structure/machinery/nuclearbomb/ADM/proc/collapse(mob/living/carbon/human/user)
	var/obj/item/ADM = new source_type(loc)
	if(istype(user))
		user.visible_message(SPAN_NOTICE("[user]收起了[src]。"),
			SPAN_NOTICE("你收起了[src]。"))
		user.put_in_active_hand(ADM)
	qdel(src)

// ADM in hands
/obj/item/ADM
	name = "Mk-214战术原子爆破弹"
	desc = "一枚收拢后等待部署的战术原子爆破弹，威力惊人。内含控制台及弹头启动钥匙。"
	w_class = SIZE_LARGE
	unacidable = TRUE
	flags_equip_slot = SLOT_BACK
	flags_item = SMARTGUNNER_BACKPACK_OVERRIDE
	icon_state = "admpacked"
	item_state = "admpacked"
	icon = 'icons/obj/items/marine-items.dmi'

/obj/item/ADM/attack_self(mob/user)
	. = ..()

	if(SSinterior.in_interior(user))
		to_chat(usr, SPAN_WARNING("这里太狭窄，无法部署[src]。"))
		return
	var/turf/Tile = get_step(user, user.dir)
	var/blocked = FALSE
	for(var/obj/Obj in Tile)
		if(Obj.density)
			blocked = TRUE
			break
	for(var/mob/Mob in Tile)
		blocked = TRUE
		break
	if(istype(Tile, /turf/open))
		var/turf/open/floor = Tile
		if(!floor.allow_construction)
			to_chat(user, SPAN_WARNING("你不能在这里部署[src]，请寻找更稳固的表面！"))
			return FALSE
	else
		blocked = TRUE
	if(blocked)
		to_chat(usr, SPAN_WARNING("你需要一片开阔区域才能部署[src]，前方有东西挡住了！"))
		return

	if(usr.action_busy)
		return
	user.visible_message(SPAN_NOTICE("[user]开始部署[src]。"),
			SPAN_NOTICE("你开始部署[src]。"))
	playsound(loc, list('sound/handling/armorequip_1.ogg', 'sound/handling/armorequip_2.ogg'), 25, 1)
	if(!do_after(user, 5 SECONDS, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
		to_chat(user, SPAN_WARNING("你的动作被打断了。"))
		return
	user.visible_message(SPAN_NOTICE("[user]完成了[src]的部署。"),
			SPAN_NOTICE("你完成了[src]的部署。"))

	var/obj/structure/machinery/nuclearbomb/ADM/planted = new(Tile)
	planted.update_icon()
	qdel(src)
