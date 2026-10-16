/*
 * Science
 */

/obj/item/clothing/under/rank/rd
	desc = "由特殊纤维制成，可提供轻微的生物防护。上面的标志表明穿戴者是研究主管。"
	name = "研究主管制服"
	icon_state = "rdalt_s"
	worn_state = "rdalt_s"
	permeability_coefficient = 0.50
	armor_melee = CLOTHING_ARMOR_NONE
	armor_bullet = CLOTHING_ARMOR_NONE
	armor_laser = CLOTHING_ARMOR_NONE
	armor_energy = CLOTHING_ARMOR_NONE
	armor_bomb = CLOTHING_ARMOR_NONE
	armor_bio = CLOTHING_ARMOR_LOW
	armor_rad = CLOTHING_ARMOR_LOW
	armor_internaldamage = CLOTHING_ARMOR_LOW
	flags_jumpsuit = FALSE

/obj/item/clothing/under/rank/rdalt
	desc = "由特殊纤维制成，可提供轻微的生物防护。上面的标志表明穿戴者是研究主管。"
	name = "研究主管连体服"
	icon_state = "rdalt"
	permeability_coefficient = 0.50
	armor_melee = CLOTHING_ARMOR_NONE
	armor_bullet = CLOTHING_ARMOR_NONE
	armor_laser = CLOTHING_ARMOR_NONE
	armor_energy = CLOTHING_ARMOR_NONE
	armor_bomb = CLOTHING_ARMOR_NONE
	armor_bio = CLOTHING_ARMOR_LOW
	armor_rad = CLOTHING_ARMOR_LOW
	armor_internaldamage = CLOTHING_ARMOR_LOW
	flags_jumpsuit = FALSE

/obj/item/clothing/under/rank/scientist
	desc = "由特殊纤维制成，可提供轻微的生物防护。上面的标志表明穿戴者是科学家。"
	name = "科学家连体服"
	icon_state = "science"
	item_state = "w_suit"
	permeability_coefficient = 0.50
	armor_melee = CLOTHING_ARMOR_NONE
	armor_bullet = CLOTHING_ARMOR_NONE
	armor_laser = CLOTHING_ARMOR_NONE
	armor_energy = CLOTHING_ARMOR_NONE
	armor_bomb = CLOTHING_ARMOR_NONE
	armor_bio = CLOTHING_ARMOR_LOW
	armor_rad = CLOTHING_ARMOR_LOW
	armor_internaldamage = CLOTHING_ARMOR_LOW

/obj/item/clothing/under/rank/chemist
	desc = "由特殊纤维制成，可提供生物防护。上面有药剂师的职务条纹。"
	name = "药剂师连体服"
	icon_state = "chemistry"
	item_state = "w_suit"
	permeability_coefficient = 0.50
	armor_melee = CLOTHING_ARMOR_NONE
	armor_bullet = CLOTHING_ARMOR_NONE
	armor_laser = CLOTHING_ARMOR_NONE
	armor_energy = CLOTHING_ARMOR_NONE
	armor_bomb = CLOTHING_ARMOR_NONE
	armor_bio = CLOTHING_ARMOR_LOW
	armor_rad = CLOTHING_ARMOR_LOW
	armor_internaldamage = CLOTHING_ARMOR_LOW

/*
 * Medical
 */
/obj/item/clothing/under/rank/chief_medical_officer
	desc = "由资历足以担任“首席医疗官”的人员穿着的连体服，可提供轻微的生物防护。"
	name = "首席医疗官连体服"
	icon_state = "cmo"
	item_state = "w_suit"
	permeability_coefficient = 0.50
	armor_melee = CLOTHING_ARMOR_NONE
	armor_bullet = CLOTHING_ARMOR_NONE
	armor_laser = CLOTHING_ARMOR_NONE
	armor_energy = CLOTHING_ARMOR_NONE
	armor_bomb = CLOTHING_ARMOR_NONE
	armor_bio = CLOTHING_ARMOR_LOW
	armor_rad = CLOTHING_ARMOR_LOW
	armor_internaldamage = CLOTHING_ARMOR_LOW

/obj/item/clothing/under/rank/geneticist
	desc = "由特殊纤维制成，可提供生物防护。上面有遗传学家的职务条纹。"
	name = "遗传学家连体服"
	icon_state = "genetics"
	item_state = "w_suit"
	permeability_coefficient = 0.50
	armor_melee = CLOTHING_ARMOR_NONE
	armor_bullet = CLOTHING_ARMOR_NONE
	armor_laser = CLOTHING_ARMOR_NONE
	armor_energy = CLOTHING_ARMOR_NONE
	armor_bomb = CLOTHING_ARMOR_NONE
	armor_bio = CLOTHING_ARMOR_LOW
	armor_rad = CLOTHING_ARMOR_LOW
	armor_internaldamage = CLOTHING_ARMOR_LOW

/obj/item/clothing/under/rank/virologist
	desc = "由特殊纤维制成，可提供生物防护。上面有病毒学家的职务条纹。"
	name = "病毒学家连体服"
	icon_state = "virology"
	item_state = "w_suit"
	permeability_coefficient = 0.50
	armor_melee = CLOTHING_ARMOR_NONE
	armor_bullet = CLOTHING_ARMOR_NONE
	armor_laser = CLOTHING_ARMOR_NONE
	armor_energy = CLOTHING_ARMOR_NONE
	armor_bomb = CLOTHING_ARMOR_NONE
	armor_bio = CLOTHING_ARMOR_LOW
	armor_rad = CLOTHING_ARMOR_LOW
	armor_internaldamage = CLOTHING_ARMOR_LOW
	flags_jumpsuit = FALSE

/obj/item/clothing/under/rank/medical
	desc = "由特殊纤维制成，可提供轻微的生物防护。胸前的十字标志表明穿戴者是受过训练的医护人员。"
	name = "医生制服"
	icon_state = "medical"
	item_state = "w_suit"
	permeability_coefficient = 0.50
	armor_melee = CLOTHING_ARMOR_NONE
	armor_bullet = CLOTHING_ARMOR_NONE
	armor_laser = CLOTHING_ARMOR_NONE
	armor_energy = CLOTHING_ARMOR_NONE
	armor_bomb = CLOTHING_ARMOR_NONE
	armor_bio = CLOTHING_ARMOR_LOW
	armor_rad = CLOTHING_ARMOR_LOW
	armor_internaldamage = CLOTHING_ARMOR_LOW
	item_state_slots = list(WEAR_BODY = "medical")

/obj/item/clothing/under/rank/medical/lightblue
	name = "医用刷手服"
	desc = "由特殊纤维制成，可提供轻微的生物防护。这套是浅蓝色的。"
	icon_state = "scrubslightblue"
	flags_jumpsuit = FALSE
	item_state_slots = list(WEAR_BODY = "scrubslightblue")

/obj/item/clothing/under/rank/medical/blue
	name = "医用刷手服"
	desc = "由特殊纤维制成，可提供轻微的生物防护。这套是庄重的蓝色。"
	icon_state = "scrubsblue"
	flags_jumpsuit = FALSE
	item_state_slots = list(WEAR_BODY = "scrubsblue")

/obj/item/clothing/under/rank/medical/green
	name = "医用刷手服"
	desc = "由特殊纤维制成，可提供轻微的生物防护。这套是翡翠绿的。"
	icon_state = "scrubsgreen"
	flags_jumpsuit = FALSE
	item_state_slots = list(WEAR_BODY = "scrubsgreen")

/obj/item/clothing/under/rank/medical/purple
	name = "医用刷手服"
	desc = "由特殊纤维制成，可提供轻微的生物防护。这套是浆果红的。"
	icon_state = "scrubspurple"
	flags_jumpsuit = FALSE
	item_state_slots = list(WEAR_BODY = "scrubspurple")

/obj/item/clothing/under/rank/medical/olive
	name = "医用刷手服"
	desc = "由特殊纤维制成，可提供轻微的生物防护。这套是橄榄绿的。"
	icon_state = "scrubsolive"
	flags_jumpsuit = FALSE
	item_state_slots = list(WEAR_BODY = "scrubsolive")

/obj/item/clothing/under/rank/medical/grey
	name = "医用刷手服"
	desc = "由特殊纤维制成，可提供轻微的生物防护。这套是普通的灰色。"
	icon_state = "scrubsgrey"
	flags_jumpsuit = FALSE
	item_state_slots = list(WEAR_BODY = "scrubsgrey")

/obj/item/clothing/under/rank/medical/orange
	name = "医用刷手服"
	desc = "由特殊纤维制成，可提供轻微的生物防护。这套是囚服橙的。"
	icon_state = "scrubsorange"
	flags_jumpsuit = FALSE
	item_state_slots = list(WEAR_BODY = "scrubsorange")

/obj/item/clothing/under/rank/psych
	desc = "一套普通的白色连体服。青绿色标志表明穿戴者是精神科医生。"
	name = "精神科医生连体服"
	icon_state = "psych"
	item_state = "w_suit"
	flags_jumpsuit = FALSE


/obj/item/clothing/under/rank/psych/turtleneck
	desc = "一件青绿色高领衫，搭配深蓝色休闲裤，属于一位心理学家。"
	name = "心理学家高领衫"
	icon_state = "psychturtle"
	item_state = "b_suit"
	flags_jumpsuit = FALSE
