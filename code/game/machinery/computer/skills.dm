//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:31

/obj/structure/machinery/computer/skills//TODO:SANITY
	name = "任职档案"
	desc = "用于查看人员的任职档案。"
	icon_state = "medlaptop"
	req_one_access = list(ACCESS_MARINE_DATABASE)
	circuit = /obj/item/circuitboard/computer/skills
	var/obj/item/card/id/scan = null
	var/authenticated = null
	var/rank = null
	var/screen = null
	var/datum/data/record/active1 = null
	var/a_id = null
	var/temp = null
	var/printing = null
	var/can_change_id = 0
	var/list/Perp
	var/tempname = null
	//Sorting Variables
	var/sortBy = "name"
	var/order = 1 // -1 = Descending - 1 = Ascending


/obj/structure/machinery/computer/skills/attackby(obj/item/O as obj, user as mob)
	if(istype(O, /obj/item/card/id) && !scan)
		if(usr.drop_held_item())
			O.forceMove(src)
			scan = O
			to_chat(user, "你插入了[O]。")
	..()

/obj/structure/machinery/computer/skills/attack_remote(mob/user as mob)
	return attack_hand(user)

//Someone needs to break down the dat += into chunks instead of long ass lines.
/obj/structure/machinery/computer/skills/attack_hand(mob/user as mob)
	if(..())
		return
	if (src.z > 6)
		to_chat(user, SPAN_DANGER("<b>无法建立连接</b>：\black 你离空间站太远了！"))
		return
	var/dat

	if (temp)
		dat = "<TT>[temp]</TT><BR><BR><A href='byond://?src=\ref[src];choice=Clear Screen'>清屏</A>"
	else
		dat = "确认身份：<A href='byond://?src=\ref[src];choice=Confirm Identity'>[scan ? scan.name : "----------"]</A><HR>"
		if (authenticated)
			switch(screen)
				if(1.0)
					dat += {"
<p style='text-align:center;'>"}
					dat += "<A href='byond://?src=\ref[src];choice=Search Records'>搜索记录</A><BR>"
					dat += "<A href='byond://?src=\ref[src];choice=New Record (General)'>新建记录</A><BR>"
					dat += {"
</p>
<table style="text-align:center;" cellspacing="0" width="100%">
<tr>
<th>记录：</th>
</tr>
</table>
<table style="text-align:center;" border="1" cellspacing="0" width="100%">
<tr>
<th><A href='byond://?src=\ref[src];choice=Sorting;sort=name'>姓名</A></th>
<th><A href='byond://?src=\ref[src];choice=Sorting;sort=id'>编号</A></th>
<th><A href='byond://?src=\ref[src];choice=Sorting;sort=rank'>职位</A></th>
<th><A href='byond://?src=\ref[src];choice=Sorting;sort=fingerprint'>指纹</A></th>
</tr>"}
					if(!isnull(GLOB.data_core.general))
						for(var/datum/data/record/R in sortRecord(GLOB.data_core.general, sortBy, order))
							dat += "<tr><td><A href='byond://?src=\ref[src];choice=Browse Record;d_rec=\ref[R]'>[R.fields["name"]]</a></td>"
							dat += "<td>[R.fields["id"]]</td>"
							dat += "<td>[localized_player_label(R.fields["rank"])]</td>"
						dat += "</table><hr width='75%' />"
					dat += "<A href='byond://?src=\ref[src];choice=Record Maintenance'>记录维护</A><br><br>"
					dat += "<A href='byond://?src=\ref[src];choice=Log Out'>{退出登录}</A>"
				if(2.0)
					dat += "<B>记录维护</B><HR>"
					dat += "<BR><A href='byond://?src=\ref[src];choice=Delete All Records'>删除全部记录</A><BR><BR><A href='byond://?src=\ref[src];choice=Return'>返回</A>"
				if(3.0)
					dat += "<CENTER><B>任职记录</B></CENTER><BR>"
					if ((istype(active1, /datum/data/record) && GLOB.data_core.general.Find(active1)))
						dat += "<table><tr><td> \
						姓名：<A href='byond://?src=\ref[src];choice=Edit Field;field=name'>[active1.fields["name"]]</A><BR> \
						编号：<A href='byond://?src=\ref[src];choice=Edit Field;field=id'>[active1.fields["id"]]</A><BR>\n \
						性别：<A href='byond://?src=\ref[src];choice=Edit Field;field=sex'>[localized_player_label(active1.fields["sex"])]</A><BR>\n \
						年龄：<A href='byond://?src=\ref[src];choice=Edit Field;field=age'>[active1.fields["age"]]</A><BR>\n \
						职位：<A href='byond://?src=\ref[src];choice=Edit Field;field=rank'>[localized_player_label(active1.fields["rank"])]</A><BR>\n \
						身体状况：[localized_player_label(active1.fields["p_stat"])]<BR>\n \
						精神状态：[localized_player_label(active1.fields["m_stat"])]<BR><BR>\n \
						任职与技能概要：<BR> [decode(active1.fields["notes"])]<BR></td> \
						<td align = center valign = top>照片：<br><img src=front.png height=80 width=80 border=4> \
						<img src=side.png height=80 width=80 border=4></td></tr></table>"
					else
						dat += "<B>常规记录丢失！</B><BR>"
					dat += "\n<A href='byond://?src=\ref[src];choice=Delete Record (ALL)'>删除整份记录</A><BR><BR>\n<A href='byond://?src=\ref[src];choice=Print Record'>打印记录</A><BR>\n<A href='byond://?src=\ref[src];choice=Return'>返回</A><BR>"
				if(4.0)
					if(!length(Perp))
						dat += "错误：找不到该字符串。<br><br><A href='byond://?src=\ref[src];choice=Return'>返回</A>"
					else
						dat += {"
<table style="text-align:center;" cellspacing="0" width="100%">
<tr> "}
						dat += "<th>“[tempname]”的搜索结果：</th>"
						dat += {"
</tr>
</table>
<table style="text-align:center;" border="1" cellspacing="0" width="100%">
<tr>
<th>姓名</th>
<th>编号</th>
<th>职位</th>
<th>指纹</th>
</tr> "}
						for(var/i=1, i<=length(Perp), i += 2)
							var/crimstat = ""
							var/datum/data/record/R = Perp[i]
							if(istype(Perp[i+1],/datum/data/record/))
								var/datum/data/record/E = Perp[i+1]
								crimstat = E.fields["criminal"]
							dat += "<tr style=background-color:#00FF7F><td><A href='byond://?src=\ref[src];choice=Browse Record;d_rec=\ref[R]'>[R.fields["name"]]</a></td>"
							dat += "<td>[R.fields["id"]]</td>"
							dat += "<td>[localized_player_label(R.fields["rank"])]</td>"
							dat += "<td>[localized_player_label(crimstat)]</td></tr>"
						dat += "</table><hr width='75%' />"
						dat += "<br><A href='byond://?src=\ref[src];choice=Return'>返回索引。</A>"
		else
			dat += "<A href='byond://?src=\ref[src];choice=Log In'>{登录}</A>"
	show_browser(user, dat, "任职记录", "secure_rec", width = 600, height = 400)
	onclose(user, "secure_rec")
	return

/*Revised /N
I can't be bothered to look more of the actual code outside of switch but that probably needs revising too.
What a mess.*/
/obj/structure/machinery/computer/skills/Topic(href, href_list)
	if(..())
		return
	if (!( GLOB.data_core.general.Find(active1) ))
		active1 = null
	if ((usr.contents.Find(src) || (in_range(src, usr) && istype(loc, /turf))) || (isRemoteControlling(usr)))
		usr.set_interaction(src)
		switch(href_list["choice"])
// SORTING!
			if("Sorting")
				// Reverse the order if clicked twice
				if(sortBy == href_list["sort"])
					if(order == 1)
						order = -1
					else
						order = 1
				else
				// New sorting order!
					sortBy = href_list["sort"]
					order = initial(order)
//BASIC FUNCTIONS
			if("Clear Screen")
				temp = null

			if ("Return")
				screen = 1
				active1 = null

			if("Confirm Identity")
				if (scan)
					if(istype(usr,/mob/living/carbon/human) && !usr.get_active_hand())
						usr.put_in_hands(scan)
					else
						scan.forceMove(get_turf(src))
					scan = null
				else
					var/obj/item/I = usr.get_active_hand()
					if (istype(I, /obj/item/card/id))
						if(usr.drop_held_item())
							I.forceMove(src)
							scan = I

			if("Log Out")
				authenticated = null
				screen = null
				active1 = null

			if("Log In")
				if (isRemoteControlling(usr))
					src.active1 = null
					src.authenticated = usr.name
					src.rank = "AI"
					src.screen = 1
				else if (istype(scan, /obj/item/card/id))
					active1 = null
					if(check_access(scan))
						authenticated = scan.registered_name
						rank = scan.paygrade
						screen = 1
//RECORD FUNCTIONS
			if("Search Records")
				var/t1 = input("搜索内容（部分姓名、编号、指纹或军衔）：", "安保档案", null, null)  as text
				if ((!( t1 ) || usr.stat || !( authenticated ) || usr.is_mob_restrained() || !in_range(src, usr)))
					return
				Perp = new/list()
				t1 = lowertext(t1)
				var/list/components = splittext(t1, " ")
				if(length(components) > 5)
					return //Lets not let them search too greedily.
				for(var/datum/data/record/R in GLOB.data_core.general)
					var/temptext = R.fields["name"] + " " + R.fields["id"] + " " + R.fields["rank"]
					for(var/i = 1, i<=length(components), i++)
						if(findtext(temptext,components[i]))
							var/prelist = new/list(2)
							prelist[1] = R
							Perp += prelist
				for(var/i = 1, i<=length(Perp), i+=2)
					for(var/datum/data/record/E in GLOB.data_core.security)
						var/datum/data/record/R = Perp[i]
						if ((E.fields["name"] == R.fields["name"] && E.fields["id"] == R.fields["id"]))
							Perp[i+1] = E
				tempname = t1
				screen = 4

			if("Record Maintenance")
				screen = 2
				active1 = null

			if ("Browse Record")
				var/datum/data/record/R = locate(href_list["d_rec"])
				if (!( GLOB.data_core.general.Find(R) ))
					temp = "未找到记录！"
				else
					active1 = R
					screen = 3

			if ("Print Record")
				if (!( printing ))
					printing = 1
					sleep(50)
					var/obj/item/paper/P = new /obj/item/paper( loc )
					P.info = "<CENTER><B>任职记录</B></CENTER><BR>"
					if ((istype(active1, /datum/data/record) && GLOB.data_core.general.Find(active1)))
						P.info += "姓名：[active1.fields["name"]] 编号：[active1.fields["id"]]<BR>\n性别：[localized_player_label(active1.fields["sex"])]<BR>\n年龄：[active1.fields["age"]]<BR>\n身体状况：[localized_player_label(active1.fields["p_stat"])]<BR>\n精神状态：[localized_player_label(active1.fields["m_stat"])]<BR>\n任职与技能概要：<BR>\n[decode(active1.fields["notes"])]<BR>"
						P.name = "任职记录（[active1.fields["name"]]）"
					else
						P.info += "<B>常规记录丢失！</B><BR>"
						P.name = "任职记录（???）"
					P.info += "</TT>"

					printing = null
//RECORD DELETE
			if ("Delete All Records")
				temp = ""
				temp += "确定要删除全部任职记录吗？<br>"
				temp += "<a href='byond://?src=\ref[src];choice=Purge All Records'>是</a><br>"
				temp += "<a href='byond://?src=\ref[src];choice=Clear Screen'>否</a>"

			if ("Purge All Records")
				for(var/datum/data/record/R in GLOB.data_core.security)
					GLOB.data_core.security -= R
					qdel(R)
				temp = "全部任职记录已删除。"
				msg_admin_niche("[key_name_admin(usr)] deleted all employment records.")

			if ("Delete Record (ALL)")
				if(istype(active1, /datum/data/record))
					temp = "<h5>确定要删除整份记录吗？</h5>"
					temp += "<a href='byond://?src=\ref[src];choice=Delete Record (ALL) Execute'>是</a><br>"
					temp += "<a href='byond://?src=\ref[src];choice=Clear Screen'>否</a>"
//RECORD CREATE
			if ("New Record (General)")
				active1 = CreateGeneralRecord()

//FIELD FUNCTIONS
			if ("Edit Field")
				var/a1 = active1
				switch(href_list["field"])
					if("name")
						if (istype(active1, /datum/data/record))
							var/new_value = reject_bad_name(input("请输入姓名：", "安保档案", active1.fields["name"], null)  as text)
							if ((!( new_value ) || !length(trim(new_value)) || !( authenticated ) || usr.stat || usr.is_mob_restrained() || (!in_range(src, usr) && (!isRemoteControlling(usr)))) || active1 != a1)
								return
							message_admins("[key_name(usr)] changed the employment record name of [active1.fields["name"]] to [new_value]")
							active1.fields["name"] = new_value

					if("id")
						if (istype(active1, /datum/data/record))
							var/new_value = copytext(trim(sanitize(input("请输入编号：", "安保档案", active1.fields["id"], null)  as text)),1,MAX_MESSAGE_LEN)
							if ((!( new_value ) || !( authenticated ) || usr.stat || usr.is_mob_restrained() || (!in_range(src, usr) && (!isRemoteControlling(usr))) || active1 != a1))
								return
							msg_admin_niche("[key_name_admin(usr)] changed the employment record id for [active1.fields["name"]] ([active1.fields["id"]]) to [new_value].")
							active1.fields["id"] = new_value

					if("sex")
						if (istype(active1, /datum/data/record))
							var/new_value = "Male"
							if (active1.fields["sex"] == "Male")
								new_value = "Female"
							active1.fields["sex"] = new_value
							msg_admin_niche("[key_name_admin(usr)] changed the employment record sex for [active1.fields["name"]] ([active1.fields["id"]]) to [new_value].")

					if("age")
						if (istype(active1, /datum/data/record))
							var/new_value = input("请输入年龄：", "安保档案", active1.fields["age"], null)  as num
							if ((!( new_value ) || !( authenticated ) || usr.stat || usr.is_mob_restrained() || (!in_range(src, usr) && (!isRemoteControlling(usr))) || active1 != a1))
								return
							active1.fields["age"] = new_value
							msg_admin_niche("[key_name_admin(usr)] changed the employment record age for [active1.fields["name"]] ([active1.fields["id"]]) to [new_value].")

					if("rank")
						if(istype(active1, /datum/data/record))
						//This was so silly before the change. Now it actually works without beating your head against the keyboard. /N
							if(GLOB.uscm_highcom_paygrades.Find(rank))
								temp = "<h5>职位：</h5>"
								temp += "<ul>"
								for(var/rank in GLOB.joblist)
									temp += "<li><a href='byond://?src=\ref[src];choice=Change Rank;rank=[rank]'>[rank]</a></li>"
								temp += "</ul>"
							else
								localized_native_alert(usr, "你的军衔不满足此操作要求！")

					if("species")
						if (istype(active1, /datum/data/record))
							var/new_value = copytext(trim(sanitize(input("请输入种族：", "一般档案", active1.fields["species"], null)  as message)),1,MAX_MESSAGE_LEN)
							if ((!( new_value ) || !( authenticated ) || usr.stat || usr.is_mob_restrained() || (!in_range(src, usr) && (!isRemoteControlling(usr))) || active1 != a1))
								return
							active1.fields["species"] = new_value
							msg_admin_niche("[key_name_admin(usr)] changed the employment record species for [active1.fields["name"]] ([active1.fields["id"]]) to [new_value].")

//TEMPORARY MENU FUNCTIONS
			else//To properly clear as per clear screen.
				temp=null
				switch(href_list["choice"])
					if ("Change Rank")
						if(istype(active1, /datum/data/record) && GLOB.uscm_highcom_paygrades.Find(rank))
							var/new_value = href_list["rank"]
							active1.fields["rank"] = new_value
							if(new_value in GLOB.joblist)
								active1.fields["real_rank"] = new_value
							message_admins("[key_name_admin(usr)] changed the employment record rank for [active1.fields["name"]] ([active1.fields["id"]]) to [new_value].")

					if ("Delete Record (ALL) Execute")
						if(istype(active1, /datum/data/record))
							for(var/datum/data/record/R as anything in GLOB.data_core.medical)
								if ((R.fields["name"] == active1.fields["name"] || R.fields["id"] == active1.fields["id"]))
									GLOB.data_core.medical -= R
									qdel(R)
							msg_admin_niche("[key_name_admin(usr)] deleted all employment records for [active1.fields["name"]] ([active1.fields["id"]]).")
							QDEL_NULL(active1)
					else
						temp = "此功能目前似乎无法正常使用，敬请谅解。"

	add_fingerprint(usr)
	updateUsrDialog()
	return

/obj/structure/machinery/computer/skills/emp_act(severity)
	. = ..()
	if(inoperable())
		return

	for(var/datum/data/record/R in GLOB.data_core.security)
		if(prob(10/severity))
			switch(rand(1,6))
				if(1)
					msg_admin_niche("The employment record name of [R.fields["name"]] was scrambled!")
					R.fields["name"] = "[pick(pick(GLOB.first_names_male), pick(GLOB.first_names_female))] [pick(GLOB.last_names)]"
				if(2)
					R.fields["sex"] = pick("Male", "Female")
					msg_admin_niche("The employment record sex of [R.fields["name"]] was scrambled!")
				if(3)
					R.fields["age"] = rand(5, 85)
					msg_admin_niche("The employment record age of [R.fields["name"]] was scrambled!")
				if(4)
					R.fields["criminal"] = pick("None", "*Arrest*", "Incarcerated", "Released")
					msg_admin_niche("The employment record criminal status of [R.fields["name"]] was scrambled!")
				if(5)
					R.fields["p_stat"] = pick("*Unconscious*", "Active", "Physically Unfit")
					msg_admin_niche("The employment record physical state of [R.fields["name"]] was scrambled!")
				if(6)
					R.fields["m_stat"] = pick("*Insane*", "*Unstable*", "*Watch*", "Stable")
					msg_admin_niche("The employment record mental state of [R.fields["name"]] was scrambled!")
			continue

		else if(prob(1))
			msg_admin_niche("The employment record of [R.fields["name"]] was lost!")
			GLOB.data_core.security -= R
			qdel(R)
			continue

