//=============================//Marine Raiders\\==================================\\
//=======================================================================\\

/obj/item/clothing/suit/storage/marine/sof
	name = "\improper 特种作战部队护甲"
	desc = "深度定制的 M3 护甲，由陆战突击队使用。"
	icon_state = "marsoc"
	armor_melee = CLOTHING_ARMOR_HIGH
	armor_bullet = CLOTHING_ARMOR_HIGH
	armor_bomb = CLOTHING_ARMOR_VERYHIGH
	armor_bio = CLOTHING_ARMOR_MEDIUMLOW
	armor_rad = CLOTHING_ARMOR_MEDIUMHIGH
	armor_internaldamage = CLOTHING_ARMOR_MEDIUMHIGH
	slowdown = SLOWDOWN_ARMOR_LIGHT
	unacidable = TRUE
	flags_atom = MOB_LOCK_ON_EQUIP|NO_CRYO_STORE|NO_SNOW_TYPE
	storage_slots = 4


//=============================//PMCs\\==================================\\
//=======================================================================\\

/obj/item/clothing/suit/storage/marine/veteran
	flags_marine_armor = ARMOR_LAMP_OVERLAY
	flags_atom = NO_SNOW_TYPE|NO_NAME_OVERRIDE //Let's make these keep their name and icon.

/obj/item/clothing/suit/storage/marine/veteran/pmc
	name = "WY 战术护甲"
	desc = "皇家陆战突击队装备选型的候选产品，目前仅由维兰德-汤谷雇佣兵进行实地测试。"
	icon_state = "pmc_armor"
	armor_bullet = CLOTHING_ARMOR_MEDIUMHIGH
	armor_energy = CLOTHING_ARMOR_MEDIUMLOW
	armor_bomb = CLOTHING_ARMOR_MEDIUM
	armor_rad = CLOTHING_ARMOR_MEDIUM
	storage_slots = 2
	slowdown = SLOWDOWN_ARMOR_LIGHT
	flags_atom = NO_SNOW_TYPE|NO_NAME_OVERRIDE
	allowed = list(
		/obj/item/weapon/gun,
		/obj/item/tank/emergency_oxygen,
		/obj/item/device/flashlight,
		/obj/item/ammo_magazine/,
		/obj/item/weapon/baton,
		/obj/item/restraint/handcuffs,
		/obj/item/storage/fancy/cigarettes,
		/obj/item/tool/lighter,
		/obj/item/explosive/grenade,
		/obj/item/storage/bible,
		/obj/item/tool/crowbar,
		/obj/item/storage/large_holster/katana,
		/obj/item/storage/large_holster/machete,
		/obj/item/storage/large_holster/m39,
		/obj/item/weapon/sword/machete,
		/obj/item/attachable/bayonet,
		/obj/item/device/motiondetector,
		/obj/item/tool/crew_monitor,
		/obj/item/storage/backpack/general_belt,
		/obj/item/storage/belt/gun/m4a3,
		/obj/item/storage/belt/gun/m44,
		/obj/item/storage/belt/gun/flaregun,
		/obj/item/device/walkman,
		/obj/item/storage/belt/gun/m39,
		/obj/item/storage/belt/gun/xm51,
	)
	item_state_slots = list(WEAR_JACKET = "pmc_armor")

/obj/item/clothing/suit/storage/marine/veteran/pmc/light
	name = "WY 轻型战术护甲"
	icon_state = "pmc_sniper"
	armor_melee = CLOTHING_ARMOR_MEDIUMLOW
	armor_bullet = CLOTHING_ARMOR_MEDIUM
	armor_energy = CLOTHING_ARMOR_MEDIUMLOW
	armor_bomb = CLOTHING_ARMOR_MEDIUMLOW
	armor_rad = CLOTHING_ARMOR_MEDIUM
	armor_internaldamage = CLOTHING_ARMOR_MEDIUMLOW
	slowdown = SLOWDOWN_ARMOR_VERY_LIGHT
	item_state_slots = list(WEAR_JACKET = "pmc_sniper")

/obj/item/clothing/suit/storage/marine/veteran/pmc/light/corporate
	name = "\improper M1 式公司安保护甲"
	desc = "右胸带维兰德-汤谷徽章的基础背心，通常由守卫公司设施的低级警卫穿戴。"
	icon = 'icons/mob/humans/onmob/contained/wy_goons.dmi'
	icon_state = "armor"
	item_state = "armor"
	item_state_slots = null
	contained_sprite = TRUE
	slowdown = SLOWDOWN_ARMOR_LIGHT

	flags_armor_protection = BODY_FLAG_CHEST
	flags_cold_protection = BODY_FLAG_CHEST
	flags_heat_protection = BODY_FLAG_CHEST

/obj/item/clothing/suit/storage/marine/veteran/pmc/light/corporate/lead
	desc = "右胸带维兰德-汤谷徽章的基础背心。这一型供因“战地表现良好”而晋升的低级警卫穿戴，也就是公司马屁精。"
	icon_state = "lead_armor"
	item_state = "lead_armor"

/obj/item/clothing/suit/storage/marine/veteran/pmc/leader
	name = "\improper M4 式私人军事公司领队护甲"
	desc = "标准阿玛特系统 M3 护甲的改型，为高级安保人员和公司雇佣兵设计。这件看起来属于高级军官。"
	icon_state = "officer_armor"
	item_state_slots = list(WEAR_JACKET = "officer_armor")

/obj/item/clothing/suit/storage/marine/veteran/pmc/light/synth
	name = "\improper M4 合成人私人军事公司护甲"
	desc = "标准阿玛特系统 M3 护甲的深度改型。专为野外私人军事公司支援单位设计，所有护甲插板均已移除，以高速救援为理念。"
	time_to_unequip = 0.5 SECONDS
	time_to_equip = 1 SECONDS
	armor_melee = CLOTHING_ARMOR_NONE
	armor_bullet = CLOTHING_ARMOR_NONE
	armor_laser = CLOTHING_ARMOR_NONE
	armor_energy = CLOTHING_ARMOR_NONE
	armor_bomb = CLOTHING_ARMOR_NONE
	armor_bio = CLOTHING_ARMOR_NONE
	armor_rad = CLOTHING_ARMOR_NONE
	armor_internaldamage = CLOTHING_ARMOR_NONE
	storage_slots = 3
	slowdown = SLOWDOWN_ARMOR_SUPER_LIGHT

/obj/item/clothing/suit/storage/marine/veteran/pmc/corporate
	name = "\improper M1 式私人军事公司领队护甲"
	desc = "标准阿玛特系统 M3 护甲的改型，为高级安保人员和公司雇佣兵设计。这件看起来属于高级军官。"
	icon_state = "officer_armor"
	item_state_slots = list(WEAR_JACKET = "officer_armor")

/obj/item/clothing/suit/storage/marine/veteran/pmc/light/synth/Initialize()
	flags_atom |= NO_NAME_OVERRIDE
	flags_marine_armor |= SYNTH_ALLOWED
	return ..()

/obj/item/clothing/suit/storage/marine/smartgunner/veteran/pmc
	name = "\improper 私人军事公司机枪手护甲"
	desc = "标准阿玛特系统 M3 护甲的改型，配有各种背带与绑带，使使用者可以携带 M56 智能机枪。"
	icon_state = "heavy_armor"
	flags_inventory = BLOCKSHARPOBJ|BLOCK_KNOCKDOWN|SMARTGUN_HARNESS
	flags_bodypart_hidden = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_ARMS|BODY_FLAG_LEGS
	flags_atom = NO_SNOW_TYPE|NO_NAME_OVERRIDE
	armor_bullet = CLOTHING_ARMOR_MEDIUMHIGH
	armor_laser = CLOTHING_ARMOR_MEDIUMLOW
	armor_energy = CLOTHING_ARMOR_MEDIUMLOW
	armor_bomb = CLOTHING_ARMOR_MEDIUM
	armor_rad = CLOTHING_ARMOR_MEDIUM
	item_state_slots = list(WEAR_JACKET = "heavy_armor")

/obj/item/clothing/suit/storage/marine/smartgunner/veteran/pmc/terminator
	name = "\improper M5Xg 外骨骼机枪手护甲"
	desc = "由重叠装甲板组成的复杂系统，旨在让穿着者几乎不受轻武器火力伤害。被动外骨骼承担护甲重量，使人类能够负担其巨大体积。这一型可支撑 M56 智能机枪。"
	icon_state = "commando_armor"
	slowdown = SLOWDOWN_ARMOR_MEDIUM
	movement_compensation = SLOWDOWN_ARMOR_VERY_HEAVY
	armor_melee = CLOTHING_ARMOR_HIGH
	armor_bullet = CLOTHING_ARMOR_ULTRAHIGH
	armor_laser = CLOTHING_ARMOR_MEDIUM
	armor_energy = CLOTHING_ARMOR_MEDIUM
	armor_bomb = CLOTHING_ARMOR_VERYHIGH
	armor_rad = CLOTHING_ARMOR_MEDIUMHIGH
	armor_internaldamage = CLOTHING_ARMOR_MEDIUMHIGH
	flags_armor_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_ARMS|BODY_FLAG_LEGS|BODY_FLAG_FEET
	item_state_slots = list(WEAR_JACKET = "commando_armor")
	unacidable = TRUE

/obj/item/clothing/suit/storage/marine/veteran/pmc/commando
	name = "\improper M5X 外骨骼护甲"
	desc = "由重叠装甲板组成的复杂系统，旨在让穿着者几乎不受轻武器火力伤害。被动外骨骼承担护甲重量，使人类能够负担其巨大体积。"
	icon_state = "commando_armor"
	slowdown = SLOWDOWN_ARMOR_MEDIUM
	movement_compensation = SLOWDOWN_ARMOR_VERY_HEAVY
	armor_melee = CLOTHING_ARMOR_VERYHIGH
	armor_bullet = CLOTHING_ARMOR_ULTRAHIGH
	armor_energy = CLOTHING_ARMOR_MEDIUM
	armor_bomb = CLOTHING_ARMOR_VERYHIGH
	armor_rad = CLOTHING_ARMOR_MEDIUMHIGH
	armor_internaldamage = CLOTHING_ARMOR_MEDIUMHIGH
	flags_inventory = BLOCK_KNOCKDOWN
	flags_armor_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_ARMS|BODY_FLAG_LEGS|BODY_FLAG_FEET
	item_state_slots = list(WEAR_JACKET = "commando_armor")
	unacidable = TRUE


//===========================//DISTRESS\\================================\\
//=======================================================================\\

/obj/item/clothing/suit/storage/marine/veteran/bear
	name = "\improper H1 铁熊背心"
	desc = "铁熊雇佣兵穿戴的防护背心。"
	icon_state = "bear_armor"
	flags_armor_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN
	armor_energy = CLOTHING_ARMOR_MEDIUMLOW
	armor_bomb = CLOTHING_ARMOR_MEDIUM
	armor_rad = CLOTHING_ARMOR_MEDIUM
	storage_slots = 2
	slowdown = SLOWDOWN_ARMOR_VERY_LIGHT

/obj/item/clothing/suit/storage/marine/veteran/dutch
	name = "\improper D2 装甲背心"
	desc = "一些身经百战的雇佣兵穿戴的防护背心。"
	icon_state = "dutch_armor"
	flags_armor_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_ARMS|BODY_FLAG_LEGS //Makes no sense but they need leg/arm armor too.
	armor_melee = CLOTHING_ARMOR_HIGH
	armor_bullet = CLOTHING_ARMOR_HIGHPLUS
	armor_energy = CLOTHING_ARMOR_MEDIUMLOW
	armor_bomb = CLOTHING_ARMOR_HIGH
	armor_rad = CLOTHING_ARMOR_MEDIUM
	storage_slots = 2
	light_range = 7
	slowdown = SLOWDOWN_ARMOR_VERY_LIGHT

/obj/item/clothing/suit/storage/marine/veteran/van_bandolier
	name = "狩猎夹克"
	desc = "精心裁制的狩猎夹克，巧妙地衬入分段装甲板。有时猎物也会还击。"
	icon_state = "van_bandolier"
	item_state = "van_bandolier_jacket"
	blood_overlay_type = "coat"
	flags_marine_armor = NO_FLAGS //No shoulder light.
	actions_types = list()
	slowdown = SLOWDOWN_ARMOR_LIGHT
	storage_slots = 2
	movement_compensation = SLOWDOWN_ARMOR_LIGHT
	allowed = list(
		/obj/item/weapon/gun,
		/obj/item/tank/emergency_oxygen,
		/obj/item/device/flashlight,
		/obj/item/storage/fancy/cigarettes,
		/obj/item/tool/lighter,
		/obj/item/storage/bible,
		/obj/item/attachable/bayonet,
		/obj/item/storage/backpack/general_belt,
		/obj/item/storage/large_holster/machete,
		/obj/item/storage/belt/gun/m4a3,
		/obj/item/storage/belt/gun/m44,
		/obj/item/storage/belt/gun/smartpistol,
		/obj/item/storage/belt/gun/flaregun,
		/obj/item/device/motiondetector,
		/obj/item/device/walkman,
		/obj/item/storage/belt/shotgun/van_bandolier,
	)

//===========================//U.P.P\\================================\\
//=====================================================================\\

/obj/item/clothing/suit/storage/marine/faction
	flags_atom = NO_SNOW_TYPE|NO_NAME_OVERRIDE
	flags_armor_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_ARMS|BODY_FLAG_LEGS
	flags_cold_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_ARMS|BODY_FLAG_LEGS
	flags_heat_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_ARMS|BODY_FLAG_LEGS
	min_cold_protection_temperature = HELMET_MIN_COLD_PROT
	max_heat_protection_temperature = HELMET_MAX_HEAT_PROT
	blood_overlay_type = "armor"
	armor_melee = CLOTHING_ARMOR_MEDIUM
	armor_bullet = CLOTHING_ARMOR_MEDIUM
	armor_laser = CLOTHING_ARMOR_MEDIUMLOW
	armor_energy = CLOTHING_ARMOR_MEDIUMLOW
	armor_bomb = CLOTHING_ARMOR_MEDIUM
	armor_bio = CLOTHING_ARMOR_MEDIUM
	armor_rad = CLOTHING_ARMOR_MEDIUM
	armor_internaldamage = CLOTHING_ARMOR_MEDIUMHIGH
	slowdown = SLOWDOWN_ARMOR_MEDIUM
	movement_compensation = SLOWDOWN_ARMOR_LIGHT

/obj/item/clothing/suit/marine/faction/UPP
	name = "6B90 式 UPP 护甲"
	desc = "联盟前线制式护甲，属于库伊亚-M 防护系统。6B90 在要害部位使用新型超轻合金护板以抵御步枪弹，防弹网衬保护躯干免受弹片和跳弹伤害。后腰的小型发射器向战术作战中心提供低分辨率音视频与生命体征数据。虽号称均码，但支撑系统很难调得舒适。"
	icon_state = "upp_armor"
	flags_atom = NO_SNOW_TYPE|NO_NAME_OVERRIDE|FPRINT|CONDUCT
	flags_armor_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_LEGS
	slowdown = SLOWDOWN_ARMOR_MEDIUM
	flags_inventory = BLOCKSHARPOBJ
	armor_melee = CLOTHING_ARMOR_MEDIUMHIGH
	armor_bullet = CLOTHING_ARMOR_MEDIUMHIGH
	armor_energy = CLOTHING_ARMOR_MEDIUM
	armor_bio = CLOTHING_ARMOR_MEDIUMLOW
	armor_rad = CLOTHING_ARMOR_HIGHPLUS
	armor_internaldamage = CLOTHING_ARMOR_MEDIUM
	flags_inventory = BLOCKSHARPOBJ
	valid_accessory_slots = list(ACCESSORY_SLOT_MEDAL, ACCESSORY_SLOT_DECORARMOR, ACCESSORY_SLOT_DECORGROIN, ACCESSORY_SLOT_DECORSHIN, ACCESSORY_SLOT_DECORBRACER, ACCESSORY_SLOT_DECORNECK, ACCESSORY_SLOT_PAINT, ACCESSORY_SLOT_M3UTILITY, ACCESSORY_SLOT_PONCHO, ACCESSORY_SLOT_DECORKNEE)
	restricted_accessory_slots = list(ACCESSORY_SLOT_DECORARMOR, ACCESSORY_SLOT_DECORGROIN, ACCESSORY_SLOT_DECORBRACER, ACCESSORY_SLOT_DECORNECK, ACCESSORY_SLOT_DECORSHIN, ACCESSORY_SLOT_M3UTILITY, ACCESSORY_SLOT_PAINT, ACCESSORY_SLOT_DECORKNEE)
	specialty = "\improper 6B90 式"

/obj/item/clothing/suit/marine/faction/UPP/standard/Initialize(mapload)
	. = ..()
	var/obj/item/clothing/accessory/upppads/legs/greaves = new()
	src.attach_accessory(null, greaves, TRUE)
	var/obj/item/clothing/accessory/upppads/crotch/crotch = new()
	src.attach_accessory(null, crotch, TRUE)

/obj/item/clothing/suit/marine/smartgunner/upp
	name = "\improper 6B91-2 进步人民联盟护甲"
	desc = "标准防弹衣的深度改型，专为联盟机枪手设计。腰背部内置紧凑型火控计算机和加密数据处理单元，并配有连接机枪的装甲电缆，满足操作武器的一切要求，但笨重是常见抱怨。"
	icon_state = "upp_armor_support"
	slowdown = SLOWDOWN_ARMOR_LOWHEAVY
	flags_atom = NO_SNOW_TYPE|NO_NAME_OVERRIDE
	flags_inventory = BLOCKSHARPOBJ|SMARTGUN_HARNESS
	flags_armor_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_LEGS
	armor_melee = CLOTHING_ARMOR_HIGH
	armor_bullet = CLOTHING_ARMOR_HIGH
	armor_laser = CLOTHING_ARMOR_MEDIUMLOW
	armor_energy = CLOTHING_ARMOR_MEDIUM
	armor_bio = CLOTHING_ARMOR_MEDIUMHIGH
	armor_rad = CLOTHING_ARMOR_MEDIUMHIGH
	armor_internaldamage = CLOTHING_ARMOR_HIGH
	valid_accessory_slots = list(ACCESSORY_SLOT_MEDAL, ACCESSORY_SLOT_DECORARMOR,ACCESSORY_SLOT_DECORSHIN, ACCESSORY_SLOT_DECORBRACER, ACCESSORY_SLOT_DECORNECK, ACCESSORY_SLOT_PAINT, ACCESSORY_SLOT_M3UTILITY, ACCESSORY_SLOT_PONCHO, ACCESSORY_SLOT_DECORKNEE)
	restricted_accessory_slots = list(ACCESSORY_SLOT_DECORARMOR,ACCESSORY_SLOT_DECORBRACER, ACCESSORY_SLOT_DECORNECK, ACCESSORY_SLOT_DECORSHIN, ACCESSORY_SLOT_M3UTILITY, ACCESSORY_SLOT_PAINT, ACCESSORY_SLOT_DECORKNEE)
	specialty = "\improper 6B91-2 式"
	allowed = list(
		/obj/item/tank/emergency_oxygen,
		/obj/item/device/flashlight,
		/obj/item/ammo_magazine,
		/obj/item/explosive/mine,
		/obj/item/attachable/bayonet,
		/obj/item/weapon/gun/pkp,
		/obj/item/storage/backpack/general_belt,
		/obj/item/device/motiondetector,
		/obj/item/device/walkman,
		/obj/item/storage/large_holster/machete,
		/obj/item/storage/belt/gun/type47,
	)

	smartgun_back = list(
		/obj/item/storage/large_holster/machete,
		/obj/item/ammo_box,
	)

/obj/item/clothing/suit/storage/marine/smartgunner/upp/Initialize()
	. = ..()
	pockets.bypass_w_limit = list(
		/obj/item/ammo_magazine/minigun,
		/obj/item/ammo_magazine/pkp,
		)

/obj/item/clothing/suit/marine/smartgunner/upp/Initialize(mapload)
	. = ..()
	var/obj/item/clothing/accessory/upppads/legs/greaves = new()
	src.attach_accessory(null, greaves, TRUE)

/obj/item/clothing/suit/marine/faction/UPP/light
	name = "6B72-03 式 UPP 护甲"
	desc = "老式 UPP“猎手”护甲系统。环绕式软甲与陶瓷复合胸板为装甲乘员和后方部队提供基础弹道、弹片防护。重量轻，但防护等级与覆盖面积不足。仍配发给领土卫队及人民武装警察战术小队，也有部分特种部队使用。"
	icon_state = "upp_armor_light"
	flags_armor_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_LEGS
	slowdown = SLOWDOWN_ARMOR_LIGHT
	armor_melee = CLOTHING_ARMOR_MEDIUM
	armor_bullet = CLOTHING_ARMOR_MEDIUM
	armor_bomb = CLOTHING_ARMOR_LOW
	armor_bio = CLOTHING_ARMOR_MEDIUMLOW
	armor_rad = CLOTHING_ARMOR_LOW
	armor_internaldamage = CLOTHING_ARMOR_MEDIUM
	time_to_unequip = 10
	time_to_equip = 10
	flags_inventory = null
	valid_accessory_slots = list(ACCESSORY_SLOT_MEDAL, ACCESSORY_SLOT_DECORARMOR,ACCESSORY_SLOT_DECORSHIN, ACCESSORY_SLOT_DECORBRACER, ACCESSORY_SLOT_DECORNECK, ACCESSORY_SLOT_PAINT, ACCESSORY_SLOT_M3UTILITY, ACCESSORY_SLOT_PONCHO, ACCESSORY_SLOT_DECORKNEE)
	restricted_accessory_slots = list(ACCESSORY_SLOT_DECORARMOR,ACCESSORY_SLOT_DECORBRACER, ACCESSORY_SLOT_DECORNECK, ACCESSORY_SLOT_DECORSHIN, ACCESSORY_SLOT_M3UTILITY, ACCESSORY_SLOT_PAINT, ACCESSORY_SLOT_DECORKNEE)
	specialty = "\improper 6B72-03 式"

/obj/item/clothing/suit/marine/faction/UPP/light/Initialize(mapload)
	. = ..()
	var/obj/item/clothing/accessory/upppads/legs/greaves = new()
	src.attach_accessory(null, greaves, TRUE)

/obj/item/clothing/suit/marine/faction/UPP/CANC
	name = "\improper 12 式 CANC 护甲"
	desc = "老式 CANC 护甲系统，提供基础的弹道与破片防护。"
	icon_state = "canc"
	flags_armor_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_LEGS
	slowdown = SLOWDOWN_ARMOR_LIGHT
	armor_melee = CLOTHING_ARMOR_MEDIUM
	armor_bullet = CLOTHING_ARMOR_MEDIUM
	armor_bomb = CLOTHING_ARMOR_LOW
	armor_bio = CLOTHING_ARMOR_MEDIUMLOW
	armor_rad = CLOTHING_ARMOR_LOW
	armor_internaldamage = CLOTHING_ARMOR_MEDIUM
	time_to_unequip = 10
	time_to_equip = 10
	flags_inventory = null
	valid_accessory_slots = list(ACCESSORY_SLOT_MEDAL, ACCESSORY_SLOT_DECORARMOR,ACCESSORY_SLOT_DECORSHIN, ACCESSORY_SLOT_DECORBRACER, ACCESSORY_SLOT_DECORNECK, ACCESSORY_SLOT_PAINT, ACCESSORY_SLOT_M3UTILITY, ACCESSORY_SLOT_PONCHO, ACCESSORY_SLOT_DECORKNEE)
	restricted_accessory_slots = list(ACCESSORY_SLOT_DECORARMOR,ACCESSORY_SLOT_DECORBRACER, ACCESSORY_SLOT_DECORNECK, ACCESSORY_SLOT_DECORSHIN, ACCESSORY_SLOT_M3UTILITY, ACCESSORY_SLOT_PAINT, ACCESSORY_SLOT_DECORKNEE)
	specialty = "\improper 12 式"

/obj/item/clothing/suit/marine/faction/UPP/CANC/Initialize(mapload)
	. = ..()
	var/obj/item/clothing/accessory/storage/webbing/m3/uppsmall/webbing = new()
	src.attach_accessory(null, webbing, TRUE)

/obj/item/clothing/suit/marine/smartgunner/upp/canc
	name = "\improper 12 式 CANC 背负装备"
	desc = "老式 CANC 护甲系统，提供基础的弹道与破片防护。"
	icon_state = "canc"
	slowdown = SLOWDOWN_ARMOR_LOWHEAVY
	flags_atom = NO_SNOW_TYPE|NO_NAME_OVERRIDE
	flags_inventory = BLOCKSHARPOBJ|SMARTGUN_HARNESS
	flags_armor_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_LEGS
	armor_melee = CLOTHING_ARMOR_HIGH
	armor_bullet = CLOTHING_ARMOR_HIGH
	armor_laser = CLOTHING_ARMOR_MEDIUMLOW
	armor_energy = CLOTHING_ARMOR_MEDIUM
	armor_bio = CLOTHING_ARMOR_MEDIUMHIGH
	armor_rad = CLOTHING_ARMOR_MEDIUMHIGH
	armor_internaldamage = CLOTHING_ARMOR_HIGH
	valid_accessory_slots = list(ACCESSORY_SLOT_MEDAL, ACCESSORY_SLOT_DECORARMOR,ACCESSORY_SLOT_DECORSHIN, ACCESSORY_SLOT_DECORBRACER, ACCESSORY_SLOT_DECORNECK, ACCESSORY_SLOT_PAINT, ACCESSORY_SLOT_M3UTILITY, ACCESSORY_SLOT_PONCHO, ACCESSORY_SLOT_DECORKNEE)
	restricted_accessory_slots = list(ACCESSORY_SLOT_DECORARMOR,ACCESSORY_SLOT_DECORBRACER, ACCESSORY_SLOT_DECORNECK, ACCESSORY_SLOT_DECORSHIN, ACCESSORY_SLOT_M3UTILITY, ACCESSORY_SLOT_PAINT, ACCESSORY_SLOT_DECORKNEE)
	specialty = "\improper 12 式 CANC 背负"

/obj/item/clothing/suit/marine/faction/UPP/jacket
	name = "\improper UH4 迷彩夹克"
	icon_state = "upp_coat"
	desc = "军用夹克，分散嵌有少量对位芳纶插片，提供最基本的防护，并配有个人照明单元。"
	blood_overlay_type = "coat"
	flags_armor_protection = BODY_FLAG_CHEST|BODY_FLAG_ARMS
	min_cold_protection_temperature = ICE_PLANET_MIN_COLD_PROT
	slowdown = SLOWDOWN_ARMOR_LIGHT
	armor_melee = CLOTHING_ARMOR_VERYLOW
	armor_bullet = CLOTHING_ARMOR_VERYLOW
	armor_laser = CLOTHING_ARMOR_NONE
	armor_energy = CLOTHING_ARMOR_NONE
	armor_bomb = CLOTHING_ARMOR_LOW
	armor_bio = CLOTHING_ARMOR_NONE
	armor_rad = CLOTHING_ARMOR_NONE
	armor_internaldamage = CLOTHING_ARMOR_NONE
	valid_accessory_slots = list(ACCESSORY_SLOT_ARMBAND, ACCESSORY_SLOT_DECOR, ACCESSORY_SLOT_MEDAL, ACCESSORY_SLOT_M3UTILITY)
	restricted_accessory_slots = list(ACCESSORY_SLOT_ARMBAND, ACCESSORY_SLOT_M3UTILITY)
	time_to_unequip = 5
	time_to_equip = 5

/obj/item/clothing/suit/marine/faction/UPP/jacket/mp
	name = "\improper UH4-P 迷彩夹克"
	desc = "进步人民联盟宪兵夹克，分散嵌有少量对位芳纶插片，提供最基本的防护，并配有个人照明单元。"
	icon_state = "upp_coat_mp"

/obj/item/clothing/suit/marine/faction/UPP/jacket/pap
	name = "\improper 人民武警制服夹克"
	desc = "人民武警常服夹克，分散嵌有少量对位芳纶插片，提供最基本的防护，并配有个人照明单元。"
	icon_state = "upp_coat_pap"


//===========================//FREELANCER\\================================\\
//=====================================================================\\

/obj/item/clothing/suit/storage/marine/faction/freelancer
	name = "自由佣兵胸甲"
	desc = "由各类护甲板拼成的防护胸甲。做工扎实，防护出奇地好，设计与进步人民联盟和美国殖民地陆战队的同类护甲相似。自由佣兵中许多熟练工匠每月能制作约一件。"
	icon_state = "freelancer_armor"
	slowdown = SLOWDOWN_ARMOR_LIGHT
	flags_armor_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_LEGS
	armor_melee = CLOTHING_ARMOR_MEDIUMHIGH
	armor_bullet = CLOTHING_ARMOR_MEDIUMHIGH
	armor_energy = CLOTHING_ARMOR_MEDIUMLOW
	storage_slots = 2

//this one is for CLF
/obj/item/clothing/suit/storage/militia
	name = "殖民地民兵长身护甲"
	desc = "殖民地民兵的长身护甲，由煮硬皮革和少量现代装甲板制成。虽比大多数现代护甲原始、防护也不算强，却几乎不影响行动，符合当地殖民者的需求。穿戴快、易隐藏，还能在大型工坊中低成本生产。"
	icon = 'icons/obj/items/clothing/cm_suits.dmi'
	icon_state = "rebel_armor"
	item_icons = list(
		WEAR_JACKET = 'icons/mob/humans/onmob/suit_1.dmi'
	)
	sprite_sheets = list(SPECIES_MONKEY = 'icons/mob/humans/species/monkeys/onmob/suit_monkey_1.dmi')
	slowdown = SLOWDOWN_ARMOR_VERY_LIGHT
	flags_armor_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_LEGS|BODY_FLAG_ARMS
	movement_compensation = SLOWDOWN_ARMOR_MEDIUM
	armor_melee = CLOTHING_ARMOR_MEDIUM
	armor_bullet = CLOTHING_ARMOR_MEDIUMLOW
	armor_laser = CLOTHING_ARMOR_MEDIUMLOW
	armor_energy = CLOTHING_ARMOR_MEDIUMLOW
	armor_bomb = CLOTHING_ARMOR_MEDIUM
	armor_bio = CLOTHING_ARMOR_MEDIUMLOW
	armor_rad = CLOTHING_ARMOR_MEDIUM
	armor_internaldamage = CLOTHING_ARMOR_MEDIUM
	storage_slots = 2
	allowed = list(
		/obj/item/weapon/gun,
		/obj/item/tank/emergency_oxygen,
		/obj/item/device/flashlight,
		/obj/item/ammo_magazine,
		/obj/item/explosive/grenade,
		/obj/item/device/binoculars,
		/obj/item/attachable/bayonet,
		/obj/item/storage/backpack/general_belt,
		/obj/item/storage/large_holster/machete,
		/obj/item/weapon/baseballbat,
		/obj/item/weapon/baseballbat/metal,
		/obj/item/device/motiondetector,
		/obj/item/device/walkman,
	)
	flags_cold_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_LEGS|BODY_FLAG_FEET|BODY_FLAG_ARMS|BODY_FLAG_HANDS
	min_cold_protection_temperature = SPACE_SUIT_MIN_COLD_PROT
	valid_accessory_slots = list(ACCESSORY_SLOT_MEDAL)

/obj/item/clothing/suit/storage/militia/Initialize()
	. = ..()
	pockets.max_w_class = SIZE_SMALL //Can contain small items AND rifle magazines.
	pockets.bypass_w_limit = list(
		/obj/item/ammo_magazine/rifle,
		/obj/item/ammo_magazine/smg,
		/obj/item/ammo_magazine/sniper,
	)
	pockets.max_storage_space = 8

/obj/item/clothing/suit/storage/militia/vest
	name = "殖民地民兵背心"
	desc = "殖民地民兵的长身护甲，由煮硬皮革和少量现代装甲板制成。虽比大多数现代护甲原始、防护也不算强，却几乎不影响行动，符合当地殖民者的需求。穿戴快、易隐藏，还能在大型工坊中低成本生产。这款极轻型变体只保护胸腹。"
	icon_state = "clf_2"
	flags_armor_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN
	flags_cold_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN
	slowdown = 0.2
	movement_compensation = SLOWDOWN_ARMOR_MEDIUM

/obj/item/clothing/suit/storage/militia/brace
	name = "殖民地民兵护臂"
	desc = "殖民地民兵的长身护甲，由煮硬皮革和少量现代装甲板制成。虽比大多数现代护甲原始、防护也不算强，却几乎不影响行动，符合当地殖民者的需求。穿戴快、易隐藏，还能在大型工坊中低成本生产。这款极轻型变体拆除了部分胸甲。"
	icon_state = "clf_3"
	flags_armor_protection = BODY_FLAG_GROIN|BODY_FLAG_ARMS|BODY_FLAG_LEGS
	flags_cold_protection = BODY_FLAG_GROIN|BODY_FLAG_ARMS|BODY_FLAG_LEGS
	slowdown = 0.2
	movement_compensation = SLOWDOWN_ARMOR_MEDIUM

/obj/item/clothing/suit/storage/militia/partial
	name = "殖民地民兵半身护甲"
	desc = "殖民地民兵的长身护甲，由煮硬皮革和少量现代装甲板制成。虽比大多数现代护甲原始、防护也不算强，却几乎不影响行动，符合当地殖民者的需求。穿戴快、易隐藏，还能在大型工坊中低成本生产。这款更轻的变体拆除了部分臂甲。"
	icon_state = "clf_4"
	flags_armor_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_LEGS
	flags_cold_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_ARMS|BODY_FLAG_LEGS
	slowdown = 0.2

/obj/item/clothing/suit/storage/militia/smartgun
	name = "殖民地民兵背负装备"
	desc = "由煮制皮革和现代护甲板制成的殖民地民兵锁甲。防护虽不算强，与现代护甲相比也很原始，却几乎不妨碍行动，符合当地殖民者的需求。穿脱迅速、便于隐藏，也可在大型作坊低成本生产。这件在装甲板之间编入绑带，能让使用者操作缴获的智能机枪，虽然有些不舒服。"
	flags_inventory = BLOCKSHARPOBJ|SMARTGUN_HARNESS

/obj/item/clothing/suit/storage/CMB
	name = "\improper 殖民地执法局副法警夹克"
	desc = "用轻型防弹织层加强的蓝色聚酯纤维飞行夹克，别着副法警徽章，背后写有“副法警”。"
	icon_state = "CMB_jacket"
	item_state = "CMB_jacket"
	blood_overlay_type = "coat"
	flags_armor_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_ARMS
	flags_cold_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_ARMS
	armor_melee = CLOTHING_ARMOR_MEDIUMLOW
	armor_bullet = CLOTHING_ARMOR_MEDIUMLOW
	armor_energy = CLOTHING_ARMOR_LOW
	armor_bomb = CLOTHING_ARMOR_LOW
	armor_bio = CLOTHING_ARMOR_LOW
	armor_internaldamage = CLOTHING_ARMOR_LOW
	allowed = list(
		/obj/item/weapon/gun,
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
		/obj/item/storage/belt/gun/m4a3,
		/obj/item/storage/belt/gun/m44,
		/obj/item/storage/belt/gun/mateba,
		/obj/item/storage/belt/gun/smartpistol,
		/obj/item/storage/large_holster/machete,
		/obj/item/storage/large_holster/katana,
		/obj/item/device/motiondetector,
		/obj/item/device/walkman,
	)
	valid_accessory_slots = list(ACCESSORY_SLOT_ARMBAND, ACCESSORY_SLOT_DECOR)
	restricted_accessory_slots = list(ACCESSORY_SLOT_ARMBAND)

/obj/item/clothing/suit/storage/CMB/Initialize()
	. = ..()
	pockets.max_w_class = SIZE_SMALL //Can contain small items AND rifle magazines.
	pockets.bypass_w_limit = list(
		/obj/item/ammo_magazine/rifle,
		/obj/item/ammo_magazine/smg,
		/obj/item/ammo_magazine/sniper,
	)
	pockets.max_storage_space = 8

/obj/item/clothing/suit/storage/CMB/marshal
	name = "\improper 殖民地执法局法警夹克"
	desc = "厚实而时髦的黑色皮夹克，别着法警徽章。背后醒目的“法警”字样象征外缘地区的正义、权威与保护。地球的法律延伸到了太阳系之外。"
	icon_state = "CMB_jacket_marshal"
	item_state = "CMB_jacket_marshal"

//===========================//HELGHAST - MERCENARY\\================================\\
//=====================================================================\\

/obj/item/clothing/suit/storage/marine/veteran/mercenary
	name = "\improper K12 陶瓷板护甲"
	desc = "带深蓝装饰的灰色重型陶瓷护甲，是活动于本星区的某个不明雇佣兵组织的制式服装。"
	icon_state = "mercenary_heavy_armor"
	flags_inventory = BLOCKSHARPOBJ|BLOCK_KNOCKDOWN
	armor_melee = CLOTHING_ARMOR_VERYHIGH
	armor_bullet = CLOTHING_ARMOR_VERYHIGH
	armor_energy = CLOTHING_ARMOR_MEDIUMLOW
	armor_bomb = CLOTHING_ARMOR_MEDIUM
	armor_bio = CLOTHING_ARMOR_HIGHPLUS
	armor_rad = CLOTHING_ARMOR_MEDIUM
	armor_internaldamage = CLOTHING_ARMOR_HIGHPLUS
	storage_slots = 2
	slowdown = SLOWDOWN_ARMOR_LIGHT
	allowed = list(
		/obj/item/weapon/gun,
		/obj/item/tank/emergency_oxygen,
		/obj/item/device/flashlight,
		/obj/item/ammo_magazine/,
		/obj/item/weapon/baton,
		/obj/item/restraint/handcuffs,
		/obj/item/storage/fancy/cigarettes,
		/obj/item/tool/lighter,
		/obj/item/explosive/grenade,
		/obj/item/storage/bible,
		/obj/item/weapon/sword/machete,
		/obj/item/attachable/bayonet,
		/obj/item/device/motiondetector,
		/obj/item/device/walkman,
	)
	item_state_slots = list(WEAR_JACKET = "mercenary_heavy_armor")

/obj/item/clothing/suit/storage/marine/veteran/mercenary/heavy
	name = "\improper 改装 K12 陶瓷板护甲"
	desc = "带深蓝装饰的灰色重型陶瓷护甲，储物袋内加装了额外陶瓷板，似乎用于支撑极重的武器。"
	armor_melee = CLOTHING_ARMOR_ULTRAHIGH
	armor_bullet = CLOTHING_ARMOR_ULTRAHIGHPLUS
	armor_bomb = CLOTHING_ARMOR_HIGHPLUS
	armor_bio = CLOTHING_ARMOR_HIGHPLUS
	armor_rad = CLOTHING_ARMOR_MEDIUM
	armor_internaldamage = CLOTHING_ARMOR_VERYHIGHPLUS
	storage_slots = 1

/obj/item/clothing/suit/storage/marine/veteran/mercenary/miner
	name = "\improper Y8 装甲采矿背心"
	desc = "用于采矿防护的米色轻型护甲，是活动于本星区的某个不明雇佣兵组织的专用制服。"
	icon_state = "mercenary_miner_armor"
	storage_slots = 3
	allowed = list(
		/obj/item/weapon/gun,
		/obj/item/tank/emergency_oxygen,
		/obj/item/device/flashlight,
		/obj/item/ammo_magazine/,
		/obj/item/weapon/baton,
		/obj/item/restraint/handcuffs,
		/obj/item/storage/fancy/cigarettes,
		/obj/item/tool/lighter,
		/obj/item/explosive/grenade,
		/obj/item/storage/bible,
		/obj/item/weapon/sword/machete,
		/obj/item/attachable/bayonet,
		/obj/item/device/motiondetector,
		/obj/item/device/walkman,
	)
	item_state_slots = list(WEAR_JACKET = "mercenary_miner_armor")

/obj/item/clothing/suit/storage/marine/veteran/mercenary/support
	name = "\improper Z7 装甲背心"
	desc = "带黄色装饰的蓝色护甲，用于在高危环境中施工或进行医疗作业时提供防护，是活动于本星区的某个不明雇佣兵组织的专用制服。"
	icon_state = "mercenary_engineer_armor"
	item_state_slots = list(WEAR_JACKET = "mercenary_engineer_armor")

/obj/item/clothing/suit/storage/marine/M3G/hefa
	name = "\improper HEFA 骑士护甲"
	desc = "饰有 HEFA 手榴弹图案的厚重护甲，通常由 HEFA 骑士穿戴。"
	specialty = "HEFA 骑士"
	icon_state = "hefadier"
	flags_atom = NO_NAME_OVERRIDE|NO_SNOW_TYPE
	flags_item = NO_CRYO_STORE
	flags_marine_armor = ARMOR_LAMP_OVERLAY
	armor_bullet = CLOTHING_ARMOR_VERYHIGH
	armor_melee = CLOTHING_ARMOR_VERYHIGH
	armor_bomb = CLOTHING_ARMOR_GIGAHIGH


//=========================//PROVOST\\================================\\
//=======================================================================\\

/obj/item/clothing/suit/storage/marine/MP/provost
	name = "\improper M3 式军法监察护甲"
	desc = "标准军法监察 M3 式胸甲，可保护胸部免受子弹、刀刃和意外伤害，附带小皮袋，提供有限储物空间。"
	icon_state = "pvmedium"
	item_state_slots = list(WEAR_JACKET = "pvmedium")
	slowdown = SLOWDOWN_ARMOR_LIGHT
	armor_bullet = CLOTHING_ARMOR_MEDIUM
	armor_laser = CLOTHING_ARMOR_MEDIUMLOW
	armor_bomb = CLOTHING_ARMOR_MEDIUMHIGH
	armor_bio = CLOTHING_ARMOR_MEDIUMHIGH
	armor_internaldamage = CLOTHING_ARMOR_MEDIUM
	flags_atom = NO_SNOW_TYPE|NO_NAME_OVERRIDE
	storage_slots = 3

/obj/item/clothing/suit/storage/marine/MP/provost/tml
	name = "\improper M3 式高级军法监察护甲"
	desc = "高级军官使用的精制军法监察 M3 式胸甲，可保护胸部免受子弹、刀刃和意外伤害，附带小皮袋，提供有限储物空间。"
	icon_state = "pvleader"
	item_state_slots = list(WEAR_JACKET = "pvleader")

/obj/item/clothing/suit/storage/marine/MP/provost/marshal
	name = "\improper M5 式军法监察长护甲"
	desc = "为军法监察长量身定制的豪华护甲，亲临战场时能让部下清楚谁说了算。"
	icon_state = "pvmarshal"
	item_state_slots = list(WEAR_JACKET = "pvmarshal")
	w_class = SIZE_MEDIUM
	storage_slots = 4

/obj/item/clothing/suit/storage/marine/MP/provost/light
	name = "\improper M3 式军法监察轻型护甲"
	desc = "轻型军法监察 M3 式胸甲，可保护胸部免受子弹、刀刃和意外伤害，附带小皮袋，提供有限储物空间。"
	icon_state = "pvlight"
	item_state_slots = list(WEAR_JACKET = "pvlight")
	slowdown = SLOWDOWN_ARMOR_VERY_LIGHT

/obj/item/clothing/suit/storage/marine/MP/provost/light/flexi
	name = "\improper M3 式军法监察柔性护甲"
	desc = "柔软易收纳的 M3 式胸甲，可保护胸部免受子弹、刀刃和意外伤害，附带小皮袋，提供有限储物空间。"
	w_class = SIZE_MEDIUM
	icon_state = "pvlight_2"
	item_state_slots = list(WEAR_JACKET = "pvlight_2")
	storage_slots = 2

//================//UNITED AMERICAS RIOT CONTROL\\=====================\\
//=======================================================================\\

/obj/item/clothing/suit/storage/marine/veteran/ua_riot
	name = "\improper UA-M1 防弹衣"
	desc = "以美国殖民地陆战队的 M3 式护甲为基础，供美洲联盟安保、防暴及镇压工会小队使用。对近战和子弹防护良好，但四肢缺乏保护是致命短板。"
	icon_state = "ua_riot"
	flags_armor_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN
	flags_cold_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN
	flags_heat_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN
	armor_melee = CLOTHING_ARMOR_MEDIUMHIGH
	armor_bullet = CLOTHING_ARMOR_MEDIUMHIGH
	armor_energy = CLOTHING_ARMOR_MEDIUM
	armor_bomb = CLOTHING_ARMOR_MEDIUM
	armor_rad = CLOTHING_ARMOR_MEDIUM
	armor_internaldamage = CLOTHING_ARMOR_MEDIUMHIGH
	slowdown = SLOWDOWN_ARMOR_VERY_LIGHT  // it's lighter
	flags_atom = NO_SNOW_TYPE

/obj/item/clothing/suit/storage/marine/veteran/ua_riot/synth
	name = "\improper UA-M1S 合成人防弹衣"
	desc = "以美国殖民地陆战队的 M3 式护甲为基础，供美洲联盟安保、防暴及镇压工会小队使用。UA-1MS 改型符合合成人程序限制，牺牲防护以换取速度和携行能力。"
	armor_melee = CLOTHING_ARMOR_NONE
	armor_bullet = CLOTHING_ARMOR_NONE
	armor_laser = CLOTHING_ARMOR_NONE
	armor_energy = CLOTHING_ARMOR_NONE
	armor_bomb = CLOTHING_ARMOR_NONE
	armor_bio = CLOTHING_ARMOR_NONE
	armor_rad = CLOTHING_ARMOR_NONE
	armor_internaldamage = CLOTHING_ARMOR_NONE
	slowdown = SLOWDOWN_ARMOR_SUPER_LIGHT
	storage_slots = 3
	flags_atom = NO_SNOW_TYPE|NO_NAME_OVERRIDE
	flags_marine_armor = ARMOR_SQUAD_OVERLAY|ARMOR_LAMP_OVERLAY|SYNTH_ALLOWED

//================//=ROYAL MARINES=\\====================================\\
//=======================================================================\\

/obj/item/clothing/suit/marine/veteran/royal_marine
	name = "红隼装甲胸甲"
	desc = "RMC 制式红隼个人护甲，由维兰德-汤谷子公司林登塔尔-埃伦费尔德军工设计。采用最新一代先进复合防弹材料、集成生命监测系统，并配有携行系统和 TNR 肩灯支架。"
	icon_state = "rmc_standard"
	item_state = "rmc_standard"
	flags_atom = NO_NAME_OVERRIDE|NO_SNOW_TYPE
	armor_bullet = CLOTHING_ARMOR_MEDIUMHIGH
	allowed = list(
		/obj/item/weapon/gun,
		/obj/item/tank/emergency_oxygen,
		/obj/item/device/flashlight,
		/obj/item/ammo_magazine/,
		/obj/item/weapon/baton,
		/obj/item/restraint/handcuffs,
		/obj/item/storage/fancy/cigarettes,
		/obj/item/tool/lighter,
		/obj/item/explosive/grenade,
		/obj/item/storage/bible,
		/obj/item/weapon/sword/machete,
		/obj/item/attachable/bayonet,
		/obj/item/device/motiondetector,
		/obj/item/device/walkman,
		/obj/item/storage/belt/marine/rmc,
		/obj/item/storage/belt/medical/rmc,
		/obj/item/storage/belt/gun/l905,
		/obj/item/storage/belt/gun/mortarbelt/rmc,
		/obj/item/storage/backpack/general_belt/rmc,
		/obj/item/storage/belt/gun/flaregun,
	)
	valid_accessory_slots = list(ACCESSORY_SLOT_MEDAL, ACCESSORY_SLOT_DECORARMOR, ACCESSORY_SLOT_DECORARMOR, ACCESSORY_SLOT_DECORSHIN, ACCESSORY_SLOT_PAINT, ACCESSORY_SLOT_M3UTILITY, ACCESSORY_SLOT_PONCHO)
	restricted_accessory_slots = list(ACCESSORY_SLOT_DECORARMOR,ACCESSORY_SLOT_DECORSHIN, ACCESSORY_SLOT_M3UTILITY, ACCESSORY_SLOT_PAINT)

/obj/item/clothing/suit/marine/veteran/royal_marine/heavy
//Just the normal armor with attachies

/obj/item/clothing/suit/marine/veteran/royal_marine/heavy/Initialize(mapload)
	. = ..()
	var/obj/item/clothing/accessory/twepads/shoulders = new()
	src.attach_accessory(null, shoulders, TRUE)
	var/obj/item/clothing/accessory/twepads/legs/greaves = new()
	src.attach_accessory(null, greaves, TRUE)

/obj/item/clothing/suit/marine/veteran/royal_marine/smartgun //Smartgun Spec Armor
	name = "\improper 红隼通用机枪背负装备"
	desc = "皇家陆战突击队制式红隼个人护甲，由维兰德-汤谷子公司林登塔尔－埃伦费尔德军工设计。这一型带有 L58A3 武器系统支撑架，严重限制可额外挂载的储物装备。采用最新一代先进复合防弹材料、内置生物监测系统，以及携行系统和 TNR 肩灯安装架。"
	icon_state = "rmc_smartgun"
	item_state = "rmc_smartgun"
	flags_atom = NO_NAME_OVERRIDE|NO_SNOW_TYPE
	flags_inventory = BLOCKSHARPOBJ|BLOCK_KNOCKDOWN|SMARTGUN_HARNESS
	allowed = list(
		/obj/item/weapon/gun/smartgun/rmc,
	)

/atom/movable/marine_light
	light_system = DIRECTIONAL_LIGHT

//CBRN
/obj/item/clothing/suit/storage/marine/cbrn
	name = "\improper M3-M 护甲"
	desc = "虽不像常规服役的 M3 式护甲，仍由其衍生。它经过大幅改造，以套在任务导向防护服外，移除了额外衬垫和文拉尔复合材料层，避免限制行动。但减少复合层也使防护不尽人意，自 2165 年起便不断有人投诉。"
	icon_state = "cbrn"
	item_state = "cbrn"
	slowdown = SLOWDOWN_ARMOR_HEAVY
	armor_melee = CLOTHING_ARMOR_MEDIUM
	armor_bullet = CLOTHING_ARMOR_MEDIUM
	armor_bomb = CLOTHING_ARMOR_MEDIUM
	armor_bio = CLOTHING_ARMOR_LOW
	armor_rad =CLOTHING_ARMOR_MEDIUMLOW
	armor_internaldamage = CLOTHING_ARMOR_LOW
	flags_marine_armor = NO_FLAGS
	flags_atom = NO_NAME_OVERRIDE|NO_SNOW_TYPE
	flags_inventory = BLOCKSHARPOBJ
	flags_armor_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN
	flags_cold_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN
	flags_heat_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN

/obj/item/clothing/suit/storage/marine/cbrn/advanced
	slowdown = SLOWDOWN_ARMOR_LOWHEAVY
	armor_melee = CLOTHING_ARMOR_HIGH
	armor_bullet = CLOTHING_ARMOR_MEDIUMHIGH
	armor_bomb = CLOTHING_ARMOR_ULTRAHIGH
	armor_bio = CLOTHING_ARMOR_GIGAHIGHPLUS
	armor_rad = CLOTHING_ARMOR_GIGAHIGHPLUS
	armor_internaldamage = CLOTHING_ARMOR_HIGHPLUS

//Mercs
/obj/item/clothing/suit/storage/marine/veteran/merc
	name = "DP TAC-PACK II 代装甲背心"
	desc = "资金较充足的叛军和雇佣兵组织使用的可靠装甲背心，能在失去战斗力前挡住几次轻武器命中。由戴维斯专有技术公司制造。"
	icon = 'icons/obj/items/clothing/cm_suits.dmi'
	item_icons = list(
		WEAR_JACKET = 'icons/mob/humans/onmob/suit_1.dmi'
	)
	icon_state = "merc_medium"
	item_state = "merc_medium"
	armor_melee = CLOTHING_ARMOR_MEDIUMLOW
	armor_bullet = CLOTHING_ARMOR_MEDIUM
	armor_laser = CLOTHING_ARMOR_LOW
	armor_energy = CLOTHING_ARMOR_LOW
	armor_bomb = CLOTHING_ARMOR_MEDIUMLOW
	armor_bio = CLOTHING_ARMOR_MEDIUM
	armor_rad = CLOTHING_ARMOR_NONE
	armor_internaldamage = CLOTHING_ARMOR_MEDIUM
	flags_armor_protection = BODY_FLAG_CHEST|BODY_FLAG_ARMS|BODY_FLAG_GROIN

/obj/item/clothing/suit/storage/marine/veteran/merc/light
	name = "DP TAC-PACK I-L 代装甲背心"
	desc = "防护略弱的背心，比起装甲厚度更重视行动自由与机动性。由戴维斯专有技术公司制造。"
	icon = 'icons/obj/items/clothing/cm_suits.dmi'
	item_icons = list(
		WEAR_JACKET = 'icons/mob/humans/onmob/suit_1.dmi'
	)
	icon_state = "merc_light"
	item_state = "merc_light"
	armor_melee = CLOTHING_ARMOR_LOW
	armor_bullet = CLOTHING_ARMOR_MEDIUMLOW
	armor_bomb = CLOTHING_ARMOR_LOW
	flags_armor_protection = BODY_FLAG_CHEST

/obj/item/clothing/suit/storage/marine/veteran/merc/heavy
	name = "DP TAC-PACK IV-H 代装甲背心"
	desc = "以 II 代和 I 代为基础的重型装甲背心，装甲板更厚，覆盖也更全面，让使用者能承受大量伤害后才倒下。由戴维斯专有技术公司制造。"
	icon = 'icons/obj/items/clothing/cm_suits.dmi'
	item_icons = list(
		WEAR_JACKET = 'icons/mob/humans/onmob/suit_1.dmi'
	)
	icon_state = "merc_heavy"
	item_state = "merc_heavy"
	armor_melee = CLOTHING_ARMOR_HIGH
	armor_bullet = CLOTHING_ARMOR_HIGH
	armor_internaldamage = CLOTHING_ARMOR_MEDIUM
	armor_bomb = CLOTHING_ARMOR_VERYHIGH
	flags_inventory = BLOCK_KNOCKDOWN
	flags_armor_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_LEGS|BODY_FLAG_FEET|BODY_FLAG_ARMS|BODY_FLAG_HANDS
	slowdown = SLOWDOWN_ARMOR_HEAVY
	time_to_unequip = 20
	time_to_equip = 20


