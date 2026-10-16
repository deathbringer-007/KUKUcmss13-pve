/obj/structure/machinery/constructable_frame/porta_comms
	name = "便携式通讯装置"
	desc = "小巧便携的 TC-4T 通讯设备组装套件，用于建立行星表面与外太空之间的子空间通讯链路。尚需接线。"
	icon = 'icons/obj/structures/machinery/comm_tower2.dmi'
	icon_state = "construct_0_0"
	required_skill = SKILL_ENGINEER_TRAINED
	required_dismantle_skill = 5
	density = TRUE
	anchored = FALSE
	unslashable = TRUE
	unacidable = TRUE

/obj/structure/machinery/constructable_frame/porta_comms/update_icon()
	..()
	var/is_wired = 0
	for(var/obj/item/I in contents)
		if(iswire(I))
			is_wired = 1
			break
	if(components)
		switch(length(components))
			if(0 to 8)
				icon_state = "construct_[length(contents)]_[is_wired]"
			else
				icon_state = "construct_8_1"
	else if(state)
		icon_state = "construct_1_0"
	else
		icon_state = "construct_0_0"

/obj/structure/machinery/constructable_frame/porta_comms/ex_act(severity)
	return

/obj/structure/machinery/constructable_frame/porta_comms/attackby(obj/item/I, mob/user)
	var/area/A = get_area(src)
	if (!A.can_build_special)
		to_chat(usr, SPAN_DANGER("这里不适合部署它！"))
		return
	if(istype(I, /obj/item/circuitboard/machine) && !istype(I, /obj/item/circuitboard/machine/telecomms/relay/tower))
		return
	..()

