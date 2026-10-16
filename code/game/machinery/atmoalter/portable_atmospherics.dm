/obj/structure/machinery/portable_atmospherics
	name = "大气调节设备"
	use_power = USE_POWER_NONE
	var/destroyed = 0

/obj/structure/machinery/portable_atmospherics/proc/disconnect()
	anchored = FALSE
	return 1


/obj/structure/machinery/portable_atmospherics/attackby(obj/item/W, mob/user)
	if((istype(W, /obj/item/device/analyzer)) && Adjacent(user))
		visible_message(SPAN_DANGER("[user]对[icon2html(icon, viewers(src))]使用了[W]。"))
		to_chat(user, SPAN_NOTICE("[icon2html(icon, user)]的分析结果："))
		to_chat(user, SPAN_NOTICE("储罐是空的！"))




/obj/structure/machinery/portable_atmospherics/powered
	var/power_rating
	var/power_losses
	var/last_power_draw = 0
	var/obj/item/cell/cell

/obj/structure/machinery/portable_atmospherics/powered/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/cell))
		if(cell)
			to_chat(user, "已经装有一块电池了。")
			return

		var/obj/item/cell/C = I

		if(user.drop_inv_item_to_loc(C, src))
			C.add_fingerprint(user)
			cell = C
			user.visible_message(SPAN_NOTICE("[user]打开[src]的面板，放入了[C]。"), SPAN_NOTICE("你打开[src]的面板，放入了[C]。"))
		return

	if(HAS_TRAIT(I, TRAIT_TOOL_SCREWDRIVER))
		if(!cell)
			to_chat(user, SPAN_DANGER("没有安装电池。"))
			return

		user.visible_message(SPAN_NOTICE("[user]打开[src]的面板，取出了[cell]。"), SPAN_NOTICE("你打开[src]的面板，取出了[cell]。"))
		cell.add_fingerprint(user)
		cell.forceMove(loc)
		cell = null
		return

	..()

