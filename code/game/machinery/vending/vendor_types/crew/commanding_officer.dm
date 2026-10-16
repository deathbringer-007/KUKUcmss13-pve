//------------GEAR VENDOR---------------

GLOBAL_LIST_INIT(cm_vending_gear_commanding_officer, list(
		list("指挥官 PRIMARY (任选一件)", 0, null, null, null),
		list("M46C 脉冲步枪", 0, /obj/effect/essentials_set/co/riflepreset, MARINE_CAN_BUY_SECONDARY, VENDOR_ITEM_MANDATORY),
		list("M56C 智能机枪", 0, /obj/item/storage/box/m56c_system, MARINE_CAN_BUY_SECONDARY, VENDOR_ITEM_MANDATORY),

		list("主武器弹药", 0, null, null, null),
		list("M41A MK1 弹匣", 30, /obj/item/ammo_magazine/rifle/m41aMK1, null, VENDOR_ITEM_RECOMMENDED),
		list("M41A MK1 穿甲弹匣", 40, /obj/item/ammo_magazine/rifle/m41aMK1/ap, null, VENDOR_ITEM_RECOMMENDED),
		list("M41A 扩容弹匣", 20, /obj/item/ammo_magazine/rifle/extended, null, VENDOR_ITEM_REGULAR),
		list("M41A 穿甲弹匣", 20, /obj/item/ammo_magazine/rifle/ap, null, VENDOR_ITEM_REGULAR),
		list("M56B 智能机枪弹鼓", 20, /obj/item/ammo_magazine/smartgun, null, VENDOR_ITEM_REGULAR),

		list("副武器弹药", 0, null, null, null),
		list("高冲击弹马特巴快速装弹器 (.454)", 15, /obj/item/ammo_magazine/revolver/mateba/highimpact, null, VENDOR_ITEM_RECOMMENDED),
		list("高冲击穿甲弹马特巴快速装弹器 (.454)", 20, /obj/item/ammo_magazine/revolver/mateba/highimpact/ap, null, VENDOR_ITEM_REGULAR),
		list("高冲击弹沙漠之鹰弹匣 (.50)", 15, /obj/item/ammo_magazine/pistol/heavy/super/highimpact, null, VENDOR_ITEM_RECOMMENDED),
		list("高冲击穿甲弹沙漠之鹰弹匣 (.50)", 20, /obj/item/ammo_magazine/pistol/heavy/super/highimpact/ap, null, VENDOR_ITEM_REGULAR),

		list("霰弹枪弹药", 0, null, null, null),
		list("鹿弹", 20, /obj/item/ammo_magazine/shotgun/buckshot, null, VENDOR_ITEM_REGULAR),
		list("霰弹枪独头弹", 20, /obj/item/ammo_magazine/shotgun/slugs, null, VENDOR_ITEM_REGULAR),
		list("箭形弹", 20, /obj/item/ammo_magazine/shotgun/flechette, null, VENDOR_ITEM_REGULAR),

		list("特殊弹药", 0, null, null, null),
		list("M41A 燃烧弹匣", 65, /obj/item/ammo_magazine/rifle/incendiary, null, VENDOR_ITEM_REGULAR),
		list("M41A 橡胶弹匣", 10, /obj/item/ammo_magazine/rifle/rubber, null, VENDOR_ITEM_REGULAR),
		list("布袋弹", 10, /obj/item/ammo_magazine/shotgun/beanbag, null, VENDOR_ITEM_REGULAR),

		list("爆炸物", 0, null, null, null),
		list("HEDP 手榴弹包", 15, /obj/item/storage/box/packet/high_explosive, null, VENDOR_ITEM_REGULAR),
		list("HEFA 手榴弹包", 15, /obj/item/storage/box/packet/hefa, null, VENDOR_ITEM_REGULAR),
		list("WP 手榴弹包", 15, /obj/item/storage/box/packet/phosphorus, null, VENDOR_ITEM_REGULAR),
		list("G2 电击手榴弹包 (x3 手榴弹)",  15, /obj/item/storage/box/packet/sebb, null, VENDOR_ITEM_REGULAR),

		list("导轨配件", 0, null, null, null),
		list("红点瞄准镜", 15, /obj/item/attachable/reddot, null, VENDOR_ITEM_REGULAR),
		list("反射式瞄准镜", 15, /obj/item/attachable/reflex, null, VENDOR_ITEM_REGULAR),
		list("S4 2x 小型望远瞄准镜", 15, /obj/item/attachable/scope/mini, null, VENDOR_ITEM_REGULAR),

		list("头盔面罩", 0, null, null, null),
		list("焊接面罩", 5, /obj/item/device/helmet_visor/welding_visor, null, VENDOR_ITEM_RECOMMENDED),

		list("下挂配件", 0, null, null, null),
		list("激光瞄准器", 15, /obj/item/attachable/lasersight, null, VENDOR_ITEM_REGULAR),
		list("倾斜握把", 15, /obj/item/attachable/angledgrip, null, VENDOR_ITEM_REGULAR),
		list("垂直握把", 15, /obj/item/attachable/verticalgrip, null, VENDOR_ITEM_REGULAR),
		list("下挂霰弹枪", 15, /obj/item/attachable/attached_gun/shotgun, null, VENDOR_ITEM_REGULAR),
		list("下挂灭火器", 15, /obj/item/attachable/attached_gun/extinguisher, null, VENDOR_ITEM_REGULAR),
		list("下挂火焰喷射器", 15, /obj/item/attachable/attached_gun/flamer, null, VENDOR_ITEM_REGULAR),
		list("下挂榴弹发射器", 5, /obj/item/attachable/attached_gun/grenade, null, VENDOR_ITEM_REGULAR),

		list("枪管配件", 0, null, null, null),
		list("加长枪管", 15, /obj/item/attachable/extended_barrel, null, VENDOR_ITEM_REGULAR),
		list("后坐补偿器", 15, /obj/item/attachable/compensator, null, VENDOR_ITEM_REGULAR),
		list("消音器", 15, /obj/item/attachable/suppressor, null, VENDOR_ITEM_REGULAR),
			))

/obj/structure/machinery/cm_vending/gear/commanding_officer
	name = "ColMarTech指挥官武器架"
	desc = "供指挥官使用的自动武器架。提供仅供 USCM 最高级军官使用的丰富武器选择。"
	req_access = list(ACCESS_MARINE_SENIOR)
	vendor_role = list(JOB_CO, JOB_WO_CO)
	icon_state = "guns"
	use_snowflake_points = TRUE

/obj/structure/machinery/cm_vending/gear/commanding_officer/get_listed_products(mob/user)
	return GLOB.cm_vending_gear_commanding_officer

//------------CLOTHING VENDOR---------------

GLOBAL_LIST_INIT(cm_vending_clothing_commanding_officer, list(
		list("标准装备 (全部领取)", 0, null, null, null),
		list("耳机", 0, /obj/item/device/radio/headset/almayer/mcom/cdrcom, MARINE_CAN_BUY_EAR, VENDOR_ITEM_MANDATORY),
		list("即食军粮", 0, /obj/item/storage/box/mre, MARINE_CAN_BUY_MRE, VENDOR_ITEM_MANDATORY),

		list("指挥官必备套件 (全部领取)", 0, null, null, null),
		list("指挥官必备套件", 0, /obj/effect/essentials_set/commanding_officer, MARINE_CAN_BUY_ESSENTIALS, VENDOR_ITEM_MANDATORY),

		list("包 (任选一件)", 0, null, null, null),
		list("指挥官背包", 0, /obj/item/storage/backpack/mcommander, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_MANDATORY),
		list("安全挎包", 0, /obj/item/storage/backpack/satchel/lockable, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_MANDATORY),

		list("战斗装备 (全部领取)", 0, null, null, null),
		list("指挥官 M3 护甲", 0, /obj/item/clothing/suit/storage/marine/MP/CO, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_MANDATORY),
		list("指挥官 M10 头盔", 0, /obj/item/clothing/head/helmet/marine/CO, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_MANDATORY),
		list("战斗手套", 0, /obj/item/clothing/gloves/marine, MARINE_CAN_BUY_GLOVES, VENDOR_ITEM_MANDATORY),
		list("陆战队战斗靴", 0, /obj/item/clothing/shoes/marine/knife, MARINE_CAN_BUY_SHOES, VENDOR_ITEM_MANDATORY),

		list("饰品 (任选一件)", 0, null, null, null),
		list("棕色携行背心", 0, /obj/item/clothing/accessory/storage/black_vest/brown_vest, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_RECOMMENDED),
		list("黑色携行背心", 0, /obj/item/clothing/accessory/storage/black_vest, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("战术马甲", 0, /obj/item/clothing/accessory/storage/black_vest/waistcoat, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("肩部枪套", 0, /obj/item/clothing/accessory/storage/holster, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("携行带", 0, /obj/item/clothing/accessory/storage/webbing, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("挂袋", 0, /obj/item/clothing/accessory/storage/droppouch, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),

		list("抬头显示设备 (任选一件)", 0, null, null, null),
		list("医疗抬头显示眼镜", 0, /obj/item/clothing/glasses/hud/health, MARINE_CAN_BUY_GLASSES, VENDOR_ITEM_RECOMMENDED),
		list("安保抬头显示眼镜", 0, /obj/item/clothing/glasses/sunglasses/sechud, MARINE_CAN_BUY_GLASSES, VENDOR_ITEM_REGULAR),

		list("腰带 (任选一件)", 0, null, null, null),
		list("G8-A 通用杂物袋", 0, /obj/item/storage/backpack/general_belt, MARINE_CAN_BUY_BELT, VENDOR_ITEM_RECOMMENDED),
		list("宪兵腰带", 0, /obj/item/storage/belt/security/MP/full, MARINE_CAN_BUY_BELT, VENDOR_ITEM_RECOMMENDED),
		list("M276 医疗携行挂具", 0, /obj/item/storage/belt/medical/full, MARINE_CAN_BUY_BELT, VENDOR_ITEM_RECOMMENDED),
		list("M276 弹药携行挂具", 0, /obj/item/storage/belt/marine, MARINE_CAN_BUY_BELT, VENDOR_ITEM_RECOMMENDED),
		list("M276 枪套式工具挂具", 0, /obj/item/storage/belt/gun/utility/full, MARINE_CAN_BUY_BELT, VENDOR_ITEM_RECOMMENDED),
		list("M276 M82F 枪套挂具", 0, /obj/item/storage/belt/gun/flaregun, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),

		list("收纳袋 (任选两件)", 0, null, null, null),
		list("急救袋 (可补充注射器)", 0, /obj/item/storage/pouch/firstaid/full, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("急救袋 (夹板, 医用纱布, 烧伤药膏)", 0, /obj/item/storage/pouch/firstaid/full/alternate, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("急救袋 (药片包)", 0, /obj/item/storage/pouch/firstaid/full/pills, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("医疗套件袋", 0, /obj/item/storage/pouch/medkit, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("自动注射器收纳袋", 0, /obj/item/storage/pouch/autoinjector/full, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("大型杂物袋", 0, /obj/item/storage/pouch/general/large, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("大型手枪弹匣袋", 0, /obj/item/storage/pouch/magazine/pistol/large, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("大型弹匣袋", 0, /obj/item/storage/pouch/magazine/large, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("副武器袋", 0, /obj/item/storage/pouch/pistol, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("大型霰弹袋", 0, /obj/item/storage/pouch/shotgun/large, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("工具袋 (满装)", 0, /obj/item/storage/pouch/tools/full, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
	))

/obj/structure/machinery/cm_vending/clothing/commanding_officer
	name = "ColMarTech指挥官装备架"
	desc = "供指挥官使用的自动装备售货机。提供仅供 USCM 最高级军官使用的精选装备。"
	req_access = list(ACCESS_MARINE_SENIOR)
	vendor_role = list(JOB_CO, JOB_WO_CO)

/obj/structure/machinery/cm_vending/clothing/commanding_officer/get_listed_products(mob/user)
	return GLOB.cm_vending_clothing_commanding_officer

/obj/effect/essentials_set/commanding_officer
	spawned_gear_list = list(
		/obj/item/device/binoculars/range/designator,
		/obj/item/map/current_map,
		/obj/item/device/whistle,
		/obj/item/weapon/gun/energy/taser,
		/obj/item/device/megaphone,
	)

// This gets around the COs' weapon not spawning without incendiary mag.
/obj/effect/essentials_set/co/riflepreset
	spawned_gear_list = list(
		/obj/item/weapon/gun/rifle/m46c,
	)
