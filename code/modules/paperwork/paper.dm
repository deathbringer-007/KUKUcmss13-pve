/*
 * Paper
 * also scraps of paper
 */

#define MAX_FIELDS 51

/obj/item/paper
	name = "纸"
	gender = PLURAL
	icon = 'icons/obj/items/paper.dmi'
	icon_state = "paper"
	item_state = "paper"
	pickup_sound = 'sound/handling/paper_pickup.ogg'
	drop_sound = 'sound/handling/paper_drop.ogg'
	throwforce = 0
	w_class = SIZE_TINY
	throw_speed = SPEED_FAST
	flags_equip_slot = SLOT_HEAD
	flags_armor_protection = BODY_FLAG_HEAD
	attack_verb = list("轻敲")
	ground_offset_x = 9
	ground_offset_y = 8

	var/info //What's actually written on the paper.
	var/info_links //A different version of the paper which includes html links at fields and EOF
	var/stamps //The (text for the) stamps on the paper.
	var/fields //Amount of user created fields
	var/list/stamped
	var/ico[0] //Icons and
	var/offset_x[0] //offsets stored for later
	var/offset_y[0] //usage by the photocopier
	var/rigged = 0
	var/spam_flag = 0

	// any photos that might be attached to the paper
	var/list/photo_list

	var/deffont = "Verdana"
	var/signfont = "Times New Roman"
	var/crayonfont = "Comic Sans MS"

//lipstick wiping is in code/game/obj/items/weapons/cosmetics.dm!

/obj/item/paper/Initialize(mapload, photo_list)
	. = ..()
	stamps = ""
	src.photo_list = photo_list

	if(info != initial(info))
		info = html_encode(info)
		info = replacetext(info, "\n", "<BR>")
		info = parsepencode(info)

	update_icon()
	updateinfolinks()

/obj/item/paper/update_icon()
	if(icon_state == "paper_talisman" || icon_state == "paper_wy_words" || icon_state == "paper_uscm" || icon_state == "fortune" || icon_state == "paper_flag")
		return
	if(info)
		if(icon_state == "paper_wy")
			icon_state = "paper_wy_words"
			return
		if(icon_state == "paper_uscm")
			icon_state = "paper_uscm_words"
			return
		if(icon_state == "paper_flag")
			icon_state = "paper_flag_words"
			item_state = "paper_flag"
			return
		icon_state = "paper_words"
		return
	icon_state = "paper"

/obj/item/paper/get_examine_text(mob/user)
	. = ..()
	if(in_range(user, src) || isobserver(user))
		if(!(istype(user, /mob/dead/observer) || istype(user, /mob/living/carbon/human) || isRemoteControlling(user)))
			// Show scrambled paper if they aren't a ghost, human, or silicone.
			read_paper(user,scramble = TRUE)
		else
			read_paper(user)
	else
		. += SPAN_NOTICE("距离太远。")

/obj/item/paper/proc/read_paper(mob/user, scramble = FALSE)
	var/datum/asset/asset_datum = get_asset_datum(/datum/asset/simple/paper)
	asset_datum.send(user)
	if(photo_list)
		for(var/photo in photo_list)
			user << browse_rsc(photo_list[photo], photo)
	var/paper_info = info
	if(scramble)
		paper_info = stars_decode_html(info)
	show_browser(user, "<BODY class='paper'>[paper_info][stamps]</BODY>", name, name, width = 650, height = 700)
	onclose(user, name)

/obj/item/paper/verb/rename()
	set name = "Rename paper"
	set category = "Object"
	set src in usr

	var/n_name = strip_html(input(usr, "要给这张纸取什么标题？", "纸张标签", null)  as text)
	close_browser(usr, name)
	if((loc == usr && usr.stat == 0))
		name = "[(n_name ? text("[n_name]") : "纸张")]"
	add_fingerprint(usr)
	return

/obj/item/paper/attack_self(mob/living/user)
	..()
	read_paper(user)

/obj/item/paper/attack_remote(mob/living/silicon/ai/user as mob)
	var/dist
	dist = get_dist(src, user)
	if(dist < 2)
		read_paper(user)
	else
		//Show scrambled paper
		show_browser(user, "<BODY class='paper'>[stars(info)][stamps]</BODY>", name, name)
		onclose(user, name)
	return

/obj/item/paper/attack(mob/living/carbon/M, mob/living/carbon/user)
	if(user.zone_selected == "eyes")
		user.visible_message(SPAN_NOTICE("你将纸张展示给[M]。"), \
			SPAN_NOTICE("[user]举起一张纸，展示给[M]。"))
		examine(M)

	else if(user.zone_selected == "mouth") // lipstick wiping
		if(ishuman(M))
			var/mob/living/carbon/human/H = M
			if(H == user)
				to_chat(user, SPAN_NOTICE("你用[src]擦掉了脸上的涂装。"))
				H.lip_style = null
				H.update_body()
			else
				user.visible_message(SPAN_WARNING("[user]开始用[src]擦除[H]脸上的涂装。"), \
									SPAN_NOTICE("你开始擦除[H]脸上的涂装。"))
				if(do_after(user, 10, INTERRUPT_ALL, BUSY_ICON_FRIENDLY) && do_after(H, 10, INTERRUPT_ALL, BUSY_ICON_GENERIC)) //user needs to keep their active hand, H does not.
					user.visible_message(SPAN_NOTICE("[user]用[src]擦掉了[H]脸上的涂装。"), \
										SPAN_NOTICE("你擦掉了[H]脸上的涂装。"))
					H.lip_style = null
					H.update_body()

/obj/item/paper/vv_get_dropdown()
	. = ..()
	. += "<option value>-----PAPER-----</option>"
	. += "<option value='?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];customise_paper=\ref[src]'>Customise content</option>"

/obj/item/paper/proc/addtofield(id, text, links = 0)
	var/locid = 0
	var/laststart = 1
	var/textindex = 1
	var/spam_protection = 100
	while(1) // I know this can cause infinite loops and fuck up the whole server, but the if(istart==0) should be safe as fuck
		var/istart = 0
		spam_protection--
		if(spam_protection <= 0)
			return

		if(links)
			istart = findtext(info_links, "<span class=\"paper_field\">", laststart)
		else
			istart = findtext(info, "<span class=\"paper_field\">", laststart)

		if(istart==0)
			return // No field found with matching id

		laststart = istart+1
		locid++
		if(locid == id)
			var/iend = 1
			if(links)
				iend = findtext(info_links, "</span>", istart)
			else
				iend = findtext(info, "</span>", istart)

			//textindex = istart+26
			textindex = iend
			break

	if(links)
		var/before = copytext(info_links, 1, textindex)
		var/after = copytext(info_links, textindex)
		info_links = before + text + after
	else
		var/before = copytext(info, 1, textindex)
		var/after = copytext(info, textindex)
		info = before + text + after
		updateinfolinks()

/obj/item/paper/proc/updateinfolinks()
	info_links = info
	for(var/i=1,  i<=min(fields, MAX_FIELDS), i++)
		addtofield(i, "<font face=\"[deffont]\"><A href='byond://?src=\ref[src];write=[i]'>write</A></font>", 1)
	info_links = info_links + "<font face=\"[deffont]\"><A href='byond://?src=\ref[src];write=end'>write</A></font>"


/obj/item/paper/proc/clearpaper()
	info = null
	stamps = null
	stamped = list()
	overlays.Cut()
	updateinfolinks()
	update_icon()


/obj/item/paper/proc/parsepencode(t, obj/item/tool/pen/P, mob/user as mob, iscrayon = 0)
	var/datum/asset/asset = get_asset_datum(/datum/asset/simple/paper)

	t = replacetext(t, "\[center\]", "<center>")
	t = replacetext(t, "\[/center\]", "</center>")
	t = replacetext(t, "\[br\]", "<BR>")
	t = replacetext(t, "\[b\]", "<B>")
	t = replacetext(t, "\[/b\]", "</B>")
	t = replacetext(t, "\[i\]", "<I>")
	t = replacetext(t, "\[/i\]", "</I>")
	t = replacetext(t, "\[u\]", "<U>")
	t = replacetext(t, "\[/u\]", "</U>")
	t = replacetext(t, "\[large\]", "<font size=\"4\">")
	t = replacetext(t, "\[/large\]", "</font>")
	t = replacetext(t, "\[sign\]", "<font face=\"[signfont]\"><i>[user ? user.real_name : "Anonymous"]</i></font>")
	t = replacetext(t, "\[date\]", "<font face=\"[signfont]\"><i>[time2text(REALTIMEOFDAY, "Day DD Month [GLOB.game_year]")]</i></font>")
	t = replacetext(t, "\[shortdate\]", "<font face=\"[signfont]\"><i>[time2text(REALTIMEOFDAY, "DD/MM/[GLOB.game_year]")]</i></font>")
	t = replacetext(t, "\[time\]", "<font face=\"[signfont]\"><i>[worldtime2text("hh:mm")]</i></font>")
	t = replacetext(t, "\[date+time\]", "<font face=\"[signfont]\"><i>[worldtime2text("hh:mm")], [time2text(REALTIMEOFDAY, "Day DD Month [GLOB.game_year]")]</i></font>")
	t = replacetext(t, "\[field\]", "<span class=\"paper_field\"></span>")

	t = replacetext(t, "\[h1\]", "<H1>")
	t = replacetext(t, "\[/h1\]", "</H1>")
	t = replacetext(t, "\[h2\]", "<H2>")
	t = replacetext(t, "\[/h2\]", "</H2>")
	t = replacetext(t, "\[h3\]", "<H3>")
	t = replacetext(t, "\[/h3\]", "</H3>")

	if(!iscrayon)
		t = replacetext(t, "\[*\]", "<li>")
		t = replacetext(t, "\[hr\]", "<HR>")
		t = replacetext(t, "\[small\]", "<font size = \"1\">")
		t = replacetext(t, "\[/small\]", "</font>")
		t = replacetext(t, "\[list\]", "<ul>")
		t = replacetext(t, "\[/list\]", "</ul>")
		t = replacetext(t, "\[table\]", "<table border=1 cellspacing=0 cellpadding=3 style='border: 1px solid black;'>")
		t = replacetext(t, "\[/table\]", "</td></tr></table>")
		t = replacetext(t, "\[grid\]", "<table>")
		t = replacetext(t, "\[/grid\]", "</td></tr></table>")
		t = replacetext(t, "\[row\]", "</td><tr>")
		t = replacetext(t, "\[cell\]", "<td>")
		t = replacetext(t, "\[logo\]", "<img src = [asset.get_url_mappings()["wylogo.png"]]>")
		t = replacetext(t, "\[wy\]", "<img src = [asset.get_url_mappings()["wylogo.png"]]>")
		t = replacetext(t, "\[uscm\]", "<img src = [asset.get_url_mappings()["uscmlogo.png"]]>")
		t = replacetext(t, "\[upp\]", "<img src = [asset.get_url_mappings()["upplogo.png"]]>")
		t = replacetext(t, "\[cmb\]", "<img src = [asset.get_url_mappings()["cmblogo.png"]]>")

		t = "<font face=\"[deffont]\" color=[P ? P.pen_color : "black"]>[t]</font>"
	else // If it is a crayon, and he still tries to use these, make them empty!
		t = replacetext(t, "\[*\]", "")
		t = replacetext(t, "\[hr\]", "")
		t = replacetext(t, "\[small\]", "")
		t = replacetext(t, "\[/small\]", "")
		t = replacetext(t, "\[list\]", "")
		t = replacetext(t, "\[/list\]", "")
		t = replacetext(t, "\[table\]", "")
		t = replacetext(t, "\[/table\]", "")
		t = replacetext(t, "\[row\]", "")
		t = replacetext(t, "\[cell\]", "")
		t = replacetext(t, "\[logo\]", "")

		t = "<font face=\"[crayonfont]\" color=[P ? P.pen_color : "black"]><b>[t]</b></font>"

// t = replacetext(t, "#", "") // Junk converted to nothing!

//Count the fields
	var/laststart = 1
	while(1)
		var/i = findtext(t, "<span class=\"paper_field\">", laststart)
		if(i==0)
			break
		laststart = i+1
		fields = min(fields+1, MAX_FIELDS)
		//NOTE: The max here will include the auto-created field when hitting a paper with a pen. So it should be [your_desired_number]+1.
	return t


/obj/item/paper/proc/openhelp(mob/user as mob)
	var/dat = {"<HTML>
	<BODY>
		<b><center>蜡笔与钢笔格式指令</center></b><br>
		<br>
		\[br\] : 插入换行。<br>
		\[center\] - \[/center\] : 将文字居中。<br>
		\[h1\] - \[/h1\] : 将文字设为一级标题。<br>
		\[h2\] - \[/h2\] : 将文字设为二级标题。<br>
		\[h3\] - \[/h3\] : 将文字设为三级标题。<br>
		\[b\] - \[/b\] : 将文字<b>加粗</b>。<br>
		\[i\] - \[/i\] : 将文字设为<i>斜体</i>。<br>
		\[u\] - \[/u\] : 给文字加<u>下划线</u>。<br>
		\[large\] - \[/large\] : <font size = \"4\">放大</font>文字。<br>
		\[sign\] : 插入无法冒名的本人签名。<br>
		\[field\] : 插入可继续填写的隐藏字段，适用于表格。<br>
		<br>
		<b><center>钢笔专用格式指令</center></b><br>
		\[small\] - \[/small\] : <font size = \"1\">缩小</font>文字。<br>
		\[list\] - \[/list\] : 建立列表。<br>
		\[*\] : 插入列表项目符号。<br>
		\[hr\] : 插入水平分隔线。
	</BODY></HTML>"}
	show_browser(user, dat, "钢笔书写帮助", "paper_help")

/obj/item/paper/proc/burnpaper(obj/item/P, mob/user)
	var/class = "<span class='warning'>"

	if(P.heat_source >= 400 && !user.is_mob_restrained())
		if(istype(P, /obj/item/tool/lighter/zippo))
			class = "<span class='rose'>"

		user.visible_message("[class][user]将[P]靠向[src]，看起来正试图将其点燃！", \
		"[class]你将[P]靠向[src]，慢慢将它点燃。")

		spawn(20)
			if(get_dist(src, user) < 2 && user.get_active_hand() == P && P.heat_source)
				user.visible_message("[class][user]烧穿了[src]，将它化为灰烬。灰烬在空中飘动，最终落在地上。", \
				"[class]你烧穿了[src]，将它化为灰烬。灰烬在空中飘动，最终落在地上。")

				if(user.get_inactive_hand() == src)
					user.drop_inv_item_on_ground(src)

				new /obj/effect/decal/cleanable/ash(src.loc)
				qdel(src)

			else
				to_chat(user, SPAN_DANGER("你必须稳稳拿住[P]才能烧掉[src]。"))


/obj/item/paper/Topic(href, href_list)
	..()
	if(!usr || (usr.stat || usr.is_mob_restrained()))
		return

	if(usr.client.prefs.muted & MUTE_IC)
		to_chat(usr, SPAN_DANGER("你已被禁言，无法在纸上书写。"))
		return

	if(href_list["write"])
		var/id = href_list["write"]
		var/t =  stripped_multiline_input(usr, "请输入要写的内容：", "Write", "", MAX_MESSAGE_LEN)
		var/shortened_t = copytext(t,1,100)
		msg_admin_niche("PAPER: [key_name(usr)] tried to write something. First 100 characters: [shortened_t]")

		var/obj/item/i = usr.get_active_hand() // Check to see if he still got that darn pen, also check if he's using a crayon or pen.
		var/iscrayon = 0
		if(!HAS_TRAIT(i, TRAIT_TOOL_PEN))
			if(!istype(i, /obj/item/toy/crayon))
				return
			iscrayon = 1


		// if paper is not in usr, then it must be near them, or in a clipboard, noticeboard or folder, which must be in or near usr
		if(src.loc != usr && !src.Adjacent(usr) && !((istype(src.loc, /obj/item/clipboard) || istype(src.loc, /obj/structure/noticeboard) || istype(src.loc, /obj/item/folder)) && (src.loc.loc == usr || src.loc.Adjacent(usr)) ) )
			return

		t = replacetext(t, "\n", "<BR>")
		t = parsepencode(t, i, usr, iscrayon) // Encode everything from pencode to html

		if(id!="end")
			addtofield(text2num(id), t) // He wants to edit a field, let him.
		else
			info += t // Oh, he wants to edit to the end of the file, let him.
			updateinfolinks()

		show_browser(usr, "<BODY class='paper'>[info_links][stamps]</BODY>", name, name) // Update the window

		update_icon()
		playsound(src, "paper_writing", 15, TRUE)

/obj/item/paper/attackby(obj/item/P, mob/user)
	..()

	if(istype(P, /obj/item/paper) || istype(P, /obj/item/photo))
		if (istype(P, /obj/item/paper/carbon))
			var/obj/item/paper/carbon/C = P
			if (!C.iscopy && !C.copied)
				to_chat(user, SPAN_NOTICE("先取下复写纸。"))
				add_fingerprint(user)
				return
		if(loc != user) return
		var/obj/item/paper_bundle/B = new(get_turf(user))
		if (name != "paper")
			B.name = name
		else if (P.name != "paper" && P.name != "photo")
			B.name = P.name
		user.drop_inv_item_on_ground(P)
		user.drop_inv_item_on_ground(src)
		to_chat(user, SPAN_NOTICE("你将[P.name]夹到了[(src.name == "paper") ? "纸张" : src.name]上。"))
		B.attach_doc(src, user, TRUE)
		B.attach_doc(P, user, TRUE)
		user.put_in_hands(B)

	else if(HAS_TRAIT(P, TRAIT_TOOL_PEN) || istype(P, /obj/item/toy/crayon))
		if(HAS_TRAIT(P, TRAIT_TOOL_PEN))
			var/obj/item/tool/pen/p = P
			if(!p.on)
				to_chat(user, SPAN_NOTICE("你的笔还没打开！"))
				return
		show_browser(user, "<BODY class='paper'>[info_links][stamps]</BODY>", name, name) // Update the window
		//openhelp(user)
		return

	else if(istype(P, /obj/item/tool/stamp))
		if((!in_range(src, usr) && loc != user && !( istype(loc, /obj/item/clipboard) ) && loc.loc != user && user.get_active_hand() != P))
			return

		stamps += (stamps=="" ? "<HR>" : "<BR>") + "<i>本文件已盖上[P.name]。</i>"
		playsound(src, 'sound/effects/alien_footstep_medium3.ogg', 20, TRUE, 6)

		var/image/stampoverlay = image('icons/obj/items/paper.dmi')
		var/x
		var/y
		if(istype(P, /obj/item/tool/stamp/captain) || istype(P, /obj/item/tool/stamp/weyyu))
			x = rand(-2, 0)
			y = rand(-1, 2)
		else
			x = rand(-2, 2)
			y = rand(-3, 2)
		offset_x += x
		offset_y += y
		stampoverlay.pixel_x = x
		stampoverlay.pixel_y = y

		if(!ico)
			ico = new
		ico += "paper_[P.icon_state]"
		stampoverlay.icon_state = "paper_[P.icon_state]"

		if(!stamped)
			stamped = new
		stamped += P.type
		overlays += stampoverlay

		to_chat(user, SPAN_NOTICE("你用橡皮印章在纸上盖了章。"))

	else if(P.heat_source >= 400)
		burnpaper(P, user)

	add_fingerprint(user)
	return

/obj/item/paper/proc/convert_to_chem_report()
	if(istype(src, /obj/item/paper/research_report))
		return src
	var/obj/item/paper/research_report/CR = new /obj/item/paper/research_report
	if(istype(src, /obj/item/paper/research_notes))
		var/obj/item/paper/research_notes/N = src
		if(N.note_type == "synthesis")
			CR.data = N.data
			if(N.full_report)
				CR.completed = TRUE
	CR.info = info
	CR.info_links = info_links
	CR.stamps = stamps
	CR.fields = fields
	CR.name = name
	CR.forceMove(loc)
	qdel(src)
	return CR

/*
 * Premade paper
 */
/obj/item/paper/Court
	name = "裁决"
	info = "因危害空间站的罪行，判处该犯人：<BR>\n<BR>\n"

/obj/item/paper/almayer_storage
	name = "阿尔迈耶号应急储藏室便条"
	info = "<i>嘿，加里，我已经按你说的，让伙计们把大部分应急物资搬到自动储存与检索系统货舱了。<BR>下次你来奇努克，我请你喝啤酒，怎么样？</i>"
/obj/item/paper/Toxin
	name = "化学资料"
	info = "已知舰载毒物：<BR>\n\tA级半液态弗燃素：<BR>\n\t\t剧毒。人体无法承受超过 15 单位的浓度。<BR>\n\t\t防毒面具过滤 50 单位后将失效。<BR>\n\t\t会像气体一样扩散。<BR>\n\t\t可由洗气机过滤。<BR>\n\t\t瓶装版本与气罐中的版本有很大区别！<BR>\n<BR>\n\t\t警告：极易燃烧。除封闭燃烧区外，请远离热源！<BR>\n\t\t警告：未经授权使用属于犯罪。<BR>\n已知舰载抗毒剂：<BR>\n\t01P 型抗毒剂：可对抗 A 级弗燃素。<BR>\n\t\t直接注入血液效果最佳。<BR>\n\t\t每套普通医疗包都含有一支满装注射器。<BR>\n\t\t专用中毒急救箱约有七支。<BR>\n<BR>\n已知舰载化学品（其他）：<BR>\n\t复苏剂 T#001：<BR>\n\t\t即使仅将 1 单位直接注入血液，也可解除弗燃素造成的麻痹和昏睡。<BR>\n\t\t用于濒死患者时，可阻止后续损伤约“剂量×3”秒。<BR>\n\t\t它不会治愈患者，也不会使其能够被治愈。<BR>\n\t\t也可用于非濒死患者，但药物消失得同样快。<BR>\n\t催眠剂 T#054：<BR>\n\t\t5 单位会精确引起一分钟睡眠，效果可以累积。<BR>\n\t\t警告：未经授权使用属于犯罪。"

/obj/item/paper/courtroom
	name = "SS13 法律标准作业程序速成指南"
	info = "<B>职责分工：</B><BR>\n侦探主要担任调查员和检察官。<BR>\n勤务助理获得侦探书面授权后，也可履行这些职责。<BR>\n舰长、人事主管或监狱官担任审判机关。<BR>\n安保员负责执行令状、维持庭审安全及押送囚犯。<BR>\n<BR>\n<B>调查阶段：</B><BR>\n犯罪发生后，侦探应收集证据，查明作案者及事件经过。务必逐项登记，不得遗漏，将所有证据记在纸上，并采集足够数量的指纹。需要询问他人时，可以当面提问；若对方拒绝，可请审判机关签发传票。若仍不回应，应以不服从命令及妨碍司法为由拘押，待其合作后释放。<BR>\n<BR>\n法证人员明确嫌疑人后，应在纸上写出逮捕令，<B>必须列明指控</B>。随后向审判机关简述案情；若案情基本成立，应予签署，再由安保执行。<BR>\n<BR>\n<B>审前准备阶段：</B><BR>\n被告若要求法律代理人，应为其提供，并给予双方会面时间，在牢房会面也可以。应向被告及律师提供所有拟用于庭审的证据副本，重新抄写在纸上也行。这称为证据披露材料。除少数例外，<B>双方庭审只能使用这些证据</B>。控方若寻求死刑，必须此时说明；辩方若拟以精神障碍主张无罪，也必须此时提出，留出充分检查时间。<BR>\n双方分别编制证人名单。默认情况下，被告同时列入双方名单。双方可继续收集证据，但拟用于庭审的新证据也必须提供给对方。\n辩方可在此时准备针对证据的动议。<BR>\n<B>可提出的动议：</B><BR>\n1. <U>排除证据：</U>证据存在问题，应予剔除，例如与案件无关或安保人员存在舞弊。<BR>\n2. <U>自由行动：</U>要求被告在庭审前及庭审中不戴手铐。<BR>\n3. <U>传唤证人：</U>辩方能合理说明该证人的必要性，而对方拒不合作时，可签发传票。<BR>\n4. <U>撤销指控：</U>证据不足以开庭，应撤销指控。法证人员可以重新起诉，但审判机关必须仔细审查新证据。<BR>\n5. <U>认定无受审能力：</U>被告可能精神失常。动议获准后，由医务人员检查；若确认，应由医疗人员照护，直至具备受审能力。<BR>\n<BR>\n所有人员转移到法庭。<BR>\n<B>审前听证：</B><BR>\n审判机关与双方在法庭会面，除警卫外不得有其他人在场。辩方提交答辩；若认罪，直接进入量刑。随后双方提出动议，由审判机关裁决，双方均可辩论。审判机关取得船员名单，先筛选合适且有空的陪审员，再将其召来。双方可提问，并申请排除明显偏颇者，但排除理由必须得到审判机关认可。<BR>\n<BR>\n<B>庭审：</B><BR>\n分为三个阶段。<BR>\n1. <B>开庭陈词：</B>双方可作简短陈述，不得出示任何证据。<BR>\n2. <B>传唤证人与出示证据：</B>控方先按任意顺序传唤获准名单上的证人，必要时可再次传唤。律师可结合证据提问，以证明观点。每位证人作证后，对方都有交叉询问机会。双方问完后，控方可传唤其他证人，也可重新传唤同一证人。控方结束后，辩方传唤证人。初步举证结束后，双方可自由传唤任一名单上的证人。<BR>\n双方结束证人询问后，进入下一阶段。<BR>\n3. <B>结案陈词：</B>规则同开庭陈词。<BR>\n陪审团随后<B>秘密评议，并必须一致同意裁决</B>。注意，可以对部分罪名判有罪，对其他罪名判无罪。例如，被告被指控持枪杀人，但只是未经许可拾起枪械，则可能杀人罪不成立，却成立非法持有武器罪。达成一致后宣布裁决；若无法达成且认为不可能达成，则宣布陪审团僵局，换一批全新陪审员，从审前阶段重新开始。<BR>\n<BR>\n<B>量刑阶段：</B><BR>\n若寻求死刑，必须经过庭审，并直接进入第二部分。<BR>\nI. 双方可按任意顺序提出更多证据和证人，情感因素等不受限制。控方提出量刑建议，双方结束后由审判机关宣判。<BR>\nII. 陪审团留下，按第一部分进行，唯一任务是判断死刑是否适用；若不适用，由法官选择刑罚。<BR>\n<BR>\n大功告成。安保随后执行判决，并将成立的罪名记入该人的档案。<BR>\n"

/obj/item/paper/hydroponics
	name = "来自比利·鲍勃的问候"
	info = "<B>嘿，园艺同行！</B><BR>\n<BR>\n我信不过空间站上的人，所以几周前就离开了。不过，还是给你留下一些操作说明。<BR>\n种植植物时，只要知道该选哪些，每一代就能变得更强壮、效力更高、产量更好。用你的植物分析仪来挑选。将收获物放进种子提取器，就能获得种子，重新种植出更好的作物！<BR>\n有时种植盘杂草太多，会出现变异的蘑菇或杂草品种。极少数情况下，连杂草本身也会变异！<BR>\n<BR>\n总之，祝你玩得开心！<BR>\n<BR>\n此致，<BR>\n比利·鲍勃·约翰逊。<BR>\n<BR>\n附言，几点提示：<BR>\n荨麻：效力＝伤害<BR>\n毒蝇伞：效力＝致命程度＋副作用<BR>\n裸盖菇：效力＝致幻强度＋效果<BR>\n辣椒：效力＝辣度<BR>\n<B>蘑菇需要营养液才能存活！</B><BR>\n<B>荨麻等杂草需要水才能存活！</B><BR>\n<B>其他植物两者都需要。</B>"

/obj/item/paper/djstation
	name = "DJ 监听哨站"
	info = "<B>欢迎，新主人！</B><BR><BR>你买到了最新监听设备。我们的电信系统最擅长接收公共和私人无线电频率。按以下步骤，就能收听那些有趣的频道：<br><ol><li>准备一把多功能工具。</li><li>用它操作每台机器，也就是广播器、接收器和中继器。</li><li>打开所有机器，监听配置已为你预设完成。</li></ol>就这么简单。若要监听私人频道，还需配置前台的对讲机。可用频率如下：<br><ul><li>145.7——公共频道</li><li>144.7——人工智能私人频道</li><li>135.9——安保频道</li><li>135.7——工程频道</li><li>135.5——医疗频道</li><li>135.3——指挥频道</li><li>135.1——科研频道</li><li>134.9——采矿频道</li><li>134.7——货运频道</li>"

/obj/item/paper/warhead_recycle
	name = "美国殖民地陆战队回收计划"
	info = "<B>美国殖民地陆战队轨道炮系统用户，您好！</B><BR><BR>很遗憾地通知您，一次通信失误导致您的轨道轰炸弹头被当作废金属回收了！别担心，这些金属已经在最高指挥部的卧式冷柜上发挥了良好作用。"

/obj/item/paper/flag
	name = "纸旗"
	desc = "有人粗糙地把一张纸粘在了棍子上。你很想像个傻瓜一样挥舞它。"
	icon_state = "paper_flag"
	item_state = "paper_flag"

	anchored = TRUE

/obj/item/paper/jobs
	name = "岗位资料"
	info = "本文介绍 13 号空间站可分配的全部正式岗位。<BR>\n资料采用以下格式，通常按职级由低到高排列。<BR>\n<BR>\n<B>岗位名称</B>　普通权限＞实验室权限－引擎权限－系统权限（大气控制）<BR>\n\t岗位说明<BR>\n岗位职责（不分先后）<BR>\n适用时附带提示<BR>\n<BR>\n<B>研究助理</B> 1>1-0-0<BR>\n\t这可能是最低级的岗位。初次分配岗位后才进入空间站的人会自动获得此职，权限有限。人事主管应根据需要作出适当安排。<BR>\n1. 协助研究人员。<BR>\n2. 清洁实验室。<BR>\n3. 准备材料。<BR>\n<BR>\n<B>勤务助理</B> 2>0-0-0<BR>\n\t协助安保员，主要在舰内巡逻，随时准备维护舰船安全。（补充：更新或升级后的安保规程允许为安保人员配发低级武器。）<BR>\n1. 巡逻舰船、守卫重点区域。<BR>\n2. 协助安保员。<BR>\n3. 执行其他安保任务。<BR>\n<BR>\n<B>技术助理</B> 1>0-0-1<BR>\n\t另一个初级岗位，协助工程师与空间站技师维护空间站。这项工作很重要，可减轻空间站技师通常繁重的工作量。<BR>\n1. 协助空间站技师与工程师。<BR>\n2. 执行日常维护。<BR>\n3. 准备材料。<BR>\n<BR>\n<B>医疗助理</B> 1>1-0-0<BR>\n\t第四种初级岗位，相对少见，在医疗区之外权限不大。类似护士，协助整理医疗记录、准备物资、填充注射器和检查生命体征。<BR>\n1. 协助医务人员。<BR>\n2. 更新医疗档案。<BR>\n3. 准备医疗操作所需材料。<BR>\n<BR>\n<B>研究技师</B> 2>3-0-0<BR>\n\t比研究助理高一级。通常没有独立实验室，但会更直接参与实验。可正式担任其他人的顾问。<BR>\n1. 向上级汇报研究。<BR>\n2. 与正式研究员共同开展研究。<BR>\n<BR>\n<B>侦探</B> 3>2-0-0<BR>\n\t这份工作大多有些乏味。唯一职责是调查并分析犯罪现场，减轻安保员的部分负担。应判断事件经过、出庭作证，并妥善保存证据。<BR>\n1. 调查犯罪现场并得出结论。<BR>\n2. 妥善储存、分类登记证据。<BR>\n3. 向上级或调查机构陈述发现。<BR>\n<BR>\n<B>空间站技师</B> 2>0-2-3<BR>\n\t确保 13 号空间站的全部系统可用。主要在计算机实验室工作，修复故障设备，并与大气技师协作。<BR>\n1. 维护空间站系统。<BR>\n2. 修理设备。<BR>\n<BR>\n<B>大气技师</B> 3>0-0-4<BR>\n\t主要在大气控制中心与实验室工作，维护空间站脆弱的大气环境，职责十分重要。<BR>\n1. 维护空间站大气。<BR>\n2. 安全地研究空间站内的大气。<BR>\n<BR>\n<B>工程师</B> 2>1-3-0<BR>\n\t应详细了解空间站推进系统的原理，是少数可不受限制进入引擎区的岗位之一。<BR>\n1. 维护引擎。<BR>\n2. 防止引擎起火。<BR>\n3. 保持安全轨道。<BR>\n<BR>\n<B>医学研究员</B> 2>5-0-0<BR>\n\t确保所有实验安全，并进行有助于改善空间站的实验。新实验室建成前，通常没有太多工作。<BR>\n1. 确保空间站安全。<BR>\n2. 研究空间站所研究材料的医学性质。<BR>\n<BR>\n<B>科学家</B> 2>5-0-0<BR>\n\t研究空间站处理材料的性质，尤其是毒性。由于经常处理弗燃素，也可称为弗燃素技师。<BR>\n1. 研究弗燃素。<BR>\n2. 确保所有弗燃素得到妥善处理。<BR>\n<BR>\n<B>医生（军官）</B> 2>0-0-0<BR>\n\t主要留在医疗区，确保所有人来接受治疗与检查，并维持医疗物资秩序。<BR>\n1. 治疗伤员。<BR>\n2. 为所有人员体检。<BR>\n3. 监督医疗设备使用。<BR>\n<BR>\n<B>安保员</B> 3>0-0-0<BR>\n\t维护空间站秩序与安全，也应协助修理，承担一般维护工作。原本不配武器，需自行利用资源。（补充：更新或升级后的安保规程允许为安保人员配发武器。）<BR>\n1. 维持秩序。<BR>\n2. 协助他人。<BR>\n3. 修复结构问题。<BR>\n<BR>\n<B>安保主管</B> 4>5-2-2<BR>\n\t指挥安保人员，审慎管理安保设备的使用。所有安保事项都应向其汇报。<BR>\n1. 监督安保。<BR>\n2. 分配巡逻任务。<BR>\n3. 保护空间站和人员。<BR>\n<BR>\n<B>人事主管</B> 4>4-2-2<BR>\n\t管理人员的一切行动，并有权分配岗位与权限。<BR>\n1. 分配职责。<BR>\n2. 管理人员。<BR>\n3. 管理研究工作。<BR>\n<BR>\n<B>舰长</B> 5>5-5-5（全站无限制权限）<BR>\n\t空间站上能获得的最高职位，可进入任何区域，必须保护好身份卡。也有权分配岗位与权限，不得滥用权力。<BR>\n1. 分配全部岗位。<BR>\n2. 检查空间站问题。<BR>\n3. 履行管理职责。<BR>\n"

/obj/item/paper/photograph
	name = "照片"
	icon_state = "photo"
	var/photo_id = 0
	item_state = "paper"

/obj/item/paper/sop
	name = "文件——《标准作业程序》"
	info = "警报等级：<BR>\n蓝色——紧急情况<BR>\n\t1. 由火灾触发。<BR>\n\t2. 由人工触发。<BR>\n\t应对：关闭所有防火门，只有重置警报后才能开启。<BR>\n红色——弹射／自毁<BR>\n\t1. 由舱段操作计算机触发。<BR>\n\t应对：指定时间后，舱段将完全弹离。<BR>\n<BR>\n引擎维护说明：<BR>\n\t关闭点火系统。<BR>\n\t启动内部电源。<BR>\n\t启动轨道平衡矩阵。<BR>\n\t移走区域内的挥发性液体。<BR>\n\t穿上消防服。<BR>\n\t作业后：进行去污，并接受医疗检查。<BR>\n<BR>\n毒理实验室规程：<BR>\n\t无论何时都要戴防毒面具。<BR>\n\t准备氧气瓶。<BR>\n\t启动内部供气。<BR>\n\t作业后：进行去污，并接受医疗检查。<BR>\n<BR>\n灾害应对：<BR>\n\t火灾：<BR>\n\t\t启动区域火警，移至安全区，取得消防服。<BR>\n\t\t事后评估并修复损伤，必要时撤离。<BR>\n\t流星雨：<BR>\n\t\t启动火警，移至舰船后部。<BR>\n\t\t事后修复损伤，必要时撤离。<BR>\n\t意外再入大气层：<BR>\n\t\t启动舰船前部火警，将挥发性物质移至防火区！<BR>\n\t\t取得消防服，留在安全处等待救援船。<BR>\n\t\t若救援船未到，撤离到附近安全区！<BR>\n"

/obj/item/paper/prison_station/test_log
	name = "文件——《实验记录》"
	info = "<p style=\"text-align: center;\"><sub>实验记录</sub></p><p>标本：候选生物武器卡帕，3 号个体</p><BR>\n<p>-</p><p>步骤：观察</p><p>结果：标本在牢房内踱步，似乎焦躁不安，发出叫声。</p><p>-</p><p>步骤：灵长类实验对象</p><p>结果：被标本吞食。与上次灵长类实验无显著差异。</p><p><em>备注：该加大力度了。</em></p><p>-</p><p>步骤：人类实验对象（D-1）。指示其“像摸狗一样抚摸它”。</p><p>结果：标本与 D-1 对视约两秒。D-1 尖叫并敲打观察窗，恳求放其离开。标本扑向 D-1，以前爪反复劈砍将其杀死。</p><p><em>备注：很有前景！</em></p><p>-</p><p>步骤：两名人类实验对象（D-2、D-3）。指示其制服标本。</p><p>结果：D-2 与 D-3 缓慢靠近标本。D-3 拳击标本前额，无明显效果。标本扑向 D-3，以前爪反复劈砍将其杀死。D-2 尖叫并敲打观察窗。标本扑向 D-2，以前爪反复劈砍将其杀死。</p><p>标本开始抓挠观察室通道门。它表现出意料之外的力量，竟能将门撕——</p>"

/obj/item/paper/prison_station/interrogation_log
	name = "文件——《实验记录》"
	desc = "这张纸似乎曾裹在干血里揉成一团，几乎无法辨认。";
	info = "<p style=\"text-align: center;\"><sub>审讯记录</sub></p><p>人员：（隐去）“维尔丹”（隐去）</p><BR>\n<p</p><p>步骤：绞压手法</p><p>结果：维尔丹四处撞头，显得焦躁并哭泣，可能十分愤怒。大声叫喊。</p><p>-</p><p>步骤：电击。</p><p>结果：愤怒地哭喊。与上一步无显著差异。</p><p><em>备注：耐痛，必须加大疼痛。</em></p><p>-</p><p>步骤：巧手工匠。在锯子工作时命其“看着”。</p><p>结果：维尔丹盯着看了约三秒，随后尖叫，试图挣脱束缚，并恳求释放。锯子终于完成工作。维尔丹似乎已语无伦次。</p><p><em>备注：很有前景！</em></p><p>-</p><p>步骤：收集情报。</p><p>结果：维尔丹开始透露其他小组的信息。</p><p>维尔丹因疲倦而低声说话，我得坐近些。维尔丹向我凑近，他——</p><em>（纸张其余部分溅满鲜血，无法辨认。）</em>";

/obj/item/paper/prison_station/monkey_note
	name = "文件——《灵长类实验对象说明》"
	info = "看紧那些猴子，记清数量。我们刚发现它们能钻过通风管，进入大气系统。<BR>\n<BR>\n我可不想再向监狱官解释，囚犯怎么又弄到了新“宠物”。"

/obj/item/paper/prison_station/warden_note
	name = "文件——《最后的记录》"
	info = "<p>时间不多了。留给任何响应求救信号的人。</p><p>最初，南部高戒备牢区遭到撞击。我们以为是海盗袭击。</p><p>确实是，但平民居住区也发生了什么。我们忙着应付海盗，无法响应。</p><p>一半守卫已死，其余大多数下落不明。</p><p>许多人可能在中央封锁启动时被困在院子里。</p><p>中央封锁会在 12:50 自动解除。</p><p>院区封锁不会自动——</p><p>有什么来了</p>"

/obj/item/paper/prison_station/chapel_program
	name = "文件——《礼拜仪式流程》"
	info = "“揭开第四印时，我听见第四个活物说：你来看。<BR>\n<BR>\n我就观看，见有一匹灰马；骑在马上的，名字叫作死，阴府也随着他。有权柄赐给他们，可以用刀剑、饥荒、瘟疫、野兽，杀害地上四分之一的人。”<BR>\n<BR>\n<BR>\n<BR>\n“牧师：主啊，求你怜悯。众人：主啊，求你怜悯。<BR>\n牧师：基督啊，求你怜悯。众人：基督啊，求你怜悯。<BR>\n牧师：主啊，求你怜悯。众人：主啊，求你怜悯。”<BR>\n<BR>\n<BR>\n<BR>\n<em>只有这两段仍可辨认，其余部分都被血迹覆盖。</em>"

/obj/item/paper/prison_station/inmate_handbook
	name = "文件——《囚犯权利、待遇与责任》"
	info = "<p style=\"text-align: center;\"><sub>菲奥里纳轨道监狱</sub></p><p style=\"text-align: center;\"><sub>囚犯权利、待遇与责任</sub></p><p>权利</p><p>根据《2087 年惩教法》，你享有以下权利：</p><p>1. 获得全体工作人员公正、公平对待。<BR>\n2. 知悉规章、程序和日程。<BR>\n3. 自由选择宗教信仰，自愿参加宗教仪式。<BR>\n4. 获得健康照护，包括餐食、适当寝具与衣物及其清洗安排、定期淋浴、保暖和新鲜空气所需的通风、定期锻炼、洗漱用品、医疗及牙科治疗。</p><p>待遇</p><p>以下并非你的固有权利，而是机构授予的待遇，可在任何时间、因任何原因撤销：</p><p>1. 可获准接受亲友探视并通信。<BR>\n2. 可获准取得教育或娱乐读物。<BR>\n3. 可获准保有少量个人资金，在监狱商店购物。</p><p>责任</p><p>囚犯必须履行以下责任：</p><p>1. 了解并遵守所有规章、程序和日程。<BR>\n2. 服从工作人员的一切命令。<BR>\n3. 承认并尊重其他囚犯的权利。<BR>\n4. 不浪费食物，遵守洗衣和淋浴安排，保持住所整洁，不藏违禁品，并在需要时寻求医疗及牙科照护。<BR>\n5. 探视时举止得体，不接收或传递违禁品，不通过通信违反法律、机构规章或指引。<BR>\n6. 履行财务义务，包括但不限于法院裁定的费用、罚金和赔偿。<BR>\n<B>7. 配合菲奥里纳轨道监狱医学研究部开展的任何及全部研究。</B></p>"

/obj/item/paper/prison_station/pirate_note
	name = "文件——《舰长日志》"
	info = "<p>找到他了。</p><p>至少找到了他的位置。以我们的名声，他会被关进菲奥里纳倒也不奇怪。</p><p>他再会逃，也不可能独自脱身。安保措施太多，没有船也走不了。他们防备好了来自内部的一切威胁。</p><p>但他们可没准备好应付一艘直接撞穿舰体的“流浪货船”。</p><p>撑住，杰克。我们来接你了。"

/obj/item/paper/prison_station/pirate_note/clfship
	info = "<p>我们中弹了！</p><p>求救！求救！我们遭到了——……的攻击。</p><p>我们落在某颗行星上，南边似乎有殖民地。也许可以过去看看有没有美国殖民地陆战队。我们的船他妈的坏得普通手段根本修不好，还在等损伤评估。</p><p>科比和瑞安今天伤重不治……“该死的陆战队。”总有一天我会复仇……</p><p>总有一天，殖民地会摆脱维兰德-汤谷与陆战队爪牙的压迫统治。"

/obj/item/paper/prison_station/nursery_rhyme
	info = "<p>玛丽有只小羊羔，<BR>\n羊毛洁白像雪飘；<BR>\n玛丽无论去哪里，<BR>\n小羊总要跟着跑。</p><p>一天跟她进学校，<BR>\n学校规矩不准闹；<BR>\n孩子见了都欢笑，<BR>\n小羊竟然来学校。</p><p>老师把它赶出门，<BR>\n它却仍在近处绕；<BR>\n耐心等着不离开，<BR>\n直到玛丽露面了。</p><p>“小羊为何爱玛丽？”<BR>\n孩子急切问道；<BR>\n“因为玛丽也爱它呀”，<BR>\n老师微笑回答道。"

/obj/item/paper/lv_624/cheese
	name = "文件——《军械库物资说明》"
	info = "<p>管理员似乎在上次地球补给中额外订了一批奶酪。主厨房没地方存，他又想让奶酪“陈化”之类的。</p><p>暂时放在军械库，那里条件似乎合适。总之，气味问题还请见谅。</p><p>——约翰逊法警</p>"

/obj/item/paper/bigred/walls
	name = "揉皱的便条"
	info = "<b>墙里有棉花糖</b>"

/obj/item/paper/bigred/lambda
	name = "撕下的日记页"
	info = "史密斯总监的日记\n记录日期：2181 年 12 月 15 日\n今天，我感受到了真正的进展！XX-121 繁殖项目全面展开，库珀管理员已批准继续生产标本。想想看，这一切竟都源于最初那一个“女王”形态的标本……它已长到近五米高，却完全没有停止产卵的迹象！这些生物将成为我们时代的新一代合成人，我们要让那些西格森混蛋瞧瞧。"

/obj/item/paper/bigred/union
	name = "竖井矿工工会"
	info = "今天，我们再也受不了因为达不到上级不合理的矿石指标，就被克扣工资、当狗使唤。他们说这里有“价值连城的矿石海洋”，可我们挖了多年，连一颗钻石都没见过。够了，忍无可忍。他们以为能控制我们的一切，那就错了！我们受压迫的工人要揭竿而起，反抗资本家的走狗，用武力夺回工资。\n如果他们派狗来镇压，我们会把每一个都杀光。"

/obj/item/paper/bigred/finance
	name = "重要财务信件"
	info = "致：殖民地财务主管约瑟夫·巴恩斯\n发自：殖民地采矿主管艾登·孟\n我们什么时候才能拿到修采矿机器人的额外资金？那台机器人几小时就能完成一个月的工作！可它坏了以后，我们的指标却一点没减。说真的，我们究竟什么时候才能拿到任何新资金？我的大多数员工已经干了十个月，一分钱都没领到；手头仅剩的一点钱，连让设施勉强运转都很困难。\n科研部门什么时候才能不再拿走殖民地一半的资金？是，我知道他们有个超级机密的维兰德-汤谷项目，但说实话，实验室对这个项目一个字也没透露。你真要信任一个连内容都不知道的项目吗？\n请尽快告诉我是否能得到资金，以及何时到账。我怕自己撑不了多久，没法再让他们抱有希望……\n——孟"

/obj/item/paper/bigred/smuggling
	name = "折叠的便条"
	info = "好吧，杰夫，你藏着整瓶碎心剂被抓时，是我替你出头的，你还欠着我。记得我怎么让你免去十五年牢狱之灾吗？\n总之，我有件特别的事要你办，就当还人情。\n<p>卸货柜时，留意带蓝色六边形标记的箱子。</p><p>找到后，任何情况下都别打开，也别让别人靠近。把它送到病毒学区，具体是大厅后方通向洞穴的洞口。</p>\n<p>放在右侧最近的裂隙边，我的人会来收。要是积压了，就往上叠。</p>\n<p>很简单吧？不过是搬货。有人问，就说里面是电动工具。</p>\n<p>祝好运。干得好，我会拿几根我们弄到的太空大麻烟卷给你当小费。</p>"
	color = "grey"

/obj/item/paper/bigred/witness
	name = "目击者的日记"
	info = "纵观历史，人类一直在对抗邪恶。不管是共产主义者、懒鬼、自由派、混蛋，还是你的老板，这些邪恶最终总能以某种方式解决。<p>但我潜入拉姆达洞穴时，亲眼见到了一种生物，它散发的邪恶如此浓烈，立刻让人充满愤怒和恐惧。\n见过它之后，我才意识到，管理层竟允许这种怪物待在殖民地，简直疯了。\n在我的殖民地……我的家里，妈的！我还得和这些蠢货混蛋一起生活；他们被愚蠢和公司利润迷住了眼，根本看不见自己带来的邪恶。"
	color = "green"
/obj/item/paper/bigred/them
	name = "它们"
	color = "green"
	info = "<p>我他妈受不了了。我毫不怀疑，整个殖民地管理层都被它们控制了。那些东西邪恶得令人发指，叫它们怪物都是侮辱怪物。</p><p>现在我明白为什么要藏着它们了，因为它们才是真正的主人，操纵殖民地的意志，威胁整个人类。</p>\n<p>那些……东西并不是科学家的实验对象，我们才是它们的实验对象！</p>\n它们不愿让任何未受控制的人知道。我敢说，只要大家知道，拉姆达秘密实验室几小时内就会被烧成平地……要是我们有办法做到就好了……"

/obj/item/paper/bigred/crazy
	name = "它们来找我了"
	info = "妈的，我一遍又一遍地告诉别人，从同事、朋友，到任何肯听的人。可每一次，他们都说我疯了。<p>最近它们注意到了我，开始派爪牙对付我。只要离开洞穴，无论走到哪儿，几乎总有法警跟着，至少隔着三十英尺。它们知道了，想让我闭嘴，或者去死。</p>\n后来，安保主管吉姆·汉密尔顿那个混蛋亲自命令我停止“散播谣言”，否则后果自负。<p><b>不，我不会听命于一个傀儡，一个受它们控制的哈巴狗！</b></p>\n\n不过还有希望。工作场所里正传着兵变的消息。矿工会起义，用武力夺取管理权，领头人也答应我调查拉姆达，把真相彻底揭开！<p>但不能只是揭露那些扭曲的秘密，再把它们留在那里。它们活着太危险，而且一定会想办法逃脱惩罚。兵变发生时，我会杀穿安保防线，找到误运到这里的温压炸药，趁乱送进秘密实验室，将那里彻底炸毁，拯救殖民地和全人类。</p>"
	color = "green"

/obj/item/paper/bigred/final
	name = "最后一篇记录"
	color = "green"
	info =  "<p>我没能做到。那些该死的法警，它们的爪牙，嗅到了同事们的计划，提前发动了搜捕。我们得到消息，搭起几道路障想拖住他们，但已经太迟。我们的计划，我拯救人类的计划，全都化为乌有。</p>我躺着写下这些时，他们正用催泪气体灌满整片区域，枪声在洞穴中回荡。\n它们已经侵入我的脑海，声音在……笑，说“一切都结束了”，还说“我们已经崛起”。它们嘲笑我，因为我根本无力阻止。\n就在我快写完最后一篇记录时，一名死去军官的无线电里传出几声惊慌的呼叫，说拉姆达发生红色警报级突破，“异形已脱离收容”。\n可他们的呼救一个也没得到回应，因为同僚都忙着殴打可怜的矿工……\n<b>它们赢了……它们早就计划好了一切……</b>\n如今只有上帝能救我们……"

/obj/item/paper/bigred/upp
	name = "进步人民联盟命令"

/obj/item/paper/bigred/upp/Initialize(mapload, photo_list)
	. = ..()

	var/datum/asset/asset = get_asset_datum(/datum/asset/simple/paper)
	info = "<center> <img src = [asset.get_url_mappings()["upplogo.png"]]> <br> <b><small>进步人民联盟第四舰队</b></small> <br> <b><large>第 173 空降侦察部队第 2 排命令</large></b> <br> <small>第 52 号</small></center> <hr> <b>进步人民联盟军官命令</b><br><b>上校 <redacted> 甘巴塔尔</b><br><b>MV-35 指挥官</b> <br> 日期：2182 年 <br> <b><large>特别任务<large></b> <hr> 敌对的维兰德-汤谷公司在尼洛德星区边缘的活动愈发令人无法容忍。更有证据表明，他们正在研究开发与部署某种生物武器，这对联盟在该星区的利益构成不可接受的安全威胁。此类武器落入美洲联盟或美国殖民地陆战队手中的风险，同样不可接受。<br><br>第 173 空降侦察部队鲍里斯小队接令如下：对雷神星（美洲联盟代号 LV-670）上维兰德-汤谷的奥克斯利之争殖民地、特里金特大坝实施空降侦察。查明当地生物武器项目是否属实。若明确证实项目存在，准许迅速突袭并回收。避免与美洲联盟及美国殖民地陆战队接触，若遭遇其军队，立即中止任务。<hr><center><b>授权军官：甘巴塔尔</b><br>姓名与军衔：上校</center> <hr><small><i>仅限授权用途</i></small>"

/obj/item/paper/brynhild
	name = "手榴弹使用须知！"
	info = "既然你们这群废物根本靠不住，连该死的毒气手榴弹都拿不稳，它们和其他手榴弹已被移到武器维护台旁的弹药柜。"

/obj/item/paper/crumpled
	name = "纸片"
	icon_state = "scrap"

/obj/item/paper/crumpled/update_icon()
	return

/obj/item/paper/crumpled/bloody
	icon_state = "scrap_bloodied"

/obj/item/paper/crumpled/bloody/csheet
	info = "<b>角色卡</b>\n\n野蛮人科尔巴斯\n6 级野蛮人\n生命值：47/93\n力量：18\n敏捷：14\n体质：16\n智力：8\n感知：11\n魅力：15\n\n<B>物品栏：</b>\n巨剑 +3\n链甲——\n\n\n纸张其余部分都被血迹覆盖。"

/obj/item/paper/wy
	icon_state = "paper_wy"

/obj/item/paper/wy/Initialize(mapload, photo_list)
	. = ..()

	var/datum/asset/asset = get_asset_datum(/datum/asset/simple/paper)
	info = "<center><img src = [asset.get_url_mappings()["wylogo.png"]]></center><BR>\n<span class=\"paper_field\"></span>"

/obj/item/paper/uscm
	icon_state = "paper_uscm"

/obj/item/paper/uscm/Initialize(mapload, photo_list)
	. = ..()

	var/datum/asset/asset = get_asset_datum(/datum/asset/simple/paper)
	info = "<center><img src = [asset.get_url_mappings()["uscmlogo.png"]]></center><BR>\n<span class=\"paper_field\"></span>"

/obj/item/paper/research_notes
	icon_state = "paper_wy_words"
	unacidable = TRUE
	var/datum/reagent/data
	var/tier
	var/note_type
	var/full_report
	var/grant

/obj/item/paper/research_notes/Initialize()
	. = ..()
	return INITIALIZE_HINT_LATELOAD

/obj/item/paper/research_notes/LateInitialize()
	. = ..()
	generate()

/obj/item/paper/research_notes/proc/generate()
	is_objective = TRUE
	if(!note_type)
		note_type = pick(prob(50);"synthesis",prob(35);"grant",prob(15);"test")
	var/datum/reagent/generated/C = data
	if(!C)
		var/random_chem
		if(tier)
			random_chem = pick(GLOB.chemical_gen_classes_list[tier])
		else
			if(note_type == "test")
				random_chem = pick(GLOB.chemical_gen_classes_list["T4"])
			else
				random_chem = pick( prob(55);pick(GLOB.chemical_gen_classes_list["T2"]),
									prob(30);pick(GLOB.chemical_gen_classes_list["T3"]),
									prob(15);pick(GLOB.chemical_gen_classes_list["T4"]))
		if(!random_chem)
			random_chem = pick(GLOB.chemical_gen_classes_list["T1"])
		C = GLOB.chemical_reagents_list["[random_chem]"]
	var/datum/asset/asset = get_asset_datum(/datum/asset/simple/paper)
	var/txt = "<center><img src = [asset.get_url_mappings()["wylogo.png"]]><HR><I><B>维兰德-汤谷官方文件</B><BR>实验笔记</I><HR><H2>"
	switch(note_type)
		if("synthesis")
			var/datum/chemical_reaction/G = GLOB.chemical_reactions_list[C.id]
			name = "[C.name]的合成"
			icon_state = "paper_wy_partial_report"
			txt += "[name] </H2></center>"
			txt += "在实验 <I>[pick("C","Q","V","W","X","Y","Z")][rand(100,999)][pick("a","b","c")]</I>中，成功按照以下配方合成了理论化合物[C.name]：<BR>\n<BR>\n"
			for(var/I in G.required_reagents)
				var/datum/reagent/R = GLOB.chemical_reagents_list["[I]"]
				var/U = G.required_reagents[I]
				txt += "<font size = \"2\"><I> - [U] [R.name]</I></font><BR>\n"
			if(LAZYLEN(G.required_catalysts))
				txt += "<BR>\n并使用以下催化剂： <BR>\n<BR>\n"
				for(var/I in G.required_catalysts)
					var/datum/reagent/R = GLOB.chemical_reagents_list["[I]"]
					var/U = G.required_catalysts[I]
					txt += "<font size = \"2\"><I> - [U] [R.name]</I></font><BR>\n"
			if(full_report)
				txt += "<BR>试验中发现以下性质：<BR><font size = \"2.5\">[C.description]\n"
				txt += "<BR>过量阈值：[C.overdose]单位</font><BR>\n"
				icon_state = "paper_wy_full_report"
			else
				txt += "<BR>\n化学性质有待进一步检测。<BR>\n"
			var/is_volatile = FALSE
			if(C.chemfiresupp)
				is_volatile = TRUE
			else
				for(var/datum/chem_property/P in C.properties)
					if(P.volatile)
						is_volatile = TRUE
						break
			if(is_volatile)
				txt += "<BR><B>\n警告：试剂不稳定，请谨慎混合。</B><BR>\n"
			txt += "<BR>\n<HR> - <I>维兰德-汤谷</I>"
		if("test")
			name = "实验 [pick("C","Q","V","W","X","Y","Z")][rand(100,999)][pick("a","b","c")]"
			icon_state = "paper_wy_synthesis"
			txt += "[name]记录</H2></center>"
			txt += "实验对象 <I>[rand(10000,99999)]</I>在[C.name]试验中出现了[pick(C.properties)]效果。 <BR>\n其他化学性质有待进一步检测。 <BR>\n"
			txt += "<BR>\n<HR> - <I>维兰德-汤谷</I>"
		if("grant")
			if(!grant)
				grant = rand(2,4)
			icon_state = "paper_wy_grant"
			name = "研究经费"
			txt += "维兰德-汤谷研究经费</H2></center>"
			txt += "尊敬的研究员：维兰德-汤谷十分关注您近期的科研进展。为进一步支持您的工作，特拨付[grant]点研究经费。请在当地维兰德-汤谷科研数据终端扫描本文件以领取。<BR>\n"
			txt += "<BR>\n<HR> - <I>维兰德-汤谷</I>"
	info = txt

/obj/item/paper/research_notes/bad
	note_type = "synthesis"
	tier = "T1"

/obj/item/paper/research_notes/decent
	note_type = "synthesis"
	tier = "T2"
	full_report = TRUE

/obj/item/paper/research_notes/good
	note_type = "synthesis"
	full_report = TRUE

/obj/item/paper/research_notes/good/Initialize()
	var/list/L = list("T3", "T4")
	tier = pick(L)
	. = ..()

/obj/item/paper/research_notes/unique
	note_type = "synthesis"
	full_report = TRUE
	var/gen_tier

/obj/item/paper/research_notes/unique/tier_one
	gen_tier = 1

/obj/item/paper/research_notes/unique/tier_two
	gen_tier = 2

/obj/item/paper/research_notes/unique/tier_three
	gen_tier = 3

/obj/item/paper/research_notes/unique/tier_four
	gen_tier = 4

/obj/item/paper/research_notes/unique/tier_five
	gen_tier = 5

/obj/item/paper/research_notes/unique/Initialize()
	//Each one of these get a new unique chem
	var/datum/reagent/generated/C = new /datum/reagent/generated
	C.id = "tau-[length(GLOB.chemical_gen_classes_list["tau"])]"
	C.generate_name()
	C.chemclass = CHEM_CLASS_RARE
	if(gen_tier)
		C.gen_tier = gen_tier
	else
		C.gen_tier = GLOB.chemical_data.clearance_level
	C.generate_stats()
	GLOB.chemical_gen_classes_list["tau"] += C.id //Because each unique_vended should be unique, we do not save the chemclass anywhere but in the tau list
	GLOB.chemical_reagents_list[C.id] = C
	C.generate_assoc_recipe()
	data = C
	msg_admin_niche("New reagent with id [C.id], name [C.name], level [C.gen_tier], generated and printed at [loc] [ADMIN_JMP(loc)].")
	. = ..()

/obj/item/paper/research_notes/grant
	note_type = "grant"

/obj/item/paper/research_notes/grant/high
	note_type = "grant"
	grant = 4

/obj/item/paper/research_report
	icon_state = "paper_wy_words"
	var/datum/reagent/data
	var/completed = FALSE

/obj/item/paper/research_report/proc/generate(datum/reagent/S, info_only = FALSE)
	if(!S)
		return
	info += "<B>标识：</B> <I>[S.name]</I><BR><BR>\n"
	info += "<B>数据库详情：</B><BR>\n"
	if(S.chemclass >= CHEM_CLASS_ULTRA)
		if(GLOB.chemical_data.clearance_level >= S.gen_tier || info_only)
			info += "<I>以下有关[S.name]的信息列为[S.gen_tier]级权限机密。</I><BR>"
			info += "<font size = \"2.5\">[S.description]\n"
			info += "<BR>过量阈值：[S.overdose]单位\n"
			info += "<BR>标准持续时间倍率：[REAGENTS_METABOLISM/S.custom_metabolism]倍</font><BR>\n"
			completed = TRUE
			icon_state = "paper_wy_full_report"
		else
			info += "机密：<I>阅读此数据库条目需要[S.gen_tier]级权限。</I><BR>\n"
			icon_state = "paper_wy_partial_report"
	else if(S.chemclass == CHEM_CLASS_SPECIAL && !GLOB.chemical_data.clearance_x_access && !info_only)
		info += "机密：<I>阅读此数据库条目需要<B>X</B>级权限。</I><BR>\n"
		icon_state = "paper_wy_partial_report"
	else if(S.description)
		info += "<font size = \"2.5\">[S.description]\n"
		info += "<BR>过量阈值：[S.overdose]单位\n"
		info += "<BR>标准持续时间倍率：[REAGENTS_METABOLISM/S.custom_metabolism]倍</font><BR>\n"
		completed = TRUE
		icon_state = "paper_wy_full_report"
	else
		info += "<I>数据库中没有此试剂的详细资料。</I><BR>\n"
		icon_state = "paper_wy_synthesis"
	if(S.chemclass >= CHEM_CLASS_SPECIAL && !GLOB.chemical_data.chemical_identified_list[S.id] && !info_only)
		info += "<BR><I>已将[S.name]的发射光谱存入数据库。</I><BR>\n"
	info += "<BR><B>成分详情：</B><BR>\n"
	if(GLOB.chemical_reactions_list[S.id])
		var/datum/chemical_reaction/C = GLOB.chemical_reactions_list[S.id]
		for(var/I in C.required_reagents)
			var/datum/reagent/R = GLOB.chemical_reagents_list["[I]"]
			if(R.chemclass >= CHEM_CLASS_SPECIAL && !GLOB.chemical_data.chemical_identified_list[R.id] && !info_only)
				info += "<font size = \"2\"><I> - 未知发射光谱</I></font><BR>\n"
				completed = FALSE
			else
				var/U = C.required_reagents[I]
				info += "<font size = \"2\"><I> - [U] [R.name]</I></font><BR>\n"
		if(LAZYLEN(C.required_catalysts))
			info += "<BR>反应需要以下催化剂：<BR>\n"
			for(var/I in C.required_catalysts)
				var/datum/reagent/R = GLOB.chemical_reagents_list["[I]"]
				if(R.chemclass >= CHEM_CLASS_SPECIAL && !GLOB.chemical_data.chemical_identified_list[R.id] && !info_only)
					info += "<font size = \"2\"><I> - 未知发射光谱</I></font><BR>\n"
					completed = FALSE
				else
					var/U = C.required_catalysts[I]
					info += "<font size = \"2\"><I> - [U] [R.name]</I></font><BR>\n"
	else if(GLOB.chemical_gen_classes_list["C1"].Find(S.id))
		info += "<font size = \"2\"><I> - [S.name]</I></font><BR>\n"
	else
		info += "<I>错误：无法分析样本的发射光谱。</I>" //A reaction to make this doesn't exist, so this is our IC excuse
		completed = FALSE

	if(info_only)
		completed = TRUE
	else
		if(!S.properties) //Safety for empty reagents
			completed = FALSE
		if(S.chemclass == CHEM_CLASS_SPECIAL && GLOB.chemical_data.clearance_x_access)
			completed = TRUE

	data = S

/obj/item/paper/incident
	name = "事件报告"
	var/datum/crime_incident/incident

/obj/item/paper/incident/Initialize()
	. = ..()
	var/template = {"\[center\]\[logo\]\[/center\]
		\[center\]\[b\]\[i\]美国殖民地陆战队编码事件报告\[/b\]\[/i\]\[hr\]
		\[small\]仅限宪兵使用\[/small\]\[br\]
		\[barcode\]\[/center\]"}
	info = parsepencode(template, null, null, FALSE)
	update_icon()

/obj/item/paper/incident/Destroy()
	incident = null

	. = ..()


/obj/item/paper/fingerprint
	name = "指纹报告"

/obj/item/paper/fingerprint/Initialize(mapload, list/prints)
	. = ..()
	var/template = {"\[center\]\[logo\]\[/center\]"}

	var/i = 0
	for(var/obj/effect/decal/prints/print_set in prints)
		i++
		template += {"\[center\]\[b\]\[i\]指纹样本编号 [i]\[/b\]\[/i\]\[hr\]
		\[small\]
		姓名： [print_set.criminal_name]\[br\]
		军衔： [print_set.criminal_rank]\[br\]
		小队： [print_set.criminal_squad]\[br\]
		描述： [print_set.description]\[br\]
		\[/small\]
		\[/center\]
		\[br\]"}

	info = parsepencode(template, null, null, FALSE)
#undef MAX_FIELDS

/obj/item/paper/colonial_grunts
	icon = 'icons/obj/items/paper.dmi'
	icon_state = "paper_stack_words"
	name = "殖民地太空大兵"
	desc = "以 USCM 为主题的桌面游戏，容易上手、玩法简单，最重要的是全小队都能玩得开心。"

/obj/item/paper/colonial_grunts/Initialize(mapload, ...)
	. = ..()
	info = "<div> <img style='align:middle' src='[SSassets.transport.get_asset_url("colonialspacegruntsEZ.png")]'>"
	update_icon()
