#define LOW_MULTIBROADCAST_COOLDOWN 1 MINUTES
#define HIGH_MULTIBROADCAST_COOLDOWN 3 MINUTES

/obj/item/device/radio/headset
	name = "无线电耳机"
	desc = "可戴在头上的新式模块化通讯器，能够安装加密密钥。"
	icon_state = "generic_headset"
	item_state = "headset"
	matter = list("metal" = 75)
	subspace_transmission = 1
	canhear_range = 0 // can't hear headsets from very far away


	flags_equip_slot = SLOT_EAR
	inherent_traits = list(TRAIT_ITEM_EAR_EXCLUSIVE)
	var/translate_apollo = FALSE
	var/translate_hive = FALSE
	var/maximum_keys = 3
	var/list/initial_keys //Typepaths of objects to be created at initialisation.
	var/list/keys //Actual objects.
	maxf = 1489

	var/list/inbuilt_tracking_options = list(
		"Platoon Commander" = TRACKER_PLTCO,
		"Section Sergeant" = TRACKER_SL,
		"Squad Leader" = TRACKER_FTL,
		"Landing Zone" = TRACKER_LZ
	)
	var/list/tracking_options = list()

	var/list/volume_settings

	var/last_multi_broadcast = -999
	var/multibroadcast_cooldown = HIGH_MULTIBROADCAST_COOLDOWN


	has_hud = FALSE
	var/headset_hud_on = FALSE
	var/locate_setting = TRACKER_SL
	var/misc_tracking = FALSE
	///Tracker specific vars
	var/has_tracker = FALSE
	///Whether or not the headset will show them on the tac-map
	var/map_tracking = FALSE
	///What HUD it will display if present
	hud_type = MOB_HUD_FACTION_MARINE
	var/minimap_type = MINIMAP_FLAG_USCM
	var/default_freq
	var/mob/living/carbon/human/wearer

/obj/item/device/radio/headset/Initialize()
	. = ..()
	keys = list()
	for (var/key in initial_keys)
		keys += new key(src)
	recalculateChannels()

	if(length(volume_settings))
		verbs += /obj/item/device/radio/headset/proc/set_volume_setting

	if(has_hud)
		headset_hud_on = TRUE
		misc_tracking = TRUE
		verbs += /obj/item/device/radio/headset/proc/toggle_squadhud
		verbs += /obj/item/device/radio/headset/proc/switch_tracker_target

	if(frequency)
		for(var/cycled_channel in GLOB.radiochannels)
			if(GLOB.radiochannels[cycled_channel] == frequency)
				default_freq = cycled_channel

	RegisterSignal(SSdcs, COMSIG_GLOB_PLATOON_NAME_CHANGE, PROC_REF(rename_platoon))

	if(SQUAD_MARINE_1 == default_freq && SQUAD_MARINE_1 != GLOB.main_platoon_name)
		rename_platoon(null, GLOB.main_platoon_name, SQUAD_MARINE_1)

/obj/item/device/radio/headset/proc/rename_platoon(datum/source, new_name, old_name)
	SIGNAL_HANDLER

	set_frequency(frequency)

/obj/item/device/radio/headset/Destroy()
	wearer = null
	QDEL_NULL_LIST(keys)
	return ..()

/obj/item/device/radio/headset/proc/set_volume_setting()
	set name = "Set Headset Volume"
	set category = "Object"
	set src in usr

	var/static/list/text_to_volume = list(
		RADIO_VOLUME_QUIET_STR = RADIO_VOLUME_QUIET,
		RADIO_VOLUME_RAISED_STR = RADIO_VOLUME_RAISED,
		RADIO_VOLUME_IMPORTANT_STR = RADIO_VOLUME_IMPORTANT,
		RADIO_VOLUME_CRITICAL_STR = RADIO_VOLUME_CRITICAL
	)

	var/volume_setting = localized_input_list(usr, "请选择耳机通话音量。", "耳机音量", volume_settings)
	if(!volume_setting)
		return
	volume = text_to_volume[volume_setting]
	to_chat(usr, SPAN_NOTICE("你将[src]的音量设为<b>[localized_player_label(volume_setting)]</b>。"))

/obj/item/device/radio/headset/handle_message_mode(mob/living/M as mob, message, channel)
	if (channel == RADIO_CHANNEL_SPECIAL)
		if (translate_apollo)
			var/datum/language/apollo = GLOB.all_languages[LANGUAGE_APOLLO]
			apollo.broadcast(M, message)
		if (translate_hive)
			var/datum/language/hivemind = GLOB.all_languages[LANGUAGE_HIVEMIND]
			hivemind.broadcast(M, message)
		return null

	if(default_freq && channel == default_freq)
		return radio_connection

	return ..()

/obj/item/device/radio/headset/attack_self(mob/user as mob)
	on = TRUE //Turn it on if it was off
	. = ..()

/obj/item/device/radio/headset/receive_range(freq, level, aiOverride = 0)
	if (aiOverride)
		return ..(freq, level)
	if(ishuman(loc))
		var/mob/living/carbon/human/H = loc
		if(H.has_item_in_ears(src))
			return ..(freq, level)
	return -1

/obj/item/device/radio/headset/attack_hand(mob/user as mob)
	if(!ishuman(user) || loc != user)
		return ..()
	var/mob/living/carbon/human/H = user
	if (!H.has_item_in_ears(src))
		return ..()
	user.set_interaction(src)
	tgui_interact(user)

/obj/item/device/radio/headset/examine(mob/user as mob)
	if(ishuman(user) && loc == user)
		tgui_interact(user)
	return ..()

/obj/item/device/radio/headset/MouseDrop(obj/over_object as obj)
	if(!CAN_PICKUP(usr, src))
		return ..()
	if(!istype(over_object, /atom/movable/screen))
		return ..()
	if(loc != usr) //Makes sure that the headset is equipped, so that we can't drag it into our hand from miles away.
		return ..()

	switch(over_object.name)
		if("r_hand")
			if(usr.drop_inv_item_on_ground(src))
				usr.put_in_r_hand(src)
		if("l_hand")
			if(usr.drop_inv_item_on_ground(src))
				usr.put_in_l_hand(src)
	add_fingerprint(usr)

/obj/item/device/radio/headset/attackby(obj/item/W as obj, mob/user as mob)
// ..()
	user.set_interaction(src)
	if ( !(HAS_TRAIT(W, TRAIT_TOOL_SCREWDRIVER) || (istype(W, /obj/item/device/encryptionkey)) ))
		return

	if(HAS_TRAIT(W, TRAIT_TOOL_SCREWDRIVER))
		var/turf/T = get_turf(user)
		if(!T)
			to_chat(user, "你不能在这里这样做。")
			return
		var/removed_keys = FALSE
		for (var/obj/item/device/encryptionkey/key in keys)
			if(key.abstract)
				continue
			key.forceMove(T)
			keys -= key
			removed_keys = TRUE
		if(removed_keys)
			recalculateChannels()
			to_chat(user, SPAN_NOTICE("你取出了[src]中的加密密钥！"))
		else
			to_chat(user, SPAN_NOTICE("这个耳机里没有加密密钥！真没用……"))

	if(istype(W, /obj/item/device/encryptionkey/))
		var/keycount = 0
		for (var/obj/item/device/encryptionkey/key in keys)
			if(!key.abstract)
				keycount++
		if(keycount >= maximum_keys)
			to_chat(user, SPAN_WARNING("[src]装不下另一枚密钥！"))
			return
		if(user.drop_held_item())
			W.forceMove(src)
			keys += W
			to_chat(user, SPAN_NOTICE("你将[W]插入[src]！"))
			recalculateChannels()

	return


/obj/item/device/radio/headset/proc/recalculateChannels()
	for(var/ch_name in channels)
		SSradio.remove_object(src, GLOB.radiochannels[ch_name])
		secure_radio_connections[ch_name] = null
	channels = list()
	translate_apollo = FALSE
	translate_hive = FALSE

	tracking_options = length(inbuilt_tracking_options) ? inbuilt_tracking_options.Copy() : list()
	for(var/i in keys)
		var/obj/item/device/encryptionkey/key = i
		for(var/ch_name in key.channels)
			if(ch_name in channels)
				continue
			channels += ch_name
			channels[ch_name] = key.channels[ch_name]
		for(var/tracking_option in key.tracking_options)
			tracking_options[tracking_option] = key.tracking_options[tracking_option]
		if(key.translate_apollo)
			translate_apollo = TRUE
		if(key.translate_hive)
			translate_hive = TRUE

	if(length(tracking_options))
		var/list/tracking_stuff = list()
		for(var/tracking_fluff in tracking_options)
			tracking_stuff += tracking_options[tracking_fluff]
		if(!(locate_setting in tracking_stuff))
			locate_setting = tracking_stuff[1]
	else
		locate_setting = initial(locate_setting)

	for (var/ch_name in channels)
		secure_radio_connections[ch_name] = SSradio.add_object(src, GLOB.radiochannels[ch_name],  RADIO_CHAT)
	SStgui.update_uis(src)

/obj/item/device/radio/headset/set_frequency(new_frequency)
	..()
	if(frequency)
		for(var/cycled_channel in GLOB.radiochannels)
			if(GLOB.radiochannels[cycled_channel] == frequency)
				default_freq = cycled_channel

/obj/item/device/radio/headset/equipped(mob/living/carbon/human/user, slot)
	. = ..()
	if(user.has_item_in_ears(src))
		RegisterSignal(user, list(
			COMSIG_LIVING_REJUVENATED,
			COMSIG_HUMAN_REVIVED,
		), PROC_REF(turn_on_map_tracking))
		wearer = user
		RegisterSignal(user, COMSIG_MOB_STAT_SET_ALIVE, PROC_REF(update_minimap_icon))
		RegisterSignal(user, COMSIG_MOB_LOGGED_IN, PROC_REF(add_hud_tracker))
		RegisterSignal(user, COMSIG_MOB_DEATH, PROC_REF(update_minimap_icon))
		RegisterSignal(user, COMSIG_HUMAN_SET_UNDEFIBBABLE, PROC_REF(update_minimap_icon))
		if(headset_hud_on)
			for(var/type in hud_type)
				var/datum/mob_hud/H = GLOB.huds[type]
				H.add_hud_to(user, src)
			//squad leader locator is no longer invisible on our player HUD.
			if(user.mind && (user.assigned_squad || misc_tracking) && user.hud_used && user.hud_used.locate_leader)
				user.show_hud_tracker()
			if(misc_tracking)
				SStracking.start_misc_tracking(user)
			INVOKE_NEXT_TICK(src, PROC_REF(update_minimap_icon), wearer)

/obj/item/device/radio/headset/dropped(mob/living/carbon/human/user)
	UnregisterSignal(user, list(
		COMSIG_LIVING_REJUVENATED,
		COMSIG_HUMAN_REVIVED,
		COMSIG_MOB_LOGGED_IN,
		COMSIG_MOB_DEATH,
		COMSIG_HUMAN_SET_UNDEFIBBABLE,
		COMSIG_MOB_STAT_SET_ALIVE
	))
	if(istype(user) && user.has_item_in_ears(src)) //dropped() is called before the inventory reference is update.
		for(var/type in hud_type)
			var/datum/mob_hud/H = GLOB.huds[type]
			H.remove_hud_from(user, src)
		//squad leader locator is invisible again
		if(user.hud_used && user.hud_used.locate_leader)
			user.hide_hud_tracker()
		if(misc_tracking)
			SStracking.stop_misc_tracking(user)
		SSminimaps.remove_marker(wearer)
	wearer = null
	..()

/obj/item/device/radio/headset/proc/add_hud_tracker(mob/living/carbon/human/user)
	SIGNAL_HANDLER

	if(headset_hud_on && user.mind && (user.assigned_squad || misc_tracking) && user.hud_used?.locate_leader)
		user.show_hud_tracker()

/obj/item/device/radio/headset/proc/turn_on_map_tracking()
	SIGNAL_HANDLER

/obj/item/device/radio/headset/proc/toggle_hudicons()
	if(!headset_hud_on)
		return
	else
		for(var/type in hud_type)
			var/datum/mob_hud/H = GLOB.huds[type]
			H.add_hud_to(usr, src)

/obj/item/device/radio/headset/proc/toggle_squadhud()
	set name = "Toggle Headset HUD"
	set category = "Object"
	set src in usr

	if(usr.is_mob_incapacitated())
		return 0
	headset_hud_on = !headset_hud_on
	if(ishuman(usr))
		var/mob/living/carbon/human/user = usr
		if(user.has_item_in_ears(src)) //worn
			for(var/type in hud_type)
				var/datum/mob_hud/H = GLOB.huds[type]
				if(headset_hud_on)
					H.add_hud_to(usr, src)
					if(user.mind && (misc_tracking || user.assigned_squad) && user.hud_used?.locate_leader)
						user.show_hud_tracker()
					if(misc_tracking)
						SStracking.start_misc_tracking(user)
					update_minimap_icon()
				else
					H.remove_hud_from(usr, src)
					if(user.hud_used?.locate_leader)
						user.hide_hud_tracker()
					if(misc_tracking)
						SStracking.stop_misc_tracking(user)
					SSminimaps.remove_marker(wearer)
	to_chat(usr, SPAN_NOTICE("你[headset_hud_on ? "开启":"关闭"]了[src]的耳机抬头显示。"))
	playsound(src,'sound/machines/click.ogg', 20, 1)

/obj/item/device/radio/headset/proc/switch_tracker_target()
	set name = "Switch Tracker Target"
	set category = "Object"
	set src in usr

	if(usr.is_mob_incapacitated())
		return

	handle_switching_tracker_target(usr)

/obj/item/device/radio/headset/proc/handle_switching_tracker_target(mob/living/carbon/human/user)
	var/new_track = localized_input_list(user, "请选择新的追踪目标。", "选择追踪目标", tracking_options)
	if(!new_track)
		return
	to_chat(user, SPAN_NOTICE("你将耳机追踪器设为指向<b>[localized_player_label(new_track)]</b>。"))
	locate_setting = tracking_options[new_track]

/obj/item/device/radio/headset/proc/update_minimap_icon()
	SIGNAL_HANDLER
	if(!has_hud)
		return

	if(!wearer)
		return

	SSminimaps.remove_marker(wearer)
	if(!wearer.assigned_equipment_preset || !wearer.assigned_equipment_preset.minimap_icon)
		return
	var/marker_flags = minimap_type
	var/turf/turf_gotten = get_turf(wearer)
	if(!turf_gotten)
		return
	var/z_level = turf_gotten.z

	if(wearer.assigned_equipment_preset.always_minimap_visible == TRUE || wearer.stat == DEAD) //We show to all marines if we have this flag, separated by faction
		if(hud_type == MOB_HUD_FACTION_MARINE)
			marker_flags = MINIMAP_FLAG_USCM
		else if(hud_type == MOB_HUD_FACTION_UPP)
			marker_flags = MINIMAP_FLAG_UPP
		else if(hud_type == MOB_HUD_FACTION_TWE)
			marker_flags = MINIMAP_FLAG_TWE
		else if(hud_type == MOB_HUD_FACTION_PMC)
			marker_flags = MINIMAP_FLAG_PMC
		else if(hud_type == MOB_HUD_FACTION_CLF)
			marker_flags = MINIMAP_FLAG_CLF

	if(wearer.undefibbable)
		set_undefibbable_on_minimap(z_level, marker_flags)
		return

	if(wearer.stat == DEAD)
		set_dead_on_minimap(z_level, marker_flags)
		return

	SSminimaps.add_marker(wearer, z_level, marker_flags, given_image = wearer.assigned_equipment_preset.get_minimap_icon(wearer))

///Change the minimap icon to a dead icon
/obj/item/device/radio/headset/proc/set_dead_on_minimap(z_level, marker_flags)
	SSminimaps.add_marker(wearer, z_level, marker_flags, given_image = wearer.assigned_equipment_preset.get_minimap_icon(wearer), overlay_iconstates = list("defibbable"))

///Change the minimap icon to a undefibbable icon
/obj/item/device/radio/headset/proc/set_undefibbable_on_minimap(z_level, marker_flags)
	SSminimaps.add_marker(wearer, z_level, marker_flags, given_image = wearer.assigned_equipment_preset.get_minimap_icon(wearer), overlay_iconstates = list("undefibbable"))

/obj/item/device/radio/headset/binary
	initial_keys = list(/obj/item/device/encryptionkey/binary)


/obj/item/device/radio/headset/ai_integrated //No need to care about icons, it should be hidden inside the AI anyway.
	name = "人工智能子空间收发器"
	desc = "人工智能内置无线电收发器。"
	icon = 'icons/obj/items/robot_component.dmi'
	icon_state = "radio"
	item_state = "headset"
	initial_keys = list(/obj/item/device/encryptionkey/ai_integrated)
	var/myAi = null // Atlantis: Reference back to the AI which has this radio.
	var/disabledAi = 0 // Atlantis: Used to manually disable AI's integrated radio via intellicard menu.

/obj/item/device/radio/headset/ai_integrated/receive_range(freq, level)
	if (disabledAi)
		return -1 //Transceiver Disabled.
	return ..(freq, level, 1)

//MARINE HEADSETS

/obj/item/device/radio/headset/almayer
	name = "陆战队无线电耳机"
	desc = "标准军用无线电耳机，比战斗型号更笨重。"
	icon_state = "generic_headset"
	item_state = "headset"
	frequency = PUB_FREQ
	has_hud = TRUE
	map_tracking = TRUE
	hud_type = list(MOB_HUD_FACTION_ARMY, MOB_HUD_FACTION_MARINE, MOB_HUD_FACTION_NAVY)

/obj/item/device/radio/headset/almayer/equipped(mob/living/carbon/human/user, slot)
	. = ..()

	if((user == user.assigned_squad?.fireteam_leaders["SQ1"] || user == user.assigned_squad?.fireteam_leaders["SQ2"]) && ("Section Sergeant" in tracking_options))
		locate_setting = tracking_options["Section Sergeant"]
		return

	if(((user in user.assigned_squad?.fireteams["SQ1"]) || (user in user.assigned_squad?.fireteams["SQ2"])) && ("Squad Leader" in tracking_options))
		locate_setting = tracking_options["Squad Leader"]
		return

/obj/item/device/radio/headset/almayer/verb/give_medal_recommendation()
	set name = "Give Medal Recommendation"
	set desc = "提交勋章推荐，交由指挥官审批。"
	set category = "Object.Medals"
	set src in usr

	var/mob/living/carbon/human/wearer = usr
	if(!istype(wearer))
		return
	var/obj/item/card/id/id_card = wearer.get_idcard()
	if(!id_card)
		return

	var/datum/paygrade/paygrade_actual = GLOB.paygrades[id_card.paygrade]
	if(!paygrade_actual)
		return
	if(!istype(paygrade_actual, /datum/paygrade/marine)) //We only want marines to be able to recommend for medals
		return
	if(paygrade_actual.ranking < 3) //E1 starts at 0, so anyone above Corporal (ranking = 3) can recommend for medals
		to_chat(wearer, SPAN_WARNING("只有军官或士官（ME4 及以上）才能推荐授勋！"))
		return
	if(add_medal_recommendation(usr))
		to_chat(usr, SPAN_NOTICE("推荐已成功提交。"))

/obj/item/device/radio/headset/almayer/ce
	name = "总工程师耳机"
	desc = "供负责启动引擎、管理维护技术员、拆地板找废金属的人使用的耳机，结构结实可靠。频道如下：:n - 工程，:v - 陆战队指挥，:m - 医疗，:u - 军需，:a - 阿尔法小队，:b - 布拉沃小队，:c - 查理小队，:d - 德尔塔小队。"
	icon_state = "ce_headset"
	initial_keys = list(/obj/item/device/encryptionkey/ce)
	volume = RADIO_VOLUME_CRITICAL
	multibroadcast_cooldown = LOW_MULTIBROADCAST_COOLDOWN

/obj/item/device/radio/headset/almayer/cmo
	name = "首席医疗官耳机"
	desc = "配发给医疗部门最高负责人的耳机。频道如下：:m - 医疗，:v - 陆战队指挥。"
	icon_state = "cmo_headset"
	initial_keys = list(/obj/item/device/encryptionkey/cmo)
	volume = RADIO_VOLUME_CRITICAL
	multibroadcast_cooldown = LOW_MULTIBROADCAST_COOLDOWN

/obj/item/device/radio/headset/almayer/mt
	name = "工程无线电耳机"
	desc = "适合协调用于维护的酒吧和轨道轰炸，结构结实可靠。使用 :n 进入工程频道。"
	icon_state = "eng_headset"
	initial_keys = list(/obj/item/device/encryptionkey/engi)

/obj/item/device/radio/headset/almayer/chef
	name = "厨房无线电耳机"
	desc = "舰上厨房人员使用的耳机，背景总有煎锅滋滋作响。用 :u 与军需频道协调，再用 :v 向指挥部通报送餐服务。"
	icon_state = "req_headset"
	initial_keys = list(/obj/item/device/encryptionkey/req/mst)

/obj/item/device/radio/headset/almayer/doc
	name = "医疗无线电耳机"
	desc = "供医务室训练有素的工作人员使用的耳机。使用 :m 进入医疗频道。"
	icon_state = "med_headset"
	initial_keys = list(/obj/item/device/encryptionkey/med)

/obj/item/device/radio/headset/almayer/research
	name = "研究员无线电耳机"
	desc = "医务室熟练研究员使用的耳机。频道如下：:m - 医疗，:t - 情报。"
	icon_state = "med_headset"
	initial_keys = list(/obj/item/device/encryptionkey/medres)

/obj/item/device/radio/headset/almayer/ct
	name = "军需无线电耳机"
	desc = "美国殖民地陆战队底层货运技师使用的耳机，轻巧便携。用 :u 访问军需频道。"
	icon_state = "req_headset"
	initial_keys = list(/obj/item/device/encryptionkey/req/ct)

/obj/item/device/radio/headset/almayer/qm
	desc = "军需官用来指挥手下苦力的耳机。频道如下：:u - 军需，:v - 陆战队指挥，:a - 阿尔法小队，:b - 布拉沃小队，:c - 查理小队，:d - 德尔塔小队。"
	name = "军需官无线电耳机"
	icon_state = "ro_headset"
	initial_keys = list(/obj/item/device/encryptionkey/qm)
	volume = RADIO_VOLUME_CRITICAL
	multibroadcast_cooldown = LOW_MULTIBROADCAST_COOLDOWN

/obj/item/device/radio/headset/almayer/mmpo
	name = "陆战队宪兵无线电耳机"
	desc = "陆战队宪兵使用的耳机。频道如下：:p - 宪兵，:v - 陆战队指挥，:a - 阿尔法小队，:b - 布拉沃小队，:c - 查理小队，:d - 德尔塔小队。"
	icon_state = "sec_headset"
	initial_keys = list(/obj/item/device/encryptionkey/mmpo)

/obj/item/device/radio/headset/almayer/marine/mp_honor
	name = "陆战队仪仗队无线电耳机"
	desc = "陆战队仪仗队成员使用的耳机。频道：:p - 宪兵, :v - 陆战队指挥. :a - 阿尔法小队, :b - 布拉沃小队, :c - 查理小队, :d - 德尔塔小队."
	icon_override = 'icons/obj/items/radio.dmi'
	icon_state = "sec_headset"
	item_icons = list(
		WEAR_L_EAR = 'icons/mob/humans/onmob/ears.dmi',
		WEAR_R_EAR = 'icons/mob/humans/onmob/ears.dmi',
		)
	initial_keys = list(/obj/item/device/encryptionkey/mmpo)
	volume = RADIO_VOLUME_RAISED
	locate_setting = TRACKER_CO
	has_tracker = TRUE
	misc_tracking = TRUE

	inbuilt_tracking_options = list(
		"Commanding Officer" = TRACKER_CO,
		"Executive Officer" = TRACKER_XO
	)

/obj/item/device/radio/headset/almayer/cmpcom
	name = "陆战队宪兵长无线电耳机"
	desc = "用来讨论采购甜甜圈和抓捕流氓。频道如下：:v - 陆战队指挥，:p - 宪兵，:n - 工程，:m - 医疗，:u - 军需，:a - 阿尔法小队，:b - 布拉沃小队，:c - 查理小队，:d - 德尔塔小队。"
	icon_state = "sec_headset"
	initial_keys = list(/obj/item/device/encryptionkey/cmpcom)
	volume = RADIO_VOLUME_CRITICAL

/obj/item/device/radio/headset/almayer/mcom
	name = "陆战队指挥无线电耳机"
	desc = "供战斗情报中心人员和高层使用，配有非制式支架。频道如下：:v - 陆战队指挥，:a - 阿尔法小队，:b - 布拉沃小队，:c - 查理小队，:d - 德尔塔小队，:n - 工程，:m - 医疗，:u - 军需，:j - JTAC，:t - 情报。"
	icon_state = "mcom_headset"
	initial_keys = list(/obj/item/device/encryptionkey/mcom)
	volume = RADIO_VOLUME_CRITICAL
	multibroadcast_cooldown = LOW_MULTIBROADCAST_COOLDOWN
	frequency = ALPHA_FREQ

/obj/item/device/radio/headset/almayer/mcom/alt
	initial_keys = list(/obj/item/device/encryptionkey/mcom/alt)

/obj/item/device/radio/headset/almayer/marine/mp_honor/com
	name = "陆战队仪仗队指挥无线电耳机"
	desc = "仅配发给高度信任的陆战队仪仗队员，配有非标准支架。频道：:v - 陆战队指挥, :p - 宪兵, :n - 工程, :m - 医疗, :u - 军需, :a - 阿尔法小队, :b - 布拉沃小队, :c - 查理小队, :d - 德尔塔小队."
	icon_state = "mcom_headset"
	initial_keys = list(/obj/item/device/encryptionkey/cmpcom)

/obj/item/device/radio/headset/almayer/po
	name = "陆战队飞行员无线电耳机"
	desc = "供飞行军官使用。频道：:v - 陆战队指挥, :n - 工程, :m - 医疗, :j - JTAC, :t - 情报."
	initial_keys = list(/obj/item/device/encryptionkey/po)
	volume = RADIO_VOLUME_CRITICAL
	multibroadcast_cooldown = LOW_MULTIBROADCAST_COOLDOWN

/obj/item/device/radio/headset/almayer/intel
	name = "陆战队情报无线电耳机"
	desc = "供情报军官使用。频道：:v - 陆战队指挥, :a - 阿尔法小队, :b - 布拉沃小队, :c - 查理小队, :d - 德尔塔小队, :n - 工程, :m - 医疗, :j - JTAC, :t - 情报."
	initial_keys = list(/obj/item/device/encryptionkey/io)
	frequency = INTEL_FREQ

/obj/item/device/radio/headset/almayer/mcl
	name = "公司联络员无线电耳机"
	desc = "公司联络员用它劝人签保密协议。频道：:v - 陆战队指挥, :a - 阿尔法小队, :b - 布拉沃小队, :c - 查理小队, :d - 德尔塔小队, :n - 工程, :m - 医疗, :u - 军需, :j - JTAC, :t - 情报, :y 维兰德-汤谷."
	icon_state = "wy_headset"
	maximum_keys = 5
	initial_keys = list(/obj/item/device/encryptionkey/mcom/cl)

/obj/item/device/radio/headset/almayer/reporter
	name = "记者无线电耳机"
	desc = "战地记者用它抢独家新闻。频道：:v - 陆战队指挥, :a - 阿尔法小队, :b - 布拉沃小队, :c - 查理小队, :d - 德尔塔小队, :n - 工程, :m - 医疗, :u - 军需, :j - JTAC, :t - 情报."
	initial_keys = list(/obj/item/device/encryptionkey/mcom)

/obj/item/device/radio/headset/almayer/rep
	name = "代表无线电耳机"
	desc = "这耳机是最糟糕的发明，里面总有说不完的闲聊。"
	icon_state = "wy_headset"
	initial_keys = list(/obj/item/device/encryptionkey/mcom/rep)

/obj/item/device/radio/headset/almayer/mcom/cdrcom
	name = "陆战队高级指挥耳机"
	desc = "仅配发给高级指挥人员。频道如下：:v - 陆战队指挥，:p - 宪兵，:a - 阿尔法小队，:b - 布拉沃小队，:c - 查理小队，:d - 德尔塔小队，:n - 工程，:m - 医疗，:u - 军需，:j - JTAC，:t - 情报。"
	icon_state = "mco_headset"
	initial_keys = list(/obj/item/device/encryptionkey/cmpcom/cdrcom)
	volume = RADIO_VOLUME_CRITICAL

/obj/item/device/radio/headset/almayer/mcom/sea
	name = "陆战队资深士兵顾问耳机"
	desc = "仅配发给资深士兵顾问。频道：:v - 陆战队指挥, :p - 宪兵, :a - 阿尔法小队, :b - 布拉沃小队, :c - 查理小队, :d - 德尔塔小队, :n - 工程, :m - 医疗, :u - 军需, :j - JTAC,  :t - 情报"
	icon_state = "mco_headset"
	initial_keys = list(/obj/item/device/encryptionkey/cmpcom/cdrcom)
	volume = RADIO_VOLUME_CRITICAL
	has_tracker = TRUE
	misc_tracking = TRUE
	locate_setting = TRACKER_CO

	inbuilt_tracking_options = list(
		"Commanding Officer" = TRACKER_CO,
		"Executive Officer" = TRACKER_XO,
		"Chief MP" = TRACKER_CMP
	)

/obj/item/device/radio/headset/almayer/mcom/synth
	name = "陆战队合成人耳机"
	desc = "仅配发给 USCM 合成人。频道如下：:v - 陆战队指挥，:p - 宪兵，:a - 阿尔法小队，:b - 布拉沃小队，:c - 查理小队，:d - 德尔塔小队，:n - 工程，:m - 医疗，:u - 军需，:j - JTAC，:t - 情报。"
	icon_state = "ms_headset"
	initial_keys = list(/obj/item/device/encryptionkey/cmpcom/synth)
	volume = RADIO_VOLUME_CRITICAL
	has_tracker = TRUE
	misc_tracking = TRUE
	has_hud = TRUE
	locate_setting = TRACKER_ASL

	inbuilt_tracking_options = list(
		"Platoon Commander" = TRACKER_PLTCO,
		"A-Section Sergeant" = TRACKER_ASL,
		"B-Section Sergeant" = TRACKER_BSL,
		"Landing Zone" = TRACKER_LZ
	)

/obj/item/device/radio/headset/almayer/mcom/ai
	initial_keys = list(/obj/item/device/encryptionkey/mcom/ai)
	volume = RADIO_VOLUME_CRITICAL

/obj/item/device/radio/headset/almayer/marine
	name = "陆战队无线电耳机"
	desc = "标准陆战队无线电耳机。佩戴后可使用小队长追踪器，空手点击追踪器可打开小队信息窗口。"
	icon_state = "generic_headset"
	item_state = "headset"
	frequency = ALPHA_FREQ

//############################## VISIBLE HEADSETS ###############################
/obj/item/device/radio/headset/almayer/marine/solardevils
	name = "陆战队无线电耳机"
	desc = "标准陆战队无线电耳机。佩戴后可使用小队长追踪器，空手点击追踪器可打开小队信息窗口。"
	icon_state = "uscm_headset"
	item_state = "uscm_headset"
	item_icons = list(
		WEAR_L_EAR = 'icons/mob/humans/onmob/ears.dmi',
		WEAR_R_EAR = 'icons/mob/humans/onmob/ears.dmi',
		)
	frequency = ALPHA_FREQ
	has_tracker = TRUE
	misc_tracking = TRUE
	hud_type = list(MOB_HUD_FACTION_MARINE, MOB_HUD_FACTION_ARMY, MOB_HUD_FACTION_NAVY)

/obj/item/device/radio/headset/almayer/marine/solardevils/seclead
	initial_keys = list(/obj/item/device/encryptionkey/squadlead)

/obj/item/device/radio/headset/almayer/marine/solardevils/pltco
	initial_keys = list(/obj/item/device/encryptionkey/bravo, /obj/item/device/encryptionkey/squadlead)

/obj/item/device/radio/headset/almayer/marine/solardevils/forecon
	name = "USCM SOF 耳机"
	desc = "仅配发给陆战突袭队和 USCM 武装侦察部队成员。"
	frequency = SOF_FREQ
	initial_keys = list(/obj/item/device/encryptionkey/soc/forecon)
	volume = RADIO_VOLUME_QUIET

/obj/item/device/radio/headset/almayer/marine/solardevils/forecon/synth
	name = "美国殖民地陆战队侦察合成人耳机"
	desc = "仅配发给武装侦察及陆战特战单位所属的美国殖民地陆战队合成人。"
	initial_keys = list(/obj/item/device/encryptionkey/po)
	volume = RADIO_VOLUME_CRITICAL
	has_tracker = TRUE
	misc_tracking = TRUE
	locate_setting = TRACKER_ASL

	inbuilt_tracking_options = list(
		"Squad Leader" = TRACKER_ASL,
		"Landing Zone" = TRACKER_LZ
	)

/obj/item/device/radio/headset/almayer/marine/solardevils/rmc
	name = "皇家陆战突击队耳机"
	desc = "TWE 精锐皇家陆战突击队使用的专用耳机。"
	icon_state = "rmc_headset"
	item_state = "rmc_headset"
	minimap_type = MINIMAP_FLAG_TWE
	frequency = RMC_FREQ
	has_hud = TRUE
	hud_type = list(MOB_HUD_FACTION_TWE, MOB_HUD_FACTION_WY)
	inbuilt_tracking_options = list(
		"Troop Commander" = TRACKER_PLTCO,
		"Section/Team Leader" = TRACKER_FTL,
	)
	locate_setting = TRACKER_PLTCO

/obj/item/device/radio/headset/almayer/marine/solardevils/foxtrot
	frequency = CRYO_FREQ

/obj/item/device/radio/headset/almayer/marine/solardevils/upp
	name = "UPP 海军步兵耳机"
	desc = "UPP 军方使用的专用耳机。"
	icon_state = "upp_headset"
	item_state = "upp_headset"
	frequency = UPP_FREQ
	minimap_type = MINIMAP_FLAG_UPP
	hud_type = list(MOB_HUD_FACTION_UPP)

/obj/item/device/radio/headset/almayer/marine/solardevils/upp/synth
	name = "进步人民联盟合成人耳机"
	desc = "进步人民联盟军方各类合成人使用的特殊耳机。"
	volume = RADIO_VOLUME_IMPORTANT
	has_tracker = TRUE
	misc_tracking = TRUE
	locate_setting = TRACKER_ASL

	inbuilt_tracking_options = list(
		"Platoon Commander" = TRACKER_PLTCO,
		"Platoon Sergeant" = TRACKER_ASL,
		"Landing Zone" = TRACKER_LZ
	)

/obj/item/device/radio/headset/almayer/marine/solardevils/upp/territorial
	name = "进步人民联盟国土卫队耳机"
	desc = "进步人民联盟国土卫队使用的特殊耳机，无法访问海军步兵频道，也提供当地殖民地通信。用 :o 访问殖民地频道。"
	frequency = UPP_GRD_FREQ
	initial_keys = list(/obj/item/device/encryptionkey/colony)

/obj/item/device/radio/headset/almayer/marine/solardevils/upp/medic
	name = "UPP-MED 医疗耳机"
	desc = "进步人民联盟军队使用的特殊耳机。频道：#m - 医疗."
	frequency = UPP_FREQ
	initial_keys = list(/obj/item/device/encryptionkey/upp/medic)

/obj/item/device/radio/headset/almayer/marine/solardevils/upp/command
	name = "UPP-CMD 指挥耳机"
	desc = "进步人民联盟军队使用的特殊耳机。频道：:o - 殖民地, #j - 战斗控制, #n - 工程, #m - 医疗, #v - 指挥, #u - 进步人民联盟通用."
	initial_keys = list(/obj/item/device/encryptionkey/upp/command)

/obj/item/device/radio/headset/almayer/marine/solardevils/canc
	name = "CANC 耳机"
	desc = "CANC 军队使用的特殊耳机。"
	icon_state = "upp_headset"
	item_state = "upp_headset"
	frequency = CLF_FREQ
	has_hud = FALSE //Until we get CANC stuff, this'll do

/obj/item/device/radio/headset/almayer/cia
	name = "无线电耳机"
	desc = "一副无线电耳机。"
	frequency = CIA_FREQ
	initial_keys = list(/obj/item/device/encryptionkey/cia, /obj/item/device/encryptionkey/soc, /obj/item/device/encryptionkey/listening_bug/freq_a)


//############################## ALPHA ###############################
/obj/item/device/radio/headset/almayer/marine/alpha
	name = "陆战队阿尔法无线电耳机"
	desc = "阿尔法小队成员使用的耳机。佩戴后可使用小队长追踪器，空手点击追踪器可打开小队信息窗口。"
	icon_state = "alpha_headset"
	frequency = ALPHA_FREQ //default frequency is alpha squad channel, not PUB_FREQ

/obj/item/device/radio/headset/almayer/marine/alpha/lead
	name = "陆战队阿尔法小队长无线电耳机"
	desc = "陆战队阿尔法小队长使用的耳机。频道如下：:v - 陆战队指挥，:j - JTAC。佩戴后可使用小队长追踪器，空手点击追踪器可打开小队信息窗口。"
	initial_keys = list(/obj/item/device/encryptionkey/public, /obj/item/device/encryptionkey/squadlead)
	volume = RADIO_VOLUME_CRITICAL

/obj/item/device/radio/headset/almayer/marine/alpha/tl
	name = "陆战队阿尔法战斗组长无线电耳机"
	desc = "陆战队阿尔法小队战斗组长使用的耳机。频道如下：:u - 军需，:j - JTAC。佩戴后可使用小队长追踪器，空手点击追踪器可打开小队信息窗口。"
	initial_keys = list(/obj/item/device/encryptionkey/public, /obj/item/device/encryptionkey/jtac)
	volume = RADIO_VOLUME_RAISED

/obj/item/device/radio/headset/almayer/marine/alpha/engi
	name = "陆战队阿尔法工兵无线电耳机"
	desc = "陆战队阿尔法小队战斗工兵使用的耳机。使用 :n 进入工程频道。佩戴后可使用小队长追踪器，空手点击追踪器可打开小队信息窗口。"
	initial_keys = list(/obj/item/device/encryptionkey/public, /obj/item/device/encryptionkey/engi)

/obj/item/device/radio/headset/almayer/marine/alpha/med
	name = "陆战队阿尔法医疗兵无线电耳机"
	desc = "陆战队阿尔法小队战斗医疗兵使用的耳机。使用 :m 进入医疗频道。佩戴后可使用小队长追踪器，空手点击追踪器可打开小队信息窗口。"
	initial_keys = list(/obj/item/device/encryptionkey/public, /obj/item/device/encryptionkey/med)

//############################## BRAVO ###############################
/obj/item/device/radio/headset/almayer/marine/bravo
	name = "陆战队布拉沃无线电耳机"
	desc = "布拉沃小队成员使用的耳机。佩戴后可使用小队长追踪器，空手点击追踪器可打开小队信息窗口。"
	icon_state = "bravo_headset"
	frequency = BRAVO_FREQ

/obj/item/device/radio/headset/almayer/marine/bravo/lead
	name = "陆战队布拉沃小队长无线电耳机"
	desc = "陆战队布拉沃小队长使用的耳机。频道如下：:v - 陆战队指挥，:j - JTAC。佩戴后可使用小队长追踪器，空手点击追踪器可打开小队信息窗口。"
	initial_keys = list(/obj/item/device/encryptionkey/public, /obj/item/device/encryptionkey/squadlead)
	volume = RADIO_VOLUME_CRITICAL

/obj/item/device/radio/headset/almayer/marine/bravo/tl
	name = "陆战队布拉沃战斗组长无线电耳机"
	desc = "陆战队布拉沃小队战斗组长使用的耳机。频道如下：:u - 军需，:j - JTAC。佩戴后可使用小队长追踪器，空手点击追踪器可打开小队信息窗口。"
	initial_keys = list(/obj/item/device/encryptionkey/public, /obj/item/device/encryptionkey/jtac)
	volume = RADIO_VOLUME_RAISED

/obj/item/device/radio/headset/almayer/marine/bravo/engi
	name = "陆战队布拉沃工兵无线电耳机"
	desc = "陆战队布拉沃小队战斗工兵使用的耳机。使用 :n 进入工程频道。佩戴后可使用小队长追踪器，空手点击追踪器可打开小队信息窗口。"
	initial_keys = list(/obj/item/device/encryptionkey/public, /obj/item/device/encryptionkey/engi)

/obj/item/device/radio/headset/almayer/marine/bravo/med
	name = "陆战队布拉沃医疗兵无线电耳机"
	desc = "陆战队布拉沃小队战斗医疗兵使用的耳机。使用 :m 进入医疗频道。佩戴后可使用小队长追踪器，空手点击追踪器可打开小队信息窗口。"
	initial_keys = list(/obj/item/device/encryptionkey/public, /obj/item/device/encryptionkey/med)

//############################## CHARLIE ###############################
/obj/item/device/radio/headset/almayer/marine/charlie
	name = "陆战队查理无线电耳机"
	desc = "查理小队成员使用的耳机。佩戴后可使用小队长追踪器，空手点击追踪器可打开小队信息窗口。"
	icon_state = "charlie_headset"
	frequency = CHARLIE_FREQ

/obj/item/device/radio/headset/almayer/marine/charlie/lead
	name = "陆战队查理小队长无线电耳机"
	desc = "陆战队查理小队长使用的耳机。频道如下：:v - 陆战队指挥，:j - JTAC。佩戴后可使用小队长追踪器，空手点击追踪器可打开小队信息窗口。"
	initial_keys = list(/obj/item/device/encryptionkey/public, /obj/item/device/encryptionkey/squadlead)
	volume = RADIO_VOLUME_CRITICAL

/obj/item/device/radio/headset/almayer/marine/charlie/tl
	name = "陆战队查理战斗组长无线电耳机"
	desc = "陆战队查理小队战斗组长使用的耳机。频道如下：:u - 军需，:j - JTAC。佩戴后可使用小队长追踪器，空手点击追踪器可打开小队信息窗口。"
	initial_keys = list(/obj/item/device/encryptionkey/public, /obj/item/device/encryptionkey/jtac)
	volume = RADIO_VOLUME_RAISED

/obj/item/device/radio/headset/almayer/marine/charlie/engi
	name = "陆战队查理工兵无线电耳机"
	desc = "陆战队查理小队战斗工兵使用的耳机。使用 :n 进入工程频道。佩戴后可使用小队长追踪器，空手点击追踪器可打开小队信息窗口。"
	initial_keys = list(/obj/item/device/encryptionkey/public, /obj/item/device/encryptionkey/engi)

/obj/item/device/radio/headset/almayer/marine/charlie/med
	name = "陆战队查理医疗兵无线电耳机"
	desc = "陆战队查理小队战斗医疗兵使用的耳机。使用 :m 进入医疗频道。佩戴后可使用小队长追踪器，空手点击追踪器可打开小队信息窗口。"
	initial_keys = list(/obj/item/device/encryptionkey/public, /obj/item/device/encryptionkey/med)

//############################## DELTA ###############################
/obj/item/device/radio/headset/almayer/marine/delta
	name = "陆战队德尔塔无线电耳机"
	desc = "德尔塔小队成员使用的耳机。佩戴后可使用小队长追踪器，空手点击追踪器可打开小队信息窗口。"
	icon_state = "delta_headset"
	frequency = DELTA_FREQ

/obj/item/device/radio/headset/almayer/marine/delta/lead
	name = "陆战队德尔塔小队长无线电耳机"
	desc = "陆战队德尔塔小队长使用的耳机。频道如下：:v - 陆战队指挥，:j - JTAC。佩戴后可使用小队长追踪器，空手点击追踪器可打开小队信息窗口。"
	initial_keys = list(/obj/item/device/encryptionkey/public, /obj/item/device/encryptionkey/squadlead)
	volume = RADIO_VOLUME_CRITICAL

/obj/item/device/radio/headset/almayer/marine/delta/tl
	name = "陆战队德尔塔战斗组长无线电耳机"
	desc = "陆战队德尔塔小队战斗组长使用的耳机。频道如下：:u - 军需，:j - JTAC。佩戴后可使用小队长追踪器，空手点击追踪器可打开小队信息窗口。"
	initial_keys = list(/obj/item/device/encryptionkey/public, /obj/item/device/encryptionkey/jtac)
	volume = RADIO_VOLUME_RAISED

/obj/item/device/radio/headset/almayer/marine/delta/engi
	name = "陆战队德尔塔工兵无线电耳机"
	desc = "陆战队德尔塔小队战斗工兵使用的耳机。使用 :n 进入工程频道。佩戴后可使用小队长追踪器，空手点击追踪器可打开小队信息窗口。"
	initial_keys = list(/obj/item/device/encryptionkey/public, /obj/item/device/encryptionkey/engi)

/obj/item/device/radio/headset/almayer/marine/delta/med
	name = "陆战队德尔塔医疗兵无线电耳机"
	desc = "陆战队德尔塔小队战斗医疗兵使用的耳机。使用 :m 进入医疗频道。佩戴后可使用小队长追踪器，空手点击追踪器可打开小队信息窗口。"
	initial_keys = list(/obj/item/device/encryptionkey/public, /obj/item/device/encryptionkey/med)

//############################## ECHO ###############################
/obj/item/device/radio/headset/almayer/marine/echo
	name = "陆战队回声小队无线电耳机"
	desc = "供回声小队成员使用。佩戴后可使用队长追踪器。空手点击追踪器即可打开小队信息窗口。"
	icon_state = "echo_headset"
	frequency = ECHO_FREQ

/obj/item/device/radio/headset/almayer/marine/echo/lead
	name = "陆战队回声小队队长无线电耳机"
	desc = "供陆战队回声小队队长使用。频道：:v——陆战队指挥，:j——联合终端攻击控制。佩戴后可使用队长追踪器。空手点击追踪器即可打开小队信息窗口。"
	initial_keys = list(/obj/item/device/encryptionkey/public, /obj/item/device/encryptionkey/squadlead)
	volume = RADIO_VOLUME_CRITICAL

/obj/item/device/radio/headset/almayer/marine/echo/tl
	name = "陆战队回声小队战斗组长无线电耳机"
	desc = "供陆战队回声战斗组长使用。频道：:u——军需，:j——联合终端攻击控制。佩戴后可使用队长追踪器。空手点击追踪器即可打开小队信息窗口。"
	initial_keys = list(/obj/item/device/encryptionkey/public, /obj/item/device/encryptionkey/jtac)
	volume = RADIO_VOLUME_RAISED

/obj/item/device/radio/headset/almayer/marine/echo/engi
	name = "陆战队回声小队工程兵无线电耳机"
	desc = "供陆战队回声战斗工程兵使用。用 :n 访问工程频道。佩戴后可使用队长追踪器。空手点击追踪器即可打开小队信息窗口。"
	initial_keys = list(/obj/item/device/encryptionkey/public, /obj/item/device/encryptionkey/engi)

/obj/item/device/radio/headset/almayer/marine/echo/med
	name = "陆战队回声小队医护兵无线电耳机"
	desc = "供陆战队回声战斗医护兵使用。用 :m 访问医疗频道。佩戴后可使用队长追踪器。空手点击追踪器即可打开小队信息窗口。"
	initial_keys = list(/obj/item/device/encryptionkey/public, /obj/item/device/encryptionkey/med)


//############################## CRYO ###############################
/obj/item/device/radio/headset/almayer/marine/cryo
	name = "陆战队狐步小队无线电耳机"
	desc = "供狐步小队成员使用。佩戴后可使用队长追踪器。空手点击追踪器即可打开小队信息窗口。"
	icon_state = "cryo_headset"
	frequency = CRYO_FREQ

/obj/item/device/radio/headset/almayer/marine/cryo/lead
	name = "陆战队狐步小队队长无线电耳机"
	desc = "供陆战队狐步小队队长使用。频道：:v——陆战队指挥，:j——联合终端攻击控制。佩戴后可使用队长追踪器。空手点击追踪器即可打开小队信息窗口。"
	initial_keys = list(/obj/item/device/encryptionkey/public, /obj/item/device/encryptionkey/squadlead)
	volume = RADIO_VOLUME_CRITICAL

/obj/item/device/radio/headset/almayer/marine/cryo/tl
	name = "陆战队狐步小队战斗组长无线电耳机"
	desc = "供陆战队狐步战斗组长使用。频道：:u——军需，:j——联合终端攻击控制。佩戴后可使用队长追踪器。空手点击追踪器即可打开小队信息窗口。"
	initial_keys = list(/obj/item/device/encryptionkey/public, /obj/item/device/encryptionkey/jtac)
	volume = RADIO_VOLUME_RAISED

/obj/item/device/radio/headset/almayer/marine/cryo/engi
	name = "陆战队狐步小队工程兵无线电耳机"
	desc = "供陆战队狐步战斗工程兵使用。用 :n 访问工程频道。佩戴后可使用队长追踪器。空手点击追踪器即可打开小队信息窗口。"
	initial_keys = list(/obj/item/device/encryptionkey/public, /obj/item/device/encryptionkey/engi)

/obj/item/device/radio/headset/almayer/marine/cryo/med
	name = "陆战队狐步小队医护兵无线电耳机"
	desc = "供陆战队狐步战斗医护兵使用。用 :m 访问医疗频道。佩戴后可使用队长追踪器。空手点击追踪器即可打开小队信息窗口。"
	initial_keys = list(/obj/item/device/encryptionkey/public, /obj/item/device/encryptionkey/med)

/obj/item/device/radio/headset/almayer/marine/mortar
	name = "迫击炮组无线电耳机"
	desc = "尘土突袭者地堡迫击炮组用它了解那阵 80 毫米弹雨的命中效果。可用 :e 访问工程频道、:j 协调联合终端攻击控制、:t 联络情报，以及 :u 请求更多炮弹——这里可不是温彻斯特哨站！"
	icon_state = "ce_headset"
	initial_keys = list(/obj/item/device/encryptionkey/mortar)
	volume = RADIO_VOLUME_RAISED

//*************************************
//-----SELF SETTING MARINE HEADSET-----
//*************************************/
//For events. Currently used for WO only. After equipping it, self_set() will adapt headset to marine.

/obj/item/device/radio/headset/almayer/marine/self_setting/proc/self_set()
	var/mob/living/carbon/human/H = loc
	if(istype(H, /mob/living/carbon/human))
		if(H.assigned_squad)
			switch(H.assigned_squad.name)
				if(SQUAD_MARINE_2)
					name = "[SQUAD_MARINE_2]无线电耳机"
					desc = "供[SQUAD_MARINE_2]小队成员使用。"
					icon_state = "bravo_headset"
					frequency = BRAVO_FREQ
				if(SQUAD_MARINE_3)
					name = "[SQUAD_MARINE_3]无线电耳机"
					desc = "供[SQUAD_MARINE_3]小队成员使用。"
					icon_state = "charlie_headset"
					frequency = CHARLIE_FREQ
				if(SQUAD_MARINE_4)
					name = "[SQUAD_MARINE_4]无线电耳机"
					desc = "供[SQUAD_MARINE_4]小队成员使用。"
					icon_state = "delta_headset"
					frequency = DELTA_FREQ
				if(SQUAD_MARINE_5)
					name = "[SQUAD_MARINE_5]无线电耳机"
					desc = "供[SQUAD_MARINE_5]小队成员使用。"
					frequency = ECHO_FREQ
				if(SQUAD_MARINE_CRYO)
					name = "[SQUAD_MARINE_CRYO]无线电耳机"
					desc = "供[SQUAD_MARINE_CRYO]小队成员使用。"
					frequency = CRYO_FREQ

			if(H.assigned_squad.name == GLOB.main_platoon_name)
				name = "[GLOB.main_platoon_name]无线电耳机"
				desc = "供[GLOB.main_platoon_name]小队成员使用。"
				icon_state = "alpha_headset"
				frequency = ALPHA_FREQ

			switch(GET_DEFAULT_ROLE(H.job))
				if(JOB_SQUAD_LEADER)
					name = "陆战队队长 " + name
					keys += new /obj/item/device/encryptionkey/squadlead(src)
					volume = RADIO_VOLUME_CRITICAL
				if(JOB_SQUAD_MEDIC)
					name = "陆战队医护兵 " + name
					keys += new /obj/item/device/encryptionkey/med(src)
				if(JOB_SQUAD_ENGI)
					name = "陆战队战斗技师 " + name
					keys += new /obj/item/device/encryptionkey/engi(src)
				if(JOB_SQUAD_TEAM_LEADER)
					name = "陆战队战斗组长 " + name
					keys += new /obj/item/device/encryptionkey/jtac(src)
				else
					name = "陆战队员 " + name

			set_frequency(frequency)
			for(var/ch_name in channels)
				secure_radio_connections[ch_name] = SSradio.add_object(src, GLOB.radiochannels[ch_name],  RADIO_CHAT)
			recalculateChannels()
			if(H.mind && H.hud_used && H.hud_used.locate_leader) //make SL tracker visible
				H.hud_used.locate_leader.alpha = 255
				H.hud_used.locate_leader.mouse_opacity = MOUSE_OPACITY_ICON

//Distress (ERT) headsets.

/obj/item/device/radio/headset/distress
	name = "殖民地耳机"
	desc = "殖民者使用的标准耳机。"
	frequency = COLONY_FREQ

/obj/item/device/radio/headset/distress/WY
	name = "维兰德-汤谷公司耳机"
	desc = "维兰德-汤谷公司人员常戴的耳机。"
	frequency = WY_FREQ
	initial_keys = list(/obj/item/device/encryptionkey/colony, /obj/item/device/encryptionkey/WY)

/obj/item/device/radio/headset/distress/dutch
	name = "达奇十二人组耳机"
	desc = "小队受训行动人员使用的专用耳机，也可能是恐怖分子使用的。用 :h 进入殖民地频道。"
	frequency = DUT_FREQ
	initial_keys = list(/obj/item/device/encryptionkey/colony)
	ignore_z = TRUE

/obj/item/device/radio/headset/distress/pmc
	name = "PMC 耳机"
	desc = "公司人员使用的专用耳机。频道如下：:g - 公共，:v - 陆战队指挥，:a - 阿尔法小队，:b - 布拉沃小队，:c - 查理小队，:d - 德尔塔小队，:n - 工程，:m - 医疗，:u - 军需，:j - JTAC，:t - 情报，:y - 公司。"
	frequency = PMC_FREQ
	icon_state = "pmc_headset"
	initial_keys = list(/obj/item/device/encryptionkey/public, /obj/item/device/encryptionkey/mcom/cl)
	has_hud = TRUE
	hud_type = list(MOB_HUD_FACTION_PMC, MOB_HUD_FACTION_WY, MOB_HUD_FACTION_TWE)

	misc_tracking = TRUE
	locate_setting = TRACKER_CL
	inbuilt_tracking_options = list(
		"Corporate Liaison" = TRACKER_CL
	)

/obj/item/device/radio/headset/distress/pmc/platoon
	desc = "公司私人军事承包商使用的专用耳机。频道如下：#p - 通用，#y - 维兰德-汤谷。"
	initial_keys = list(/obj/item/device/encryptionkey/pmc)
	locate_setting = TRACKER_SL
	inbuilt_tracking_options = list(
		"Overwatch" = TRACKER_PLTCO,
		"Operation Leader" = TRACKER_SL,
		"Team Leader" = TRACKER_FTL,
		"Landing Zone" = TRACKER_LZ
	)

/obj/item/device/radio/headset/distress/pmc/platoon/synth
	name = "私人军事公司合成人耳机"
	desc = "配发给公司支援合成人的耳机及抬头显示单元。频道：#p - 通用, #y - WY,  #z - 指挥, #f - 医疗, #e - 工程, #o - JTAC."
	initial_keys = list(/obj/item/device/encryptionkey/pmc/command)
	volume = RADIO_VOLUME_IMPORTANT
	has_tracker = TRUE
	misc_tracking = TRUE
	locate_setting = TRACKER_ASL

	inbuilt_tracking_options = list(
		"Overwatch" = TRACKER_PLTCO,
		"Operation Leader" = TRACKER_ASL,
		"Landing Zone" = TRACKER_LZ
	)

/obj/item/device/radio/headset/distress/pmc/platoon/cmd
	name = "战场监控耳机"
	desc = "私人军事公司战场监控人员使用的特殊耳机及抬头显示单元。频道：#p - 通用, #y - WY,  #z - 指挥, #f - 医疗, #e - 工程, #o - JTAC."
	initial_keys = list(/obj/item/device/encryptionkey/pmc/command)

/obj/item/device/radio/headset/distress/cbrn
	name = "\improper 核生化防护耳机"
	desc = "配发给核生化防护陆战队员的耳机。频道：:g - 公共, :v - 陆战队指挥, :a - 阿尔法小队, :b - 布拉沃小队, :c - 查理小队, :d - 德尔塔小队, :n - 工程, :m - 医疗, :u - 军需, :j - JTAC, :t - 情报"
	frequency = CBRN_FREQ
	initial_keys = list(/obj/item/device/encryptionkey/public, /obj/item/device/encryptionkey/mcom)
	ignore_z = TRUE
	has_hud = TRUE

/obj/item/device/radio/headset/distress/forecon
	name = "\improper 武装侦察耳机"
	desc = "配发给武装侦察陆战队员的耳机。频道：:g - 公共, :v - 陆战队指挥, :a - 阿尔法小队, :b - 布拉沃小队, :c - 查理小队, :d - 德尔塔小队, :n - 工程, :m - 医疗, :u - 军需, :j - JTAC, :t - 情报"
	frequency = FORECON_FREQ
	initial_keys = list(/obj/item/device/encryptionkey/public, /obj/item/device/encryptionkey/mcom)
	ignore_z = TRUE
	has_hud = TRUE

/obj/item/device/radio/headset/distress/pmc/hvh
	desc = "公司人员使用的专用耳机。频道如下：:o - 殖民地。"
	initial_keys = list(/obj/item/device/encryptionkey/colony, /obj/item/device/encryptionkey/WY)
	misc_tracking = FALSE

/obj/item/device/radio/headset/distress/pmc/cct
	name = "PMC-CCT 战斗控制耳机"
	desc = "公司人员使用的特殊耳机。频道：:o - 殖民地, #e - 工程, #o - JTAC, #p - 通用"
	initial_keys = list(/obj/item/device/encryptionkey/colony, /obj/item/device/encryptionkey/pmc/engi, /obj/item/device/encryptionkey/mcom/cl)

/obj/item/device/radio/headset/distress/pmc/cct/hvh
	initial_keys = list(/obj/item/device/encryptionkey/colony, /obj/item/device/encryptionkey/pmc/engi)

/obj/item/device/radio/headset/distress/pmc/medic
	name = "PMC-MED 医疗耳机"
	desc = "公司人员使用的特殊耳机。频道：:o - 殖民地, #f - 医疗, #p - 通用"
	initial_keys = list(/obj/item/device/encryptionkey/colony, /obj/item/device/encryptionkey/pmc/medic, /obj/item/device/encryptionkey/mcom/cl)

/obj/item/device/radio/headset/distress/pmc/medic/hvh
	initial_keys = list(/obj/item/device/encryptionkey/colony, /obj/item/device/encryptionkey/pmc/medic)

/obj/item/device/radio/headset/distress/pmc/command
	name = "PMC-CMD 指挥耳机"
	desc = "公司人员使用的特殊耳机。频道：:o - 殖民地, #z - 指挥, #f - 医疗, #e - 工程, #o - JTAC, #p - 通用"
	initial_keys = list(/obj/item/device/encryptionkey/colony, /obj/item/device/encryptionkey/pmc/command, /obj/item/device/encryptionkey/mcom/cl)

/obj/item/device/radio/headset/distress/pmc/command/hvh
	initial_keys = list(/obj/item/device/encryptionkey/colony, /obj/item/device/encryptionkey/pmc/command)

/obj/item/device/radio/headset/distress/pmc/command/director
	name = "维兰德-汤谷总监耳机"
	desc = "公司总监使用的特殊耳机。频道：:o - 殖民地, #z - 指挥, #f - 医疗, #e - 工程, #o - JTAC, #p - 通用"
	maximum_keys = 4
	initial_keys = list(/obj/item/device/encryptionkey/colony, /obj/item/device/encryptionkey/pmc/command, /obj/item/device/encryptionkey/commando, /obj/item/device/encryptionkey/mcom/cl)

/obj/item/device/radio/headset/distress/pmc/command/director/hvh
	maximum_keys = 3
	initial_keys = list(/obj/item/device/encryptionkey/colony, /obj/item/device/encryptionkey/pmc/command, /obj/item/device/encryptionkey/commando)

//UPP Headsets
/obj/item/device/radio/headset/distress/UPP
	name = "进步人民联盟海军步兵耳机"
	desc = "进步人民联盟军队使用的特殊耳机。"
	frequency = UPP_FREQ
	has_hud = TRUE
	hud_type = list(MOB_HUD_FACTION_UPP)
	minimap_type = MINIMAP_FLAG_UPP

/obj/item/device/radio/headset/distress/UPP/territorial
	name = "进步人民联盟国土卫队耳机"
	desc = "进步人民联盟国土卫队使用的特殊耳机，无法访问海军步兵频道，也提供当地殖民地通信。用 :o 访问殖民地频道。"
	frequency = UPP_GRD_FREQ
	initial_keys = list(/obj/item/device/encryptionkey/colony)

/obj/item/device/radio/headset/distress/UPP/cct
	name = "UPP-CCT 战斗控制耳机"
	desc = "进步人民联盟军队使用的特殊耳机。频道：:o - 殖民地, #j - 战斗控制, #n 工程."
	initial_keys = list(/obj/item/device/encryptionkey/colony, /obj/item/device/encryptionkey/upp/engi)

/obj/item/device/radio/headset/distress/UPP/medic
	name = "UPP-MED 医疗耳机"
	desc = "进步人民联盟军队使用的特殊耳机。频道：:o - 殖民地, #m - 医疗."
	initial_keys = list(/obj/item/device/encryptionkey/colony, /obj/item/device/encryptionkey/upp/medic)

/obj/item/device/radio/headset/distress/UPP/command
	name = "UPP-CMD 指挥耳机"
	desc = "进步人民联盟军队使用的特殊耳机。频道：:o - 殖民地, #j - 战斗控制, #n - 工程, #m - 医疗, #v - 指挥, #u - 进步人民联盟通用."
	initial_keys = list(/obj/item/device/encryptionkey/colony, /obj/item/device/encryptionkey/upp/command)

/obj/item/device/radio/headset/distress/UPP/kdo
	name = "UPP-Kdo 突击队耳机"
	desc = "进步人民联盟突击队使用的专用耳机。频道：#j - 战斗控制, #u - 进步人民联盟通用, #T - 突击队."
	initial_keys = /obj/item/device/encryptionkey/upp/kdo

/obj/item/device/radio/headset/distress/UPP/kdo/medic
	name = "UPP-KdoM 突击队医疗耳机"
	desc = "进步人民联盟突击队使用的专用耳机。频道：:o - 殖民地, #j - 战斗控制, #m - 医疗 #u - 进步人民联盟通用, #T - 突击队."
	initial_keys = list(/obj/item/device/encryptionkey/upp/kdo, /obj/item/device/encryptionkey/colony)

/obj/item/device/radio/headset/distress/UPP/kdo/command
	name = "UPP-KdoC 突击队指挥耳机"
	desc = "进步人民联盟突击队使用的专用耳机。频道：:o - 殖民地, #j - 战斗控制, #n - 工程, #m - 医疗, #v - 指挥, #u - 进步人民联盟通用, #T - 突击队."
	initial_keys = list(/obj/item/device/encryptionkey/upp/kdo, /obj/item/device/encryptionkey/colony, /obj/item/device/encryptionkey/upp/command)

//CLF Headsets
/obj/item/device/radio/headset/distress/CLF
	name = "殖民地耳机"
	desc = "殖民者使用的标准耳机，但这副被动过手脚。用 :o 访问殖民地频道。"
	frequency = CLF_FREQ
	initial_keys = list(/obj/item/device/encryptionkey/colony)
	has_hud = TRUE
	hud_type = list(MOB_HUD_FACTION_CLF)

/obj/item/device/radio/headset/distress/CLF/cct
	name = "CLF-CCT 战斗控制耳机"
	desc = "受过训练的小股行动人员使用的特殊耳机。也可能是恐怖分子。频道：:o - 殖民地, #b - 工程"
	initial_keys = list(/obj/item/device/encryptionkey/colony, /obj/item/device/encryptionkey/clf/engi)

/obj/item/device/radio/headset/distress/CLF/medic
	name = "CLF-MED 医疗耳机"
	desc = "受过训练的小股行动人员使用的特殊耳机。也可能是恐怖分子。频道：:o - 殖民地, #a - 医疗"
	initial_keys = list(/obj/item/device/encryptionkey/colony, /obj/item/device/encryptionkey/clf/medic)

/obj/item/device/radio/headset/distress/CLF/command
	desc = "受过训练的小股行动人员使用的特殊耳机。也可能是恐怖分子。频道：:o - 殖民地, #a - 医疗, #b - 工程, #c - 指挥, #d - 战斗控制, #g 解放阵线通用"
	initial_keys = list(/obj/item/device/encryptionkey/colony, /obj/item/device/encryptionkey/clf/command)

//WY Headsets
/obj/item/device/radio/headset/distress/commando
	name = "突击队耳机"
	desc = "身份不明的行动人员使用的特殊耳机。频道：:g - 公共, :v - 陆战队指挥, :a - 阿尔法小队, :b - 布拉沃小队, :c - 查理小队, :d - 德尔塔小队, :n - 工程, :m - 医疗, :u - 军需, :j - JTAC, :t - 情报."
	frequency = WY_WO_FREQ
	icon_state = "pmc_headset"
	initial_keys = list(/obj/item/device/encryptionkey/public, /obj/item/device/encryptionkey/mcom)

/obj/item/device/radio/headset/distress/contractor
	name = "先锋之箭公司耳机"
	desc = "先锋之箭公司雇佣兵使用的特殊耳机，配有非标准支架。频道：:g - 公共, :v - 陆战队指挥, :n - 工程, :m - 医疗, :u - 军需, :j - JTAC, :t - 情报."
	frequency = VAI_FREQ
	icon_state = "vai_headset"
	initial_keys = list(/obj/item/device/encryptionkey/public, /obj/item/device/encryptionkey/contractor)
	has_hud = TRUE

/obj/item/device/radio/headset/distress/royal_marine
	name = "皇家陆战突击队耳机"
	desc = "三世界帝国精锐皇家陆战突击队使用的特殊耳机。"
	frequency = RMC_FREQ
	icon_state = "vai_headset"
	initial_keys = list(/obj/item/device/encryptionkey/royal_marine)
	has_hud = TRUE
	hud_type = list(MOB_HUD_FACTION_TWE, MOB_HUD_FACTION_WY)
	volume = RADIO_VOLUME_IMPORTANT

//CMB Headsets
/obj/item/device/radio/headset/distress/CMB
	name = "\improper 殖民地执法局耳塞"
	desc = "殖民地执法局使用的低调耳塞。频道：; - CMB, :o - 殖民地, :g - 公共, :v - 陆战队指挥, :m - 医疗, :t - 情报."
	frequency = CMB_FREQ
	icon_state = "cmb_headset"
	initial_keys = list(/obj/item/device/encryptionkey/colony)
	has_hud = TRUE
	hud_type = list(MOB_HUD_FACTION_MARSHAL)

/obj/item/device/radio/headset/distress/CMB/limited
	name = "\improper 殖民地执法局耳塞"
	desc = "殖民地执法局使用的低调耳塞。频道：; - CMB, :o - 殖民地."
	initial_keys = list(/obj/item/device/encryptionkey/colony)

/obj/item/device/radio/headset/distress/CMB/ICC
	name = "\improper 星际商业委员会联络耳机"
	desc = "星际商业委员会使用的昂贵耳机，特别装有殖民地执法局联络芯片。频道：; - CMB, :o - 殖民地, :g - 公共, :v - 陆战队指挥, :m - 医疗, :t - 情报, :y - 维兰德-汤谷."
	icon_state = "wy_headset"
	initial_keys = list(/obj/item/device/encryptionkey/WY, /obj/item/device/encryptionkey/cmb)

/obj/item/device/radio/headset/almayer/highcom
	name = "美国殖民地陆战队最高指挥部耳机"
	desc = "配发给美国殖民地陆战队最高指挥部成员及其直属下级。频道：:v - 陆战队指挥, :p - 宪兵, :a - 阿尔法小队, :b - 布拉沃小队, :c - 查理小队, :d - 德尔塔小队, :n - 工程, :m - 医疗, :u - 军需, :j - JTAC,  :t - 情报,  :z - 最高指挥部"
	icon_state = "mhc_headset"
	frequency = HC_FREQ
	initial_keys = list(/obj/item/device/encryptionkey/highcom)
	volume = RADIO_VOLUME_CRITICAL

/obj/item/device/radio/headset/almayer/provost
	name = "美国殖民地陆战队军法监察耳机"
	desc = "配发给美国殖民地陆战队军法监察办公室成员及其直属下级。"
	icon_state = "pvst_headset"
	frequency = PVST_FREQ
	initial_keys = list(/obj/item/device/encryptionkey/provost)
	volume = RADIO_VOLUME_CRITICAL

/obj/item/device/radio/headset/almayer/sof
	name = "美国殖民地陆战队特战耳机"
	desc = "仅配发给陆战突击队及美国殖民地陆战队武装侦察人员。"
	icon_state = "soc_headset"
	frequency = SOF_FREQ
	initial_keys = list(/obj/item/device/encryptionkey/soc)
	volume = RADIO_VOLUME_IMPORTANT

/obj/item/device/radio/headset/almayer/sof/survivor_forecon
	name = "美国殖民地陆战队特战耳机"
	desc = "仅配发给陆战突击队及美国殖民地陆战队武装侦察人员。"
	icon_state = "soc_headset"
	frequency = SOF_FREQ
	initial_keys = list(/obj/item/device/encryptionkey/soc/forecon)
	volume = RADIO_VOLUME_QUIET
	has_hud = TRUE
	hud_type = list(MOB_HUD_FACTION_ARMY, MOB_HUD_FACTION_MARINE, MOB_HUD_FACTION_NAVY)

/obj/item/device/radio/headset/almayer/mcom/vc
	name = "陆战队载具乘员无线电耳机"
	desc = "美国殖民地陆战队载具乘员使用，配有非标准支架。频道：:v - 陆战队指挥, :n - 工程, :m - 医疗, :u - 军需"
	initial_keys = list(/obj/item/device/encryptionkey/vc)
	volume = RADIO_VOLUME_RAISED
	multibroadcast_cooldown = HIGH_MULTIBROADCAST_COOLDOWN

/obj/item/device/radio/headset/distress/UPP/recon
	name = "\improper 进步人民联盟耳机"
	desc = "进步人民联盟军队侦察单位使用的特殊耳机。"
	frequency = UPP_FREQ
	initial_keys = list(/obj/item/device/encryptionkey/upp)
	volume = RADIO_VOLUME_QUIET
	ignore_z = FALSE
	has_hud = TRUE
	hud_type = list(MOB_HUD_FACTION_UPP)

/obj/item/device/radio/headset/distress/USASF
	name = "\improper 美国航空航天部队耳塞"
	desc = "美国航空航天部队人员使用的流线型耳机，产自太阳系，低调且舒适得出奇。频道：; - USASF, :o - 殖民地."
	frequency = ASF_FREQ
	icon_state = "nav_headset"
	initial_keys = list(/obj/item/device/encryptionkey/usasf)
	has_hud = TRUE
	hud_type = list(MOB_HUD_FACTION_ARMY, MOB_HUD_FACTION_MARINE, MOB_HUD_FACTION_NAVY)

/obj/item/device/radio/headset/distress/USASF/attache
	desc = "美国航空航天部队人员使用的流线型耳机，产自太阳系，低调且舒适得出奇。频道：; - USASF, :o - 殖民地, :a 当地美国殖民地陆战队."
	initial_keys = list(/obj/item/device/encryptionkey/usasf/attache)

/obj/item/device/radio/headset/distress/USASF/command
	name = "\improper 美国航空航天部队指挥耳塞"
	desc = "美国航空航天部队军官使用的流线型耳机，产自太阳系，低调且舒适得出奇，配有加强支架。频道：; - USASF, :o - 殖民地, :g - 公共, :v - 指挥, :J - JTAC."
	icon_state = "navcom_headset"
	initial_keys = list(/obj/item/device/encryptionkey/usasf/command)
	volume = RADIO_VOLUME_CRITICAL

/obj/item/device/radio/headset/distress/USASF/command/attache
	name = "\improper 美国航空航天部队指挥耳塞"
	desc = "美国航空航天部队军官使用的流线型耳机，产自太阳系，低调且舒适得出奇，配有加强支架。频道：; - USASF, :o - 殖民地, :g - 公共, :v - 陆战队指挥, :J - JTAC, :a 当地美国殖民地陆战队."
	icon_state = "navcom_headset"
	initial_keys = list(/obj/item/device/encryptionkey/usasf/command/attache)
	volume = RADIO_VOLUME_CRITICAL

/obj/item/device/radio/headset/distress/army
	name = "\improper 美国陆军无线电耳机"
	desc = "美国陆军人员使用的坚固耳机，设计寿命比使用者还长。频道：; - 美国陆军, :o - 殖民地."
	frequency = ARM_FREQ
	icon_state = "arm_headset"
	initial_keys = list(/obj/item/device/encryptionkey/army)
	has_hud = TRUE
	hud_type = list(MOB_HUD_FACTION_ARMY, MOB_HUD_FACTION_MARINE, MOB_HUD_FACTION_NAVY)

/obj/item/device/radio/headset/distress/army/attache
	desc = "美国陆军人员使用的坚固耳机，设计寿命比使用者还长。频道：; - 美国陆军, :o - 殖民地, :a 当地美国殖民地陆战队."
	initial_keys = list(/obj/item/device/encryptionkey/army/attache)

/obj/item/device/radio/headset/distress/army/command
	name = "\improper 美国陆军指挥耳机"
	desc = "美国陆军军官使用的坚固耳机，设计寿命比使用者还长。此型配有加强支架和闪灯，让你在部下面前显得更重要！频道：; - 美国陆军, :o - 殖民地, :v - 指挥, :J - JTAC."
	icon_state = "armcom_headset"
	initial_keys = list(/obj/item/device/encryptionkey/army/command)
	volume = RADIO_VOLUME_CRITICAL

/obj/item/device/radio/headset/distress/army/command/attache
	name = "\improper 美国陆军指挥耳机"
	desc = "美国陆军军官使用的坚固耳机，设计寿命比使用者还长。此型配有加强支架和闪灯，让你在部下面前显得更重要！频道：; - 美国陆军, :o - 殖民地, :v - 陆战队指挥, :J - JTAC, :a 当地美国殖民地陆战队."
	icon_state = "armcom_headset"
	initial_keys = list(/obj/item/device/encryptionkey/army/command/attache)
	volume = RADIO_VOLUME_CRITICAL

/obj/item/device/radio/headset/distress/guard
	name = "\improper 殖民地卫队无线电耳机"
	desc = "美洲联盟殖民地卫队使用的坚固耳机，设计寿命比使用者还长。频道：#d - 殖民地卫队, :o - 殖民地."
	frequency = GRD_FREQ
	icon_state = "generic_headset"
	initial_keys = list(/obj/item/device/encryptionkey/guard)
	has_hud = TRUE
	hud_type = list(MOB_HUD_FACTION_MARSHAL, MOB_HUD_FACTION_UACG)

/obj/item/device/radio/headset/distress/rebel_ua
	name = "殖民地耳机"
	desc = "殖民者使用的标准耳机，但这副被动过手脚。用 :o 访问殖民地频道。"
	frequency = PFA_FREQ
	initial_keys = list(/obj/item/device/encryptionkey/colony)

/obj/item/device/radio/headset/distress/rebel_twe
	name = "殖民地耳机"
	desc = "殖民者使用的标准耳机，但这副被动过手脚。用 :o 访问殖民地频道。"
	frequency = JSC_FREQ
	initial_keys = list(/obj/item/device/encryptionkey/colony)

/obj/item/device/radio/headset/distress/merc
	name = "雇佣兵耳机"
	desc = "由民用商用耳机改成的军用耳机。频道：; - 雇佣兵,  :o - 殖民地."
	frequency = MERC_FREQ
	initial_keys = list(/obj/item/device/encryptionkey/colony)
	ignore_z = TRUE
