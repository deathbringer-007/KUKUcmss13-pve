//------------GEAR VENDOR---------------

GLOBAL_LIST_INIT(cm_vending_gear_engi, list(
		list("工兵套装 (必选)", 0, null, null, null),
		list("必备工兵套装", 0, /obj/effect/essentials_set/engi, MARINE_CAN_BUY_ESSENTIALS, VENDOR_ITEM_MANDATORY),

		list("手持防卫装备 (任选一件)", 0, null, null, null),
		list("21S 特斯拉线圈", 0, /obj/item/defenses/handheld/tesla_coil, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_MANDATORY),
		list("JIMA 立式旗帜", 0, /obj/item/defenses/handheld/planted_flag, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_MANDATORY),
		list("UA 42-F 哨戒喷火器", 0, /obj/item/defenses/handheld/sentry/flamer, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_MANDATORY),
		list("UA 571-C 哨戒机枪", 0, /obj/item/defenses/handheld/sentry, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_MANDATORY),
		list("哨戒武器升级套件", 15, /obj/item/engi_upgrade_kit, null, VENDOR_ITEM_REGULAR),

		list("工程用品", 0, null, null, null),
		list("气闸门电路板", 2, /obj/item/circuitboard/airlock, null, VENDOR_ITEM_REGULAR),
		list("区域电力控制器电路板", 2, /obj/item/circuitboard/apc, null, VENDOR_ITEM_REGULAR),
		list("工兵铲 (ET)", 2, /obj/item/tool/shovel/etool, null, VENDOR_ITEM_REGULAR),
		list("高容量电池", 3, /obj/item/cell/high, null, VENDOR_ITEM_REGULAR),
		list("金属 x10", 5, /obj/item/stack/sheet/metal/small_stack, null, VENDOR_ITEM_RECOMMENDED),
		list("塑钢 x10", 7, /obj/item/stack/sheet/plasteel/small_stack, null, VENDOR_ITEM_RECOMMENDED),
		list("塑性炸药", 3, /obj/item/explosive/plastic, null, VENDOR_ITEM_REGULAR),
		list("破障炸药", 5, /obj/item/explosive/plastic/breaching_charge, null, VENDOR_ITEM_RECOMMENDED),
		list("沙袋 x25", 10, /obj/item/stack/sandbags_empty/half, null, VENDOR_ITEM_RECOMMENDED),
		list("超高容量电池", 10, /obj/item/cell/super, null, VENDOR_ITEM_REGULAR),
		list("ES-11 移动燃料罐", 4, /obj/item/tool/weldpack/minitank, null, VENDOR_ITEM_REGULAR),

		list("爆炸物", 0, null, null, null),
		list("M40 HEDP 高爆包 (x3 手榴弹)", 18, /obj/item/storage/box/packet/high_explosive, null, VENDOR_ITEM_REGULAR),
		list("M40 HIDP 燃烧弹包 (x3 手榴弹)", 18, /obj/item/storage/box/packet/incendiary, null, VENDOR_ITEM_REGULAR),
		list("M40 WPDP 白磷包 (x3 手榴弹)", 18, /obj/item/storage/box/packet/phosphorus, null, VENDOR_ITEM_REGULAR),
		list("M40 HSDP 烟幕包 (x3 手榴弹)", 9, /obj/item/storage/box/packet/smoke, null, VENDOR_ITEM_REGULAR),
		list("M20 地雷盒 (x5 地雷)", 18, /obj/item/storage/box/explosive_mines, null, VENDOR_ITEM_REGULAR),
		list("M40 MFHS 金属泡沫手榴弹", 5, /obj/item/explosive/grenade/metal_foam, null, VENDOR_ITEM_REGULAR),
		list("G2 电击手榴弹包 (x3 手榴弹)",  16, /obj/item/storage/box/packet/sebb, null, VENDOR_ITEM_REGULAR),

		list("主武器弹药", 0, null, null, null),
		list("M49A 穿甲弹匣 (10x24mm)", 6, /obj/item/ammo_magazine/rifle/m49a/ap, null, VENDOR_ITEM_REGULAR),
		list("M39 穿甲弹匣 (10x20mm)", 6, /obj/item/ammo_magazine/smg/m39/ap , null, VENDOR_ITEM_REGULAR),
		list("M39 扩容弹匣 (10x20mm)", 6, /obj/item/ammo_magazine/smg/m39/extended , null, VENDOR_ITEM_REGULAR),
		list("M41A 穿甲弹匣 (10x24mm)", 6, /obj/item/ammo_magazine/rifle/ap , null, VENDOR_ITEM_REGULAR),
		list("M41A 扩容弹匣 (10x24mm)", 6, /obj/item/ammo_magazine/rifle/extended , null, VENDOR_ITEM_REGULAR),

		list("副武器弹药", 0, null, null, null),
		list("M44 重型快速装弹器 (.44)", 6, /obj/item/ammo_magazine/revolver/heavy, null, VENDOR_ITEM_REGULAR),
		list("M44 精确射手快速装弹器 (.44)", 6, /obj/item/ammo_magazine/revolver/marksman, null, VENDOR_ITEM_REGULAR),
		list("M4A3 空尖弹匣", 3, /obj/item/ammo_magazine/pistol/hp, null, VENDOR_ITEM_REGULAR),
		list("M4A3 穿甲弹匣", 3, /obj/item/ammo_magazine/pistol/ap, null, VENDOR_ITEM_REGULAR),
		list("VP78 弹匣", 3, /obj/item/ammo_magazine/pistol/vp78, null, VENDOR_ITEM_REGULAR),
		list("SU-6 智能手枪弹匣 (.45)", 6, /obj/item/ammo_magazine/pistol/smart, null, VENDOR_ITEM_REGULAR),

		list("护甲", 0, null, null, null),
		list("M3 B12 式陆战队护甲", 24, /obj/item/clothing/suit/storage/marine/medium/leader, null, VENDOR_ITEM_REGULAR),
		list("M4 式护甲", 16, /obj/item/clothing/suit/storage/marine/medium/rto, null, VENDOR_ITEM_REGULAR),

		list("限配枪械", 0, null, null, null),
		list("VP78 手枪", 8, /obj/item/storage/box/guncase/vp78, null, VENDOR_ITEM_REGULAR),
		list("SU-6 智能手枪", 12, /obj/item/storage/box/guncase/smartpistol, null, VENDOR_ITEM_REGULAR),
		list("M240 火焰喷射器", 12, /obj/item/storage/box/guncase/flamer, null, VENDOR_ITEM_REGULAR),
		list("M79 榴弹发射器", 24, /obj/item/storage/box/guncase/m79, null, VENDOR_ITEM_REGULAR),
		list("M56D 重机枪", 24, /obj/item/storage/box/guncase/m56d, null, VENDOR_ITEM_REGULAR),

		list("服装", 0, null, null, null),
		list("砍刀鞘 (满装)", 6, /obj/item/storage/large_holster/machete/full, null, VENDOR_ITEM_REGULAR),
		list("砍刀袋 (满装)", 8, /obj/item/storage/pouch/machete/full, null, VENDOR_ITEM_REGULAR),
		list("USCM 无线电话背包", 15, /obj/item/storage/backpack/marine/satchel/rto, null, VENDOR_ITEM_REGULAR),
		list("燃料罐绑带袋", 4, /obj/item/storage/pouch/flamertank, null, VENDOR_ITEM_REGULAR),
		list("枪带袋", 6, /obj/item/storage/pouch/sling, null, VENDOR_ITEM_REGULAR),
		list("大型杂物袋", 6, /obj/item/storage/pouch/general/large, null, VENDOR_ITEM_REGULAR),
		list("M276 式战斗工具携行腰带", 15, /obj/item/storage/belt/gun/utility, null, VENDOR_ITEM_REGULAR),

		list("勤务服", 0, null, null, null),
		list("轮式担架床", 5, /obj/item/roller, null, VENDOR_ITEM_REGULAR),
		list("富尔顿回收装置组", 5, /obj/item/stack/fulton, null, VENDOR_ITEM_REGULAR),
		list("灭火器 (便携式)", 3, /obj/item/tool/extinguisher/mini, null, VENDOR_ITEM_REGULAR),
		list("运动探测器", 8, /obj/item/device/motiondetector, null, VENDOR_ITEM_REGULAR),
		list("哨子", 3, /obj/item/device/whistle, null, VENDOR_ITEM_REGULAR),

		list("双筒望远镜", 0, null, null, null),
		list("双筒望远镜", 5, /obj/item/device/binoculars, null, VENDOR_ITEM_REGULAR),
		list("测距仪", 10, /obj/item/device/binoculars/range, null, VENDOR_ITEM_REGULAR),
		list("激光目标指示器", 15, /obj/item/device/binoculars/range/designator, null, VENDOR_ITEM_REGULAR),

		list("头盔光学设备", 0, null, null, null),
		list("头盔医疗镜片", 12, /obj/item/device/helmet_visor/medical, null, VENDOR_ITEM_REGULAR),

		list("技能指导手册", 0, null, null, null),
		list("JTAC 技能指导手册", 15, /obj/item/pamphlet/skill/jtac, null, VENDOR_ITEM_REGULAR),

		list("无线电密钥", 0, null, null, null),
		list("情报无线电加密密钥", 3, /obj/item/device/encryptionkey/intel, null, VENDOR_ITEM_REGULAR),
		list("JTAC 无线电加密密钥", 3, /obj/item/device/encryptionkey/jtac, null, VENDOR_ITEM_REGULAR),
		list("补给无线电加密密钥", 3, /obj/item/device/encryptionkey/req, null, VENDOR_ITEM_REGULAR),
	))

/obj/structure/machinery/cm_vending/gear/engi
	name = "ColMarTech小队战斗技术员用品架"
	desc = "供战斗技术员使用的自动装备架。"
	icon_state = "eng_gear"
	vendor_role = list(JOB_SQUAD_ENGI)
	req_access = list(ACCESS_MARINE_ENGPREP)

/obj/structure/machinery/cm_vending/gear/engi/get_listed_products(mob/user)
	return GLOB.cm_vending_gear_engi

//------------CLOTHING VENDOR---------------

GLOBAL_LIST_INIT(cm_vending_clothing_engi, list(
		list("标准装备 (全部领取)", 0, null, null, null),
		list("陆战队标准服装", 0, list(/obj/item/clothing/under/marine/engineer, /obj/item/clothing/shoes/marine/knife, /obj/item/clothing/gloves/marine, /obj/item/device/radio/headset/almayer/marine, /obj/item/clothing/head/helmet/marine/tech), MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_MANDATORY),
		list("即食军粮", 0, /obj/item/storage/box/mre, MARINE_CAN_BUY_MRE, VENDOR_ITEM_MANDATORY),
		list("地图", 0, /obj/item/map/current_map, MARINE_CAN_BUY_KIT, VENDOR_ITEM_MANDATORY),

		list("护甲 (任选一件)", 0, null, null, null),
		list("轻型护甲", 0, /obj/item/clothing/suit/storage/marine/light, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_REGULAR),
		list("中型护甲", 0, /obj/item/clothing/suit/storage/marine/medium, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_RECOMMENDED),
		list("重型护甲", 0, /obj/item/clothing/suit/storage/marine/heavy, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_REGULAR),

		list("背包 (任选一件)", 0, null, null, null),
		list("砍刀鞘 (满装)", 0, /obj/item/storage/large_holster/machete/full, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_REGULAR),
		list("技术员背包", 0, /obj/item/storage/backpack/marine/tech, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_REGULAR),
		list("技术员挎包", 0, /obj/item/storage/backpack/marine/satchel/tech, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_REGULAR),
		list("技术员焊接背包", 0, /obj/item/storage/backpack/marine/engineerpack, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_MANDATORY),
		list("技术员焊接挎包", 0, /obj/item/storage/backpack/marine/engineerpack/satchel, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_REGULAR),
		list("技术员焊接胸挂", 0, /obj/item/storage/backpack/marine/engineerpack/welder_chestrig, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_MANDATORY),

		list("腰带 (任选一件)", 0, null, null, null),
		list("G8-A 通用杂物袋", 0, /obj/item/storage/backpack/general_belt, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 弹药携行挂具", 0, /obj/item/storage/belt/marine, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 通用手枪枪套挂具", 0, /obj/item/storage/belt/gun/m4a3, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 M39 枪套挂具", 0, /obj/item/storage/belt/gun/m39, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 通用左轮手枪枪套挂具", 0, /obj/item/storage/belt/gun/m44, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 M82F 枪套挂具", 0, /obj/item/storage/belt/gun/flaregun, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 霰弹装填挂具", 0, /obj/item/storage/belt/shotgun, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 迫击炮手腰带", 0, /obj/item/storage/belt/gun/mortarbelt, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 工具携行腰带 (满装)", 0, /obj/item/storage/belt/utility/full, MARINE_CAN_BUY_BELT, VENDOR_ITEM_MANDATORY),
		list("M276 M40 手榴弹携行挂具", 0, /obj/item/storage/belt/grenade, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M277 式建筑工具挂具", 0, /obj/item/storage/belt/utility/construction, MARINE_CAN_BUY_BELT, VENDOR_ITEM_RECOMMENDED),

		list("收纳袋 (任选两件)", 0, null, null, null),
		list("建材袋", 0, /obj/item/storage/pouch/construction, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("急救袋 (可补充注射器)", 0, /obj/item/storage/pouch/firstaid/full, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("急救袋 (夹板, 医用纱布, 烧伤药膏)", 0, /obj/item/storage/pouch/firstaid/full/alternate, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("急救袋 (药片包)", 0, /obj/item/storage/pouch/firstaid/full/pills, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("电子器材袋 (满装)", 0, /obj/item/storage/pouch/electronics/full, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("爆炸物袋", 0, /obj/item/storage/pouch/explosive, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("照明弹袋 (满装)", 0, /obj/item/storage/pouch/flare/full, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("大型手枪弹匣袋", 0, /obj/item/storage/pouch/magazine/pistol/large, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("弹匣袋", 0, /obj/item/storage/pouch/magazine, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("霰弹袋", 0, /obj/item/storage/pouch/shotgun, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("中型杂物袋", 0, /obj/item/storage/pouch/general/medium, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("手枪袋", 0, /obj/item/storage/pouch/pistol, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("工具袋 (满装)", 0, /obj/item/storage/pouch/tools/full, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("工兵工具包袋", 0, /obj/item/storage/pouch/engikit, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),


		list("饰品 (任选一件)", 0, null, null, null),
		list("黑色携行背心", 0, /obj/item/clothing/accessory/storage/black_vest, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("棕色携行背心", 0, /obj/item/clothing/accessory/storage/black_vest/brown_vest, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_RECOMMENDED),
		list("肩部枪套", 0, /obj/item/clothing/accessory/storage/holster, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("携行带", 0, /obj/item/clothing/accessory/storage/webbing, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("挂袋", 0, /obj/item/clothing/accessory/storage/droppouch, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("小型工具携行带 (满装)", 0, /obj/item/clothing/accessory/storage/tool_webbing/small/equipped, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),

		list("面罩 (任选一件)", 0, null, null, null),
		list("防毒面具", 0, /obj/item/clothing/mask/gas, MARINE_CAN_BUY_MASK, VENDOR_ITEM_REGULAR),
		list("吸热头套", 0, /obj/item/clothing/mask/rebreather/scarf, MARINE_CAN_BUY_MASK, VENDOR_ITEM_REGULAR),
	))

/obj/structure/machinery/cm_vending/clothing/engi
	name = "ColMarTech小队战斗技术员装备架"
	desc = "连接着巨型战斗技术员制式装备仓库的自动装备架。"
	req_access = list(ACCESS_MARINE_ENGPREP)
	vendor_role = list(JOB_SQUAD_ENGI)

/obj/structure/machinery/cm_vending/clothing/engi/get_listed_products(mob/user)
	return GLOB.cm_vending_clothing_engi

/obj/structure/machinery/cm_vending/clothing/engi/alpha
	squad_tag = SQUAD_MARINE_1
	req_access = list(ACCESS_MARINE_ENGPREP, ACCESS_MARINE_ALPHA)
	gloves_type = /obj/item/clothing/gloves/marine
	headset_type = /obj/item/device/radio/headset/almayer/marine/alpha/engi

/obj/structure/machinery/cm_vending/clothing/engi/bravo
	squad_tag = SQUAD_MARINE_2
	req_access = list(ACCESS_MARINE_ENGPREP, ACCESS_MARINE_BRAVO)
	gloves_type = /obj/item/clothing/gloves/marine
	headset_type = /obj/item/device/radio/headset/almayer/marine/bravo/engi

/obj/structure/machinery/cm_vending/clothing/engi/charlie
	squad_tag = SQUAD_MARINE_3
	req_access = list(ACCESS_MARINE_ENGPREP, ACCESS_MARINE_CHARLIE)
	gloves_type = /obj/item/clothing/gloves/marine
	headset_type = /obj/item/device/radio/headset/almayer/marine/charlie/engi

/obj/structure/machinery/cm_vending/clothing/engi/delta
	squad_tag = SQUAD_MARINE_4
	req_access = list(ACCESS_MARINE_ENGPREP, ACCESS_MARINE_DELTA)
	gloves_type = /obj/item/clothing/gloves/marine
	headset_type = /obj/item/device/radio/headset/almayer/marine/delta/engi

//------------ESSENTIAL SETS---------------

/obj/effect/essentials_set/engi
	spawned_gear_list = list(
		/obj/item/explosive/plastic,
		/obj/item/stack/sandbags_empty = 25,
		/obj/item/stack/sheet/metal/large_stack,
		/obj/item/stack/sheet/plasteel/med_large_stack,
		/obj/item/circuitboard/apc,
		/obj/item/cell/high,
		/obj/item/tool/shovel/etool/folded,
		/obj/item/device/lightreplacer,
		/obj/item/weapon/gun/smg/nailgun/compact/tactical,
	)

// RMC engi-vendor

/obj/effect/essentials_set/rmcengi
	spawned_gear_list = list(
		/obj/item/clothing/accessory/storage/tool_webbing/tactical,
		/obj/item/storage/pouch/tools/tactical/rmc,
		/obj/item/defenses/handheld/tesla_coil/stun/rmc,
		/obj/item/storage/toolkit/full,
	)

GLOBAL_LIST_INIT(cm_vending_clothing_rmc_engi, list(
		list("工程套装 (必选)", 0, null, null, null),
		list("必备工程套装", 0, /obj/effect/essentials_set/rmcengi, MARINE_CAN_BUY_ESSENTIALS, VENDOR_ITEM_MANDATORY),

		list("重型破障装备 (任选一件)", 0, null, null, null),
		list("破障锤", 0, /obj/item/weapon/twohanded/breacher, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),

		list("背包 (任选一件)", 0, null, null, null),
		list("重型背包", 0, /obj/item/storage/backpack/rmc/heavy, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_REGULAR),
		list("工程背包", 0, /obj/item/storage/backpack/marine/engineerpack/satchel/rmc, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_RECOMMENDED),
		list("标准背包", 0, /obj/item/storage/backpack/rmc/medium, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_REGULAR),
		list("轻型背包", 0, /obj/item/storage/backpack/rmc/light, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_REGULAR),

		list("腰带 (任选一件)", 0, null, null, null),
		list("L70 式弹药携行挂具", 0, /obj/item/storage/belt/marine/rmc, MARINE_CAN_BUY_BELT, VENDOR_ITEM_RECOMMENDED),
		list("L26 式通用杂物腰带", 0, /obj/item/storage/backpack/general_belt/rmc, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("L165 枪械腰带", 0, /obj/item/storage/belt/gun/l905, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),

		list("饰品 (任选一件)", 0, null, null, null),
		list("挂袋", 0, /obj/item/clothing/accessory/storage/droppouch/rmc, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_RECOMMENDED),
		list("小型收纳袋", 0, /obj/item/clothing/accessory/storage/smallpouch/rmc, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("腰部枪套", 0, /obj/item/clothing/accessory/storage/holster/waist, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
	))

/obj/structure/machinery/cm_vending/clothing/engi/rmc
	name = "维兰科技班组工程装备架"
	desc = "连接着巨型制式工程装备仓库的自动装备架。"
	icon_state = "eng_gear"
	req_access = list(ACCESS_TWE_ENGPREP)
	vendor_role = list(JOB_TWE_RMC_ENGI)
	vendor_theme = VENDOR_THEME_COMPANY

/obj/structure/machinery/cm_vending/clothing/engi/rmc/get_listed_products(mob/user)
	return GLOB.cm_vending_clothing_rmc_engi

// Mortar/Fire Support vendor

/obj/effect/essentials_set/rmcmortar
	spawned_gear_list = list(
		/obj/item/mortar_kit/rmc,
		/obj/item/storage/belt/gun/mortarbelt/rmc,
		/obj/item/device/binoculars/range,
		/obj/item/tool/wrench,
	)

/obj/effect/essentials_set/rmcgl
	spawned_gear_list = list(
		/obj/item/weapon/gun/launcher/grenade/m92/rmc,
		/obj/item/storage/belt/gun/mortarbelt/rmc,
	)


GLOBAL_LIST_INIT(cm_vending_mortar_gear, list(
		list("火力支援套装 (必选)", 0, null, null, null),
		list("L53A1 轻型迫击炮套件", 0, /obj/effect/essentials_set/rmcmortar, MARINE_CAN_BUY_ESSENTIALS, VENDOR_ITEM_MANDATORY),
		list("L164A3 MGL 套件", 0, /obj/effect/essentials_set/rmcgl, MARINE_CAN_BUY_ESSENTIALS, VENDOR_ITEM_REGULAR),

		list("迫击炮弹", 0, null, null, null),
		list("高爆迫击炮弹", 15, /obj/item/mortar_shell/he, null, VENDOR_ITEM_REGULAR),
		list("破片迫击炮弹", 10, /obj/item/mortar_shell/frag, null, VENDOR_ITEM_REGULAR),
		list("燃烧迫击炮弹", 15, /obj/item/mortar_shell/incendiary, null, VENDOR_ITEM_REGULAR),
		list("烟幕迫击炮弹", 10, /obj/item/mortar_shell/smoke, null, VENDOR_ITEM_REGULAR),
		list("白磷爆破迫击炮弹", 25, /obj/item/mortar_shell/phosphorus, null, VENDOR_ITEM_REGULAR),
		list("照明／摄像迫击炮弹", 10, /obj/item/mortar_shell/flare, null, VENDOR_ITEM_REGULAR),

		list("20MM 手榴弹包", 0, null, null, null),
		list("L103A1 20mm HE", 20, /obj/item/storage/box/packet/rmc/mini, null, VENDOR_ITEM_REGULAR),
		list("L104A1 20mm 破片弹", 20, /obj/item/storage/box/packet/rmc/mini/frag, null, VENDOR_ITEM_REGULAR),
		list("L103A1/I 20mm 燃烧弹", 20, /obj/item/storage/box/packet/rmc/mini/incen, null, VENDOR_ITEM_REGULAR),
		list("L108A1 20mm HESH", 30, /obj/item/storage/box/packet/rmc/mini/squash, null, VENDOR_ITEM_REGULAR),
		list("L104A1/H 20mm 全息标记弹", 20, /obj/item/storage/box/packet/rmc/mini/holo, null, VENDOR_ITEM_REGULAR),
		list("L101A2 20mm 神经毒剂弹", 30, /obj/item/storage/box/packet/rmc/mini/gas, null, VENDOR_ITEM_REGULAR),

	))

/obj/structure/machinery/cm_vending/gear/mortar_stuff
	name = "维兰科技班组火力支援装备架"
	desc = "装有专用火力支援装备的自动装备架，供 RMC 部队的炮火支援专家使用。"
	icon_state = "mor_gear"
	show_points = TRUE
	use_snowflake_points = TRUE
	req_access = list(ACCESS_TWE_HEVWEAPPREP)
	vendor_theme = VENDOR_THEME_COMPANY
	vendor_role = list(JOB_TWE_RMC_BREACHER)

/obj/structure/machinery/cm_vending/gear/mortar_stuff/get_listed_products(mob/user)
	return GLOB.cm_vending_mortar_gear
