#define PERMABRIG_SENTENCE 60 // Measured in minutes

/obj/structure/machinery/computer/sentencing
	name = "司法自动化系统"
	desc = "维兰德-汤谷生产的强大设备，用于简化囚犯处罚流程。这片银河最顶尖的执法装备。"
	icon_state = "jas"
	req_one_access = list(ACCESS_MARINE_BRIG, ACCESS_MARINE_COMMAND)
	var/datum/crime_incident/incident
	var/current_menu = "main"
	var/static/paper_counter = 0

/obj/structure/machinery/computer/sentencing/attack_hand(mob/user as mob)
	if(..() || !allowed(usr) || inoperable())
		return

	tgui_interact(user)

/obj/structure/machinery/computer/sentencing/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if (!ui)
		ui = new(user, src, "Sentencing", "刑事量刑")
		ui.open()
		ui.set_autoupdate(FALSE)

/obj/structure/machinery/computer/sentencing/ui_data(mob/user)
	var/list/data = list()

	data["current_menu"] = current_menu

	if (incident)
		data["suspect_name"] = incident.criminal_name
		data["summary"] = html_decode(incident.notes)

		// Sentence.
		if(incident.brig_sentence < PERMABRIG_SENTENCE)
			data["sentence"] = "[incident.brig_sentence] minutes"
		else
			data["sentence"] = "PERMA BRIGGED"

		// Current charges.
		var/list/current_charges = list()
		for(var/datum/law/L as anything in incident.charges)
			var/list/current_charge = list()
			current_charge["name"] = L.name
			current_charge["desc"] = L.desc
			current_charge["special_punishment"] = L.special_punishment
			current_charge["ref"] = "\ref[L]"
			current_charges += list(current_charge)
		data["current_charges"] = current_charges

		// Witnesses.
		var/list/witnesses = list()
		for(var/W as anything in incident.witnesses)
			var/list/witness = list()
			witness["name"] = W
			witness["notes"] = html_decode(incident.witnesses[W])
			witness["ref"] = "\ref[W]"
			witnesses += list(witness)
		data["witnesses"] = witnesses

		// Evidence.
		var/list/evidence = list()
		for(var/E as anything in incident.evidence)
			var/list/object = list()
			object["name"] = E
			object["notes"] = html_decode(incident.evidence[E])
			object["ref"] = "\ref[E]"
			evidence += list(object)
		data["evidence"] = evidence

	return data

/obj/structure/machinery/computer/sentencing/ui_static_data()
	var/list/data = list()

	data["laws"] = list()
	data["laws"] += list(create_law_data("轻罪", SSlaw_init.minor_law))
	data["laws"] += list(create_law_data("重罪", SSlaw_init.major_law))
	data["laws"] += list(create_law_data("死罪", SSlaw_init.capital_law))
	data["laws"] += list(create_law_data("附加罪名", SSlaw_init.optional_law))
	data["laws"] += list(create_law_data("预防性拘押", SSlaw_init.precautionary_law))

	return data

/obj/structure/machinery/computer/sentencing/proc/create_law_data(label, list/laws)
	var/list/data = list()

	var/list/formatted_laws = list()
	for(var/datum/law/L as anything in laws)
		var/law = list()
		law["name"] = L.name
		law["desc"] = L.desc
		law["brig_time"] = L.brig_time
		law["special_punishment"] = L.special_punishment
		law["ref"] = "\ref[L]"
		formatted_laws += list(law)

	data["label"] = label
	data["laws"] = formatted_laws

	return data

/obj/structure/machinery/computer/sentencing/ui_act(action, params)
	. = ..()
	if(.)
		return

	playsound(src, "keyboard", 15, 1)

	switch (action)
		if ("set_menu")
			current_menu = params["new_menu"]

		if ("scrap_report")
			qdel(incident)
			incident = null
			current_menu = "main"

		if ("new_report")
			incident = new()
			current_menu = "incident_report"

		if ("new_charge")
			var/datum/law/L = locate(params["law"])
			incident.charges += L
			incident.refresh_sentences()
			current_menu = "incident_report"

		if ("remove_charge")
			var/datum/law/L = locate(params["charge"])
			incident.charges -= L
			incident.refresh_sentences()

		if ("set_suspect")
			var/obj/item/card/id/id = usr.get_active_hand()
			if (istype(id))
				if (incident && id.registered_name)
					incident.criminal_name = id.registered_name
					incident.criminal_gid = add_zero(num2hex(id.registered_gid), 6)
					ping("[src]鸣响：“已核实嫌疑人[id.registered_name]。”")
			else
				to_chat(usr, SPAN_INFO("你需要手持嫌疑人的身份卡，或抓住对方后使用终端。"))

		if ("edit_summary")
			var/notes = tgui_input_text(usr, "描述事件经过", "事件报告", html_decode(incident.notes), multiline = TRUE)
			if(!isnull(notes) && incident)
				incident.notes = notes

		if ("add_witness")
			var/obj/item/card/id/id = usr.get_active_hand()
			if (istype(id))
				if (incident && id.registered_name)
					incident.witnesses += list(id.registered_name)
					ping("[src]鸣响：“已添加证人[id.registered_name]。”")
			else
				to_chat(usr, SPAN_INFO("你需要手持证人的身份卡。"))

		if ("edit_witness_notes")
			var/witness = locate(params["witness"])

			var/notes = tgui_input_text(usr, "概述证人的陈述", "证人报告", html_decode(incident.witnesses[witness]), multiline = TRUE)
			if(!isnull(notes) && incident)
				incident.witnesses[witness] = notes

		if ("remove_witness")
			incident.witnesses -= locate(params["witness"])

		if ("add_evidence")
			var/obj/O = usr.get_active_hand()
			if(istype(O))
				incident.evidence += O
				ping("[src]鸣响：“证物[O.name]已登记。”")
			else
				to_chat(usr, SPAN_INFO("你需要手持证物。"))

		if ("edit_evidence_notes")
			var/evidence = locate(params["evidence"])

			var/notes = tgui_input_text(usr, "描述此证物与案件的关联", "证据报告", html_decode(incident.evidence[evidence]), multiline = TRUE)
			if (!isnull(notes) && incident)
				incident.evidence[evidence] = notes

		if ("remove_evidence")
			incident.evidence -= locate(params["evidence"])

		if ("export")
			if (print_incident_report())
				incident = null
				current_menu = "main"
			else
				to_chat(usr, SPAN_ALERT("报告信息不完整。"))

	return TRUE

/obj/structure/machinery/computer/sentencing/proc/print_incident_report()
	if (!incident.criminal_name || !incident.brig_sentence)
		return FALSE

	// Update criminal record.
	if (incident.criminal_gid)
		for (var/datum/data/record/R in GLOB.data_core.security)
			if (R.fields["id"] == incident.criminal_gid)
				var/datum/data/record/found_record = R

				found_record.fields["incident"] += "<BR> \
												罪名： [incident.charges_to_string()].<BR> \
												备注： [incident.notes].<BR>"

				break

	var/obj/item/paper/incident/paper = new /obj/item/paper/incident(loc)
	paper.incident = incident
	paper.name = "编码事件报告 [paper_counter++]（[incident.criminal_name]）"
	playsound(loc, 'sound/machines/twobeep.ogg', 15, 1)
	return TRUE

/obj/structure/machinery/computer/sentencing/attackby(obj/item/O, mob/user)
	if (istype(O, /obj/item/paper/incident))
		if (current_menu == "main")
			var/obj/item/paper/incident/paper = O
			user.temp_drop_inv_item(paper)
			paper.forceMove(loc)
			incident = paper.incident
			ping("[src]鸣响：“事件报告导入成功！”")
			current_menu = "incident_report"
			qdel(paper)
			tgui_interact(user)
		else
			to_chat(user, SPAN_ALERT("已有一份报告正在处理中。"))

	else if (istype(O, /obj/item/paper/) && current_menu == "main")
		to_chat(user, SPAN_ALERT("此控制台只接受事件报告原件，复印件无效。"))

	else if (istype(O, /obj/item/grab))
		var/obj/item/grab/grab = O
		if (ishuman(grab.grabbed_thing))
			var/mob/living/carbon/human/human = grab.grabbed_thing
			var/obj/item/card/id/id = human.get_idcard()
			if (istype(id))
				if (incident && id.registered_name)
					incident.criminal_name = id.registered_name
					incident.criminal_gid = add_zero(num2hex(id.registered_gid), 6)
					ping("[src]鸣响：“已核实嫌疑人[id.registered_name]。”")

	..()
