/obj/structure/machinery/space_heater
	name = "电暖器"
	desc = "一台电暖器，利用电能通过热辐射加热房间。"
	icon = 'icons/obj/structures/machinery/atmos.dmi'
	icon_state = "sheater0"
	anchored = FALSE
	density = FALSE
	var/obj/item/cell/cell
	var/on = 0
	var/open = 0
	var/set_temperature = T0C + 70 //K
	var/heating_power = 40000

	flags_atom = FPRINT

/obj/structure/machinery/space_heater/Initialize()
	. = ..()
	cell = new (src)
	cell.charge += 500
	update_icon()

/obj/structure/machinery/space_heater/Destroy()
	QDEL_NULL(cell)
	. = ..()


/obj/structure/machinery/space_heater/update_icon()
	overlays.Cut()
	icon_state = "sheater[on]"
	if(open)
		overlays  += "sheater-open"

/obj/structure/machinery/space_heater/get_examine_text(mob/user)
	. = ..()
	. += "电暖器目前[on ? "已开启" : "已关闭"]，检修盖[open ? "开着" : "关着"]。"
	if(open)
		. += "电池[cell ? "已安装" : "未安装"]。"
	else
		. += "电量表显示[cell ? round(cell.percent(),1) : 0]%。"


/obj/structure/machinery/space_heater/emp_act(severity)
	. = ..()
	if(inoperable())
		return
	if(cell)
		cell.emp_act(severity)

/obj/structure/machinery/space_heater/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/cell))
		if(open)
			if(cell)
				to_chat(user, "里面已经有电池了。")
				return
			else
				// insert cell
				var/obj/item/cell/C = usr.get_active_hand()
				if(istype(C))
					if(user.drop_inv_item_to_loc(C, src))
						cell = C
						C.add_fingerprint(usr)

						user.visible_message(SPAN_NOTICE("[user]将电池装入了[src]。"), SPAN_NOTICE("你将电池装入了[src]。"))
		else
			to_chat(user, "必须打开检修盖才能装入电池。")
			return
	else if(HAS_TRAIT(I, TRAIT_TOOL_SCREWDRIVER))
		open = !open
		user.visible_message(SPAN_NOTICE("[user][open ? "打开" : "关闭"]了[src]的检修盖。"), SPAN_NOTICE("你[open ? "打开" : "关闭"]了[src]的检修盖。"))
		update_icon()
		if(!open && user.interactee == src)
			close_browser(user, "spaceheater")
			user.unset_interaction()
	else
		..()
	return

/obj/structure/machinery/space_heater/attack_hand(mob/user as mob)
	src.add_fingerprint(user)
	interact(user)

/obj/structure/machinery/space_heater/interact(mob/user as mob)

	if(open)

		var/dat
		dat = "电池："
		if(cell)
			dat += "<A href='byond://?src=\ref[src];op=cellremove'>已安装</A><BR>"
		else
			dat += "<A href='byond://?src=\ref[src];op=cellinstall'>未安装</A><BR>"

		dat += "电量：[cell ? round(cell.percent(),1) : 0]%<BR><BR>"

		dat += "设定温度："

		dat += "<A href='byond://?src=\ref[src];op=temp;val=-5'>-</A>"

		dat += " [set_temperature]K ([set_temperature-T0C]&deg;C)"
		dat += "<A href='byond://?src=\ref[src];op=temp;val=5'>+</A><BR>"

		user.set_interaction(src)
		show_browser(user, dat, "电暖器控制面板", "spaceheater")
	else
		on = !on
		if(on)
			start_processing()
		else
			stop_processing()
		user.visible_message(SPAN_NOTICE("[user][on ? "开启" : "关闭"]了[src]。"),SPAN_NOTICE("你[on ? "开启" : "关闭"]了[src]。"))
		update_icon()
	return


/obj/structure/machinery/space_heater/Topic(href, href_list)
	. = ..()
	if(.)
		return
	if (usr.stat)
		return
	if ((in_range(src, usr) && istype(src.loc, /turf)) || (isRemoteControlling(usr)))
		usr.set_interaction(src)

		switch(href_list["op"])

			if("temp")
				var/value = text2num(href_list["val"])

				// limit to 0-90 degC
				set_temperature = clamp(set_temperature + value, T0C, T0C + 90)

			if("cellremove")
				if(open && cell && !usr.get_active_hand())
					usr.visible_message(SPAN_NOTICE("[usr]从[src]中取出了[cell]。"), SPAN_NOTICE("你从[src]中取出了[cell]。"))
					cell.update_icon()
					usr.put_in_hands(cell)
					cell.add_fingerprint(usr)
					cell = null


			if("cellinstall")
				if(open && !cell)
					var/obj/item/cell/C = usr.get_active_hand()
					if(istype(C))
						if(usr.drop_held_item())
							cell = C
							C.forceMove(src)
							C.add_fingerprint(usr)

							usr.visible_message(SPAN_NOTICE("[usr]将[C]装入了[src]。"), SPAN_NOTICE("你将[C]装入了[src]。"))

		updateDialog()
	else
		close_browser(usr, "spaceheater")
		usr.unset_interaction()
	return



/obj/structure/machinery/space_heater/process()
	if(on)
		if(isturf(loc) && cell && cell.charge)
			for(var/mob/living/carbon/human/H in range(2, src))
				if(H.bodytemperature < T20C)
					H.bodytemperature += min(floor(T20C - H.bodytemperature)*0.7, 25)
					H.recalculate_move_delay = TRUE


			cell.use(50*CELLRATE)

		else
			on = 0
			stop_processing()
			update_icon()

/obj/structure/machinery/space_heater/radiator
	name = "暖气片"
	desc = "一组暖气片，利用热水通过对流加热房间。"
	icon_state = "radiator"
	anchored = TRUE

/obj/structure/machinery/space_heater/radiator/update_icon()
	return

/obj/structure/machinery/space_heater/radiator/red
	name = "暖气片"
	desc = "一组暖气片，利用热水通过对流加热房间。这组有个红色手柄。"
	icon_state = "radiator-r"
