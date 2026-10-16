//------------WHISKEY OUTPOST VENDOR VEERSIONS---------------

//------------UNIFORM VENDOR---------------

/obj/structure/machinery/cm_vending/sorted/uniform_supply/squad_prep/wo
	req_access = list()
	req_one_access = list()

/obj/structure/machinery/cm_vending/sorted/uniform_supply/squad_prep/wo/populate_product_list(scale)
	listed_products = list(
		list("标准装备", -1, null, null, null),
		list("陆战队战斗靴", floor(scale * 10), /obj/item/clothing/shoes/marine, VENDOR_ITEM_REGULAR),
		list("USCM 制服", floor(scale * 10), /obj/item/clothing/under/marine, VENDOR_ITEM_REGULAR),
		list("陆战队战斗手套", floor(scale * 10), /obj/item/clothing/gloves/marine, VENDOR_ITEM_REGULAR),
		list("陆战队棕色战斗手套", floor(scale * 2), /obj/item/clothing/gloves/marine/brown, VENDOR_ITEM_REGULAR),
		list("陆战队黑色战斗手套", floor(scale * 2), /obj/item/clothing/gloves/marine, VENDOR_ITEM_REGULAR),
		list("M10 式陆战队头盔", floor(scale * 10), /obj/item/clothing/head/helmet/marine, VENDOR_ITEM_REGULAR),
		list("USCM 巡逻帽", floor(scale * 10), /obj/item/clothing/head/cmcap, VENDOR_ITEM_REGULAR),
		list("USCM 丛林帽", floor(scale * 10), /obj/item/clothing/head/cmcap/boonie, VENDOR_ITEM_REGULAR),

		list("无线电耳机", -1, null, null),
		list("一排耳机", floor(scale * 5), /obj/item/device/radio/headset/almayer/marine/solardevils, VENDOR_ITEM_REGULAR),
		list("二排耳机", floor(scale * 5), /obj/item/device/radio/headset/almayer/marine/solardevils/foxtrot, VENDOR_ITEM_REGULAR),

		list("携行带", -1, null, null),
		list("M3 式携行带", floor(scale * 2), /obj/item/clothing/accessory/storage/webbing/m3, VENDOR_ITEM_REGULAR),
		list("M3 式弹匣携行带", floor(scale * 2), /obj/item/clothing/accessory/storage/webbing/m3/mag, VENDOR_ITEM_REGULAR),
		list("M3 式霰弹携行带", floor(scale * 2), /obj/item/clothing/accessory/storage/webbing/m3/shotgun, VENDOR_ITEM_REGULAR),
		list("M3 式 M40 携行带", floor(scale * 1), /obj/item/clothing/accessory/storage/webbing/m3/m40, VENDOR_ITEM_REGULAR),
		list("M3 式小型收纳袋携行带", floor(scale * 1), /obj/item/clothing/accessory/storage/webbing/m3/small, VENDOR_ITEM_REGULAR),
		list("挂袋", 3, /obj/item/clothing/accessory/storage/droppouch, VENDOR_ITEM_REGULAR),
		list("肩部枪套", round(max(1,(scale * 0.5))), /obj/item/clothing/accessory/storage/holster, VENDOR_ITEM_REGULAR),

		list("护甲", -1, null, null),
		list("M3 式陆战队护甲", 20, /obj/item/clothing/suit/marine, VENDOR_ITEM_REGULAR),
		list("M3-EOD 式重型护甲", 10, /obj/item/clothing/suit/marine/heavy, VENDOR_ITEM_REGULAR),
		list("M3-L 式轻型护甲", 10, /obj/item/clothing/suit/marine/light, VENDOR_ITEM_REGULAR),

		list("背包", -1, null, null, null),
		list("轻型 IMP 背包", floor(scale * 10), /obj/item/storage/backpack/marine, VENDOR_ITEM_REGULAR),
		list("技术员背包", floor(scale * 10), /obj/item/storage/backpack/marine/tech, VENDOR_ITEM_REGULAR),
		list("医疗背包", floor(scale * 10), /obj/item/storage/backpack/marine/medic, VENDOR_ITEM_REGULAR),
		list("USCM 挎包", floor(scale * 10), /obj/item/storage/backpack/marine/satchel, VENDOR_ITEM_REGULAR),
		list("USCM 胸挂", floor(scale * 10), /obj/item/storage/backpack/marine/satchel/chestrig, VENDOR_ITEM_REGULAR),
		list("USCM 技术员挎包", floor(scale * 10), /obj/item/storage/backpack/marine/satchel/tech, VENDOR_ITEM_REGULAR),
		list("USCM 技术员胸挂", floor(scale * 10), /obj/item/storage/backpack/marine/engineerpack/welder_chestrig, VENDOR_ITEM_REGULAR),
		list("医疗挎包", floor(scale * 10), /obj/item/storage/backpack/marine/satchel/medic, VENDOR_ITEM_REGULAR),
		list("霰弹枪鞘", floor(scale * 10), /obj/item/storage/large_holster/m37, VENDOR_ITEM_REGULAR),

		list("限配背包", -1, null, null),
		list("USCM 技术员焊接背包", floor(scale * 1), /obj/item/storage/backpack/marine/engineerpack, VENDOR_ITEM_REGULAR),
		list("技术员焊接挎包", floor(scale * 2), /obj/item/storage/backpack/marine/engineerpack/satchel, VENDOR_ITEM_REGULAR),

		list("腰带", -1, null, null),
		list("M276 式弹药携行挂具", floor(scale * 10), /obj/item/storage/belt/marine, VENDOR_ITEM_REGULAR),
		list("M276 式 M40 手榴弹携行挂具", floor(scale * 5), /obj/item/storage/belt/grenade, VENDOR_ITEM_REGULAR),
		list("M276 式霰弹装填挂具", floor(scale * 10), /obj/item/storage/belt/shotgun, VENDOR_ITEM_REGULAR),
		list("M276 式通用手枪枪套挂具", floor(scale * 10), /obj/item/storage/belt/gun/m4a3, VENDOR_ITEM_REGULAR),
		list("M276 式 M39 枪套挂具", floor(scale * 10), /obj/item/storage/large_holster/m39, VENDOR_ITEM_REGULAR),
		list("M276 式 M39 枪套挂具及收纳袋", floor(scale * 5), /obj/item/storage/belt/gun/m39, VENDOR_ITEM_REGULAR),
		list("M276 式通用左轮手枪枪套挂具", floor(scale * 10), /obj/item/storage/belt/gun/m44, VENDOR_ITEM_REGULAR),
		list("M276 式 M82F 枪套挂具", floor(scale * 2), /obj/item/storage/belt/gun/flaregun, VENDOR_ITEM_REGULAR),
		list("M276 刀具携行挂具 (满装)", floor(scale * 10), /obj/item/storage/belt/knifepouch, VENDOR_ITEM_REGULAR),
		list("M276 G8-A 通用杂物袋", floor(scale * 10), /obj/item/storage/backpack/general_belt, VENDOR_ITEM_REGULAR),

		list("收纳袋", -1, null, null, null),
		list("刺刀鞘 (满装)",floor(scale * 10), /obj/item/storage/pouch/bayonet, VENDOR_ITEM_REGULAR),
		list("急救袋 (夹板, 医用纱布, 烧伤药膏)", floor(scale * 10), /obj/item/storage/pouch/firstaid/full/alternate, VENDOR_ITEM_REGULAR),
		list("急救袋 (药片包)", floor(scale * 10), /obj/item/storage/pouch/firstaid/full/pills, VENDOR_ITEM_REGULAR),
		list("照明弹袋 (满装)", floor(scale * 10), /obj/item/storage/pouch/flare/full, VENDOR_ITEM_REGULAR),
		list("弹匣袋", floor(scale * 10), /obj/item/storage/pouch/magazine, VENDOR_ITEM_REGULAR),
		list("霰弹袋", floor(scale * 10), /obj/item/storage/pouch/shotgun, VENDOR_ITEM_REGULAR),
		list("中型杂物袋", floor(scale * 10), /obj/item/storage/pouch/general/medium, VENDOR_ITEM_REGULAR),
		list("手枪弹匣袋", floor(scale * 10), /obj/item/storage/pouch/magazine/pistol, VENDOR_ITEM_REGULAR),
		list("手枪袋", floor(scale * 10), /obj/item/storage/pouch/pistol, VENDOR_ITEM_REGULAR),

		list("限配收纳袋", -1, null, null, null),
		list("建材袋", floor(scale * 1), /obj/item/storage/pouch/construction, VENDOR_ITEM_REGULAR),
		list("爆炸物袋", floor(scale * 1), /obj/item/storage/pouch/explosive, VENDOR_ITEM_REGULAR),
		list("急救响应袋 (空)", floor(scale * 2), /obj/item/storage/pouch/first_responder, VENDOR_ITEM_REGULAR),
		list("大型手枪弹匣袋", floor(scale * 2), /obj/item/storage/pouch/magazine/pistol/large, VENDOR_ITEM_REGULAR),
		list("工具袋", floor(scale * 1), /obj/item/storage/pouch/tools, VENDOR_ITEM_REGULAR),
		list("枪带袋", floor(scale * 1), /obj/item/storage/pouch/sling, VENDOR_ITEM_REGULAR),

		list("面罩", -1, null, null, null),
		list("防毒面具", floor(scale * 10), /obj/item/clothing/mask/gas, VENDOR_ITEM_REGULAR),
		list("吸热头套", floor(scale * 5), /obj/item/clothing/mask/rebreather/scarf, VENDOR_ITEM_REGULAR),
		list("呼吸调温器", floor(scale * 5), /obj/item/clothing/mask/rebreather, MARINE_CAN_BUY_MASK, VENDOR_ITEM_REGULAR),

		list("杂项", -1, null, null, null),
		list("防弹护目镜", floor(scale * 5), /obj/item/clothing/glasses/mgoggles, VENDOR_ITEM_REGULAR),
		list("矫视型防弹护目镜", floor(scale * 5), /obj/item/clothing/glasses/mgoggles/prescription, VENDOR_ITEM_REGULAR),
		list("陆战队军用配发眼镜", floor(scale * 5), /obj/item/clothing/glasses/regular, VENDOR_ITEM_REGULAR),
		list("M10 头盔伪装网", floor(scale * 5), /obj/item/prop/helmetgarb/netting, VENDOR_ITEM_REGULAR),
		list("M10 头盔防雨罩", floor(scale * 5), /obj/item/prop/helmetgarb/raincover, VENDOR_ITEM_REGULAR),
		list("M10 头盔迷彩罩", floor(scale * 5), /obj/item/prop/helmetgarb/camocover, VENDOR_ITEM_REGULAR),
		list("枪械润滑剂", floor(scale * 10), /obj/item/prop/helmetgarb/gunoil, VENDOR_ITEM_REGULAR),
		list("USCM 装饰徽章", floor(scale * 10), /obj/item/prop/helmetgarb/flair_uscm, VENDOR_ITEM_REGULAR),
		list("坠落猎鹰肩章", floor(scale * 10), /obj/item/clothing/accessory/patch/falcon, VENDOR_ITEM_REGULAR),
		list("USCM 肩章", floor(scale * 10), /obj/item/clothing/accessory/patch, VENDOR_ITEM_REGULAR),
		list("铺盖卷", floor(scale * 10), /obj/item/roller/bedroll, VENDOR_ITEM_REGULAR),

		list("光学设备", -1, null, null, null),
		list("高级医疗镜片 (医疗兵专用)", floor(scale * 2), /obj/item/device/helmet_visor/medical/advanced, VENDOR_ITEM_REGULAR),
		list("小队状态镜片", floor(scale * 10), /obj/item/device/helmet_visor, VENDOR_ITEM_REGULAR),
		)

//------------WEAPON RACKS---------------

/obj/structure/machinery/cm_vending/sorted/cargo_guns/squad_prep/wo
	req_access = list()
	req_one_access = list()
	vend_flags = VEND_CLUTTER_PROTECTION | VEND_LIMITED_INVENTORY | VEND_TO_HAND | VEND_LOAD_AMMO_BOXES | VEND_STOCK_DYNAMIC

/obj/structure/machinery/cm_vending/sorted/cargo_guns/squad_prep/wo/populate_product_list(scale)
	listed_products = list(
		list("主武器枪械", -1, null, null),
		list("M49A 战斗步枪", floor(scale * 10), /obj/item/weapon/gun/rifle/m49a, VENDOR_ITEM_REGULAR),
		list("M37A2 泵动霰弹枪", floor(scale * 15), /obj/item/weapon/gun/shotgun/pump, VENDOR_ITEM_REGULAR),
		list("M39 冲锋枪", floor(scale * 30), /obj/item/weapon/gun/smg/m39, VENDOR_ITEM_REGULAR),
		list("M41A 脉冲步枪 MK1", floor(scale * 30), /obj/item/weapon/gun/rifle/m41aMK1, VENDOR_ITEM_REGULAR),
		list("M41A 脉冲步枪 MK2", floor(scale * 30), /obj/item/weapon/gun/rifle/m41a, VENDOR_ITEM_REGULAR),

		list("主武器弹药", -1, null, null),
		list("整箱鹿弹 (12g)", floor(scale * 10), /obj/item/ammo_magazine/shotgun/buckshot, VENDOR_ITEM_REGULAR),
		list("整箱箭形弹 (12g)", floor(scale * 4), /obj/item/ammo_magazine/shotgun/flechette, VENDOR_ITEM_REGULAR),
		list("整箱霰弹枪独头弹 (12g)", floor(scale * 10), /obj/item/ammo_magazine/shotgun/slugs, VENDOR_ITEM_REGULAR),
		list("M49A 弹匣 (10x24mm)", floor(scale * 15), /obj/item/ammo_magazine/rifle/m49a, VENDOR_ITEM_REGULAR),
		list("M39 高速弹匣 (10x20mm)", floor(scale * 25), /obj/item/ammo_magazine/smg/m39, VENDOR_ITEM_REGULAR),
		list("M41A MK1 弹匣 (10x24mm)", floor(scale * 25), /obj/item/ammo_magazine/rifle/m41aMK1, VENDOR_ITEM_REGULAR),
		list("M41A MK2 弹匣 (10x24mm)", floor(scale * 25), /obj/item/ammo_magazine/rifle, VENDOR_ITEM_REGULAR),

		list("副武器", -1, null, null),
		list("VP70 战斗手枪", floor(scale * 25), /obj/item/weapon/gun/pistol/vp70, VENDOR_ITEM_REGULAR),
		list("M44 战斗左轮手枪", floor(scale * 25), /obj/item/weapon/gun/revolver/m44, VENDOR_ITEM_REGULAR),
		list("M4A3 制式手枪", floor(scale * 25), /obj/item/weapon/gun/pistol/m4a3, VENDOR_ITEM_REGULAR),
		list("M82F 信号枪", floor(scale * 5), /obj/item/weapon/gun/flare, VENDOR_ITEM_REGULAR),

		list("副武器弹药", -1, null, null),
		list("VP70 弹匣 (9mm)", floor(scale * 25), /obj/item/ammo_magazine/pistol/vp70, VENDOR_ITEM_REGULAR),
		list("M44 快速装弹器 (.44)", floor(scale * 20), /obj/item/ammo_magazine/revolver, VENDOR_ITEM_REGULAR),
		list("M4A3 弹匣 (9mm)", floor(scale * 25), /obj/item/ammo_magazine/pistol, VENDOR_ITEM_REGULAR),

		list("配件", -1, null, null),
		list("M39 折叠枪托", floor(scale * 10), /obj/item/attachable/stock/smg/collapsible, VENDOR_ITEM_REGULAR),
		list("导轨手电筒", floor(scale * 25), /obj/item/attachable/flashlight, VENDOR_ITEM_REGULAR),
		list("下挂手电握把", floor(scale * 10), /obj/item/attachable/flashlight/grip, VENDOR_ITEM_REGULAR),
		list("下挂式榴弹发射器", floor(scale * 25), /obj/item/attachable/attached_gun/grenade, VENDOR_ITEM_REGULAR), //They already get these as on-spawns, might as well formalize some spares.

		list("勤务服", -1, null, null),
		list("M5 刺刀", floor(scale * 25), /obj/item/attachable/bayonet, VENDOR_ITEM_REGULAR),
		list("M11 飞刀", floor(scale * 10), /obj/item/weapon/throwing_knife, VENDOR_ITEM_REGULAR),
		list("M94 标记照明弹包", floor(scale * 10), /obj/item/storage/box/flare, VENDOR_ITEM_REGULAR),
		list("塑性炸药", floor(scale * 2), /obj/item/explosive/plastic, VENDOR_ITEM_REGULAR),
	)

//------------REQ AMMUNITION VENDOR---------------
/obj/structure/machinery/cm_vending/sorted/cargo_ammo/cargo/wo
	req_access = list(ACCESS_MARINE_CARGO)
	req_one_access = list()

/obj/structure/machinery/cm_vending/sorted/cargo_ammo/cargo/wo/populate_product_list(scale)
	..()
	listed_products += list(
		list("额外侦察兵弹药", -1, null, null, null),
		list("A19 高速高冲击弹匣 (10x24mm)", floor(scale * 1), /obj/item/ammo_magazine/rifle/m49a/custom/explosive, VENDOR_ITEM_REGULAR),
		list("A19 高速燃烧弹匣 (10x24mm)", floor(scale * 1), /obj/item/ammo_magazine/rifle/m49a/custom/incendiary, VENDOR_ITEM_REGULAR),
		list("A19 高速弹匣 (10x24mm)", floor(scale * 1.5), /obj/item/ammo_magazine/rifle/m49a/custom, VENDOR_ITEM_REGULAR),

		list("额外狙击手弹药", -1, null, null, null),
		list("M42A 防空弹匣 (10x28mm)", floor(scale * 1), /obj/item/ammo_magazine/sniper/flak, VENDOR_ITEM_REGULAR),
		list("M42A 燃烧弹匣 (10x28mm)", floor(scale * 1), /obj/item/ammo_magazine/sniper/incendiary, VENDOR_ITEM_REGULAR),
		list("M42A 精确射击弹匣 (10x28mm 无壳弹)", floor(scale * 1.5), /obj/item/ammo_magazine/sniper, VENDOR_ITEM_REGULAR),
		list("XM43E1 精确射击弹匣 (10x99mm 无壳弹)", floor(scale * 3), /obj/item/ammo_magazine/sniper/anti_materiel, VENDOR_ITEM_REGULAR),

		list("额外爆破手弹药", -1, null, null, null),
		list("84mm 反装甲火箭弹", floor(scale * 1), /obj/item/ammo_magazine/rocket/ap, VENDOR_ITEM_REGULAR),
		list("84mm 高爆火箭弹", floor(scale * 1), /obj/item/ammo_magazine/rocket, VENDOR_ITEM_REGULAR),
		list("84mm 白磷火箭弹", floor(scale * 1), /obj/item/ammo_magazine/rocket/wp, VENDOR_ITEM_REGULAR),

		list("额外手榴弹", -1, null, null, null),
		list("M40 HEDP 手榴弹包 (x6)", floor(scale * 1.5), /obj/effect/essentials_set/hedp_6_pack, VENDOR_ITEM_REGULAR),
		list("M40 HIDP 手榴弹包 (x6)", floor(scale * 1.5), /obj/effect/essentials_set/hidp_6_pack, VENDOR_ITEM_REGULAR),
		list("M74 AGM-F 手榴弹包 (x6)", floor(scale * 1.5), /obj/effect/essentials_set/agmf_6_pack, VENDOR_ITEM_REGULAR),
		list("M74 AGM-I 手榴弹包 (x6)", floor(scale * 1.5), /obj/effect/essentials_set/agmi_6_pack, VENDOR_ITEM_REGULAR),

		list("额外喷火器燃料罐", -1, null, null, null),
		list("大型喷火器燃料罐", floor(scale * 1), /obj/item/ammo_magazine/flamer_tank/large, VENDOR_ITEM_REGULAR),
		list("大型喷火器燃料罐 (B) (绿色火焰)", floor(scale * 1), /obj/item/ammo_magazine/flamer_tank/large/B, VENDOR_ITEM_REGULAR),
		list("大型喷火器燃料罐 (X) (蓝色火焰)", floor(scale * 1), /obj/item/ammo_magazine/flamer_tank/large/X, VENDOR_ITEM_REGULAR),
		)

//------------ARMAMENTS VENDOR---------------

/obj/structure/machinery/cm_vending/sorted/cargo_guns/cargo/wo
	req_access = list(ACCESS_MARINE_CARGO)
	vend_dir = NORTH
	vend_dir_whitelist = list(EAST, WEST)

//---- ATTACHIES
/obj/structure/machinery/cm_vending/sorted/attachments/wo
	req_access = list(ACCESS_MARINE_CARGO)
	vend_dir = NORTH
	vend_dir_whitelist = list(SOUTHWEST, SOUTHEAST)
