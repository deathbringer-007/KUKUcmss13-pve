/obj/structure/machinery/storm_siren
	name = "风暴警报器"
	desc = "用于向殖民地发布风暴预警的警报器。"
	icon = 'icons/obj/structures/machinery/loudspeaker.dmi'
	icon_state = "loudspeaker"
	density = FALSE
	anchored = TRUE
	unacidable = 1
	unslashable = 1
	use_power = USE_POWER_NONE
	health = 0

/obj/structure/machinery/storm_siren/Initialize()
	GLOB.weather_notify_objects += src
	return ..()

/obj/structure/machinery/storm_siren/Destroy()
	GLOB.weather_notify_objects -= src
	. = ..()

/obj/structure/machinery/storm_siren/power_change()
	return

/obj/structure/machinery/storm_siren/proc/weather_warning()
	playsound(loc, 'sound/effects/weather_warning_varadero.ogg', 60, 0)
	visible_message(SPAN_DANGER("风暴警报器鸣响：注意！注意！检测到热带风暴正在逼近。请立即寻找掩体避难。"))
