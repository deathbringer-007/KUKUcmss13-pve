/obj/structure/machinery/weather_siren
	name = "天气警报器"
	desc = "用于向殖民地播报天气预警的警报器。"
	icon = 'icons/obj/structures/machinery/loudspeaker.dmi'
	icon_state = "loudspeaker"
	density = FALSE
	anchored = TRUE
	unacidable = 1
	unslashable = 1
	use_power = USE_POWER_NONE
	health = 0

/obj/structure/machinery/weather_siren/Initialize()
	GLOB.weather_notify_objects += src
	return ..()

/obj/structure/machinery/weather_siren/Destroy()
	GLOB.weather_notify_objects -= src
	. = ..()

/obj/structure/machinery/weather_siren/power_change()
	return

/obj/structure/machinery/weather_siren/proc/weather_warning()
	playsound(loc, 'sound/effects/weather_warning.ogg', 50, 0)
	visible_message(SPAN_DANGER("[src]鸣响：注意！检测到可能具有危险性的天气异常。请立即寻找掩体避难。"))
