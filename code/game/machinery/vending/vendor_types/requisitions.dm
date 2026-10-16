//------------REQ VENDORS AND THEIR SQUAD VARIANTS---------------

//------------ARMAMENTS VENDOR---------------

/obj/structure/machinery/cm_vending/sorted/cargo_guns
	name = "ColMarTech自动军械售货机"
	desc = "连接着大型枪械与爆炸物仓库的自动补给架。军需官和货运技术员可以使用。"
	icon_state = "prep"
	req_access = list(ACCESS_MARINE_CARGO)
	vendor_theme = VENDOR_THEME_USCM
	vend_flags = VEND_CLUTTER_PROTECTION | VEND_LIMITED_INVENTORY | VEND_TO_HAND | VEND_LOAD_AMMO_BOXES

/obj/structure/machinery/cm_vending/sorted/cargo_guns/Initialize()
	. = ..()
	if(z in SSmapping.levels_by_trait(ZTRAIT_GROUND))
		malfunction()

/obj/structure/machinery/cm_vending/sorted/cargo_guns/vend_fail()
	return

/obj/structure/machinery/cm_vending/sorted/cargo_guns/ui_state(mob/user)
	return GLOB.not_incapacitated_and_adjacent_state

/obj/structure/machinery/cm_vending/sorted/cargo_guns/populate_product_list(scale)
	listed_products = list(
		list("主武器枪械", -1, null, null),
		list("M37A2 泵动霰弹枪", floor(scale * 30), /obj/item/weapon/gun/shotgun/pump, VENDOR_ITEM_REGULAR),
		list("M39 冲锋枪", floor(scale * 60), /obj/item/weapon/gun/smg/m39, VENDOR_ITEM_REGULAR),
		list("M41A 脉冲步枪 MK2", floor(scale * 60), /obj/item/weapon/gun/rifle/m41a, VENDOR_ITEM_REGULAR),
		list("M49A 战斗步枪", floor(scale * 20), /obj/item/weapon/gun/rifle/m49a, VENDOR_ITEM_REGULAR),

		list("副武器", -1, null, null),
		list("VP70 战斗手枪", floor(scale * 50), /obj/item/weapon/gun/pistol/vp70, VENDOR_ITEM_REGULAR),
		list("M44 战斗左轮手枪", floor(scale * 50), /obj/item/weapon/gun/revolver/m44, VENDOR_ITEM_REGULAR),
		list("M4A3 制式手枪", floor(scale * 50), /obj/item/weapon/gun/pistol/m4a3, VENDOR_ITEM_REGULAR),
		list("M82F 信号枪", floor(scale * 20), /obj/item/weapon/gun/flare, VENDOR_ITEM_REGULAR),

		list("限配枪械", -1, null, null),
		list("VP78 手枪", floor(scale * 4), /obj/item/storage/box/guncase/vp78, VENDOR_ITEM_REGULAR),
		list("SU-6 智能手枪", floor(scale * 3), /obj/item/storage/box/guncase/smartpistol, VENDOR_ITEM_REGULAR),
		list("MOU-53 霰弹枪", floor(scale * 2), /obj/item/storage/box/guncase/mou53, VENDOR_ITEM_REGULAR),
		list("XM88 重型步枪", floor(scale * 3), /obj/item/storage/box/guncase/xm88, VENDOR_ITEM_REGULAR),
		list("M41AE2 重型脉冲步枪", 2.5, /obj/item/storage/box/guncase/lmg, VENDOR_ITEM_REGULAR),
		list("M41A 脉冲步枪 MK1", floor(scale * 3), /obj/item/storage/box/guncase/m41aMK1, VENDOR_ITEM_REGULAR),
		list("M56D 重机枪", floor(scale * 2), /obj/item/storage/box/guncase/m56d, VENDOR_ITEM_REGULAR),
		list("M2C 重机枪", floor(scale * 2), /obj/item/storage/box/guncase/m2c, VENDOR_ITEM_REGULAR),
		list("M240 火焰喷射器", floor(scale * 2), /obj/item/storage/box/guncase/flamer, VENDOR_ITEM_REGULAR),
		list("M79 榴弹发射器", floor(scale * 3), /obj/item/storage/box/guncase/m79, VENDOR_ITEM_REGULAR),
		list("XM51 破障霰弹枪", floor(scale * 3), /obj/item/storage/box/guncase/xm51, VENDOR_ITEM_REGULAR),

		list("爆炸物", -1, null, null),
		list("M15 破片手榴弹", floor(scale * 2), /obj/item/explosive/grenade/high_explosive/m15, VENDOR_ITEM_REGULAR),
		list("M20A2 阔剑反步兵地雷", floor(scale * 4), /obj/item/explosive/mine/strong, VENDOR_ITEM_REGULAR),
		list("M40 HEDP 手榴弹", floor(scale * 25), /obj/item/explosive/grenade/high_explosive, VENDOR_ITEM_REGULAR),
		list("M40 HIDP 燃烧手榴弹", floor(scale * 4), /obj/item/explosive/grenade/incendiary, VENDOR_ITEM_REGULAR),
		list("M40 CCDP 化合物烟幕手榴弹", floor(scale * 4), /obj/item/explosive/grenade/phosphorus, VENDOR_ITEM_REGULAR),
		list("M40 HSDP 烟幕手榴弹", floor(scale * 5), /obj/item/explosive/grenade/smokebomb, VENDOR_ITEM_REGULAR),
		list("M74 AGM-Frag 空爆榴弹", floor(scale * 4), /obj/item/explosive/grenade/high_explosive/airburst, VENDOR_ITEM_REGULAR),
		list("M74 AGM-燃烧弹空爆榴弹", floor(scale * 4), /obj/item/explosive/grenade/incendiary/airburst, VENDOR_ITEM_REGULAR),
		list("M74 AGM-烟幕空爆榴弹", floor(scale * 4), /obj/item/explosive/grenade/smokebomb/airburst, VENDOR_ITEM_REGULAR),
		list("M74 AGM-照明弹", floor(scale * 2), /obj/item/explosive/grenade/high_explosive/airburst/starshell, VENDOR_ITEM_REGULAR),
		list("M74 AGM-蜂群弹", floor(scale * 4), /obj/item/explosive/grenade/high_explosive/airburst/hornet_shell, VENDOR_ITEM_REGULAR),
		list("G2 电击手榴弹", round(scale * 5), /obj/item/explosive/grenade/sebb, VENDOR_ITEM_REGULAR),
		list("M40 HIRR 警棍弹", floor(scale * 8), /obj/item/explosive/grenade/slug/baton, VENDOR_ITEM_REGULAR),
		list("M40 MFHS 金属泡沫手榴弹", floor(scale * 6), /obj/item/explosive/grenade/metal_foam, VENDOR_ITEM_REGULAR),
		list("塑性炸药", floor(scale * 3), /obj/item/explosive/plastic, VENDOR_ITEM_REGULAR),
		list("破障炸药", floor(scale * 2), /obj/item/explosive/plastic/breaching_charge, VENDOR_ITEM_REGULAR),

		list("携行带", -1, null, null),
		list("挂袋", floor(scale * 5), /obj/item/clothing/accessory/storage/droppouch, VENDOR_ITEM_REGULAR),
		list("外挂携行带", floor(scale * 5), /obj/item/clothing/suit/storage/webbing, VENDOR_ITEM_REGULAR),

		list("背包", -1, null, null),
		list("轻型 IMP 背包", floor(scale * 15), /obj/item/storage/backpack/marine, VENDOR_ITEM_REGULAR),
		list("霰弹枪鞘", floor(scale * 10), /obj/item/storage/large_holster/m37, VENDOR_ITEM_REGULAR),
		list("火焰兵 G4-1 燃料罐", floor(scale * 2), /obj/item/storage/backpack/marine/engineerpack/flamethrower/kit, VENDOR_ITEM_REGULAR),
		list("技术员焊接背包", floor(scale * 2), /obj/item/storage/backpack/marine/engineerpack, VENDOR_ITEM_REGULAR),
		list("迫击炮弹背包", floor(scale * 1), /obj/item/storage/backpack/marine/mortarpack, VENDOR_ITEM_REGULAR),
		list("技术员焊接挎包", floor(scale * 5), /obj/item/storage/backpack/marine/engineerpack/satchel, VENDOR_ITEM_REGULAR),
		list("IMP 弹药架", floor(scale * 2), /obj/item/storage/backpack/marine/ammo_rack, VENDOR_ITEM_REGULAR),
		list("无线电话背包", floor(scale * 2), /obj/item/storage/backpack/marine/satchel/rto, VENDOR_ITEM_REGULAR),
		list("降落伞", floor(scale * 20), /obj/item/parachute, VENDOR_ITEM_REGULAR),

		list("腰带", -1, null, null),
		list("G8-A 通用杂物袋", floor(scale * 2), /obj/item/storage/backpack/general_belt, VENDOR_ITEM_REGULAR),
		list("M276 弹药携行挂具", floor(scale * 15), /obj/item/storage/belt/marine, VENDOR_ITEM_REGULAR),
		list("M276 通用手枪枪套挂具", floor(scale * 10), /obj/item/storage/belt/gun/m4a3, VENDOR_ITEM_REGULAR),
		list("M276 刀具携行挂具", floor(scale * 5), /obj/item/storage/belt/knifepouch, VENDOR_ITEM_REGULAR),
		list("M276 M39 枪套挂具", floor(scale * 5), /obj/item/storage/belt/gun/m39, VENDOR_ITEM_REGULAR),
		list("M276 M40 手榴弹携行挂具", floor(scale * 2), /obj/item/storage/belt/grenade, VENDOR_ITEM_REGULAR),
		list("M276 通用左轮手枪枪套挂具", floor(scale * 5), /obj/item/storage/belt/gun/m44, VENDOR_ITEM_REGULAR),
		list("M276 M82F 枪套挂具", floor(scale * 2), /obj/item/storage/belt/gun/flaregun, VENDOR_ITEM_REGULAR),
		list("M276 霰弹装填挂具", floor(scale * 10), /obj/item/storage/belt/shotgun, VENDOR_ITEM_REGULAR),
		list("M276 迫击炮手腰带", floor(scale * 2), /obj/item/storage/belt/gun/mortarbelt, VENDOR_ITEM_REGULAR),

		list("收纳袋", -1, null, null),
		list("自动注射器收纳袋", floor(scale * 1), /obj/item/storage/pouch/autoinjector, VENDOR_ITEM_REGULAR),
		list("医疗套件袋", floor(scale * 2), /obj/item/storage/pouch/medkit, VENDOR_ITEM_REGULAR),
		list("急救袋 (满装)", floor(scale * 5), /obj/item/storage/pouch/firstaid/full, VENDOR_ITEM_REGULAR),
		list("急救响应袋", floor(scale * 2), /obj/item/storage/pouch/first_responder, VENDOR_ITEM_REGULAR),
		list("注射器收纳袋", floor(scale * 2), /obj/item/storage/pouch/syringe, VENDOR_ITEM_REGULAR),
		list("工具袋 (满装)", floor(scale * 2), /obj/item/storage/pouch/tools/full, VENDOR_ITEM_REGULAR),
		list("建材袋", floor(scale * 2), /obj/item/storage/pouch/construction, VENDOR_ITEM_REGULAR),
		list("电子器材袋", floor(scale * 2), /obj/item/storage/pouch/electronics, VENDOR_ITEM_REGULAR),
		list("爆炸物袋", floor(scale * 2), /obj/item/storage/pouch/explosive, VENDOR_ITEM_REGULAR),
		list("照明弹袋 (满装)", floor(scale * 5), /obj/item/storage/pouch/flare/full, VENDOR_ITEM_REGULAR),
		list("枪带袋", floor(scale * 2), /obj/item/storage/pouch/sling, VENDOR_ITEM_REGULAR),
		list("砍刀袋 (满装)", 1, /obj/item/storage/pouch/machete/full, VENDOR_ITEM_REGULAR),
		list("刺刀袋", floor(scale * 2), /obj/item/storage/pouch/bayonet, VENDOR_ITEM_REGULAR),
		list("中型杂物袋", floor(scale * 2), /obj/item/storage/pouch/general/medium, VENDOR_ITEM_REGULAR),
		list("弹匣袋", floor(scale * 5), /obj/item/storage/pouch/magazine, VENDOR_ITEM_REGULAR),
		list("霰弹袋", floor(scale * 5), /obj/item/storage/pouch/shotgun, VENDOR_ITEM_REGULAR),
		list("副武器袋", floor(scale * 5), /obj/item/storage/pouch/pistol, VENDOR_ITEM_REGULAR),
		list("大型手枪弹匣袋", floor(scale * 5), /obj/item/storage/pouch/magazine/pistol/large, VENDOR_ITEM_REGULAR),
		list("燃料罐绑带袋", floor(scale * 4), /obj/item/storage/pouch/flamertank, VENDOR_ITEM_REGULAR),
		list("大型杂物袋", floor(scale * 1), /obj/item/storage/pouch/general/large, VENDOR_ITEM_REGULAR),
		list("大型弹匣袋", floor(scale * 1), /obj/item/storage/pouch/magazine/large, VENDOR_ITEM_REGULAR),
		list("大型霰弹袋", floor(scale * 1), /obj/item/storage/pouch/shotgun/large, VENDOR_ITEM_REGULAR),

		list("杂项", -1, null, null),
		list("战斗手电筒", floor(scale * 8), /obj/item/device/flashlight/combat, VENDOR_ITEM_REGULAR),
		list("工兵铲", floor(scale * 4), /obj/item/tool/shovel/etool/folded, VENDOR_ITEM_REGULAR),
		list("防毒面具", floor(scale * 10), /obj/item/clothing/mask/gas, VENDOR_ITEM_REGULAR),
		list("M89-S 信号照明弹包", floor(scale * 2), /obj/item/storage/box/flare/signal, VENDOR_ITEM_REGULAR),
		list("M94 标记照明弹包", floor(scale * 10), /obj/item/storage/box/flare, VENDOR_ITEM_REGULAR),
		list("砍刀鞘 (满装)", floor(scale * 6), /obj/item/storage/large_holster/machete/full, VENDOR_ITEM_REGULAR),
		list("MB-6 折叠路障 (x3)", floor(scale * 3), /obj/item/stack/folding_barricade/three, VENDOR_ITEM_REGULAR),
		list("运动探测器", floor(scale * 4), /obj/item/device/motiondetector, VENDOR_ITEM_REGULAR),
		list("情报探测器", floor(scale * 4), /obj/item/device/motiondetector/intel, VENDOR_ITEM_REGULAR),
		list("双筒望远镜", floor(scale * 2), /obj/item/device/binoculars, VENDOR_ITEM_REGULAR),
		list("测距仪", floor(scale * 1), /obj/item/device/binoculars/range, VENDOR_ITEM_REGULAR),
		list("激光目标指示器", floor(scale * 1), /obj/item/device/binoculars/range/designator, VENDOR_ITEM_REGULAR),
		list("焊接护目镜", floor(scale * 3), /obj/item/clothing/glasses/welding, VENDOR_ITEM_REGULAR),
		list("灭火器 (便携式)", floor(scale * 3), /obj/item/tool/extinguisher/mini, VENDOR_ITEM_REGULAR),
		list("高容量电池", floor(scale * 1), /obj/item/cell/high, VENDOR_ITEM_REGULAR),
		list("富尔顿回收装置组", floor(scale * 1), /obj/item/stack/fulton, VENDOR_ITEM_REGULAR),
		list("哨戒机枪网络笔记本电脑", 4, /obj/item/device/sentry_computer, VENDOR_ITEM_REGULAR),
		list("JTAC 技能指导手册", floor(scale * 1), /obj/item/pamphlet/skill/jtac, VENDOR_ITEM_REGULAR),
		list("工程技能指导手册", floor(scale * 1), /obj/item/pamphlet/skill/engineer, VENDOR_ITEM_REGULAR),
		list("动力装载机操作认证", 0.75, /obj/item/pamphlet/skill/powerloader, VENDOR_ITEM_REGULAR),
		list("备用 PDT/L 战斗搭档套件", floor(scale * 4), /obj/item/storage/box/pdt_kit, VENDOR_ITEM_REGULAR),
		list("W-Y 牌可充电微型电池", floor(scale * 3), /obj/item/cell/crap, VENDOR_ITEM_REGULAR),
		list("射钉枪弹匣 (7x45mm)", floor(scale * 4), /obj/item/ammo_magazine/smg/nailgun, VENDOR_ITEM_REGULAR),

		list("爆炸物箱", -1, null, null),
		list("M15 破片手榴弹包", 0, /obj/item/storage/box/packet/m15, VENDOR_ITEM_REGULAR),
		list("M40 HEDP 手榴弹包", 0, /obj/item/storage/box/packet/high_explosive, VENDOR_ITEM_REGULAR),
		list("M40 HEDP 手榴弹箱", 0, /obj/item/ammo_box/magazine/nade_box, VENDOR_ITEM_REGULAR),
		list("M77 HIAM 手榴弹包", 0, /obj/item/storage/box/packet/incendiary, VENDOR_ITEM_REGULAR),
		list("M77 HIAM 手榴弹箱", 0, /obj/item/ammo_box/magazine/nade_box/incen, VENDOR_ITEM_REGULAR),
		list("M60 WPSI 手榴弹包", 0, /obj/item/storage/box/packet/phosphorus, VENDOR_ITEM_REGULAR),
		list("M60 WPSI 手榴弹箱", 0, /obj/item/ammo_box/magazine/nade_box/phophorus, VENDOR_ITEM_REGULAR),
		list("M47 HSDP 手榴弹包", 0, /obj/item/storage/box/packet/smoke, VENDOR_ITEM_REGULAR),
		list("M230 LLRB 手榴弹包", 0, /obj/item/storage/box/packet/baton, VENDOR_ITEM_REGULAR),
		list("M74 AGM-F 手榴弹箱", 0, /obj/item/ammo_box/magazine/nade_box/fourtymil/airburst, VENDOR_ITEM_REGULAR),
		list("M74 AGM-I 手榴弹箱", 0, /obj/item/ammo_box/magazine/nade_box/fourtymil/airburst/incen, VENDOR_ITEM_REGULAR),
		list("M74 AGM-S 烟幕手榴弹箱", 0, /obj/item/ammo_box/magazine/nade_box/fourtymil/airburst/smoke, VENDOR_ITEM_REGULAR),
		list("M74 AGM-S 照明弹包", 0, /obj/item/storage/box/packet/flare, VENDOR_ITEM_REGULAR),
		list("G2 电击手榴弹包", 0, /obj/item/storage/box/packet/sebb, VENDOR_ITEM_REGULAR),
		list("M20 地雷盒", 0, /obj/item/storage/box/explosive_mines, VENDOR_ITEM_REGULAR),

		list("其他箱装物资", -1, null, null),
		list("整箱战斗手电筒", 0, /obj/item/ammo_box/magazine/misc/flashlight/combat, VENDOR_ITEM_REGULAR),
		list("整箱 M94 标记照明弹包", 0, /obj/item/ammo_box/magazine/misc/flares, VENDOR_ITEM_REGULAR),
		list("整箱 M89 信号照明弹包", 0, /obj/item/ammo_box/magazine/misc/flares/signal, VENDOR_ITEM_REGULAR),
		list("整箱高容量电池", 0, /obj/item/ammo_box/magazine/misc/power_cell, VENDOR_ITEM_REGULAR),
		list("射钉枪弹匣箱 (7x45mm)", floor(scale * 2), /obj/item/ammo_box/magazine/nailgun, VENDOR_ITEM_REGULAR)
		)

/obj/structure/machinery/cm_vending/sorted/cargo_guns/stock(obj/item/item_to_stock, mob/user)
	if(istype(item_to_stock, /obj/item/storage) && !istype(item_to_stock, /obj/item/storage/box/flare) && !istype(item_to_stock, /obj/item/storage/large_holster/machete))
		to_chat(user, SPAN_WARNING("无法回存[item_to_stock]。"))
		return

	//this below is in case we have subtype of an object, that SHOULD be treated as parent object (like /empty ammo box)
	var/corrected_path = return_corresponding_type(item_to_stock.type)

	var/list/R
	for(R in (listed_products))
		if(item_to_stock.type == R[3] || corrected_path && corrected_path == R[3])
			if(!check_if_item_is_good_to_restock(item_to_stock, user))
				return

			if(item_to_stock.loc == user) //Inside the mob's inventory
				if(item_to_stock.flags_item & WIELDED)
					item_to_stock.unwield(user)
				user.temp_drop_inv_item(item_to_stock)

			if(isstorage(item_to_stock.loc)) //inside a storage item
				var/obj/item/storage/S = item_to_stock.loc
				S.remove_from_storage(item_to_stock, user.loc)

			qdel(item_to_stock)
			user.visible_message(SPAN_NOTICE("[user]向[src]补充了[R[1]]。"),
			SPAN_NOTICE("你向[src]补充了[R[1]]。"))
			R[2]++
			if(vend_flags & VEND_LOAD_AMMO_BOXES)
				update_derived_ammo_and_boxes_on_add(R)
			updateUsrDialog()
			return //We found our item, no reason to go on.

//Special cargo-specific vendor with vending offsets
/obj/structure/machinery/cm_vending/sorted/cargo_guns/cargo
	vend_flags = VEND_CLUTTER_PROTECTION | VEND_LIMITED_INVENTORY | VEND_LOAD_AMMO_BOXES | VEND_STOCK_DYNAMIC //We want to vend to turf not hand, since we are in requisitions
	vend_dir = WEST
	vend_dir_whitelist = list(NORTH, SOUTH)

/obj/structure/machinery/cm_vending/sorted/cargo_guns/cargo/blend
	icon_state = "req_guns_wall"
	vend_delay = 3
	vend_sound = 'sound/machines/vending_drop.ogg'
	tiles_with = list(
		/obj/structure/window/framed/almayer,
		/obj/structure/machinery/door/airlock,
		/turf/closed/wall/almayer,
	)

//------------AMMUNITION VENDOR---------------

/obj/structure/machinery/cm_vending/sorted/cargo_ammo
	name = "ColMarTech自动弹药售货机"
	desc = "连接着大型弹药仓库的自动补给架。军需官和货运技术员可以使用。"
	icon_state = "req_ammo"
	req_access = list(ACCESS_MARINE_CARGO)
	vendor_theme = VENDOR_THEME_USCM
	vend_flags = VEND_CLUTTER_PROTECTION | VEND_LIMITED_INVENTORY | VEND_TO_HAND | VEND_LOAD_AMMO_BOXES | VEND_STOCK_DYNAMIC
	vend_dir = WEST
	vend_dir_whitelist = list(SOUTHWEST, NORTHWEST)

/obj/structure/machinery/cm_vending/sorted/cargo_ammo/Initialize()
	. = ..()
	if(z in SSmapping.levels_by_trait(ZTRAIT_GROUND))
		malfunction()

/obj/structure/machinery/cm_vending/sorted/cargo_ammo/vend_fail()
	return

/obj/structure/machinery/cm_vending/sorted/cargo_ammo/ui_state(mob/user)
	return GLOB.not_incapacitated_and_adjacent_state

/obj/structure/machinery/cm_vending/sorted/cargo_ammo/populate_product_list(scale)
	listed_products = list(
		list("普通弹药", -1, null, null),
		list("整箱鹿弹", floor(scale * 56), /obj/item/ammo_magazine/shotgun/buckshot, VENDOR_ITEM_REGULAR),
		list("整箱箭形弹", floor(scale * 56), /obj/item/ammo_magazine/shotgun/flechette, VENDOR_ITEM_REGULAR),
		list("整箱霰弹枪独头弹", floor(scale * 56), /obj/item/ammo_magazine/shotgun/slugs, VENDOR_ITEM_REGULAR),
		list("M49A 弹匣 (10x24mm)", floor(scale * 60), /obj/item/ammo_magazine/rifle/m49a, VENDOR_ITEM_REGULAR),
		list("M41A MK2 弹匣 (10x24mm)", floor(scale * 100), /obj/item/ammo_magazine/rifle, VENDOR_ITEM_REGULAR),
		list("M39 高速弹匣 (10x20mm)", floor(scale * 100), /obj/item/ammo_magazine/smg/m39, VENDOR_ITEM_REGULAR),
		list("M44 快速装弹器 (.44)", floor(scale * 80), /obj/item/ammo_magazine/revolver, VENDOR_ITEM_REGULAR),
		list("M4A3 弹匣 (9mm)", floor(scale * 100), /obj/item/ammo_magazine/pistol, VENDOR_ITEM_REGULAR),
		list("VP70 弹匣 (9mm)", floor(scale * 50), /obj/item/ammo_magazine/pistol/vp70, VENDOR_ITEM_REGULAR),

		list("穿甲弹药", -1, null, null),
		list("M49A 穿甲弹匣 (10x24mm)", floor(scale * 16), /obj/item/ammo_magazine/rifle/m49a/ap, VENDOR_ITEM_REGULAR),
		list("M39 穿甲弹匣 (10x20mm)", floor(scale * 12), /obj/item/ammo_magazine/smg/m39/ap, VENDOR_ITEM_REGULAR),
		list("M41A MK2 穿甲弹匣 (10x24mm)", floor(scale * 10), /obj/item/ammo_magazine/rifle/ap, VENDOR_ITEM_REGULAR),
		list("M4A3 穿甲弹匣 (9mm)", floor(scale * 2), /obj/item/ammo_magazine/pistol/ap, VENDOR_ITEM_REGULAR),

		list("扩容弹药", -1, null, null),
		list("M39 扩容弹匣 (10x20mm)", floor(scale * 10), /obj/item/ammo_magazine/smg/m39/extended, VENDOR_ITEM_REGULAR),
		list("M41A MK2 扩容弹匣 (10x24mm)", floor(scale * 8), /obj/item/ammo_magazine/rifle/extended, VENDOR_ITEM_REGULAR),

		list("特殊弹药", -1, null, null),
		list("M56 DV9 电池", 4, /obj/item/smartgun_battery, VENDOR_ITEM_REGULAR),
		list("M56 智能机枪弹鼓", 4, /obj/item/ammo_magazine/smartgun, VENDOR_ITEM_REGULAR),
		list("M44 重型快速装弹器 (.44)", round(scale * 10.5), /obj/item/ammo_magazine/revolver/heavy, VENDOR_ITEM_REGULAR),
		list("M44 精确射手快速装弹器 (.44)", round(scale * 5.7), /obj/item/ammo_magazine/revolver/marksman, VENDOR_ITEM_REGULAR),
		list("M4A3 空尖弹匣 (9mm)", round(scale * 2), /obj/item/ammo_magazine/pistol/hp, VENDOR_ITEM_REGULAR),
		list("M41AE2 全息标记弹 (10x24mm)", round(scale * 2), /obj/item/ammo_magazine/hpr_box/holo_target, VENDOR_ITEM_REGULAR),

		list("限配枪械弹药", -1, null, null),
		list("VP78 弹匣", round(scale * 11.2), /obj/item/ammo_magazine/pistol/vp78, VENDOR_ITEM_REGULAR),
		list("SU-6 智能手枪弹匣 (.45)", round(scale * 12,8), /obj/item/ammo_magazine/pistol/smart, VENDOR_ITEM_REGULAR),
		list("M240 喷火器燃料罐", round(scale * 3), /obj/item/ammo_magazine/flamer_tank, VENDOR_ITEM_REGULAR),
		list("M41AE2 弹箱 (10x24mm)", round(scale * 3), /obj/item/ammo_magazine/hpr_box, VENDOR_ITEM_REGULAR),
		list("M41A MK1 弹匣 (10x24mm)", round(scale * 4.5), /obj/item/ammo_magazine/rifle/m41aMK1, VENDOR_ITEM_REGULAR),
		list("M41A MK1 穿甲弹匣 (10x24mm)", round(scale * 2), /obj/item/ammo_magazine/rifle/m41aMK1/ap, VENDOR_ITEM_REGULAR),
		list("M56D 弹鼓", round(scale * 2), /obj/item/ammo_magazine/m56d, VENDOR_ITEM_REGULAR),
		list("M2C 弹箱", round(scale * 2), /obj/item/ammo_magazine/m2c, VENDOR_ITEM_REGULAR),

		list("霰弹枪弹药箱", -1, null, null),
		list("霰弹枪弹药箱 (鹿弹 x 100)", round(scale * 2), /obj/item/ammo_box/magazine/shotgun/buckshot, VENDOR_ITEM_REGULAR),
		list("霰弹枪弹药箱 (箭形弹 x 100)", round(scale * 2), /obj/item/ammo_box/magazine/shotgun/flechette, VENDOR_ITEM_REGULAR),
		list("霰弹枪弹药箱 (独头弹 x 100)", round(scale * 2), /obj/item/ammo_box/magazine/shotgun, VENDOR_ITEM_REGULAR),
		)

/obj/structure/machinery/cm_vending/sorted/cargo_ammo/stock(obj/item/item_to_stock, mob/user)
	//these are exempted because checks would be huge and not worth it
	if(istype(item_to_stock, /obj/item/storage))
		to_chat(user, SPAN_WARNING("无法回存[item_to_stock]。"))
		return
	var/list/R

	//this below is in case we have subtype of an object, that SHOULD be treated as parent object (like /empty ammo box)
	var/corrected_path = return_corresponding_type(item_to_stock.type)

	for(R in (listed_products))
		if(item_to_stock.type == R[3] || corrected_path && corrected_path == R[3])
			if(!check_if_item_is_good_to_restock(item_to_stock, user))
				return

			if(item_to_stock.loc == user) //Inside the mob's inventory
				if(item_to_stock.flags_item & WIELDED)
					item_to_stock.unwield(user)
				user.temp_drop_inv_item(item_to_stock)

			if(isstorage(item_to_stock.loc)) //inside a storage item
				var/obj/item/storage/S = item_to_stock.loc
				S.remove_from_storage(item_to_stock, user.loc)

			qdel(item_to_stock)
			user.visible_message(SPAN_NOTICE("[user]向[src]补充了[R[1]]。"),
			SPAN_NOTICE("你向[src]补充了[R[1]]。"))
			R[2]++
			if(vend_flags & VEND_LOAD_AMMO_BOXES)
				update_derived_ammo_and_boxes_on_add(R)
			updateUsrDialog()
			return //We found our item, no reason to go on.

/obj/structure/machinery/cm_vending/sorted/cargo_ammo/cargo/blend
	icon_state = "req_ammo_wall"
	vend_delay = 3
	vend_sound = 'sound/machines/vending_drop.ogg'
	tiles_with = list(
		/obj/structure/window/framed/almayer,
		/obj/structure/machinery/door/airlock,
		/turf/closed/wall/almayer,
	)

//Special cargo-specific vendor with vending offsets
/obj/structure/machinery/cm_vending/sorted/cargo_ammo/cargo
	vend_flags = VEND_CLUTTER_PROTECTION | VEND_LIMITED_INVENTORY | VEND_LOAD_AMMO_BOXES | VEND_STOCK_DYNAMIC //We want to vend to turf not hand, since we are in requisitions

//------------ATTACHMENTS VENDOR---------------

/obj/structure/machinery/cm_vending/sorted/attachments
	name = "阿玛特系统配件售货机"
	desc = "连接着大型武器配件仓库的自动补给架。军需官和货运技术员可以使用。"
	req_access = list(ACCESS_MARINE_CARGO)
	vendor_theme = VENDOR_THEME_USCM
	icon_state = "req_attach"
	vend_dir = WEST
	vend_dir_whitelist = list(SOUTHEAST, NORTHEAST)
	vend_flags = VEND_CLUTTER_PROTECTION | VEND_LIMITED_INVENTORY //We want to vend to turf not hand, since we are in requisitions

/obj/structure/machinery/cm_vending/sorted/attachments/Initialize()
	. = ..()
	if(z in SSmapping.levels_by_trait(ZTRAIT_GROUND))
		malfunction()

/obj/structure/machinery/cm_vending/sorted/attachments/vend_fail()
	return

/obj/structure/machinery/cm_vending/sorted/attachments/ui_state(mob/user)
	return GLOB.not_incapacitated_and_adjacent_state

/obj/structure/machinery/cm_vending/sorted/attachments/populate_product_list(scale)
	listed_products = list(
		list("枪管", -1, null, null),
		list("加长枪管", 6.5, /obj/item/attachable/extended_barrel, VENDOR_ITEM_REGULAR),
		list("M5 刺刀", 10.5, /obj/item/attachable/bayonet, VENDOR_ITEM_REGULAR),
		list("后坐补偿器", 6.5, /obj/item/attachable/compensator, VENDOR_ITEM_REGULAR),
		list("消音器", 6.5, /obj/item/attachable/suppressor, VENDOR_ITEM_REGULAR),

		list("导轨", -1, null, null),
		list("B8 智能瞄准镜", 3.5, /obj/item/attachable/scope/mini_iff, VENDOR_ITEM_REGULAR),
		list("磁力枪背带", 8.5, /obj/item/attachable/magnetic_harness, VENDOR_ITEM_REGULAR),
		list("导轨手电筒", 10.5, /obj/item/attachable/flashlight, VENDOR_ITEM_REGULAR),
		list("S4 2x 小型望远瞄准镜", 4.5, /obj/item/attachable/scope/mini, VENDOR_ITEM_REGULAR),
		list("S5 红点瞄准镜", 9.5, /obj/item/attachable/reddot, VENDOR_ITEM_REGULAR),
		list("S6 反射式瞄准镜", 9.5, /obj/item/attachable/reflex, VENDOR_ITEM_REGULAR),
		list("S8 4x 望远瞄准镜", 4.5, /obj/item/attachable/scope, VENDOR_ITEM_REGULAR),

		list("下挂", -1, null, null),
		list("倾斜握把", 6.5, /obj/item/attachable/angledgrip, VENDOR_ITEM_REGULAR),
		list("两脚架", 6.5, /obj/item/attachable/bipod, VENDOR_ITEM_REGULAR),
		list("点射组件", 4.5, /obj/item/attachable/burstfire_assembly, VENDOR_ITEM_REGULAR),
		list("陀螺稳定器", 4.5, /obj/item/attachable/gyro, VENDOR_ITEM_REGULAR),
		list("激光瞄准器", 9.5, /obj/item/attachable/lasersight, VENDOR_ITEM_REGULAR),
		list("微型喷火器", 4.5, /obj/item/attachable/attached_gun/flamer, VENDOR_ITEM_REGULAR),
		list("XM-VESG-1 喷火器喷嘴", 4.5, /obj/item/attachable/attached_gun/flamer_nozzle, VENDOR_ITEM_REGULAR),
		list("U7 下挂霰弹枪", 4.5, /obj/item/attachable/attached_gun/shotgun, VENDOR_ITEM_REGULAR),
		list("下挂灭火器", 4.5, /obj/item/attachable/attached_gun/extinguisher, VENDOR_ITEM_REGULAR),
		list("下挂手电握把", 9.5, /obj/item/attachable/flashlight/grip, VENDOR_ITEM_REGULAR),
		list("下挂式榴弹发射器", 9.5, /obj/item/attachable/attached_gun/grenade, VENDOR_ITEM_REGULAR),
		list("垂直握把", 9.5, /obj/item/attachable/verticalgrip, VENDOR_ITEM_REGULAR),

		list("枪托", -1, null, null),
		list("M37 木制枪托", 4.5, /obj/item/attachable/stock/shotgun, VENDOR_ITEM_REGULAR),
		list("M39 臂托", 4.5, /obj/item/attachable/stock/smg/collapsible/brace, VENDOR_ITEM_REGULAR),
		list("M39 折叠枪托", 4.5, /obj/item/attachable/stock/smg/collapsible, VENDOR_ITEM_REGULAR),
		list("M39 枪托", 4.5, /obj/item/attachable/stock/smg, VENDOR_ITEM_REGULAR),
		list("M41A 固定枪托", 4.5, /obj/item/attachable/stock/rifle, VENDOR_ITEM_REGULAR),
		list("M41A 折叠枪托", 4.5, /obj/item/attachable/stock/rifle/collapsible, VENDOR_ITEM_REGULAR),
		list("M44 马格南精确射击枪托", 4.5, /obj/item/attachable/stock/revolver, VENDOR_ITEM_REGULAR)
		)

/obj/structure/machinery/cm_vending/sorted/attachments/blend
	icon_state = "req_attach_wall"
	vend_delay = 3
	vend_sound = 'sound/machines/vending_drop.ogg'
	tiles_with = list(
		/obj/structure/window/framed/almayer,
		/obj/structure/machinery/door/airlock,
		/turf/closed/wall/almayer,
	)

//------------UNIFORM VENDOR---------------

/obj/structure/machinery/cm_vending/sorted/uniform_supply
	name = "ColMarTech备用制服售货机"
	desc = "连接着大型陆战队制式制服仓库的自动补给架。军需官和货运技术员可以使用。"
	icon_state = "clothing"
	req_access = list()
	req_one_access = list(ACCESS_MARINE_CARGO)
	vendor_theme = VENDOR_THEME_USCM

	listed_products = list(
		list("制服", -1, null, null),
		list("USCM 制服", 20, /obj/item/clothing/under/marine, VENDOR_ITEM_REGULAR),
		list("USCM 战斗技术员制服", 5, /obj/item/clothing/under/marine/engineer, VENDOR_ITEM_REGULAR),
		list("USCM 医疗兵制服", 5, /obj/item/clothing/under/marine/medic, VENDOR_ITEM_REGULAR),

		list("靴子", -1, null, null),
		list("陆战队战斗靴", 20, /obj/item/clothing/shoes/marine, VENDOR_ITEM_REGULAR),
		list("陆战队丛林战斗靴", 5, /obj/item/clothing/shoes/marine/jungle, VENDOR_ITEM_REGULAR),

		list("背包", -1, null, null),
		list("轻型 IMP 背包", 20, /obj/item/storage/backpack/marine, VENDOR_ITEM_REGULAR),
		list("USCM 挎包", 20, /obj/item/storage/backpack/marine/satchel, VENDOR_ITEM_REGULAR),
		list("USCM 胸挂", 10, /obj/item/storage/backpack/marine/satchel/chestrig, VENDOR_ITEM_REGULAR),
		list("USCM 技术员背包", 10, /obj/item/storage/backpack/marine/tech, VENDOR_ITEM_REGULAR),
		list("USCM 技术员胸挂", 10, /obj/item/storage/backpack/marine/satchel/tech, VENDOR_ITEM_REGULAR),
		list("USCM 医疗兵背包", 10, /obj/item/storage/backpack/marine/medic, VENDOR_ITEM_REGULAR),
		list("USCM 医疗兵挎包", 10, /obj/item/storage/backpack/marine/satchel/medic, VENDOR_ITEM_REGULAR),


		list("护甲", -1, null, null),
		list("M10 式陆战队头盔", 20, /obj/item/clothing/head/helmet/marine, VENDOR_ITEM_REGULAR),
		list("M10 式技术员头盔", 20, /obj/item/clothing/head/helmet/marine/tech, VENDOR_ITEM_REGULAR),
		list("M10 式医疗兵头盔", 20, /obj/item/clothing/head/helmet/marine/medic, VENDOR_ITEM_REGULAR),
		list("M3 式陆战队护甲", 20, /obj/item/clothing/suit/marine, VENDOR_ITEM_REGULAR),
		list("M3 式棱纹陆战队护甲", 20, /obj/item/clothing/suit/marine/lines, VENDOR_ITEM_REGULAR),
		list("M3-EOD 式重型护甲", 10, /obj/item/clothing/suit/marine/heavy, VENDOR_ITEM_REGULAR),
		list("M3-L 式轻型护甲", 10, /obj/item/clothing/suit/marine/light, VENDOR_ITEM_REGULAR),

		list("手套", -1, null, null),
		list("战斗手套", 40, /obj/item/clothing/gloves/marine, VENDOR_ITEM_REGULAR),
		list("棕色战斗手套", 20, /obj/item/clothing/gloves/marine/brown, VENDOR_ITEM_REGULAR),

		list("无线电", -1, null, null),
		list("阿尔法小队无线电加密密钥", 5, /obj/item/device/encryptionkey/alpha, VENDOR_ITEM_REGULAR),
		list("布拉沃小队无线电加密密钥", 5, /obj/item/device/encryptionkey/bravo, VENDOR_ITEM_REGULAR),
		list("查理小队无线电加密密钥", 5, /obj/item/device/encryptionkey/charlie, VENDOR_ITEM_REGULAR),
		list("德尔塔小队无线电加密密钥", 5, /obj/item/device/encryptionkey/delta, VENDOR_ITEM_REGULAR),
		list("回声小队无线电加密密钥", 5, /obj/item/device/encryptionkey/echo, VENDOR_ITEM_REGULAR),
		list("工程无线电加密密钥", 5, /obj/item/device/encryptionkey/engi, VENDOR_ITEM_REGULAR),
		list("情报无线电加密密钥", 5, /obj/item/device/encryptionkey/intel, VENDOR_ITEM_REGULAR),
		list("JTAC 无线电加密密钥", 5, /obj/item/device/encryptionkey/jtac, VENDOR_ITEM_REGULAR),
		list("医疗无线电加密密钥", 5, /obj/item/device/encryptionkey/med, VENDOR_ITEM_REGULAR),
		list("哨戒机枪网络加密密钥", 8, /obj/item/device/encryptionkey/sentry_laptop, VENDOR_ITEM_REGULAR),
		list("陆战队无线电耳机", 5, /obj/item/device/radio/headset/almayer, VENDOR_ITEM_REGULAR),
		list("补给无线电加密密钥", 5, /obj/item/device/encryptionkey/req, VENDOR_ITEM_REGULAR),

		list("面罩", -1, null, null, null),
		list("防毒面具", 20, /obj/item/clothing/mask/gas, VENDOR_ITEM_REGULAR),
		list("吸热头套", 10, /obj/item/clothing/mask/rebreather/scarf, VENDOR_ITEM_REGULAR),

		list("杂项", -1, null, null),
		list("铺盖卷", 30, /obj/item/roller/bedroll, VENDOR_ITEM_REGULAR),
		)

/obj/structure/machinery/cm_vending/sorted/uniform_supply/ui_state(mob/user)
	return GLOB.not_incapacitated_and_adjacent_strict_state

/obj/structure/machinery/cm_vending/sorted/uniform_supply/populate_product_list(scale)
	return

/obj/structure/machinery/cm_vending/sorted/uniform_supply/vend_fail()
	return

/obj/structure/machinery/cm_vending/sorted/uniform_supply/stock(obj/item/item_to_stock, mob/user)
	var/list/R
	for(R in (listed_products))
		if(item_to_stock.type == R[3] && !istype(item_to_stock,/obj/item/storage))
			//Marine armor handling
			if(istype(item_to_stock, /obj/item/clothing/suit/storage/marine))
				var/obj/item/clothing/suit/storage/marine/AR = item_to_stock
				if(AR.pockets && length(AR.pockets.contents))
					to_chat(user, SPAN_WARNING("[AR]里面还有东西。请先清空再回存。"))
					return
			//Marine helmet handling
			else if(istype(item_to_stock, /obj/item/clothing/head/helmet/marine))
				var/obj/item/clothing/head/helmet/marine/H = item_to_stock
				if(H.pockets && length(H.pockets.contents))
					to_chat(user, SPAN_WARNING("[H]里面还有东西。请先清空再回存。"))
					return

			if(item_to_stock.loc == user) //Inside the mob's inventory
				if(item_to_stock.flags_item & WIELDED)
					item_to_stock.unwield(user)
				user.temp_drop_inv_item(item_to_stock)

			if(isstorage(item_to_stock.loc)) //inside a storage item
				var/obj/item/storage/S = item_to_stock.loc
				S.remove_from_storage(item_to_stock, user.loc)

			qdel(item_to_stock)
			user.visible_message(SPAN_NOTICE("[user]向[src]补充了[R[1]]。"),
			SPAN_NOTICE("你向[src]补充了[R[1]]。"))
			R[2]++
			if(vend_flags & VEND_LOAD_AMMO_BOXES)
				update_derived_ammo_and_boxes_on_add(R)
			updateUsrDialog()
			return //We found our item, no reason to go on.

//------------TRAINING WEAPONS RACK---------------

/obj/structure/machinery/cm_vending/sorted/cargo_guns/squad_prep/training //Nonlethal stuff for events.
	name = "ColMarTech自动训练武器架"
	desc = "连接着大型制式武器与非致命弹药仓库的自动武器架。"

/obj/structure/machinery/cm_vending/sorted/cargo_guns/squad_prep/training/populate_product_list(scale)
	listed_products = list(
		list("主武器枪械", -1, null, null),
		list("M49A 战斗步枪", floor(scale * 10), /obj/item/weapon/gun/rifle/m49a, VENDOR_ITEM_REGULAR),
		list("M37A2 泵动霰弹枪", floor(scale * 15), /obj/item/weapon/gun/shotgun/pump, VENDOR_ITEM_REGULAR),
		list("M39 冲锋枪", floor(scale * 30), /obj/item/weapon/gun/smg/m39, VENDOR_ITEM_REGULAR),
		list("M41A 脉冲步枪 MK2", floor(scale * 30), /obj/item/weapon/gun/rifle/m41a, VENDOR_ITEM_RECOMMENDED),

		list("主武器非致命弹药", -1, null, null),
		list("整箱布袋弹 (12g)", floor(scale * 15), /obj/item/ammo_magazine/shotgun/beanbag, VENDOR_ITEM_REGULAR),
		list("M49A 橡胶弹匣 (10x24mm)", floor(scale * 15), /obj/item/ammo_magazine/rifle/m49a/rubber, VENDOR_ITEM_REGULAR),
		list("M39 橡胶弹匣 (10x20mm)", floor(scale * 25), /obj/item/ammo_magazine/smg/m39/rubber, VENDOR_ITEM_REGULAR),
		list("M41A 橡胶弹匣 (10x24mm)", floor(scale * 25), /obj/item/ammo_magazine/rifle/rubber, VENDOR_ITEM_REGULAR),

		list("副武器", -1, null, null),
		list("VP70 战斗手枪", floor(scale * 25), /obj/item/weapon/gun/pistol/vp70, VENDOR_ITEM_REGULAR),
		list("M4A3 制式手枪", floor(scale * 25), /obj/item/weapon/gun/pistol/m4a3, VENDOR_ITEM_REGULAR),

		list("副武器非致命弹药", -1, null, null),
		list("VP70 橡胶弹匣 (9mm)", floor(scale * 25), /obj/item/ammo_magazine/pistol/vp70/rubber, VENDOR_ITEM_REGULAR),
		list("M4A3 橡胶弹匣 (9mm)", floor(scale * 25), /obj/item/ammo_magazine/pistol/rubber, VENDOR_ITEM_REGULAR),

		list("配件", -1, null, null),
		list("导轨手电筒", floor(scale * 25), /obj/item/attachable/flashlight, VENDOR_ITEM_RECOMMENDED),
		list("下挂手电握把", floor(scale * 10), /obj/item/attachable/flashlight/grip, VENDOR_ITEM_RECOMMENDED),
		list("下挂式榴弹发射器", floor(scale * 25), /obj/item/attachable/attached_gun/grenade, VENDOR_ITEM_REGULAR), //They already get these as on-spawns, might as well formalize some spares.

		list("勤务服", -1, null, null),
		list("M07 训练手榴弹", floor(scale * 15), /obj/item/explosive/grenade/high_explosive/training, VENDOR_ITEM_REGULAR),
		list("M15 橡胶弹丸手榴弹", floor(scale * 10), /obj/item/explosive/grenade/high_explosive/m15/rubber, VENDOR_ITEM_REGULAR),
		list("M5 刺刀", floor(scale * 25), /obj/item/attachable/bayonet, VENDOR_ITEM_REGULAR),
		list("M94 标记照明弹包", floor(scale * 10), /obj/item/storage/box/flare, VENDOR_ITEM_RECOMMENDED)
	)
