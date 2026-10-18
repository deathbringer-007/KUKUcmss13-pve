/obj/item/device/tracker
	name = "关注目标追踪器"
	desc = "用于追踪关注目标的追踪器，并不常见。"
	icon_state = "tracker"
	item_state = "tracker"
	var/active = FALSE
	var/ping_speed = 20
	var/ping_duration = 20
	var/obj/item/tracked_object

/obj/item/device/tracker/update_icon()
	overlays.Cut()

	if(active && tracked_object)
		overlays += icon(icon, "+tracker_arrow", Get_Compass_Dir(src, tracked_object))

/obj/item/device/tracker/attack_self(mob/user)
	if(!skillcheckexplicit(user, SKILL_ANTAG, SKILL_ANTAG_AGENT))
		return ..()

	if(isnull(tracked_object))
		select_object(user)
		return

	to_chat(user, SPAN_NOTICE("你开始追踪 [tracked_object.name]。"))
	if(!do_after(user, ping_speed, INTERRUPT_ALL, BUSY_ICON_HOSTILE))
		return

	active = TRUE
	update_icon()

	addtimer(CALLBACK(src, PROC_REF(deactive)), ping_duration)

/obj/item/device/tracker/proc/deactive()
	active = FALSE
	update_icon()

/obj/item/device/tracker/clicked(mob/user, list/mods)
	if(!ishuman(user) || !skillcheckexplicit(user, SKILL_ANTAG, SKILL_ANTAG_AGENT))
		return ..()

	if(mods[ALT_CLICK])
		if(!CAN_PICKUP(user, src))
			return ..()
		select_object(user)
		return TRUE

	return ..()

/obj/item/device/tracker/proc/select_object(mob/user)
	if(!LAZYLEN(GLOB.objects_of_interest))
		to_chat(user, SPAN_WARNING("没有值得追踪的目标。"))
		return

	var/list/object_choices = list()
	for(var/obj/O in GLOB.objects_of_interest)
		var/z_level_to_compare_from = O.z
		if(istype(O.loc, /obj/structure/surface))
			z_level_to_compare_from = O.loc.z

		if(z_level_to_compare_from == user.z)
			object_choices += O

	if(!length(object_choices))
		to_chat(user, SPAN_WARNING("没有值得追踪的目标。"))
		return

	tracked_object = tgui_input_list(usr, "你想追踪哪个关注目标？", "目标类型", object_choices)

	to_chat(user, SPAN_WARNING("已选择新的追踪目标：[tracked_object.name]。"))

/obj/item/device/tracker/Destroy()
	if(tracked_object)
		tracked_object = null
	. = ..()
