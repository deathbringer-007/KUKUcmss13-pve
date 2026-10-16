/obj/item/hardpoint/holder
	name = "挂架挂载点"
	desc = "用于承载其他挂载组件的支架。"

	// List of types of hardpoints that this hardpoint can hold
	var/list/accepted_hardpoints

	// List of held hardpoints
	var/list/hardpoints

/obj/item/hardpoint/holder/Destroy()
	QDEL_NULL_LIST(hardpoints)

	. = ..()

/obj/item/hardpoint/holder/update_icon()
	overlays.Cut()
	for(var/obj/item/hardpoint/H in hardpoints)
		var/image/I = H.get_hardpoint_image()
		overlays += I

/obj/item/hardpoint/holder/get_examine_text(mob/user)
	. = ..()
	for(var/obj/item/hardpoint/H in hardpoints)
		. += "[src]上安装着[H]模块。"
		. += H.get_examine_text(user, TRUE)

/obj/item/hardpoint/holder/get_tgui_info()
	var/list/data = list()

	for(var/obj/item/hardpoint/H in hardpoints)
		data += list(H.get_tgui_info())

	return data

/obj/item/hardpoint/holder/take_damage(damage)
	..()

	for(var/obj/item/hardpoint/H in hardpoints)
		H.take_damage(damage)

/obj/item/hardpoint/holder/on_install(obj/vehicle/multitile/vehicle)
	..()
	if(!vehicle) //in loose holder
		return
	for(var/obj/item/hardpoint/hardpoint in hardpoints)
		hardpoint.owner = vehicle
		hardpoint.on_install(vehicle)

/obj/item/hardpoint/holder/on_uninstall(obj/vehicle/multitile/vehicle)
	if(!vehicle) //in loose holder
		return
	for(var/obj/item/hardpoint/hardpoint in hardpoints)
		hardpoint.on_uninstall(vehicle)
		hardpoint.owner = null
	..()

/obj/item/hardpoint/holder/proc/can_install(obj/item/hardpoint/H)
	// Can only have 1 hardpoint of each slot type
	if(LAZYLEN(hardpoints))
		for(var/obj/item/hardpoint/HP in hardpoints)
			if(HP.slot == H.slot)
				return FALSE
	// Must be accepted by the holder
	return LAZYISIN(accepted_hardpoints, H.type)

/obj/item/hardpoint/holder/proc/install(obj/item/hardpoint/H, mob/user)
	if(health <= 0)
		to_chat(user, SPAN_WARNING("[src]的所有安装点都已损坏！"))
		return

	user.visible_message(SPAN_NOTICE("[user]开始将[H]安装到[src]的[list(HDPT_PRIMARY = "主武器", HDPT_SECONDARY = "副武器", HDPT_SUPPORT = "支援", HDPT_ARMOR = "装甲", HDPT_TREADS = "履带", HDPT_WHEELS = "车轮", HDPT_TURRET = "炮塔", HDPT_SPECIAL = "特殊")[H.slot]]挂点。"),
		SPAN_NOTICE("你开始将[H]安装到[src]的[list(HDPT_PRIMARY = "主武器", HDPT_SECONDARY = "副武器", HDPT_SUPPORT = "支援", HDPT_ARMOR = "装甲", HDPT_TREADS = "履带", HDPT_WHEELS = "车轮", HDPT_TURRET = "炮塔", HDPT_SPECIAL = "特殊")[H.slot]]挂点。"))
	if(!do_after(user, 120 * user.get_skill_duration_multiplier(SKILL_ENGINEER), INTERRUPT_ALL, BUSY_ICON_FRIENDLY))
		user.visible_message(SPAN_WARNING("[user]停止向[src]安装[H]。"), SPAN_WARNING("你停止向[src]安装[H]。"))
		return

	user.temp_drop_inv_item(H, 0)
	add_hardpoint(H)

	update_icon()

/obj/item/hardpoint/holder/proc/uninstall(obj/item/hardpoint/H, mob/user)
	if(!LAZYISIN(hardpoints, H))
		return

	user.visible_message(SPAN_NOTICE("[user]开始从[src]的[list(HDPT_PRIMARY = "主武器", HDPT_SECONDARY = "副武器", HDPT_SUPPORT = "支援", HDPT_ARMOR = "装甲", HDPT_TREADS = "履带", HDPT_WHEELS = "车轮", HDPT_TURRET = "炮塔", HDPT_SPECIAL = "特殊")[H.slot]]挂点拆除[H]。"),
		SPAN_NOTICE("你开始从[src]的[list(HDPT_PRIMARY = "主武器", HDPT_SECONDARY = "副武器", HDPT_SUPPORT = "支援", HDPT_ARMOR = "装甲", HDPT_TREADS = "履带", HDPT_WHEELS = "车轮", HDPT_TURRET = "炮塔", HDPT_SPECIAL = "特殊")[H.slot]]挂点拆除[H]。"))
	if(!do_after(user, 120 * user.get_skill_duration_multiplier(SKILL_ENGINEER), INTERRUPT_ALL, BUSY_ICON_FRIENDLY))
		user.visible_message(SPAN_WARNING("[user]停止从[src]上拆除[H]。"), SPAN_WARNING("你停止从[src]上拆除[H]。"))
		return

	remove_hardpoint(H, get_turf(user))

	update_icon()

/obj/item/hardpoint/holder/attackby(obj/item/O, mob/user)
	if(HAS_TRAIT(O, TRAIT_TOOL_CROWBAR))
		if(!skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_TRAINED))
			to_chat(user, SPAN_WARNING("你不知道如何用[O]操作[src]。"))
			return

		var/chosen_hp = tgui_input_list(usr, "选择要拆除的挂载模块", "拆除载具挂载模块", (hardpoints + "取消"))
		if(chosen_hp == "取消")
			return
		var/obj/item/hardpoint/old = chosen_hp

		uninstall(old, user)
		return

	if(istype(O, /obj/item/hardpoint))
		if(!skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_TRAINED))
			to_chat(user, SPAN_WARNING("你不知道如何用[O]操作[src]。"))
			return

		var/obj/item/hardpoint/H = O
		if(!(H.type in accepted_hardpoints))
			to_chat(user, SPAN_WARNING("你不知道如何用[O]操作[src]。"))
			return

		install(H, user)
		return

	..()

/obj/item/hardpoint/holder/proc/add_hardpoint(obj/item/hardpoint/H)
	H.owner = owner
	H.forceMove(src)
	LAZYADD(hardpoints, H)

	H.on_install(owner)
	H.rotate(turning_angle(H.dir, dir))

/obj/item/hardpoint/holder/proc/remove_hardpoint(obj/item/hardpoint/H, turf/uninstall_to)
	if(!hardpoints)
		return
	H.forceMove(uninstall_to ? uninstall_to : get_turf(src))

	H.on_uninstall(owner)
	H.reset_rotation()
	hardpoints -= H
	H.owner = null

	if(H.health <= 0)
		qdel(H)

//Returns all activatable hardpoints
/obj/item/hardpoint/holder/proc/get_activatable_hardpoints(seat)
	var/list/hps = list()
	for(var/obj/item/hardpoint/H in hardpoints)
		if(!H.is_activatable() || seat && seat != H.allowed_seat)
			continue
		hps += H
	return hps

//Returns hardpoints that use ammunition
/obj/item/hardpoint/holder/proc/get_hardpoints_with_ammo(seat)
	var/list/hps = list()
	for(var/obj/item/hardpoint/H in hardpoints)
		if(!H.ammo || seat && seat != H.allowed_seat)
			continue
		hps += H
	return hps

/obj/item/hardpoint/holder/proc/find_hardpoint(name)
	for(var/obj/item/hardpoint/H in hardpoints)
		if(H.name == name)
			return H
	return null

// Modified to return a list of all images tied to the holder
/obj/item/hardpoint/holder/get_hardpoint_image()
	var/image/I = ..()
	var/list/images = list(I)
	for(var/obj/item/hardpoint/H in hardpoints)
		var/image/HI = H.get_hardpoint_image()
		if(LAZYLEN(px_offsets) && loc && HI)
			HI.pixel_x += px_offsets["[loc.dir]"][1]
			HI.pixel_y += px_offsets["[loc.dir]"][2]
		images += HI
	return images

/obj/item/hardpoint/holder/rotate(deg)
	for(var/obj/item/hardpoint/H in hardpoints)
		H.rotate(deg)

	..()
