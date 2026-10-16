/obj/item/reagent_container/hypospray/autoinjector
	name = "因纳普罗伐林自动注射器"
	var/chemname = "inaprovaline"
	//desc = "A rapid and safe way to administer small amounts of drugs by untrained or trained personnel."
	desc = "装有因纳普罗伐林的自动注射器，可用于挽救生命。"
	icon_state = "empty"
	item_state = "empty"
	flags_atom = FPRINT
	matter = list("plastic" = 300)
	amount_per_transfer_from_this = HIGH_REAGENTS_OVERDOSE * INJECTOR_PERCENTAGE_OF_OD
	possible_transfer_amounts = null
	volume = (HIGH_REAGENTS_OVERDOSE * INJECTOR_PERCENTAGE_OF_OD) * INJECTOR_USES
	magfed = FALSE
	starting_vial = null
	transparent = FALSE
	var/uses_left = 3
	var/mixed_chem = FALSE
	var/display_maptext = FALSE
	var/maptext_label
	maptext_height = 16
	maptext_width = 16
	maptext_x = 18
	maptext_y = 3

/obj/item/reagent_container/hypospray/autoinjector/Initialize()
	. = ..()
	if(mixed_chem)
		return
	reagents.add_reagent(chemname, volume)
	if(display_maptext == TRUE)
		verbs += /obj/item/storage/pill_bottle/verb/set_maptext
	update_icon()

/obj/item/reagent_container/hypospray/autoinjector/proc/update_uses_left()
	var/UL = reagents.total_volume / amount_per_transfer_from_this
	UL = floor(UL) == UL ? UL : floor(UL) + 1
	uses_left = UL

/obj/item/reagent_container/hypospray/autoinjector/attack(mob/M, mob/user)
	if(uses_left <= 0)
		return
	. = ..()
	if(!.)
		return
	uses_left--
	update_icon()

/obj/item/reagent_container/hypospray/autoinjector/update_icon()
	overlays.Cut()
	if(uses_left)
		overlays += "[chemname]_[uses_left]"
	if((isstorage(loc) || ismob(loc)) && display_maptext)
		maptext = SPAN_LANGCHAT("[maptext_label]")
	else
		maptext = ""

/obj/item/reagent_container/hypospray/autoinjector/get_examine_text(mob/user)
	. = ..()
	if(uses_left)
		. += SPAN_NOTICE("It is currently loaded with [uses_left].")
	else
		. += SPAN_NOTICE("It is empty.")

/obj/item/reagent_container/hypospray/autoinjector/equipped()
	..()
	update_icon()

/obj/item/reagent_container/hypospray/autoinjector/on_exit_storage()
	..()
	update_icon()

/obj/item/reagent_container/hypospray/autoinjector/dropped()
	..()
	update_icon()

/obj/item/reagent_container/hypospray/autoinjector/ai_can_use(mob/living/carbon/human/user, datum/human_ai_brain/ai_brain, mob/living/carbon/human/target)
	if(!uses_left || issynth(target))
		return FALSE

	var/datum/reagent/reagent_datum = GLOB.chemical_reagents_list[chemname]

	if((target.reagents.get_reagent_amount(chemname) + amount_per_transfer_from_this) > reagent_datum.overdose)
		return FALSE

	if(skilllock != SKILL_MEDICAL_TRAINED && !skillcheck(user, SKILL_MEDICAL, skilllock))
		return FALSE

	return TRUE

/obj/item/reagent_container/hypospray/autoinjector/ai_use(mob/living/carbon/human/user, datum/human_ai_brain/ai_brain, mob/living/carbon/human/target)
	attack(target, user)

/obj/item/reagent_container/hypospray/autoinjector/tricord
	name = "广效康复嗪自动注射器"
	chemname = "tricordrazine"
	desc = "装有 3 次剂量广效康复嗪的自动注射器。这种温和的通用药物可用于治疗损伤。"
	amount_per_transfer_from_this = REAGENTS_OVERDOSE * INJECTOR_PERCENTAGE_OF_OD
	volume = (REAGENTS_OVERDOSE * INJECTOR_PERCENTAGE_OF_OD) * INJECTOR_USES
	display_maptext = TRUE
	maptext_label = "Tc"

/obj/item/reagent_container/hypospray/autoinjector/tricord/skillless
	name = "广效康复嗪 EZ 自动注射器"
	desc = "装有 3 次剂量广效康复嗪的 EZ 自动注射器。这种温和的通用药物可用于治疗损伤，无需训练即可使用。"
	icon_state = "emptyskill"
	item_state = "emptyskill"
	skilllock = SKILL_MEDICAL_DEFAULT

/obj/item/reagent_container/hypospray/autoinjector/adrenaline
	name = "肾上腺素自动注射器"
	chemname = "adrenaline"
	desc = "装有 3 次剂量肾上腺素的自动注射器。这种神经兴奋剂有助于恢复心跳。"
	amount_per_transfer_from_this = LOWM_REAGENTS_OVERDOSE * INJECTOR_PERCENTAGE_OF_OD
	volume = (LOWM_REAGENTS_OVERDOSE * INJECTOR_PERCENTAGE_OF_OD) * INJECTOR_USES
	display_maptext = TRUE
	maptext_label = "Ep"

/obj/item/reagent_container/hypospray/autoinjector/adrenaline_concentrated
	name = "浓缩肾上腺素自动注射器"
	chemname = "adrenaline_concentrated"
	desc = "装有 3 次剂量浓缩肾上腺素的自动注射器。这种兴奋剂可防止昏迷，但会给心血管系统带来严重负担。<B>警告：同一人不得注射超过两次！</B>"
	amount_per_transfer_from_this = LOWM_REAGENTS_OVERDOSE * INJECTOR_PERCENTAGE_OF_OD
	volume = (LOWM_REAGENTS_OVERDOSE * INJECTOR_PERCENTAGE_OF_OD) * INJECTOR_USES
	display_maptext = TRUE
	maptext_label = "Ad"

/obj/item/reagent_container/hypospray/autoinjector/dexalinp
	name = "强化右氧林自动注射器"
	chemname = "dexalinp"
	desc = "装有 3 次剂量强化右氧林的自动注射器，可立即为全身供氧。"
	amount_per_transfer_from_this = 1
	volume = 3
	display_maptext = TRUE
	maptext_label = "D+"

/obj/item/reagent_container/hypospray/autoinjector/dexalinp/ai_can_use(mob/living/carbon/human/user, datum/human_ai_brain/ai_brain, mob/living/carbon/human/target)
	if(target.reagents.get_reagent_amount(chemname))
		return FALSE
	return ..()

/obj/item/reagent_container/hypospray/autoinjector/chloralhydrate
	name = "anesthetic autoinjector"
	chemname = "anesthetic"
	desc = "An autoinjector loaded with 3 uses of Chloral Hydrate and Sleeping Agent. Good to quickly pacify someone, for surgery of course."
	amount_per_transfer_from_this = 10
	volume = 30
	mixed_chem = TRUE
	display_maptext = TRUE //if you want to give it a label you can, but it won't come with one by default.

/obj/item/reagent_container/hypospray/autoinjector/chloralhydrate/Initialize()
	. = ..()
	reagents.add_reagent("chloralhydrate", 1*3)
	reagents.add_reagent("stoxin", 9*3)
	update_icon()

/obj/item/reagent_container/hypospray/autoinjector/tramadol
	name = "曲马多自动注射器"
	chemname = "tramadol"
	desc = "装有 3 次剂量曲马多的自动注射器。这种较温和的止痛药对普通伤口有效。"
	amount_per_transfer_from_this = REAGENTS_OVERDOSE * INJECTOR_PERCENTAGE_OF_OD
	volume = (REAGENTS_OVERDOSE * INJECTOR_PERCENTAGE_OF_OD) * INJECTOR_USES
	display_maptext = TRUE
	maptext_label = "Tr"

/obj/item/reagent_container/hypospray/autoinjector/tramadol/skillless
	name = "曲马多 EZ 自动注射器"
	desc = "装有 3 次剂量曲马多的 EZ 自动注射器。这种较温和的止痛药对普通伤口有效，无需训练即可使用。"
	icon_state = "emptyskill"
	item_state = "emptyskill"
	skilllock = SKILL_MEDICAL_DEFAULT

/obj/item/reagent_container/hypospray/autoinjector/tramadol/skillless/one_use
	desc = "An EZ autoinjector loaded with 1 use of Tramadol, a weak but effective painkiller for normal wounds. Doesn't require any training to use."
	volume = 15
	amount_per_transfer_from_this = 15
	uses_left = 1

/obj/item/reagent_container/hypospray/autoinjector/oxycodone
	name = "羟考酮自动注射器 (EXTREME PAINKILLER)"
	chemname = "oxycodone"
	desc = "装有 3 次剂量羟考酮的自动注射器。这种强效镇痛药供危及生命时使用。"
	amount_per_transfer_from_this = MED_REAGENTS_OVERDOSE * INJECTOR_PERCENTAGE_OF_OD
	volume = (MED_REAGENTS_OVERDOSE * INJECTOR_PERCENTAGE_OF_OD) * INJECTOR_USES
	display_maptext = TRUE
	maptext_label = "Ox"

/obj/item/reagent_container/hypospray/autoinjector/kelotane
	name = "克洛坦自动注射器"
	chemname = "kelotane"
	desc = "装有 3 次剂量克洛坦的自动注射器。克洛坦是常用烧伤药。"
	amount_per_transfer_from_this = REAGENTS_OVERDOSE * INJECTOR_PERCENTAGE_OF_OD
	volume = (REAGENTS_OVERDOSE * INJECTOR_PERCENTAGE_OF_OD) * INJECTOR_USES
	display_maptext = TRUE
	maptext_label = "Kl"

/obj/item/reagent_container/hypospray/autoinjector/kelotane/skillless
	name = "克洛坦 EZ 自动注射器"
	desc = "装有 3 次剂量克洛坦的 EZ 自动注射器。克洛坦是常用烧伤药，无需训练即可使用。"
	icon_state = "emptyskill"
	item_state = "emptyskill"
	skilllock = SKILL_MEDICAL_DEFAULT

/obj/item/reagent_container/hypospray/autoinjector/kelotane/skillless/one_use
	desc = "An EZ autoinjector loaded with 1 use of Kelotane, a common burn medicine. Doesn't require any training to use."
	volume = 15
	amount_per_transfer_from_this = 15
	uses_left = 1

/obj/item/reagent_container/hypospray/autoinjector/bicaridine
	name = "比卡定自动注射器"
	chemname = "bicaridine"
	desc = "装有 3 次剂量比卡定的自动注射器。比卡定是常用的钝伤及循环系统损伤治疗药。"
	amount_per_transfer_from_this = REAGENTS_OVERDOSE * INJECTOR_PERCENTAGE_OF_OD
	volume = (REAGENTS_OVERDOSE * INJECTOR_PERCENTAGE_OF_OD) * INJECTOR_USES
	display_maptext = TRUE
	maptext_label = "Bi"

/obj/item/reagent_container/hypospray/autoinjector/bicaridine/skillless
	name = "比卡定 EZ 自动注射器"
	desc = "装有 3 次剂量比卡定的 EZ 自动注射器。比卡定是常用的钝伤及循环系统损伤治疗药，无需训练即可使用。"
	icon_state = "emptyskill"
	item_state = "emptyskill"
	skilllock = SKILL_MEDICAL_DEFAULT

/obj/item/reagent_container/hypospray/autoinjector/bicaridine/skillless/one_use
	desc = "An EZ autoinjector loaded with 1 use of Bicaridine, a common brute and circulatory damage medicine.  Doesn't require any training to use."
	volume = 15
	amount_per_transfer_from_this = 15
	uses_left = 1

/obj/item/reagent_container/hypospray/autoinjector/inaprovaline
	name = "因纳普罗伐林自动注射器"
	chemname = "inaprovaline"
	desc = "装有 3 次剂量因纳普罗伐林的自动注射器，用于紧急稳定危重患者。"
	amount_per_transfer_from_this = HIGH_REAGENTS_OVERDOSE * INJECTOR_PERCENTAGE_OF_OD
	volume = (HIGH_REAGENTS_OVERDOSE * INJECTOR_PERCENTAGE_OF_OD) * INJECTOR_USES
	display_maptext = TRUE
	maptext_label = "In"

/obj/item/reagent_container/hypospray/autoinjector/emergency
	name = "应急自动注射器 (CAUTION)"
	desc = "装有特殊复方药剂的自动注射器，供危及生命时使用，无需训练即可操作。"
	icon_state = "emptyskill"
	item_state = "emptyskill"
	chemname = "emergency"
	amount_per_transfer_from_this = (REAGENTS_OVERDOSE-1)*2 + (MED_REAGENTS_OVERDOSE-1)
	volume = (REAGENTS_OVERDOSE-1)*2 + (MED_REAGENTS_OVERDOSE-1)
	mixed_chem = TRUE
	uses_left = 1
	injectSFX = 'sound/items/air_release.ogg'
	injectVOL = 70//limited-supply emergency injector with v.large injection of drugs. Variable sfx freq sometimes rolls too quiet.
	display_maptext = TRUE //see anaesthetic injector
	maptext_label = "!!"
	skilllock = SKILL_MEDICAL_DEFAULT

/obj/item/reagent_container/hypospray/autoinjector/emergency/Initialize()
	. = ..()
	reagents.add_reagent("bicaridine", REAGENTS_OVERDOSE-1)
	reagents.add_reagent("kelotane", REAGENTS_OVERDOSE-1)
	reagents.add_reagent("oxycodone", MED_REAGENTS_OVERDOSE-1)
	update_icon()

/obj/item/reagent_container/hypospray/autoinjector/ultrazine
	name = "超能嗪自动注射器"
	chemname = "ultrazine"
	desc = "装有特殊非法肌肉兴奋剂的自动注射器，一次使用不得超过两针，极易成瘾。"
	amount_per_transfer_from_this = 5
	volume = 25
	uses_left = 5
	icon_state = "stimpack"
	item_state = "stimpack"
	skilllock = SKILL_MEDICAL_DEFAULT
	display_maptext = TRUE
	maptext_label = "UZ"

/obj/item/reagent_container/hypospray/autoinjector/ultrazine/liaison
	name = "白色自动注射器"
	desc = "老话说得好，别拿可疑针管扎自己。"
	maptext_label = "??"

/obj/item/reagent_container/hypospray/autoinjector/yautja
	name = "unusual crystal"
	chemname = "thwei"
	desc = "A strange glowing crystal with a spike at one end."
	icon = 'icons/obj/items/hunter/pred_gear.dmi'
	icon_state = "crystal"
	amount_per_transfer_from_this = REAGENTS_OVERDOSE
	volume = REAGENTS_OVERDOSE
	uses_left = 1
	black_market_value = 25

/obj/item/reagent_container/hypospray/autoinjector/yautja/attack(mob/M as mob, mob/user as mob)
	if(HAS_TRAIT(user, TRAIT_YAUTJA_TECH))
		..()
	else
		to_chat(user, SPAN_DANGER("You have no idea where to inject [src]."))

/obj/item/reagent_container/hypospray/autoinjector/skillless
	name = "急救自动注射器"
	chemname = "tricordrazine"
	desc = "装有小剂量药物的自动注射器，供陆战队员自救使用。"
	icon_state = "tricord"
	amount_per_transfer_from_this = 15
	volume = 15
	skilllock = SKILL_MEDICAL_DEFAULT
	uses_left = 1
	display_maptext = TRUE

/obj/item/reagent_container/hypospray/autoinjector/skillless/attack(mob/M as mob, mob/user as mob)
	. = ..()
	if(.)
		if(!uses_left) //Prevents autoinjectors to be refilled.
			icon_state += "0"
			name += "（已耗尽）"
			flags_atom &= ~OPENCONTAINER

/obj/item/reagent_container/hypospray/autoinjector/skillless/attackby()
	return

/obj/item/reagent_container/hypospray/autoinjector/skillless/get_examine_text(mob/user)
	. = ..()
	if(reagents && length(reagents.reagent_list))
		. += SPAN_NOTICE("It is currently loaded.")
	else if(!uses_left)
		. += SPAN_NOTICE("It is spent.")
	else
		. += SPAN_NOTICE("It is empty.")

/obj/item/reagent_container/hypospray/autoinjector/skillless/tramadol
	name = "止痛自动注射器"
	chemname = "tramadol"
	desc = "装有少量止痛药的自动注射器，供陆战队员自行使用。"
	icon_state = "tramadol"

/obj/item/reagent_container/hypospray/autoinjector/dylovene
	name = "dylovene autoinjector"
	chemname = "anti_toxin"
	desc = "An autoinjector loaded with 3 uses of Dylovene, a general-use anti-toxin."
	amount_per_transfer_from_this = LOWM_REAGENTS_OVERDOSE * INJECTOR_PERCENTAGE_OF_OD
	volume = (LOWM_REAGENTS_OVERDOSE * INJECTOR_PERCENTAGE_OF_OD) * INJECTOR_USES
	display_maptext = TRUE
	maptext_label = "Dy"

/obj/item/reagent_container/hypospray/autoinjector/dylovene/skillless
	name = "dylovene EZ autoinjector"
	desc = "An EZ autoinjector loaded with 3 uses of Dylovene, a general-use anti-toxin. Doesn't require any training to use."
	icon_state = "emptyskill"
	item_state = "emptyskill"
	skilllock = SKILL_MEDICAL_DEFAULT

/obj/item/reagent_container/hypospray/autoinjector/iron
	name = "铁自动注射器"
	chemname = "iron"
	desc = "装有 3 次剂量铁剂的自动注射器，用于恢复血容量。"
	amount_per_transfer_from_this = REAGENTS_OVERDOSE * INJECTOR_PERCENTAGE_OF_OD
	volume = (REAGENTS_OVERDOSE * INJECTOR_PERCENTAGE_OF_OD) * INJECTOR_USES
	display_maptext = TRUE
	maptext_label = "Fe"

/obj/item/reagent_container/hypospray/autoinjector/iron/skillless

	name = "iron EZ autoinjector"
	desc = "An EZ autoinjector loaded with 3 uses of iron, to restore blood volume. Doesn't require any training to use."
	icon_state = "emptyskill"
	item_state = "emptyskill"
	skilllock = SKILL_MEDICAL_DEFAULT

/obj/item/reagent_container/hypospray/autoinjector/empty
	name = "自动注射器 (C-T)"
	desc = "一支定制自动注射器，大概出自科研部门。"
	chemname = "custom"
	mixed_chem = TRUE
	amount_per_transfer_from_this = 5
	volume = 15
	uses_left = 0
	display_maptext = TRUE

/obj/item/reagent_container/hypospray/autoinjector/empty/get_examine_text(mob/user)
	. = ..()
	. += SPAN_NOTICE("It transfers [amount_per_transfer_from_this]u per injection and has a maximum of [volume/amount_per_transfer_from_this] injections.")

/obj/item/reagent_container/hypospray/autoinjector/empty/update_icon()
	overlays.Cut()
	if(uses_left)
		var/image/cust_fill = image('icons/obj/items/syringe.dmi', src, "[chemname]_[uses_left]")
		cust_fill.color = mix_color_from_reagents(reagents.reagent_list)
		overlays += cust_fill

/obj/item/reagent_container/hypospray/autoinjector/empty/small
	name = "autoinjector (C-S)"
	amount_per_transfer_from_this = 15
	volume = 45

/obj/item/reagent_container/hypospray/autoinjector/empty/medium
	name = "autoinjector (C-M)"
	amount_per_transfer_from_this = 30
	volume = 90

/obj/item/reagent_container/hypospray/autoinjector/empty/large
	name = "autoinjector (C-L)"
	amount_per_transfer_from_this = 60
	volume = 180

/obj/item/reagent_container/hypospray/autoinjector/empty/skillless
	name = "Autoinjector (E-T)"
	desc = "A custom-made EZ autoinjector, likely from research. Injects its entire payload immediately and doesn't require any training."
	chemname = "custom_ez"
	icon_state = "empty_ez"
	item_state = "empty_ez"
	skilllock = SKILL_MEDICAL_DEFAULT
	amount_per_transfer_from_this = 15
	volume = 15
	uses_left = 0

/obj/item/reagent_container/hypospray/autoinjector/empty/skillless/unit
	name = "Autoinjector (E-U)"
	volume = 1
	amount_per_transfer_from_this = 1

/obj/item/reagent_container/hypospray/autoinjector/empty/skillless/verysmall
	name = "Autoinjector (E-VS)"
	volume = 5
	amount_per_transfer_from_this = 5

/obj/item/reagent_container/hypospray/autoinjector/empty/skillless/small
	name = "Autoinjector (E-S)"
	volume = 10
	amount_per_transfer_from_this = 10

/obj/item/reagent_container/hypospray/autoinjector/empty/skillless/medium
	name = "Autoinjector (E-M)"
	volume = 30
	amount_per_transfer_from_this = 30

/obj/item/reagent_container/hypospray/autoinjector/empty/skillless/large
	name = "Autoinjector (E-L)"
	volume = 45
	amount_per_transfer_from_this = 45

/obj/item/reagent_container/hypospray/autoinjector/empty/skillless/extralarge
	name = "Autoinjector (E-XL)"
	volume = 60
	amount_per_transfer_from_this = 60

/obj/item/reagent_container/hypospray/autoinjector/empty/medic
	name = "医护自动注射器 (M-M)"
	desc = "一支定制专业注射器，大概出自科研部门。带有类似药瓶的锁定装置，最多可注射 6 次。"
	skilllock = SKILL_MEDICAL_MEDIC
	volume = 90
	amount_per_transfer_from_this = 15
	chemname = "custom_medic"
	icon_state = "empty_medic"
	item_state = "empty_medic"
	uses_left = 0

/obj/item/reagent_container/hypospray/autoinjector/empty/medic/large
	name = "Medic Autoinjector (M-L)"
	volume = 180
	amount_per_transfer_from_this = 30
