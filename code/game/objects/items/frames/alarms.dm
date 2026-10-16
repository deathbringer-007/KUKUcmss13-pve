

/*
AIR ALARM ITEM
Handheld air alarm frame, for placing on walls
Code shamelessly copied from apc_frame
*/
/obj/item/frame/air_alarm
	name = "空气警报器框架"
	desc = "用于组装空气警报器。"
	icon = 'icons/obj/structures/machinery/monitors.dmi'
	icon_state = "alarm_bitem"
	flags_atom = FPRINT|CONDUCT

/obj/item/frame/air_alarm/attackby(obj/item/W as obj, mob/user as mob)
	if (HAS_TRAIT(W, TRAIT_TOOL_WRENCH))
		new /obj/item/stack/sheet/metal( get_turf(src.loc), 2 )
		qdel(src)
		return
	..()

/obj/item/frame/air_alarm/proc/try_build(turf/on_wall)
	if (get_dist(on_wall,usr)>1)
		return

	var/ndir = get_dir(on_wall,usr)
	if (!(ndir in GLOB.cardinals))
		return

	var/turf/loc = get_turf(usr)
	var/area/A = loc.loc
	if (!istype(loc, /turf/open/floor))
		to_chat(usr, SPAN_DANGER("不能在这个位置安装空气警报器。"))
		return
	if (A.requires_power == 0 || A.name == "Space")
		to_chat(usr, SPAN_DANGER("不能在这个区域安装空气警报器。"))
		return

	if(gotwallitem(loc, ndir))
		to_chat(usr, SPAN_DANGER("这面墙上已经装有东西了！"))
		return

	new /obj/structure/machinery/alarm(loc, ndir, 1)
	qdel(src)

/*
FIRE ALARM ITEM
Handheld fire alarm frame, for placing on walls
Code shamelessly copied from apc_frame
*/
/obj/item/frame/fire_alarm
	name = "火灾警报器框架"
	desc = "用于组装火灾警报器。"
	icon = 'icons/obj/structures/machinery/monitors.dmi'
	icon_state = "fire_bitem"
	flags_atom = FPRINT|CONDUCT

/obj/item/frame/fire_alarm/attackby(obj/item/W as obj, mob/user as mob)
	if (HAS_TRAIT(W, TRAIT_TOOL_WRENCH))
		new /obj/item/stack/sheet/metal( get_turf(src.loc), 2 )
		qdel(src)
		return
	..()

/obj/item/frame/fire_alarm/proc/try_build(turf/on_wall)
	if (get_dist(on_wall,usr)>1)
		return

	var/ndir = get_dir(on_wall,usr)
	if (!(ndir in GLOB.cardinals))
		return

	var/turf/loc = get_turf(usr)
	var/area/A = loc.loc
	if (!istype(loc, /turf/open/floor))
		to_chat(usr, SPAN_DANGER("不能在这个位置安装火灾警报器。"))
		return
	if (A.requires_power == 0 || A.name == "Space")
		to_chat(usr, SPAN_DANGER("不能在这个区域安装火灾警报器。"))
		return

	if(gotwallitem(loc, ndir))
		to_chat(usr, SPAN_DANGER("这面墙上已经装有东西了！"))
		return

	new /obj/structure/machinery/firealarm(loc, ndir, 1)

	qdel(src)
