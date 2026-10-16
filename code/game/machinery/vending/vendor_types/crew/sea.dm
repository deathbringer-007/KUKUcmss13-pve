//------------GEAR VENDOR---------------

GLOBAL_LIST_INIT(cm_vending_gear_sea, list(
		list("个人主武器 (任选一件)", 0, null, null, null),
		list("M41A MK1 脉冲步枪", 0, /obj/item/weapon/gun/rifle/m41aMK1, MARINE_CAN_BUY_SECONDARY, VENDOR_ITEM_REGULAR),

		list("备用弹药", 0, null, null, null),
		list("M41A MK1 弹匣", 9, /obj/item/ammo_magazine/rifle/m41aMK1, null, VENDOR_ITEM_REGULAR),

		list("枪械配件 (任选一件)", 0, null, null, null),
		list("激光瞄准器", 0, /obj/item/attachable/lasersight, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
		list("红点瞄准镜", 0, /obj/item/attachable/reddot, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
		list("反射式瞄准镜", 0, /obj/item/attachable/reflex, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
		list("导轨手电筒", 0, /obj/item/attachable/flashlight, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
	))

/obj/structure/machinery/cm_vending/gear/di
	name = "ColMarTech教官武器架"
	desc = "供训练教官使用的自动装备架。"
	req_access = list(ACCESS_MARINE_SEA)
	vendor_role = list(JOB_DI)
	icon_state = "guns"

/obj/structure/machinery/cm_vending/gear/di/get_listed_products(mob/user)
	return GLOB.cm_vending_gear_sea

//------------CLOTHING VENDOR---------------

GLOBAL_LIST_INIT(cm_vending_clothing_di, list(
		list("标准装备 (全部领取)", 0, null, null, null),
		list("教官帽", 0, /obj/item/clothing/head/drillhat, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_RECOMMENDED),
		list("军官制服", 0, /obj/item/clothing/under/marine/dress, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_MANDATORY),
		list("USCM 常服外套", 0, /obj/item/clothing/suit/storage/jacket/marine/service, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_REGULAR),
		list("陆战队战斗靴", 0, /obj/item/clothing/shoes/marine/knife, MARINE_CAN_BUY_SHOES, VENDOR_ITEM_MANDATORY),
		list("耳机", 0, /obj/item/device/radio/headset/almayer/mcom/cdrcom, MARINE_CAN_BUY_EAR, VENDOR_ITEM_MANDATORY),
		list("挎包", 0, /obj/item/storage/backpack/satchel/lockable, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_MANDATORY),
		list("即食军粮", 0, /obj/item/storage/box/mre, MARINE_CAN_BUY_MRE, VENDOR_ITEM_MANDATORY),

		list("手套 (任选一件)", 0, null, null, null),
		list("绝缘手套", 0, /obj/item/clothing/gloves/yellow, MARINE_CAN_BUY_GLOVES, VENDOR_ITEM_REGULAR),
		list("陆战队战斗手套", 0, /obj/item/clothing/gloves/marine, MARINE_CAN_BUY_GLOVES, VENDOR_ITEM_REGULAR),

		list("腰带 (任选一件)", 0, null, null, null),
		list("G8-A 通用杂物袋", 0, /obj/item/storage/backpack/general_belt, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 救生医疗包 (满装)", 0, /obj/item/storage/belt/medical/lifesaver/full, MARINE_CAN_BUY_BELT, VENDOR_ITEM_RECOMMENDED),
		list("M276 工具携行腰带 (满装)", 0, /obj/item/storage/belt/utility/full, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 战斗工具携行腰带 (满装)", 0, /obj/item/storage/belt/gun/utility/full, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),

		list("收纳袋 (任选两件)", 0, null, null, null),
		list("自动注射器收纳袋", 0, /obj/item/storage/pouch/autoinjector/full, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("大型杂物袋", 0, /obj/item/storage/pouch/general/large, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("大型弹匣袋", 0, /obj/item/storage/pouch/magazine/large, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("大型手枪弹匣袋", 0, /obj/item/storage/pouch/magazine/pistol/large, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("大型霰弹袋", 0, /obj/item/storage/pouch/shotgun/large, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("医疗套件袋", 0, /obj/item/storage/pouch/medkit, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("副武器袋", 0, /obj/item/storage/pouch/pistol, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("枪带袋", 0, /obj/item/storage/pouch/sling, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),

		list("战斗护甲 (任选一件)", 0, null, null, null),
		list("M3-VL 式防弹背心", 0, /obj/item/clothing/suit/storage/marine/light/vest, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_REGULAR),
		list("M3-L 式轻型护甲", 0, /obj/item/clothing/suit/storage/marine/light, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_RECOMMENDED),
		list("M3 式陆战队护甲", 0, /obj/item/clothing/suit/storage/marine, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_REGULAR),
		list("防弹背心", 0, /obj/item/clothing/suit/armor/bulletproof, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_REGULAR),
		list("M10 头盔", 0, /obj/item/clothing/head/helmet/marine, MARINE_CAN_BUY_COMBAT_HELMET, VENDOR_ITEM_REGULAR),

		list("眼部装备 (任选一件)", 0, null, null, null),
		list("焊接护目镜", 0, /obj/item/clothing/glasses/welding, MARINE_CAN_BUY_GLASSES, VENDOR_ITEM_REGULAR),
		list("医疗抬头显示眼镜", 0, /obj/item/clothing/glasses/hud/health, MARINE_CAN_BUY_GLASSES, VENDOR_ITEM_REGULAR),
		list("矫视型医疗抬头显示眼镜", 0, /obj/item/clothing/glasses/hud/health/prescription, MARINE_CAN_BUY_GLASSES, VENDOR_ITEM_REGULAR),
		list("太阳镜", 0, /obj/item/clothing/glasses/sunglasses, MARINE_CAN_BUY_GLASSES, VENDOR_ITEM_REGULAR),

		list("饰品 (任选一件)", 0, null, null, null),
		list("棕色携行背心", 0, /obj/item/clothing/accessory/storage/black_vest/brown_vest, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("黑色携行背心", 0, /obj/item/clothing/accessory/storage/black_vest, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("肩部枪套", 0, /obj/item/clothing/accessory/storage/holster, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("携行带", 0, /obj/item/clothing/accessory/storage/webbing, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("挂袋", 0, /obj/item/clothing/accessory/storage/droppouch, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
	))

/obj/structure/machinery/cm_vending/clothing/di
	name = "ColMarTech资深士官顾问装备架"
	desc = "连接着巨型资深士官顾问制式装备仓库的自动装备架。"
	req_access = list(ACCESS_MARINE_SEA)
	vendor_role = list(JOB_DI)

/obj/structure/machinery/cm_vending/clothing/di/get_listed_products(mob/user)
	return GLOB.cm_vending_clothing_di
