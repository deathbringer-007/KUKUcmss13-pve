/obj/structure/machinery/portable_atmospherics/powered/scrubber
	name = "便携式空气洗涤器"

	icon = 'icons/obj/structures/machinery/atmos.dmi'
	icon_state = "pscrubber:0"
	density = TRUE


	var/on = 0

/obj/structure/machinery/portable_atmospherics/powered/scrubber/New()
	..()
	cell = new/obj/item/cell(src)

/obj/structure/machinery/portable_atmospherics/powered/scrubber/initialize_pass_flags(datum/pass_flags_container/PF)
	..()
	if (PF)
		PF.flags_can_pass_all = PASS_OVER|PASS_AROUND|PASS_UNDER

/obj/structure/machinery/portable_atmospherics/powered/scrubber/emp_act(severity)
	. = ..()
	if(inoperable())
		return

	if(prob(50/severity))
		on = !on
		update_icon()

/obj/structure/machinery/portable_atmospherics/powered/scrubber/update_icon()
	src.overlays = 0

	if(on && cell && cell.charge)
		icon_state = "pscrubber:1"
	else
		icon_state = "pscrubber:0"

	return


//Huge scrubber
/obj/structure/machinery/portable_atmospherics/powered/scrubber/huge
	name = "大型空气洗涤器"
	icon_state = "scrubber:0"
	anchored = TRUE

	chan
	use_power = USE_POWER_NONE

	var/global/gid = 1
	var/id = 0

/obj/structure/machinery/portable_atmospherics/powered/scrubber/huge/New()
	..()
	cell = null

	id = gid
	gid++

	name = "[name]（编号 [id]）"

/obj/structure/machinery/portable_atmospherics/powered/scrubber/huge/attack_hand(mob/user as mob)
		to_chat(usr, SPAN_NOTICE("你无法直接操作这台机器，请使用洗涤器控制台。"))

/obj/structure/machinery/portable_atmospherics/powered/scrubber/huge/update_icon()
	src.overlays = 0

	if(on && !(inoperable()))
		icon_state = "scrubber:1"
	else
		icon_state = "scrubber:0"


/obj/structure/machinery/portable_atmospherics/powered/scrubber/huge/attackby(obj/item/I as obj, mob/user as mob)
	if(HAS_TRAIT(I, TRAIT_TOOL_WRENCH))
		if(on)
			to_chat(user, SPAN_NOTICE("请先关闭它！"))
			return

		anchored = !anchored
		playsound(src.loc, 'sound/items/Ratchet.ogg', 25, 1)
		to_chat(user, SPAN_NOTICE("你用扳手[anchored ? "固定" : "松开"]了[src]。"))

		return

	//doesn't use power cells
	if(istype(I, /obj/item/cell))
		return
	if (HAS_TRAIT(I, TRAIT_TOOL_SCREWDRIVER))
		return

	//doesn't hold tanks
	if(istype(I, /obj/item/tank))
		return

	..()


/obj/structure/machinery/portable_atmospherics/powered/scrubber/huge/stationary
	name = "固定式空气洗涤器"

/obj/structure/machinery/portable_atmospherics/powered/scrubber/huge/stationary/attackby(obj/item/I as obj, mob/user as mob)
	if(HAS_TRAIT(I, TRAIT_TOOL_WRENCH))
		to_chat(user, SPAN_NOTICE("螺栓太紧，你拧不开！"))
		return

	..()
