/obj/item/clothing/gloves/antag
	name = "可疑的手套"
	desc = "一副黑色手套，既绝缘，又能躲过" + MAIN_AI_SYSTEM + "的侦测。"
	// "[]" won't work here because it wouldn't be a constant expression

	icon_state = "black"
	item_state = "bgloves"

	siemens_coefficient = 0
	permeability_coefficient = 0.05
	flags_cold_protection = BODY_FLAG_HANDS
	min_cold_protection_temperature = GLOVES_MIN_COLD_PROT
	flags_heat_protection = BODY_FLAG_HANDS
	max_heat_protection_temperature = GLOVES_MAX_HEAT_PROT

	hide_prints = TRUE

/obj/item/clothing/gloves/antag/mob_can_equip(mob/user, slot)
	if(!skillcheckexplicit(user, SKILL_ANTAG, SKILL_ANTAG_AGENT))
		to_chat(user, SPAN_WARNING("戴上这副手套可不是明智之举！"))
		return FALSE
	. = ..()
