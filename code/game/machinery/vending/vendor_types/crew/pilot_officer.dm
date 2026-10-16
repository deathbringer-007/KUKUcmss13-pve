//------------PILOT OFFICER REQUIPMENT RACK---------------

/obj/structure/machinery/cm_vending/sorted/cargo_guns/pilot_officer
	name = "ColMarTech运输艇机组武器架"
	desc = "连接着小型制式武器仓库的自动武器架。仅限运输艇机组使用。"
	icon_state = "guns"
	req_access = list(ACCESS_MARINE_PILOT)
	vendor_role = list(JOB_CAS_PILOT, JOB_DROPSHIP_PILOT, JOB_DROPSHIP_CREW_CHIEF)
	vend_flags = VEND_CLUTTER_PROTECTION | VEND_LIMITED_INVENTORY | VEND_TO_HAND

	listed_products = list(
		list("主武器枪械", -1, null, null),
		list("M49A 战斗步枪", 4, /obj/item/weapon/gun/rifle/m49a, VENDOR_ITEM_REGULAR),
		list("M39 冲锋枪", 4, /obj/item/weapon/gun/smg/m39, VENDOR_ITEM_REGULAR),
		list("M37A2 泵动霰弹枪", 4, /obj/item/weapon/gun/shotgun/pump, VENDOR_ITEM_REGULAR),
		list("M41A 脉冲步枪 MK2", 4, /obj/item/weapon/gun/rifle/m41a, VENDOR_ITEM_REGULAR),

		list("主武器弹药", -1, null, null),
		list("整箱鹿弹 (12g)", 12, /obj/item/ammo_magazine/shotgun/buckshot, VENDOR_ITEM_REGULAR),
		list("整箱箭形弹 (12g)", 12, /obj/item/ammo_magazine/shotgun/flechette, VENDOR_ITEM_REGULAR),
		list("整箱霰弹枪独头弹 (12g)", 12, /obj/item/ammo_magazine/shotgun/slugs, VENDOR_ITEM_REGULAR),
		list("M49A 弹匣 (10x24mm)", 24, /obj/item/ammo_magazine/rifle/m49a, VENDOR_ITEM_REGULAR),
		list("M39 高速弹匣 (10x20mm)", 24, /obj/item/ammo_magazine/smg/m39, VENDOR_ITEM_REGULAR),
		list("M41A 弹匣 (10x24mm)", 24, /obj/item/ammo_magazine/rifle, VENDOR_ITEM_REGULAR),

		list("副武器", -1, null, null),
		list("VP70 战斗手枪", 4, /obj/item/weapon/gun/pistol/vp70, VENDOR_ITEM_REGULAR),
		list("M44 战斗左轮手枪", 4, /obj/item/weapon/gun/revolver/m44, VENDOR_ITEM_REGULAR),
		list("M4A3 制式手枪", 4, /obj/item/weapon/gun/pistol/m4a3, VENDOR_ITEM_REGULAR),
		list("M82F 信号枪", 4, /obj/item/weapon/gun/flare, VENDOR_ITEM_REGULAR),

		list("副武器弹药", -1, null, null),
		list("VP70 弹匣 (9mm)", 20, /obj/item/ammo_magazine/pistol/vp70, VENDOR_ITEM_REGULAR),
		list("M44 快速装弹器 (.44)", 20, /obj/item/ammo_magazine/revolver, VENDOR_ITEM_REGULAR),
		list("M4A3 弹匣 (9mm)", 20, /obj/item/ammo_magazine/pistol, VENDOR_ITEM_REGULAR),
		list("M4A3 穿甲弹匣 (9mm)", 12, /obj/item/ammo_magazine/pistol/ap, VENDOR_ITEM_REGULAR),
		list("M4A3 空尖弹匣 (9mm)", 12, /obj/item/ammo_magazine/pistol/hp, VENDOR_ITEM_REGULAR),
		list("VP78 弹匣 (9mm)", 16, /obj/item/ammo_magazine/pistol/vp78, VENDOR_ITEM_REGULAR),

		list("配件", -1, null, null),
		list("导轨手电筒", 8, /obj/item/attachable/flashlight, VENDOR_ITEM_REGULAR),
		list("下挂手电握把", 4, /obj/item/attachable/flashlight/grip, VENDOR_ITEM_REGULAR),

		list("勤务服", -1, null, null),
		list("战斗手电筒", 4, /obj/item/device/flashlight/combat, VENDOR_ITEM_REGULAR),
		list("M5 刺刀", 4, /obj/item/attachable/bayonet, VENDOR_ITEM_REGULAR),
		list("M89-S 信号照明弹包", 1, /obj/item/storage/box/flare/signal, VENDOR_ITEM_REGULAR),
		list("M94 标记照明弹包", 10, /obj/item/storage/box/flare, VENDOR_ITEM_REGULAR)
	)

/obj/structure/machinery/cm_vending/sorted/cargo_guns/pilot_officer/populate_product_list(scale)
	return

//------------CLOTHING VENDOR---------------

/obj/effect/essentials_set/po_alternate
	spawned_gear_list = list(
		/obj/item/clothing/under/marine/officer/pilot/flight,
		/obj/item/clothing/suit/storage/jacket/marine/pilot,
	)

GLOBAL_LIST_INIT(cm_vending_clothing_pilot_officer, list(
		list("标准装备 (全部领取)", 0, null, null, null),
		list("手套", 0, /obj/item/clothing/gloves/yellow, MARINE_CAN_BUY_GLOVES, VENDOR_ITEM_MANDATORY),
		list("M30 战术头盔", 0, /obj/item/clothing/head/helmet/upp/marinepilot, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_MANDATORY),
		list("皮革挎包", 0, /obj/item/storage/backpack/satchel, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_MANDATORY),
		list("即食军粮", 0, /obj/item/storage/box/mre, MARINE_CAN_BUY_MRE, VENDOR_ITEM_MANDATORY),

		list("护甲 (任选一件)", 0, null, null, null),
		list("M70 防破片夹克", 0, /obj/item/clothing/suit/armor/vest/pilot, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_MANDATORY),
		list("M3-VL 式防破片背心", 0, /obj/item/clothing/suit/storage/marine/light/vest/dcc, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_MANDATORY),

		list("个人副武器 (任选一件)", 0, null, null, null),
		list("VP70 战斗手枪", 0, /obj/item/weapon/gun/pistol/vp70, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
		list("VP78 手枪", 0, /obj/item/weapon/gun/pistol/vp78, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),

		list("腰带 (任选一件)", 0, null, null, null),
		list("G8-A 通用杂物袋", 0, /obj/item/storage/backpack/general_belt, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 弹药携行挂具", 0, /obj/item/storage/belt/marine, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 救生医疗包 (满装)", 0, /obj/item/storage/belt/medical/lifesaver/full, MARINE_CAN_BUY_BELT, VENDOR_ITEM_RECOMMENDED),
		list("M276 医疗携行挂具 (满装)", 0, /obj/item/storage/belt/medical/full, MARINE_CAN_BUY_BELT, VENDOR_ITEM_RECOMMENDED),
		list("M276 M39 枪套挂具", 0, /obj/item/storage/belt/gun/m39, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 通用左轮手枪枪套挂具", 0, /obj/item/storage/belt/gun/m44, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 M82F 枪套挂具", 0, /obj/item/storage/belt/gun/flaregun, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 通用手枪枪套挂具", 0, /obj/item/storage/belt/gun/m4a3, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 霰弹装填挂具", 0, /obj/item/storage/belt/shotgun, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),

		list("收纳袋 (任选两件)", 0, null, null, null),
		list("急救袋 (可补充注射器)", 0, /obj/item/storage/pouch/firstaid/full, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("急救袋 (夹板, 医用纱布, 烧伤药膏)", 0, /obj/item/storage/pouch/firstaid/full/alternate, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("急救袋 (药片包)", 0, /obj/item/storage/pouch/firstaid/full/pills, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("急救响应袋", 0, /obj/item/storage/pouch/first_responder, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("照明弹袋 (满装)", 0, /obj/item/storage/pouch/flare/full, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("大型杂物袋", 0, /obj/item/storage/pouch/general/large, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("大型弹匣袋", 0, /obj/item/storage/pouch/magazine/large, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("大型手枪弹匣袋", 0, /obj/item/storage/pouch/magazine/pistol/large, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("大型霰弹袋", 0, /obj/item/storage/pouch/shotgun/large, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("医疗收纳袋", 0, /obj/item/storage/pouch/medical, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("医疗套件袋", 0, /obj/item/storage/pouch/medkit, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("副武器袋", 0, /obj/item/storage/pouch/pistol, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("枪带袋", 0, /obj/item/storage/pouch/sling, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),

		list("饰品 (任选一件)", 0, null, null, null),
		list("黑色携行背心", 0, /obj/item/clothing/accessory/storage/black_vest, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("棕色携行背心", 0, /obj/item/clothing/accessory/storage/black_vest/brown_vest, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_RECOMMENDED),
		list("肩部枪套", 0, /obj/item/clothing/accessory/storage/holster, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("携行带", 0, /obj/item/clothing/accessory/storage/webbing, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),

		list("眼镜 (任选一件)", 0, null, null, null),
		list("飞行员太阳镜", 0, /obj/item/clothing/glasses/sunglasses/aviator, MARINE_CAN_BUY_GLASSES, VENDOR_ITEM_REGULAR),
		list("医疗抬头显示眼镜", 0, /obj/item/clothing/glasses/hud/health, MARINE_CAN_BUY_GLASSES, VENDOR_ITEM_RECOMMENDED),
		list("太阳镜", 0, /obj/item/clothing/glasses/sunglasses, MARINE_CAN_BUY_GLASSES, VENDOR_ITEM_REGULAR),

		list("面罩 (任选一件)", 0, null, null, null),
		list("防毒面具", 0, /obj/item/clothing/mask/gas, MARINE_CAN_BUY_MASK, VENDOR_ITEM_REGULAR),
		list("吸热头套", 0, /obj/item/clothing/mask/rebreather/scarf, MARINE_CAN_BUY_MASK, VENDOR_ITEM_REGULAR),

		list("配件", 0, null, null, null),
		list("倾斜握把", 10, /obj/item/attachable/angledgrip, null, VENDOR_ITEM_REGULAR),
		list("加长枪管", 10, /obj/item/attachable/extended_barrel, null, VENDOR_ITEM_REGULAR),
		list("陀螺稳定器", 10, /obj/item/attachable/gyro, null, VENDOR_ITEM_REGULAR),
		list("激光瞄准器", 10, /obj/item/attachable/lasersight, null, VENDOR_ITEM_REGULAR),
		list("万能钥匙下挂霰弹枪", 10, /obj/item/attachable/attached_gun/shotgun, null, VENDOR_ITEM_REGULAR),
		list("M37 木制枪托", 10, /obj/item/attachable/stock/shotgun, null, VENDOR_ITEM_REGULAR),
		list("M39 枪托", 10, /obj/item/attachable/stock/smg, null, VENDOR_ITEM_REGULAR),
		list("M41A 固定枪托", 10, /obj/item/attachable/stock/rifle, null, VENDOR_ITEM_REGULAR),
		list("后坐补偿器", 10, /obj/item/attachable/compensator, null, VENDOR_ITEM_REGULAR),
		list("红点瞄准镜", 10, /obj/item/attachable/reddot, null, VENDOR_ITEM_REGULAR),
		list("反射式瞄准镜", 10, /obj/item/attachable/reflex, null, VENDOR_ITEM_REGULAR),
		list("消音器", 10, /obj/item/attachable/suppressor, null, VENDOR_ITEM_REGULAR),
		list("垂直握把", 10, /obj/item/attachable/verticalgrip, null, VENDOR_ITEM_REGULAR),

		list("弹药", 0, null, null, null),
		list("M49A 穿甲弹匣 (10x24mm)", 10, /obj/item/ammo_magazine/rifle/m49a/ap, null, VENDOR_ITEM_REGULAR),
		list("M39 穿甲弹匣 (10x20mm)", 10, /obj/item/ammo_magazine/smg/m39/ap, null, VENDOR_ITEM_REGULAR),
		list("M39 扩容弹匣 (10x20mm)", 10, /obj/item/ammo_magazine/smg/m39/extended, null, VENDOR_ITEM_REGULAR),
		list("M41A 穿甲弹匣 (10x24mm)", 10, /obj/item/ammo_magazine/rifle/ap, null, VENDOR_ITEM_REGULAR),
		list("M41A 扩容弹匣 (10x24mm)", 10, /obj/item/ammo_magazine/rifle/extended, null, VENDOR_ITEM_REGULAR),
		list("M44 重型快速装弹器 (.44)", 10, /obj/item/ammo_magazine/revolver/heavy, null, VENDOR_ITEM_REGULAR),

		list("勤务服", 0, null, null, null),
		list("飞行员飞行服套件", 10, /obj/effect/essentials_set/po_alternate, null, VENDOR_ITEM_REGULAR),
		list("灭火器 (便携式)", 5, /obj/item/tool/extinguisher/mini, null, VENDOR_ITEM_REGULAR),
		list("大型杂物袋", 15, /obj/item/storage/pouch/general/large, null, VENDOR_ITEM_REGULAR),
		list("大型弹匣袋", 15, /obj/item/storage/pouch/magazine/large, null, VENDOR_ITEM_REGULAR),
		list("砍刀鞘 (满装)", 10, /obj/item/storage/large_holster/machete/full, null, VENDOR_ITEM_REGULAR),
		list("砍刀袋 (满装)", 15, /obj/item/storage/pouch/machete/full, null, VENDOR_ITEM_REGULAR),
		list("运动探测器", 15, /obj/item/device/motiondetector, null, VENDOR_ITEM_RECOMMENDED)
	))

GLOBAL_LIST_INIT(cm_vending_clothing_dropship_crew_chief, list(
		list("标准装备 (全部领取)", 0, null, null, null),
		list("手套", 0, /obj/item/clothing/gloves/yellow, MARINE_CAN_BUY_GLOVES, VENDOR_ITEM_MANDATORY),
		list("巡逻帽", 0, /obj/item/clothing/head/cmcap, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_MANDATORY),
		list("皮革挎包", 0, /obj/item/storage/backpack/satchel, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_MANDATORY),
		list("即食军粮", 0, /obj/item/storage/box/mre, MARINE_CAN_BUY_MRE, VENDOR_ITEM_MANDATORY),

		list("护甲 (任选一件)", 0, null, null, null),
		list("M70 防破片夹克", 0, /obj/item/clothing/suit/armor/vest/pilot, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_MANDATORY),
		list("M3-VL 式防破片背心", 0, /obj/item/clothing/suit/storage/marine/light/vest/dcc, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_MANDATORY),

		list("个人副武器 (任选一件)", 0, null, null, null),
		list("VP70 战斗手枪", 0, /obj/item/weapon/gun/pistol/vp70, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
		list("VP78 手枪", 0, /obj/item/weapon/gun/pistol/vp78, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),

		list("腰带 (任选一件)", 0, null, null, null),
		list("G8-A 通用杂物袋", 0, /obj/item/storage/backpack/general_belt, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 弹药携行挂具", 0, /obj/item/storage/belt/marine, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 救生医疗包 (满装)", 0, /obj/item/storage/belt/medical/lifesaver/full, MARINE_CAN_BUY_BELT, VENDOR_ITEM_RECOMMENDED),
		list("M276 医疗携行挂具 (满装)", 0, /obj/item/storage/belt/medical/full, MARINE_CAN_BUY_BELT, VENDOR_ITEM_RECOMMENDED),
		list("M276 M39 枪套挂具", 0, /obj/item/storage/belt/gun/m39, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 通用左轮手枪枪套挂具", 0, /obj/item/storage/belt/gun/m44, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 M82F 枪套挂具", 0, /obj/item/storage/belt/gun/flaregun, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 通用手枪枪套挂具", 0, /obj/item/storage/belt/gun/m4a3, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 霰弹装填挂具", 0, /obj/item/storage/belt/shotgun, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),

		list("收纳袋 (任选两件)", 0, null, null, null),
		list("急救袋 (可补充注射器)", 0, /obj/item/storage/pouch/firstaid/full, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("急救袋 (夹板, 医用纱布, 烧伤药膏)", 0, /obj/item/storage/pouch/firstaid/full/alternate, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("急救袋 (药片包)", 0, /obj/item/storage/pouch/firstaid/full/pills, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("急救响应袋", 0, /obj/item/storage/pouch/first_responder, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("照明弹袋 (满装)", 0, /obj/item/storage/pouch/flare/full, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("大型杂物袋", 0, /obj/item/storage/pouch/general/large, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("大型弹匣袋", 0, /obj/item/storage/pouch/magazine/large, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("大型手枪弹匣袋", 0, /obj/item/storage/pouch/magazine/pistol/large, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("大型霰弹袋", 0, /obj/item/storage/pouch/shotgun/large, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("医疗收纳袋", 0, /obj/item/storage/pouch/medical, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("医疗套件袋", 0, /obj/item/storage/pouch/medkit, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("副武器袋", 0, /obj/item/storage/pouch/pistol, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("枪带袋", 0, /obj/item/storage/pouch/sling, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),

		list("饰品 (任选一件)", 0, null, null, null),
		list("黑色携行背心", 0, /obj/item/clothing/accessory/storage/black_vest, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("棕色携行背心", 0, /obj/item/clothing/accessory/storage/black_vest/brown_vest, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_RECOMMENDED),
		list("肩部枪套", 0, /obj/item/clothing/accessory/storage/holster, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("携行带", 0, /obj/item/clothing/accessory/storage/webbing, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("挂袋", 0, /obj/item/clothing/accessory/storage/droppouch, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),

		list("眼镜 (任选一件)", 0, null, null, null),
		list("飞行员太阳镜", 0, /obj/item/clothing/glasses/sunglasses/aviator, MARINE_CAN_BUY_GLASSES, VENDOR_ITEM_REGULAR),
		list("医疗抬头显示眼镜", 0, /obj/item/clothing/glasses/hud/health, MARINE_CAN_BUY_GLASSES, VENDOR_ITEM_RECOMMENDED),
		list("太阳镜", 0, /obj/item/clothing/glasses/sunglasses, MARINE_CAN_BUY_GLASSES, VENDOR_ITEM_REGULAR),

		list("面罩 (任选一件)", 0, null, null, null),
		list("防毒面具", 0, /obj/item/clothing/mask/gas, MARINE_CAN_BUY_MASK, VENDOR_ITEM_REGULAR),
		list("吸热头套", 0, /obj/item/clothing/mask/rebreather/scarf, MARINE_CAN_BUY_MASK, VENDOR_ITEM_REGULAR),

		list("配件", 0, null, null, null),
		list("倾斜握把", 10, /obj/item/attachable/angledgrip, null, VENDOR_ITEM_REGULAR),
		list("加长枪管", 10, /obj/item/attachable/extended_barrel, null, VENDOR_ITEM_REGULAR),
		list("陀螺稳定器", 10, /obj/item/attachable/gyro, null, VENDOR_ITEM_REGULAR),
		list("激光瞄准器", 10, /obj/item/attachable/lasersight, null, VENDOR_ITEM_REGULAR),
		list("万能钥匙下挂霰弹枪", 10, /obj/item/attachable/attached_gun/shotgun, null, VENDOR_ITEM_REGULAR),
		list("M37 木制枪托", 10, /obj/item/attachable/stock/shotgun, null, VENDOR_ITEM_REGULAR),
		list("M39 枪托", 10, /obj/item/attachable/stock/smg, null, VENDOR_ITEM_REGULAR),
		list("M41A 固定枪托", 10, /obj/item/attachable/stock/rifle, null, VENDOR_ITEM_REGULAR),
		list("后坐补偿器", 10, /obj/item/attachable/compensator, null, VENDOR_ITEM_REGULAR),
		list("红点瞄准镜", 10, /obj/item/attachable/reddot, null, VENDOR_ITEM_REGULAR),
		list("反射式瞄准镜", 10, /obj/item/attachable/reflex, null, VENDOR_ITEM_REGULAR),
		list("消音器", 10, /obj/item/attachable/suppressor, null, VENDOR_ITEM_REGULAR),
		list("垂直握把", 10, /obj/item/attachable/verticalgrip, null, VENDOR_ITEM_REGULAR),

		list("弹药", 0, null, null, null),
		list("M49A 穿甲弹匣 (10x24mm)", 10, /obj/item/ammo_magazine/rifle/m49a/ap, null, VENDOR_ITEM_REGULAR),
		list("M39 穿甲弹匣 (10x20mm)", 10, /obj/item/ammo_magazine/smg/m39/ap, null, VENDOR_ITEM_REGULAR),
		list("M39 扩容弹匣 (10x20mm)", 10, /obj/item/ammo_magazine/smg/m39/extended, null, VENDOR_ITEM_REGULAR),
		list("M41A 穿甲弹匣 (10x24mm)", 10, /obj/item/ammo_magazine/rifle/ap, null, VENDOR_ITEM_REGULAR),
		list("M41A 扩容弹匣 (10x24mm)", 10, /obj/item/ammo_magazine/rifle/extended, null, VENDOR_ITEM_REGULAR),
		list("M44 重型快速装弹器 (.44)", 10, /obj/item/ammo_magazine/revolver/heavy, null, VENDOR_ITEM_REGULAR),

		list("勤务服", 0, null, null, null),
		list("灭火器 (便携式)", 5, /obj/item/tool/extinguisher/mini, null, VENDOR_ITEM_REGULAR),
		list("大型杂物袋", 15, /obj/item/storage/pouch/general/large, null, VENDOR_ITEM_REGULAR),
		list("大型弹匣袋", 15, /obj/item/storage/pouch/magazine/large, null, VENDOR_ITEM_REGULAR),
		list("砍刀鞘 (满装)", 10, /obj/item/storage/large_holster/machete/full, null, VENDOR_ITEM_REGULAR),
		list("砍刀袋 (满装)", 15, /obj/item/storage/pouch/machete/full, null, VENDOR_ITEM_REGULAR),
		list("运动探测器", 15, /obj/item/device/motiondetector, null, VENDOR_ITEM_RECOMMENDED)
	))

//MARINE_CAN_BUY_SHOES MARINE_CAN_BUY_UNIFORM currently not used
/obj/structure/machinery/cm_vending/clothing/pilot_officer
	name = "ColMarTech运输艇机组装备架"
	desc = "连接着巨型运输艇机组制式装备仓库的自动装备架。"
	req_access = list(ACCESS_MARINE_PILOT)
	vendor_role = list(JOB_CAS_PILOT, JOB_DROPSHIP_PILOT, JOB_DROPSHIP_CREW_CHIEF)

/obj/structure/machinery/cm_vending/clothing/pilot_officer/get_listed_products(mob/user)
	if(!user)
		var/list/combined = list()
		combined += GLOB.cm_vending_clothing_dropship_crew_chief
		combined += GLOB.cm_vending_clothing_pilot_officer
		return combined
	if(user.job == JOB_DROPSHIP_CREW_CHIEF)
		return GLOB.cm_vending_clothing_dropship_crew_chief
	if(user.job == JOB_CAS_PILOT)
		return GLOB.cm_vending_clothing_pilot_officer
	if(user.job == JOB_DROPSHIP_PILOT)
		return GLOB.cm_vending_clothing_pilot_officer
	return ..()
