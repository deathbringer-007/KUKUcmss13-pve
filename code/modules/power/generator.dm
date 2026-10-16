/obj/structure/machinery/power/generator
	name = "温差发电机"
	desc = "一台高效温差发电机。"
	icon_state = "teg"
	density = TRUE
	anchored = FALSE

	use_power = USE_POWER_IDLE
	idle_power_usage = 100 //Watts, I hope.  Just enough to do the computer and display things.

/obj/structure/machinery/power/generator/attackby(obj/item/W as obj, mob/user as mob)
	if(HAS_TRAIT(W, TRAIT_TOOL_WRENCH))
		anchored = !anchored
		to_chat(user, SPAN_NOTICE("你[anchored ? "拧紧" : "松开"]了将[src]固定在地板上的螺栓。"))
		use_power = anchored
	else
		..()

/obj/structure/machinery/power/generator/verb/rotate_clock()
	set category = "物品"
	set name = "顺时针旋转发电机"
	set src in view(1)

	if (usr.stat || usr.is_mob_restrained()  || anchored)
		return

	src.setDir(turn(src.dir, 90))

/obj/structure/machinery/power/generator/verb/rotate_anticlock()
	set category = "物品"
	set name = "逆时针旋转发电机"
	set src in view(1)

	if (usr.stat || usr.is_mob_restrained()  || anchored)
		return

	src.setDir(turn(src.dir, -90))
