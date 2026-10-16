
///handheld distress beacons used by goon chem retrieval team to call for PMC back up
/obj/item/handheld_distress_beacon
	name = "\improper PMC手持求救信标"
	desc = "标准手持求救信标，通常供可能离开常规通信范围、但仍需呼叫援助的小队使用。这个印着维兰德-汤谷的标志，大批销往尼洛德星区各地的殖民地。"
	icon = 'icons/obj/items/handheld_beacon.dmi'
	icon_state = "beacon_inactive"
	w_class = SIZE_SMALL

	///The beacons faction that will be sent in message_admins
	var/beacon_type = "PMC beacon"
	///Tells the user who the beacon will be sent to IC
	var/recipient = "USCSS罗伊斯号"
	///The name of the ERT that will be passed to get_specific_call
	var/list/ert_paths = list(/datum/emergency_call/pmc/chem_retrieval) // "Weyland-Yutani PMC (Chemical Investigation Squad)"
	///The clickable version that will be sent in message_admins
	var/list/ert_short_names = list("SEND PMCs")
	///Whether beacon can be used, or has already been used
	var/active = FALSE

/obj/item/handheld_distress_beacon/get_examine_text(mob/user)
	. = ..()

	if(active)
		. += "信标已启动！"

/obj/item/handheld_distress_beacon/update_icon()
	. = ..()

	if(active)
		icon_state = "beacon_active"
		return
	icon_state = initial(icon_state)

/obj/item/handheld_distress_beacon/attack_self(mob/user)
	. = ..()

	if(active)
		to_chat(user, "[src]已经启动了！")
		return FALSE
	var/reason = tgui_input_text(user, "你为什么要启动这个信标？", "求救原因")
	if(!reason)
		return FALSE

	active = TRUE
	update_icon()

	if(!ert_paths || !ert_short_names || (length(ert_paths) != length(ert_short_names))) //Make sure they are greater than 0, and both are same length
		to_chat(user, SPAN_BOLDWARNING("[src]已损坏！"))
		CRASH("[src] was improperly set, and has been disabled.") //For the runtime logs

	var/beacon_call_buttons
	for(var/current_ert_num in 1 to length(ert_paths))
		beacon_call_buttons += "(<A href='byond://?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];distress_handheld=\ref[user];ert_name=[ert_paths[current_ert_num]]'>[ert_short_names[current_ert_num]]</A>) "

	for(var/client/admin_client in GLOB.admins)
		if((R_ADMIN|R_MOD) & admin_client.admin_holder.rights)
			playsound_client(admin_client,'sound/effects/sos-morse-code.ogg',10)
	message_admins("[key_name(user)] has used a [beacon_type] for the reason '[SPAN_ORANGE(reason)]'! [CC_MARK(user)] [beacon_call_buttons](<A href='byond://?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];deny_distress_handheld=\ref[user]'>DENY</A>) [ADMIN_JMP_USER(user)] [CC_REPLY(user)]")
	to_chat(user, SPAN_NOTICE("求救信标请求已发送至[recipient]。"))

/// CMB distress beacon held by CMB Marshal for signalling distress to Anchorpoint Station
/obj/item/handheld_distress_beacon/cmb
	name = "\improper CMB手持求救信标"
	desc = "紧急求救信标，印有殖民地执法局的星徽，侧面以模板刻着“锚点空间站”。配发给殖民地执法官，带有加长的中继天线。"

	beacon_type = "CMB beacon"
	recipient = "锚点空间站"
	// "CMB - Patrol Team - Marshals in Distress (Friendly)", "CMB - Anchorpoint Station Colonial Marine QRF (Friendly)"
	ert_paths = list(/datum/emergency_call/cmb/alt, /datum/emergency_call/cmb/anchorpoint)
	ert_short_names = list("SEND CMB", "SEND QRF")

// Corporate Lawyer beacon available for 50 points at the CLs briefcase
/obj/item/handheld_distress_beacon/lawyer
	name = "\improper 公司事务部手持信标"
	desc = "加密信标，印有维兰德-汤谷的口号“自2099年起，建设更美好的世界”。侧面以模板刻着“仅用于处理违约者”。带有公司事务部的标志，配发给多数驻美洲联盟或三世界帝国宙域的公司高管。"

	beacon_type = "Lawyer beacon"
	recipient = "公司事务部"
	ert_paths = list(/datum/emergency_call/inspection_wy/lawyer) // "Lawyers - Corporate"
	ert_short_names = list("SEND LAWYERS")

// Corporate Security Bodyguard beacon available for 50 points at the CLs briefcase
/obj/item/handheld_distress_beacon/bodyguard
	name = "\improper 公司安保部手持信标"
	desc = "标准公司安保信标，印有维兰德-汤谷的口号“自2099年起，建设更美好的世界”。带有公司安保部的标志，配发给驻银河系各地高危设施的公司高管。"

	beacon_type = "Bodyguard beacon"
	recipient = "公司安保部"
	ert_paths = list(/datum/emergency_call/goon/bodyguard) // "Weyland-Yutani Goon (Executive Bodyguard Detail)"
	ert_short_names = list("SEND BODYGUARD")

// Provost office distress beacon held by Inspectors+
/obj/item/handheld_distress_beacon/provost
	name = "\improper 军法监察署手持信标"
	desc = "印有军法监察署标志的标准信标，供人员在紧急情况下使用。带有加长的中继天线，可呼叫一队军法监察执法人员。"

	beacon_type = "Provost Enforcers beacon"
	recipient = "USS督察长号"
	ert_paths = list(/datum/emergency_call/provost_enforcer) // "USCM Provost Enforcers"
	ert_short_names = list("SEND ENFORCERS")
