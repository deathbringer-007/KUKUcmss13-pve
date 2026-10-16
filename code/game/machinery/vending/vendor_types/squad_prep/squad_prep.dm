//------------SQUAD PREP VENDORS -------------------

//------------SQUAD PREP WEAPON RACKS---------------

/obj/structure/machinery/cm_vending/sorted/cargo_guns/squad_prep
	name = "ColMarTech自动武器架"
	desc = "连接着大型制式武器仓库的自动武器架。"
	icon_state = "guns"
	req_access = list()
	req_one_access = list(ACCESS_MARINE_DATABASE, ACCESS_MARINE_PREP)
	hackable = TRUE
	vend_flags = VEND_CLUTTER_PROTECTION | VEND_LIMITED_INVENTORY | VEND_TO_HAND

/obj/structure/machinery/cm_vending/sorted/cargo_guns/squad_prep/ui_state(mob/user)
	return GLOB.not_incapacitated_and_adjacent_strict_state

/obj/structure/machinery/cm_vending/sorted/cargo_guns/squad_prep/populate_product_list(scale)
	listed_products = list(
		list("主武器枪械", -1, null, null),
		list("M49A 战斗步枪", floor(scale * 10), /obj/item/weapon/gun/rifle/m49a, VENDOR_ITEM_REGULAR),
		list("M37A2 泵动霰弹枪", floor(scale * 15), /obj/item/weapon/gun/shotgun/pump, VENDOR_ITEM_REGULAR),
		list("M39 冲锋枪", floor(scale * 30), /obj/item/weapon/gun/smg/m39, VENDOR_ITEM_REGULAR),
		list("M41A 脉冲步枪 MK2", floor(scale * 30), /obj/item/weapon/gun/rifle/m41a, VENDOR_ITEM_RECOMMENDED),

		list("主武器弹药", -1, null, null),
		list("整箱箭形弹 (12g)", floor(scale * 4), /obj/item/ammo_magazine/shotgun/flechette, VENDOR_ITEM_REGULAR),
		list("整箱鹿弹 (12g)", floor(scale * 10), /obj/item/ammo_magazine/shotgun/buckshot, VENDOR_ITEM_REGULAR),
		list("整箱霰弹枪独头弹 (12g)", floor(scale * 10), /obj/item/ammo_magazine/shotgun/slugs, VENDOR_ITEM_REGULAR),
		list("M49A 弹匣 (10x24mm)", floor(scale * 15), /obj/item/ammo_magazine/rifle/m49a, VENDOR_ITEM_REGULAR),
		list("M39 高速弹匣 (10x20mm)", floor(scale * 25), /obj/item/ammo_magazine/smg/m39, VENDOR_ITEM_REGULAR),
		list("M41A 弹匣 (10x24mm)", floor(scale * 25), /obj/item/ammo_magazine/rifle, VENDOR_ITEM_REGULAR),

		list("副武器", -1, null, null),
		list("VP70 战斗手枪", floor(scale * 25), /obj/item/weapon/gun/pistol/vp70, VENDOR_ITEM_REGULAR),
		list("M44 战斗左轮手枪", floor(scale * 25), /obj/item/weapon/gun/revolver/m44, VENDOR_ITEM_REGULAR),
		list("M4A3 制式手枪", floor(scale * 25), /obj/item/weapon/gun/pistol/m4a3, VENDOR_ITEM_REGULAR),
		list("M82F 信号枪", floor(scale * 10), /obj/item/weapon/gun/flare, VENDOR_ITEM_REGULAR),

		list("副武器弹药", -1, null, null),
		list("VP70 弹匣 (9mm)", floor(scale * 25), /obj/item/ammo_magazine/pistol/vp70, VENDOR_ITEM_REGULAR),
		list("M44 快速装弹器 (.44)", floor(scale * 20), /obj/item/ammo_magazine/revolver, VENDOR_ITEM_REGULAR),
		list("M4A3 弹匣 (9mm)", floor(scale * 25), /obj/item/ammo_magazine/pistol, VENDOR_ITEM_REGULAR),

		list("配件", -1, null, null),
		list("M39 折叠枪托", floor(scale * 10), /obj/item/attachable/stock/smg/collapsible, VENDOR_ITEM_REGULAR),
		list("M41A 折叠枪托", floor(scale * 10), /obj/item/attachable/stock/rifle/collapsible, VENDOR_ITEM_REGULAR),
		list("导轨手电筒", floor(scale * 25), /obj/item/attachable/flashlight, VENDOR_ITEM_RECOMMENDED),
		list("下挂手电握把", floor(scale * 10), /obj/item/attachable/flashlight/grip, VENDOR_ITEM_RECOMMENDED),
		list("下挂式榴弹发射器", floor(scale * 25), /obj/item/attachable/attached_gun/grenade, VENDOR_ITEM_REGULAR), //They already get these as on-spawns, might as well formalize some spares.

		list("勤务服", -1, null, null),
		list("M13 格斗刀", floor(scale * 25), /obj/item/weapon/knife/marine, VENDOR_ITEM_REGULAR),
		list("M94 标记照明弹包", floor(scale * 10), /obj/item/storage/box/flare, VENDOR_ITEM_RECOMMENDED)
	)

/obj/structure/machinery/cm_vending/sorted/cargo_guns/squad_prep/tutorial
	name = "ColMarTech自动武器架"
	desc = "连接着大型制式武器仓库的自动武器架。"
	icon_state = "guns"
	req_access = list(ACCESS_TUTORIAL_LOCKED)
	req_one_access = list()
	hackable = FALSE
	vend_flags = VEND_CLUTTER_PROTECTION | VEND_LIMITED_INVENTORY | VEND_TO_HAND

/obj/structure/machinery/cm_vending/sorted/cargo_guns/squad_prep/tutorial/populate_product_list(scale)
	listed_products = list(
		list("主武器枪械", -1, null, null),
		list("M41A 脉冲步枪 MK2", 1, /obj/item/weapon/gun/rifle/m41a, VENDOR_ITEM_RECOMMENDED),

		list("主武器弹药", -1, null, null),
		list("M41A 弹匣 (10x24mm)", 1, /obj/item/ammo_magazine/rifle, VENDOR_ITEM_RECOMMENDED),
	)

/// Called if the tutorial mob somehow uses an entire magazine without the xeno dying
/obj/structure/machinery/cm_vending/sorted/cargo_guns/squad_prep/tutorial/proc/load_ammo()
	listed_products = list(
		list("主武器枪械", -1, null, null),
		list("M41A 脉冲步枪 MK2", 0, /obj/item/weapon/gun/rifle/m41a, VENDOR_ITEM_RECOMMENDED),

		list("主武器弹药", -1, null, null),
		list("M41A 弹匣 (10x24mm)", 99, /obj/item/ammo_magazine/rifle, VENDOR_ITEM_RECOMMENDED),
	)

//------------SQUAD PREP UNIFORM VENDOR---------------


/obj/structure/machinery/cm_vending/sorted/uniform_supply/squad_prep
	name = "ColMarTech备用制服售货机"
	desc = "连接着小型陆战队制式制服仓库的自动补给架。"
	icon_state = "uscm_gear"
	req_access = list(ACCESS_MARINE_PREP)
	req_one_access = list()
	listed_products = list()
	hackable = TRUE
	vend_flags = VEND_CLUTTER_PROTECTION | VEND_LIMITED_INVENTORY | VEND_TO_HAND | VEND_STOCK_DYNAMIC

/obj/structure/machinery/cm_vending/sorted/uniform_supply/squad_prep/ui_state(mob/user)
	return GLOB.not_incapacitated_and_adjacent_strict_state

/obj/structure/machinery/cm_vending/sorted/uniform_supply/squad_prep/populate_product_list(scale)
	listed_products = list(
		list("标准装备", -1, null, null, null),
		list("陆战队战斗靴", floor(scale * 15), /obj/item/clothing/shoes/marine/knife, VENDOR_ITEM_REGULAR),
		list("陆战队制服, 自适应迷彩", floor(scale * 15), /obj/item/clothing/under/marine, VENDOR_ITEM_REGULAR),
		list("陆战队制服, 丛林作战服", floor(scale * 15), /obj/item/clothing/under/marine/standard, VENDOR_ITEM_REGULAR),
		list("陆战队战斗手套", floor(scale * 15), /obj/item/clothing/gloves/marine, VENDOR_ITEM_REGULAR),
		list("陆战队无线电耳机", floor(scale * 15), /obj/item/device/radio/headset/almayer/marine/solardevils, VENDOR_ITEM_REGULAR),
		list("M5 式摄像耳机", floor(scale * 15), /obj/item/device/overwatch_camera, VENDOR_ITEM_REGULAR),
		list("作训帽, 丛林", floor(scale * 15), /obj/item/clothing/head/cmcap, VENDOR_ITEM_REGULAR),
		list("作训帽, 雪地", floor(scale * 15), /obj/item/clothing/head/cmcap/snow, VENDOR_ITEM_REGULAR),
		list("作训帽, 沙漠", floor(scale * 15), /obj/item/clothing/head/cmcap/desert, VENDOR_ITEM_REGULAR),
		list("作战帽, 绿色", floor(scale * 15), /obj/item/clothing/head/cmcap/bridge, VENDOR_ITEM_REGULAR),
		list("作战帽, 棕褐色", floor(scale * 15), /obj/item/clothing/head/cmcap/bridge/tan, VENDOR_ITEM_REGULAR),
		list("丛林帽, 丛林", floor(scale * 15), /obj/item/clothing/head/cmcap/boonie, VENDOR_ITEM_REGULAR),
		list("丛林帽, 沙漠", floor(scale * 15), /obj/item/clothing/head/cmcap/boonie/tan, VENDOR_ITEM_REGULAR),

		list("携行带", -1, null, null),
		list("M3 式携行带", 2, /obj/item/clothing/accessory/storage/webbing/m3, VENDOR_ITEM_REGULAR),
		list("M3 式弹匣携行带", 2, /obj/item/clothing/accessory/storage/webbing/m3/mag, VENDOR_ITEM_REGULAR),
		list("M3 式霰弹携行带", 2, /obj/item/clothing/accessory/storage/webbing/m3/shotgun, VENDOR_ITEM_REGULAR),
		list("M3 式 M40 携行带", 0.75, /obj/item/clothing/accessory/storage/webbing/m3/m40, VENDOR_ITEM_REGULAR),
		list("M3 式小型收纳袋携行带", 2, /obj/item/clothing/accessory/storage/webbing/m3/small, VENDOR_ITEM_REGULAR),
		list("挂袋", 4, /obj/item/clothing/accessory/storage/droppouch, VENDOR_ITEM_REGULAR),
		list("腿袋", 4, /obj/item/clothing/accessory/storage/smallpouch, VENDOR_ITEM_REGULAR),
		list("肩部枪套", round(max(1,(scale * 0.5))), /obj/item/clothing/accessory/storage/holster, VENDOR_ITEM_REGULAR),

		list("护甲", -1, null, null),
		list("M10 式陆战队头盔", floor(scale * 15), /obj/item/clothing/head/helmet/marine, VENDOR_ITEM_REGULAR),
		list("标准 M3 式护甲套装", round(scale * 15), /obj/item/storage/box/guncase/m3armor, VENDOR_ITEM_REGULAR),
		list("M3 式胸甲", round(scale * 10), /obj/item/clothing/suit/marine, VENDOR_ITEM_REGULAR),
		list("M3 式棱纹胸甲", round(scale * 10), /obj/item/clothing/suit/marine/lines, VENDOR_ITEM_REGULAR),
		list("M3 式平滑胸甲", round(scale * 10), /obj/item/clothing/suit/marine/smooth, VENDOR_ITEM_REGULAR),
		list("M3 式肩甲", round(scale * 10), /obj/item/clothing/accessory/pads, VENDOR_ITEM_REGULAR),
		list("M3 式下腹护板", round(scale * 10), /obj/item/clothing/accessory/pads/groin, VENDOR_ITEM_REGULAR),
		list("M3 式护胫", round(scale * 15), /obj/item/clothing/accessory/pads/greaves, VENDOR_ITEM_REGULAR),
		list("M3 式护膝", round(scale * 15), /obj/item/clothing/accessory/pads/kneepads, VENDOR_ITEM_REGULAR),
		list("M3 式前臂护甲", round(scale * 10), /obj/item/clothing/accessory/pads/bracers, VENDOR_ITEM_REGULAR),
		list("M3 式护喉", round(scale * 15), /obj/item/clothing/accessory/pads/neckguard, VENDOR_ITEM_REGULAR),

		list("背包", -1, null, null, null),
		list("轻型 IMP 背包", floor(scale * 15), /obj/item/storage/backpack/marine, VENDOR_ITEM_REGULAR),
		list("技术员背包", floor(scale * 15), /obj/item/storage/backpack/marine/tech, VENDOR_ITEM_REGULAR),
		list("USCM 挎包", floor(scale * 15), /obj/item/storage/backpack/marine/satchel, VENDOR_ITEM_REGULAR),
		list("USCM 技术员挎包", floor(scale * 15), /obj/item/storage/backpack/marine/satchel/tech, VENDOR_ITEM_REGULAR),

		list("限配背包", -1, null, null),
		list("无线电话背包", 0.75, /obj/item/storage/backpack/marine/satchel/rto, VENDOR_ITEM_REGULAR),

		list("腰带", -1, null, null),
		list("M276 式弹药携行挂具", floor(scale * 15), /obj/item/storage/belt/marine, VENDOR_ITEM_REGULAR),
		list("M276 式 M40 手榴弹携行挂具", floor(scale * 10), /obj/item/storage/belt/grenade, VENDOR_ITEM_REGULAR),
		list("M276 式通用手枪枪套挂具", floor(scale * 15), /obj/item/storage/belt/gun/m4a3, VENDOR_ITEM_REGULAR),
		list("M276 式通用左轮手枪枪套挂具", floor(scale * 15), /obj/item/storage/belt/gun/m44, VENDOR_ITEM_REGULAR),
		list("M276 式 M82F 枪套挂具", floor(scale * 5), /obj/item/storage/belt/gun/flaregun, VENDOR_ITEM_REGULAR),
		list("M276 G8-A 通用杂物袋", floor(scale * 15), /obj/item/storage/backpack/general_belt, VENDOR_ITEM_REGULAR),

		list("收纳袋", -1, null, null, null),
		list("急救袋", floor(scale * 15), /obj/item/storage/pouch/firstaid, VENDOR_ITEM_REGULAR),
		list("照明弹袋 (满装)", floor(scale * 15), /obj/item/storage/pouch/flare/full, VENDOR_ITEM_REGULAR),
		list("弹匣袋", floor(scale * 15), /obj/item/storage/pouch/magazine, VENDOR_ITEM_REGULAR),
		list("中型杂物袋", floor(scale * 15), /obj/item/storage/pouch/general/medium, VENDOR_ITEM_REGULAR),
		list("手枪弹匣袋", floor(scale * 15), /obj/item/storage/pouch/magazine/pistol, VENDOR_ITEM_REGULAR),
		list("手枪袋", floor(scale * 15), /obj/item/storage/pouch/pistol, VENDOR_ITEM_REGULAR),

		list("限配收纳袋", -1, null, null, null),
		list("建材袋", 1.25, /obj/item/storage/pouch/construction, VENDOR_ITEM_REGULAR),
		list("爆炸物袋", 1.25, /obj/item/storage/pouch/explosive, VENDOR_ITEM_REGULAR),
		list("急救响应袋", 2.5, /obj/item/storage/pouch/first_responder, VENDOR_ITEM_REGULAR),
		list("大型手枪弹匣袋", floor(scale * 2), /obj/item/storage/pouch/magazine/pistol/large, VENDOR_ITEM_REGULAR),
		list("工具袋", 1.25, /obj/item/storage/pouch/tools, VENDOR_ITEM_REGULAR),
		list("枪带袋", 1.25, /obj/item/storage/pouch/sling, VENDOR_ITEM_REGULAR),
		list("喷火器燃料罐袋", 1.25, /obj/item/storage/pouch/flamertank, VENDOR_ITEM_REGULAR),
		list("霰弹袋", 1.25, /obj/item/storage/pouch/shotgun, VENDOR_ITEM_REGULAR),

		list("面罩", -1, null, null, null),
		list("M5 防毒面具", floor(scale * 15), /obj/item/clothing/mask/gas/military, VENDOR_ITEM_REGULAR),
		list("战术面巾", floor(scale * 10), /obj/item/clothing/mask/rebreather/scarf/tacticalmask, VENDOR_ITEM_REGULAR),
		list("吸热头套", floor(scale * 10), /obj/item/clothing/mask/rebreather/scarf, VENDOR_ITEM_REGULAR),

		list("杂项", -1, null, null, null),
		list("防弹护目镜", round(scale * 10), /obj/item/clothing/glasses/mgoggles, VENDOR_ITEM_REGULAR),
		list("防弹护目镜, 遮阳", round(scale * 10), /obj/item/clothing/glasses/mgoggles/black, VENDOR_ITEM_REGULAR),
		list("防弹护目镜, 防激光 (棕色)", round(scale * 10), /obj/item/clothing/glasses/mgoggles/orange, VENDOR_ITEM_REGULAR),
		list("防弹护目镜, 防激光 (绿色)", round(scale * 10), /obj/item/clothing/glasses/mgoggles/green, VENDOR_ITEM_REGULAR),
		list("M10 头盔丛林罩", round(scale * 10), /obj/item/prop/helmetgarb/camocover, VENDOR_ITEM_REGULAR),
		list("M10 头盔雪地罩", round(scale * 10), /obj/item/prop/helmetgarb/camocover/snow, VENDOR_ITEM_REGULAR),
		list("M10 头盔沙漠罩", round(scale * 10), /obj/item/prop/helmetgarb/camocover/desert, VENDOR_ITEM_REGULAR),
		list("M10 头盔伪装网", round(scale * 10), /obj/item/prop/helmetgarb/netting, VENDOR_ITEM_REGULAR),
		list("M10 头盔防雨罩", round(scale * 10), /obj/item/prop/helmetgarb/raincover, VENDOR_ITEM_REGULAR),
		list("太阳恶魔肩章", round(scale * 15), /obj/item/clothing/accessory/patch/devils, VENDOR_ITEM_REGULAR),
		list("USCM 肩章", round(scale * 15), /obj/item/clothing/accessory/patch, VENDOR_ITEM_REGULAR),
		list("枪械润滑剂", round(scale * 15), /obj/item/prop/helmetgarb/gunoil, VENDOR_ITEM_REGULAR),
		list("LRRP 铺盖卷", round(scale * 15), /obj/item/roller/bedroll, VENDOR_ITEM_REGULAR),
		list("陆战队配发指南针", round(scale * 15), /obj/item/prop/helmetgarb/compass, VENDOR_ITEM_REGULAR),
		)

/obj/item/storage/box/guncase/m3armor //forgive me, father
	name = "M3 式护甲箱"
	desc = "装有 USCMC M3 式护甲套装标准配件的箱子。配件不单独出售。"
	can_hold = list(/obj/item/clothing/suit/marine, /obj/item/clothing/accessory/pads/groin, /obj/item/clothing/accessory/pads, /obj/item/clothing/accessory/pads/greaves)
	storage_slots = 5

/obj/item/storage/box/guncase/m3armor/fill_preset_inventory()
	new /obj/item/clothing/suit/marine(src)
	new /obj/item/clothing/accessory/pads(src)
	new /obj/item/clothing/accessory/pads/groin(src)
	new /obj/item/clothing/accessory/pads/greaves(src)
	new /obj/item/clothing/accessory/pads/kneepads(src)
/obj/effect/essentials_set/m3
	spawned_gear_list = list(
		/obj/item/clothing/suit/marine,
		/obj/item/clothing/accessory/pads/greaves,
		/obj/item/clothing/accessory/pads/groin,
	)


/obj/structure/machinery/cm_vending/sorted/uniform_supply/squad_prep/upp
	name = "联盟科技备用制服售货机"
	desc = "连接着小型 UPP 制式制服仓库的自动补给架。"
	icon_state = "upp_gear"
	req_access = list(ACCESS_UPP_GENERAL)
	req_one_access = list()
	listed_products = list()
	hackable = TRUE
	vendor_theme = VENDOR_THEME_UPP

/obj/structure/machinery/cm_vending/sorted/uniform_supply/squad_prep/upp/populate_product_list(scale)
	listed_products = list(
		list("标准装备", -1, null, null, null),
		list("军用战斗靴", round(scale * 15), /obj/item/clothing/shoes/marine/upp, VENDOR_ITEM_REGULAR),
		list("海军步兵制服", round(scale * 15), /obj/item/clothing/under/marine/veteran/UPP, VENDOR_ITEM_REGULAR),
		list("战斗手套", round(scale * 15), /obj/item/clothing/gloves/marine, VENDOR_ITEM_REGULAR),
		list("无线电耳机", round(scale * 15), /obj/item/device/radio/headset/almayer/marine/solardevils/upp, VENDOR_ITEM_REGULAR),
		list("1PN77M \"潜望镜\" 摄像装置", floor(scale * 15), /obj/item/device/overwatch_camera/upp, VENDOR_ITEM_REGULAR),

		list("携行带", -1, null, null),
		list("90 式弹匣携行带", round(scale * 10), /obj/item/clothing/accessory/storage/webbing/m3/uppmags, VENDOR_ITEM_REGULAR),
		list("78 式小型收纳袋携行带", round(scale * 10), /obj/item/clothing/accessory/storage/webbing/m3/uppsmall, VENDOR_ITEM_REGULAR),
		list("77 式收纳袋携行带", round(scale * 10), /obj/item/clothing/accessory/storage/webbing/m3/uppgeneral, VENDOR_ITEM_REGULAR),
		list("挂袋", round(max(1,(scale * 2))), /obj/item/clothing/accessory/storage/droppouch/upp, VENDOR_ITEM_REGULAR),
		list("腿袋", 4, /obj/item/clothing/accessory/storage/smallpouch/upp, VENDOR_ITEM_REGULAR),
		list("肩部枪套", round(max(1,(scale * 0.5))), /obj/item/clothing/accessory/storage/holster, VENDOR_ITEM_REGULAR),

		list("护甲", -1, null, null),
		list("6b82 战斗头盔 (绿色)", round(scale * 15), /obj/item/clothing/head/helmet/upp, VENDOR_ITEM_REGULAR),
		list("6b82 战斗头盔 (棕色)", round(scale * 15), /obj/item/clothing/head/helmet/upp/alt, VENDOR_ITEM_REGULAR),
		list("6B72-03 式背心", round(scale * 10), /obj/item/clothing/suit/marine/faction/UPP/light, VENDOR_ITEM_REGULAR),
		list("6B90 式胸甲", round(scale * 15), /obj/item/clothing/suit/marine/faction/UPP, VENDOR_ITEM_REGULAR),
		list("6B90 护裆", round(scale * 15), /obj/item/clothing/accessory/upppads/crotch, VENDOR_ITEM_REGULAR),
		list("6B90 护腿", round(scale * 15), /obj/item/clothing/accessory/upppads/legs, VENDOR_ITEM_REGULAR),
		list("6B90 臂甲", round(scale * 15), /obj/item/clothing/accessory/upppads, VENDOR_ITEM_REGULAR),

		list("背包", -1, null, null, null),
		list("UPP 挎包", round(scale * 15), /obj/item/storage/backpack/lightpack/upp, VENDOR_ITEM_REGULAR),

		list("限配背包", -1, null, null),
		list("无线电话背包", round(max(1,(scale * 0.5))), /obj/item/storage/backpack/marine/satchel/rto, VENDOR_ITEM_REGULAR),

		list("腰带", -1, null, null),
		list("41 式弹药携行挂具", round(scale * 15), /obj/item/storage/belt/marine/upp, VENDOR_ITEM_REGULAR),
		list("M276 式 M40 手榴弹携行挂具", round(scale * 10), /obj/item/storage/belt/grenade, VENDOR_ITEM_REGULAR),
		list("47 式通用手枪枪套挂具", round(scale * 15), /obj/item/storage/belt/gun/type47, VENDOR_ITEM_REGULAR),
		list("M276 式 M82F 枪套挂具", round(scale * 5), /obj/item/storage/belt/gun/flaregun, VENDOR_ITEM_REGULAR),
		list("48 式通用杂物袋", round(scale * 15), /obj/item/storage/backpack/general_belt/upp, VENDOR_ITEM_REGULAR),

		list("收纳袋", -1, null, null, null),
		list("急救袋", floor(scale * 15), /obj/item/storage/pouch/firstaid, VENDOR_ITEM_REGULAR),
		list("照明弹袋 (满装)", floor(scale * 15), /obj/item/storage/pouch/flare/full, VENDOR_ITEM_REGULAR),
		list("弹匣袋", floor(scale * 15), /obj/item/storage/pouch/magazine, VENDOR_ITEM_REGULAR),
		list("霰弹袋", round(scale * 15), /obj/item/storage/pouch/shotgun, VENDOR_ITEM_REGULAR),
		list("中型杂物袋", floor(scale * 15), /obj/item/storage/pouch/general/medium, VENDOR_ITEM_REGULAR),
		list("手枪弹匣袋", floor(scale * 15), /obj/item/storage/pouch/magazine/pistol, VENDOR_ITEM_REGULAR),
		list("手枪袋", floor(scale * 15), /obj/item/storage/pouch/pistol, VENDOR_ITEM_REGULAR),
		list("50 式工兵铲收纳袋", round(scale * 15), /obj/item/storage/pouch/etool, VENDOR_ITEM_REGULAR),

		list("限配收纳袋", -1, null, null, null),
		list("建材袋", round(scale * 1.25), /obj/item/storage/pouch/construction, VENDOR_ITEM_REGULAR),
		list("爆炸物袋", round(scale * 1.25), /obj/item/storage/pouch/explosive, VENDOR_ITEM_REGULAR),
		list("急救响应袋 (空)", round(scale * 2.5), /obj/item/storage/pouch/first_responder, VENDOR_ITEM_REGULAR),
		list("大型手枪弹匣袋", round(scale * 2), /obj/item/storage/pouch/magazine/pistol/large, VENDOR_ITEM_REGULAR),
		list("工具袋", round(scale * 1.25), /obj/item/storage/pouch/tools, VENDOR_ITEM_REGULAR),
		list("枪带袋", round(scale * 1.25), /obj/item/storage/pouch/sling, VENDOR_ITEM_REGULAR),

		list("面罩", -1, null, null, null),
		list("ShMB/4 防毒面具", round(scale * 15), /obj/item/clothing/mask/gas/military/upp, VENDOR_ITEM_REGULAR),

		list("杂项", -1, null, null, null),
		list("防弹护目镜", round(scale * 10), /obj/item/clothing/glasses/mgoggles/upp, VENDOR_ITEM_REGULAR),
		list("矫视型防弹护目镜", round(scale * 10), /obj/item/clothing/glasses/mgoggles/upp/prescription, VENDOR_ITEM_REGULAR),
		list("枪械润滑剂", round(scale * 15), /obj/item/prop/helmetgarb/gunoil, VENDOR_ITEM_REGULAR),
		list("UPP 海军步兵肩章", round(scale * 15), /obj/item/clothing/accessory/patch/upp/naval, VENDOR_ITEM_REGULAR),
		list("UPPAC 肩章", round(scale * 15), /obj/item/clothing/accessory/patch/upp, VENDOR_ITEM_REGULAR),
		list("铺盖卷", round(scale * 20), /obj/item/roller/bedroll, VENDOR_ITEM_REGULAR),
		list("军用水壶", round(scale * 20), /obj/item/reagent_container/food/drinks/flask/canteen, VENDOR_ITEM_REGULAR),
		)

/obj/structure/machinery/cm_vending/sorted/uniform_supply/squad_prep/pmc
	name = "PMC 制服售货机"
	icon_state = "pmc_gear"
	req_access = list(ACCESS_WY_GENERAL)

/obj/structure/machinery/cm_vending/sorted/uniform_supply/squad_prep/pmc/populate_product_list(scale)
	listed_products = list(
		list("标准装备", -1, null, null, null),
		list("战斗靴", round(scale * 15), /obj/item/clothing/shoes/marine/civilian/knife, VENDOR_ITEM_REGULAR),
		list("PMC 制服", round(scale * 15), /obj/item/clothing/under/marine/veteran/pmc, VENDOR_ITEM_REGULAR),
		list("战斗手套", round(scale * 15), /obj/item/clothing/gloves/marine, VENDOR_ITEM_REGULAR),
		list("PMC 无线电耳机", round(scale * 15), /obj/item/device/radio/headset/distress/pmc/platoon, VENDOR_ITEM_REGULAR),
		list("Mk3 TOCU 头戴摄像机", floor(scale * 15), /obj/item/device/overwatch_camera/pmc, VENDOR_ITEM_REGULAR),

		list("携行带", -1, null, null),
		list("黑色携行背心", round(scale * 4), /obj/item/clothing/accessory/storage/black_vest, VENDOR_ITEM_REGULAR),
		list("携行带", round(scale * 2), /obj/item/clothing/accessory/storage/webbing, VENDOR_ITEM_REGULAR),
		list("挂袋", round(max(1,(scale * 0.5))), /obj/item/clothing/accessory/storage/droppouch, VENDOR_ITEM_REGULAR),
		list("肩部枪套", round(max(1,(scale * 0.5))), /obj/item/clothing/accessory/storage/holster, VENDOR_ITEM_REGULAR),

		list("护甲", -1, null, null),
		list("战术头盔", round(scale * 15), /obj/item/clothing/head/helmet/marine/veteran/pmc, VENDOR_ITEM_REGULAR),
		list("战术护甲", round(scale * 15), /obj/item/clothing/suit/storage/marine/veteran/pmc, VENDOR_ITEM_REGULAR),
		list("战术轻型护甲", round(scale * 10), /obj/item/clothing/suit/storage/marine/veteran/pmc/light, VENDOR_ITEM_REGULAR),

		list("背包", -1, null, null, null),
		list("轻型战斗背包", round(scale * 15), /obj/item/storage/backpack/lightpack, VENDOR_ITEM_REGULAR),
		list("RMC 行军背包", round(scale * 15), /obj/item/storage/backpack/rmc/medium, VENDOR_ITEM_REGULAR),

		list("限配背包", -1, null, null),
		list("无线电话背包", round(max(1,(scale * 0.5))), /obj/item/storage/backpack/marine/satchel/rto, VENDOR_ITEM_REGULAR),

		list("腰带", -1, null, null),
		list("M276 式弹药携行挂具", round(scale * 15), /obj/item/storage/belt/marine, VENDOR_ITEM_REGULAR),
		list("M276 式 M40 手榴弹携行挂具", round(scale * 10), /obj/item/storage/belt/grenade, VENDOR_ITEM_REGULAR),
		list("M276 式通用手枪枪套挂具", round(scale * 15), /obj/item/storage/belt/gun/m4a3, VENDOR_ITEM_REGULAR),
		list("M276 式 M44 枪套挂具", round(scale * 15), /obj/item/storage/belt/gun/m44, VENDOR_ITEM_REGULAR),
		list("M276 式 M82F 枪套挂具", round(scale * 5), /obj/item/storage/belt/gun/flaregun, VENDOR_ITEM_REGULAR),
		list("M276 G8-A 通用杂物袋", round(scale * 15), /obj/item/storage/backpack/general_belt, VENDOR_ITEM_REGULAR),

		list("收纳袋", -1, null, null, null),
		list("急救袋", floor(scale * 15), /obj/item/storage/pouch/firstaid, VENDOR_ITEM_REGULAR),
		list("照明弹袋 (满装)", floor(scale * 15), /obj/item/storage/pouch/flare/full, VENDOR_ITEM_REGULAR),
		list("弹匣袋", floor(scale * 15), /obj/item/storage/pouch/magazine, VENDOR_ITEM_REGULAR),
		list("中型杂物袋", floor(scale * 15), /obj/item/storage/pouch/general/medium, VENDOR_ITEM_REGULAR),
		list("手枪弹匣袋", floor(scale * 15), /obj/item/storage/pouch/magazine/pistol, VENDOR_ITEM_REGULAR),
		list("手枪袋", floor(scale * 15), /obj/item/storage/pouch/pistol, VENDOR_ITEM_REGULAR),

		list("限配收纳袋", -1, null, null, null),
		list("建材袋", 1.25, /obj/item/storage/pouch/construction, VENDOR_ITEM_REGULAR),
		list("爆炸物袋", 1.25, /obj/item/storage/pouch/explosive, VENDOR_ITEM_REGULAR),
		list("急救响应袋", 2.5, /obj/item/storage/pouch/first_responder, VENDOR_ITEM_REGULAR),
		list("大型手枪弹匣袋", floor(scale * 2), /obj/item/storage/pouch/magazine/pistol/large, VENDOR_ITEM_REGULAR),
		list("工具袋", 1.25, /obj/item/storage/pouch/tools, VENDOR_ITEM_REGULAR),
		list("枪带袋", 1.25, /obj/item/storage/pouch/sling, VENDOR_ITEM_REGULAR),
		list("喷火器燃料罐袋", 1.25, /obj/item/storage/pouch/flamertank, VENDOR_ITEM_REGULAR),

		list("面罩", -1, null, null, null),
		list("过滤面罩", round(scale * 10), /obj/item/clothing/mask/gas/pmc, VENDOR_ITEM_REGULAR),
		list("巴拉克拉法帽", round(scale * 15), /obj/item/clothing/mask/rebreather/scarf, VENDOR_ITEM_REGULAR),

		list("杂项", -1, null, null, null),
		list("防弹护目镜", round(scale * 10), /obj/item/clothing/glasses/mgoggles, VENDOR_ITEM_REGULAR),
		list("枪械润滑剂", round(scale * 15), /obj/item/prop/helmetgarb/gunoil, VENDOR_ITEM_REGULAR),
		list("PMC 帽", round(scale * 15), /obj/item/clothing/head/cmcap/weyyu, VENDOR_ITEM_REGULAR),
		)

/obj/structure/machinery/cm_vending/sorted/uniform_supply/squad_prep/pmc/suits
	name = "PMC 商务服装售货机"
	icon_state = "pmc_gear"

/obj/structure/machinery/cm_vending/sorted/uniform_supply/squad_prep/pmc/suits/populate_product_list(scale)
	listed_products = list(
		list("外套与内衣", 0, null, null, null),
		list("黑色西装裤", 15, /obj/item/clothing/under/liaison_suit/black, VENDOR_ITEM_RECOMMENDED),
		list("蓝色西装裤", 15, /obj/item/clothing/under/liaison_suit/blue, VENDOR_ITEM_REGULAR),
		list("棕色西装裤", 15, /obj/item/clothing/under/liaison_suit/brown, VENDOR_ITEM_REGULAR),
		list("白色西装裤", 15, /obj/item/clothing/under/liaison_suit/corporate_formal, VENDOR_ITEM_REGULAR),
		list("联络员棕褐色外套", 15, /obj/item/clothing/under/liaison_suit, VENDOR_ITEM_REGULAR),
		list("联络员炭灰色外套", 15, /obj/item/clothing/under/liaison_suit/charcoal, VENDOR_ITEM_REGULAR),
		list("联络员白色外套", 15, /obj/item/clothing/under/liaison_suit/formal, VENDOR_ITEM_REGULAR),
		list("联络员蓝色西装上衣", 15, /obj/item/clothing/under/liaison_suit/blazer, VENDOR_ITEM_REGULAR),
		list("联络员背带装", 15, /obj/item/clothing/under/liaison_suit/suspenders, VENDOR_ITEM_REGULAR),
		list("联络员裙子", 15, /obj/item/clothing/under/blackskirt, VENDOR_ITEM_REGULAR),
		list("学员制服", 15, /obj/item/clothing/under/suit_jacket/trainee, VENDOR_ITEM_REGULAR),
		list("乡村俱乐部服装", 15, /obj/item/clothing/under/liaison_suit/ivy, VENDOR_ITEM_REGULAR),
		list("橙色套装", 15, /obj/item/clothing/under/liaison_suit/orange, VENDOR_ITEM_REGULAR),
		list("商务便装", 15, /obj/item/clothing/under/liaison_suit/field, VENDOR_ITEM_REGULAR),
		list("灰色工作服", 15, /obj/item/clothing/under/colonist/workwear, VENDOR_ITEM_REGULAR),
		list("卡其色工作服", 15, /obj/item/clothing/under/colonist/workwear/khaki, VENDOR_ITEM_REGULAR),
		list("粉红色工作服", 15, /obj/item/clothing/under/colonist/workwear/pink, VENDOR_ITEM_REGULAR),
		list("绿色工作服", 15, /obj/item/clothing/under/colonist/workwear/green, VENDOR_ITEM_REGULAR),

		list("外套", 0, null, null, null),
		list("黑色西装外套", 15, /obj/item/clothing/suit/storage/jacket/marine/corporate/black, VENDOR_ITEM_RECOMMENDED),
		list("卡其色西装外套", 15, /obj/item/clothing/suit/storage/jacket/marine/corporate, VENDOR_ITEM_REGULAR),
		list("棕色西装外套", 15, /obj/item/clothing/suit/storage/jacket/marine/corporate/brown, VENDOR_ITEM_REGULAR),
		list("蓝色西装外套", 15, /obj/item/clothing/suit/storage/jacket/marine/corporate/blue, VENDOR_ITEM_REGULAR),
		list("正式西装外套", 15, /obj/item/clothing/suit/storage/jacket/marine/corporate/formal, VENDOR_ITEM_REGULAR),
		list("灰色飞行夹克", 15, /obj/item/clothing/suit/storage/jacket/marine/bomber/grey, VENDOR_ITEM_REGULAR),
		list("红色飞行夹克", 15, /obj/item/clothing/suit/storage/jacket/marine/bomber/red, VENDOR_ITEM_REGULAR),
		list("卡其色飞行夹克", 15, /obj/item/clothing/suit/storage/jacket/marine/bomber, VENDOR_ITEM_REGULAR),
		list("棕色飞行夹克", 15, /obj/item/clothing/suit/storage/bomber, VENDOR_ITEM_REGULAR),
		list("黑色飞行夹克", 15, /obj/item/clothing/suit/storage/bomber/alt, VENDOR_ITEM_REGULAR),
		list("联络员冬季外套", 15, /obj/item/clothing/suit/storage/snow_suit/liaison, VENDOR_ITEM_REGULAR),
		list("白大褂", 15, /obj/item/clothing/suit/storage/labcoat, VENDOR_ITEM_REGULAR),
		list("灰色背心", 15, /obj/item/clothing/suit/storage/jacket/marine/vest/grey, VENDOR_ITEM_REGULAR),
		list("棕色背心", 15, /obj/item/clothing/suit/storage/jacket/marine/vest, VENDOR_ITEM_REGULAR),
		list("棕褐色背心", 15, /obj/item/clothing/suit/storage/jacket/marine/vest/tan, VENDOR_ITEM_REGULAR),

		list("领带", 0, null, null, null),
		list("黑色领带", 15, /obj/item/clothing/accessory/black, VENDOR_ITEM_RECOMMENDED),
		list("红色领带", 15, /obj/item/clothing/accessory/red, VENDOR_ITEM_REGULAR),
		list("紫色领带", 15, /obj/item/clothing/accessory/purple, VENDOR_ITEM_REGULAR),
		list("蓝色领带", 15, /obj/item/clothing/accessory/blue, VENDOR_ITEM_REGULAR),
		list("绿色领带", 15, /obj/item/clothing/accessory/green, VENDOR_ITEM_REGULAR),
		list("金色领带", 15, /obj/item/clothing/accessory/gold, VENDOR_ITEM_REGULAR),
		list("特制领带", 15, /obj/item/clothing/accessory/horrible, VENDOR_ITEM_REGULAR),

		list("眼镜", 0, null, null, null),
		list("百美克斯太阳镜", 15, /obj/item/clothing/glasses/sunglasses/big, VENDOR_ITEM_RECOMMENDED),
		list("飞行员太阳镜", 15, /obj/item/clothing/glasses/sunglasses/aviator, VENDOR_ITEM_REGULAR),
		list("太阳镜", 15, /obj/item/clothing/glasses/sunglasses, VENDOR_ITEM_REGULAR),
		list("矫视型太阳镜", 15, /obj/item/clothing/glasses/sunglasses/prescription, VENDOR_ITEM_REGULAR),
		list("矫视眼镜", 15, /obj/item/clothing/glasses/regular/hipster, VENDOR_ITEM_REGULAR),

		list("手套", 0, null, null, null),
		list("黑色手套", 15, /obj/item/clothing/gloves/black, VENDOR_ITEM_RECOMMENDED),
		list("礼服手套", 15, /obj/item/clothing/gloves/marine/dress, VENDOR_ITEM_REGULAR),

		list("鞋子", 0, null, null, null),
		list("系带皮鞋, 黑色", 15, /obj/item/clothing/shoes/laceup, VENDOR_ITEM_RECOMMENDED),
		list("系带皮鞋, 棕色", 15, /obj/item/clothing/shoes/laceup/brown, VENDOR_ITEM_REGULAR),
		list("运动鞋, 黑色", 15, /obj/item/clothing/shoes/black, VENDOR_ITEM_REGULAR),
		list("公司配发靴", 15, /obj/item/clothing/shoes/marine/civilian, VENDOR_ITEM_REGULAR),

		list("帽子", 0, null, null, null),
		list("黑色贝雷帽", 15, /obj/item/clothing/head/beret/cm/black/civilian, VENDOR_ITEM_REGULAR),
		list("白色贝雷帽", 15, /obj/item/clothing/head/beret/cm/white/civilian, VENDOR_ITEM_REGULAR),
		list("软呢帽", 15, /obj/item/clothing/head/fedora, VENDOR_ITEM_REGULAR),

)

/obj/structure/machinery/cm_vending/sorted/uniform_supply/squad_prep/forecon
	name = "ColMarTech武装侦察制服售货机"
	icon_state = "forecon_gear"

/obj/structure/machinery/cm_vending/sorted/uniform_supply/squad_prep/forecon/populate_product_list(scale)
	listed_products = list(
		list("标准装备", -1, null, null, null),
		list("陆战队战斗靴", floor(scale * 15), /obj/item/clothing/shoes/marine/jungle/knife, VENDOR_ITEM_REGULAR),
		list("陆战队制服", floor(scale * 15), /obj/item/clothing/under/marine/standard, VENDOR_ITEM_REGULAR),
		list("陆战队黑色手套", round(scale * 15), /obj/item/clothing/gloves/marine, VENDOR_ITEM_REGULAR),
		list("陆战队棕色手套", round(scale * 15), /obj/item/clothing/gloves/marine/brown, VENDOR_ITEM_REGULAR),
		list("陆战队无线电耳机", round(scale * 15), /obj/item/device/radio/headset/almayer/marine/solardevils/forecon, VENDOR_ITEM_REGULAR),
		list("M5 式摄像耳机", floor(scale * 15), /obj/item/device/overwatch_camera, VENDOR_ITEM_REGULAR),
		list("巡逻帽, 丛林作战服", floor(scale * 15), /obj/item/clothing/head/cmcap, VENDOR_ITEM_REGULAR),
		list("巡逻帽, 雪地", floor(scale * 15), /obj/item/clothing/head/cmcap/snow, VENDOR_ITEM_REGULAR),
		list("巡逻帽, 沙漠", floor(scale * 15), /obj/item/clothing/head/cmcap/desert, VENDOR_ITEM_REGULAR),
		list("巡逻帽, 卡其色", round(scale * 5), /obj/item/clothing/head/cmcap/khaki, VENDOR_ITEM_REGULAR),
		list("丛林帽, 丛林", floor(scale * 15), /obj/item/clothing/head/cmcap/boonie, VENDOR_ITEM_REGULAR),
		list("丛林帽, 沙漠", floor(scale * 15), /obj/item/clothing/head/cmcap/boonie/tan, VENDOR_ITEM_REGULAR),
		list("丛林帽, 雪地", floor(scale * 15), /obj/item/clothing/head/cmcap/boonie/snow, VENDOR_ITEM_REGULAR),

		list("携行带", -1, null, null),
		list("M3-R 式携行带", 2, /obj/item/clothing/accessory/storage/webbing/m3/recon, VENDOR_ITEM_REGULAR),
		list("M3-R 式霰弹携行带", 2, /obj/item/clothing/accessory/storage/webbing/m3/recon/shotgun, VENDOR_ITEM_REGULAR),
		list("M3-R 式 M40 携行带", 2, /obj/item/clothing/accessory/storage/webbing/m3/recon/m40, VENDOR_ITEM_REGULAR),
		list("挂袋", 3, /obj/item/clothing/accessory/storage/droppouch, VENDOR_ITEM_REGULAR),
		list("肩部枪套", round(max(1,(scale * 0.5))), /obj/item/clothing/accessory/storage/holster, VENDOR_ITEM_REGULAR),

		list("护甲", -1, null, null),
		list("M3-R 式侦察护甲", round(scale * 10), /obj/item/clothing/suit/marine/rto/forecon, VENDOR_ITEM_REGULAR),
		list("M3 式前臂护甲", round(scale * 10), /obj/item/clothing/accessory/pads/bracers/standard, VENDOR_ITEM_REGULAR),
		list("M3 式护胫", round(scale * 10), /obj/item/clothing/accessory/pads/greaves/standard, VENDOR_ITEM_REGULAR),
		list("M3 式护膝", round(scale * 10), /obj/item/clothing/accessory/pads/kneepads/standard, VENDOR_ITEM_REGULAR),

		list("背包", -1, null, null, null),
		list("轻型 IMP 背包", round(scale * 15), /obj/item/storage/backpack/marine/standard, VENDOR_ITEM_REGULAR),
		list("USCM 挎包", round(scale * 15), /obj/item/storage/backpack/marine/satchel, VENDOR_ITEM_REGULAR),
		list("USCM 技术员挎包", floor(scale * 15), /obj/item/storage/backpack/marine/satchel/tech, VENDOR_ITEM_REGULAR),

		list("腰带", -1, null, null),
		list("M276 式弹药携行挂具", round(scale * 15), /obj/item/storage/belt/marine/standard, VENDOR_ITEM_REGULAR),
		list("M276 式 M40 手榴弹携行挂具", round(scale * 10), /obj/item/storage/belt/grenade, VENDOR_ITEM_REGULAR),
		list("M276 式通用手枪枪套挂具", round(scale * 15), /obj/item/storage/belt/gun/m4a3/standard, VENDOR_ITEM_REGULAR),
		list("M276 式通用左轮手枪枪套挂具", floor(scale * 15), /obj/item/storage/belt/gun/m44, VENDOR_ITEM_REGULAR),
		list("M276 式 M82F 枪套挂具", round(scale * 5), /obj/item/storage/belt/gun/flaregun, VENDOR_ITEM_REGULAR),
		list("M276 G8-A 通用杂物袋", round(scale * 15), /obj/item/storage/backpack/general_belt/standard, VENDOR_ITEM_REGULAR),

		list("收纳袋", -1, null, null, null),
		list("急救袋", floor(scale * 15), /obj/item/storage/pouch/firstaid, VENDOR_ITEM_REGULAR),
		list("照明弹袋 (满装)", floor(scale * 15), /obj/item/storage/pouch/flare/full, VENDOR_ITEM_REGULAR),
		list("弹匣袋", floor(scale * 15), /obj/item/storage/pouch/magazine, VENDOR_ITEM_REGULAR),
		list("中型杂物袋", floor(scale * 15), /obj/item/storage/pouch/general/medium, VENDOR_ITEM_REGULAR),
		list("手枪弹匣袋", floor(scale * 15), /obj/item/storage/pouch/magazine/pistol, VENDOR_ITEM_REGULAR),
		list("手枪袋", floor(scale * 15), /obj/item/storage/pouch/pistol, VENDOR_ITEM_REGULAR),

		list("限配收纳袋", -1, null, null, null),
		list("建材袋", 1.25, /obj/item/storage/pouch/construction, VENDOR_ITEM_REGULAR),
		list("爆炸物袋", 1.25, /obj/item/storage/pouch/explosive, VENDOR_ITEM_REGULAR),
		list("急救响应袋", 2.5, /obj/item/storage/pouch/first_responder, VENDOR_ITEM_REGULAR),
		list("大型手枪弹匣袋", floor(scale * 2), /obj/item/storage/pouch/magazine/pistol/large, VENDOR_ITEM_REGULAR),
		list("工具袋", 1.25, /obj/item/storage/pouch/tools, VENDOR_ITEM_REGULAR),
		list("枪带袋", 1.25, /obj/item/storage/pouch/sling, VENDOR_ITEM_REGULAR),
		list("喷火器燃料罐袋", 1.25, /obj/item/storage/pouch/flamertank, VENDOR_ITEM_REGULAR),
		list("霰弹袋", 1.25, /obj/item/storage/pouch/shotgun, VENDOR_ITEM_REGULAR),

		list("面罩", -1, null, null, null),
		list("M5 防毒面具", floor(scale * 15), /obj/item/clothing/mask/gas/military, VENDOR_ITEM_REGULAR),
		list("战术面巾", floor(scale * 10), /obj/item/clothing/mask/rebreather/scarf/tacticalmask, VENDOR_ITEM_REGULAR),
		list("吸热头套", floor(scale * 10), /obj/item/clothing/mask/rebreather/scarf, VENDOR_ITEM_REGULAR),

		list("额外服装", -1, null, null),
		list("雨披, 绿色", round(scale * 10), /obj/item/clothing/accessory/poncho/green, VENDOR_ITEM_REGULAR),
		list("雨披, 棕色", round(scale * 10), /obj/item/clothing/accessory/poncho/brown, VENDOR_ITEM_REGULAR),
		list("雨披, 黑色", round(scale * 10), /obj/item/clothing/accessory/poncho/black, VENDOR_ITEM_REGULAR),
		list("头巾, 丛林", round(scale * 5), /obj/item/clothing/head/cmbandana, VENDOR_ITEM_REGULAR),
		list("头巾, 沙漠", round(scale * 5), /obj/item/clothing/head/cmbandana/tan, VENDOR_ITEM_REGULAR),
		list("针织帽, 丛林", round(scale * 5), /obj/item/clothing/head/beanie/green, VENDOR_ITEM_REGULAR),
		list("针织帽, 城市", round(scale * 5), /obj/item/clothing/head/beanie/gray, VENDOR_ITEM_REGULAR),
		list("针织帽, 沙漠", round(scale * 5), /obj/item/clothing/head/beanie/tan, VENDOR_ITEM_REGULAR),
		list("贴头巾, 黑色", round(scale * 5), /obj/item/clothing/head/durag/black, VENDOR_ITEM_REGULAR),
		list("贴头巾, 自适应迷彩", round(scale * 5), /obj/item/clothing/head/durag, VENDOR_ITEM_REGULAR),
		list("远征帽, 丛林", round(scale * 5), /obj/item/clothing/head/cmcap/flap, VENDOR_ITEM_REGULAR),
		list("远征帽, 沙漠", round(scale * 5), /obj/item/clothing/head/cmcap/flap/desert, VENDOR_ITEM_REGULAR),
		list("远征帽, 雪地", round(scale * 5), /obj/item/clothing/head/cmcap/flap/snow, VENDOR_ITEM_REGULAR),
		list("USCM 耳机", round(scale * 5), /obj/item/clothing/head/headset/, VENDOR_ITEM_REGULAR),
		list("头带, 棕色", round(scale * 5), /obj/item/clothing/head/headband/brown, VENDOR_ITEM_REGULAR),
		list("头带, 灰色", round(scale * 5), /obj/item/clothing/head/headband/brown, VENDOR_ITEM_REGULAR),
		list("头带, 红色", round(scale * 5), /obj/item/clothing/head/headband/red, VENDOR_ITEM_REGULAR),
		list("头带, 绿色", round(scale * 5), /obj/item/clothing/head/headband, VENDOR_ITEM_REGULAR),
		list("头带, 棕褐色", round(scale * 5), /obj/item/clothing/head/headband/tan, VENDOR_ITEM_REGULAR),

		list("杂项", -1, null, null, null),
		list("防弹护目镜", round(scale * 10), /obj/item/clothing/glasses/mgoggles, VENDOR_ITEM_REGULAR),
		list("防弹护目镜, 遮阳", round(scale * 10), /obj/item/clothing/glasses/mgoggles/black, VENDOR_ITEM_REGULAR),
		list("防弹护目镜, 防激光 (棕色)", round(scale * 10), /obj/item/clothing/glasses/mgoggles/orange, VENDOR_ITEM_REGULAR),
		list("防弹护目镜, 防激光 (绿色)", round(scale * 10), /obj/item/clothing/glasses/mgoggles/green, VENDOR_ITEM_REGULAR),
		list("枪械润滑剂", round(scale * 15), /obj/item/prop/helmetgarb/gunoil, VENDOR_ITEM_REGULAR),
		list("FORECON 肩章", round(scale * 15), /obj/item/clothing/accessory/patch/forecon, VENDOR_ITEM_REGULAR),
		list("USCM 肩章", round(scale * 15), /obj/item/clothing/accessory/patch, VENDOR_ITEM_REGULAR),
		list("LRRP 铺盖卷", round(scale * 20), /obj/item/roller/bedroll, VENDOR_ITEM_REGULAR),
		list("陆战队配发指南针", round(scale * 20), /obj/item/prop/helmetgarb/compass, VENDOR_ITEM_REGULAR),
		)

/obj/structure/machinery/cm_vending/sorted/uniform_supply/squad_prep/rmc
	name = "维兰科技备用制服售货机"
	desc = "连接着小型 RMC 制式制服仓库的自动补给架。"
	icon_state = "rmc_gear"
	req_access = list(ACCESS_TWE_COMMANDO)
	req_one_access = list()
	listed_products = list()
	hackable = TRUE
	vendor_theme = VENDOR_THEME_COMPANY

/obj/structure/machinery/cm_vending/sorted/uniform_supply/squad_prep/rmc/populate_product_list(scale)
	listed_products = list(
		list("标准装备", -1, null, null, null),
		list("战斗靴", round(scale * 10), /obj/item/clothing/shoes/marine/rmc/knife, VENDOR_ITEM_REGULAR),
		list("皇家陆战队制服", round(scale * 10), /obj/item/clothing/under/marine/veteran/royal_marine, VENDOR_ITEM_REGULAR),
		list("战斗手套", round(scale * 10), /obj/item/clothing/gloves/marine, VENDOR_ITEM_REGULAR),
		list("Mk16 战术头盔", round(scale * 10), /obj/item/clothing/head/helmet/marine/veteran/pmc/gunner/rmc, VENDOR_ITEM_REGULAR),
		list("战术针织帽", round(scale * 10), /obj/item/clothing/head/beanie/royal_marine, VENDOR_ITEM_REGULAR),
		list("无线电耳机", round(scale * 10), /obj/item/device/radio/headset/almayer/marine/solardevils/rmc, VENDOR_ITEM_REGULAR),

		list("携行带", -1, null, null),
		list("82 式弹匣携行带", round(scale * 10), /obj/item/clothing/accessory/storage/webbing/m3/uppmags/rmc, VENDOR_ITEM_REGULAR),
		list("67 式携行带", round(scale * 10), /obj/item/clothing/accessory/storage/webbing/m3/uppsmall/rmc, VENDOR_ITEM_REGULAR),
		list("挂袋", round(scale * 4), /obj/item/clothing/accessory/storage/droppouch/rmc, VENDOR_ITEM_RECOMMENDED),
		list("小型收纳袋", round(scale * 4), /obj/item/clothing/accessory/storage/smallpouch/rmc, VENDOR_ITEM_REGULAR),
		list("腰部枪套", round(scale * 2), /obj/item/clothing/accessory/storage/holster/waist, VENDOR_ITEM_REGULAR),

		list("护甲", -1, null, null),
		list("红隼装甲胸甲", round(scale * 10), /obj/item/clothing/suit/marine/veteran/royal_marine, VENDOR_ITEM_REGULAR),
		list("红隼肩垫", round(scale * 10), /obj/item/clothing/accessory/twepads, VENDOR_ITEM_REGULAR),
		list("红隼护腿", round(scale * 10), /obj/item/clothing/accessory/twepads/legs, VENDOR_ITEM_REGULAR),

		list("背包", -1, null, null, null),
		list("重型背包", round(scale * 5), /obj/item/storage/backpack/rmc/heavy, VENDOR_ITEM_REGULAR),
		list("标准背包", round(scale * 10), /obj/item/storage/backpack/rmc/medium, VENDOR_ITEM_RECOMMENDED),
		list("轻型背包", round(scale * 5), /obj/item/storage/backpack/rmc/light, VENDOR_ITEM_REGULAR),

		list("腰带", -1, null, null),
		list("L70 式弹药携行挂具", round(scale * 10), /obj/item/storage/belt/marine/rmc, VENDOR_ITEM_RECOMMENDED),
		list("L26 式通用杂物腰带", round(scale * 10), /obj/item/storage/backpack/general_belt/rmc, VENDOR_ITEM_REGULAR),
		list("L165 枪械腰带", round(scale * 10), /obj/item/storage/belt/gun/l905, VENDOR_ITEM_REGULAR),

		list("收纳袋", -1, null, null, null),
		list("急救响应袋", floor(scale * 5), /obj/item/storage/pouch/first_responder/rmc, VENDOR_ITEM_REGULAR), //Only the FRP so they can store the ATKs & ABKs
		list("照明弹袋 (满装)", floor(scale * 5), /obj/item/storage/pouch/flare/rmc/full, VENDOR_ITEM_REGULAR),
		list("大型弹匣袋", floor(scale * 5), /obj/item/storage/pouch/magazine/large, VENDOR_ITEM_REGULAR),
		list("大型杂物袋", floor(scale * 5), /obj/item/storage/pouch/general/large, VENDOR_ITEM_REGULAR),
		list("大型手枪弹匣袋", floor(scale * 5), /obj/item/storage/pouch/magazine/pistol/large, VENDOR_ITEM_REGULAR),
		list("手枪袋", floor(scale * 5), /obj/item/storage/pouch/pistol, VENDOR_ITEM_REGULAR),
		list("爆炸物袋", floor(scale * 2), /obj/item/storage/pouch/explosive, VENDOR_ITEM_REGULAR),
		list("枪带袋", floor(scale * 2), /obj/item/storage/pouch/sling, VENDOR_ITEM_REGULAR),

		list("面罩", -1, null, null, null),
		list("L7 防毒面具", round(scale * 15), /obj/item/clothing/mask/gas/pmc/royal_marine, VENDOR_ITEM_REGULAR),

		list("杂项", -1, null, null, null),
		list("防弹护目镜", round(scale * 10), /obj/item/clothing/glasses/mgoggles/upp, VENDOR_ITEM_REGULAR),
		list("矫视型防弹护目镜", round(scale * 10), /obj/item/clothing/glasses/mgoggles/upp/prescription, VENDOR_ITEM_REGULAR),
		list("枪械润滑剂", round(scale * 15), /obj/item/prop/helmetgarb/gunoil, VENDOR_ITEM_REGULAR),
		list("皇家陆战突击队肩章", round(scale * 15), /obj/item/clothing/accessory/patch/royal_marines, VENDOR_ITEM_REGULAR),
		list("TWE 肩章", round(scale * 15), /obj/item/clothing/accessory/patch/twe, VENDOR_ITEM_REGULAR),
		list("铺盖卷", round(scale * 20), /obj/item/roller/bedroll, VENDOR_ITEM_REGULAR),
		list("军用水壶", round(scale * 20), /obj/item/reagent_container/food/drinks/flask/canteen, VENDOR_ITEM_REGULAR),
		)


//--------------SQUAD SPECIFIC VERSIONS--------------
//Those vendors aren't being used i will make them us the main vendor a parent to avoid having four different
// list with just the headset changed.

/obj/structure/machinery/cm_vending/sorted/uniform_supply/squad_prep/alpha
	req_access = list(ACCESS_MARINE_PREP)
	req_one_access = list(ACCESS_MARINE_ALPHA, ACCESS_MARINE_DATABASE, ACCESS_MARINE_CARGO)

/obj/structure/machinery/cm_vending/sorted/uniform_supply/squad_prep/bravo
	req_access = list(ACCESS_MARINE_PREP)
	req_one_access = list(ACCESS_MARINE_BRAVO, ACCESS_MARINE_DATABASE, ACCESS_MARINE_CARGO)

/obj/structure/machinery/cm_vending/sorted/uniform_supply/squad_prep/bravo/populate_product_list(scale)
	..()
	listed_products += list(
		list("耳机", -1, null, null),
		list("陆战队布拉沃无线电耳机", 10, /obj/item/device/radio/headset/almayer/marine/bravo, VENDOR_ITEM_REGULAR),
		)

/obj/structure/machinery/cm_vending/sorted/uniform_supply/squad_prep/charlie
	req_access = list(ACCESS_MARINE_PREP)
	req_one_access = list(ACCESS_MARINE_CHARLIE, ACCESS_MARINE_DATABASE, ACCESS_MARINE_CARGO)

/obj/structure/machinery/cm_vending/sorted/uniform_supply/squad_prep/charlie/populate_product_list(scale)
	..()
	listed_products += list(
		list("耳机", -1, null, null),
		list("陆战队查理无线电耳机", 10, /obj/item/device/radio/headset/almayer/marine/charlie, VENDOR_ITEM_REGULAR),
		)

/obj/structure/machinery/cm_vending/sorted/uniform_supply/squad_prep/delta
	req_access = list(ACCESS_MARINE_PREP)
	req_one_access = list(ACCESS_MARINE_DELTA, ACCESS_MARINE_DATABASE, ACCESS_MARINE_CARGO)

/obj/structure/machinery/cm_vending/sorted/uniform_supply/squad_prep/delta/populate_product_list(scale)
	..()
	listed_products += list(
		list("耳机", -1, null, null),
		list("陆战队德尔塔无线电耳机", 10, /obj/item/device/radio/headset/almayer/marine/delta, VENDOR_ITEM_REGULAR),
		)

//--------------SQUAD MUNITION VENDOR--------------

/obj/structure/machinery/cm_vending/sorted/cargo_ammo/squad
	name = "ColMarTech小队自动弹药售货机"
	desc = "连接着小型综合弹药仓库的自动补给架。所有陆战队步枪手均可使用。"
	req_access = list(ACCESS_MARINE_ALPHA)
	req_one_access = list(ACCESS_MARINE_LEADER, ACCESS_MARINE_SPECPREP, ACCESS_MARINE_RO)
	hackable = TRUE
	vend_flags = VEND_CLUTTER_PROTECTION | VEND_LIMITED_INVENTORY | VEND_TO_HAND | VEND_STOCK_DYNAMIC

	vend_x_offset = 2

/obj/structure/machinery/cm_vending/sorted/cargo_ammo/squad/ui_state(mob/user)
	return GLOB.not_incapacitated_and_adjacent_strict_state


/obj/structure/machinery/cm_vending/sorted/cargo_ammo/squad/populate_product_list(scale)
	listed_products = list(
		list("穿甲弹药", -1, null, null),
		list("M49A 穿甲弹匣 (10x24mm)", 3.5, /obj/item/ammo_magazine/rifle/m49a/ap, VENDOR_ITEM_REGULAR),
		list("M39 穿甲弹匣 (10x20mm)", floor(scale * 3), /obj/item/ammo_magazine/smg/m39/ap, VENDOR_ITEM_REGULAR),
		list("M41A 穿甲弹匣 (10x24mm)", floor(scale * 3), /obj/item/ammo_magazine/rifle/ap, VENDOR_ITEM_REGULAR),

		list("扩容弹药", -1, null, null),
		list("M39 扩容弹匣 (10x20mm)", 1.8, /obj/item/ammo_magazine/smg/m39/extended, VENDOR_ITEM_REGULAR),
		list("M41A 扩容弹匣 (10x24mm)", 1.9, /obj/item/ammo_magazine/rifle/extended, VENDOR_ITEM_REGULAR),

		list("特殊弹药", -1, null, null),
		list("M56 智能机枪弹鼓", 1, /obj/item/ammo_magazine/smartgun, VENDOR_ITEM_REGULAR),
		list("M44 重型快速装弹器 (.44)", floor(scale * 2), /obj/item/ammo_magazine/revolver/heavy, VENDOR_ITEM_REGULAR),
		list("M44 精确射手快速装弹器 (.44)", floor(scale * 2), /obj/item/ammo_magazine/revolver/marksman, VENDOR_ITEM_REGULAR),

		list("限配枪械弹药", -1, null, null),
		list("VP78 弹匣", floor(scale * 5), /obj/item/ammo_magazine/pistol/vp78, VENDOR_ITEM_REGULAR),
		list("SU-6 智能手枪弹匣 (.45)", floor(scale * 5), /obj/item/ammo_magazine/pistol/smart, VENDOR_ITEM_REGULAR),
		list("M240 喷火器燃料罐", floor(scale * 3), /obj/item/ammo_magazine/flamer_tank, VENDOR_ITEM_REGULAR),
		list("M56D 弹鼓", floor(scale * 2), /obj/item/ammo_magazine/m56d, VENDOR_ITEM_REGULAR),
		list("M2C 弹箱", floor(scale * 2), /obj/item/ammo_magazine/m2c, VENDOR_ITEM_REGULAR),
		list("HIRR 警棍弹", floor(scale * 6), /obj/item/explosive/grenade/slug/baton, VENDOR_ITEM_REGULAR),
		list("M74 AGM-S 照明弹", floor(scale * 4), /obj/item/explosive/grenade/high_explosive/airburst/starshell, VENDOR_ITEM_REGULAR),
		list("M74 AGM-S 蜂群弹", floor(scale * 4), /obj/item/explosive/grenade/high_explosive/airburst/hornet_shell, VENDOR_ITEM_REGULAR),
		)

//--------------SQUAD ARMAMENTS VENDOR--------------

/obj/structure/machinery/cm_vending/sorted/cargo_guns/squad
	name = "ColMarTech小队自动杂物售货机"
	desc = "连接着小型杂物与工具仓库的自动补给架。所有陆战队步枪手均可使用。"
	req_access = list()
	req_one_access = list(ACCESS_MARINE_LEADER, ACCESS_MARINE_SPECPREP, ACCESS_MARINE_RO, ACCESS_MARINE_PREP)
	hackable = TRUE

	vend_x_offset = 2
	vend_y_offset = 1
	vend_flags = VEND_CLUTTER_PROTECTION | VEND_LIMITED_INVENTORY | VEND_TO_HAND | VEND_STOCK_DYNAMIC

/obj/structure/machinery/cm_vending/sorted/cargo_guns/squad/ui_state(mob/user)
	return GLOB.not_incapacitated_and_adjacent_strict_state

/obj/structure/machinery/cm_vending/sorted/cargo_guns/squad/populate_product_list(scale)
	listed_products = list(
		list("食品", -1, null, null),
		list("即食军粮", floor(scale * 5), /obj/item/storage/box/mre, VENDOR_ITEM_REGULAR),
		list("即食军粮箱", floor(scale * 1), /obj/item/ammo_box/magazine/misc/mre, VENDOR_ITEM_REGULAR),

		list("医疗", -1, null, null),
		list("医用纱布", round(scale * 15), /obj/item/stack/medical/bruise_pack, VENDOR_ITEM_REGULAR),
		list("烧伤药膏", round(scale * 15), /obj/item/stack/medical/ointment, VENDOR_ITEM_REGULAR),
		list("夹板", round(scale * 15), /obj/item/stack/medical/splint, VENDOR_ITEM_REGULAR),
		list("应急自动注射器", round(scale * 15), /obj/item/reagent_container/hypospray/autoinjector/emergency, VENDOR_ITEM_REGULAR),
		list("比卡定自动注射器", round(scale * 15), /obj/item/reagent_container/hypospray/autoinjector/bicaridine/skillless, VENDOR_ITEM_REGULAR),
		list("克洛坦自动注射器", round(scale * 15), /obj/item/reagent_container/hypospray/autoinjector/kelotane/skillless, VENDOR_ITEM_REGULAR),
		list("广效康复嗪自动注射器", round(scale * 15), /obj/item/reagent_container/hypospray/autoinjector/tricord/skillless, VENDOR_ITEM_REGULAR),
		list("曲马多注射器", round(scale * 15), /obj/item/reagent_container/hypospray/autoinjector/tramadol/skillless, VENDOR_ITEM_REGULAR),

		list("工具", -1, null, null),
		list("工兵铲 (ET)", round(scale * 2), /obj/item/tool/shovel/etool/folded, VENDOR_ITEM_REGULAR),
		list("螺丝刀", round(scale * 5), /obj/item/tool/screwdriver, VENDOR_ITEM_REGULAR),
		list("剪线钳", round(scale * 5), /obj/item/tool/wirecutters, VENDOR_ITEM_REGULAR),
		list("撬棍", round(scale * 5), /obj/item/tool/crowbar, VENDOR_ITEM_REGULAR),
		list("扳手", round(scale * 5), /obj/item/tool/wrench, VENDOR_ITEM_REGULAR),
		list("多功能工具", round(scale * 1), /obj/item/device/multitool, VENDOR_ITEM_REGULAR),
		list("焊接工具", round(scale * 1), /obj/item/tool/weldingtool, VENDOR_ITEM_REGULAR),

		list("爆炸物", -1, null, null),
		list("塑性炸药", round(scale * 2), /obj/item/explosive/plastic, VENDOR_ITEM_REGULAR),
		list("破障炸药", round(scale * 2), /obj/item/explosive/plastic/breaching_charge, VENDOR_ITEM_REGULAR),

		list("照明弹与灯具", -1, null, null),
		list("战斗手电筒", round(scale * 5), /obj/item/device/flashlight/combat, VENDOR_ITEM_REGULAR),
		list("整箱手电筒", round(scale * 1), /obj/item/ammo_box/magazine/misc/flashlight, VENDOR_ITEM_REGULAR),
		list("整箱照明弹", round(scale * 1), /obj/item/ammo_box/magazine/misc/flares, VENDOR_ITEM_REGULAR),
		list("M94 标记照明弹包", round(scale * 10), /obj/item/storage/box/flare, VENDOR_ITEM_REGULAR),
		list("M89-S 信号照明弹包", round(scale * 1), /obj/item/storage/box/flare/signal, VENDOR_ITEM_REGULAR),

		list("副武器", -1, null, null),
		list("VP70 战斗手枪", round(scale * 2), /obj/item/weapon/gun/pistol/vp70/unloaded, VENDOR_ITEM_REGULAR),
		list("M4A3 制式手枪", round(scale * 2), /obj/item/weapon/gun/pistol/m4a3/unloaded, VENDOR_ITEM_REGULAR),
		list("M82F 信号枪", round(scale * 1), /obj/item/weapon/gun/flare, VENDOR_ITEM_REGULAR),

		list("杂项", -1, null, null),
		list("灭火器", round(scale * 5), /obj/item/tool/extinguisher, VENDOR_ITEM_REGULAR),
		list("灭火器 (便携式)", round(scale * 1), /obj/item/tool/extinguisher/mini, VENDOR_ITEM_REGULAR),
		list("轮式担架床", round(scale * 2), /obj/item/roller, VENDOR_ITEM_REGULAR),
		list("砍刀鞘 (满装)", round(scale * 5), /obj/item/storage/large_holster/machete/full, VENDOR_ITEM_REGULAR),
		list("战术单目镜", round(scale * 2), /obj/item/device/binoculars/range/monocular, VENDOR_ITEM_REGULAR),
		list("AN/PSQ-55 哨戒武器控制台", round(scale * 1), /obj/item/device/sentry_computer, VENDOR_ITEM_REGULAR),
		list("备用 PDT/L 战斗搭档套件", round(scale * 3), /obj/item/storage/box/pdt_kit/advanced, VENDOR_ITEM_REGULAR),
		list("导轨手电筒", round(scale * 5), /obj/item/attachable/flashlight, VENDOR_ITEM_REGULAR),
		list("双点枪带", round(scale * 5), /obj/item/attachable/sling, VENDOR_ITEM_REGULAR),
		list("M13 格斗刀", round(scale * 25), /obj/item/weapon/knife/marine, VENDOR_ITEM_REGULAR),
		)

/obj/structure/machinery/cm_vending/sorted/cargo_guns/squad/upp
	name = "联盟科技小队自动杂物售货机"
	desc = "连接着小型杂物与工具仓库的自动补给架。所有 UPP 步枪手均可使用。"
	req_access = list()
	req_one_access = list(ACCESS_UPP_GENERAL)
	hackable = TRUE

	vend_x_offset = 2
	vend_y_offset = 1
	vend_flags = VEND_CLUTTER_PROTECTION | VEND_LIMITED_INVENTORY | VEND_TO_HAND
	vendor_theme = VENDOR_THEME_UPP

/obj/structure/machinery/cm_vending/sorted/cargo_guns/squad/upp/populate_product_list(scale)
	listed_products = list(
		list("食品", -1, null, null),
		list("单兵口粮", round(scale * 15), /obj/item/storage/box/mre/upp, VENDOR_ITEM_REGULAR),
		list("IMR 箱", floor(scale * 1), /obj/item/ammo_box/magazine/misc/mre/upp, VENDOR_ITEM_REGULAR),

		list("医疗", -1, null, null),
		list("医用纱布", round(scale * 15), /obj/item/stack/medical/bruise_pack, VENDOR_ITEM_REGULAR),
		list("烧伤药膏", round(scale * 15), /obj/item/stack/medical/ointment, VENDOR_ITEM_REGULAR),
		list("夹板", round(scale * 15), /obj/item/stack/medical/splint, VENDOR_ITEM_REGULAR),
		list("应急自动注射器", round(scale * 15), /obj/item/reagent_container/hypospray/autoinjector/emergency, VENDOR_ITEM_REGULAR),
		list("比卡定自动注射器", round(scale * 15), /obj/item/reagent_container/hypospray/autoinjector/bicaridine/skillless, VENDOR_ITEM_REGULAR),
		list("克洛坦自动注射器", round(scale * 15), /obj/item/reagent_container/hypospray/autoinjector/kelotane/skillless, VENDOR_ITEM_REGULAR),
		list("广效康复嗪自动注射器", round(scale * 15), /obj/item/reagent_container/hypospray/autoinjector/tricord/skillless, VENDOR_ITEM_REGULAR),
		list("曲马多注射器", round(scale * 15), /obj/item/reagent_container/hypospray/autoinjector/tramadol/skillless, VENDOR_ITEM_REGULAR),

		list("工具", -1, null, null),
		list("50 式工兵铲", round(scale * 2), /obj/item/tool/shovel/etool/upp/folded, VENDOR_ITEM_REGULAR),
		list("螺丝刀", round(scale * 5), /obj/item/tool/screwdriver/tactical, VENDOR_ITEM_REGULAR),
		list("剪线钳", round(scale * 5), /obj/item/tool/wirecutters/tactical, VENDOR_ITEM_REGULAR),
		list("撬棍", round(scale * 5), /obj/item/tool/crowbar/tactical, VENDOR_ITEM_REGULAR),
		list("扳手", round(scale * 5), /obj/item/tool/wrench, VENDOR_ITEM_REGULAR),
		list("多功能工具", round(scale * 1), /obj/item/device/multitool/upp, VENDOR_ITEM_REGULAR),
		list("焊接工具", round(scale * 1), /obj/item/tool/weldingtool, VENDOR_ITEM_REGULAR),

		list("爆炸物", -1, null, null),
		list("塑性炸药", round(scale * 2), /obj/item/explosive/plastic, VENDOR_ITEM_REGULAR),
		list("破障炸药", round(scale * 2), /obj/item/explosive/plastic/breaching_charge, VENDOR_ITEM_REGULAR),

		list("照明弹与灯具", -1, null, null),
		list("整箱 R52 照明弹包", round(scale * 1), /obj/item/ammo_box/magazine/misc/flares/upp, VENDOR_ITEM_REGULAR),
		list("R52 标记照明弹包", round(scale * 10), /obj/item/storage/box/flare/upp, VENDOR_ITEM_REGULAR),

		list("副武器", -1, null, null),
		list("NP92 制式手枪", round(scale * 2), /obj/item/weapon/gun/pistol/np92/unloaded, VENDOR_ITEM_REGULAR),
		list("73 式制式手枪", round(scale * 2), /obj/item/weapon/gun/pistol/t73/unloaded, VENDOR_ITEM_REGULAR),

		list("杂项", -1, null, null),
		list("灭火器", round(scale * 5), /obj/item/tool/extinguisher, VENDOR_ITEM_REGULAR),
		list("灭火器 (便携式)", round(scale * 1), /obj/item/tool/extinguisher/mini, VENDOR_ITEM_REGULAR),
		list("轮式担架床", round(scale * 2), /obj/item/roller, VENDOR_ITEM_REGULAR),
		list("砍刀鞘 (满装)", round(scale * 5), /obj/item/storage/large_holster/machete/arnold/weak, VENDOR_ITEM_REGULAR),
		list("激光目标指示器", round(scale * 2), /obj/item/device/binoculars/range/designator/upp, VENDOR_ITEM_REGULAR),
		list("备用 PDT/L 战斗搭档套件", round(scale * 3), /obj/item/storage/box/pdt_kit/advanced, VENDOR_ITEM_REGULAR),
		list("导轨手电筒", round(scale * 5), /obj/item/attachable/flashlight, VENDOR_ITEM_REGULAR),
		list("80 式刺刀", round(scale * 5), /obj/item/attachable/bayonet/upp, null, VENDOR_ITEM_REGULAR),
		list("83 式榴弹发射器", 3, /obj/item/attachable/attached_gun/grenade/type71, null, VENDOR_ITEM_REGULAR),

		list("服装", -1, null, null),
		list("巴拉克拉法帽", round(scale * 5), /obj/item/clothing/mask/rebreather/scarf/tan, VENDOR_ITEM_REGULAR),
		list("巴拉克拉法帽", round(scale * 5), /obj/item/clothing/mask/rebreather/scarf, VENDOR_ITEM_REGULAR),
		list("围巾", round(scale * 5), /obj/item/clothing/mask/rebreather/scarf/tacticalmask/tan, VENDOR_ITEM_REGULAR),
		list("围巾", round(scale * 5), /obj/item/clothing/mask/rebreather/scarf/tacticalmask/black, VENDOR_ITEM_REGULAR),
		)

/obj/structure/machinery/cm_vending/sorted/cargo_guns/squad/forecon/populate_product_list(scale)
	listed_products = list(
		list("食品", -1, null, null),
		list("长途巡逻即食军粮", round(scale * 5), /obj/item/storage/box/mre/fsr, VENDOR_ITEM_REGULAR),
		list("即食军粮箱", round(scale * 1), /obj/item/ammo_box/magazine/misc/mre/fsr, VENDOR_ITEM_REGULAR),

		list("医疗", -1, null, null),
		list("医用纱布", round(scale * 15), /obj/item/stack/medical/bruise_pack, VENDOR_ITEM_REGULAR),
		list("烧伤药膏", round(scale * 15), /obj/item/stack/medical/ointment, VENDOR_ITEM_REGULAR),
		list("夹板", round(scale * 15), /obj/item/stack/medical/splint, VENDOR_ITEM_REGULAR),
		list("应急自动注射器", round(scale * 15), /obj/item/reagent_container/hypospray/autoinjector/emergency, VENDOR_ITEM_REGULAR),
		list("比卡定自动注射器", round(scale * 15), /obj/item/reagent_container/hypospray/autoinjector/bicaridine/skillless, VENDOR_ITEM_REGULAR),
		list("克洛坦自动注射器", round(scale * 15), /obj/item/reagent_container/hypospray/autoinjector/kelotane/skillless, VENDOR_ITEM_REGULAR),
		list("广效康复嗪自动注射器", round(scale * 15), /obj/item/reagent_container/hypospray/autoinjector/tricord/skillless, VENDOR_ITEM_REGULAR),
		list("曲马多注射器", round(scale * 15), /obj/item/reagent_container/hypospray/autoinjector/tramadol/skillless, VENDOR_ITEM_REGULAR),

		list("工具", -1, null, null),
		list("工兵铲 (ET)", round(scale * 2), /obj/item/tool/shovel/etool/folded, VENDOR_ITEM_REGULAR),
		list("螺丝刀", round(scale * 5), /obj/item/tool/screwdriver, VENDOR_ITEM_REGULAR),
		list("剪线钳", round(scale * 5), /obj/item/tool/wirecutters, VENDOR_ITEM_REGULAR),
		list("撬棍", round(scale * 5), /obj/item/tool/crowbar, VENDOR_ITEM_REGULAR),
		list("扳手", round(scale * 5), /obj/item/tool/wrench, VENDOR_ITEM_REGULAR),
		list("多功能工具", round(scale * 1), /obj/item/device/multitool, VENDOR_ITEM_REGULAR),
		list("焊接工具", round(scale * 1), /obj/item/tool/weldingtool, VENDOR_ITEM_REGULAR),

		list("爆炸物", -1, null, null),
		list("塑性炸药", round(scale * 2), /obj/item/explosive/plastic, VENDOR_ITEM_REGULAR),
		list("破障炸药", round(scale * 2), /obj/item/explosive/plastic/breaching_charge, VENDOR_ITEM_REGULAR),

		list("照明弹与灯具", -1, null, null),
		list("战斗手电筒", round(scale * 5), /obj/item/device/flashlight/combat, VENDOR_ITEM_REGULAR),
		list("整箱手电筒", round(scale * 1), /obj/item/ammo_box/magazine/misc/flashlight, VENDOR_ITEM_REGULAR),
		list("整箱照明弹", round(scale * 1), /obj/item/ammo_box/magazine/misc/flares, VENDOR_ITEM_REGULAR),
		list("M94 标记照明弹包", round(scale * 10), /obj/item/storage/box/flare, VENDOR_ITEM_REGULAR),
		list("M89-S 信号照明弹包", round(scale * 1), /obj/item/storage/box/flare/signal, VENDOR_ITEM_REGULAR),
		list("M72A2 HIPF 照明弹手榴弹包", round(scale * 3), /obj/item/storage/box/packet/flare, VENDOR_ITEM_REGULAR),

		list("副武器", -1, null, null), //forecon loves their pistols
		list("M48A4 制式手枪", round(scale * 5), /obj/item/weapon/gun/pistol/m1911/socom, VENDOR_ITEM_REGULAR),
		list("VP70 战斗手枪", round(scale * 5), /obj/item/weapon/gun/pistol/vp70, VENDOR_ITEM_REGULAR),
		list("M44 战斗左轮手枪", round(scale * 5), /obj/item/weapon/gun/revolver/m44, VENDOR_ITEM_REGULAR),
		list("M4A3 制式手枪", round(scale * 5), /obj/item/weapon/gun/pistol/m4a3, VENDOR_ITEM_REGULAR),
		list("VP78 手枪", round(scale * 5), /obj/item/weapon/gun/pistol/vp78, VENDOR_ITEM_REGULAR),
		list("M82F 信号枪", round(scale * 3), /obj/item/weapon/gun/flare, VENDOR_ITEM_REGULAR),

		list("副武器弹药", -1, null, null),
		list("M1911 弹匣 (.45)", round(scale * 20), /obj/item/ammo_magazine/pistol/m1911, VENDOR_ITEM_REGULAR),
		list("VP70 弹匣 (9mm)", round(scale * 20), /obj/item/ammo_magazine/pistol/vp70, VENDOR_ITEM_REGULAR),
		list("M44 快速装弹器 (.44)", round(scale * 20), /obj/item/ammo_magazine/revolver, VENDOR_ITEM_REGULAR),
		list("M4A3 弹匣 (9mm)", round(scale * 20), /obj/item/ammo_magazine/pistol, VENDOR_ITEM_REGULAR),
		list("VP78 弹匣 (9mm)", round(scale * 20), /obj/item/ammo_magazine/pistol/vp78, VENDOR_ITEM_REGULAR),

		list("杂项", -1, null, null),
		list("灭火器", round(scale * 5), /obj/item/tool/extinguisher, VENDOR_ITEM_REGULAR),
		list("灭火器 (便携式)", round(scale * 1), /obj/item/tool/extinguisher/mini, VENDOR_ITEM_REGULAR),
		list("轮式担架床", round(scale * 2), /obj/item/roller, VENDOR_ITEM_REGULAR),
		list("砍刀鞘 (满装)", round(scale * 5), /obj/item/storage/large_holster/machete/full, VENDOR_ITEM_REGULAR),
		list("双筒望远镜", round(scale * 1), /obj/item/device/binoculars, VENDOR_ITEM_REGULAR),
		list("备用 PDT/L 战斗搭档套件", round(scale * 3), /obj/item/storage/box/pdt_kit/advanced, VENDOR_ITEM_REGULAR),
		list("导轨手电筒", round(scale * 5), /obj/item/attachable/flashlight, VENDOR_ITEM_REGULAR),
		list("双点枪带", round(scale * 5), /obj/item/attachable/sling, VENDOR_ITEM_REGULAR),
		list("M13 格斗刀", round(scale * 5), /obj/item/weapon/knife/marine, VENDOR_ITEM_REGULAR),
		)

/obj/structure/machinery/cm_vending/sorted/cargo_guns/squad/pmc
	name = "PMC 小队自动杂物售货机"
	desc = "连接着小型杂物与工具仓库的自动补给架。所有 PMC 作战人员均可使用。"
	req_access = list(ACCESS_WY_GENERAL)
	req_one_access = list()

/obj/structure/machinery/cm_vending/sorted/cargo_guns/squad/pmc/populate_product_list(scale)
	listed_products = list(
		list("食品", -1, null, null),
		list("高级即食军粮", round(scale * 5), /obj/item/storage/box/mre/pmc, VENDOR_ITEM_REGULAR),
		list("即食军粮箱", round(scale * 1), /obj/item/ammo_box/magazine/misc/mre/pmc, VENDOR_ITEM_REGULAR),

		list("医疗", -1, null, null),
		list("医用纱布", round(scale * 15), /obj/item/stack/medical/bruise_pack, VENDOR_ITEM_REGULAR),
		list("烧伤药膏", round(scale * 15), /obj/item/stack/medical/ointment, VENDOR_ITEM_REGULAR),
		list("夹板", round(scale * 15), /obj/item/stack/medical/splint, VENDOR_ITEM_REGULAR),
		list("应急自动注射器", round(scale * 15), /obj/item/reagent_container/hypospray/autoinjector/emergency, VENDOR_ITEM_REGULAR),
		list("比卡定自动注射器", round(scale * 15), /obj/item/reagent_container/hypospray/autoinjector/bicaridine/skillless, VENDOR_ITEM_REGULAR),
		list("克洛坦自动注射器", round(scale * 15), /obj/item/reagent_container/hypospray/autoinjector/kelotane/skillless, VENDOR_ITEM_REGULAR),
		list("广效康复嗪自动注射器", round(scale * 15), /obj/item/reagent_container/hypospray/autoinjector/tricord/skillless, VENDOR_ITEM_REGULAR),
		list("曲马多注射器", round(scale * 15), /obj/item/reagent_container/hypospray/autoinjector/tramadol/skillless, VENDOR_ITEM_REGULAR),

		list("工具", -1, null, null),
		list("工兵铲 (ET)", round(scale * 2), /obj/item/tool/shovel/etool/folded, VENDOR_ITEM_REGULAR),
		list("螺丝刀", round(scale * 5), /obj/item/tool/screwdriver, VENDOR_ITEM_REGULAR),
		list("剪线钳", round(scale * 5), /obj/item/tool/wirecutters, VENDOR_ITEM_REGULAR),
		list("撬棍", round(scale * 5), /obj/item/tool/crowbar, VENDOR_ITEM_REGULAR),
		list("扳手", round(scale * 5), /obj/item/tool/wrench, VENDOR_ITEM_REGULAR),
		list("多功能工具", round(scale * 1), /obj/item/device/multitool, VENDOR_ITEM_REGULAR),
		list("焊接工具", round(scale * 1), /obj/item/tool/weldingtool, VENDOR_ITEM_REGULAR),

		list("爆炸物", -1, null, null),
		list("塑性炸药", round(scale * 2), /obj/item/explosive/plastic, VENDOR_ITEM_REGULAR),
		list("破障炸药", round(scale * 2), /obj/item/explosive/plastic/breaching_charge, VENDOR_ITEM_REGULAR),

		list("照明弹与灯具", -1, null, null),
		list("战斗手电筒", round(scale * 5), /obj/item/device/flashlight/combat, VENDOR_ITEM_REGULAR),
		list("整箱手电筒", round(scale * 1), /obj/item/ammo_box/magazine/misc/flashlight, VENDOR_ITEM_REGULAR),
		list("整箱照明弹", round(scale * 1), /obj/item/ammo_box/magazine/misc/flares, VENDOR_ITEM_REGULAR),
		list("M94 标记照明弹包", round(scale * 10), /obj/item/storage/box/flare, VENDOR_ITEM_REGULAR),
		list("M89-S 信号照明弹包", round(scale * 1), /obj/item/storage/box/flare/signal, VENDOR_ITEM_REGULAR),

		list("副武器", -1, null, null),
		list("VP70 战斗手枪", round(scale * 2), /obj/item/weapon/gun/pistol/vp70/unloaded, VENDOR_ITEM_REGULAR),
		list("VP78 战斗手枪", round(scale * 2), /obj/item/weapon/gun/pistol/vp78/unloaded, VENDOR_ITEM_REGULAR),
		list("ES4 静电手枪", round(scale * 3), /obj/item/weapon/gun/pistol/es4/unloaded, VENDOR_ITEM_REGULAR),

		list("副武器弹药", -1, null, null),
		list("VP70 弹匣 (9mm)", round(scale * 20), /obj/item/ammo_magazine/pistol/vp70, VENDOR_ITEM_REGULAR),
		list("VP78 弹匣 (9mm)", round(scale * 20), /obj/item/ammo_magazine/pistol/vp78, VENDOR_ITEM_REGULAR),
		list("ES4 电击弹匣 (9mm)", round(scale * 10), /obj/item/ammo_magazine/pistol/es4, VENDOR_ITEM_REGULAR),

		list("杂项", -1, null, null),
		list("灭火器", round(scale * 5), /obj/item/tool/extinguisher, VENDOR_ITEM_REGULAR),
		list("灭火器 (便携式)", round(scale * 1), /obj/item/tool/extinguisher/mini, VENDOR_ITEM_REGULAR),
		list("轮式担架床", round(scale * 2), /obj/item/roller, VENDOR_ITEM_REGULAR),
		list("砍刀鞘 (满装)", round(scale * 5), /obj/item/storage/large_holster/machete/full, VENDOR_ITEM_REGULAR),
		list("激光目标指示器", round(scale * 2), /obj/item/device/binoculars/range/designator, VENDOR_ITEM_REGULAR),
		list("AN/PSQ-55 哨戒武器控制台", round(scale * 1), /obj/item/device/sentry_computer, VENDOR_ITEM_REGULAR),
		list("备用 PDT/L 战斗搭档套件", round(scale * 3), /obj/item/storage/box/pdt_kit/advanced, VENDOR_ITEM_REGULAR),
		list("导轨手电筒", round(scale * 5), /obj/item/attachable/flashlight, VENDOR_ITEM_REGULAR),
		list("双点枪带", round(scale * 5), /obj/item/attachable/sling, VENDOR_ITEM_REGULAR),
		list("费尔贝恩-赛克斯格斗刀", round(scale * 25), /obj/item/weapon/knife/marine/sas, VENDOR_ITEM_REGULAR),
		)

/obj/structure/machinery/cm_vending/sorted/cargo_guns/squad/rmc
	name = "维兰科技班组自动杂物售货机"
	desc = "连接着小型杂物与工具仓库的自动补给架。所有皇家陆战队员均可使用。"
	req_access = list(ACCESS_TWE_COMMANDO)
	req_one_access = list()

/obj/structure/machinery/cm_vending/sorted/cargo_guns/squad/rmc/populate_product_list(scale)
	listed_products = list(
		list("食品", -1, null, null),
		list("作战口粮包", round(scale * 5), /obj/item/storage/box/mre/twe, VENDOR_ITEM_REGULAR),
		list("作战口粮包箱", round(scale * 1), /obj/item/ammo_box/magazine/misc/mre/twe, VENDOR_ITEM_REGULAR),

//Everyone has medical skill, so no need for the skillless injectors.
//ATK & ABK's as standard so the little shits don't empty the medics vendor too, because I KNOW they will otherwise
//Gauze & ointment are in there for handling low-damage wounds if they choose to pack them. 5-brute bleeding wounds, my beloathed.
//Don't be gentle with them. >:3
		list("医疗", -1, null, null),
		list("医用纱布", round(scale * 10), /obj/item/stack/medical/bruise_pack, VENDOR_ITEM_REGULAR),
		list("烧伤药膏", round(scale * 10), /obj/item/stack/medical/ointment, VENDOR_ITEM_REGULAR),
		list("创伤治疗包", round(scale * 15), /obj/item/stack/medical/advanced/bruise_pack, VENDOR_ITEM_REGULAR),
		list("烧伤治疗包", round(scale * 15), /obj/item/stack/medical/advanced/ointment, VENDOR_ITEM_REGULAR),
		list("夹板", round(scale * 15), /obj/item/stack/medical/splint, VENDOR_ITEM_REGULAR),
		list("应急自动注射器", round(scale * 15), /obj/item/reagent_container/hypospray/autoinjector/emergency, VENDOR_ITEM_REGULAR),
		list("比卡定自动注射器", round(scale * 15), /obj/item/reagent_container/hypospray/autoinjector/bicaridine, VENDOR_ITEM_REGULAR),
		list("克洛坦自动注射器", round(scale * 15), /obj/item/reagent_container/hypospray/autoinjector/kelotane, VENDOR_ITEM_REGULAR),
		list("广效康复嗪自动注射器", round(scale * 15), /obj/item/reagent_container/hypospray/autoinjector/tricord, VENDOR_ITEM_REGULAR),
		list("曲马多注射器", round(scale * 15), /obj/item/reagent_container/hypospray/autoinjector/tramadol, VENDOR_ITEM_REGULAR),

		list("爆炸物", -1, null, null),
		list("塑性炸药", round(scale * 1), /obj/item/explosive/plastic, VENDOR_ITEM_REGULAR),
		list("破障炸药", round(scale * 1), /obj/item/explosive/plastic/breaching_charge, VENDOR_ITEM_REGULAR),

		list("照明弹与灯具", -1, null, null),
		list("战斗手电筒", round(scale * 10), /obj/item/device/flashlight/combat, VENDOR_ITEM_REGULAR),
		list("L96 标记照明弹包", round(scale * 10), /obj/item/storage/box/flare/rmc, VENDOR_ITEM_REGULAR),

		list("副武器", -1, null, null),
		list("VP70 战斗手枪", round(scale * 2), /obj/item/weapon/gun/pistol/vp70/unloaded, VENDOR_ITEM_REGULAR),
		list("L54A2 战斗手枪", round(scale * 2), /obj/item/weapon/gun/pistol/l54/unloaded, VENDOR_ITEM_REGULAR),
		list("L165A1 战斗手枪", round(scale * 2), /obj/item/weapon/gun/pistol/vp78/rmc/unloaded, VENDOR_ITEM_REGULAR),

		list("杂项", -1, null, null),
		list("灭火器 (便携式)", round(scale * 2), /obj/item/tool/extinguisher/mini, VENDOR_ITEM_REGULAR),
		list("轮式担架床", round(scale * 2), /obj/item/roller, VENDOR_ITEM_REGULAR),
		list("砍刀鞘 (满装)", round(scale * 5), /obj/item/storage/large_holster/machete/full, VENDOR_ITEM_REGULAR),
		list("2155 式工兵铲", round(scale * 2), /obj/item/tool/shovel/etool/rmc/folded, VENDOR_ITEM_REGULAR),
		list("双筒望远镜", round(scale * 2), /obj/item/device/binoculars/civ, VENDOR_ITEM_REGULAR),
		list("导轨手电筒", round(scale * 5), /obj/item/attachable/flashlight, VENDOR_ITEM_REGULAR),
		list("双点枪带", round(scale * 2), /obj/item/attachable/sling, VENDOR_ITEM_REGULAR),
		list("费尔贝恩-赛克斯格斗刀", round(scale * 25), /obj/item/weapon/knife/marine/sas, VENDOR_ITEM_REGULAR),
		)


//--------------SQUAD ATTACHMENTS VENDOR--------------

/obj/structure/machinery/cm_vending/sorted/attachments/squad
	name = "阿玛特系统小队配件售货机"
	desc = "连接着小型武器配件仓库的自动补给架。所有陆战队步枪手均可使用。"
	req_access = list(ACCESS_MARINE_ALPHA)
	req_one_access = list(ACCESS_MARINE_LEADER, ACCESS_MARINE_SPECPREP, ACCESS_MARINE_RO)
	hackable = TRUE
	vend_flags = VEND_CLUTTER_PROTECTION | VEND_LIMITED_INVENTORY | VEND_TO_HAND | VEND_STOCK_DYNAMIC

	vend_y_offset = 1

/obj/structure/machinery/cm_vending/sorted/attachments/squad/ui_state(mob/user)
	return GLOB.not_incapacitated_and_adjacent_strict_state

/obj/structure/machinery/cm_vending/sorted/attachments/squad/populate_product_list(scale)
	listed_products = list(
		list("枪管", -1, null, null),
		list("加长枪管", 2.5, /obj/item/attachable/extended_barrel, VENDOR_ITEM_REGULAR),
		list("后坐补偿器", 2.5, /obj/item/attachable/compensator, VENDOR_ITEM_REGULAR),
		list("消音器", 2.5, /obj/item/attachable/suppressor, VENDOR_ITEM_REGULAR),

		list("导轨", -1, null, null),
		list("B8 智能瞄准镜", 1.5, /obj/item/attachable/scope/mini_iff, VENDOR_ITEM_REGULAR),
		list("磁力枪背带", 4, /obj/item/attachable/magnetic_harness, VENDOR_ITEM_REGULAR),
		list("S4 2x 小型望远瞄准镜", 2, /obj/item/attachable/scope/mini, VENDOR_ITEM_REGULAR),
		list("S5 红点瞄准镜", 3, /obj/item/attachable/reddot, VENDOR_ITEM_REGULAR),
		list("S6 反射式瞄准镜", 3, /obj/item/attachable/reflex, VENDOR_ITEM_REGULAR),
		list("S8 4x 望远瞄准镜", 2, /obj/item/attachable/scope, VENDOR_ITEM_REGULAR),

		list("下挂", -1, null, null),
		list("倾斜握把", 2.5, /obj/item/attachable/angledgrip, VENDOR_ITEM_REGULAR),
		list("两脚架", 2.5, /obj/item/attachable/bipod, VENDOR_ITEM_REGULAR),
		list("点射组件", 1.5, /obj/item/attachable/burstfire_assembly, VENDOR_ITEM_REGULAR),
		list("陀螺稳定器", 1.5, /obj/item/attachable/gyro, VENDOR_ITEM_REGULAR),
		list("激光瞄准器", 3, /obj/item/attachable/lasersight, VENDOR_ITEM_REGULAR),
		list("微型喷火器", 1.5, /obj/item/attachable/attached_gun/flamer, VENDOR_ITEM_REGULAR),
		list("XM-VESG-1 喷火器喷嘴", 1.5, /obj/item/attachable/attached_gun/flamer_nozzle, VENDOR_ITEM_REGULAR),
		list("U7 下挂霰弹枪", 1.5, /obj/item/attachable/attached_gun/shotgun, VENDOR_ITEM_REGULAR),
		list("下挂灭火器", 1.5, /obj/item/attachable/attached_gun/extinguisher, VENDOR_ITEM_REGULAR),
		list("垂直握把", 3, /obj/item/attachable/verticalgrip, VENDOR_ITEM_REGULAR),

		list("枪托", -1, null, null),
		list("M37 木制枪托", 1.5, /obj/item/attachable/stock/shotgun, VENDOR_ITEM_REGULAR),
		list("M39 臂托", 1.5, /obj/item/attachable/stock/smg/collapsible/brace, VENDOR_ITEM_REGULAR),
		list("M39 枪托", 1.5, /obj/item/attachable/stock/smg, VENDOR_ITEM_REGULAR),
		list("M41A 固定枪托", 1.5, /obj/item/attachable/stock/rifle, VENDOR_ITEM_REGULAR),
		list("M44 马格南精确射击枪托", 1.5, /obj/item/attachable/stock/revolver, VENDOR_ITEM_REGULAR)
		)

//------------ESSENTIAL SETS---------------
/obj/effect/essentials_set/random/uscm_light_armor
	spawned_gear_list = list(
		/obj/item/clothing/suit/marine/light/lines,
		/obj/item/clothing/suit/marine/light/smooth,
	)

/obj/effect/essentials_set/random/uscm_heavy_armor
	spawned_gear_list = list(
		/obj/item/clothing/suit/marine/heavy/lines,
		/obj/item/clothing/suit/marine/heavy/smooth,
	)

//------------MARINE CIVILIAN CLOTHING---------------

GLOBAL_LIST_INIT(cm_vending_clothing_marine_snowflake, list(
	list("衬衫与制服", 0, null, null, null),
	list("白色 T恤与棕色牛仔裤", 12, /obj/item/clothing/under/tshirt/w_br, null, VENDOR_ITEM_REGULAR),
	list("灰色 T恤与蓝色牛仔裤", 12, /obj/item/clothing/under/tshirt/gray_blu, null, VENDOR_ITEM_REGULAR),
	list("红色 T恤与黑色牛仔裤", 12, /obj/item/clothing/under/tshirt/r_bla, null, VENDOR_ITEM_REGULAR),
	list("边疆连体服", 12, /obj/item/clothing/under/rank/synthetic/frontier, null, VENDOR_ITEM_REGULAR),
	list("UA 灰色连体服", 12, /obj/item/clothing/under/colonist/ua_civvies, null, VENDOR_ITEM_REGULAR),
	list("UA 棕色连体服", 12, /obj/item/clothing/under/colonist/wy_davisone, null, VENDOR_ITEM_REGULAR),
	list("UA 绿色勤务服", 12, /obj/item/clothing/under/rank/synthetic/utility, null, VENDOR_ITEM_REGULAR),
	list("灰色勤务服", 12, /obj/item/clothing/under/rank/synthetic/utility/yellow, null, VENDOR_ITEM_REGULAR),
	list("灰色勤务服与蓝色牛仔裤", 12, /obj/item/clothing/under/rank/synthetic/utility/red, null, VENDOR_ITEM_REGULAR),
	list("蓝色勤务服与棕色牛仔裤", 12, /obj/item/clothing/under/rank/synthetic/utility/blue, null, VENDOR_ITEM_REGULAR),
	list("白色常服", 12, /obj/item/clothing/under/colonist/white_service, null, VENDOR_ITEM_REGULAR),
	list("勤务员服装", 12, /obj/item/clothing/under/colonist/wy_joliet_shopsteward, null, VENDOR_ITEM_REGULAR),
	list("红色礼服裙", 12, /obj/item/clothing/under/blackskirt, null, VENDOR_ITEM_REGULAR),
	list("蓝色西装裤", 12, /obj/item/clothing/under/liaison_suit/blue, null, VENDOR_ITEM_REGULAR),
	list("棕色西装裤", 12, /obj/item/clothing/under/liaison_suit/brown, null, VENDOR_ITEM_REGULAR),
	list("白色西装裤", 12, /obj/item/clothing/under/liaison_suit/corporate_formal, null, VENDOR_ITEM_REGULAR),
	list("工作乔制服", 36, /obj/item/clothing/under/rank/synthetic/joe, null, VENDOR_ITEM_REGULAR),

	list("眼镜", 0, null, null, null),
	list("陆战队军用配发眼镜", 12, /obj/item/clothing/glasses/regular, null, VENDOR_ITEM_REGULAR),
	list("太阳镜", 12, /obj/item/clothing/glasses/sunglasses, null, VENDOR_ITEM_REGULAR),

	list("鞋子", 0, null, null, null),
	list("靴子", 12, /obj/item/clothing/shoes/marine, null, VENDOR_ITEM_REGULAR),
	list("鞋子, 黑色", 12, /obj/item/clothing/shoes/black, null, VENDOR_ITEM_REGULAR),
	list("鞋子, 蓝色", 12, /obj/item/clothing/shoes/blue, null, VENDOR_ITEM_REGULAR),
	list("鞋子, 棕色", 12, /obj/item/clothing/shoes/brown, null, VENDOR_ITEM_REGULAR),
	list("鞋子, 绿色", 12, /obj/item/clothing/shoes/green, null, VENDOR_ITEM_REGULAR),
	list("鞋子, 紫色", 12, /obj/item/clothing/shoes/purple, null, VENDOR_ITEM_REGULAR),
	list("鞋子, 红色", 12, /obj/item/clothing/shoes/red, null, VENDOR_ITEM_REGULAR),
	list("鞋子, 白色", 12, /obj/item/clothing/shoes/white, null, VENDOR_ITEM_REGULAR),
	list("鞋子, 黄色", 12, /obj/item/clothing/shoes/yellow, null, VENDOR_ITEM_REGULAR),

	list("头部装备", 0, null, null, null),
	list("针织帽", 12, /obj/item/clothing/head/beanie, null, VENDOR_ITEM_REGULAR),
	list("贝雷帽, 工程", 12, /obj/item/clothing/head/beret/eng, null, VENDOR_ITEM_REGULAR),
	list("贝雷帽, 紫色", 12, /obj/item/clothing/head/beret/jan, null, VENDOR_ITEM_REGULAR),
	list("贝雷帽, 红色", 12, /obj/item/clothing/head/beret/cm/red, null, VENDOR_ITEM_REGULAR),
	list("贝雷帽, 标准", 12, /obj/item/clothing/head/beret/cm, null, VENDOR_ITEM_REGULAR),
	list("贝雷帽, 棕褐色", 12, /obj/item/clothing/head/beret/cm/tan, null, VENDOR_ITEM_REGULAR),
	list("贝雷帽, 绿色", 12, /obj/item/clothing/head/beret/cm, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),
	list("贝雷帽, 黑色", 12, /obj/item/clothing/head/beret/cm/black, null, VENDOR_ITEM_REGULAR),
	list("贝雷帽, 白色", 12, /obj/item/clothing/head/beret/cm/white, null, VENDOR_ITEM_REGULAR),
	list("护耳毛帽", 12, /obj/item/clothing/head/ushanka, null, VENDOR_ITEM_REGULAR),
	list("帽", 12, /obj/item/clothing/head/cmcap, null, VENDOR_ITEM_REGULAR),
	list("软呢帽", 12, /obj/item/clothing/head/fedora, null, VENDOR_ITEM_REGULAR),

	list("外套", 0, null, null, null),
	list("飞行夹克, 棕色", 12, /obj/item/clothing/suit/storage/bomber, null, VENDOR_ITEM_REGULAR),
	list("飞行夹克, 黑色", 12, /obj/item/clothing/suit/storage/bomber/alt, null, VENDOR_ITEM_REGULAR),
	list("外挂携行带", 12, /obj/item/clothing/suit/storage/webbing, null, VENDOR_ITEM_REGULAR),
	list("多用途背心", 12, /obj/item/clothing/suit/storage/utility_vest, null, VENDOR_ITEM_REGULAR),
	list("反光背心(橙色)", 12, /obj/item/clothing/suit/storage/hazardvest, null, VENDOR_ITEM_REGULAR),
	list("反光背心(蓝色)", 12, /obj/item/clothing/suit/storage/hazardvest/blue, null, VENDOR_ITEM_REGULAR),
	list("反光背心(黄色)", 12, /obj/item/clothing/suit/storage/hazardvest/yellow, null, VENDOR_ITEM_REGULAR),
	list("反光背心(黑色)", 12, /obj/item/clothing/suit/storage/hazardvest/black, null, VENDOR_ITEM_REGULAR),
	list("USCM 常服外套", 12, /obj/item/clothing/suit/storage/jacket/marine/service, null, VENDOR_ITEM_REGULAR),
	list("防风夹克, 棕色", 12, /obj/item/clothing/suit/storage/windbreaker/windbreaker_brown, null, VENDOR_ITEM_REGULAR),
	list("防风夹克, 灰色", 12, /obj/item/clothing/suit/storage/windbreaker/windbreaker_gray, null, VENDOR_ITEM_REGULAR),
	list("防风夹克, 绿色", 12, /obj/item/clothing/suit/storage/windbreaker/windbreaker_green, null, VENDOR_ITEM_REGULAR),
	list("防风夹克, 急救响应员", 12, /obj/item/clothing/suit/storage/windbreaker/windbreaker_fr, null, VENDOR_ITEM_REGULAR),
	list("防风夹克, 探险", 12, /obj/item/clothing/suit/storage/windbreaker/windbreaker_covenant, null, VENDOR_ITEM_REGULAR),
	list("黑色西装外套", 12, /obj/item/clothing/suit/storage/jacket/marine/corporate/black, null, VENDOR_ITEM_REGULAR),
	list("棕色西装外套", 12, /obj/item/clothing/suit/storage/jacket/marine/corporate/brown, null, VENDOR_ITEM_REGULAR),
	list("蓝色西装外套", 12, /obj/item/clothing/suit/storage/jacket/marine/corporate/blue, null, VENDOR_ITEM_REGULAR),
	list("棕色背心", 12, /obj/item/clothing/suit/storage/jacket/marine/vest, null, VENDOR_ITEM_REGULAR),
	list("棕褐色背心", 12, /obj/item/clothing/suit/storage/jacket/marine/vest/tan, null, VENDOR_ITEM_REGULAR),
	list("灰色背心", 12, /obj/item/clothing/suit/storage/jacket/marine/vest/grey, null, VENDOR_ITEM_REGULAR),

	list("背包", 0, null, null, null),
	list("背包, 工业", 12, /obj/item/storage/backpack/industrial, null, VENDOR_ITEM_REGULAR),
	list("挎包, 皮革", 12, /obj/item/storage/backpack/satchel, null, VENDOR_ITEM_REGULAR),
	list("挎包, 医疗", 12, /obj/item/storage/backpack/satchel/med, null, VENDOR_ITEM_REGULAR),

	list("其他", 0, null, null, null),
	list("红色臂带", 6, /obj/item/clothing/accessory/armband, null, VENDOR_ITEM_REGULAR),
	list("紫色臂带", 6, /obj/item/clothing/accessory/armband/science, null, VENDOR_ITEM_REGULAR),
	list("黄色臂带", 6, /obj/item/clothing/accessory/armband/engine, null, VENDOR_ITEM_REGULAR),
	list("绿色臂带", 6, /obj/item/clothing/accessory/armband/medgreen, null, VENDOR_ITEM_REGULAR),
	list("礼服手套", 6, /obj/item/clothing/gloves/marine/dress, null, VENDOR_ITEM_REGULAR),

))

/obj/structure/machinery/cm_vending/clothing/marine/snowflake
	name = "个人便服储存柜"
	desc = "在你执勤期间存放个人便服的售货机。"
	icon_state = "snowflake"
	show_points = TRUE
	use_snowflake_points = TRUE
	vendor_theme = VENDOR_THEME_COMPANY
	req_access = list()
	vendor_role = list()

	vend_delay = 1 SECONDS

/obj/structure/machinery/cm_vending/clothing/marine/snowflake/get_listed_products(mob/user)
	return GLOB.cm_vending_clothing_marine_snowflake
