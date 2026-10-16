/obj/item/clothing/suit/storage/marine/smartgunner
	name = "\improper M56战斗护具"
	desc = "由防弹微网和陶瓷复合胸甲构成的轻型背心，提供实用的防护，并配有操作M56智能机枪所需的计算机、绑带和支撑架。"
	icon_state = "8"
	item_state = "armor"
	armor_laser = CLOTHING_ARMOR_LOW
	armor_bomb = CLOTHING_ARMOR_MEDIUM
	armor_rad = CLOTHING_ARMOR_MEDIUM
	storage_slots = 2
	slowdown = SLOWDOWN_ARMOR_MEDIUM
	flags_inventory = BLOCKSHARPOBJ|SMARTGUN_HARNESS
	flags_atom = NO_NAME_OVERRIDE
	unacidable = TRUE
	allowed = list(/obj/item/weapon/gun/smartgun)
	var/list/smartgun_back = list(
		/obj/item/storage/large_holster/machete/smartgunner,
	)
	valid_accessory_slots = list(ACCESSORY_SLOT_MEDAL, ACCESSORY_SLOT_SGPAINT, ACCESSORY_SLOT_PAINT, ACCESSORY_SLOT_PONCHO)

/obj/item/clothing/suit/storage/marine/smartgunner/Initialize()
	. = ..()
	if(SSmapping.configs[GROUND_MAP].environment_traits[MAP_COLD] && name == "\improper M56战斗护具" && !(flags_atom & NO_SNOW_TYPE))
		name = "M56雪地战斗护具"
	//select_gamemode_skin(type)

/obj/item/clothing/suit/storage/marine/smartgunner/mob_can_equip(mob/equipping_mob, slot, disable_warning = FALSE)
	. = ..()

	if(equipping_mob.back && !(equipping_mob.back.flags_item & SMARTGUNNER_BACKPACK_OVERRIDE))
		if(!disable_warning)
			to_chat(equipping_mob, SPAN_WARNING("背着背包时无法穿上[src]。"))
		return FALSE

/obj/item/clothing/suit/storage/marine/smartgunner/equipped(mob/user, slot, silent)
	. = ..()

	if(slot == WEAR_JACKET)
		RegisterSignal(user, COMSIG_HUMAN_ATTEMPTING_EQUIP, PROC_REF(check_equipping))

/obj/item/clothing/suit/storage/marine/smartgunner/proc/check_equipping(mob/living/carbon/human/equipping_human, obj/item/equipping_item, slot)
	SIGNAL_HANDLER

	if(slot != WEAR_BACK)
		return

	if(equipping_item.flags_item & SMARTGUNNER_BACKPACK_OVERRIDE || is_type_in_list(equipping_item, smartgun_back))
		return

	. = COMPONENT_HUMAN_CANCEL_ATTEMPT_EQUIP

	if(equipping_item.flags_equip_slot == SLOT_BACK)
		to_chat(equipping_human, SPAN_WARNING("穿着[src]时无法将[equipping_item]装备在背部。"))
		return

/obj/item/clothing/suit/storage/marine/smartgunner/unequipped(mob/user, slot)
	. = ..()

	UnregisterSignal(user, COMSIG_HUMAN_ATTEMPTING_EQUIP)

/obj/item/clothing/suit/storage/marine/smartgunner/standard
	flags_atom = NO_SNOW_TYPE|NO_NAME_OVERRIDE

/obj/item/clothing/suit/storage/marine/smartgunner/black
	flags_atom = NO_SNOW_TYPE|NO_NAME_OVERRIDE
	icon_state = "8fancy"

//Customizable Variant
/obj/item/clothing/suit/marine/smartgunner
	name = "\improper M56战斗护具"
	desc = "由防弹微网和陶瓷复合胸甲构成的轻型背心，提供实用的防护，并配有操作M56智能机枪所需的计算机、绑带和支撑架。"
	icon_state = "8"
	item_state = "armor"
	armor_laser = CLOTHING_ARMOR_LOW
	armor_bomb = CLOTHING_ARMOR_MEDIUM
	armor_rad = CLOTHING_ARMOR_MEDIUM
	slowdown = SLOWDOWN_ARMOR_MEDIUM
	flags_inventory = BLOCKSHARPOBJ|SMARTGUN_HARNESS
	flags_atom = NO_NAME_OVERRIDE
	unacidable = TRUE
	allowed = list(/obj/item/weapon/gun/smartgun)
	var/list/smartgun_back = list(
		/obj/item/storage/large_holster/machete/smartgunner
	)
	valid_accessory_slots = list(
		ACCESSORY_SLOT_MEDAL,
		ACCESSORY_SLOT_SGPAINT,
		ACCESSORY_SLOT_M56UTILITY,
		ACCESSORY_SLOT_PAINT,
		ACCESSORY_SLOT_PONCHO,
		ACCESSORY_SLOT_DECORNECK,
		ACCESSORY_SLOT_DECORBRACER,
		ACCESSORY_SLOT_DECORSHIN,
		ACCESSORY_SLOT_DECORKNEE,
		ACCESSORY_SLOT_DECORGROIN,
	)
	restricted_accessory_slots = list(
		ACCESSORY_SLOT_PAINT,
		ACCESSORY_SLOT_SGPAINT,
		ACCESSORY_SLOT_M56UTILITY,
		ACCESSORY_SLOT_DECORNECK,
		ACCESSORY_SLOT_DECORBRACER,
		ACCESSORY_SLOT_DECORSHIN,
		ACCESSORY_SLOT_DECORKNEE,
		ACCESSORY_SLOT_DECORGROIN,
	)

/obj/item/clothing/suit/marine/smartgunner/Initialize()
	. = ..()
	if(SSmapping.configs[GROUND_MAP].environment_traits[MAP_COLD] && name == "\improper M56战斗护具" && !(flags_atom & NO_SNOW_TYPE))
		name = "\improper M56雪地战斗护具"
	//select_gamemode_skin(type)

/obj/item/clothing/suit/marine/smartgunner/mob_can_equip(mob/equipping_mob, slot, disable_warning = FALSE)
	. = ..()

	if(equipping_mob.back && !(equipping_mob.back.flags_item & SMARTGUNNER_BACKPACK_OVERRIDE))
		if(!disable_warning)
			to_chat(equipping_mob, SPAN_WARNING("背着背包时无法穿上[src]。"))
		return FALSE

/obj/item/clothing/suit/marine/smartgunner/equipped(mob/user, slot, silent)
	. = ..()

	if(slot == WEAR_JACKET)
		RegisterSignal(user, COMSIG_HUMAN_ATTEMPTING_EQUIP, PROC_REF(check_equipping))

/obj/item/clothing/suit/marine/smartgunner/proc/check_equipping(mob/living/carbon/human/equipping_human, obj/item/equipping_item, slot)
	SIGNAL_HANDLER

	if(slot != WEAR_BACK)
		return

	if(equipping_item.flags_item & SMARTGUNNER_BACKPACK_OVERRIDE || is_type_in_list(equipping_item, smartgun_back))
		return

	. = COMPONENT_HUMAN_CANCEL_ATTEMPT_EQUIP

	if(equipping_item.flags_equip_slot == SLOT_BACK)
		to_chat(equipping_human, SPAN_WARNING("穿着[src]时无法将[equipping_item]装备在背部。"))
		return

/obj/item/clothing/suit/marine/smartgunner/unequipped(mob/user, slot)
	. = ..()

	UnregisterSignal(user, COMSIG_HUMAN_ATTEMPTING_EQUIP)

/obj/item/clothing/suit/marine/smartgunner/standard
	flags_atom = NO_SNOW_TYPE|NO_NAME_OVERRIDE

/obj/item/clothing/suit/marine/smartgunner/black
	flags_atom = NO_SNOW_TYPE|NO_NAME_OVERRIDE
	icon_state = "8fancy"
