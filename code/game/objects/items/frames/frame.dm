
//items that are frames or assembly used to construct something (table parts, camera assembly, etc...)

/obj/item/frame
	appearance_flags = TILE_BOUND

// APC FRAME

/obj/item/frame/apc
	name = "\improper 区域电力控制器框架"
	desc = "用于维修或组装区域电力控制器。"
	icon = 'icons/obj/structures/machinery/apc_repair.dmi'
	icon_state = "apc_frame"
	flags_atom = FPRINT|CONDUCT

/obj/item/frame/apc/attackby(obj/item/W as obj, mob/user as mob)
	..()
	if (HAS_TRAIT(W, TRAIT_TOOL_WRENCH))
		new /obj/item/stack/sheet/metal( get_turf(src.loc), 2 )
		qdel(src)

/obj/item/frame/apc/proc/try_build(turf/on_wall)
	if (get_dist(on_wall,usr)>1)
		return
	var/ndir = get_dir(usr,on_wall)
	if (!(ndir in GLOB.cardinals))
		return
	var/turf/loc = get_turf(usr)
	var/area/A = get_area(loc)
	if (!istype(loc, /turf/open/floor))
		to_chat(usr, SPAN_WARNING("不能在这个位置安装区域电力控制器。"))
		return
	if (A.requires_power == 0 || istype(A, /area/space))
		to_chat(usr, SPAN_WARNING("不能在这个区域安装区域电力控制器。"))
		return
	if (A.get_apc())
		to_chat(usr, SPAN_WARNING("这个区域已经有区域电力控制器了。"))
		return //only one APC per area
	if (A.always_unpowered)
		to_chat(usr, SPAN_WARNING("这个区域不适合安装区域电力控制器。"))
		return
	for(var/obj/structure/machinery/power/terminal/T in loc)
		if (T.master)
			to_chat(usr, SPAN_WARNING("这里已经有另一个电网终端了。"))
			return
		else
			var/obj/item/stack/cable_coil/C = new /obj/item/stack/cable_coil(loc)
			C.amount = 10
			to_chat(usr, "你剪断了电缆，拆掉了闲置的电力终端。")
			qdel(T)
	new /obj/structure/machinery/power/apc(loc, ndir, 1)
	qdel(src)
