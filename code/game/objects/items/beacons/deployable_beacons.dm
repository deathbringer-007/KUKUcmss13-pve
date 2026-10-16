/// Generic deployable beacon for objectives
/obj/item/deployable_beacon
	name = "可部署信标"
	desc = "一种标准的可部署信标，通常供可能超出常规通信范围、却仍需发送信号的队伍使用。这款印有维兰德-汤谷标志，成批出售。"
	icon = 'icons/obj/items/deployable_beacon.dmi'
	icon_state = "beacon_inactive"
	w_class = SIZE_SMALL

	/// The type of beacon it turns into
	var/beacon_type = /obj/structure/deployable_beacon

	/// Color of the beacon's light
	var/beacon_light_color = COLOR_WHITE

/obj/item/deployable_beacon/Initialize(mapload, ...)
	. = ..()

	var/image/overlay_image = new('icons/obj/items/deployable_beacon.dmi', icon_state = "beacon_inactive_overlay")
	overlay_image.color = beacon_light_color

	overlays += overlay_image

/obj/item/deployable_beacon/attack_self(mob/user)
	. = ..()

	var/turf/deploying_turf = get_turf(user)

	var/blocked = FALSE
	for(var/obj/potential_blocking_object in deploying_turf)
		if(potential_blocking_object.density || potential_blocking_object.can_block_movement)
			blocked = potential_blocking_object
			break

	if(!istype(deploying_turf, /turf/open))
		blocked = deploying_turf

	var/turf/open/floor = deploying_turf
	if(!floor.allow_construction)
		to_chat(user, SPAN_WARNING("无法在这里部署[src]，找一处更稳固的表面！"))
		return FALSE

	if(blocked)
		to_chat(usr, SPAN_WARNING("部署[src]需要空旷区域，[blocked]挡住了位置！"))
		return

	if(user.action_busy)
		return

	if(!do_after(user, (1 SECONDS), INTERRUPT_ALL, BUSY_ICON_BUILD, src))
		return

	playsound(deploying_turf, 'sound/machines/beacon_activated.ogg')

	var/obj/structure/deployable_beacon/deployed_beacon = new beacon_type(get_turf(src), user)

	var/datum/component/label/src_label_component = GetComponent(/datum/component/label)
	var/label_text
	if(src_label_component)
		label_text = src_label_component.label_name
		src_label_component.remove_label()

	deployed_beacon.name = name
	deployed_beacon.desc = desc

	if(label_text)
		deployed_beacon.AddComponent(/datum/component/label, label_text)

	qdel(src)

/obj/item/deployable_beacon/red
	beacon_type = /obj/structure/deployable_beacon/red
	beacon_light_color = COLOR_RED

/obj/item/deployable_beacon/green
	beacon_type = /obj/structure/deployable_beacon/green
	beacon_light_color = COLOR_GREEN

/obj/item/deployable_beacon/blue
	beacon_type = /obj/structure/deployable_beacon/blue
	beacon_light_color = COLOR_BLUE

/obj/item/deployable_beacon/purple
	beacon_type = /obj/structure/deployable_beacon/purple
	beacon_light_color = COLOR_PURPLE

