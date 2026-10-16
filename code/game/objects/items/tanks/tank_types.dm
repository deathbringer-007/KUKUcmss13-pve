/* Types of tanks!
 * Contains:
 * Oxygen
 * Anesthetic
 * Air
 * Phoron
 * Emergency Oxygen
 */

/*
 * Oxygen
 */
/obj/item/tank/oxygen
	name = "氧气瓶"
	desc = "一瓶氧气。"
	icon_state = "oxygen"
	distribute_pressure = ONE_ATMOSPHERE*O2STANDARD
	gas_type = GAS_TYPE_OXYGEN



/obj/item/tank/oxygen/yellow
	desc = "一瓶氧气，瓶身是黄色的。"
	icon_state = "oxygen_f"

/obj/item/tank/oxygen/red
	desc = "一瓶氧气，瓶身是红色的。"
	icon_state = "oxygen_fr"


/*
 * Anesthetic
 */
/obj/item/tank/anesthetic
	name = "麻醉气体瓶"
	desc = "装有一氧化二氮与氧气混合气体的气瓶。"
	icon_state = "anesthetic"
	item_state = "anesthetic"
	gas_type = GAS_TYPE_N2O


/*
 * Air
 */
/obj/item/tank/air
	name = "空气瓶"
	desc = "有人要来点混合气体吗？"
	icon_state = "oxygen"

/*
 * Emergency Oxygen
 */
/obj/item/tank/emergency_oxygen
	name = "应急氧气瓶"
	desc = "用于紧急情况。内含的氧气很少，请留到真正需要时再使用。"
	icon_state = "emergency"
	flags_atom = FPRINT|CONDUCT
	flags_equip_slot = SLOT_WAIST
	w_class = SIZE_TINY
	force = 4
	distribute_pressure = ONE_ATMOSPHERE*O2STANDARD
	volume = 2 //Tiny. Real life equivalents only have 21 breaths of oxygen in them. They're EMERGENCY tanks anyway -errorage (dangercon 2011)
	gas_type = GAS_TYPE_OXYGEN
	pressure = 3*ONE_ATMOSPHERE
	pressure_full = 3*ONE_ATMOSPHERE

/obj/item/tank/emergency_oxygen/get_examine_text(mob/user)
	. = ..()
	if(pressure < 50 && loc==user)
		. += SPAN_DANGER("[src]的仪表显示气体即将耗尽！")

/obj/item/tank/emergency_oxygen/engi
	name = "增容型应急氧气瓶"
	icon_state = "emergency_engi"
	volume = 6
	pressure = 5*ONE_ATMOSPHERE
	pressure_full = 5*ONE_ATMOSPHERE

/obj/item/tank/emergency_oxygen/double
	name = "双联应急氧气瓶"
	icon_state = "emergency_double"
	volume = 10
	pressure = 5*ONE_ATMOSPHERE
	pressure_full = 5*ONE_ATMOSPHERE

/*
 * Nitrogen
 */
/obj/item/tank/nitrogen
	name = "氮气瓶"
	desc = "一瓶氮气。"
	icon_state = "oxygen_fr"
	distribute_pressure = ONE_ATMOSPHERE*O2STANDARD
	gas_type = GAS_TYPE_NITROGEN

// Phoron, used for generators.
/obj/item/tank/phoron
	name = "弗燃素瓶"
	desc = "一瓶液态弗燃素。警告：弗燃素蒸气极其危险。"
	icon_state = "phoron"
	distribute_pressure = ONE_ATMOSPHERE*O2STANDARD
	gas_type = GAS_TYPE_PHORON

/obj/item/tank/phoron/update_icon()
	. = ..()

	if(volume <= 0)
		icon_state = "phoron_empty"
	else
		icon_state = "phoron"
