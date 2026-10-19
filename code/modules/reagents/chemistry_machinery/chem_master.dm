/obj/structure/machinery/chem_master
	name = "制药大师 3000"
	density = TRUE
	anchored = TRUE
	icon = 'icons/obj/structures/machinery/science_machines.dmi'
	icon_state = "mixer0"
	var/base_state = "mixer"
	use_power = USE_POWER_IDLE
	idle_power_usage = 20
	layer = BELOW_OBJ_LAYER //So bottles/pills reliably appear above it
	var/req_skill = SKILL_MEDICAL
	var/req_skill_level = SKILL_MEDICAL_MEDIC
	var/pill_maker = TRUE
	var/vial_maker = FALSE
	var/obj/item/reagent_container/beaker = null
	var/obj/item/storage/pill_bottle/loaded_pill_bottle = null
	var/mode = 0
	var/condi = 0
	var/useramount = 30 // Last used amount
	var/pillamount = 16
	var/bottlesprite = "1" //yes, strings
	var/pillsprite = "1"
	var/client/has_sprites = list()
	var/max_pill_count = 20
	var/tether_range = 3
	var/obj/structure/machinery/smartfridge/chemistry/connected

/obj/structure/machinery/chem_master/Initialize()
	. = ..()
	create_reagents(300)
	connect_smartfridge()

/obj/structure/machinery/chem_master/Destroy()
	cleanup()
	. = ..()

/obj/structure/machinery/chem_master/proc/connect_smartfridge()
	if(connected)
		return
	connected = locate(/obj/structure/machinery/smartfridge/chemistry) in range(tether_range, src)
	if(connected)
		RegisterSignal(connected, COMSIG_PARENT_QDELETING, PROC_REF(cleanup))
		visible_message(SPAN_NOTICE("<b>[src]鸣响提示：</b>已连接智能冰箱。"))

/obj/structure/machinery/chem_master/ex_act(severity)
	switch(severity)
		if(EXPLOSION_THRESHOLD_LOW to EXPLOSION_THRESHOLD_MEDIUM)
			if (prob(50))
				deconstruct(FALSE)
				return
		if(EXPLOSION_THRESHOLD_MEDIUM to INFINITY)
			deconstruct(FALSE)
			return

/obj/structure/machinery/chem_master/update_icon()
	if(stat & BROKEN)
		icon_state = (beaker?"mixer1_b":"mixer0_b")
	else if(stat & NOPOWER)
		icon_state = (beaker?"[base_state]1_nopower":"[base_state]0_nopower")
	else
		icon_state = (beaker?"[base_state]1":"[base_state]0")


/obj/structure/machinery/chem_master/attackby(obj/item/B, mob/living/user)
	if(istype(B, /obj/item/reagent_container/glass))
		var/obj/item/old_beaker = beaker
		beaker = B
		user.drop_inv_item_to_loc(B, src)
		if(old_beaker)
			to_chat(user, SPAN_NOTICE("你取出[old_beaker]，换上[B]。"))
			user.put_in_hands(old_beaker)
		else
			to_chat(user, SPAN_NOTICE("你将烧杯装入机器！"))
		updateUsrDialog()
		update_icon()

	else if(istype(B, /obj/item/storage/pill_bottle) && pill_maker)
		if(loaded_pill_bottle)
			to_chat(user, SPAN_WARNING("机器中已经装有药瓶。"))
			return

		loaded_pill_bottle = B
		user.drop_inv_item_to_loc(B, src)
		to_chat(user, SPAN_NOTICE("你将药瓶装入出药槽！"))
		updateUsrDialog()
	return

/obj/structure/machinery/chem_master/proc/transfer_chemicals(obj/dest, obj/source, amount, reagent_id)
	if(istype(source))
		if(amount > 0 && source.reagents && amount <= source.reagents.maximum_volume)
			if(!istype(dest))
				source.reagents.remove_reagent(reagent_id, amount)
			else if(dest.reagents)
				source.reagents.trans_id_to(dest, reagent_id, amount)

/obj/structure/machinery/chem_master/Topic(href, href_list)
	. = ..()
	if(.)
		return
	if(inoperable())
		return
	if(!ishuman(usr))
		return
	var/mob/living/carbon/human/user = usr
	if(user.stat || user.is_mob_restrained())
		return
	if(!in_range(src, user))
		return

	add_fingerprint(user)
	user.set_interaction(src)


	if(href_list["ejectp"])
		if(!loaded_pill_bottle)
			return

		if(!Adjacent(usr) || !usr.put_in_hands(loaded_pill_bottle))
			loaded_pill_bottle.forceMove(loc)

		loaded_pill_bottle = null

	// Adding a name to the currently stored pill bottle
	if(href_list["addlabelp"])

		// Checking for state changes
		if(!loaded_pill_bottle)
			return

		if(!Adjacent(usr))
			return

		var/label = copytext(reject_bad_text(input(user,"标签写什么？", "设置标签", "")), 1, MAX_NAME_LEN)
		if(label)
			loaded_pill_bottle.AddComponent(/datum/component/label, label)
			if(length(label) < 3)
				loaded_pill_bottle.maptext_label = label
				loaded_pill_bottle.update_icon()
	else if(href_list["setcolor"])
		// Checking for state changes
		if(!loaded_pill_bottle)
			return

		if(!Adjacent(usr))
			return

		loaded_pill_bottle.choose_color()

	else if(href_list["close"])
		close_browser(user, "chemmaster")
		user.unset_interaction()
		return

	if(beaker)
		if(href_list["add"])
			if(href_list["amount"])
				var/id = href_list["add"]
				var/amount = text2num(href_list["amount"])
				transfer_chemicals(src, beaker, amount, id)

		else if(href_list["addcustom"])
			var/id = href_list["addcustom"]
			useramount = tgui_input_number(usr, "选择转移量。", "转移量", useramount)
			transfer_chemicals(src, beaker, useramount, id)

		else if(href_list["addall"])
			for(var/datum/reagent/R in beaker.reagents.reagent_list)
				var/amount = beaker.volume
				transfer_chemicals(src, beaker, amount, R.id)

		else if(href_list["remove"])
			if(href_list["amount"])
				var/id = href_list["remove"]
				var/amount = text2num(href_list["amount"])
				if(mode)
					transfer_chemicals(beaker, src, amount, id)
				else
					transfer_chemicals(null, src, amount, id)


		else if(href_list["removecustom"])
			var/id = href_list["removecustom"]
			useramount = tgui_input_number(usr, "选择转移量。", "转移量", useramount)
			if(mode)
				transfer_chemicals(beaker, src, useramount, id)
			else
				transfer_chemicals(null, src, useramount, id)

		else if(href_list["removeall"])
			for(var/datum/reagent/R in src.reagents.reagent_list)
				var/amount = src.reagents.total_volume
				if(mode)
					transfer_chemicals(beaker, src, amount, R.id)
				else
					transfer_chemicals(null, src, amount, R.id)

		else if(href_list["toggle"])
			mode = !mode

		else if(href_list["main"])
			attack_hand(user)
			return
		else if(href_list["eject"])
			if(!beaker)
				return

			if(!Adjacent(usr) || !usr.put_in_hands(beaker))
				beaker.forceMove(loc)

			beaker = null
			reagents.clear_reagents()
			update_icon()

		else if (href_list["createpill"] || href_list["createpill_multiple"])
			var/count = 1

			if(reagents.total_volume/count < 1) //Sanity checking.
				return

			if(href_list["createpill_multiple"])
				count = clamp(tgui_input_number(user, "选择制作药片的数量。（最多：[max_pill_count]）", "制药数量", pillamount, max_pill_count, 1), 0, max_pill_count)
				if(!count)
					return

			if(reagents.total_volume/count < 1) //Sanity checking.
				return

			for(var/datum/reagent/R in reagents.reagent_list)
				if(R.flags & REAGENT_NOT_INGESTIBLE)
					to_chat(user, SPAN_WARNING("[R.localized_name || R.name]必须静脉给药，不能制成药片。"))
					return

			var/amount_per_pill = reagents.total_volume/count
			if(amount_per_pill > 60) amount_per_pill = 60

			if(reagents.total_volume/count < 1) //Sanity checking.
				return
			var/was_logged = FALSE

			while (count--)
				var/obj/item/reagent_container/pill/P = new/obj/item/reagent_container/pill(loc)
				P.pill_desc = "一片定制药片。"
				P.icon_state = "pill"+pillsprite
				reagents.trans_to(P,amount_per_pill)
				if(loaded_pill_bottle)
					if(length(loaded_pill_bottle.contents) < loaded_pill_bottle.max_storage_space)
						loaded_pill_bottle.handle_item_insertion(P, TRUE)
						updateUsrDialog()

				if(!was_logged)
					var/list/reagents_in_pill = list()
					for(var/datum/reagent/R in P.reagents.reagent_list)
						reagents_in_pill += R.name
					var/contained = english_list(reagents_in_pill)
					msg_admin_niche("[key_name(usr)] created one or more pills (total pills to synthesize: [count+1]) (REAGENTS: [contained]) in [get_area(user)] ([user.loc.x],[user.loc.y],[user.loc.z]).", user.loc.x, user.loc.y, user.loc.z)
					was_logged = TRUE

		else if(href_list["createglass"])
			if(!condi)
				var/name = reject_bad_text(input(user,"标签：","输入标签", reagents.get_master_reagent_display_name()) as text|null)
				if(!name)
					return

				var/obj/item/reagent_container/glass/P
				if(href_list["createbottle"])
					P = new/obj/item/reagent_container/glass/bottle()
					P.name = "[name]试剂瓶"
					P.icon_state = "bottle-"+bottlesprite
					reagents.trans_to(P, 60)
				else if(href_list["createvial"])
					P = new/obj/item/reagent_container/glass/beaker/vial()
					P.name = "[name]试管"
					reagents.trans_to(P, 30)

				P.update_icon()

				if(href_list["store"])
					connected.add_local_item(P)
				else if(!Adjacent(usr) || !usr.put_in_hands(P))
					P.forceMove(loc)

			else
				var/obj/item/reagent_container/food/condiment/P = new/obj/item/reagent_container/food/condiment()
				reagents.trans_to(P, 50)

				if(!Adjacent(usr) || !usr.put_in_hands(P))
					P.forceMove(loc)
		else if(href_list["change_pill"])
			var/dat = "<table>"
			for(var/i = 1 to PILL_ICON_CHOICES)
				dat += "<tr><td><a href=\"byond://?src=\ref[src]&pill_sprite=[i]\"><img src=\"pill[i].png\" /></a></td></tr>"
			dat += "</table>"
			show_browser(user, dat, "选择药片外观", "chem_master")
			return
		else if(href_list["change_bottle"])
			var/dat = "<table>"
			for(var/i = 1 to BOTTLE_ICON_CHOICES)
				dat += "<tr><td><a href=\"byond://?src=\ref[src]&bottle_sprite=[i]\"><img src=\"bottle-[i].png\" /></a></td></tr>"
			dat += "</table>"
			show_browser(user, dat, "选择试剂瓶外观", "chem_master")
			return
		else if(href_list["pill_sprite"])
			pillsprite = href_list["pill_sprite"]
		else if(href_list["bottle_sprite"])
			bottlesprite = href_list["bottle_sprite"]

	if(href_list["transferp"])
		if(!loaded_pill_bottle)
			return

		if(QDELETED(connected))
			to_chat(user, SPAN_WARNING("请先连接智能冰箱。"))
			return

		if(src.z != connected.z || get_dist(src, connected) > tether_range)
			to_chat(user, SPAN_WARNING("智能冰箱超出范围，连接已断开。"))
			cleanup()
			attack_hand(user)
			return

		connected.add_local_item(loaded_pill_bottle)
		loaded_pill_bottle = null

	// Connecting a smartfridge
	if(href_list["connect"])
		connect_smartfridge()

	//src.updateUsrDialog()
	attack_hand(user)

/obj/structure/machinery/chem_master/attack_hand(mob/living/user)
	if(stat & BROKEN)
		return
	if(req_skill && !skillcheck(user, req_skill, req_skill_level))
		to_chat(user, SPAN_WARNING("你没有接受过使用这台设备的训练。"))
		return
	user.set_interaction(src)
	if(!(user.client in has_sprites))
		spawn()
			has_sprites += user.client
			for(var/i = 1 to PILL_ICON_CHOICES)
				user << browse_rsc(icon('icons/obj/items/chemistry.dmi', "pill" + num2text(i)), "pill[i].png")
			for(var/i = 1 to BOTTLE_ICON_CHOICES)
				user << browse_rsc(icon('icons/obj/items/chemistry.dmi', "bottle-" + num2text(i)), "bottle-[i].png")
	var/dat = ""
	if(!beaker)
		dat = "请放入烧杯。<BR>"
		if(pill_maker)
			if(loaded_pill_bottle)
				dat += "<A href='byond://?src=\ref[src];ejectp=1;user=\ref[user]'>取出药瓶 \[[length(loaded_pill_bottle.contents)]/[loaded_pill_bottle.max_storage_space]\]</A><BR><BR>"
			else
				dat += "未装入药瓶。<BR><BR>"
		dat += "<A href='byond://?src=\ref[src];close=1'>关闭</A>"
	else
		dat += "<A href='byond://?src=\ref[src];eject=1;user=\ref[user]'>取出烧杯并清空暂存槽</A><BR><BR>"
		if(pill_maker)
			if(loaded_pill_bottle)
				dat += "<A href='byond://?src=\ref[src];ejectp=1;user=\ref[user]'>取出[loaded_pill_bottle] \[[length(loaded_pill_bottle.contents)]/[loaded_pill_bottle.max_storage_space]\]</A><BR>"
				dat += "<A href='byond://?src=\ref[src];addlabelp=1;user=\ref[user]'>给[loaded_pill_bottle]添加标签 \[[length(loaded_pill_bottle.contents)]/[loaded_pill_bottle.max_storage_space]\]</A><BR>"
				dat += "<A href='byond://?src=\ref[src];setcolor=1;user=\ref[user]'>设置[loaded_pill_bottle]的颜色 \[[length(loaded_pill_bottle.contents)]/[loaded_pill_bottle.max_storage_space]\]</A><BR><BR>"
				dat += "<A href='byond://?src=\ref[src];transferp=1;'>将[loaded_pill_bottle] \[[length(loaded_pill_bottle.contents)]/[loaded_pill_bottle.max_storage_space]\] 转存至智能冰箱</A><BR><BR>"
			else
				dat += "未装入药瓶。<BR><BR>"
		if(!connected && pill_maker)
			dat += "<A href='byond://?src=\ref[src];connect=1'>连接智能冰箱</A><BR><BR>"
		if(!beaker.reagents.total_volume)
			dat += "烧杯是空的。"
		else
			dat += "加入暂存槽：<BR>"
			for(var/datum/reagent/G in beaker.reagents.reagent_list)
				dat += "[G.localized_name || G.name]，[G.volume] 单位 - "
				dat += "<A href='byond://?src=\ref[src];add=[G.id];amount=1'>1</A> "
				dat += "<A href='byond://?src=\ref[src];add=[G.id];amount=5'>5</A> "
				dat += "<A href='byond://?src=\ref[src];add=[G.id];amount=10'>10</A> "
				dat += "<A href='byond://?src=\ref[src];add=[G.id];amount=30'>30</A> "
				dat += "<A href='byond://?src=\ref[src];add=[G.id];amount=60'>60</A> "
				dat += "<A href='byond://?src=\ref[src];add=[G.id];amount=[G.volume]'>全部</A> "
				dat += "<A href='byond://?src=\ref[src];addcustom=[G.id]'>自定义</A><BR>"
			dat += "<A href='byond://?src=\ref[src];addall=[beaker]'>全部试剂</A><BR>"

		dat += "<HR>转移至 <A href='byond://?src=\ref[src];toggle=1'>[(!mode ? "废弃" : "烧杯")]：</A><BR>"
		if(reagents.total_volume)
			for(var/datum/reagent/N in reagents.reagent_list)
				dat += "[N.localized_name || N.name]，[N.volume] 单位 - "
				dat += "<A href='byond://?src=\ref[src];remove=[N.id];amount=1'>1</A> "
				dat += "<A href='byond://?src=\ref[src];remove=[N.id];amount=5'>5</A> "
				dat += "<A href='byond://?src=\ref[src];remove=[N.id];amount=10'>10</A> "
				dat += "<A href='byond://?src=\ref[src];remove=[N.id];amount=30'>30</A> "
				dat += "<A href='byond://?src=\ref[src];remove=[N.id];amount=60'>60</A> "
				dat += "<A href='byond://?src=\ref[src];remove=[N.id];amount=[N.volume]'>全部</A> "
				dat += "<A href='byond://?src=\ref[src];removecustom=[N.id]'>自定义</A><BR>"
			dat += "<A href='byond://?src=\ref[src];removeall=[src]'>全部试剂</A><BR>"
		else
			dat += "空<BR>"
		if(!condi)
			if(pill_maker)
				dat += "<HR><BR><A href='byond://?src=\ref[src];createpill=1'>制作药片（最多 60 单位）</A><a href=\"byond://?src=\ref[src]&change_pill=1\"><img src=\"pill[pillsprite].png\" /></a><BR>"
				dat += "<A href='byond://?src=\ref[src];createpill_multiple=1'>批量制作药片</A><BR>"
			dat += "<A href='byond://?src=\ref[src];createglass=1;createbottle=1;user=\ref[user]'>装瓶（最多 60 单位）<a href=\"byond://?src=\ref[src]&change_bottle=1\"><img src=\"bottle-[bottlesprite].png\" /></A>"
			if(connected)
				dat += "<BR><A href='byond://?src=\ref[src];createglass=1;createbottle=1;store=1;user=\ref[user]'>装瓶并存入智能冰箱（最多 60 单位）</A>"
			if(vial_maker)
				dat += "<BR><BR><A href='byond://?src=\ref[src];createglass=1;createvial=1;user=\ref[user]'>装试管（最多 30 单位）</A>"
				if(connected)
					dat += "<BR><A href='byond://?src=\ref[src];createglass=1;createvial=1;store=1;user=\ref[user]'>装试管并存入智能冰箱（最多 30 单位）</A>"
		else
			dat += "<A href='byond://?src=\ref[src];createglass=1;user=\ref[user]'>装瓶（最多 50 单位）</A>"
	if(!condi)
		show_browser(user, "[name]菜单：<BR><BR>[dat]", name, "chem_master", width = 460, height = 520)
	else
		show_browser(user, "调味大师菜单：<BR><BR>[dat]", name, "chem_master")
	return

/obj/structure/machinery/chem_master/proc/cleanup()
	SIGNAL_HANDLER
	if(connected)
		connected = null

/obj/structure/machinery/chem_master/condimaster
	name = "调味大师 3000"
	req_skill = null
	req_skill_level = null
	condi = 1

/obj/structure/machinery/chem_master/industry_mixer
	name = "工业化学混合机"
	icon_state = "industry_mixer0"
	base_state = "industry_mixer"
	req_skill = SKILL_ENGINEER
	req_skill_level = SKILL_ENGINEER_TRAINED
	pill_maker = FALSE
	vial_maker = TRUE
	max_pill_count = 0
