/obj/item/clothing/glasses/hud
	name = "抬头显示器"
	gender = NEUTER
	desc = "能以近乎实时的速度提供重要信息的抬头显示器。"
	flags_atom = null //doesn't protect eyes because it's a monocle, duh


/obj/item/clothing/glasses/hud/health
	name = "\improper 医疗伙伴抬头显示器"
	desc = "扫描视野内人类并提供准确健康状况数据的抬头显示器。"
	icon_state = "healthhud"
	deactive_state = "degoggles"
	flags_armor_protection = 0
	toggleable = TRUE
	hud_type = list(MOB_HUD_MEDICAL_ADVANCED)
	actions_types = list(/datum/action/item_action/toggle)
	req_skill = SKILL_MEDICAL
	req_skill_level = SKILL_MEDICAL_MEDIC

/obj/item/clothing/glasses/hud/health/prescription
	name = "\improper 医疗伙伴抬头显示器（视力矫正型）"
	desc = "扫描视野内人类并提供准确健康状况数据的抬头显示器，配有视力矫正镜片。"
	prescription = TRUE

/datum/action/item_action/view_publications/New(Target)
	..()
	name = "查看研究出版物"
	button.name = name
	button.overlays.Cut()
	var/image/IMG = image('icons/obj/structures/machinery/computer.dmi', button, "research")
	IMG.pixel_x = 0
	IMG.pixel_y = -5
	button.overlays += IMG

/datum/action/item_action/view_publications/update_button_icon()
	return

/datum/action/item_action/view_publications/can_use_action()
	if(owner && !owner.is_mob_incapacitated() && owner.faction != FACTION_SURVIVOR)
		return TRUE

/datum/action/item_action/view_publications/action_activate()
	. = ..()
	var/obj/item/clothing/glasses/hud/health/hud = holder_item
	hud.tgui_interact(owner)

/obj/item/clothing/glasses/hud/health/ui_state(mob/user)
	return GLOB.not_incapacitated_and_adjacent_strict_state

/obj/item/clothing/glasses/hud/health/ui_data(mob/user)
	var/list/data = list(
		"published_documents" = GLOB.chemical_data.research_publications,
		"terminal_view" = FALSE
	)
	return data

/obj/item/clothing/glasses/hud/health/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if (!ui)
		ui = new(user, src, "PublishedDocsHud", name)
		ui.open()

/obj/item/clothing/glasses/hud/health/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
	if(!ishuman(usr))
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

/obj/item/clothing/glasses/hud/health/verb/view_publications()
	set category = "物品"
	set name = "查看研究出版物"
	set src in usr

	if(!usr.stat && !usr.is_mob_restrained() && usr.faction != FACTION_SURVIVOR)
		tgui_interact(usr)

/obj/item/clothing/glasses/hud/health/Topic(href, href_list)
	. = ..()
	if(.)
		return
	if(!ishuman(usr))
		return
	var/mob/living/carbon/human/user = usr
	if(user.stat || user.is_mob_restrained() || !in_range(src, user))
		return

	if(href_list["read_document"])
		var/obj/item/paper/research_report/report = GLOB.chemical_data.research_documents[href_list["print_type"]][href_list["print_title"]]
		if(report)
			report.read_paper(user)

/obj/item/clothing/glasses/hud/sensor
	name = "\improper 传感伙伴抬头显示器"
	desc = "一种较为老旧的抬头显示器，可显示个人服装传感器最后记录的生物体征数据。"
	icon_state = "sensorhud"
	deactive_state = "sensorhud_d"
	flags_armor_protection = 0
	toggleable = TRUE
	hud_type = list(MOB_HUD_MEDICAL_ADVANCED)
	actions_types = list(/datum/action/item_action/toggle)
	req_skill = SKILL_MEDICAL
	req_skill_level = SKILL_MEDICAL_DEFAULT

/obj/item/clothing/glasses/hud/sensor/prescription
	name = "\improper 传感伙伴抬头显示器（视力矫正型）"
	desc = "一种较为老旧的抬头显示器，可显示个人服装传感器最后记录的生物体征数据，配有视力矫正镜片。"
	prescription = TRUE

/obj/item/clothing/glasses/hud/security
	name = "\improper 巡逻伙伴抬头显示器"
	desc = "扫描视野内人类并提供准确身份状态和安保记录的抬头显示器。"
	icon_state = "securityhud"
	deactive_state = "degoggles"
	toggleable = TRUE
	flags_armor_protection = 0
	hud_type = list(MOB_HUD_SECURITY_ADVANCED)
	actions_types = list(/datum/action/item_action/toggle)

/obj/item/clothing/glasses/hud/security/prescription
	name = "\improper 巡逻伙伴抬头显示器（视力矫正型）"
	desc = "扫描视野内人类并提供准确身份状态和安保记录的抬头显示器。"
	prescription = TRUE

/obj/item/clothing/glasses/hud/security/jensenshades
	name = "增强型墨镜"
	gender = PLURAL
	desc = "用于增强视觉的偏光生物神经眼镜。你怎么不试着找份工作？"
	icon_state = "jensenshades"
	item_state = "jensenshades"
	vision_flags = SEE_MOBS
	invisa_view = 2
	toggleable = FALSE
	actions_types = list()
