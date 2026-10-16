//Putting these here since it's power-related
/obj/structure/machinery/colony_floodlight_switch
	name = "殖民地泛光灯开关"
	icon = 'icons/obj/structures/machinery/power.dmi'
	icon_state = "panelnopower"
	desc = "控制考古设施周围泛光灯的开关，仅在有电时工作。"
	density = FALSE
	anchored = TRUE
	use_power = USE_POWER_IDLE
	unslashable = TRUE
	unacidable = TRUE
	power_machine = TRUE
	var/ispowered = FALSE
	var/turned_on = FALSE //has to be toggled in engineering
	///All floodlights under our control
	var/list/floodlist = list()

/obj/structure/machinery/colony_floodlight_switch/Initialize(mapload, ...)
	. = ..()
	return INITIALIZE_HINT_LATELOAD

/obj/structure/machinery/colony_floodlight_switch/LateInitialize()
	. = ..()
	for(var/obj/structure/machinery/colony_floodlight/floodlight in GLOB.machines)
		floodlist += floodlight
		floodlight.fswitch = src
	start_processing()

/obj/structure/machinery/colony_floodlight_switch/Destroy()
	for(var/obj/structure/machinery/colony_floodlight/floodlight as anything in floodlist)
		floodlight.fswitch = null
	floodlist = null
	return ..()

/obj/structure/machinery/colony_floodlight_switch/update_icon()
	if(!ispowered)
		icon_state = "panelnopower"
	else if(turned_on)
		icon_state = "panelon"
	else
		icon_state = "paneloff"

/obj/structure/machinery/colony_floodlight_switch/process()
	var/lightpower = 0
	for(var/obj/structure/machinery/colony_floodlight/floodlight as anything in floodlist)
		if(!floodlight.is_lit)
			continue
		lightpower += floodlight.power_tick
	use_power(lightpower)

/obj/structure/machinery/colony_floodlight_switch/power_change()
	..()
	if((stat & NOPOWER))
		if(ispowered && turned_on)
			toggle_lights()
		ispowered = FALSE
		turned_on = FALSE
	else
		ispowered = TRUE
	update_icon()

/obj/structure/machinery/colony_floodlight_switch/proc/toggle_lights()
	for(var/obj/structure/machinery/colony_floodlight/floodlight as anything in floodlist)
		addtimer(CALLBACK(floodlight, TYPE_PROC_REF(/obj/structure/machinery/colony_floodlight, toggle_light)), rand(0, 5 SECONDS))

/obj/structure/machinery/colony_floodlight_switch/attack_hand(mob/user as mob)
	if(!ishuman(user))
		to_chat(user, "想得美。")
		return FALSE
	if(!ispowered)
		to_chat(user, "什么也没发生。")
		return FALSE
	playsound(src,'sound/items/Deconstruct.ogg', 30, 1)
	use_power(5)
	toggle_lights()
	turned_on = !turned_on
	update_icon()
	return TRUE


#define FLOODLIGHT_REPAIR_UNSCREW 0
#define FLOODLIGHT_REPAIR_CROWBAR 1
#define FLOODLIGHT_REPAIR_WELD 2
#define FLOODLIGHT_REPAIR_CABLE 3
#define FLOODLIGHT_REPAIR_SCREW 4

/obj/structure/machinery/colony_floodlight
	name = "殖民地泛光灯"
	icon = 'icons/obj/structures/machinery/big_floodlight.dmi'
	icon_state = "flood_s_off"
	density = TRUE
	anchored = TRUE
	layer = ABOVE_XENO_LAYER
	unslashable = TRUE
	unacidable = TRUE
	use_power = USE_POWER_NONE //It's the switch that uses the actual power, not the lights
	needs_power = FALSE
	///Whether it has been smashed by xenos
	var/damaged = FALSE
	///Whether the floodlight is switched to on or off. Does not necessarily mean it emits light.
	var/is_lit = FALSE
	///The power each floodlight takes up per process
	var/power_tick = 50
	///Reverse lookup for power grabbing in area
	var/obj/structure/machinery/colony_floodlight_switch/fswitch = null
	var/lum_value = 7
	var/repair_state = FLOODLIGHT_REPAIR_UNSCREW
	health = 150

/obj/structure/machinery/colony_floodlight/Destroy()
	if(fswitch)
		fswitch.floodlist -= src
		fswitch = null
	. = ..()

/obj/structure/machinery/colony_floodlight/update_icon()
	if(damaged)
		icon_state = "flood_s_dmg"
	else if(is_lit)
		icon_state = "flood_s_on"
	else
		icon_state = "flood_s_off"

/obj/structure/machinery/colony_floodlight/attackby(obj/item/I, mob/user)
	if(damaged)
		if(HAS_TRAIT(I, TRAIT_TOOL_SCREWDRIVER))
			if(!skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_TRAINED))
				to_chat(user, SPAN_WARNING("你完全不知道该如何修理[src]。"))
				return FALSE

			if(repair_state == FLOODLIGHT_REPAIR_UNSCREW)
				playsound(loc, 'sound/items/Screwdriver.ogg', 25, 1)
				user.visible_message(SPAN_NOTICE("[user]开始拧开[src]的维护舱盖。"), \
				SPAN_NOTICE("你开始拧开[src]的维护舱盖。"))
				if(do_after(user, 2 SECONDS, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
					if(QDELETED(src) || repair_state != FLOODLIGHT_REPAIR_UNSCREW)
						return
					playsound(loc, 'sound/items/Screwdriver.ogg', 25, 1)
					repair_state = FLOODLIGHT_REPAIR_CROWBAR
					user.visible_message(SPAN_NOTICE("[user]拧开了[src]的维护舱盖。"), \
					SPAN_NOTICE("你拧开了[src]的维护舱盖。"))

			else if(repair_state == FLOODLIGHT_REPAIR_SCREW)
				playsound(loc, 'sound/items/Screwdriver.ogg', 25, 1)
				user.visible_message(SPAN_NOTICE("[user]开始拧紧[src]的维护舱盖。"), \
				SPAN_NOTICE("你开始拧紧[src]的维护舱盖。"))
				if(do_after(user, 2 SECONDS, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
					if(QDELETED(src) || repair_state != FLOODLIGHT_REPAIR_SCREW)
						return
					playsound(loc, 'sound/items/Screwdriver.ogg', 25, 1)
					damaged = FALSE
					repair_state = FLOODLIGHT_REPAIR_UNSCREW
					health = initial(health)
					user.visible_message(SPAN_NOTICE("[user]拧紧了[src]的维护舱盖。"), \
					SPAN_NOTICE("你拧紧了[src]的维护舱盖。"))
					if(is_lit)
						set_light(lum_value)
					update_icon()
			return TRUE

		else if(HAS_TRAIT(I, TRAIT_TOOL_CROWBAR))
			if(!skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_TRAINED))
				to_chat(user, SPAN_WARNING("你完全不知道该如何修理[src]。"))
				return FALSE

			if(repair_state == FLOODLIGHT_REPAIR_CROWBAR)
				playsound(loc, 'sound/items/Crowbar.ogg', 25, 1)
				user.visible_message(SPAN_NOTICE("[user]开始撬出[src]损坏的照明组件。"),\
				SPAN_NOTICE("你开始撬出[src]损坏的照明组件。"))
				if(do_after(user, 2 SECONDS, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
					if(QDELETED(src) || repair_state != FLOODLIGHT_REPAIR_CROWBAR)
						return
					playsound(loc, 'sound/items/Crowbar.ogg', 25, 1)
					repair_state = FLOODLIGHT_REPAIR_WELD
					user.visible_message(SPAN_NOTICE("[user]撬出了[src]损坏的照明组件。"),\
					SPAN_NOTICE("你撬出了[src]损坏的照明组件。"))
			return TRUE

		else if(iswelder(I))
			if(!HAS_TRAIT(I, TRAIT_TOOL_BLOWTORCH))
				to_chat(user, SPAN_WARNING("你需要功率更大的喷灯！"))
				return
			var/obj/item/tool/weldingtool/welder = I

			if(!skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_TRAINED))
				to_chat(user, SPAN_WARNING("你完全不知道该如何修理[src]。"))
				return FALSE

			if(repair_state == FLOODLIGHT_REPAIR_WELD)
				if(welder.remove_fuel(1, user))
					playsound(loc, 'sound/items/weldingtool_weld.ogg', 25)
					user.visible_message(SPAN_NOTICE("[user]开始焊接修复[src]的损伤。"),
					SPAN_NOTICE("你开始焊接修复[src]的损伤。"))
					if(do_after(user, 4 SECONDS, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
						if(QDELETED(src) || !welder.isOn() || repair_state != FLOODLIGHT_REPAIR_WELD)
							return
						playsound(loc, 'sound/items/Welder2.ogg', 25, 1)
						repair_state = FLOODLIGHT_REPAIR_CABLE
						user.visible_message(SPAN_NOTICE("[user]焊接修复了[src]的损伤。"),
						SPAN_NOTICE("你焊接修复了[src]的损伤。"))
						return TRUE
				else
					to_chat(user, SPAN_WARNING("你需要更多焊接燃料才能完成这项工作。"))
			return TRUE

		else if(iscoil(I))
			var/obj/item/stack/cable_coil/coil = I
			if(!skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_TRAINED))
				to_chat(user, SPAN_WARNING("你完全不知道该如何修理[src]。"))
				return FALSE

			if(repair_state == FLOODLIGHT_REPAIR_CABLE)
				if(coil.get_amount() < 2)
					to_chat(user, SPAN_WARNING("更换损坏的电缆需要两段电线。"))
					return
				playsound(loc, 'sound/items/Deconstruct.ogg', 25, 1)
				user.visible_message(SPAN_NOTICE("[user]开始更换[src]损坏的电缆。"),\
				SPAN_NOTICE("你开始更换[src]损坏的电缆。"))
				if(do_after(user, 2 SECONDS, INTERRUPT_ALL, BUSY_ICON_GENERIC))
					if(QDELETED(src) || repair_state != FLOODLIGHT_REPAIR_CABLE)
						return
					if(coil.use(2))
						playsound(loc, 'sound/items/Deconstruct.ogg', 25, 1)
						repair_state = FLOODLIGHT_REPAIR_SCREW
						user.visible_message(SPAN_NOTICE("[user]更换了[src]损坏的电缆。"),\
						SPAN_NOTICE("你更换了[src]损坏的电缆。"))
			return TRUE

		else if(istype(I, /obj/item/device/lightreplacer))
			if(!skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_TRAINED))
				to_chat(user, SPAN_WARNING("你完全不知道该如何修理[src]。"))
				return FALSE

			if(repair_state == FLOODLIGHT_REPAIR_UNSCREW)
				to_chat(user, SPAN_WARNING("你需要拧开[src]的维护舱盖。"))
				return FALSE
			if(repair_state == FLOODLIGHT_REPAIR_SCREW)
				to_chat(user, SPAN_WARNING("你需要拧紧[src]的维护舱盖。"))
				return FALSE

			var/obj/item/device/lightreplacer/replacer = I
			if(!replacer.CanUse(user))
				to_chat(user, replacer.failmsg)
				return FALSE
			playsound(loc, 'sound/items/Crowbar.ogg', 25, 1)
			user.visible_message(SPAN_NOTICE("[user]开始更换[src]损坏的照明组件。"),\
			SPAN_NOTICE("你开始更换[src]损坏的照明组件。"))
			if(do_after(user, 2 SECONDS, INTERRUPT_ALL, BUSY_ICON_GENERIC))
				if(QDELETED(src) || repair_state == FLOODLIGHT_REPAIR_SCREW)
					return
				replacer.Use(user)
				repair_state = FLOODLIGHT_REPAIR_SCREW
				user.visible_message(SPAN_NOTICE("[user]更换了[src]损坏的照明组件。"),\
				SPAN_NOTICE("你更换了[src]损坏的照明组件。"))
			return TRUE

	return ..()

/obj/structure/machinery/colony_floodlight/attack_hand(mob/user)
	if(ishuman(user))
		if(damaged)
			to_chat(user, SPAN_WARNING("[src]损坏了。"))
		else if(!is_lit)
			to_chat(user, SPAN_WARNING("什么也没发生，看起来它的电源在别处。"))
		return FALSE
	return ..()

/obj/structure/machinery/colony_floodlight/get_examine_text(mob/user)
	. = ..()
	if(ishuman(user))
		if(damaged)
			. += SPAN_WARNING("它损坏了。")
			if(skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_TRAINED))
				switch(repair_state)
					if(FLOODLIGHT_REPAIR_UNSCREW) . += SPAN_INFO("你必须先拧开维护舱盖。")
					if(FLOODLIGHT_REPAIR_CROWBAR) . += SPAN_INFO("你必须用撬棍撬出照明组件，或使用灯具更换器。")
					if(FLOODLIGHT_REPAIR_WELD) . += SPAN_INFO("你必须焊接修复损伤。")
					if(FLOODLIGHT_REPAIR_CABLE) . += SPAN_INFO("你必须更换损坏的电缆。")
					if(FLOODLIGHT_REPAIR_SCREW) . += SPAN_INFO("你必须拧紧维护舱盖。")
		else if(!is_lit)
			. += SPAN_INFO("它似乎没有通电。")

/obj/structure/machinery/colony_floodlight/ex_act(severity)
	switch(severity)
		if(0 to EXPLOSION_THRESHOLD_LOW)
			if(prob(25))
				set_damaged()
				return
		if(EXPLOSION_THRESHOLD_LOW to EXPLOSION_THRESHOLD_MEDIUM)
			if(prob(50))
				set_damaged()
				return
		if(EXPLOSION_THRESHOLD_MEDIUM to INFINITY)
			set_damaged()
			return

/obj/structure/machinery/colony_floodlight/proc/set_damaged()
	playsound(src, "glassbreak", 70, 1)
	damaged = TRUE
	if(is_lit)
		set_light(0)
	update_icon()

/obj/structure/machinery/colony_floodlight/proc/toggle_light()
	is_lit = !is_lit
	if(!damaged)
		set_light(is_lit ? lum_value : 0)
	update_icon()
	return is_lit

#undef FLOODLIGHT_REPAIR_UNSCREW
#undef FLOODLIGHT_REPAIR_CROWBAR
#undef FLOODLIGHT_REPAIR_WELD
#undef FLOODLIGHT_REPAIR_CABLE
#undef FLOODLIGHT_REPAIR_SCREW
