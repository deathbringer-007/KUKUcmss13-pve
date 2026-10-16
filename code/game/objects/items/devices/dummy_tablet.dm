/obj/item/device/professor_dummy_tablet
	icon = 'icons/obj/items/devices.dmi'
	name = "\improper 假人教授控制平板"
	desc = "用于控制假人教授的平板设备。"
	suffix = "\[3\]"
	icon_state = "Cotablet"
	item_state = "Cotablet"

	var/mob/living/carbon/human/linked_dummy
	///Should the dummy be destroyed on hijack?
	var/dust_on_hijack = FALSE

/obj/item/device/professor_dummy_tablet/Initialize()
	. = ..()
	var/turf/actual_location = get_turf(src)
	if(is_mainship_level(actual_location.z))
		dust_on_hijack = TRUE
	RegisterSignal(SSdcs, COMSIG_GLOB_HIJACK_LANDED, PROC_REF(destroy_dummy_upon_hijack))

/obj/item/device/professor_dummy_tablet/proc/destroy_dummy_upon_hijack()
	SIGNAL_HANDLER

	if(!dust_on_hijack)
		return
	if(!linked_dummy)
		return
	linked_dummy.visible_message(SPAN_WARNING("[linked_dummy]突然化为粉末！"))
	linked_dummy.dust(create_cause_data("hijack autodelete"))

/obj/item/device/professor_dummy_tablet/Destroy()
	UnregisterSignal(src, COMSIG_GLOB_HIJACK_LANDED)
	linked_dummy = null
	. = ..()

/**
 * Checks if the user is adjacent to the dummy
 *
 * Returns TRUE if the user is adjacent to the dummy, FALSE otherwise
 *
 * * arg-1: The user
 */
/obj/item/device/professor_dummy_tablet/proc/is_adjacent_to_dummy(mob/user)
	if (get_dist(linked_dummy, user) > 1)
		to_chat(user, SPAN_WARNING("你离假人太远，无法使用它的控制平板。"))
		return FALSE
	return TRUE

/obj/item/device/professor_dummy_tablet/proc/link_dummy(mob/living/carbon/human/dummy_to_link)
	if(dummy_to_link)
		linked_dummy = dummy_to_link
		RegisterSignal(linked_dummy, COMSIG_PARENT_QDELETING, PROC_REF(self_delete))
		return

/obj/item/device/professor_dummy_tablet/proc/self_delete()
	SIGNAL_HANDLER

	UnregisterSignal(linked_dummy, COMSIG_PARENT_QDELETING)
	linked_dummy = null
	if(isstorage(loc))
		var/obj/item/storage/storage = loc
		storage.remove_from_storage(src, get_turf(src))
	qdel(src)

/obj/item/device/professor_dummy_tablet/attack_self(mob/user as mob)
	..()
	interact(user)

/obj/item/device/professor_dummy_tablet/interact(mob/user as mob)
	if(isnull(linked_dummy))
		return

	if(!is_adjacent_to_dummy(user))
		return

	user.set_interaction(src)
	var/dat = "<head><title>假人教授控制平板</title></head><body>"

	dat += "<BR>\[ <A href='byond://?src=\ref[src];operation=brute_damage_limb'>物理损伤（身体部位）</A> \]"
	dat += "<BR>\[ <A href='byond://?src=\ref[src];operation=brute_damage_organ'>物理损伤（内脏）</A> \]"
	dat += "<BR>\[ <A href='byond://?src=\ref[src];operation=burn_damage'>烧伤</A> \]"
	dat += "<BR>\[ <A href='byond://?src=\ref[src];operation=toxin'>注入毒素</A> \]"
	dat += "<BR>\[ <A href='byond://?src=\ref[src];operation=bones'>造成骨折</A> \]"
	dat += "<BR>\[ <A href='byond://?src=\ref[src];operation=blood_loss'>造成失血</A> \]"
	dat += "<BR>\[ <A href='byond://?src=\ref[src];operation=bleeding'>造成内出血</A> \]"
	dat += "<BR>\[ <A href='byond://?src=\ref[src];operation=shrapnel'>嵌入弹片</A> \]"
	dat += "<BR>\[ <A href='byond://?src=\ref[src];operation=delimb'>移除肢体</A> \]"
	dat += "<BR>\[ <A href='byond://?src=\ref[src];operation=reset'>重置</A> \]"
	dat += "<BR><hr>"

	show_browser(user, dat, "假人教授控制平板", "dummytablet", width = 400, height = 500)
	onclose(user, "dummytablet")
	updateDialog()
	return

/obj/item/device/professor_dummy_tablet/proc/select_delimb_target()
	var/list/procedureChoices = list(
		"右手" = "r_hand",
		"左手" = "l_hand",
		"右臂" = "r_arm",
		"左臂" = "l_arm",
		"右脚" = "r_foot",
		"左脚" = "l_foot",
		"右腿" = "r_leg",
		"左腿" = "l_leg",
	)
	var/selection = ""
	selection = tgui_input_list(usr, "请选择要移除的肢体。", "选择肢体", procedureChoices)
	return LAZYACCESS(procedureChoices, selection)


/obj/item/device/professor_dummy_tablet/proc/select_internal_organ()
	var/list/procedureChoices = list(
		"心脏" = "heart",
		"肺" = "lungs",
		"肝脏" = "liver",
		"肾脏" = "kidneys",
		"大脑" = "brain",
		"眼睛" = "eyes",
	)
	var/selection = ""
	selection = tgui_input_list(usr, "请选择器官。", "选择器官", procedureChoices)
	return LAZYACCESS(procedureChoices, selection)

/obj/item/device/professor_dummy_tablet/proc/select_body_part()
	var/list/procedureChoices = list(
		"头部" = "head",
		"胸部" = "chest",
		"腹股沟" = "groin",
		"右手" = "r_hand",
		"左手" = "l_hand",
		"右臂" = "r_arm",
		"左臂" = "l_arm",
		"右脚" = "r_foot",
		"左脚" = "l_foot",
		"右腿" = "r_leg",
		"左腿" = "l_leg",
	)
	var/selection = ""
	selection = tgui_input_list(usr, "请选择身体部位。", "选择身体部位", procedureChoices)
	return LAZYACCESS(procedureChoices, selection)


/obj/item/device/professor_dummy_tablet/Topic(href, href_list)
	if(..()) return FALSE

	if (!is_adjacent_to_dummy(usr))
		return FALSE

	usr.set_interaction(src)

	switch(href_list["operation"])
		if ("brute_damage_organ")
			var/selection = select_internal_organ()
			if (!selection)
				return
			var/datum/internal_organ/organ = LAZYACCESS(linked_dummy.internal_organs_by_name, selection)
			if (!istype(organ))
				return
			var/amount = 0
			amount = tgui_input_real_number(usr, "请输入损伤量。")
			if (amount==0)
				return
			organ.take_damage(amount)
		if ("brute_damage_limb")
			var/selection = select_body_part()
			if (!selection)
				return
			var/obj/limb/limb = linked_dummy.get_limb(selection)
			if (!istype(limb))
				return
			if(limb.status & LIMB_DESTROYED)
				return
			var/amount = 0
			amount = tgui_input_real_number(usr, "请输入损伤量。")
			if (amount==0)
				return
			limb.take_damage(amount, 0)
		if ("burn_damage")
			var/selection = select_body_part()
			if (!selection)
				return
			var/obj/limb/limb = linked_dummy.get_limb(selection)
			if (!istype(limb))
				return
			if(limb.status & LIMB_DESTROYED)
				return
			var/amount = 0
			amount = tgui_input_real_number(usr, "请输入烧伤量。")
			if (amount==0)
				return
			limb.take_damage(0, amount)
		if ("toxin")
			var/amount = 0
			amount = tgui_input_real_number(usr, "请输入毒素注入量。")
			if (amount==0)
				return
			linked_dummy.reagents.add_reagent("toxin", amount)
		if ("bones")
			var/selection = select_body_part()
			if (!selection)
				return
			var/obj/limb/limb = linked_dummy.get_limb(selection)
			if (!istype(limb))
				return
			if(limb.status & LIMB_DESTROYED)
				return
			limb.fracture(100)
		if ("blood_loss")
			var/amount = 0
			amount = tgui_input_real_number(usr, "请输入失血量。")
			if (amount==0)
				return
			linked_dummy.drip(amount)
		if ("bleeding")
			var/selection = select_body_part()
			if (!selection)
				return
			var/obj/limb/limb = linked_dummy.get_limb(selection)
			if (!istype(limb))
				return
			if(limb.status & LIMB_DESTROYED)
				return
			if(linked_dummy.get_limb(selection).status & LIMB_DESTROYED)
				return
			var/datum/wound/internal_bleeding/I = new (0)//<- copied from limbs.dm, doesn't have any issues with cybernetics
			limb.add_bleeding(I, TRUE)
			limb.wounds += I
		if ("shrapnel")
			var/selection = select_body_part()
			if (!selection)
				return
			var/obj/limb/limb = linked_dummy.get_limb(selection)
			if (!istype(limb))
				return
			if(limb.status & LIMB_DESTROYED)
				return
			var/obj/item/shard/shrapnel/s = new /obj/item/shard/shrapnel()
			limb.embed(s)
		if ("delimb")
			var/selection = select_body_part()
			if (!selection)
				return
			var/obj/limb/limb = linked_dummy.get_limb(selection)
			if (!istype(limb))
				return
			if(limb.status & LIMB_DESTROYED)
				return
			limb.droplimb(TRUE, TRUE, "tablet")
			playsound(loc, 'sound/weapons/slice.ogg', 25)
		if("reset")
			linked_dummy.revive()
		else
			updateUsrDialog()
			return FALSE
	linked_dummy.regenerate_all_icons()
	linked_dummy.emote("scream")
	updateUsrDialog()
	return TRUE
