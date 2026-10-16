/obj/structure/machinery/xenoanalyzer
	name = "生物质分析仪"
	desc = "分析生物材料的设备，将宝贵的物质转化成更宝贵的数据。"
	density = TRUE
	anchored = TRUE
	icon = 'icons/obj/structures/machinery/science_machines_64x32.dmi'
	icon_state = "xeno_analyzer" //for the time while no sprites
	use_power = USE_POWER_NONE
	wrenchable = FALSE
	idle_power_usage = 40
	bound_x = 32
	///assoc list containing the path to every upgrade followed by a number representing times this tech was bought. used by price inflation mechanic to increase/decrease price depending on the amount of times you bought it.
	var/list/technology_purchased = list()
	var/biomass_points = 0 //most important thing in this
	var/obj/item/organ/xeno/organ = null
	var/busy = FALSE
	var/caste_of_organ = null

/obj/structure/machinery/xenoanalyzer/Initialize(mapload, ...)
	. = ..()
	for(var/upgrade_type in subtypesof(/datum/research_upgrades))
		var/datum/research_upgrades/upgrade = upgrade_type
		if(upgrade.behavior == RESEARCH_UPGRADE_CATEGORY)
			continue
		if(upgrade.behavior == RESEARCH_UPGRADE_EXCLUDE_BUY)
			continue
		technology_purchased[upgrade_type] = 0

/obj/structure/machinery/xenoanalyzer/attack_hand(mob/user as mob)
	if(!skillcheck(user, SKILL_RESEARCH, SKILL_RESEARCH_TRAINED))
		to_chat(user, SPAN_WARNING("你完全不知道如何使用它。"))
		return
	tgui_interact(user)

/obj/structure/machinery/xenoanalyzer/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "XenomorphExtractor", name)
		ui.open()

/obj/structure/machinery/xenoanalyzer/attackby(obj/item/attacked_item, mob/user)
	if(!skillcheck(user, SKILL_RESEARCH, SKILL_RESEARCH_TRAINED))
		to_chat(user, SPAN_WARNING("你完全不知道如何使用它。"))
		return
	if(istype(attacked_item, /obj/item/organ/xeno))
		if(busy)
			to_chat(user, SPAN_WARNING("[src]目前正在工作！"))
		if(organ)
			to_chat(user, SPAN_WARNING("器官插槽已经满了！"))
			return
		if(!do_after(user, 3 SECONDS, INTERRUPT_ALL, BUSY_ICON_GENERIC))
			to_chat(user, SPAN_WARNING("你被打断了！"))
			return
		if(!user.drop_inv_item_to_loc(attacked_item, src))
			return
		to_chat(user, SPAN_NOTICE("你将器官放入了机器。"))
		organ = attacked_item
		icon_state = "xeno_analyzer_organ_on"
		caste_of_organ = organ.caste_origin
		playsound(loc, 'sound/machines/fax.ogg', 15, 1)
	if(istype(attacked_item, /obj/item/clothing/accessory/health/research_plate))
		var/obj/item/clothing/accessory/health/research_plate/plate = attacked_item
		if(plate.recyclable_value == 0 && !plate.can_recycle(user))
			to_chat(user, SPAN_WARNING("你无法回收这种装甲板。"))
			return
		if(!do_after(user, 3 SECONDS, INTERRUPT_ALL, BUSY_ICON_GENERIC))
			to_chat(user, SPAN_WARNING("你被打断了！"))
			return
		to_chat(user, SPAN_NOTICE("你回收了[attacked_item]。"))
		biomass_points += plate.recyclable_value
		qdel(attacked_item)
		playsound(loc, 'sound/machines/fax.ogg', 15, 1)

/obj/structure/machinery/xenoanalyzer/ui_data(mob/user)
	var/list/data = list()
	data["points"] = biomass_points
	data["current_clearance"] = GLOB.chemical_data.clearance_level
	data["is_x_level"] = GLOB.chemical_data.reached_x_access // why just why

	if(organ)
		data["organ"] = TRUE
		data["caste"] = caste_of_organ
		data["value"] = organ.research_value
	else
		data["organ"] = FALSE
	data["upgrades"] = list()
	data["categories"] = list()
	for(var/upgrade_type in subtypesof(/datum/research_upgrades))// moved this here since prices are dynamic now
		var/datum/research_upgrades/upgrade = upgrade_type
		if(upgrade.behavior == RESEARCH_UPGRADE_CATEGORY)
			data["categories"] += upgrade.name
			continue
		if(upgrade.behavior == RESEARCH_UPGRADE_EXCLUDE_BUY)
			continue
		var/price_adjustment = clamp(upgrade.value_upgrade + upgrade.change_purchase * technology_purchased[upgrade_type], upgrade.minimum_price, upgrade.maximum_price)
		data["upgrades"] += list(list(
			"name" = capitalize_first_letters(upgrade.name),
			"desc" = upgrade.desc,
			"cost" = price_adjustment,
			"ref" = upgrade_type,
			"category" = upgrade.upgrade_type,
			"clearance" = upgrade.clearance_req,
			"price_change" = upgrade.change_purchase,
		))
	return data

/obj/structure/machinery/xenoanalyzer/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	switch(action)
		if("eject_organ")
			eject_biomass(usr)
			. = TRUE

		if("process_organ")
			if(!busy)
				busy = TRUE
				addtimer(CALLBACK(src, PROC_REF(process_organ), organ.research_value), 3 SECONDS)
				flick("xeno_analyzer_on_moving", src)
				playsound(loc, 'sound/machines/blender.ogg', 25, TRUE)
				QDEL_NULL(organ)
				. = TRUE
		if("produce")
			if(!busy)
				start_print_upgrade(text2path(params["ref"]), usr)
	playsound(src, 'sound/machines/keyboard2.ogg', 25, TRUE)

/obj/structure/machinery/xenoanalyzer/proc/eject_biomass(mob/user)
	if(busy)
		to_chat(user, SPAN_WARNING("[src]目前正在工作！"))
		return
	if(isnull(organ))
		return
	icon_state = "xeno_analyzer"
	organ.forceMove(get_turf(src))
	organ = null

/obj/structure/machinery/xenoanalyzer/proc/process_organ(biomass_points_to_add)
	biomass_points += biomass_points_to_add
	icon_state = "xeno_analyzer"
	busy = FALSE


/obj/structure/machinery/xenoanalyzer/proc/start_print_upgrade(produce_path, mob/user)
	if(stat & NOPOWER)
		icon_state = "xeno_analyzer_off"
		return
	if(busy)//double check for me here
		to_chat(user, SPAN_WARNING("[src]发出恼人的嗡鸣并闪烁红光——它正在工作！"))
		return
	var/path_exists = FALSE
	var/datum/research_upgrades/upgrade
	var/datum_upgrades
	for(datum_upgrades in subtypesof(/datum/research_upgrades))
		upgrade = datum_upgrades
		if(upgrade.behavior == RESEARCH_UPGRADE_CATEGORY || upgrade.behavior == RESEARCH_UPGRADE_EXCLUDE_BUY)
			continue
		if(produce_path == datum_upgrades)
			path_exists = TRUE
			break
	if(!path_exists)
		to_chat(user, SPAN_WARNING("[src]发出可疑的哀鸣，随后停机了。"))
		return
	if(clamp(upgrade.value_upgrade + upgrade.change_purchase * technology_purchased[datum_upgrades], upgrade.minimum_price, upgrade.maximum_price) > biomass_points)
		to_chat(user, SPAN_WARNING("[src]发出令人不安的哔声并闪烁红光，已处理的数据不足以制造所选升级！"))
		return
	if((upgrade.clearance_req > GLOB.chemical_data.clearance_level && upgrade.clearance_req != 6) || (upgrade.clearance_req == 6 && !GLOB.chemical_data.reached_x_access))
		to_chat(user, SPAN_WARNING("[src]发出恼人的嗡鸣并闪烁红光——你无权获取这项升级！"))
		return
	flick("xeno_analyzer_printing", src)
	busy = TRUE
	biomass_points -= clamp(upgrade.value_upgrade + upgrade.change_purchase * technology_purchased[datum_upgrades], upgrade.minimum_price, upgrade.maximum_price)
	technology_purchased[datum_upgrades] += 1
	addtimer(CALLBACK(src, PROC_REF(print_upgrade), produce_path), 3 SECONDS)

/obj/structure/machinery/xenoanalyzer/proc/print_upgrade(produce_path)
	busy = FALSE
	var/datum/research_upgrades/item = new produce_path()
	item.on_purchase(get_turf(src))

