/obj/structure/pipes/vents/scrubber
	icon = 'icons/obj/pipes/vent_scrubber.dmi'
	icon_state = "map_vent"
	name = "空气洗涤器"
	vent_icon = "scrubber"

/obj/structure/pipes/vents/scrubber/no_boom
	name = "加固空气洗涤器"
	explodey = FALSE

/obj/structure/pipes/vents/scrubber/on
	icon_state = "on"


/obj/structure/pipes/vents/pump
	icon = 'icons/obj/pipes/vent_pump.dmi'
	icon_state = "map_vent"
	name = "通风口"

/obj/structure/pipes/vents/pump/no_boom
	name = "加固通风口"
	explodey = FALSE

/// Vents that are linked to ARES Security Protocols, allowing the ARES Interface to trigger security measures.
/obj/structure/pipes/vents/pump/no_boom/gas
	name = "安保通风口"
	var/datum/ares_link/link
	var/vent_tag
	COOLDOWN_DECLARE(vent_trigger_cooldown)

/obj/structure/pipes/vents/pump/no_boom/gas/Initialize()
	link_systems(override = FALSE)
	. = ..()

/obj/structure/pipes/vents/pump/no_boom/gas/Destroy()
	delink()
	return ..()

/obj/structure/pipes/vents/pump/no_boom/gas/proc/link_systems(datum/ares_link/new_link = GLOB.ares_link, override)
	if(link && !override)
		return FALSE
	delink()
	if(new_link)
		link = new_link
		new_link.linked_vents += src
		return TRUE

/obj/structure/pipes/vents/pump/no_boom/gas/proc/delink()
	if(link)
		link.linked_vents -= src
		link = null

/obj/structure/pipes/vents/pump/on
	icon_state = "on"

/obj/structure/pipes/vents/pump/siphon/on
	icon_state = "in"

/obj/structure/pipes/vents/pump/high_volume
	name = "大型通风口"

/obj/structure/pipes/vents/pump/engine
	name = "引擎核心通风口"
