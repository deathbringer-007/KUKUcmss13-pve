/obj/structure/machinery/floodlight
	name = "应急泛光灯"
	desc = "通常设置在着陆区附近的强力照明灯，可提高能见度。"
	icon = 'icons/obj/structures/machinery/floodlight.dmi'
	icon_state = "flood_0"
	density = TRUE
	anchored = TRUE
	light_power = 2
	wrenchable = TRUE
	use_power = USE_POWER_IDLE
	idle_power_usage = 0
	active_power_usage = 100

	///How far the light will go when the floodlight is on
	var/on_light_range = 6
	///Whether or not the floodlight can be toggled on or off
	var/toggleable = TRUE
	///Whether or not the floodlight is turned on, disconnected from whether it has power or is lit
	var/turned_on = FALSE
	///base state
	var/base_icon_state = "flood"

/obj/structure/machinery/floodlight/Initialize(mapload, ...)
	. = ..()

	turn_light(toggle_on = (operable() && turned_on))

/obj/structure/machinery/floodlight/turn_light(mob/user, toggle_on)
	. = ..()
	if(. == NO_LIGHT_STATE_CHANGE)
		return

	if(toggle_on)
		set_light(on_light_range)
	else
		set_light(0)

	update_icon()

/obj/structure/machinery/floodlight/attack_hand(mob/living/user)
	if(!toggleable)
		to_chat(user, SPAN_NOTICE("[src]似乎没有灯光开关。"))
		return

	if(user.is_mob_incapacitated())
		return

	if(!is_valid_user(user))
		to_chat(user, SPAN_NOTICE("你的肢体不够灵巧，无法进行此操作。"))
		return

	turned_on = !turned_on

	if(inoperable())
		to_chat(user, SPAN_NOTICE("你将泛光灯的开关拨到[turned_on ? "开启" : "关闭"]位置。它似乎无法正常工作。"))
		return

	to_chat(user, SPAN_NOTICE("你[turned_on ? "打开" : "关闭"]了灯光。"))
	turn_light(user, toggle_on = turned_on)
	update_use_power(turned_on ? USE_POWER_ACTIVE : USE_POWER_IDLE)

/obj/structure/machinery/floodlight/update_icon()
	. = ..()
	icon_state = "[base_icon_state]_[light_on]"

/obj/structure/machinery/floodlight/power_change(area/master_area = null)
	. = ..()

	turn_light(toggle_on = (!(stat & NOPOWER) && turned_on))

//Magical floodlight that cannot be destroyed or interacted with.
/obj/structure/machinery/floodlight/landing
	name = "着陆照明灯"
	desc = "通常设置在着陆区附近的强力照明灯，可提高能见度。这盏似乎已被螺栓固定，无法移动。"
	icon_state = "flood_1"
	use_power = USE_POWER_NONE
	needs_power = FALSE
	unslashable = TRUE
	unacidable = TRUE
	wrenchable = FALSE
	toggleable = FALSE
	turned_on = TRUE

/obj/structure/machinery/floodlight/landing/floor
	icon_state = "floor_flood_1"
	base_icon_state = "floor_flood"
	density = FALSE

/obj/structure/machinery/floodlight/landing/floor/update_icon()
	. = ..()
	icon_state = "floor_flood0[light_on]"
