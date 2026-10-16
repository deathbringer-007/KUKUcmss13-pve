//Also contains /obj/structure/closet/bodybag because I doubt anyone would think to look for bodybags in /object/structures

/obj/item/bodybag
	name = "裹尸袋"
	desc = "折叠起来的袋子，用于存放和运输尸体。"
	icon = 'icons/obj/bodybag.dmi'
	icon_state = "bodybag_folded"
	w_class = SIZE_SMALL
	var/unfolded_path = /obj/structure/closet/bodybag

/obj/item/bodybag/attack_self(mob/user)
	..()
	deploy_bodybag(user, user.loc)

/obj/item/bodybag/afterattack(atom/target, mob/user, proximity)
	if(!proximity)
		return
	if(isturf(target))
		var/turf/T = target
		if(!T.density)
			deploy_bodybag(user, T)

/obj/item/bodybag/proc/deploy_bodybag(mob/user, atom/location)
	var/obj/structure/closet/bodybag/R = new unfolded_path(location, src)
	R.add_fingerprint(user)
	R.open(user)
	user.temp_drop_inv_item(src)
	qdel(src)


/obj/item/bodybag/cryobag
	name = "休眠袋"
	desc = "折叠起来的可重复使用袋子，能防止袋内人员的伤势进一步恶化。"
	icon = 'icons/obj/cryobag.dmi'
	icon_state = "bodybag_folded"
	unfolded_path = /obj/structure/closet/bodybag/cryobag
	matter = list("plastic" = 7500)
	var/used = 0

/obj/item/bodybag/cryobag/Initialize(mapload, obj/structure/closet/bodybag/cryobag/CB)
	. = ..()
	if(CB)
		used = CB.used

/obj/item/storage/box/bodybags
	name = "裹尸袋箱"
	desc = "箱内装有裹尸袋。"
	icon_state = "bodybags"
	w_class = SIZE_LARGE
	can_hold = list(/obj/item/bodybag)

/obj/item/storage/box/bodybags/fill_preset_inventory()
	for(var/i = 1 to 7)
		new /obj/item/bodybag(src)

/obj/structure/closet/bodybag
	name = "裹尸袋"
	var/bag_name = "裹尸袋"
	desc = "用于存放和运输尸体的塑料袋。"
	icon = 'icons/obj/bodybag.dmi'
	icon_state = "bodybag_closed"
	icon_closed = "bodybag_closed"
	icon_opened = "bodybag_open"
	open_sound = 'sound/items/zip.ogg'
	close_sound = 'sound/items/zip.ogg'
	var/item_path = /obj/item/bodybag
	/// the active var that tracks the cooldown for opening and closing
	var/open_cooldown = 0
	density = FALSE
	anchored = FALSE
	/// To layer above rollerbeds.
	layer = ABOVE_OBJ_LAYER
	/// slightly easier than to drag the body directly.
	drag_delay = 2
	/// the roller bed this bodybag is attached to.
	var/obj/structure/bed/roller/roller_buckled
	/// How many extra pixels to offset the bag by when buckled, since rollerbeds are set up to offset a centered horizontal human sprite.
	var/buckle_offset = 5
	store_items = FALSE

/obj/structure/closet/bodybag/Initialize()
	. = ..()
	storage_capacity = (mob_size * 2) - 1

/obj/structure/closet/bodybag/proc/update_name()
	if(opened)
		name = bag_name
	else
		var/mob/living/carbon/human/H = locate() in contents
		if(H)
			name = "[bag_name]（[H.get_visible_name()]）"
		else
			name = "[bag_name]（空）"

/obj/structure/closet/bodybag/attackby(obj/item/W, mob/user)
	if(HAS_TRAIT(W, TRAIT_TOOL_PEN))
		var/prior_label_text
		var/datum/component/label/labelcomponent = src.GetComponent(/datum/component/label)
		if(labelcomponent)
			prior_label_text = labelcomponent.label_name
		var/tmp_label = sanitize(input(user, "为[name]输入标签内容","标签", prior_label_text))
		if(tmp_label == "" || !tmp_label)
			to_chat(user, SPAN_NOTICE("你需要用剪线钳剪掉标签。"))
			return
		if(length(tmp_label) > MAX_NAME_LEN)
			to_chat(user, SPAN_WARNING("标签最多可包含[MAX_NAME_LEN]个字符。"))
		else
			user.visible_message(SPAN_NOTICE("[user]给[src]贴上了“[tmp_label]”的标签。"), \
			SPAN_NOTICE("你给[src]贴上了“[tmp_label]”的标签。"))
			AddComponent(/datum/component/label, tmp_label)
			playsound(src, "paper_writing", 15, TRUE)
		return
	else if(HAS_TRAIT(W, TRAIT_TOOL_WIRECUTTERS))
		to_chat(user, SPAN_NOTICE("你剪掉了裹尸袋上的标签。"))
		src.overlays.Cut()
		var/datum/component/label/labelcomponent = src.GetComponent(/datum/component/label)
		if(labelcomponent)
			labelcomponent.remove_label()
		return
	else if(istype(W, /obj/item/weapon/zombie_claws))
		open()

/obj/structure/closet/bodybag/store_mobs(stored_units) // overriding this
	var/list/dead_mobs = list()
	for(var/mob/living/mob in loc)
		if(mob.buckled)
			continue
		if(mob.stat != DEAD) // covers alive mobs
			continue
		if(!ishuman(mob)) // all the dead other shit
			dead_mobs += mob
			continue
		var/mob/living/carbon/human/human = mob
		if(issynth(human))
			continue
		if(human.check_tod() && human.is_revivable()) // revivable
			continue
		dead_mobs += mob
	var/mob/living/mob_to_store
	if(length(dead_mobs))
		mob_to_store = pick(dead_mobs)
		mob_to_store.forceMove(src)
		stored_units += mob_size
	for(var/obj/item/limb/limb in loc)
		limb.forceMove(src)
	return stored_units

/obj/structure/closet/bodybag/attack_hand(mob/living/user)
	if(!opened)
		open_cooldown = world.time + 10 //1s cooldown for opening and closing, stop that spam! - stan_albatross
	if(opened && open_cooldown > world.time)
		to_chat(user, SPAN_WARNING("[src]刚刚打开，请稍等片刻！"))
		return
	. = ..()


/obj/structure/closet/bodybag/close()
	if(..())
		density = FALSE
		update_name()
		return 1
	return 0

/obj/structure/closet/bodybag/open()
	. = ..()
	update_name()

/obj/structure/closet/bodybag/MouseDrop(over_object, src_location, over_location)
	..()
	if(over_object == usr && Adjacent(usr) && !roller_buckled)
		if(!ishuman(usr)) return
		if(length(contents)) return 0
		visible_message(SPAN_NOTICE("[usr]折起了[name]。"))
		var/obj/item/I = new item_path(get_turf(src), src)
		usr.put_in_hands(I)
		qdel(src)



/obj/structure/closet/bodybag/Move(NewLoc, direct)
	if (roller_buckled && roller_buckled.loc != NewLoc) //not updating position
		if (!roller_buckled.anchored)
			return roller_buckled.Move(NewLoc, direct)
		else
			return 0
	else
		. = ..()


/obj/structure/closet/bodybag/forceMove(atom/destination)
	if(roller_buckled)
		roller_buckled.unbuckle()
	. = ..()



/obj/structure/closet/bodybag/update_icon()
	if(!opened)
		icon_state = icon_closed
		for(var/mob/living/L in contents)
			icon_state += "1"
			break
	else
		icon_state = icon_opened



/obj/structure/closet/bodybag/cryobag
	name = "休眠袋"
	bag_name = "休眠袋"
	desc = "可重复使用的塑料袋，能防止袋内人员的伤势进一步恶化。"
	icon = 'icons/obj/cryobag.dmi'
	item_path = /obj/item/bodybag/cryobag
	store_items = FALSE
	/// the mob in stasis
	var/mob/living/carbon/human/stasis_mob
	var/used = 0
	/// remembers the value of used, to delay crostasis start.
	var/last_use = 0
	/// 15 mins of usable cryostasis
	var/max_uses = 1800

/obj/structure/closet/bodybag/cryobag/Initialize(mapload, obj/item/bodybag/cryobag/CB)
	. = ..()
	if(CB)
		used = CB.used

/obj/structure/closet/bodybag/cryobag/attackby(obj/item/I, mob/living/user)
	if(!istype(I, /obj/item/device/healthanalyzer))
		return
	if(!stasis_mob)
		to_chat(user, SPAN_WARNING("休眠袋是空的！"))
		return
	var/obj/item/device/healthanalyzer/J = I
	J.attack(stasis_mob, user) // yes this is awful -spookydonut
	return

/obj/structure/closet/bodybag/cryobag/Destroy()
	var/mob/living/L = locate() in contents
	if(L)
		L.in_stasis = FALSE
		stasis_mob = null
	STOP_PROCESSING(SSobj, src)
	. = ..()

/obj/structure/closet/bodybag/cryobag/update_icon()
	. = ..()
	// Bump up a living player in the bag to layer of an actual corpse and not just an accidentally coverable prop
	if(stasis_mob)
		layer = LYING_BETWEEN_MOB_LAYER
	else
		layer = initial(layer)

/obj/structure/closet/bodybag/cryobag/open()
	var/mob/living/L = locate() in contents
	if(L)
		L.in_stasis = FALSE
		stasis_mob = null
		STOP_PROCESSING(SSobj, src)
	. = ..()
	if(used > max_uses)
		new /obj/item/trash/used_stasis_bag(loc)
		qdel(src)

/obj/structure/closet/bodybag/cryobag/store_mobs(stored_units) // overriding this
	var/list/mobs_can_store = list()
	for(var/mob/living/carbon/human/H in loc)
		if(H.buckled)
			continue
		if(H.stat == DEAD) // dead, nope
			continue
		mobs_can_store += H
	var/mob/living/carbon/human/mob_to_store
	if(length(mobs_can_store))
		mob_to_store = pick(mobs_can_store)
		mob_to_store.forceMove(src)
		stored_units += mob_size
	return stored_units

/obj/structure/closet/bodybag/cryobag/close()
	. = ..()
	last_use = used + 1
	var/mob/living/carbon/human/H = locate() in contents
	if(H)
		stasis_mob = H
		START_PROCESSING(SSobj, src)
		update_icon()

/obj/structure/closet/bodybag/cryobag/process()
	used++
	if(!stasis_mob)
		STOP_PROCESSING(SSobj, src)
		open()
		return
	if(stasis_mob.stat == DEAD)// || !stasis_mob.key || !stasis_mob.client) // stop using cryobags for corpses and SSD/Ghosted
		STOP_PROCESSING(SSobj, src)
		open()
		visible_message(SPAN_NOTICE("[src]将尸体排了出来。"))
		return
	if(used > last_use) //cryostasis takes a couple seconds to kick in.
		if(!stasis_mob.in_stasis)
			stasis_mob.in_stasis = STASIS_IN_BAG
	if(used > max_uses)
		open()

/obj/structure/closet/bodybag/cryobag/get_examine_text(mob/living/user)
	. = ..()
	if(ishuman(stasis_mob) && hasHUD(user,"medical"))
		var/mob/living/carbon/human/H = stasis_mob
		var/stasis_ref = WEAKREF(H)
		for(var/datum/data/record/R as anything in GLOB.data_core.medical)
			if (R.fields["ref"] == stasis_ref)
				if(!(R.fields["last_scan_time"]))
					. += "<span class = 'deptradio'>没有已记录的扫描报告</span>\n"
				else
					. += "<span class = 'deptradio'><a href='byond://?src=\ref[src];scanreport=1'>[R.fields["last_scan_time"]]的扫描报告</a></span>\n"
				break



	switch(used)
		if(0 to 600) . += "看起来是全新的。"
		if(601 to 1200) . += "看起来有些使用痕迹。"
		if(1201 to 1800) . += "看起来已经损耗严重。"

/obj/structure/closet/bodybag/cryobag/Topic(href, href_list)
	. = ..()
	if(.)
		return
	if (href_list["scanreport"])
		if(hasHUD(usr,"medical"))
			if(!skillcheck(usr, SKILL_MEDICAL, SKILL_MEDICAL_MEDIC))
				to_chat(usr, SPAN_WARNING("你没有受过使用此设备的训练。"))
				return
			if(get_dist(usr, src) > 7)
				to_chat(usr, SPAN_WARNING("[src]离得太远了。"))
				return
			if(ishuman(stasis_mob))
				var/mob/living/carbon/human/H = stasis_mob
				var/stasis_ref = WEAKREF(H)
				for(var/datum/data/record/R as anything in GLOB.data_core.medical)
					if (R.fields["ref"] == stasis_ref)
						if(R.fields["last_scan_time"] && R.fields["last_tgui_scan_result"])
							tgui_interact(usr, human = H)
						break

/obj/structure/closet/bodybag/cryobag/tgui_interact(mob/user, datum/tgui/ui, mob/living/carbon/human/human)
	. = ..()
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "HealthScan", "[human]最近一次的医疗扫描")
		ui.open()
		ui.set_autoupdate(FALSE)

/obj/structure/closet/bodybag/cryobag/ui_data(mob/user)
	if(ishuman(stasis_mob))
		var/mob/living/carbon/human/H = stasis_mob
		var/stasis_ref = WEAKREF(H)
		for(var/datum/data/record/R as anything in GLOB.data_core.medical)
			if(R.fields["ref"] == stasis_ref)
				if(R.fields["last_tgui_scan_result"])
					return R.fields["last_tgui_scan_result"]

/obj/structure/closet/bodybag/cryobag/ui_state(mob/user)
	return GLOB.not_incapacitated_state

/obj/item/trash/used_stasis_bag
	name = "用过的休眠袋"
	icon = 'icons/obj/cryobag.dmi'
	icon_state = "bodybag_used"
	desc = "已经被撕开了。你需要找一台能回收它的机器。"
