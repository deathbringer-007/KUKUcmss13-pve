/obj/item/clothing/mask/muzzle
	name = "口枷"
	desc = "让那难听的声音停下来。"
	icon_state = "muzzle"
	item_state = "muzzle"
	flags_inventory = COVERMOUTH
	flags_armor_protection = 0
	w_class = SIZE_SMALL
	gas_transfer_coefficient = 0.90

/obj/item/clothing/mask/surgical
	name = "无菌口罩"
	desc = "用于帮助阻止疾病传播的无菌口罩。"
	icon_state = "sterile"
	item_state = "sterile"
	w_class = SIZE_SMALL
	flags_inventory = COVERMOUTH
	flags_armor_protection = 0
	gas_transfer_coefficient = 0.90
	permeability_coefficient = 0.3
	armor_melee = CLOTHING_ARMOR_NONE
	armor_bullet = CLOTHING_ARMOR_NONE
	armor_laser = CLOTHING_ARMOR_NONE
	armor_energy = CLOTHING_ARMOR_NONE
	armor_bomb = CLOTHING_ARMOR_NONE
	armor_bio = CLOTHING_ARMOR_NONE
	armor_rad = CLOTHING_ARMOR_NONE
	armor_internaldamage = CLOTHING_ARMOR_NONE

/obj/item/clothing/mask/fakemoustache
	name = "假胡子"
	desc = "警告：胡子是假的。"
	icon_state = "fake-moustache"
	flags_inv_hide = HIDEFACE
	flags_armor_protection = 0

/obj/item/clothing/mask/snorkel
	name = "浮潜呼吸管"
	desc = "游泳高手的装备。"
	icon_state = "snorkel"
	flags_inv_hide = HIDEFACE
	flags_armor_protection = 0

/obj/item/clothing/mask/pig
	name = "猪脸面具"
	desc = "一副橡胶猪脸面具。"
	icon_state = "pig"
	item_state = "pig"
	flags_inventory = COVERMOUTH|COVEREYES
	flags_inv_hide = HIDEFACE|HIDEALLHAIR|HIDEEYES|HIDEEARS
	w_class = SIZE_SMALL
	siemens_coefficient = 0.9
	flags_armor_protection = BODY_FLAG_HEAD|BODY_FLAG_FACE|BODY_FLAG_EYES

/obj/item/clothing/mask/balaclava
	name = "头套"
	desc = "一顶普通的单孔头套，几乎所有体育用品店、户外用品店和军品店都有出售。它既能遮住脸，也能很好地抵御寒冷。这顶是标准黑色款。"
	icon_state = "balaclava"
	item_state = "balaclava"
	flags_inventory = COVERMOUTH|ALLOWREBREATH|ALLOWCPR
	flags_inv_hide = HIDEFACE|HIDEALLHAIR
	flags_cold_protection = BODY_FLAG_HEAD
	min_cold_protection_temperature = ICE_PLANET_MIN_COLD_PROT
	w_class = SIZE_SMALL

/obj/item/clothing/mask/balaclava/tactical
	name = "绿色头套"
	desc = "一顶普通的单孔头套，几乎所有体育用品店、户外用品店和军品店都有出售。它既能遮住脸，也能很好地抵御寒冷。这顶是非标准绿色款。"
	icon_state = "swatclava"
	item_state = "swatclava"

/obj/item/clothing/mask/balaclava/threehole
	name = "三孔头套"
	desc = "称职的爪牙、打手、暴徒和恶棍都会首选这种头套。"
	icon_state = "balaclava_threehole"
	item_state = "balaclava_threehole"
	flags_inventory = ALLOWREBREATH|ALLOWCPR

/obj/item/clothing/mask/luchador
	name = "墨西哥摔角面具"
	desc = "强健的摔角手戴着它高高跃起，击败敌人！"
	icon_state = "luchag"
	item_state = "luchag"
	flags_inv_hide = HIDEFACE|HIDEALLHAIR
	flags_armor_protection = BODY_FLAG_HEAD|BODY_FLAG_FACE
	w_class = SIZE_SMALL
	siemens_coefficient = 3

/obj/item/clothing/mask/luchador/tecnicos
	name = "正派摔角面具"
	desc = "坚持正义、光明磊落的强健摔角手佩戴的面具。"
	icon_state = "luchador"
	item_state = "luchador"

/obj/item/clothing/mask/luchador/rudos
	name = "反派摔角面具"
	desc = "为求胜利不择手段的强健摔角手佩戴的面具。"
	icon_state = "luchar"
	item_state = "luchar"
