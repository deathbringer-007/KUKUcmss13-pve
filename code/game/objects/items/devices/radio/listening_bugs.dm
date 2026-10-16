#define DISGUISE_REMOVE "remove disguise"
#define DISGUISE_RADIO "radio"
#define DISGUISE_PEN "pen"
#define DISGUISE_FOUNTAIN_PEN "fountain pen"
#define DISGUISE_ACCESS_TUNER "access tuner"
#define DISGUISE_WHISTLE "whistle"
#define DISGUISE_MASS_SPEC "mass-spectrometer"
#define DISGUISE_CAMERA "camera"
#define DISGUISE_ZIPPO "zippo lighter"
#define DISGUISE_TAPE_RECORDER "tape recorder"

/obj/item/device/radio/listening_bug
	name = "窃听器"
	desc = "小巧且可伪装成其他物品的窃听设备。"

	icon = 'icons/obj/items/devices.dmi'
	icon_state = "voice0"
	item_state = "analyzer"

	w_class = SIZE_TINY
	volume = RADIO_VOLUME_RAISED

	broadcasting = FALSE
	listening = FALSE
	frequency = BUG_A_FREQ
	canhear_range = 2
	freqlock = TRUE
	/// If the bug is disguised or not.
	var/ready_to_disguise = FALSE
	var/disguised = FALSE
	/// Whether or not the bug can be used to listen to its own channel.
	var/prevent_snooping = FALSE
	/// The ID tag of the device, for identification.
	var/nametag = "设备"

/obj/item/device/radio/listening_bug/ui_data(mob/user)
	var/list/data = list()

	data["broadcasting"] = broadcasting
	data["listening"] = listening
	data["frequency"] = frequency
	data["freqlock"] = freqlock

	var/list/radio_channels = list()

	for(var/channel in channels)
		var/channel_key = channel_to_prefix(channel)
		radio_channels += list(list(
			"name" = channel,
			"status" = channels[channel] & FREQ_LISTENING,
			"hotkey" = channel_key))

	data["channels"] = radio_channels

	data["command"] = volume
	data["useCommand"] = use_volume
	data["subspace"] = subspace_transmission
	data["subspaceSwitchable"] = subspace_switchable
	data["headset"] = FALSE

	return data

/obj/item/device/radio/listening_bug/ui_act(action, params, datum/tgui/ui, datum/ui_state/state)
	switch(action)
		if("listen")
			if(prevent_snooping)
				to_chat(usr, SPAN_WARNING("此设备无法接收传输信号！"))
				return
			listening = !listening
			return
		if("subspace")
			if(!ishuman(usr))
				return
			var/mob/living/carbon/human/user = usr
			if(!check_access(user.wear_id) && !check_access(user.get_active_hand()))
				to_chat(user, SPAN_WARNING("你需要经过身份验证的识别卡才能更改此功能！"))
				return
			if(subspace_switchable)
				subspace_transmission = !subspace_transmission
				var/initial_prevent = initial(prevent_snooping)
				if(initial_prevent)
					prevent_snooping = TRUE
				if(!subspace_transmission)
					prevent_snooping = FALSE
					channels = list()
				return
	..()

/obj/item/device/radio/listening_bug/hear_talk(mob/M as mob, msg, verb = "说", datum/language/speaking = null)
	var/processed_verb = "[SPAN_RED("\[窃听 [nametag]\]")] [verb]"
	if(broadcasting)
		if(get_dist(src, M) <= 7)
			talk_into(M, msg, null, processed_verb, speaking, listening_device = TRUE)

/obj/item/device/radio/listening_bug/afterattack(atom/target_atom, mob/user as mob, proximity)
	if(!ready_to_disguise)
		return ..()

	var/obj/item/target_item = target_atom
	if(!istype(target_item) || target_item.anchored || target_item.w_class >= SIZE_LARGE)
		to_chat(user, SPAN_WARNING("无法将窃听器伪装成这个物品。"))
		return FALSE

	var/confirm = tgui_alert(user, "确定要将窃听器伪装成“[target_item]”吗？", "确认选择", list("是","否"), 20 SECONDS)
	if(confirm != "是")
		return FALSE

	icon = target_item.icon
	name = target_item.name
	desc = target_item.desc
	icon_state = target_item.icon_state
	item_state = target_item.item_state
	flags_equip_slot = target_item.flags_equip_slot
	w_class = target_item.w_class
	ready_to_disguise = FALSE
	disguised = TRUE

/obj/item/device/radio/listening_bug/get_examine_text(mob/user)
	if(disguised)
		. = list()
		var/size
		switch(w_class)
			if(SIZE_TINY)
				size = "微型"
			if(SIZE_SMALL)
				size = "小型"
			if(SIZE_MEDIUM)
				size = "中型"
		. += "这是[blood_color ? blood_color != COLOR_OIL ? "沾血的" : "沾着油污的" : ""][icon2html(src, user)][src.name]，属于[size]物品。"
		if(desc)
			. += desc
		if(desc_lore)
			. += SPAN_NOTICE("此物品有<a href='byond://?src=\ref[src];desc_lore=1'>详细背景说明</a>。")
	else
		. = ..()
		. += SPAN_INFO("[src]当前设为 [get_bug_letter()] 频段。")
		if(nametag != initial(nametag))
			. += SPAN_INFO("[src]的名称标签为“[nametag]”。")

/obj/item/device/radio/listening_bug/verb/change_disguise()
	set name = "更改伪装"
	set category = "物品"
	set src in usr

	if(usr.is_mob_incapacitated())
		to_chat(usr, SPAN_WARNING("失去行动能力时无法执行此操作！"))
		return FALSE

	var/check = tgui_alert(usr, "要更改这个窃听器的伪装吗？", "更改伪装", list("是", "否"))
	if(check != "是")
		return FALSE
	if(disguised)
		var/remove_check = tgui_alert(usr, "要移除当前伪装吗？", "移除伪装", list("是","否"))
		if(remove_check == "是")
			icon = initial(icon)
			name = initial(name)
			desc = initial(desc)
			icon_state = initial(icon_state)
			item_state = initial(item_state)
			flags_equip_slot = initial(flags_equip_slot)
			w_class = initial(w_class)
			disguised = FALSE
			return TRUE

	to_chat(usr, SPAN_HELPFUL("现在可以选择一个中型或更小的物品，将设备伪装成它。"))
	ready_to_disguise = TRUE
	return TRUE

/obj/item/device/radio/listening_bug/proc/get_bug_letter()
	switch(frequency)
		if(BUG_A_FREQ)
			return "A"
		if(BUG_B_FREQ)
			return "B"
		if(SEC_FREQ)
			return "MP"
		if(PVST_FREQ)
			return "PVST"
		if(HC_FREQ)
			return "HC"
		if(WY_FREQ, PMC_CCT_FREQ)
			return "WY"
		if(PMC_CMD_FREQ)
			return "WYC"
		if(UPP_CCT_FREQ, UPP_KDO_FREQ)
			return "UPP"
		else
			return "X"

#define OPTION_REMOVE "Remove Tag"
#define OPTION_NEW "New Tag"

/obj/item/device/radio/listening_bug/verb/set_nametag()
	set name = "设置名称标签"
	set category = "物品"
	set src in usr

	if(usr.is_mob_incapacitated())
		to_chat(usr, SPAN_WARNING("失去行动能力时无法执行此操作！"))
		return FALSE

	var/check = tgui_alert(usr, "要更改这个窃听器的名称标签吗？", "更改名称标签", list("是", "否"))
	if(check != "是")
		return FALSE


	var/new_nametag
	var/remove
	if(nametag != initial(nametag))
		remove = tgui_alert(usr, "要移除当前名称标签吗？", "移除名称标签", list("是", "否"))
	if(remove == "是")
		new_nametag = initial(nametag)
	else
		new_nametag = tgui_input_text(usr, "请输入新的名称标签。", "新名称", initial(nametag), 6)

	if(!new_nametag || (new_nametag == nametag))
		return FALSE

	nametag = new_nametag
	log_game("[key_name(usr)] set a listening device nametag to [new_nametag].")
	return TRUE

#undef OPTION_REMOVE
#undef OPTION_NEW

/obj/item/device/radio/listening_bug/freq_a
	frequency = BUG_A_FREQ

/obj/item/device/radio/listening_bug/freq_b
	frequency = BUG_B_FREQ

/obj/item/device/radio/listening_bug/radio_linked
	prevent_snooping = TRUE
	subspace_transmission = TRUE
	subspace_switchable = TRUE

/obj/item/device/radio/listening_bug/radio_linked/mp
	frequency = SEC_FREQ
	req_one_access = list(ACCESS_MARINE_BRIG)

/obj/item/device/radio/listening_bug/radio_linked/hc
	frequency = HC_FREQ
	req_one_access = list(ACCESS_MARINE_CO)
/obj/item/device/radio/listening_bug/radio_linked/hc/pvst
	frequency = PVST_FREQ

/obj/item/device/radio/listening_bug/radio_linked/cia
	frequency = CIA_FREQ
	req_one_access = list(ACCESS_CIA)

/obj/item/device/radio/listening_bug/radio_linked/wy
	frequency = WY_FREQ
	req_one_access = list(ACCESS_WY_EXEC, ACCESS_WY_SECURITY)

/obj/item/device/radio/listening_bug/radio_linked/wy/pmc
	frequency = PMC_CCT_FREQ
	req_one_access = list(ACCESS_WY_EXEC, ACCESS_WY_SECURITY)

/obj/item/device/radio/listening_bug/radio_linked/upp
	frequency = UPP_CCT_FREQ
	req_one_access = list(ACCESS_UPP_COMMANDO, ACCESS_UPP_SECURITY)

/obj/item/device/radio/listening_bug/radio_linked/upp/commando
	frequency = UPP_KDO_FREQ
	req_one_access = list(ACCESS_UPP_COMMANDO)


// ENCRYPTION KEYS FOR LISTENING IN!
//REQURIES SUBSPACE ACTIVATION ON THE BUGS FIRST!
/obj/item/device/encryptionkey/listening_bug
	desc = "用于监听秘密发射设备的小型加密密钥！如果设备未使用子空间通讯，通常无法生效！"
	icon_state = "stripped_key"

/obj/item/device/encryptionkey/listening_bug/freq_a
	name = "窃听器加密密钥（A）"
	channels = list(RADIO_CHANNEL_BUG_A = TRUE)

/obj/item/device/encryptionkey/listening_bug/freq_b
	name = "窃听器加密密钥（B）"
	channels = list(RADIO_CHANNEL_BUG_B = TRUE)
