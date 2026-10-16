/datum/character_trait_group/biology
	trait_group_name = "生理特征"

/datum/character_trait/biology
	applyable = FALSE
	trait_group = /datum/character_trait_group/biology

/datum/character_trait/biology/bad_eyesight
	trait_name = "近视"
	trait_desc = "近处的物体看得清，远处的物体却很模糊。"
	applyable = TRUE
	cost = 1

/datum/character_trait/biology/bad_eyesight/apply_trait(mob/living/carbon/human/target)
	..()
	ENABLE_BITFIELD(target.disabilities, NEARSIGHTED)

/datum/character_trait/biology/bad_eyesight/unapply_trait(mob/living/carbon/human/target)
	..()
	DISABLE_BITFIELD(target.disabilities, NEARSIGHTED)

/datum/character_trait/biology/opiate_receptor_deficiency
	trait_name = "阿片受体功能不足"
	trait_desc = "由于阿片类药物滥用或遗传因素，所有基础止痛药对你的效力均有所降低。"
	applyable = TRUE
	cost = 1

/datum/character_trait/biology/opiate_receptor_deficiency/apply_trait(mob/living/carbon/human/target)
	..()
	ENABLE_BITFIELD(target.disabilities, OPIATE_RECEPTOR_DEFICIENCY)

/datum/character_trait/biology/opiate_receptor_deficiency/unapply_trait(mob/living/carbon/human/target)
	..()
	DISABLE_BITFIELD(target.disabilities, OPIATE_RECEPTOR_DEFICIENCY)

/datum/character_trait/biology/lisp
	trait_name = "口齿不清"
	trait_desc = "你难以清楚发出S及类似的音。做好被无情嘲笑的准备。"
	applyable = TRUE
	cost = 1
	/// Roles that will not allow the trait to be added
	var/list/inapplicable_roles = list(JOB_COMMAND_ROLES_LIST)
	/// Species that will not allow the trait to be added.
	var/list/inapplicable_species = list(SPECIES_SYNTHETIC) // Let's let predators lisp if they reaaaally want to.
	/// Maximum rank at which you can have this trait.
	var/maximum_ranking = 4 // Nothing above this. Lisping makes you hard to understand - bad for pretty much any role that requires you to communicate. Marines get away with it though.

/datum/character_trait/biology/lisp/apply_trait(mob/living/carbon/human/target, datum/equipment_preset/preset)
	var/string_paygrade = preset.load_rank(target)
	var/datum/paygrade/paygrade_datum = GLOB.paygrades[string_paygrade]
	if(paygrade_datum?.ranking > maximum_ranking)
		to_chat(target, SPAN_WARNING("你的军衔过高，无法选择口齿不清特征。"))
		return
	if(target.job in inapplicable_roles)
		to_chat(target, SPAN_WARNING("你的职位过高，无法选择口齿不清特征。"))
		return
	if(target.species.group in inapplicable_species)
		to_chat(target, SPAN_WARNING("你的物种太过精密，无法选择口齿不清特征。"))
		return

	ADD_TRAIT(target, TRAIT_LISPING, ROUNDSTART_TRAIT)
	..()

/datum/character_trait/biology/lisp/unapply_trait(mob/living/carbon/human/target)
	REMOVE_TRAIT(target, TRAIT_LISPING, ROUNDSTART_TRAIT)
	..()

/datum/character_trait/biology/bad_leg
	trait_name = "腿疾"
	trait_desc = "你的左腿（若左腿是义肢则为右腿）曾受过不明旧伤，至今未能痊愈。不用手杖行走最终会让你疼得动弹不得，不过你开局就有一根手杖。"
	applyable = TRUE
	cost = 1
	/// Roles that will not allow the trait to be added. (Due to being designed for combat, heavy physical duty, or just being too junior to be worth keeping around as a cripple.)
	var/list/inapplicable_roles
	/// Roles that get the shitty wooden pole.
	var/list/bad_cane_roles
	/// Roles that get the fancy cane.
	var/list/fancy_cane_roles
	/// Species that will not allow the trait to be added.
	var/list/inapplicable_species

/datum/character_trait/biology/bad_leg/New()
	. = ..()
	// Not on definition as several lists are added
	inapplicable_roles = list(JOB_CAS_PILOT, JOB_DROPSHIP_PILOT, JOB_DROPSHIP_CREW_CHIEF, JOB_TANK_CREW, JOB_INTEL, JOB_ORDNANCE_TECH, JOB_MARINE) + JOB_SQUAD_ROLES_LIST + JOB_MARINE_RAIDER_ROLES_LIST + JOB_ERT_GRUNT_LIST
	bad_cane_roles = list(JOB_SURVIVOR, JOB_STOWAWAY)
	fancy_cane_roles = list(JOB_CO_SURVIVOR, CORPORATE_SURVIVOR, JOB_CMO, JOB_CORPORATE_LIAISON, JOB_DI, JOB_CHIEF_ENGINEER) + JOB_COMMAND_ROLES_LIST
	inapplicable_species = list(SPECIES_SYNTHETIC, SPECIES_YAUTJA)

/datum/character_trait/biology/bad_leg/apply_trait(mob/living/carbon/human/target, datum/equipment_preset/preset)
	if(target.job in inapplicable_roles)
		to_chat(target, SPAN_WARNING("你的职位需要承担太多战斗任务，无法选择腿疾特征。"))
		return
	if(target.species.group in inapplicable_species)
		to_chat(target, SPAN_WARNING("你的物种太过精密，无法选择腿疾特征。"))
		return

	target.AddComponent(/datum/component/bad_leg)

	var/cane_type = /obj/item/weapon/pole/wooden_cane
	if(target.job in bad_cane_roles)
		cane_type = /obj/item/weapon/pole // todo - add some sort of override for corporate liaison/director/etc survivors
	if(target.job in fancy_cane_roles)
		cane_type = /obj/item/weapon/pole/fancy_cane

	var/obj/item/weapon/pole/cane = new cane_type(target.loc)

	var/success = target.equip_to_slot_if_possible(cane, WEAR_L_HAND)
	if(!success)
		success = target.equip_to_slot_if_possible(cane, WEAR_R_HAND)

	..()

//datum/character_trait/biology/bad_leg/unapply_trait(mob/living/carbon/human/target) // IMPOSSIBLE

/datum/character_trait/biology/hardcore
	trait_name = "硬核"
	trait_desc = "一条命，一次机会。（仅限步枪兵）"
	applyable = TRUE
	cost = 1

/datum/character_trait/biology/hardcore/apply_trait(mob/living/carbon/human/target, datum/equipment_preset/preset)
	if(target.job != JOB_SQUAD_MARINE)
		to_chat(target, SPAN_WARNING("只有步枪兵可以选择硬核特征。"))
		return

	ADD_TRAIT(target, TRAIT_HARDCORE, ROUNDSTART_TRAIT)
	..()

/datum/character_trait/biology/hardcore/unapply_trait(mob/living/carbon/human/target)
	REMOVE_TRAIT(target, TRAIT_HARDCORE, ROUNDSTART_TRAIT)
	..()

/datum/character_trait/biology/iron_teeth
	trait_name = "铁齿"
	trait_desc = "你有一口铁齿，或者买了极好的牙科保险。倒地时，面部栏位的物品不会掉落。"
	applyable = TRUE
	cost = 1

/datum/character_trait/biology/iron_teeth/apply_trait(mob/living/carbon/human/target, datum/equipment_preset/preset)
	ADD_TRAIT(target, TRAIT_IRON_TEETH, ROUNDSTART_TRAIT)
	..()

/datum/character_trait/biology/iron_teeth/unapply_trait(mob/living/carbon/human/target)
	REMOVE_TRAIT(target, TRAIT_IRON_TEETH, ROUNDSTART_TRAIT)
	..()
