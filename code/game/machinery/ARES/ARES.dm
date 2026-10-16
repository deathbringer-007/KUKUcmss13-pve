/obj/structure/machinery/ares
	name = "ARES设备"
	density = TRUE
	anchored = TRUE
	use_power = USE_POWER_IDLE
	idle_power_usage = 600
	icon = 'icons/obj/structures/machinery/ares.dmi'
	unslashable = TRUE
	unacidable = TRUE

	var/datum/ares_link/link

/obj/structure/machinery/ares/ex_act(severity)
	return

/obj/structure/machinery/ares/Initialize(mapload, ...)
	link_systems(override = FALSE)
	. = ..()

/obj/structure/machinery/ares/Destroy()
	delink()
	return ..()

/obj/structure/machinery/ares/update_icon()
	..()
	icon_state = initial(icon_state)
	// Broken
	if(stat & BROKEN)
		icon_state += "_broken"

	// Powered
	else if(stat & NOPOWER)
		icon_state = initial(icon_state)
		icon_state += "_off"

/// Handles linking and de-linking the ARES systems.
/obj/structure/machinery/ares/proc/link_systems(datum/ares_link/new_link = GLOB.ares_link, override)
	if(!new_link)
		log_debug("Error: link_systems called without a link datum")
	if(link && !override)
		return FALSE
	if(new_link)
		link = new_link
		new_link.linked_systems += src
		return TRUE

/obj/structure/machinery/ares/proc/delink()
	link.linked_systems -= src
	link = null

/obj/structure/machinery/ares/processor
	name = "ARES处理器"
	desc = "ARES的外置处理器，用于处理海量信息。"
	icon_state = "processor"

/obj/structure/machinery/ares/processor/apollo
	name = "ARES处理器（APOLLO）"
	desc = "ARES的APOLLO处理器外部组件，主要负责协调工作乔与维护无人机。绝对不是从西格森偷来的。"
	icon_state = "apollo_processor"

/obj/structure/machinery/ares/processor/apollo/link_systems(datum/ares_link/new_link = GLOB.ares_link, override)
	..()
	new_link.processor_apollo = src

/obj/structure/machinery/ares/processor/apollo/delink()
	if(link && link.processor_apollo == src)
		link.processor_apollo = null
	..()

/obj/structure/machinery/ares/processor/interface
	name = "ARES处理器（交互接口）"
	desc = "ARES的外置处理器，负责与舰员交互的核心任务，包括无线电通信和广播。"
	icon_state = "int_processor"

/obj/structure/machinery/ares/processor/interface/link_systems(datum/ares_link/new_link = GLOB.ares_link, override)
	..()
	new_link.processor_interface = src

/obj/structure/machinery/ares/processor/interface/delink()
	if(link && link.processor_interface == src)
		link.processor_interface = null
	..()

/obj/structure/machinery/ares/processor/bioscan
	name = "ARES处理器（生命扫描）"
	desc = "ARES生命扫描系统的外部组件。没有它，阿尔迈耶号就无法进行生命扫描！"
	icon_state = "bio_processor"

/obj/structure/machinery/ares/processor/bioscan/link_systems(datum/ares_link/new_link = GLOB.ares_link, override)
	..()
	new_link.processor_bioscan = src

/obj/structure/machinery/ares/processor/bioscan/delink()
	if(link && link.processor_bioscan == src)
		link.processor_bioscan = null
	..()

/// Central Core
/obj/structure/machinery/ares/cpu
	name = "ARES中央处理器"
	desc = "ARES的中央处理器，外壳可承受核爆冲击，内部还装有ARES的黑匣子记录仪。"
	icon_state = "CPU"

/obj/structure/machinery/ares/cpu/link_systems(datum/ares_link/new_link = GLOB.ares_link, override)
	..()
	new_link.central_processor = src

/obj/structure/machinery/ares/cpu/delink()
	if(link && link.central_processor == src)
		link.central_processor = null
	..()

/// Memory Substrate,
/obj/structure/machinery/ares/substrate
	name = "ARES存储基板"
	desc = "ARES的存储基板，存有复杂的协议和信息。即使ARES主机停机，基板仍可独立维持部分功能。"
	icon_state = "substrate"
