

/obj/item/clothing/shoes/marine
	name = "\improper USCM 作战靴"
	desc = "一双美国殖民地陆战队制式黑色作战靴。"
	icon_state = "marine"
	item_state = "marine"
	armor_melee = CLOTHING_ARMOR_MEDIUM
	armor_bullet = CLOTHING_ARMOR_MEDIUM
	armor_laser = CLOTHING_ARMOR_LOW
	armor_energy = CLOTHING_ARMOR_NONE
	armor_bomb = CLOTHING_ARMOR_MEDIUMLOW
	armor_bio = CLOTHING_ARMOR_MEDIUM
	armor_rad = CLOTHING_ARMOR_NONE
	armor_internaldamage = CLOTHING_ARMOR_MEDIUMLOW
	flags_cold_protection = BODY_FLAG_FEET
	flags_heat_protection = BODY_FLAG_FEET
	min_cold_protection_temperature = SHOE_MIN_COLD_PROT
	max_heat_protection_temperature = SHOE_MAX_HEAT_PROT
	siemens_coefficient = 0.7
	var/armor_stage = 0
	allowed_items_typecache = list(
		/obj/item/attachable/bayonet,
		/obj/item/weapon/throwing_knife,
		/obj/item/weapon/gun/pistol/holdout,
		/obj/item/weapon/gun/pistol/clfpistol,
		/obj/item/tool/screwdriver,
		/obj/item/tool/surgery/scalpel,
		/obj/item/weapon/straight_razor,
		/obj/item/weapon/knife/marine,
	)
	drop_sound = "armorequip"

/obj/item/clothing/shoes/marine/update_icon()
	if(!armor_stage)
		if(stored_item)
			icon_state = "[initial(icon_state)]-1"
		else
			icon_state = initial(icon_state)

/obj/item/clothing/shoes/marine/knife
	spawn_item_type = /obj/item/weapon/knife/marine

/obj/item/clothing/shoes/marine/brown
	icon_state = "marine_brown"
	desc = "一双美国殖民地陆战队制式棕色作战靴。"

/obj/item/clothing/shoes/marine/brown/knife
	spawn_item_type = /obj/item/weapon/knife/marine

/obj/item/clothing/shoes/marine/jungle
	icon_state = "marine_jungle"
	desc = "一双美国殖民地陆战队制式丛林靴。别慢吞吞地走，恶魔已经出笼了。"

/obj/item/clothing/shoes/marine/jungle/knife
	spawn_item_type = /obj/item/weapon/knife/marine

/obj/item/clothing/shoes/marine/army
	name = "\improper 美国陆军作战靴"
	desc = "一双美国陆军制式黑色作战靴。"

/obj/item/clothing/shoes/marine/army/knife
	spawn_item_type = /obj/item/weapon/knife/marine/baker

/obj/item/clothing/shoes/marine/upp
	name = "\improper UPP 作战靴"
	desc = "一双进步人民联盟海军步兵制式黑色作战靴。"
	spawn_item_type = /obj/item/attachable/bayonet/upp

/obj/item/clothing/shoes/marine/upp/guard
	desc = "一双进步人民联盟国土卫队制式棕色作战靴。"
	icon_state = "marine_brown"
	spawn_item_type = /obj/item/attachable/bayonet/upp

/obj/item/clothing/shoes/marine/upp/guard/canc
	spawn_item_type = /obj/item/attachable/bayonet/canc

/obj/item/clothing/shoes/marine/pve_mopp
	name = "\improper M2 MOPP 防护靴"
	desc = "M2 MOPP 防护靴能有效阻隔内脏残骸等生物污染物，让你的双脚保持洁净。"
	icon_state = "cbrn"
	item_state = "cbrn"
	armor_rad = CLOTHING_ARMOR_GIGAHIGHPLUS
	armor_bio = CLOTHING_ARMOR_GIGAHIGHPLUS

/obj/item/clothing/shoes/marine/rmc
	name = "\improper RMC 作战靴"
	desc = "一双皇家陆战突击队制式黑色作战靴。"
	icon_state = "marine"

/obj/item/clothing/shoes/marine/rmc/knife
	spawn_item_type = /obj/item/weapon/knife/marine/sas

/obj/item/clothing/shoes/marine/civilian
	name = "耐用长靴"
	desc = "一双很像军用作战靴的黑色长靴，设计灵感大概也来自军靴。无论徒步远行还是踢碎牙齿，它们都能胜任。"

/obj/item/clothing/shoes/marine/civilian/knife
	spawn_item_type = /obj/item/attachable/bayonet

/obj/item/clothing/shoes/marine/civilian/brown
	icon_state = "marine_brown"
	desc = "一双很像军用作战靴的棕色长靴，设计灵感大概也来自军靴。无论徒步远行还是踢碎牙齿，它们都能胜任。"

/obj/item/clothing/shoes/marine/civilian/jungle
	icon_state = "marine_jungle"
	desc = "一双很像军用作战靴的丛林靴，设计灵感大概也来自军靴。无论徒步远行还是踢碎牙齿，它们都能胜任。"

/obj/item/clothing/shoes/marine/joe
	name = "生物危害防护靴"
	desc = "一双实用的生物危害防护靴。"
	armor_bullet = CLOTHING_ARMOR_LOW
	armor_energy = CLOTHING_ARMOR_MEDIUMLOW
	armor_bio = CLOTHING_ARMOR_MEDIUMHIGH
	armor_rad = CLOTHING_ARMOR_MEDIUMHIGH
	armor_internaldamage = CLOTHING_ARMOR_MEDIUMLOW

/obj/item/clothing/shoes/marine/mopp
	name = "\improper M3 MOPP 防护靴"
	desc = "M2 MOPP 防护靴能有效阻隔内脏残骸等生物污染物，让你的双脚保持洁净。"
	icon_state = "cbrn"
	item_state = "cbrn"
	min_cold_protection_temperature = SHOE_MIN_COLD_PROT
	max_heat_protection_temperature = SHOE_MAX_HEAT_PROT
	flags_cold_protection = BODY_FLAG_FEET
	flags_heat_protection = BODY_FLAG_FEET
	armor_rad = CLOTHING_ARMOR_GIGAHIGHPLUS
	armor_bio = CLOTHING_ARMOR_GIGAHIGHPLUS

/obj/item/clothing/shoes/stompers
	name = "锐步践踏者运动鞋"
	desc = "一双专为鼓舞旁观者士气而设计的运动鞋。"
	icon_state = "stompers"
	flags_inventory = NOSLIPPING

/obj/item/clothing/shoes/cowboy
	name = "皮靴"
	desc = "一双皮革牛仔靴。"
	icon_state = "cowboy"

/obj/item/clothing/shoes/lizardskin
	name = "蜥蜴皮靴"
	desc = "一双蜥蜴皮牛仔靴。跳起迪斯科吧，宝贝。"
	icon_state = "lizardskin"
