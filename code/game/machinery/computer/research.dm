/obj/structure/machinery/computer/research
	name = "科研数据终端"
	desc = "用于访问科研数据的终端。"
	icon_state = "research"
	req_access = list(ACCESS_MARINE_RESEARCH)
	var/base_purchase_cost = 5
	var/max_clearance = 1 // max clearance level reached by research
	var/main_terminal = FALSE
	var/obj/structure/machinery/photocopier/photocopier

/obj/structure/machinery/computer/research/main_terminal
	name = "科研主终端"
	main_terminal = TRUE
	req_access = list(ACCESS_MARINE_CMO)

/obj/structure/machinery/computer/research/Initialize()
	. = ..()
	photocopier = locate(/obj/structure/machinery/photocopier,get_step(src, NORTH))

/obj/structure/machinery/computer/research/Destroy()
	QDEL_NULL(photocopier)
	. = ..()

/obj/structure/machinery/computer/research/attackby(obj/item/B, mob/living/user)
	//Collecting grants
	if(istype(B, /obj/item/paper/research_notes))
		var/obj/item/paper/research_notes/N = B
		if(N.note_type == "grant")
			if(!N.grant)
				return
			GLOB.chemical_data.update_credits(N.grant)
			visible_message(SPAN_NOTICE("[user]在[src]上扫描[N.name]，获得了[N.grant]科研点数。"))
			N.grant = 0
			qdel(N)
			return
	//Saving to database
	if(istype(B, /obj/item/paper))
		var/obj/item/paper/P = B
		var/response = alert(usr,"要将[P.name]保存到科研数据库吗？","[src]","是","否")
		if(response != "是")
			return
		response = alert(usr,"使用现有分类还是创建新分类？","[src]","现有分类","新分类")
		if(response == "现有分类")
			var/list/pool = list()
			for(var/category in GLOB.chemical_data.research_documents)
				pool += category
			pool = sortAssoc(pool)
			response = tgui_input_list(usr,"选择一个分类：", "分类", pool)
		else if(response == "新分类")
			response = input(usr,"请输入文档分类：")
		if(!response)
			response = "Misc."
		var/obj/item/paper/research_report/CR = P.convert_to_chem_report()
		GLOB.chemical_data.save_document(CR, response, CR.name)
		return
	//biomass credits rewards
	if(istype(B, /obj/item/research_upgrades/credits))
		var/obj/item/research_upgrades/credits/cred = B
		GLOB.chemical_data.update_credits(cred.credit_value)
		visible_message(SPAN_NOTICE("[user]将[cred]插入[src]，收取了[cred.credit_value]点销售所得。"))
		qdel(cred)
	//Clearance Card Updating
	if(!istype(B, /obj/item/card/id))
		return
	var/obj/item/card/id/silver/clearance_badge/card = B
	if(!istype(card))
		visible_message(SPAN_NOTICE("[user]在[src]上刷过身份卡，却遭到拒绝。"))
		return
	if(!card.check_biometrics(user))
		visible_message(SPAN_WARNING("警告：检测到权限异常用户，正在中止。"))
		return

	var/credits_to_add = max(card.credits_to_give - GLOB.chemical_data.credits_gained, 0)
	if(credits_to_add)
		GLOB.chemical_data.update_credits(credits_to_add)
		GLOB.chemical_data.credits_gained += credits_to_add

	visible_message(SPAN_NOTICE("[user]在[src]上刷过身份卡，获得了[credits_to_add]点数。"))
	msg_admin_niche("[key_name(user)] has swiped a clearance card to give [credits_to_add] credits to research.")
	return

/obj/structure/machinery/computer/research/ui_state(mob/user)
	return GLOB.not_incapacitated_and_adjacent_strict_state

/obj/structure/machinery/computer/research/attack_hand(mob/user as mob)
	if(inoperable())
		return
	tgui_interact(user)

/obj/structure/machinery/computer/research/ui_static_data(mob/user)
	var/list/data = list(
		"base_purchase_cost" = base_purchase_cost,
		"main_terminal" = main_terminal,
		"terminal_view" = TRUE,
	)
	return data

/obj/structure/machinery/computer/research/ui_data(mob/user)
	var/list/data = list(
		"rsc_credits" = GLOB.chemical_data.rsc_credits,
		"clearance_level" = GLOB.chemical_data.clearance_level,
		"broker_cost" = max(RESEARCH_LEVEL_INCREASE_MULTIPLIER*(GLOB.chemical_data.clearance_level + 1), 1),
		"research_documents" = GLOB.chemical_data.research_documents,
		"published_documents" = GLOB.chemical_data.research_publications,
		"clearance_x_access" = GLOB.chemical_data.clearance_x_access,
		"photocopier_error" = !photocopier,
		"printer_toner" = photocopier?.toner
	)
	return data

/obj/structure/machinery/computer/research/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if (!ui)
		ui = new(user, src, "ResearchTerminal", name)
		ui.open()

/obj/structure/machinery/computer/research/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
	if(inoperable() || !ishuman(usr))
		return
	var/mob/living/carbon/human/user = usr
	if(user.stat || user.is_mob_restrained() || !in_range(src, user))
		return
	switch(action)
		if ("read_document")
			var/print_type = params["print_type"]
			var/print_title = params["print_title"]
			var/obj/item/paper/research_report/report = GLOB.chemical_data.get_report(print_type, print_title)
			if(report)
				report.read_paper(user)
			return
		if ("print")
			if(!photocopier)
				return
			if(photocopier.toner)
				var/print_type = params["print_type"]
				var/print_title = params["print_title"]
				photocopier.toner = max(0, photocopier.toner - 1)
				var/obj/item/paper/research_report/printing = new /obj/item/paper/research_report/(photocopier.loc)
				var/obj/item/paper/research_report/report = GLOB.chemical_data.get_report(print_type, print_title)
				if(report)
					printing.name = report.name
					printing.info = report.info
					printing.data = report.data
					printing.completed = report.completed
		if("broker_clearance")
			if(!photocopier)
				return
			if(GLOB.chemical_data.clearance_level < 5)
				var/cost = max(RESEARCH_LEVEL_INCREASE_MULTIPLIER*(GLOB.chemical_data.clearance_level + 1), 1)
				if(cost <= GLOB.chemical_data.rsc_credits)
					GLOB.chemical_data.update_credits(cost * -1)
					GLOB.chemical_data.clearance_level++
					visible_message(SPAN_NOTICE("花费[cost]点数，将访问权限提升至[GLOB.chemical_data.clearance_level]级。"))
					msg_admin_niche("[key_name(user)] traded research credits to upgrade the clearance to level [GLOB.chemical_data.clearance_level].")
					if(max_clearance < GLOB.chemical_data.clearance_level)
						switch(GLOB.chemical_data.clearance_level)
							if(2)
								new /obj/item/paper/research_notes/unique/tier_two/(photocopier.loc)
								max_clearance = 2
							if(3)
								new /obj/item/paper/research_notes/unique/tier_three/(photocopier.loc)
								max_clearance = 3
							if(4)
								new /obj/item/paper/research_notes/unique/tier_four/(photocopier.loc)
								max_clearance = 4
							if(5)
								new /obj/item/paper/research_notes/unique/tier_five/(photocopier.loc)
								max_clearance = 5
		if("publish_document")
			var/print_type = params["print_type"]
			var/print_title = params["print_title"]
			var/obj/item/paper/research_report/report = GLOB.chemical_data.get_report(print_type, print_title)
			if(!report)
				to_chat(usr, SPAN_WARNING("报告数据损坏，无法传输。"))
				return
			GLOB.chemical_data.publish_document(report, print_type, print_title)
		if("unpublish_document")
			var/print_title = params["print_title"]
			var/print_type = params["print_type"]
			GLOB.chemical_data.unpublish_document(print_type, print_title)
		if("request_clearance_x_access")
			var/purchase_cost = 5
			if(purchase_cost <= GLOB.chemical_data.rsc_credits)
				GLOB.chemical_data.clearance_x_access = TRUE
				GLOB.chemical_data.reached_x_access = TRUE
				GLOB.chemical_data.update_credits(purchase_cost * -1)
				visible_message(SPAN_NOTICE("已取得X级权限。"))
	playsound(loc, pick('sound/machines/computer_typing1.ogg','sound/machines/computer_typing2.ogg','sound/machines/computer_typing3.ogg'), 5, 1)
