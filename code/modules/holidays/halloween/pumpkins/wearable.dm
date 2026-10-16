/// Carved Pumpkin from the Halloween event
/obj/item/clothing/head/pumpkin
	name = "南瓜"
	icon = 'icons/misc/events/pumpkins.dmi'
	item_icons = list(
		WEAR_HEAD = 'icons/misc/events/pumpkins.dmi',
	)
	desc = "一个看起来不太祥瑞的南瓜。戴在头上一定挺吓人……"
	w_class = SIZE_MEDIUM
	flags_inv_hide = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|HIDEALLHAIR
	flags_armor_protection = BODY_FLAG_HEAD|BODY_FLAG_EYES
	flags_inventory = COVEREYES|BLOCKSHARPOBJ|COVERMOUTH
	flags_cold_protection = BODY_FLAG_HEAD
	flags_heat_protection = BODY_FLAG_HEAD
	min_cold_protection_temperature = HELMET_MIN_COLD_PROT
	max_heat_protection_temperature = HELMET_MAX_HEAT_PROT
	armor_melee = CLOTHING_ARMOR_MEDIUM
	armor_bullet = CLOTHING_ARMOR_MEDIUM
	armor_laser = CLOTHING_ARMOR_MEDIUMLOW
	armor_energy = CLOTHING_ARMOR_NONE
	armor_bomb = CLOTHING_ARMOR_LOW
	armor_bio = CLOTHING_ARMOR_MEDIUM
	armor_rad = CLOTHING_ARMOR_LOW
	armor_internaldamage = CLOTHING_ARMOR_MEDIUM
	health = 5
	force = 15
	var/prefix = "" //! Icon state prefix for corrupted pumpkin variants
	var/carved_icon = "" //! Currently carved pumpkin overlay
	var/carvable_icons = list("smile", "cheeky", "bugeyes", "upside_down_smile", "skelly", "ff")

/obj/item/clothing/head/pumpkin/Initialize(mapload, ...)
	. = ..()
	update_icon()

/obj/item/clothing/head/pumpkin/update_icon()
	. = ..()
	if(carved_icon)
		icon_state = "[prefix]pumpkin_carved"
	else
		icon_state = "[prefix]pumpkin"
	item_state_slots = list(
		WEAR_HEAD = "[prefix]pumpkin_onmob",
	)

/obj/item/clothing/head/pumpkin/mob_can_equip(mob/user, slot, disable_warning)
	if(slot == WEAR_HEAD && !carved_icon)
		to_chat(user, SPAN_WARNING("你无法戴上完整的南瓜！先用锋利的物品将它掏空并雕刻好。"))
		return FALSE
	. = ..()

/obj/item/clothing/head/pumpkin/attackby(obj/item/tool, mob/user)
	if(!carved_icon && (tool.sharp == IS_SHARP_ITEM_ACCURATE || tool.sharp == IS_SHARP_ITEM_BIG))
		var/list/pattern_labels = list("smile" = "微笑", "cheeky" = "俏皮", "bugeyes" = "凸眼", "upside_down_smile" = "倒置笑脸", "skelly" = "骷髅", "ff" = "FF")
		var/list/pattern_choices = list()
		for(var/pattern_id in carvable_icons)
			pattern_choices[pattern_labels[pattern_id] || pattern_id] = pattern_id
		var/choice_label = tgui_input_list(user, "选择要雕刻在南瓜上的图案！", "南瓜雕刻", pattern_choices)
		var/choice = pattern_choices[choice_label]
		if(choice)
			playsound(loc, 'sound/effects/vegetation_hit.ogg', 25, 1)
			carved_icon = choice
			name = "雕刻南瓜"
			update_icon()
	else
		return ..()

/obj/item/clothing/head/pumpkin/get_mob_overlay(mob/user_mob, slot)
	var/image/pumpkin = ..()
	if(carved_icon && slot == WEAR_HEAD)
		var/image/overlay = overlay_image(icon, "[prefix]pumpkin_[carved_icon]")
		pumpkin.overlays += overlay
	return pumpkin

/obj/item/clothing/head/pumpkin/corrupted
	name = "腐化南瓜"
	prefix = "cor_"
	carvable_icons = list("cry", "sob", "sad", "why", "spooky", "ff")
