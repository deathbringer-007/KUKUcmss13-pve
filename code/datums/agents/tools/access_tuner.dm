/obj/item/device/multitool/antag
	hack_speed = 1 SECONDS

#define SHOW_HACK_MESSAGE user.visible_message(SPAN_DANGER("[user] 入侵了 [target]。"), SPAN_NOTICE("你入侵了 [target]。"))

/obj/item/device/multitool/antag/afterattack(atom/target, mob/user, flag)
	if(!skillcheckexplicit(user, SKILL_ANTAG, SKILL_ANTAG_AGENT))
		return . = ..()

	if(istype(target, /obj/structure/machinery/door/airlock))
		var/obj/structure/machinery/door/airlock/D = target

		if(!D.density || D.unacidable)
			return . = ..()

		user.visible_message(SPAN_DANGER("[user] 开始入侵并打开 [target]！"), SPAN_NOTICE("你开始入侵并打开 [target]。"))

		if(!do_after(user, hack_speed, INTERRUPT_ALL, BUSY_ICON_HOSTILE, target, INTERRUPT_ALL))
			to_chat(user, SPAN_WARNING("你决定不入侵 [target]。"))
			return

		user.visible_message(SPAN_DANGER("[user] 通过入侵打开了 [target]。"), SPAN_NOTICE("你通过入侵打开了 [target]。"))

		D.unlock()
		D.open()

	else if(istype(target, /obj/structure/machinery/door_control))
		var/obj/structure/machinery/door_control/D = target

		SHOW_HACK_MESSAGE
		D.use_button(user, TRUE)

	else if(istype(target, /obj/structure/machinery/power/apc))
		var/obj/structure/machinery/power/apc/A = target

		if(!A.locked)
			return

		SHOW_HACK_MESSAGE
		A.locked = FALSE
		A.update_icon()
	else
		. = ..()

#undef SHOW_HACK_MESSAGE
