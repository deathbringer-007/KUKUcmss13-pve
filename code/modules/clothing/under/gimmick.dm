
/obj/item/clothing/under/gimmick
	armor_melee = CLOTHING_ARMOR_MEDIUMLOW
	armor_bullet = CLOTHING_ARMOR_MEDIUM
	armor_laser = CLOTHING_ARMOR_LOW
	armor_energy = CLOTHING_ARMOR_LOW
	armor_bomb = CLOTHING_ARMOR_MEDIUM
	armor_bio = CLOTHING_ARMOR_MEDIUM
	armor_rad = CLOTHING_ARMOR_MEDIUM
	armor_internaldamage = CLOTHING_ARMOR_LOW
	has_sensor = UNIFORM_NO_SENSORS
	displays_id = 0

	item_icons = list(
		WEAR_BODY = 'icons/mob/humans/onmob/uniform_1.dmi',
	)

//JASON
/obj/item/clothing/under/gimmick/jason
	name = "脏工作服"
	desc = "挖坟时穿再合适不过。"
	icon_state = "jason_suit"

/obj/item/clothing/mask/gimmick/jason
	name = "曲棍球面具"
	desc = "散发着青春的气息。"
	icon_state = "jason_mask"
	anti_hug = 100

/obj/item/clothing/suit/gimmick/jason
	name = "霉味夹克"
	desc = "杀气十足的时尚宣言。"
	icon_state = "jason_jacket"
	item_state = "jason_jacket"

//RAMBO
/obj/item/clothing/under/gimmick/rambo
	name = "作战长裤"
	desc = "一个男人与全世界为敌时所需的唯一衣物。"
	icon_state = "rambo_suit"
	flags_armor_protection = BODY_FLAG_LEGS|BODY_FLAG_GROIN
	flags_cold_protection = BODY_FLAG_LEGS|BODY_FLAG_GROIN
	flags_heat_protection = BODY_FLAG_LEGS|BODY_FLAG_GROIN

/obj/item/clothing/suit/gimmick/rambo
	name = "吊坠"
	desc = "镶有宝石，也算是一件护身符。"
	flags_armor_protection = BODY_FLAG_CHEST
	flags_cold_protection = BODY_FLAG_CHEST
	flags_heat_protection = BODY_FLAG_CHEST
	icon_state = "rambo_pendant"

//MCCLANE
/obj/item/clothing/under/gimmick/mcclane
	name = "节日服装"
	desc = "与家人共度圣诞假日的完美装束。不含鞋子。"
	icon_state = "mcclane_suit"
	flags_armor_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_LEGS
	flags_cold_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_LEGS
	flags_heat_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_LEGS

//DUTCH
/obj/item/clothing/under/gimmick/dutch
	name = "作战服"
	desc = "一套普通军用作战服，陪你熬过艰苦的丛林战。"
	icon_state = "dutch_suit"
	flags_armor_protection = BODY_FLAG_LEGS|BODY_FLAG_GROIN
	flags_cold_protection = BODY_FLAG_LEGS|BODY_FLAG_GROIN
	flags_heat_protection = BODY_FLAG_LEGS|BODY_FLAG_GROIN

/obj/item/clothing/suit/armor/gimmick/dutch
	name = "装甲夹克"
	desc = "丛林很热。有时闷热难耐，有时简直就是人间地狱。"
	icon_state = "dutch_armor"
	flags_armor_protection = BODY_FLAG_CHEST
	flags_cold_protection = BODY_FLAG_CHEST
	flags_heat_protection = BODY_FLAG_CHEST
	armor_melee = CLOTHING_ARMOR_MEDIUM
	armor_bullet = CLOTHING_ARMOR_MEDIUM
	armor_laser = CLOTHING_ARMOR_LOW
	armor_energy = CLOTHING_ARMOR_LOW
	armor_bomb = CLOTHING_ARMOR_LOW
	armor_bio = CLOTHING_ARMOR_MEDIUM
	armor_rad = CLOTHING_ARMOR_LOW
	armor_internaldamage = CLOTHING_ARMOR_LOW
	allowed = list(
		/obj/item/weapon/gun,
		/obj/item/device/flashlight,
		/obj/item/ammo_magazine/,
		/obj/item/storage/fancy/cigarettes,
		/obj/item/tool/lighter,
		/obj/item/explosive/grenade,
		/obj/item/device/binoculars,
		/obj/item/attachable/bayonet,
		/obj/item/storage/backpack/general_belt,
		/obj/item/storage/large_holster/machete,
	)

//ROBOCOP
/obj/item/clothing/under/gimmick/robocop
	name = "金属躯体"
	desc = "躯体虽是金属，里面却有亚历克斯·J·墨菲的心灵与灵魂。"
	icon_state = "robocop_suit"
	flags_atom = FPRINT|CONDUCT

/obj/item/clothing/shoes/gimmick/robocop
	name = "抛光金属靴"
	desc = "用来踩扁底特律人渣，大小正合适。"
	icon_state = "robocop_shoes"
	armor_melee = CLOTHING_ARMOR_HIGH
	armor_bullet = CLOTHING_ARMOR_VERYHIGH
	armor_laser = CLOTHING_ARMOR_HIGH
	armor_energy = CLOTHING_ARMOR_HIGH
	armor_bomb = CLOTHING_ARMOR_HIGH
	armor_bio = CLOTHING_ARMOR_HIGH
	armor_rad = CLOTHING_ARMOR_HIGH
	armor_internaldamage = CLOTHING_ARMOR_HARDCORE
	flags_inventory = FPRINT|CONDUCT|NOSLIPPING

/obj/item/clothing/gloves/gimmick/robocop
	name = "金属手掌"
	desc = "法律冰冷而无情的双手。"
	icon_state = "robocop_gloves"
	flags_atom = FPRINT|CONDUCT
	armor_melee = CLOTHING_ARMOR_HIGH
	armor_bullet = CLOTHING_ARMOR_VERYHIGH
	armor_laser = CLOTHING_ARMOR_HIGH
	armor_energy = CLOTHING_ARMOR_HIGH
	armor_bomb = CLOTHING_ARMOR_HIGH
	armor_bio = CLOTHING_ARMOR_HIGH
	armor_rad = CLOTHING_ARMOR_HIGH
	armor_internaldamage = CLOTHING_ARMOR_HARDCORE

/obj/item/clothing/head/helmet/gimmick/robocop
	name = "抛光金属头盔"
	desc = "法律铁面无私的面孔。钛合金框架内衬多层防弹聚合物。"
	icon_state = "robocop_helmet"
	item_state = "robocop_helmet"
	armor_melee = CLOTHING_ARMOR_HIGH
	armor_bullet = CLOTHING_ARMOR_VERYHIGH
	armor_laser = CLOTHING_ARMOR_HIGH
	armor_energy = CLOTHING_ARMOR_HIGH
	armor_bomb = CLOTHING_ARMOR_HIGH
	armor_bio = CLOTHING_ARMOR_HIGH
	armor_rad = CLOTHING_ARMOR_HIGH
	armor_internaldamage = CLOTHING_ARMOR_HARDCORE
	flags_inventory = COVEREYES|BLOCKSHARPOBJ
	flags_inv_hide = HIDEEARS|HIDEEYES|HIDETOPHAIR
	anti_hug = 100

/obj/item/clothing/suit/armor/gimmick/robocop
	name = "抛光金属装甲"
	desc = "干净且保养良好，与底特律肮脏的街道截然不同。钛合金外壳、钼装甲板和防弹聚合物内衬。"
	icon_state = "robocop_armor"
	item_state = "robocop_armor"
	slowdown = 1
	flags_atom = FPRINT|CONDUCT
	flags_inventory = BLOCKSHARPOBJ
	flags_armor_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_ARMS|BODY_FLAG_LEGS
	flags_cold_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_ARMS|BODY_FLAG_LEGS
	flags_heat_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_ARMS|BODY_FLAG_LEGS
	allowed = list(/obj/item/weapon/gun/pistol/auto9)
	armor_melee = CLOTHING_ARMOR_HIGH
	armor_bullet = CLOTHING_ARMOR_VERYHIGH
	armor_laser = CLOTHING_ARMOR_HIGH
	armor_energy = CLOTHING_ARMOR_HIGH
	armor_bomb = CLOTHING_ARMOR_HIGH
	armor_bio = CLOTHING_ARMOR_HIGH
	armor_rad = CLOTHING_ARMOR_HIGH
	armor_internaldamage = CLOTHING_ARMOR_HARDCORE

//LUKE
/obj/item/clothing/under/gimmick/skywalker
	name = "黑色连体服"
	desc = "简单实用的连体服，由一位掌握了原力的人穿着。"
	icon_state = "skywalker_suit"

/obj/item/clothing/shoes/gimmick/skywalker
	name = "黑色靴子"
	desc = "功能完备，这双靴子踏过无数行星与星舰。"
	icon_state = "skywalker_shoes"
	flags_inventory = FPRINT|NOSLIPPING

/obj/item/clothing/gloves/gimmick/skywalker
	name = "黑色手套"
	desc = "用来遮住那只义手……谁说英雄就不会在意外表？"
	icon_state = "skywalker_gloves"



/obj/item/clothing/under/gimmick/rank/captain/suit
	name = "舰长西装"
	desc = "绿色西装配黄色领带，尽显权威。"
	icon_state = "green_suit"
	item_state = "dg_suit"

/obj/item/clothing/under/gimmick/rank/head_of_personnel/suit
	name = "人事主管西装"
	desc = "青绿色西装配黄色领带。既显权威，又有点俗气。"
	icon_state = "teal_suit"
	item_state = "g_suit"
