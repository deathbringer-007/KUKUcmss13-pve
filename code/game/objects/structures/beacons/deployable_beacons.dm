/obj/structure/deployable_beacon
	name = "可部署信标"
	desc = "标准可部署信标，通常供超出常规通信范围、但仍需发出各种信号的队伍使用。这款印着维兰德-汤谷标志，面向市场大量销售。"
	icon = 'icons/obj/items/deployable_beacon.dmi'
	icon_state = "beacon_active"

	/// The type of beacon it turns into
	var/beacon_type = /obj/item/deployable_beacon

	/// Color of the beacon's light
	var/beacon_light_color = COLOR_WHITE

/obj/structure/deployable_beacon/Initialize(mapload, mob/user)
	. = ..()

	var/image/overlay_image = new('icons/obj/items/deployable_beacon.dmi', icon_state = "beacon_active_overlay")
	overlay_image.color = beacon_light_color

	overlays += overlay_image

	visible_message(SPAN_NOTICE("[src]轻声鸣响，开始发送预设信号。"))

	set_light(2, 1, beacon_light_color)

	for(var/client/admin_client in GLOB.admins)
		if((R_ADMIN|R_MOD) & admin_client.admin_holder.rights)
			playsound_client(admin_client,'sound/effects/sos-morse-code.ogg',10)

	message_admins("[key_name(user)] has deployed [src]! [ADMIN_JMP(src)]")

/obj/structure/deployable_beacon/attackby(obj/item/attacking_item, mob/user)
	if(!HAS_TRAIT(attacking_item, TRAIT_TOOL_MULTITOOL))
		return ..()

	if(user.action_busy)
		return

	if(!do_after(user, (1 SECONDS), INTERRUPT_ALL, BUSY_ICON_BUILD, src))
		return

	visible_message(SPAN_NOTICE("[src]低鸣着关闭电源，并折叠收起以便携带。"))

	var/obj/item/deployable_beacon/undeployed_beacon = new beacon_type()

	var/datum/component/label/src_label_component = GetComponent(/datum/component/label)
	var/label_text
	if(src_label_component)
		label_text = src_label_component.label_name
		src_label_component.remove_label()

	undeployed_beacon.name = name
	undeployed_beacon.desc = desc

	if(label_text)
		undeployed_beacon.AddComponent(/datum/component/label, label_text)

	user.put_in_hands(undeployed_beacon)

	qdel(src)

/obj/structure/deployable_beacon/red
	beacon_type = /obj/item/deployable_beacon/red
	beacon_light_color = COLOR_RED

/obj/structure/deployable_beacon/green
	beacon_type = /obj/item/deployable_beacon/green
	beacon_light_color = COLOR_GREEN

/obj/structure/deployable_beacon/blue
	beacon_type = /obj/item/deployable_beacon/blue
	beacon_light_color = COLOR_BLUE

/obj/structure/deployable_beacon/purple
	beacon_type = /obj/item/deployable_beacon/purple
	beacon_light_color = COLOR_PURPLE
