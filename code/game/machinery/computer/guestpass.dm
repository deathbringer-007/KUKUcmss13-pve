/////////////////////////////////////////////
//Guest pass ////////////////////////////////
/////////////////////////////////////////////
/obj/item/card/id/guest
	name = "访客通行证"
	desc = "提供站内区域的临时通行权限。"
	icon_state = "guest"

	var/temp_access = list() //to prevent agent cards stealing access as permanent
	var/expiration_time = 0
	var/reason = "未指定"

/obj/item/card/id/guest/GetAccess()
	if (world.time > expiration_time)
		return access
	else
		return temp_access

/obj/item/card/id/guest/get_examine_text(mob/user)
	. = ..()
	if (world.time < expiration_time)
		. += SPAN_NOTICE("通行证将于[worldtime2text(expiration_time)]到期。")
	else
		. += SPAN_WARNING("它已于[worldtime2text(expiration_time)]到期。")

/obj/item/card/id/guest/read()
	if (world.time > expiration_time)
		to_chat(usr, SPAN_NOTICE("通行证已于[worldtime2text(expiration_time)]到期。"))
	else
		to_chat(usr, SPAN_NOTICE("通行证将于[worldtime2text(expiration_time)]到期。"))

	to_chat(usr, SPAN_NOTICE("它授予以下区域的通行权限："))
	for (var/A in temp_access)
		to_chat(usr, SPAN_NOTICE("[get_access_desc(A)]."))
	to_chat(usr, SPAN_NOTICE("签发原因：[reason]。"))
	return

/////////////////////////////////////////////
//Guest pass terminal////////////////////////
/////////////////////////////////////////////

/obj/structure/machinery/computer/guestpass
	name = "访客通行证终端"
	icon_state = "guest"
	density = FALSE


	var/obj/item/card/id/giver
	var/list/accesses = list()
	var/giv_name = "未指定"
	var/reason = "未指定"
	var/duration = 5

	var/list/internal_log = list()
	var/mode = 0  // 0 - making pass, 1 - viewing logs

/obj/structure/machinery/computer/guestpass/attackby(obj/O, mob/user)
	if(istype(O, /obj/item/card/id))
		if(!giver)
			if(user.drop_held_item())
				O.forceMove(src)
				giver = O
				updateUsrDialog()
		else
			to_chat(user, SPAN_WARNING("里面已经有身份卡了。"))

/obj/structure/machinery/computer/guestpass/attack_remote(mob/user as mob)
	return attack_hand(user)

/obj/structure/machinery/computer/guestpass/attack_hand(mob/user as mob)
	if(..())
		return

	user.set_interaction(src)
	var/dat

	if (mode == 1) //Logs
		dat += "<h3>操作记录</h3><br>"
		for (var/entry in internal_log)
			dat += "[entry]<br><hr>"
		dat += "<a href='byond://?src=\ref[src];action=print'>打印</a><br>"
		dat += "<a href='byond://?src=\ref[src];mode=0'>返回</a><br>"
	else
		dat += "<h3>访客通行证终端</h3><br>"
		dat += "<a href='byond://?src=\ref[src];mode=1'>查看操作记录</a><br><br>"
		dat += "签发身份卡：<a href='byond://?src=\ref[src];action=id'>[giver]</a><br>"
		dat += "持证人：<a href='byond://?src=\ref[src];choice=giv_name'>[giv_name]</a><br>"
		dat += "原因：<a href='byond://?src=\ref[src];choice=reason'>[reason]</a><br>"
		dat += "有效时长（分钟）：<a href='byond://?src=\ref[src];choice=duration'>[duration] 分钟</a><br>"
		dat += "可访问区域：<br>"
		if (giver && giver.access)
			for (var/A in giver.access)
				var/area = get_access_desc(A)
				if (A in accesses)
					area = "<b>[area]</b>"
				dat += "<a href='byond://?src=\ref[src];choice=access;access=[A]'>[area]</a><br>"
		dat += "<br><a href='byond://?src=\ref[src];action=issue'>签发通行证</a><br>"

	user << browse(dat, "window=guestpass;size=400x520")
	onclose(user, "guestpass")


/obj/structure/machinery/computer/guestpass/Topic(href, href_list)
	if(..())
		return
	usr.set_interaction(src)
	if (href_list["mode"])
		mode = text2num(href_list["mode"])

	if (href_list["choice"])
		switch(href_list["choice"])
			if ("giv_name")
				var/nam = stripped_input("通行证持有人", "姓名", giv_name)
				if (nam)
					giv_name = nam
			if ("reason")
				var/reas = stripped_input(usr,"签发通行证的原因", "原因", reason)
				if(reas)
					reason = reas
			if ("duration")
				var/dur = tgui_input_number(usr, "通行证有效时长，以分钟计，最多30分钟。", "有效时长", 5, 30, 1)
				if (dur)
					if (dur > 0 && dur <= 30)
						duration = dur
					else
						to_chat(usr, SPAN_WARNING("有效时长无效。"))
			if ("access")
				var/A = text2num(href_list["access"])
				if (A in accesses)
					accesses.Remove(A)
				else
					accesses.Add(A)
	if (href_list["action"])
		switch(href_list["action"])
			if ("id")
				if (giver)
					if(ishuman(usr))
						giver.forceMove(usr.loc)
						if(!usr.get_active_hand())
							usr.put_in_hands(giver)
						giver = null
					else
						giver.forceMove(src.loc)
						giver = null
					accesses.Cut()
				else
					var/obj/item/I = usr.get_active_hand()
					if (istype(I, /obj/item/card/id))
						if(usr.drop_held_item())
							I.forceMove(src)
							giver = I
				updateUsrDialog()

			if ("print")
				var/dat = "<h3>访客通行证终端操作记录</h3><br>"
				for (var/entry in internal_log)
					dat += "[entry]<br><hr>"
				//to_chat(usr, "Printing the log, standby...")
				//sleep(50)
				var/obj/item/paper/P = new/obj/item/paper( loc )
				P.name = "操作记录"
				P.info = dat

			if ("issue")
				if (giver)
					var/number = add_zero("[rand(0,9999)]", 4)
					var/entry = "\[[worldtime2text()]\] [giver.registered_name]（[giver.assignment]）向[giv_name]签发了#[number]号通行证。原因：[reason]。授予以下区域的通行权限："
					for (var/i=1 to length(accesses))
						var/A = accesses[i]
						if (A)
							var/area = get_access_desc(A)
							entry += "[i > 1 ? ", [area]" : "[area]"]"
					entry += "。到期时间：[worldtime2text(world.time + duration*10*60)]。"
					internal_log.Add(entry)

					var/obj/item/card/id/guest/pass = new(src.loc)
					pass.temp_access = accesses.Copy()
					pass.registered_name = giv_name
					pass.expiration_time = world.time + duration*10*60
					pass.reason = reason
					pass.name = "#[number]号访客通行证"
				else
					to_chat(usr, SPAN_DANGER("没有签发用身份卡，无法签发通行证。"))
	updateUsrDialog()
	return
