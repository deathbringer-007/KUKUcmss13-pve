/obj/item/clothing/suit/storage/labcoat
	name = "实验服"
	desc = "可抵御少量化学品泼溅的外套。"
	icon_state = "labcoat"
	item_state = "labcoat" //Is this even used for anything?
	blood_overlay_type = "coat"
	flags_armor_protection = BODY_FLAG_CHEST|BODY_FLAG_ARMS
	allowed = list(
		/obj/item/device/analyzer,
		/obj/item/stack/medical,
		/obj/item/reagent_container/dropper,
		/obj/item/reagent_container/syringe,
		/obj/item/reagent_container/hypospray,
		/obj/item/reagent_container/glass/bottle,
		/obj/item/reagent_container/glass/beaker,
		/obj/item/reagent_container/pill,
		/obj/item/storage/pill_bottle,
		/obj/item/paper,

		/obj/item/storage/fancy/cigarettes,
		/obj/item/tool/lighter,
		/obj/item/weapon/baton,
		/obj/item/restraint/handcuffs,
		/obj/item/device/binoculars,
		/obj/item/attachable/bayonet,

		/obj/item/device/flashlight,
		/obj/item/device/healthanalyzer,
		/obj/item/device/radio,
		/obj/item/tank/emergency_oxygen,
		/obj/item/tool/crowbar,
		/obj/item/tool/crew_monitor,
		/obj/item/tool/pen,
		/obj/item/storage/large_holster/machete,
		/obj/item/device/motiondetector,

	)
	armor_melee = CLOTHING_ARMOR_NONE
	armor_bullet = CLOTHING_ARMOR_NONE
	armor_laser = CLOTHING_ARMOR_NONE
	armor_energy = CLOTHING_ARMOR_NONE
	armor_bomb = CLOTHING_ARMOR_NONE
	armor_bio = CLOTHING_ARMOR_MEDIUMLOW
	armor_rad = CLOTHING_ARMOR_NONE
	armor_internaldamage = CLOTHING_ARMOR_LOW
	valid_accessory_slots = list(ACCESSORY_SLOT_ARMBAND, ACCESSORY_SLOT_DECOR, ACCESSORY_SLOT_MEDAL)
	restricted_accessory_slots = list(ACCESSORY_SLOT_ARMBAND)
	var/buttoned = TRUE

/obj/item/clothing/suit/storage/labcoat/verb/toggle()
	set name = "扣上／解开实验服纽扣"
	set category = "物品"
	set src in usr

	if(usr.is_mob_incapacitated())
		return 0

	if(src.buttoned == TRUE)
		src.icon_state = "[initial(icon_state)]_open"
		src.buttoned = FALSE
	else
		src.icon_state = initial(icon_state) //doesn't need to be a string
		src.buttoned = TRUE
	update_clothing_icon()

/obj/item/clothing/suit/storage/labcoat/red
	name = "红色实验服"
	desc = "可抵御少量化学品泼溅的外套。这件是红色的。"
	icon_state = "red_labcoat"
	item_state = "red_labcoat"

/obj/item/clothing/suit/storage/labcoat/blue
	name = "蓝色实验服"
	desc = "可抵御少量化学品泼溅的外套。这件是蓝色的。"
	icon_state = "blue_labcoat"
	item_state = "blue_labcoat"

/obj/item/clothing/suit/storage/labcoat/purple
	name = "紫色实验服"
	desc = "可抵御少量化学品泼溅的外套。这件是紫色的。"
	icon_state = "purple_labcoat"
	item_state = "purple_labcoat"

/obj/item/clothing/suit/storage/labcoat/orange
	name = "橙色实验服"
	desc = "可抵御少量化学品泼溅的外套。这件是橙色的。"
	icon_state = "orange_labcoat"
	item_state = "orange_labcoat"

/obj/item/clothing/suit/storage/labcoat/green
	name = "绿色实验服"
	desc = "可抵御少量化学品泼溅的外套。这件是绿色的。"
	icon_state = "green_labcoat"
	item_state = "green_labcoat"

/obj/item/clothing/suit/storage/labcoat/cmo
	name = "首席医疗官实验服"
	desc = "比标准款更蓝一些。"
	icon_state = "labcoat_cmo"
	item_state = "labcoat_cmo"

/obj/item/clothing/suit/storage/labcoat/mad
	name = "疯狂博士实验服"
	desc = "穿上它，你看起来就像能把人敲晕再射进太空的家伙。"
	icon_state = "labgreen"
	item_state = "labgreen"

/obj/item/clothing/suit/storage/labcoat/genetics
	name = "遗传学家实验服"
	desc = "可抵御少量化学品泼溅的外套，肩部有蓝色条纹。"
	icon_state = "labcoat_gen"

/obj/item/clothing/suit/storage/labcoat/chemist
	name = "药剂师实验服"
	desc = "可抵御少量化学品泼溅的外套，肩部有橙色条纹。"
	icon_state = "labcoat_chem"

/obj/item/clothing/suit/storage/labcoat/virologist
	name = "病毒学家实验服"
	desc = "可抵御少量化学品泼溅的外套，生物防护能力比标准款略强，肩部有绿色条纹。"
	icon_state = "labcoat_vir"
	armor_melee = CLOTHING_ARMOR_NONE
	armor_bullet = CLOTHING_ARMOR_NONE
	armor_laser = CLOTHING_ARMOR_NONE
	armor_energy = CLOTHING_ARMOR_NONE
	armor_bomb = CLOTHING_ARMOR_NONE
	armor_bio = CLOTHING_ARMOR_MEDIUMLOW
	armor_rad = CLOTHING_ARMOR_NONE
	armor_internaldamage = CLOTHING_ARMOR_LOW

/obj/item/clothing/suit/storage/labcoat/science
	name = "科学家实验服"
	desc = "可抵御少量化学品泼溅的外套，肩部有紫色条纹。"
	icon_state = "labcoat_tox"

/obj/item/clothing/suit/storage/labcoat/officer
	//name = "Medical officer's labcoat"
	icon_state = "labcoatg"
	item_state = "labcoatg"

/obj/item/clothing/suit/storage/labcoat/researcher
	name = "研究员实验服"
	desc = "一件高品质实验服，似乎深受学者和研究人员喜爱。它有鲜明的皮革质感，激励着你去冒险。"
	icon_state = "sciencecoat"
	item_state = "sciencecoat"

/obj/item/clothing/suit/chef/classic/medical
	name = "医用围裙"
	desc = "一条普通的无菌白色围裙，适合手术，当然也适合其他医疗操作。"

/obj/item/clothing/suit/storage/snow_suit
	name = "防寒服"
	desc = "一套标准防寒服，能保护穿戴者抵御严寒。"
	icon = 'icons/obj/items/clothing/suits.dmi'
	icon_state = "snowsuit"
	flags_armor_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_ARMS
	flags_cold_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_ARMS|BODY_FLAG_LEGS
	armor_melee = CLOTHING_ARMOR_MEDIUMLOW
	armor_bullet = CLOTHING_ARMOR_MEDIUMLOW
	armor_laser = CLOTHING_ARMOR_LOW
	armor_energy = CLOTHING_ARMOR_LOW
	armor_bomb = CLOTHING_ARMOR_NONE
	armor_bio = CLOTHING_ARMOR_MEDIUM
	armor_rad = CLOTHING_ARMOR_NONE
	armor_internaldamage = CLOTHING_ARMOR_LOW
	min_cold_protection_temperature = ICE_PLANET_MIN_COLD_PROT
	blood_overlay_type = "armor"
	siemens_coefficient = 0.7
	valid_accessory_slots = list(ACCESSORY_SLOT_DECOR, ACCESSORY_SLOT_MEDAL)

/obj/item/clothing/suit/storage/snow_suit/doctor
	name = "医生防寒服"

/obj/item/clothing/suit/storage/snow_suit/synth
	name = "合成人防寒服"
	desc = "专为极寒环境设计的防寒服，可使合成人维持在合适的温度范围内，避免供电效率下降。随着合成人隔热技术的进步，大多数寒冷环境已无需使用它。"
	armor_melee = CLOTHING_ARMOR_NONE //no free armor for synths
	armor_bullet = CLOTHING_ARMOR_NONE
	armor_laser = CLOTHING_ARMOR_NONE
	armor_energy = CLOTHING_ARMOR_NONE
	armor_bio = CLOTHING_ARMOR_NONE
	armor_internaldamage = CLOTHING_ARMOR_NONE
	allowed = list(
		/obj/item/weapon/gun/,
		/obj/item/storage/fancy/cigarettes,
		/obj/item/tool/lighter,
		/obj/item/weapon/baton,
		/obj/item/restraint/handcuffs,
		/obj/item/device/binoculars,
		/obj/item/attachable/bayonet,
		/obj/item/storage/belt/gun/m4a3,
		/obj/item/storage/belt/gun/m44,
		/obj/item/storage/belt/gun/mateba,
		/obj/item/storage/belt/gun/smartpistol,

		/obj/item/device/flashlight,
		/obj/item/device/healthanalyzer,
		/obj/item/device/radio,
		/obj/item/tank/emergency_oxygen,
		/obj/item/tool/crowbar,
		/obj/item/tool/crew_monitor,
		/obj/item/tool/pen,
		/obj/item/storage/large_holster/machete,
		/obj/item/device/motiondetector,
	)

/obj/item/clothing/suit/storage/snow_suit/survivor
	name = "加固防寒服"
	icon_state = "snowsuit" //needs new cool sprite
	desc = "一套能抵御严寒的防寒服。这件似乎经过了一些改装，既能收纳枪支，也能放下弹匣。"
	armor_melee = CLOTHING_ARMOR_MEDIUMLOW
	armor_bullet = CLOTHING_ARMOR_MEDIUM
	armor_laser = CLOTHING_ARMOR_LOW
	armor_energy = CLOTHING_ARMOR_LOW
	armor_bomb = CLOTHING_ARMOR_NONE
	armor_bio = CLOTHING_ARMOR_MEDIUM
	armor_rad = CLOTHING_ARMOR_NONE
	armor_internaldamage = CLOTHING_ARMOR_LOW
	flags_armor_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_ARMS
	allowed = list(
		/obj/item/weapon/gun,
		/obj/item/tank/emergency_oxygen,
		/obj/item/device/flashlight,
		/obj/item/ammo_magazine,
		/obj/item/explosive/grenade,
		/obj/item/device/binoculars,
		/obj/item/attachable/bayonet,
		/obj/item/storage/large_holster/machete,
		/obj/item/weapon/baseballbat,
		/obj/item/weapon/baseballbat/metal,
		/obj/item/device/motiondetector,
		/obj/item/device/walkman,
	)

/obj/item/clothing/suit/storage/snow_suit/survivor/Initialize()
	. = ..()
	pockets.max_w_class = SIZE_SMALL //Can contain small items AND rifle magazines.
	pockets.bypass_w_limit = list(
		/obj/item/ammo_magazine/rifle,
		/obj/item/ammo_magazine/smg,
		/obj/item/ammo_magazine/sniper,
	)
	pockets.max_storage_space = 8

/obj/item/clothing/suit/storage/snow_suit/survivor/parka
	name = "Parent Parka"
	desc = "一件抵御极地荒漠严寒的冬季大衣。维兰德-汤谷牌派克大衣。"

/obj/item/clothing/suit/storage/snow_suit/survivor/parka/red
	name = "安保派克大衣"
	icon_state = "redpark"

/obj/item/clothing/suit/storage/snow_suit/survivor/parka/navy
	name = "海军蓝派克大衣"
	icon_state = "navypark"

/obj/item/clothing/suit/storage/snow_suit/survivor/parka/yellow
	name = "黄色派克大衣"
	icon_state = "yellowpark"

/obj/item/clothing/suit/storage/snow_suit/survivor/parka/green
	name = "绿色派克大衣"
	icon_state = "greenpark"

/obj/item/clothing/suit/storage/snow_suit/survivor/parka/purple
	name = "紫色派克大衣"
	icon_state = "purplepark"

/obj/item/clothing/suit/storage/snow_suit/soviet
	name = "苏式防寒大衣"
	desc = "一件产自某颗荒凉冰雪星球的冬季大衣，使用当地野生动物的毛皮制作。这些动物为进步人民联盟的伟大事业献出了皮毛！"
	icon_state = "sovietcoat"
	item_state = "sovietcoat"
	flags_armor_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_ARMS
	flags_cold_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_ARMS|BODY_FLAG_LEGS
	armor_melee = CLOTHING_ARMOR_MEDIUM
	armor_bullet = CLOTHING_ARMOR_MEDIUM
	armor_laser = CLOTHING_ARMOR_LOW
	armor_energy = CLOTHING_ARMOR_LOW
	armor_bomb = CLOTHING_ARMOR_NONE
	armor_bio = CLOTHING_ARMOR_MEDIUM
	armor_rad = CLOTHING_ARMOR_NONE
	armor_internaldamage = CLOTHING_ARMOR_LOW
	min_cold_protection_temperature = ICE_PLANET_MIN_COLD_PROT
	blood_overlay_type = "armor"
	siemens_coefficient = 0.7
	allowed = list(
		/obj/item/weapon/gun,
		/obj/item/tank/emergency_oxygen,
		/obj/item/device/flashlight,
		/obj/item/ammo_magazine,
		/obj/item/explosive/grenade,
		/obj/item/device/binoculars,
		/obj/item/attachable/bayonet,
		/obj/item/storage/large_holster/machete,
		/obj/item/weapon/baseballbat,
		/obj/item/weapon/baseballbat/metal,
		/obj/item/device/motiondetector,
		/obj/item/device/walkman,
	)

/obj/item/clothing/suit/storage/snow_suit/liaison
	name = "联络员冬季大衣"
	desc = "一件维兰德-汤谷冬季大衣，让联络员在寒冷环境中享受最好的舒适感。"
	icon_state = "snowsuit_liaison"

/obj/item/clothing/suit/storage/snow_suit/liaison/modified
	name = "改装联络员冬季大衣"
	desc = "一件维兰德-汤谷冬季大衣，经过改装，可以收纳枪支和其他物品。让在寒冷敌对环境中求生的联络员享受最好的舒适性与实用性。"
	allowed = list(
		/obj/item/weapon/gun,
		/obj/item/tank/emergency_oxygen,
		/obj/item/device/flashlight,
		/obj/item/ammo_magazine,
		/obj/item/explosive/grenade,
		/obj/item/device/binoculars,
		/obj/item/attachable/bayonet,
		/obj/item/storage/large_holster/machete,
		/obj/item/weapon/baseballbat,
		/obj/item/weapon/baseballbat/metal,
		/obj/item/device/motiondetector,
		/obj/item/device/walkman,
	)
