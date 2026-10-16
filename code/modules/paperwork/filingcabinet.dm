/* Filing cabinets!
 * Contains:
 * Filing Cabinets
 * Security Record Cabinets
 * Medical Record Cabinets
 */


/*
 * Filing Cabinets
 */
/obj/structure/filingcabinet
	name = "文件柜"
	desc = "带有抽屉的大柜子。"
	icon = 'icons/obj/structures/props/misc.dmi'
	icon_state = "filingcabinet"
	density = TRUE
	anchored = TRUE
	wrenchable = TRUE
	var/list/allowed_types = list(/obj/item/paper, /obj/item/folder, /obj/item/clipboard, /obj/item/photo, /obj/item/paper_bundle, /obj/item/pamphlet)

/obj/structure/filingcabinet/proc/dump_contents()
	for(var/obj/I in src)
		I.forceMove(loc)

/obj/structure/filingcabinet/Destroy()
	dump_contents()
	for(var/obj/item/W in contents)
		if(W.unacidable)
			W.forceMove(loc)
	return ..()

/obj/structure/filingcabinet/chestdrawer
	name = "抽屉柜"
	icon_state = "chestdrawer"


/obj/structure/filingcabinet/filingcabinet //not changing the path to avoid unecessary map issues, but please don't name stuff like this in the future -Pete
	icon_state = "tallcabinet"


/obj/structure/filingcabinet/Initialize()
	. = ..()
	for(var/obj/item/I in loc)
		for(var/allowed_type in allowed_types)
			if(istype(I, allowed_type))
				I.forceMove(src)


/obj/structure/filingcabinet/attackby(obj/item/P as obj, mob/user as mob)
	if(HAS_TRAIT(P, TRAIT_TOOL_WRENCH))
		..()
	else
		for(var/allowed_type in allowed_types)
			if(istype(P, allowed_type))
				to_chat(user, SPAN_NOTICE("你将[P]放入了[src]。"))
				if(user.drop_inv_item_to_loc(P, src))
					icon_state = "[initial(icon_state)]-open"
					sleep(5)
					icon_state = initial(icon_state)
					updateUsrDialog()
					break
			else
				to_chat(user, SPAN_NOTICE("你无法将[P]放入[src]！"))

/obj/structure/filingcabinet/attack_hand(mob/user as mob)
	if(length(contents) <= 0)
		to_chat(user, SPAN_NOTICE("\The [src]是空的。"))
		return

	user.set_interaction(src)
	var/dat = "<center><table>"
	for(var/obj/item/P in src)
		dat += "<tr><td><a href='byond://?src=\ref[src];retrieve=\ref[P]'>[P.name]</a></td></tr>"
	dat += "</table></center>"
	show_browser(user, dat, name, "filingcabinet", width = 350, height = 300)

	return

/obj/structure/filingcabinet/Topic(href, href_list)
	. = ..()
	if(.)
		return
	if(href_list["retrieve"])
		close_browser(usr, "filingcabinet") // Close the menu

		//var/retrieveindex = text2num(href_list["retrieve"])
		var/obj/item/P = locate(href_list["retrieve"])//contents[retrieveindex]
		if(istype(P) && (P.loc == src) && src.Adjacent(usr))
			usr.put_in_hands(P)
			updateUsrDialog()
			icon_state = "[initial(icon_state)]-open"
			spawn(0)
				sleep(5)
				icon_state = initial(icon_state)


/*
 * Security Record Cabinets
 */
/obj/structure/filingcabinet/security
	var/virgin = 1


/obj/structure/filingcabinet/security/proc/populate()
	if(virgin)
		for(var/datum/data/record/G in GLOB.data_core.general)
			var/datum/data/record/S
			for(var/datum/data/record/R in GLOB.data_core.security)
				if((R.fields["name"] == G.fields["name"] || R.fields["id"] == G.fields["id"]))
					S = R
					break
			if(S)
				var/obj/item/paper/P = new /obj/item/paper(src)
				P.info = "<CENTER><B>安保档案</B></CENTER><BR>"
				P.info += "姓名：[G.fields["name"]] 编号：[G.fields["id"]]<BR>\n性别：[G.fields["sex"]]<BR>\n年龄：[G.fields["age"]]<BR>\n身体状况：[G.fields["p_stat"]]<BR>\n精神状况：[G.fields["m_stat"]]<BR>"
				P.info += "<BR>\n<CENTER><B>安保资料</B></CENTER><BR>\n犯罪状态：[S.fields["criminal"]]<BR>\n<BR>\n事件：[S.fields["incident"]]<BR>\n<BR>\n<CENTER><B>备注／记录</B></CENTER><BR>"
				var/counter = 1
				while(S.fields["com_[counter]"])
					P.info += "[S.fields["com_[counter]"]]<BR>"
					counter++
				P.info += "</TT>"
				P.name = "安保档案（[G.fields["name"]]）"
			virgin = 0 //tabbing here is correct- it's possible for people to try and use it
						//before the records have been generated, so we do this inside the loop.

/obj/structure/filingcabinet/security/attack_hand()
	populate()
	..()

/*
 * Medical Record Cabinets
 */
/obj/structure/filingcabinet/medical
	var/virgin = 1

/obj/structure/filingcabinet/medical/proc/populate()
	if(virgin)
		for(var/datum/data/record/G in GLOB.data_core.general)
			var/datum/data/record/M
			for(var/datum/data/record/R as anything in GLOB.data_core.medical)
				if((R.fields["name"] == G.fields["name"] || R.fields["id"] == G.fields["id"]))
					M = R
					break
			if(M)
				var/obj/item/paper/P = new /obj/item/paper(src)
				P.info = "<CENTER><B>医疗档案</B></CENTER><BR>"
				P.info += "姓名：[G.fields["name"]] 编号：[G.fields["id"]]<BR>\n性别：[G.fields["sex"]]<BR>\n年龄：[G.fields["age"]]<BR>\n身体状况：[G.fields["p_stat"]]<BR>\n精神状况：[G.fields["m_stat"]]<BR>"

				P.info += "<BR>\n<CENTER><B>医疗资料</B></CENTER><BR>\n血型：[M.fields["b_type"]]<BR>\n<BR>\n轻度残障：[M.fields["mi_dis"]]<BR>\n详情：[M.fields["mi_dis_d"]]<BR>\n<BR>\n重度残障：[M.fields["ma_dis"]]<BR>\n详情：[M.fields["ma_dis_d"]]<BR>\n<BR>\n过敏：[M.fields["alg"]]<BR>\n详情：[M.fields["alg_d"]]<BR>\n<BR>\n现有疾病：[M.fields["cdi"]]（各疾病的信息见记录／备注栏）<BR>\n详情：[M.fields["cdi_d"]]<BR>\n<BR>\n重要备注：<BR>\n\t[M.fields["notes"]]<BR>\n<BR>\n<CENTER><B>备注／记录</B></CENTER><BR>"
				var/counter = 1
				while(M.fields["com_[counter]"])
					P.info += "[M.fields["com_[counter]"]]<BR>"
					counter++
				P.info += "</TT>"
				P.name = "医疗档案（[G.fields["name"]]）"
			virgin = 0 //tabbing here is correct- it's possible for people to try and use it
						//before the records have been generated, so we do this inside the loop.

/obj/structure/filingcabinet/medical/attack_hand()
	populate()
	..()

/*
 * Hydroponics Cabinets
 */

/obj/structure/filingcabinet/seeds
	name = "种子柜"
	desc = "带有抽屉的大柜子，用于存放种子包。"
	allowed_types = list(/obj/item/seeds)

/obj/structure/filingcabinet/disk
	name = "磁盘柜"
	desc = "带有抽屉的大柜子，用于存放植物数据磁盘。"
	allowed_types = list(/obj/item/disk)
