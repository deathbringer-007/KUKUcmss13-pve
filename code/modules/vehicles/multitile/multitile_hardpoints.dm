// Returns all hardpoints that are attached to the vehicle, including ones held by holder hardpoints (e.g. turrets)
/obj/vehicle/multitile/proc/get_hardpoints_copy()
	var/list/all_hardpoints = hardpoints.Copy()
	for(var/obj/item/hardpoint/holder/H in all_hardpoints)
		if(!H.hardpoints)
			continue
		all_hardpoints += H.hardpoints.Copy()

	return all_hardpoints

//Returns all activatable hardpoints
/obj/vehicle/multitile/proc/get_activatable_hardpoints(seat)
	var/list/hps = list()
	for(var/obj/item/hardpoint/H in hardpoints)
		if(istype(H, /obj/item/hardpoint/holder))
			var/obj/item/hardpoint/holder/HP = H
			if(HP.hardpoints)
				hps += HP.get_activatable_hardpoints(seat)
		if(!H.is_activatable() || seat && seat != H.allowed_seat)
			continue
		hps += H
	return hps

//Returns hardpoints that use ammunition
/obj/vehicle/multitile/proc/get_hardpoints_with_ammo(seat)
	var/list/hps = list()
	for(var/obj/item/hardpoint/H in hardpoints)
		if(istype(H, /obj/item/hardpoint/holder))
			var/obj/item/hardpoint/holder/HP = H
			if(HP.hardpoints)
				hps += HP.get_hardpoints_with_ammo(seat)
		if(!H.ammo || seat && seat != H.allowed_seat)
			continue
		hps += H
	return hps

// Returns a hardpoint by its name
/obj/vehicle/multitile/proc/find_hardpoint(name)
	for(var/obj/item/hardpoint/H in hardpoints)
		if(istype(H, /obj/item/hardpoint/holder))
			var/obj/item/hardpoint/holder/HP = H

			var/obj/item/hardpoint/nested_hp = HP.find_hardpoint(name)
			if(nested_hp)
				return nested_hp

		if(H.name == name)
			return H
	return null

//What to do if all ofthe installed modules have been broken
/obj/vehicle/multitile/proc/handle_all_modules_broken()
	return

/obj/vehicle/multitile/proc/deactivate_all_hardpoints()
	var/list/hps = get_activatable_hardpoints()
	for(var/obj/item/hardpoint/H in hps)
		H.deactivate()

/obj/vehicle/multitile/proc/remove_all_players()
	return

//Putting on hardpoints
//Similar to repairing stuff, down to the time delay
/obj/vehicle/multitile/proc/install_hardpoint(obj/item/O, mob/user)
	if(!skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_TRAINED))
		to_chat(user, SPAN_WARNING("你不知道该如何在[src]上使用[O]。"))
		return

	var/obj/item/hardpoint/HP = O
	if(ispowerclamp(O))
		var/obj/item/powerloader_clamp/PC = O
		HP = PC.loaded

	for(var/obj/item/hardpoint/holder/H in hardpoints)
		// Attempt to install on holder hardpoints first
		if(H.can_install(HP))
			H.install(HP, user)
			update_icon()
			return

	if(health < initial(health) * 0.75)
		to_chat(user, SPAN_WARNING("[src]上所有安装点都损坏了！"))
		return

	if(LAZYLEN(hardpoints))
		for(var/obj/item/hardpoint/H in hardpoints)
			if(HP.slot == H.slot)
				to_chat(user, SPAN_WARNING("那里已经安装了东西！"))
				return

	if(!(HP.type in hardpoints_allowed))
		to_chat(user, SPAN_WARNING("你不知道该如何在[src]上使用[HP]。"))
		return

	user.visible_message(SPAN_NOTICE("[user]开始将[HP]安装到[src]的[HP.slot]挂点槽。"),
		SPAN_NOTICE("你开始将[HP]安装到[src]的[HP.slot]挂点槽。"))

	var/num_delays = 1

	switch(HP.slot)
		if(HDPT_PRIMARY) num_delays = 5
		if(HDPT_SECONDARY) num_delays = 3
		if(HDPT_SUPPORT) num_delays = 2
		if(HDPT_ARMOR) num_delays = 10
		if(HDPT_TREADS, HDPT_WHEELS) num_delays = 7

	if(!do_after(user, 30*num_delays * user.get_skill_duration_multiplier(SKILL_ENGINEER), INTERRUPT_ALL, BUSY_ICON_FRIENDLY, numticks = num_delays))
		user.visible_message(SPAN_WARNING("[user]停止将[HP]安装到[src]上。"), SPAN_WARNING("你停止将[HP]安装到[src]上。"))
		return

	//check to prevent putting two modules on same slot
	for(var/obj/item/hardpoint/H in hardpoints)
		if(HP.slot == H.slot)
			to_chat(user, SPAN_WARNING("那里已经安装了东西！"))
			return

	user.visible_message(SPAN_NOTICE("[user]将[HP]安装到了[src]上。"), SPAN_NOTICE("你将[HP]安装到了[src]上。"))

	if(ispowerclamp(O))
		var/obj/item/powerloader_clamp/PC = O
		PC.loaded.forceMove(src)
		to_chat(user, SPAN_NOTICE("你用[PC]将[PC.loaded]安装到了[src]上。"))
		PC.loaded = null
		playsound(loc, 'sound/machines/hydraulics_2.ogg', 40, 1)
		PC.update_icon()
	else
		user.temp_drop_inv_item(HP, 0)

	add_hardpoint(HP, user)

//User-orientated proc for taking of hardpoints
//Again, similar to the above ones
/obj/vehicle/multitile/proc/uninstall_hardpoint(obj/item/O, mob/user)
	if(!skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_TRAINED))
		to_chat(user, SPAN_WARNING("你不知道该如何在[src]上使用[O]。"))
		return

	if(ispowerclamp(O))
		var/obj/item/powerloader_clamp/PC = O
		if(!PC.linked_powerloader || PC.loaded)
			return

	var/list/hps = list()
	for(var/obj/item/hardpoint/H in get_hardpoints_copy())
		// Only allow uninstalls of massive hardpoints when using powerloaders
		if(H.w_class == SIZE_MASSIVE && !ispowerclamp(O) || H.w_class <= SIZE_HUGE && ispowerclamp(O) || istype(H, /obj/item/hardpoint/special))
			continue
		hps += H

	var/chosen_hp = tgui_input_list(usr, "选择要拆除的挂点", "拆除挂点", (hps + "取消"))
	if(chosen_hp == "取消" || !chosen_hp || (get_dist(src, user) > 2)) //get_dist uses 2 because the vehicle is 3x3
		return

	var/obj/item/hardpoint/old = chosen_hp

	if(!old)
		to_chat(user, SPAN_WARNING("那里没有安装任何东西。"))
		return

	if(!old.can_be_removed(user))
		return

	// It's in a holder
	if(!(old in hardpoints))
		for(var/obj/item/hardpoint/holder/H in hardpoints)
			if(old in H.hardpoints)
				H.uninstall(old, user)
				update_icon()
				return

	user.visible_message(SPAN_NOTICE("[user]开始拆卸[src]的[old.slot]挂点槽上的[old]。"),
		SPAN_NOTICE("你开始拆卸[src]的[old.slot]挂点槽上的[old]。"))

	var/num_delays = 1

	switch(old.slot)
		if(HDPT_PRIMARY) num_delays = 5
		if(HDPT_SECONDARY) num_delays = 3
		if(HDPT_SUPPORT) num_delays = 2
		if(HDPT_ARMOR) num_delays = 10
		if(HDPT_TREADS) num_delays = 7

	if(!do_after(user, 30*num_delays * user.get_skill_duration_multiplier(SKILL_ENGINEER), INTERRUPT_ALL, BUSY_ICON_FRIENDLY, numticks = num_delays))
		user.visible_message(SPAN_WARNING("[user]停止从[src]上拆卸[old]。"), SPAN_WARNING("你停止从[src]上拆卸[old]。"))
		return

	user.visible_message(SPAN_NOTICE("[user]从[src]上拆下了[old]。"), SPAN_NOTICE("你从[src]上拆下了[old]。"))

	remove_hardpoint(old, user)

	if(QDELETED(old))
		return

	if(ispowerclamp(O))
		var/obj/item/powerloader_clamp/PC = O
		PC.grab_object(user, old, "vehicle_module")
		PC.loaded.update_icon()

	if(old.slot == HDPT_TREADS && clamped)
		detach_clamp(user)

//General proc for putting on hardpoints
//ALWAYS CALL THIS WHEN ATTACHING HARDPOINTS
/obj/vehicle/multitile/proc/add_hardpoint(obj/item/hardpoint/HP, mob/user)
	HP.owner = src
	set_muzzle_offsets(HP)
	HP.forceMove(src)
	hardpoints += HP

	HP.on_install(src)
	HP.rotate(turning_angle(HP.dir, dir))

	update_icon()

/obj/vehicle/multitile/proc/set_muzzle_offsets(obj/item/hardpoint/HP)
	return

//General proc for taking off hardpoints
//ALWAYS CALL THIS WHEN REMOVING HARDPOINTS
/obj/vehicle/multitile/proc/remove_hardpoint(obj/item/hardpoint/old, mob/user)
	if(!(old in hardpoints))
		return

	if(user)
		old.forceMove(get_turf(user))
	else
		old.forceMove(get_turf(src))

	old.on_uninstall(src)
	old.reset_rotation()
	hardpoints -= old
	old.owner = null

	if(old.health <= 0 && !old.gc_destroyed) // Make sure it's not already being deleted.
		visible_message(SPAN_WARNING("[src]因遭受重创而崩解，化为一堆无用的废料。"))
		qdel(old)

	update_icon()
