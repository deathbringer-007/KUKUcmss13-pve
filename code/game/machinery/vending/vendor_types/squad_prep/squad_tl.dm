//------------GEAR VENDOR---------------

GLOBAL_LIST_INIT(cm_vending_gear_tl, list(
		list("爆炸物", 0, null, null, null),
		list("M40 HEDP 高爆包 (x3 手榴弹)", 18, /obj/item/storage/box/packet/high_explosive, null, VENDOR_ITEM_REGULAR),
		list("M40 HIDP 燃烧弹包 (x3 手榴弹)", 18, /obj/item/storage/box/packet/incendiary, null, VENDOR_ITEM_REGULAR),
		list("M40 WPDP 白磷包 (x3 手榴弹)", 18, /obj/item/storage/box/packet/phosphorus, null, VENDOR_ITEM_REGULAR),
		list("M40 HSDP 烟幕包 (x3 手榴弹)", 9, /obj/item/storage/box/packet/smoke, null, VENDOR_ITEM_REGULAR),
		list("M20 地雷盒 (x5 地雷)", 20, /obj/item/storage/box/explosive_mines, null, VENDOR_ITEM_REGULAR),
		list("M40 MFHS 金属泡沫手榴弹", 5, /obj/item/explosive/grenade/metal_foam, null, VENDOR_ITEM_REGULAR),
		list("G2 电击手榴弹包 (x3 手榴弹)",  16, /obj/item/storage/box/packet/sebb, null, VENDOR_ITEM_REGULAR),

		list("主武器弹药", 0, null, null, null),
		list("M49A 穿甲弹匣 (10x24mm)", 10, /obj/item/ammo_magazine/rifle/m49a/ap, null, VENDOR_ITEM_REGULAR),
		list("M39 穿甲弹匣 (10x20mm)", 10, /obj/item/ammo_magazine/smg/m39/ap , null, VENDOR_ITEM_REGULAR),
		list("M39 扩容弹匣 (10x20mm)", 10, /obj/item/ammo_magazine/smg/m39/extended , null, VENDOR_ITEM_REGULAR),
		list("M41A 穿甲弹匣 (10x24mm)", 10, /obj/item/ammo_magazine/rifle/ap , null, VENDOR_ITEM_REGULAR),
		list("M41A 扩容弹匣 (10x24mm)", 10, /obj/item/ammo_magazine/rifle/extended , null, VENDOR_ITEM_REGULAR),

		list("副武器弹药", 0, null, null, null),
		list("M44 重型快速装弹器 (.44)", 10, /obj/item/ammo_magazine/revolver/heavy, null, VENDOR_ITEM_REGULAR),
		list("M44 精确射手快速装弹器 (.44)", 10, /obj/item/ammo_magazine/revolver/marksman, null, VENDOR_ITEM_REGULAR),
		list("M4A3 空尖弹匣", 5, /obj/item/ammo_magazine/pistol/hp, null, VENDOR_ITEM_REGULAR),
		list("M4A3 穿甲弹匣", 5, /obj/item/ammo_magazine/pistol/ap, null, VENDOR_ITEM_REGULAR),
		list("VP78 弹匣", 5, /obj/item/ammo_magazine/pistol/vp78, null, VENDOR_ITEM_REGULAR),
		list("SU-6 智能手枪弹匣 (.45)", 10, /obj/item/ammo_magazine/pistol/smart, null, VENDOR_ITEM_REGULAR),

		list("限配枪械", 0, null, null, null),
		list("VP78 手枪", 10, /obj/item/storage/box/guncase/vp78, null, VENDOR_ITEM_REGULAR),
		list("SU-6 智能手枪", 15, /obj/item/storage/box/guncase/smartpistol, null, VENDOR_ITEM_REGULAR),
		list("M79 榴弹发射器", 30, /obj/item/storage/box/guncase/m79, null, VENDOR_ITEM_REGULAR),

		list("护甲", 0, null, null, null),
		list("M3 B12 式陆战队护甲", 30, /obj/item/clothing/suit/storage/marine/medium/leader, null, VENDOR_ITEM_REGULAR),

		list("服装", 0, null, null, null),
		list("砍刀鞘 (满装)", 5, /obj/item/storage/large_holster/machete/full, null, VENDOR_ITEM_REGULAR),
		list("砍刀袋 (满装)", 15, /obj/item/storage/pouch/machete/full, null, VENDOR_ITEM_REGULAR),
		list("USCM 无线电话背包", 5, /obj/item/storage/backpack/marine/satchel/rto, null, VENDOR_ITEM_REGULAR),
		list("焊接护目镜", 3, /obj/item/clothing/glasses/welding, null, VENDOR_ITEM_REGULAR),
		list("M276 式战斗工具携行腰带", 15, /obj/item/storage/belt/gun/utility, null, VENDOR_ITEM_REGULAR),
		list("自动注射器收纳袋 (满装)", 15, /obj/item/storage/pouch/autoinjector/full, null, VENDOR_ITEM_REGULAR),
		list("绝缘手套", 3, /obj/item/clothing/gloves/yellow, null, VENDOR_ITEM_REGULAR),
		list("夜视目镜", 30, /obj/item/device/helmet_visor/night_vision, null, VENDOR_ITEM_RECOMMENDED),

		list("工程用品", 0, null, null, null),
		list("塑性炸药", 10, /obj/item/explosive/plastic, null, VENDOR_ITEM_REGULAR),
		list("破障炸药", 10, /obj/item/explosive/plastic/breaching_charge, null, VENDOR_ITEM_REGULAR),
		list("ES-11 移动燃料罐", 5, /obj/item/tool/weldpack/minitank, null, VENDOR_ITEM_REGULAR),
		list("ME3 手持焊炬", 5, /obj/item/tool/weldingtool/simple, null, VENDOR_ITEM_REGULAR),

		list("勤务服", 0, null, null, null),
		list("运动探测器", 15, /obj/item/device/motiondetector, null, VENDOR_ITEM_RECOMMENDED),
		list("轮式担架床", 5, /obj/item/roller, null, VENDOR_ITEM_REGULAR),
		list("富尔顿回收装置组", 5, /obj/item/stack/fulton, null, VENDOR_ITEM_REGULAR),
		list("灭火器 (便携式)", 5, /obj/item/tool/extinguisher/mini, null, VENDOR_ITEM_REGULAR),
		list("哨子", 5, /obj/item/device/whistle, null, VENDOR_ITEM_REGULAR),

		list("双筒望远镜", 0, null, null, null),
		list("双筒望远镜", 5, /obj/item/device/binoculars, null, VENDOR_ITEM_REGULAR),
		list("测距仪", 10, /obj/item/device/binoculars/range, null, VENDOR_ITEM_REGULAR),
		list("激光目标指示器", 15, /obj/item/device/binoculars/range/designator, null, VENDOR_ITEM_REGULAR),

		list("头盔光学设备", 0, null, null, null),
		list("头盔医疗镜片", 15, /obj/item/device/helmet_visor/medical, null, VENDOR_ITEM_REGULAR),
		list("焊接面罩", 5, /obj/item/device/helmet_visor/welding_visor, null, VENDOR_ITEM_REGULAR),

		list("无线电密钥", 0, null, null, null),
		list("工程无线电加密密钥", 5, /obj/item/device/encryptionkey/engi, null, VENDOR_ITEM_REGULAR),
		list("情报无线电加密密钥", 5, /obj/item/device/encryptionkey/intel, null, VENDOR_ITEM_REGULAR),
		list("JTAC 无线电加密密钥", 5, /obj/item/device/encryptionkey/jtac, null, VENDOR_ITEM_REGULAR),
		list("补给无线电加密密钥", 5, /obj/item/device/encryptionkey/req, null, VENDOR_ITEM_REGULAR),
	))

/obj/structure/machinery/cm_vending/gear/tl
	name = "ColMarTech战斗组长用品架"
	desc = "供战斗组长使用的自动装备架。"
	icon_state = "intel_gear"
	show_points = TRUE
	req_access = list(ACCESS_MARINE_TL_PREP)
	vendor_role = list(JOB_SQUAD_TEAM_LEADER)

/obj/structure/machinery/cm_vending/gear/tl/get_listed_products(mob/user)
	return GLOB.cm_vending_gear_tl

//------------CLOTHING VENDOR---------------

GLOBAL_LIST_INIT(cm_vending_clothing_tl, list(
		list("标准装备 (全部领取)", 0, null, null, null),
		list("陆战队标准服装", 0, list(/obj/item/clothing/under/marine, /obj/item/clothing/shoes/marine/knife, /obj/item/clothing/gloves/marine, /obj/item/device/radio/headset/almayer/marine, /obj/item/clothing/head/helmet/marine/rto), MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_MANDATORY),
		list("M4 式护甲", 0, /obj/item/clothing/suit/storage/marine/medium/rto, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_MANDATORY),
		list("即食军粮", 0, /obj/item/storage/box/mre, MARINE_CAN_BUY_MRE, VENDOR_ITEM_MANDATORY),
		list("地图", 0, /obj/item/map/current_map, MARINE_CAN_BUY_KIT, VENDOR_ITEM_MANDATORY),
		list("战斗组长必备用品", 0, /obj/effect/essentials_set/tl, MARINE_CAN_BUY_ESSENTIALS, VENDOR_ITEM_MANDATORY),

		list("腰带 (任选一件)", 0, null, null, null),
		list("G8-A 通用杂物袋", 0, /obj/item/storage/backpack/general_belt, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 弹药携行挂具", 0, /obj/item/storage/belt/marine, MARINE_CAN_BUY_BELT, VENDOR_ITEM_RECOMMENDED),
		list("M276 通用手枪枪套挂具", 0, /obj/item/storage/belt/gun/m4a3, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 M39 枪套挂具", 0, /obj/item/storage/belt/gun/m39, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 通用左轮手枪枪套挂具", 0, /obj/item/storage/belt/gun/m44, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 M82F 枪套挂具", 0, /obj/item/storage/belt/gun/flaregun, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 霰弹装填挂具", 0, /obj/item/storage/belt/shotgun, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 工具携行腰带 (满装)", 0, /obj/item/storage/belt/utility/full, MARINE_CAN_BUY_BELT, VENDOR_ITEM_RECOMMENDED),
		list("M276 M40 手榴弹携行挂具", 0, /obj/item/storage/belt/grenade, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),

		list("收纳袋 (任选两件)", 0, null, null, null),
		list("急救袋 (可补充注射器)", 0, /obj/item/storage/pouch/firstaid/full, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("急救袋 (夹板, 医用纱布, 烧伤药膏)", 0, /obj/item/storage/pouch/firstaid/full/alternate, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("急救袋 (药片包)", 0, /obj/item/storage/pouch/firstaid/full/pills, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("急救响应袋", 0, /obj/item/storage/pouch/first_responder, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("照明弹袋 (满装)", 0, /obj/item/storage/pouch/flare/full, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("燃料罐绑带袋", 0, /obj/item/storage/pouch/flamertank, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("大型杂物袋", 0, /obj/item/storage/pouch/general/large, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("枪带袋", 0, /obj/item/storage/pouch/sling, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("大型手枪弹匣袋", 0, /obj/item/storage/pouch/magazine/pistol/large, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("弹匣袋", 0, /obj/item/storage/pouch/magazine, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("霰弹袋", 0, /obj/item/storage/pouch/shotgun, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("副武器袋", 0, /obj/item/storage/pouch/pistol, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("工具袋 (满装)", 0, /obj/item/storage/pouch/tools/full, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),

		list("饰品 (任选一件)", 0, null, null, null),
		list("黑色携行背心", 0, /obj/item/clothing/accessory/storage/black_vest, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("棕色携行背心", 0, /obj/item/clothing/accessory/storage/black_vest/brown_vest, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_RECOMMENDED),
		list("肩部枪套", 0, /obj/item/clothing/accessory/storage/holster, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("携行带", 0, /obj/item/clothing/accessory/storage/webbing, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("挂袋", 0, /obj/item/clothing/accessory/storage/droppouch, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),

		list("面罩 (任选一件)", 0, null, null, null),
		list("防毒面具", 0, /obj/item/clothing/mask/gas, MARINE_CAN_BUY_MASK, VENDOR_ITEM_REGULAR),
		list("吸热头套", 0, /obj/item/clothing/mask/rebreather/scarf, MARINE_CAN_BUY_MASK, VENDOR_ITEM_REGULAR)
	))

//MARINE_CAN_BUY_SHOES MARINE_CAN_BUY_UNIFORM currently not used
/obj/structure/machinery/cm_vending/clothing/tl
	name = "ColMarTech战斗组长装备架"
	desc = "连接着巨型战斗组长制式装备仓库的自动装备架。"
	req_access = list(ACCESS_MARINE_TL_PREP)
	vendor_role = list(JOB_SQUAD_TEAM_LEADER)

/obj/structure/machinery/cm_vending/clothing/tl/get_listed_products(mob/user)
	return GLOB.cm_vending_clothing_tl

/obj/structure/machinery/cm_vending/clothing/tl/alpha
	squad_tag = SQUAD_MARINE_1
	req_access = list(ACCESS_MARINE_TL_PREP, ACCESS_MARINE_ALPHA)
	gloves_type = /obj/item/clothing/gloves/marine
	headset_type = /obj/item/device/radio/headset/almayer/marine/alpha/tl

/obj/structure/machinery/cm_vending/clothing/tl/bravo
	squad_tag = SQUAD_MARINE_2
	req_access = list(ACCESS_MARINE_TL_PREP, ACCESS_MARINE_BRAVO)
	gloves_type = /obj/item/clothing/gloves/marine
	headset_type = /obj/item/device/radio/headset/almayer/marine/bravo/tl

/obj/structure/machinery/cm_vending/clothing/tl/charlie
	squad_tag = SQUAD_MARINE_3
	req_access = list(ACCESS_MARINE_TL_PREP, ACCESS_MARINE_CHARLIE)
	gloves_type = /obj/item/clothing/gloves/marine
	headset_type = /obj/item/device/radio/headset/almayer/marine/charlie/tl

/obj/structure/machinery/cm_vending/clothing/tl/delta
	squad_tag = SQUAD_MARINE_4
	req_access = list(ACCESS_MARINE_TL_PREP, ACCESS_MARINE_DELTA)
	gloves_type = /obj/item/clothing/gloves/marine
	headset_type = /obj/item/device/radio/headset/almayer/marine/delta/tl

//------------ESSENTIAL SETS---------------
/obj/effect/essentials_set/tl
	spawned_gear_list = list(
		/obj/item/device/binoculars/range/designator,
		/obj/item/storage/box/flare/signal,
		/obj/item/storage/box/flare/signal,
	)
