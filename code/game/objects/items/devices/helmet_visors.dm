/obj/item/device/helmet_visor
	name = "AN/PAV-70 显示目镜"
	desc = "个人增强视觉抬头显示装置的核心组件。美洲联盟军队使用的几乎所有头盔都将其列为标准配置。"
	icon = 'icons/obj/items/clothing/helmet_visors.dmi'
	icon_state = "hud_sight"
	w_class = SIZE_TINY

	hud_type = list(MOB_HUD_FACTION_MARINE, MOB_HUD_FACTION_ARMY, MOB_HUD_FACTION_NAVY)

	///The sound when toggling on the visor
	var/toggle_on_sound = 'sound/handling/hud_on.ogg'

	///The sound when toggling off the visor
	var/toggle_off_sound = 'sound/handling/hud_off.ogg'

	///The icon name for our helmet's action, in 'icons/obj/items/clothing/helmet_visors.dmi'
	var/action_icon_string = "hud_sight_down"

	///The overlay name for when our visor is active, in 'icons/mob/humans/onmob/helmet_garb.dmi'
	var/helmet_overlay = "hud_sight_right"

/obj/item/device/helmet_visor/Destroy(force)
	if(!istype(loc, /obj/item/clothing/head/helmet/marine))
		return ..()

	if(!istype(loc?.loc, /mob/living/carbon/human))
		return ..()

	var/obj/item/clothing/head/helmet/marine/attached_helmet = loc
	var/mob/living/carbon/human/user = loc.loc
	deactivate_visor(attached_helmet, user)
	. = ..()

// Visors can attach to all marine helmets by default
/obj/item/device/helmet_visor/proc/can_attach_to(obj/item/clothing/head/helmet/target_helmet)
	return TRUE

/// Called to see if the user can even use this visor
/obj/item/device/helmet_visor/proc/can_toggle(mob/living/carbon/human/user)
	return TRUE

/// Called to see if this visor is a special non-HUD visor
/obj/item/device/helmet_visor/proc/toggle_visor(obj/item/clothing/head/helmet/marine/attached_helmet, mob/living/carbon/human/user, silent = FALSE)
	if(attached_helmet == user.head && attached_helmet.active_visor == src)

		if(!can_toggle(user))
			return FALSE

		activate_visor(attached_helmet, user)

		if(!silent)
			to_chat(user, SPAN_NOTICE("你启动了[attached_helmet]上的[src]。"))
			playsound_client(user.client, toggle_on_sound, null, 75)

		return TRUE

	deactivate_visor(attached_helmet, user)

	if(!silent)
		to_chat(user, SPAN_NOTICE("你关闭了[attached_helmet]上的[src]。"))
		playsound_client(user.client, toggle_off_sound, null, 75)

	return TRUE

/// Called by toggle_visor() to activate the visor's effects
/obj/item/device/helmet_visor/proc/activate_visor(obj/item/clothing/head/helmet/marine/attached_helmet, mob/living/carbon/human/user)
	for(var/type in hud_type)
		var/datum/mob_hud/current_mob_hud = GLOB.huds[type]
		current_mob_hud.add_hud_to(user, attached_helmet)

/// Called by toggle_visor() to deactivate the visor's effects
/obj/item/device/helmet_visor/proc/deactivate_visor(obj/item/clothing/head/helmet/marine/attached_helmet, mob/living/carbon/human/user)
	for(var/type in hud_type)
		var/datum/mob_hud/current_mob_hud = GLOB.huds[type]
		current_mob_hud.remove_hud_from(user, attached_helmet)

/obj/item/device/helmet_visor/process(delta_time)
	return PROCESS_KILL

/// Called by /obj/item/clothing/head/helmet/marine/get_examine_text(mob/user) to get extra examine text for this visor
/obj/item/device/helmet_visor/proc/get_helmet_examine_text()
	return SPAN_NOTICE("[name]已翻下。")

/obj/item/device/helmet_visor/upp
	name = "KKV-66M 显示目镜"
	desc = "KKV-66M“幽灵”是德国研制的增强现实抬头显示装置，为进步人民联盟武装部队所有头盔的标准配置。"
	hud_type = list(MOB_HUD_FACTION_UPP)

/obj/item/device/helmet_visor/twe
	name = "小队信息目镜"
	desc = "可装入标准皇家陆战突击队头盔的抬头显示目镜。"
	hud_type = list(MOB_HUD_FACTION_TWE)

/obj/item/device/helmet_visor/medical
	name = "AN/MPAV-71 医疗显示目镜"
	desc = "医疗／个人增强视觉抬头显示装置的核心组件。在美国陆军以外的部队中并不常见。"
	icon_state = "med_sight"
	hud_type = list(MOB_HUD_MEDICAL_BASIC)
	action_icon_string = "med_sight_down"
	helmet_overlay = "med_sight_right"

/obj/item/device/helmet_visor/medical/army
	name = "AN/MPAV-71A 医疗显示目镜"
	desc = "医疗／个人增强视觉抬头显示装置的核心组件。本机外壳上带有美国陆军标记。"
	helmet_overlay = "med_sight_left"
	hud_type = list(MOB_HUD_FACTION_MARINE, MOB_HUD_FACTION_ARMY, MOB_HUD_FACTION_NAVY, MOB_HUD_MEDICAL_BASIC)

/obj/item/device/helmet_visor/medical/advanced
	name = "AN/MAV-72 医疗显示目镜"
	desc = "医疗增强视觉抬头显示装置的核心组件。可连接友方人员的生命体征监测器，为具备相关知识的使用者提供详细信息。"
	helmet_overlay = "med_sight_right"
	hud_type = list(MOB_HUD_FACTION_MARINE, MOB_HUD_FACTION_ARMY, MOB_HUD_FACTION_NAVY, MOB_HUD_MEDICAL_ADVANCED)

/obj/item/device/helmet_visor/medical/advanced/pmc
	hud_type = list(MOB_HUD_FACTION_PMC, MOB_HUD_FACTION_TWE, MOB_HUD_FACTION_WY, MOB_HUD_MEDICAL_ADVANCED)

/obj/item/device/helmet_visor/medical/advanced/rmc
	name = "HBVS 生命体征显示目镜"
	desc = "头戴式生命体征显示系统，是 2170 年代中期那场灾难性的突击队装备升级计划中为数不多的成功成果之一，现已成为所有皇家陆战突击队头盔的标准配置。"
	hud_type = list(MOB_HUD_FACTION_WY, MOB_HUD_FACTION_TWE, MOB_HUD_MEDICAL_ADVANCED)
	icon_state = "hud_sight"
	action_icon_string = "hud_sight_down"
	helmet_overlay = "hud_sight_full"

/obj/item/device/helmet_visor/medical/advanced/rmc/alt
	helmet_overlay = "hud_sight_right"

/obj/item/device/helmet_visor/medical/advanced/upp
	hud_type = list(MOB_HUD_FACTION_UPP, MOB_HUD_MEDICAL_ADVANCED)

/obj/item/device/helmet_visor/medical/activate_visor(obj/item/clothing/head/helmet/marine/attached_helmet, mob/living/carbon/human/user)
	. = ..()
	for(var/type in hud_type)
		var/datum/mob_hud/current_mob_hud = GLOB.huds[type]
		current_mob_hud.add_hud_to(user, attached_helmet)

/obj/item/device/helmet_visor/medical/deactivate_visor(obj/item/clothing/head/helmet/marine/attached_helmet, mob/living/carbon/human/user)
	. = ..()
	for(var/type in hud_type)
		var/datum/mob_hud/current_mob_hud = GLOB.huds[type]
		current_mob_hud.remove_hud_from(user, attached_helmet)

/obj/item/device/helmet_visor/medical/process(delta_time)
	return PROCESS_KILL

/obj/item/device/helmet_visor/medical/advanced/can_toggle(mob/living/carbon/human/user)
	. = ..()
	if(!.)
		return

	if(!skillcheck(user, SKILL_MEDICAL, SKILL_MEDICAL_MEDIC))
		to_chat(user, SPAN_NOTICE("你的技能不足，无法使用[src]。"))
		return FALSE

	return TRUE

/obj/item/device/helmet_visor/medical/advanced/ui_state(mob/user)
	return GLOB.not_incapacitated_and_adjacent_strict_state

/obj/item/device/helmet_visor/medical/advanced/ui_data(mob/user)
	var/list/data = list(
		"published_documents" = GLOB.chemical_data.research_publications,
		"terminal_view" = FALSE
	)
	return data

/obj/item/device/helmet_visor/medical/advanced/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if (!ui)
		ui = new(user, src, "PublishedDocsHud", name)
		ui.open()

/obj/item/device/helmet_visor/medical/advanced/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	if(!ishuman(ui.user))
		return

	var/mob/living/carbon/human/user = ui.user

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

/datum/action/item_action/view_publications/helmet_visor/action_activate()
	. = ..()
	var/obj/item/device/helmet_visor/medical/advanced/medical_visor = locate() in holder_item

	if(!medical_visor)
		return

	medical_visor.tgui_interact(owner)

/obj/item/device/helmet_visor/security
	name = "AN/JPAV-73"
	desc = "执法／个人增强视觉抬头显示装置的核心组件。在宪兵部队以外并不常见。"
	icon_state = "sec_sight"
	hud_type = list(MOB_HUD_FACTION_MARINE, MOB_HUD_FACTION_ARMY, MOB_HUD_FACTION_NAVY, MOB_HUD_SECURITY_ADVANCED)
	action_icon_string = "sec_sight_down"
	helmet_overlay = "sec_sight_right"

/obj/item/device/helmet_visor/welding_visor
	name = "焊接面罩"
	desc = "一体式强偏光焊接面罩，可根据使用者需要快速放下或收起。"
	icon_state = "sight_empty"
	hud_type = null
	action_icon_string = "blank_hud_sight_down"
	helmet_overlay = "weld_visor"

/obj/item/device/helmet_visor/welding_visor/activate_visor(obj/item/clothing/head/helmet/marine/attached_helmet, mob/living/carbon/human/user)
	attached_helmet.vision_impair = VISION_IMPAIR_MAX
	attached_helmet.flags_inventory |= COVEREYES|COVERMOUTH
	attached_helmet.flags_inv_hide |= HIDEEYES|HIDEFACE
	attached_helmet.eye_protection = EYE_PROTECTION_WELDING
	user.update_tint()

/obj/item/device/helmet_visor/welding_visor/deactivate_visor(obj/item/clothing/head/helmet/marine/attached_helmet, mob/living/carbon/human/user)
	attached_helmet.vision_impair = VISION_IMPAIR_NONE
	attached_helmet.flags_inventory &= ~(COVEREYES|COVERMOUTH)
	attached_helmet.flags_inv_hide &= ~(HIDEEYES|HIDEFACE)
	attached_helmet.eye_protection = EYE_PROTECTION_NONE
	user.update_tint()

/obj/item/device/helmet_visor/welding_visor/mercenary
	helmet_overlay = ""

/obj/item/device/helmet_visor/welding_visor/tanker
	helmet_overlay = "tanker_weld_visor"

#define NVG_VISOR_USAGE(delta_time) (power_cell.use(power_use * (delta_time ? delta_time : 1)))

/obj/item/device/helmet_visor/night_vision
	name = "夜视目镜"
	desc = "可装入标准 USCM 头盔的显示目镜。此型号具备夜视功能，是经费正常拨付的部队所用的制式装备。"
	icon_state = "nvg_sight"
	hud_type = null
	action_icon_string = "nvg_sight_down"
	helmet_overlay = "nvg_sight_right"
	toggle_on_sound = 'sound/handling/toggle_nv1.ogg'
	toggle_off_sound = 'sound/handling/toggle_nv2.ogg'

	/// The internal battery for the visor
	var/obj/item/cell/high/power_cell

	/// About 5 minutes active use charge (hypothetically)
	var/power_use = 33

	/// The alpha of darkness we set to for the mob while the visor is on, not completely fullbright but see-able
	var/lighting_alpha = 140

	/// A slight glowing green light while the NVG is activated, is initialized as in the attached_helmet's contents
	var/atom/movable/nvg_light/on_light

	/// Whether or not the sight uses on_light and produces light
	var/visor_glows = TRUE

/obj/item/device/helmet_visor/night_vision/Initialize(mapload, ...)
	. = ..()
	power_cell = new(src)

/obj/item/device/helmet_visor/night_vision/Destroy()
	power_cell = null
	. = ..()

/obj/item/device/helmet_visor/night_vision/get_examine_text(mob/user)
	. = ..()

	. += SPAN_NOTICE("当前电量为 [floor((power_cell.charge / power_cell.maxcharge) * 100)]%。")

/obj/item/device/helmet_visor/night_vision/activate_visor(obj/item/clothing/head/helmet/marine/attached_helmet, mob/living/carbon/human/user)
	RegisterSignal(user, COMSIG_HUMAN_POST_UPDATE_SIGHT, PROC_REF(on_update_sight))

	user.add_client_color_matrix("nvg_visor", 90, color_matrix_multiply(color_matrix_saturation(0.02), color_matrix_from_string("#c4dbdf")))
	user.overlay_fullscreen("nvg_visor", /atom/movable/screen/fullscreen/flash/noise/nvg)
	//user.overlay_fullscreen("nvg_visor_blur", /atom/movable/screen/fullscreen/brute/nvg, 1)
	user.update_sight()
	if(visor_glows)
		on_light = new(attached_helmet)
		on_light.set_light_on(TRUE)
	START_PROCESSING(SSobj, src)
	RegisterSignal(user, COMSIG_MOB_CHANGE_VIEW, PROC_REF(change_view))

/obj/item/device/helmet_visor/night_vision/deactivate_visor(obj/item/clothing/head/helmet/marine/attached_helmet, mob/living/carbon/human/user)
	user.remove_client_color_matrix("nvg_visor", 1 SECONDS)
	user.clear_fullscreen("nvg_visor", 0.5 SECONDS)
	user.clear_fullscreen("nvg_visor_blur", 0.5 SECONDS)

	if(visor_glows)
		qdel(on_light)
	UnregisterSignal(user, COMSIG_HUMAN_POST_UPDATE_SIGHT)
	UnregisterSignal(user, COMSIG_MOB_CHANGE_VIEW)

	user.update_sight()
	STOP_PROCESSING(SSobj, src)

/obj/item/device/helmet_visor/night_vision/process(delta_time)
	if(!NVG_VISOR_USAGE(delta_time))

		if(!istype(loc, /obj/item/clothing/head/helmet/marine))
			return PROCESS_KILL

		if(!istype(loc?.loc, /mob/living/carbon/human))
			return PROCESS_KILL

		var/obj/item/clothing/head/helmet/marine/attached_helmet = loc
		var/mob/living/carbon/human/user = loc.loc
		to_chat(user, SPAN_NOTICE("[src]因电池耗尽而关闭。"))
		deactivate_visor(attached_helmet, user)
		return PROCESS_KILL

/obj/item/device/helmet_visor/night_vision/can_toggle(mob/living/carbon/human/user)
	. = ..()
	if(!.)
		return

	if(user.client?.view > 7)
		to_chat(user, SPAN_WARNING("使用光学观测设备时无法使用[src]。"))
		return FALSE

	if(!NVG_VISOR_USAGE(FALSE))
		to_chat(user, SPAN_NOTICE("你的[src]没电了！需要重新充电。"))
		return FALSE

	return TRUE

/obj/item/device/helmet_visor/night_vision/get_helmet_examine_text()
	. = ..()

	. += SPAN_NOTICE("当前电量为 [floor((power_cell.charge / power_cell.maxcharge) * 100)]%。")

/obj/item/device/helmet_visor/night_vision/proc/on_update_sight(mob/user)
	SIGNAL_HANDLER

	if(lighting_alpha < 255)
		user.see_in_dark = 12
	user.lighting_alpha = lighting_alpha
	user.sync_lighting_plane_alpha()

/obj/item/device/helmet_visor/night_vision/proc/change_view(mob/user, new_size)
	SIGNAL_HANDLER
	if(new_size > 7) // cannot use binos with NVO
		var/obj/item/clothing/head/helmet/marine/attached_helmet = loc
		if(!istype(attached_helmet))
			return
		deactivate_visor(attached_helmet, user)
		to_chat(user, SPAN_NOTICE("你关闭了[attached_helmet]上的[src]。"))
		playsound_client(user.client, toggle_off_sound, null, 75)
		attached_helmet.active_visor = null
		attached_helmet.update_icon()
		var/datum/action/item_action/cycle_helmet_huds/cycle_action = locate() in attached_helmet.actions
		if(cycle_action)
			cycle_action.set_default_overlay()

#undef NVG_VISOR_USAGE

/atom/movable/nvg_light
	light_power = 0.5
	light_range = 1
	light_color = COLOR_LIGHT_GREEN
	light_system = MOVABLE_LIGHT
	light_flags = LIGHT_ATTACHED

/obj/item/device/helmet_visor/night_vision/marine_raider
	name = "高级夜视目镜"
	desc = "可装入标准 USCM 头盔的显示目镜。此型号具备夜视功能，是特种部队的制式装备。"
	hud_type = list(MOB_HUD_FACTION_MARINE, MOB_HUD_FACTION_ARMY, MOB_HUD_FACTION_NAVY, MOB_HUD_MEDICAL_ADVANCED)
	helmet_overlay = "nvg_sight_right_raider"
	power_use = 0
	visor_glows = FALSE

/obj/item/device/helmet_visor/night_vision/marine_raider/activate_visor(obj/item/clothing/head/helmet/marine/attached_helmet, mob/living/carbon/human/user)
	. = ..()

	for(var/type in hud_type)
		var/datum/mob_hud/current_mob_hud = GLOB.huds[type]
		current_mob_hud.add_hud_to(user, attached_helmet)

/obj/item/device/helmet_visor/night_vision/marine_raider/deactivate_visor(obj/item/clothing/head/helmet/marine/attached_helmet, mob/living/carbon/human/user)
	. = ..()

	for(var/type in hud_type)
		var/datum/mob_hud/current_mob_hud = GLOB.huds[type]
		current_mob_hud.remove_hud_from(user, attached_helmet)

/obj/item/device/helmet_visor/night_vision/marine_raider/process(delta_time)
	return PROCESS_KILL

/obj/item/device/helmet_visor/night_vision/marine_raider/rmc
	name = "HIBVS 夜视生命体征目镜"
	desc = "标准 HBVS 的深度改装型号，在原有生命体征监测系统之外还提供红外夜视功能。"
	hud_type = list(MOB_HUD_FACTION_TWE, MOB_HUD_FACTION_WY, MOB_HUD_MEDICAL_ADVANCED)
	helmet_overlay = "nvg_sight_rmc"
	power_use = 0
	visor_glows = FALSE

/////////////////////// PO VISOR ///////////////////////

/obj/item/device/helmet_visor/po_visor
	name = "MK30 飞行面罩（黑色）"
	desc = "USCM 运输艇飞行员使用的制式卡扣式面罩。偏光镜片可减弱眩光，在重返大气层和轨道部署期间保护双眼。"
	icon_state = "po_visor"
	action_icon_string = "po_visor_down"
	helmet_overlay = "po_visor_black"
	toggle_on_sound = 'sound/handling/helmet_open.ogg'
	toggle_off_sound = 'sound/handling/helmet_close.ogg'

/obj/item/device/helmet_visor/po_visor/can_attach_to(obj/item/clothing/head/helmet/target_helmet)
	if(!istype(target_helmet, /obj/item/clothing/head/helmet/upp/marinepilot))
		return FALSE
	return TRUE

/obj/item/device/helmet_visor/po_visor/activate_visor(obj/item/clothing/head/helmet/marine/attached_helmet, mob/living/carbon/human/user)
	..()
	attached_helmet.flags_inventory |= COVEREYES
	attached_helmet.flags_inv_hide |= HIDEEYES|HIDEFACE
	attached_helmet.eye_protection = EYE_PROTECTION_FLASH
	user.update_tint()

/obj/item/device/helmet_visor/po_visor/deactivate_visor(obj/item/clothing/head/helmet/marine/attached_helmet, mob/living/carbon/human/user)
	..()
	attached_helmet.flags_inventory &= ~(COVEREYES)
	attached_helmet.flags_inv_hide &= ~(HIDEEYES|HIDEFACE)
	attached_helmet.eye_protection = EYE_PROTECTION_NONE
	user.update_tint()

/obj/item/device/helmet_visor/po_visor/purple
	name = "MK30 飞行面罩（紫色）"
	icon_state = "po_visor_purple"
	action_icon_string = "po_visor_purple_down"
	helmet_overlay = "po_visor_purple"

/obj/item/device/helmet_visor/po_visor/lightblue
	name = "MK30 飞行面罩（浅蓝色）"
	icon_state = "po_visor_lightblue"
	action_icon_string = "po_visor_lightblue_down"
	helmet_overlay = "po_visor_lightblue"

/obj/item/device/helmet_visor/po_visor/red
	name = "MK30 飞行面罩（红色）"
	icon_state = "po_visor_red"
	action_icon_string = "po_visor_red_down"
	helmet_overlay = "po_visor_red"

/obj/item/device/helmet_visor/po_visor/darkblue
	name = "MK30 飞行面罩（深蓝色）"
	icon_state = "po_visor_darkblue"
	action_icon_string = "po_visor_darkblue_down"
	helmet_overlay = "po_visor_darkblue"

/obj/item/device/helmet_visor/po_visor/yellow
	name = "MK30 飞行面罩（黄色）"
	icon_state = "po_visor_yellow"
	action_icon_string = "po_visor_yellow_down"
	helmet_overlay = "po_visor_yellow"

/obj/item/device/helmet_visor/po_visor/marine
	name = "MK30 飞行面罩（黑色）"
	desc = "USCM 运输艇飞行员使用的制式卡扣式面罩。偏光镜片可减弱眩光，在重返大气层和轨道部署期间保护双眼。本品似乎经过少量改装，以兼容大多数现代头盔。"
	helmet_overlay = "po_visor_black_marine"
	hud_type = list()

/obj/item/device/helmet_visor/po_visor/marine/can_attach_to(obj/item/clothing/head/helmet/target_helmet)
	return TRUE

/obj/item/device/helmet_visor/po_visor/marine/yellow
	name = "MK30 飞行面罩（黄色）"
	icon_state = "po_visor_yellow"
	action_icon_string = "po_visor_yellow_down"
	helmet_overlay = "po_visor_yellow_marine"
