/*
 * Contains:
 * Security
 * Detective
 * Head of Security
 */

/*
 * Security
 */
/obj/item/clothing/under/rank/warden
	desc = "采用比普通连体服稍坚固的材料，提供更可靠的防护。肩部写着“典狱长”。"
	name = "典狱长连体服"
	icon_state = "warden"
	item_state = "r_suit"
	armor_melee = CLOTHING_ARMOR_LOW
	armor_bullet = CLOTHING_ARMOR_LOW
	armor_laser = CLOTHING_ARMOR_NONE
	armor_energy = CLOTHING_ARMOR_NONE
	armor_bomb = CLOTHING_ARMOR_NONE
	armor_bio = CLOTHING_ARMOR_NONE
	armor_rad = CLOTHING_ARMOR_NONE
	armor_internaldamage = CLOTHING_ARMOR_LOW
	siemens_coefficient = 0.9

/obj/item/clothing/under/rank/security
	name = "安保人员连体服"
	desc = "采用比普通连体服稍坚固的材料，提供可靠的防护。"
	icon_state = "security"
	item_state = "r_suit"
	armor_melee = CLOTHING_ARMOR_LOW
	armor_bullet = CLOTHING_ARMOR_LOW
	armor_laser = CLOTHING_ARMOR_NONE
	armor_energy = CLOTHING_ARMOR_NONE
	armor_bomb = CLOTHING_ARMOR_NONE
	armor_bio = CLOTHING_ARMOR_NONE
	armor_rad = CLOTHING_ARMOR_NONE
	armor_internaldamage = CLOTHING_ARMOR_LOW
	siemens_coefficient = 0.9
	flags_jumpsuit = FALSE

/obj/item/clothing/under/rank/dispatch
	name = "调度员制服"
	desc = "一件衬衫配卡其裤，上面缝有安保臂章。"
	icon_state = "dispatch"
	armor_melee = CLOTHING_ARMOR_LOW
	armor_bullet = CLOTHING_ARMOR_LOW
	armor_laser = CLOTHING_ARMOR_NONE
	armor_energy = CLOTHING_ARMOR_NONE
	armor_bomb = CLOTHING_ARMOR_NONE
	armor_bio = CLOTHING_ARMOR_NONE
	armor_rad = CLOTHING_ARMOR_NONE
	armor_internaldamage = CLOTHING_ARMOR_LOW
	flags_armor_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_LEGS
	siemens_coefficient = 0.9
	flags_jumpsuit = FALSE

/obj/item/clothing/under/rank/security2
	name = "安保人员制服"
	desc = "采用稍坚固的材料，提供可靠的防护。"
	icon_state = "redshirt2"
	item_state = "r_suit"
	armor_melee = CLOTHING_ARMOR_LOW
	armor_bullet = CLOTHING_ARMOR_LOW
	armor_laser = CLOTHING_ARMOR_NONE
	armor_energy = CLOTHING_ARMOR_NONE
	armor_bomb = CLOTHING_ARMOR_NONE
	armor_bio = CLOTHING_ARMOR_NONE
	armor_rad = CLOTHING_ARMOR_NONE
	armor_internaldamage = CLOTHING_ARMOR_LOW
	siemens_coefficient = 0.9
	flags_jumpsuit = FALSE

/obj/item/clothing/under/rank/security/corp
	icon_state = "sec_corporate"
	flags_jumpsuit = FALSE

/obj/item/clothing/under/rank/warden/corp
	icon_state = "warden_corporate"
	flags_jumpsuit = FALSE

/obj/item/clothing/under/tactical
	name = "战术连体服"
	desc = "采用比普通连体服稍坚固的材料，提供可靠的防护。"
	icon_state = "swatunder"
	armor_melee = CLOTHING_ARMOR_LOW
	armor_bullet = CLOTHING_ARMOR_LOW
	armor_laser = CLOTHING_ARMOR_NONE
	armor_energy = CLOTHING_ARMOR_NONE
	armor_bomb = CLOTHING_ARMOR_NONE
	armor_bio = CLOTHING_ARMOR_NONE
	armor_rad = CLOTHING_ARMOR_NONE
	armor_internaldamage = CLOTHING_ARMOR_LOW
	siemens_coefficient = 0.9

/*
 * Detective
 */
/obj/item/clothing/under/det
	name = "旧西装"
	desc = "穿这套衣服的人可不是闹着玩的。"
	icon_state = "detective"
	item_state = "det"
	armor_melee = CLOTHING_ARMOR_LOW
	armor_bullet = CLOTHING_ARMOR_LOW
	armor_laser = CLOTHING_ARMOR_NONE
	armor_energy = CLOTHING_ARMOR_NONE
	armor_bomb = CLOTHING_ARMOR_NONE
	armor_bio = CLOTHING_ARMOR_NONE
	armor_rad = CLOTHING_ARMOR_NONE
	armor_internaldamage = CLOTHING_ARMOR_LOW
	siemens_coefficient = 0.9

/obj/item/clothing/under/det/black
	icon_state = "detective2"

/obj/item/clothing/under/det/slob
	icon_state = "polsuit"
	flags_jumpsuit = UNIFORM_SLEEVE_ROLLABLE


/*
 * Navy uniforms
 */

/obj/item/clothing/under/rank/security/navyblue
	name = "安保人员制服"
	desc = "安保服装的最新时尚款。"
	icon_state = "officerblueclothes"
	item_state = "officerblueclothes"
	flags_jumpsuit = FALSE

/obj/item/clothing/under/rank/head_of_security/navyblue
	desc = "制服上的徽章表明它属于安保主管。"
	name = "安保主管制服"
	icon_state = "hosblueclothes"
	item_state = "hosblueclothes"
	flags_jumpsuit = FALSE

/obj/item/clothing/under/rank/warden/navyblue
	desc = "制服上的徽章表明它属于典狱长。"
	name = "典狱长制服"
	icon_state = "wardenblueclothes"
	item_state = "wardenblueclothes"
	flags_jumpsuit = FALSE
