
//Bartender
/obj/item/clothing/head/chefhat
	name = "厨师帽"
	desc = "厨师用来防止头发掉进食物的帽子。从食堂的饭菜来看，好像没起作用。"
	icon_state = "chefhat"
	item_state = "chefhat"
	desc = "厨房总司令的帽子。"
	siemens_coefficient = 0.9

//Captain: This probably shouldn't be space-worthy
/obj/item/clothing/head/caphat
	name = "舰长帽"
	icon_state = "captain"
	desc = "当王的感觉真好。"
	item_state = "caphat"
	siemens_coefficient = 0.9
	anti_hug = 1

//Captain: This probably shouldn't be space-worthy
/obj/item/clothing/head/helmet/cap
	name = "舰长便帽"
	desc = "戴上它似乎就会玩忽职守，令你不敢尝试。"
	icon_state = "capcap"
	flags_inventory = NO_FLAGS
	flags_inv_hide = NO_FLAGS
	flags_armor_protection = 0
	flags_cold_protection = BODY_FLAG_HEAD
	min_cold_protection_temperature = SPACE_HELMET_MIN_COLD_PROT
	siemens_coefficient = 0.9
	flags_armor_protection = 0

//Cult
/obj/item/clothing/head/cultist_hood
	name = "黑色兜帽"
	desc = "一顶包住头部的兜帽。"
	icon_state = "chaplain_hood"
	flags_inventory = COVEREYES
	flags_inv_hide = HIDEEARS|HIDEALLHAIR
	siemens_coefficient = 0.9
	flags_armor_protection = BODY_FLAG_HEAD|BODY_FLAG_EYES

	flags_cold_protection = BODY_FLAG_HEAD
	min_cold_protection_temperature = SPACE_HELMET_MIN_COLD_PROT

	armor_bio = CLOTHING_ARMOR_LOW
	armor_bomb = CLOTHING_ARMOR_LOW
	armor_bullet = CLOTHING_ARMOR_MEDIUMLOW
	armor_energy = CLOTHING_ARMOR_HARDCORE
	armor_internaldamage = CLOTHING_ARMOR_LOW
	armor_rad = CLOTHING_ARMOR_LOW
	armor_melee = CLOTHING_ARMOR_MEDIUMLOW
	armor_laser = CLOTHING_ARMOR_LOW

//Chaplain
/obj/item/clothing/head/nun_hood
	name = "修女头巾"
	desc = "这个星系里最虔诚的头饰。"
	icon_state = "nun_hood"
	flags_inventory = COVEREYES
	flags_inv_hide = HIDEEARS|HIDEALLHAIR
	siemens_coefficient = 0.9

//Mime
/obj/item/clothing/head/beret
	name = "贝雷帽"
	desc = "一顶贝雷帽，艺术家最爱的帽子。"
	icon_state = "beret"
	siemens_coefficient = 0.9
	flags_armor_protection = 0
	pickup_sound = null
	drop_sound = null

/obj/item/clothing/head/beret/black
	icon_state = "beret_black"

//Security
/obj/item/clothing/head/beret/sec
	name = "安保贝雷帽"
	desc = "缀有安保徽记的贝雷帽，适合重时尚、轻安全的安保人员。"
	icon_state = "beret_badge"
/obj/item/clothing/head/beret/sec/alt
	name = "军官贝雷帽"
	desc = "带有军官军衔徽章的藏蓝色贝雷帽，适合重时尚、轻安全的军官。"
	icon_state = "officerberet"
/obj/item/clothing/head/beret/sec/hos
	name = "军官贝雷帽"
	desc = "带有舰长徽章的藏蓝色贝雷帽，适合重时尚、轻安全的军官。"
	icon_state = "hosberet"
/obj/item/clothing/head/beret/sec/warden
	name = "典狱长贝雷帽"
	desc = "带有典狱长职衔徽章的藏蓝色贝雷帽，适合重时尚、轻安全的安保人员。"
	icon_state = "wardenberet"
/obj/item/clothing/head/beret/eng
	name = "工程贝雷帽"
	desc = "缀有工程徽记的贝雷帽，适合重时尚、轻安全的工程师。"
	icon_state = "e_beret_badge"
/obj/item/clothing/head/beret/jan
	name = "紫色贝雷帽"
	desc = "一顶很时髦的贝雷帽，尽管它是紫色的。"
	icon_state = "purpleberet"

/obj/item/clothing/head/beret/pmc
	name = "白色贝雷帽"
	desc = "有志成为佣兵领袖者的时尚巅峰，能为头部提供轻度冲击防护。"
	icon = 'icons/obj/items/clothing/cm_hats.dmi'
	icon_state = "officer_hat"
	item_icons = list(
		WEAR_HEAD = 'icons/mob/humans/onmob/head_1.dmi'
	)

//Medical
/obj/item/clothing/head/surgery
	name = "手术帽"
	desc = "外科医生做手术时戴的帽子，避免头发挠到你的内脏。"
	icon_state = "surgcap_blue"
	flags_inv_hide = HIDETOPHAIR

/obj/item/clothing/head/surgery/purple
	desc = "外科医生做手术时戴的帽子，避免头发挠到你的内脏。这顶是深紫色的。"
	icon_state = "surgcap_purple"

/obj/item/clothing/head/surgery/blue
	desc = "外科医生做手术时戴的帽子，避免头发挠到你的内脏。这顶是浅蓝色的。"
	icon_state = "surgcap_blue"

/obj/item/clothing/head/surgery/green
	desc = "外科医生做手术时戴的帽子，避免头发挠到你的内脏。这顶是深绿色的。"
	icon_state = "surgcap_green"

/obj/item/clothing/head/surgery/orange
	desc = "外科医生做手术时戴的帽子，避免头发挠到你的内脏。这顶是橙色的。"
	icon_state = "surgcap_orange"

//Detective

/obj/item/clothing/head/det_hat
	name = "礼帽"
	desc = "戴上它的人会显得很精明。"
	icon_state = "detective"
	allowed = list(/obj/item/reagent_container/food/snacks/candy_corn, /obj/item/tool/pen)
	armor_melee = CLOTHING_ARMOR_MEDIUM
	armor_bullet = CLOTHING_ARMOR_LOW
	armor_laser = CLOTHING_ARMOR_LOW
	armor_energy = CLOTHING_ARMOR_LOW
	armor_bomb = CLOTHING_ARMOR_LOW
	armor_bio = CLOTHING_ARMOR_LOW
	armor_rad = CLOTHING_ARMOR_LOW
	armor_internaldamage = CLOTHING_ARMOR_MEDIUM
	siemens_coefficient = 0.9
	flags_armor_protection = 0

/obj/item/clothing/head/det_hat/black
	icon_state = "detective2"
