/// Generic beacon for objectives
/obj/item/handheld_beacon
	name = "手持信标"
	desc = "标准手持信标。通常供可能超出常规通讯范围、却仍需发送信号的小队使用。这款印着维兰德-汤谷标志，是大批量销售的产品。"
	icon = 'icons/obj/items/handheld_beacon.dmi'
	icon_state = "beacon_inactive"
	w_class = SIZE_SMALL

	/// Whether the beacon is active or not
	var/active = FALSE

/obj/item/handheld_beacon/get_examine_text(mob/user)
	. = ..()

	if(active)
		. += "信标已激活！"

/obj/item/handheld_beacon/update_icon()
	. = ..()

	if(active)
		icon_state = "beacon_active"
		return
	icon_state = initial(icon_state)

/obj/item/handheld_beacon/attack_self(mob/user)
	. = ..()

	if(.)
		return

	active = !active
	update_icon()

	to_chat(user, SPAN_NOTICE("信标轻轻响了一声，随后[active ? "开启" : "关闭"]。"))

	if(!active)
		return

	for(var/client/admin_client in GLOB.admins)
		if((R_ADMIN|R_MOD) & admin_client.admin_holder.rights)
			playsound_client(admin_client,'sound/effects/sos-morse-code.ogg',10)

	message_admins("[key_name(user)] has activated [src]! [ADMIN_JMP_USER(user)]")
