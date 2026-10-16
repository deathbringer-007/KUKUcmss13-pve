// Updated version of old powerswitch by Atlantis
// Has better texture, and is now considered electronic device
// AI has ability to toggle it in 5 seconds
// Humans need 30 seconds (AI is faster when it comes to complex electronics)
// Used for advanced grid control (read: Substations)

/obj/structure/machinery/power/breakerbox
	name = "断路器箱"
	icon = 'icons/obj/structures/machinery/power.dmi'
	icon_state = "bbox_off"
	directwired = 0
	var/icon_state_on = "bbox_on"
	var/icon_state_off = "bbox_off"
	flags_atom = FPRINT
	density = TRUE
	anchored = TRUE
	var/on = 0
	var/busy = FALSE
	var/directions = list(1,2,4,8,5,6,9,10)

/obj/structure/machinery/power/breakerbox/activated
	icon_state = "bbox_on"

	// Enabled on server startup. Used in substations to keep them in bypass mode.
/obj/structure/machinery/power/breakerbox/activated/Initialize()
	. = ..()
	set_state(1)

/obj/structure/machinery/power/breakerbox/get_examine_text(mob/user)
	. = list("配有重型开关电路的大型机器，用于高级电网控制。")
	if(on)
		. += SPAN_XENOWARNING("它似乎已接通。")
	else
		. += SPAN_DANGER("它似乎已断开。")

/obj/structure/machinery/power/breakerbox/attack_remote(mob/user)
	if(busy)
		to_chat(user, SPAN_DANGER("系统正忙，请等待当前操作完成后再修改电力设置。"))
		return

	busy = TRUE
	to_chat(user, SPAN_XENOWARNING("正在更新电力设置……"))
	if(do_after(user, 50, INTERRUPT_NO_NEEDHAND, BUSY_ICON_GENERIC)) //5s for AI as AIs can manipulate electronics much faster.
		set_state(!on)
		to_chat(user, SPAN_XENOWARNING("更新完成。新设置：[on ? "接通": "断开"]"))
	busy = FALSE


/obj/structure/machinery/power/breakerbox/attack_hand(mob/user)

	if(busy)
		to_chat(user, SPAN_DANGER("系统正忙，请等待当前操作完成后再修改电力设置。"))
		return

	busy = TRUE
	for(var/mob/O in viewers(user))
		O.show_message(text(SPAN_DANGER("[user]开始重新设定[src]！")), SHOW_MESSAGE_VISIBLE)

	if(do_after(user, 300, INTERRUPT_NO_NEEDHAND|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD)) // 30s for non-AIs as humans have to manually reprogram it and rapid switching may cause some lag / powernet updates flood. If AIs spam it they can be easily traced.
		set_state(!on)
		user.visible_message(\
		SPAN_NOTICE("[user.name][on ? "接通" : "断开"]了断路器箱！"),\
		SPAN_NOTICE("你[on ? "接通" : "断开"]了断路器箱！"))
	busy = FALSE

/obj/structure/machinery/power/breakerbox/proc/set_state(state)
	on = state
	if(on)
		icon_state = icon_state_on
		var/list/connection_dirs = list()
		for(var/direction in directions)
			for(var/obj/structure/cable/C in get_step(src,direction))
				if(C.d1 == turn(direction, 180) || C.d2 == turn(direction, 180))
					connection_dirs += direction
					break

		for(var/direction in connection_dirs)
			var/obj/structure/cable/C = new/obj/structure/cable(src.loc)
			C.d1 = 0
			C.d2 = direction
			C.icon_state = "[C.d1]-[C.d2]"
			C.breaker_box = src

	else
		icon_state = icon_state_off
		for(var/obj/structure/cable/C in src.loc)
			qdel(C)
