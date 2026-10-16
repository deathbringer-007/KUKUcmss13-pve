/obj/item/iff_tag
	name = "异形敌我识别标签"
	desc = "内置小型敌我识别电脑的标签，可植入异形甲壳。使用访问调谐器操作标签即可修改识别阵营；植入后也可直接对异形操作。"
	icon = 'icons/obj/items/xeno_tag.dmi'
	icon_state = "xeno_tag"
	var/list/faction_groups = list()

/obj/item/iff_tag/attack(mob/living/carbon/xenomorph/xeno, mob/living/carbon/human/injector)
	if(isxeno(xeno))
		if(xeno.stat == DEAD)
			to_chat(injector, SPAN_WARNING("[xeno]已经死了……"))
			return
		if(xeno.iff_tag)
			to_chat(injector, SPAN_WARNING("[xeno]体内已有一个标签。"))
			return
		injector.visible_message(SPAN_NOTICE("[injector]开始将[src]强行塞入[xeno]的甲壳……"), SPAN_NOTICE("你开始将[src]强行塞入[xeno]的甲壳……"))
		if(!do_after(injector, 5 SECONDS, INTERRUPT_ALL, BUSY_ICON_GENERIC, xeno, INTERRUPT_DIFF_LOC, BUSY_ICON_GENERIC))
			return
		injector.visible_message(SPAN_NOTICE("[injector]将[src]强行塞入了[xeno]的甲壳！"), SPAN_NOTICE("你将[src]强行塞入了[xeno]的甲壳！"))
		xeno.iff_tag = src
		injector.drop_inv_item_to_loc(src, xeno)
		if(xeno.hive.hivenumber == XENO_HIVE_RENEGADE) //it's important to know their IFF settings for renegade
			to_chat(xeno, SPAN_NOTICE("设备植入甲壳后，你的本能发生了变化，驱使你保护以下对象：[english_list(faction_groups, "无")]。"))
		return
	return ..()

/obj/item/iff_tag/attackby(obj/item/W, mob/user)
	if(HAS_TRAIT(W, TRAIT_TOOL_MULTITOOL) && ishuman(user))
		handle_reprogramming(user)
		return
	return ..()

/obj/item/iff_tag/proc/handle_reprogramming(mob/living/carbon/human/programmer, mob/living/carbon/xenomorph/xeno)
	var/list/id_faction_groups = programmer.get_id_faction_group()
	var/option = tgui_alert(programmer, "异形标签当前的敌我识别阵营：[english_list(faction_groups, "无")]\n你的身份卡的敌我识别阵营：[english_list(id_faction_groups, "无")]", "异形敌我识别标签", list("覆盖", "添加", "清空"))
	if(!option)
		return FALSE
	if(xeno)
		if(!xeno.iff_tag)
			to_chat(programmer, SPAN_WARNING("你编程期间，[src]的标签被移除了！"))
			return FALSE
		if(!programmer.Adjacent(xeno))
			to_chat(programmer, SPAN_WARNING("你需要保持靠近异形才能重新编程标签！"))
			return FALSE
	switch(option)
		if("覆盖")
			faction_groups = id_faction_groups
		if("添加")
			faction_groups |= id_faction_groups
		if("清空")
			faction_groups = list()
	to_chat(programmer, SPAN_NOTICE("你已<b>[option]</b>敌我识别阵营数据，标签当前的识别阵营为：[english_list(faction_groups, "无")]。"))
	if(xeno?.hive.hivenumber == XENO_HIVE_RENEGADE) //it's important to know their IFF settings for renegade
		to_chat(xeno, SPAN_NOTICE("你的本能发生了变化，似乎在驱使你保护以下对象：[english_list(faction_groups, "无")]。"))
	return TRUE

/obj/item/iff_tag/pmc_handler
	faction_groups = FACTION_LIST_MARINE_WY


/obj/item/storage/xeno_tag_case
	name = "异形标签箱"
	desc = "用于存放异形敌我识别标签并为其充电的坚固箱子，由维兰德-汤谷研究与数据™部门提供。"
	icon = 'icons/obj/items/xeno_tag.dmi'
	icon_state = "tag_box"
	use_sound = "toolbox"
	storage_slots = 8
	can_hold = list(
		/obj/item/iff_tag,
		/obj/item/device/multitool,
	)
	black_market_value = 25

/obj/item/storage/xeno_tag_case/full/fill_preset_inventory()
	for(var/i = 1 to storage_slots - 1)
		new /obj/item/iff_tag(src)
	new /obj/item/device/multitool(src)
