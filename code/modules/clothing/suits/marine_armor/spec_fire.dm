/obj/item/clothing/suit/storage/marine/M35
	name = "\improper M35 火焰兵护甲"
	desc = "专为 USCM 火焰兵定制的 M35 护甲。原型冷却与散热系统能有效防火，但也使穿戴者更易受到超压冲击波伤害。"
	icon_state = "pyro_armor"
	slowdown = SLOWDOWN_ARMOR_MEDIUM
	armor_internaldamage = CLOTHING_ARMOR_MEDIUMHIGH
	armor_bio = CLOTHING_ARMOR_MEDIUMHIGH
	armor_bomb = CLOTHING_ARMOR_LOW
	light_range = 5
	fire_intensity_resistance = BURN_LEVEL_TIER_1
	max_heat_protection_temperature = FIRESUIT_MAX_HEAT_PROT
	flags_armor_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_ARMS|BODY_FLAG_LEGS|BODY_FLAG_FEET
	flags_cold_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_ARMS|BODY_FLAG_LEGS|BODY_FLAG_FEET
	flags_heat_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_ARMS|BODY_FLAG_LEGS|BODY_FLAG_FEET
	specialty = "M35 火焰兵"
	unacidable = TRUE
	var/shields_from_fire = TRUE

/obj/item/clothing/suit/storage/marine/M35/equipped(mob/user, slot)
	if(slot == WEAR_JACKET)
		RegisterSignal(user, COMSIG_LIVING_FLAMER_CROSSED, PROC_REF(flamer_fire_callback))
	..()

/// This proc is solely so that IgniteMob() fails
/obj/item/clothing/suit/storage/marine/M35/proc/fire_shield_is_on(mob/living/user)
	SIGNAL_HANDLER

	if(user.fire_reagent?.fire_penetrating)
		return

	return COMPONENT_CANCEL_IGNITION

/obj/item/clothing/suit/storage/marine/M35/proc/flamer_fire_callback(mob/living/user, datum/reagent/burnystuff)
	SIGNAL_HANDLER

	if(burnystuff.fire_penetrating)
		return

	. = COMPONENT_NO_IGNITE
	if(shields_from_fire)
		. |= COMPONENT_NO_BURN

/obj/item/clothing/suit/storage/marine/M35/dropped(mob/user)
	if (!istype(user))
		return
	UnregisterSignal(user, list(
		COMSIG_LIVING_PREIGNITION,
		COMSIG_LIVING_FLAMER_CROSSED,
		COMSIG_LIVING_FLAMER_FLAMED,
	))
	..()
