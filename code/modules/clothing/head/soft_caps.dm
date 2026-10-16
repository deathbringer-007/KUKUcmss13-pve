/obj/item/clothing/head/soft
	name = "货运帽"
	desc = "一顶配色俗气的黄色棒球帽。"
	icon_state = "cargosoft"
	flags_inventory = COVEREYES
	item_state = "helmet"
	var/cap_color = "cargo"
	var/flipped = 0
	siemens_coefficient = 0.9
	flags_armor_protection = 0

/obj/item/clothing/head/soft/dropped()
	icon_state = "[cap_color]soft"
	flipped=0
	..()

/obj/item/clothing/head/soft/verb/flip()
	set category = "物品"
	set name = "转动帽子"
	set src in usr
	if(!usr.is_mob_incapacitated())
		src.flipped = !src.flipped
		if(src.flipped)
			icon_state = "[cap_color]soft_flipped"
			to_chat(usr, "你将帽子转到后面，反戴起来。")
		else
			icon_state = "[cap_color]soft"
			to_chat(usr, "你将帽子转回正常位置。")
		update_clothing_icon() //so our mob-overlays update

/obj/item/clothing/head/soft/red
	name = "红色便帽"
	desc = "一顶配色俗气的红色棒球帽。"
	icon_state = "redsoft"
	cap_color = "red"

/obj/item/clothing/head/soft/blue
	name = "蓝色便帽"
	desc = "一顶配色俗气的蓝色棒球帽。"
	icon_state = "bluesoft"
	cap_color = "blue"

/obj/item/clothing/head/soft/green
	name = "绿色便帽"
	desc = "一顶配色俗气的绿色棒球帽。"
	icon_state = "greensoft"
	cap_color = "green"

/obj/item/clothing/head/soft/yellow
	name = "黄色便帽"
	desc = "一顶配色俗气的黄色棒球帽。"
	icon_state = "yellowsoft"
	cap_color = "yellow"

/obj/item/clothing/head/soft/grey
	name = "灰色便帽"
	desc = "一顶配色雅致的灰色棒球帽。"
	icon_state = "greysoft"
	cap_color = "grey"

/obj/item/clothing/head/soft/orange
	name = "橙色便帽"
	desc = "一顶配色俗气的橙色棒球帽。"
	icon_state = "orangesoft"
	cap_color = "orange"

/obj/item/clothing/head/soft/mime
	name = "白色便帽"
	desc = "一顶配色俗气的白色棒球帽。"
	icon_state = "mimesoft"
	cap_color = "mime"

/obj/item/clothing/head/soft/purple
	name = "紫色便帽"
	desc = "一顶配色俗气的紫色棒球帽。"
	icon_state = "purplesoft"
	cap_color = "purple"

/obj/item/clothing/head/soft/rainbow
	name = "彩虹便帽"
	desc = "一顶色彩鲜艳的彩虹棒球帽。"
	icon_state = "rainbowsoft"
	cap_color = "rainbow"

/obj/item/clothing/head/soft/ferret
	name = "\improper 雪貂重工卡车司机帽"
	desc = "一顶卡车司机帽。自雪貂重工于 2180 年倒闭后，这种帽子正逐渐成为收藏品。"
	icon_state = "ferretsoft"
	cap_color = "ferret"
	black_market_value = 25

/obj/item/clothing/head/soft/trucker
	name = "\improper 蓝色卡车司机帽"
	desc = "一顶蓝色卡车司机帽。"
	icon_state = "truckercap_bluesoft"
	cap_color = "truckercap_blue"

/obj/item/clothing/head/soft/trucker/red
	name = "\improper 红色卡车司机帽"
	desc = "一顶红色卡车司机帽。"
	icon_state = "truckercap_redsoft"
	cap_color = "truckercap_red"

/obj/item/clothing/head/soft/sec
	name = "安保便帽"
	desc = "一顶配色雅致的红色棒球帽。"
	icon_state = "secsoft"
	cap_color = "sec"

/obj/item/clothing/head/soft/sec/corp
	name = "公司安保便帽"
	desc = "一顶采用公司配色的棒球帽。"
	icon_state = "corpsoft"
	cap_color = "corp"



//marine cap

/obj/item/clothing/head/soft/marine
	name = "陆战队中士便帽"
	desc = "采用先进防弹纤维制成的软帽，但挡不住脑袋被敲出大包。"
	icon_state = "greysoft"
	cap_color = "grey"
	armor_melee = CLOTHING_ARMOR_MEDIUMHIGH
	armor_bullet = CLOTHING_ARMOR_MEDIUMLOW
	armor_laser = CLOTHING_ARMOR_LOW
	armor_energy = CLOTHING_ARMOR_LOW
	armor_bomb = CLOTHING_ARMOR_LOW
	armor_bio = CLOTHING_ARMOR_MEDIUM
	armor_rad = CLOTHING_ARMOR_LOW
	armor_internaldamage = CLOTHING_ARMOR_MEDIUM
	flags_inventory = BLOCKSHARPOBJ

/obj/item/clothing/head/soft/marine/alpha
	name = "阿尔法小队中士便帽"
	icon_state = "redsoft"
	cap_color = "red"

/obj/item/clothing/head/soft/marine/beta
	name = "贝塔小队中士便帽"
	icon_state = "yellowsoft"
	cap_color = "yellow"

/obj/item/clothing/head/soft/marine/charlie
	name = "查理小队中士便帽"
	icon_state = "purplesoft"
	cap_color = "purple"

/obj/item/clothing/head/soft/marine/delta
	name = "德尔塔小队中士便帽"
	icon_state = "bluesoft"
	cap_color = "blue"

/obj/item/clothing/head/soft/marine/mp
	name = "陆战队宪兵中士便帽"
	icon_state = "greensoft"
	cap_color = "green"
