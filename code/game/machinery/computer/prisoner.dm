//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:31

/obj/structure/machinery/computer/prisoner
	name = "囚犯管理终端"
	icon = 'icons/obj/structures/machinery/computer.dmi'
	icon_state = "explosive"
	density = TRUE
	req_access = list(ACCESS_MARINE_BRIG)
	circuit = /obj/item/circuitboard/computer/prisoner
	var/id = 0
	var/temp = null
	var/status = 0
	var/timeleft = 60
	var/stop = 0
	var/screen = 0 // 0 - No Access Denied, 1 - Access allowed
	processing = TRUE


/obj/structure/machinery/computer/prisoner/attack_remote(mob/user as mob)
	return src.attack_hand(user)


/obj/structure/machinery/computer/prisoner/attack_hand(mob/user as mob)
	if(..())
		return
	user.set_interaction(src)
	var/dat
	dat += "<B>囚犯植入物管理系统</B><BR>"
	if(screen == 0)
		dat += "<HR><A href='byond://?src=\ref[src];lock=1'>解锁控制台</A>"
	else if(screen == 1)
		dat += "<HR>化学植入物<BR>"
		var/turf/Tr = null
		for(var/i in GLOB.chem_implant_list)
			var/obj/item/implant/chem/C = i
			Tr = get_turf(C)
			if((Tr) && (Tr.z != src.z)) continue//Out of range
			if(!C.implanted) continue
			dat += "[C.imp_in.name]|剩余单位：[C.reagents.total_volume]|注射："
			dat += "<A href='byond://?src=\ref[src];inject1=\ref[C]'>(<font color=red>(1)</font>)</A>"
			dat += "<A href='byond://?src=\ref[src];inject5=\ref[C]'>(<font color=red>(5)</font>)</A>"
			dat += "<A href='byond://?src=\ref[src];inject10=\ref[C]'>(<font color=red>(10)</font>)</A><BR>"
			dat += "********************************<BR>"
		dat += "<HR>追踪植入物<BR>"
		for(var/i in GLOB.tracking_implant_list)
			var/obj/item/implant/tracking/T = i
			Tr = get_turf(T)
			if((Tr) && (Tr.z != src.z)) continue//Out of range
			if(!T.implanted) continue
			var/loc_display = "未知"
			var/mob/living/carbon/M = T.imp_in
			if(is_ground_level(M.z) && !istype(M.loc, /turf/open/space))
				var/turf/mob_loc = get_turf(M)
				loc_display = mob_loc.loc
			dat += "编号：[T.id]|位置：[loc_display]<BR>"
			dat += "<A href='byond://?src=\ref[src];[HrefToken(forceGlobal = TRUE)];warn=\ref[T]'>(<font color=red><i>向植入者发送消息</i></font>)</A> |<BR>"
			dat += "********************************<BR>"
		dat += "<HR><A href='byond://?src=\ref[src];lock=1'>锁定控制台</A>"

	show_browser(user, dat, name, "computer")
	onclose(user, "computer")
	return


/obj/structure/machinery/computer/prisoner/process()
	if(!..())
		src.updateDialog()
	return


/obj/structure/machinery/computer/prisoner/Topic(href, href_list)
	if(..())
		return
	if((usr.contents.Find(src) || (in_range(src, usr) && istype(src.loc, /turf))) || (isRemoteControlling(usr)))
		usr.set_interaction(src)

		if(href_list["inject1"])
			var/obj/item/implant/I = locate(href_list["inject1"])
			if(I) I.activate(1)

		else if(href_list["inject5"])
			var/obj/item/implant/I = locate(href_list["inject5"])
			if(I) I.activate(5)

		else if(href_list["inject10"])
			var/obj/item/implant/I = locate(href_list["inject10"])
			if(I) I.activate(10)

		else if(href_list["lock"])
			if(src.allowed(usr))
				screen = !screen
			else
				to_chat(usr, "访问未获授权。")

		else if(href_list["warn"])
			var/warning = strip_html(input(usr,"消息：","在此输入消息！",""))
			if(!warning) return
			var/obj/item/implant/I = locate(href_list["warn"])
			if((I)&&(I.imp_in))
				var/mob/living/carbon/R = I.imp_in
				to_chat(R, SPAN_XENOWARNING("你听见脑海中响起一个声音：“[warning]”"))

		src.add_fingerprint(usr)
	src.updateUsrDialog()
	return
