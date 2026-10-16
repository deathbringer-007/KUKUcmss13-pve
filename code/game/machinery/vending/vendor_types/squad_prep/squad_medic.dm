//------------GEAR VENDOR---------------

GLOBAL_LIST_INIT(cm_vending_gear_medic, list(
		list("医疗套装 (必选)", 0, null, null, null),
		list("必备医疗套装", 0, /obj/effect/essentials_set/medic, MARINE_CAN_BUY_ESSENTIALS, VENDOR_ITEM_MANDATORY),

		list("战地用品", 0, null, null, null),
		list("烧伤治疗包", 2, /obj/item/stack/medical/advanced/ointment, null, VENDOR_ITEM_RECOMMENDED),
		list("创伤治疗包", 2, /obj/item/stack/medical/advanced/bruise_pack, null, VENDOR_ITEM_RECOMMENDED),
		list("医用夹板", 1, /obj/item/stack/medical/splint, null, VENDOR_ITEM_RECOMMENDED),
		list("医用纱布", 1, /obj/item/stack/medical/bruise_pack, null, VENDOR_ITEM_REGULAR),
		list("烧伤药膏", 1, /obj/item/stack/medical/ointment, null, VENDOR_ITEM_REGULAR),
		list("血袋 (O-)", 4, /obj/item/reagent_container/blood/OMinus, null, VENDOR_ITEM_REGULAR),

		list("急救箱", 0, null, null, null),
		list("高级急救箱", 12, /obj/item/storage/firstaid/softpack/adv, null, VENDOR_ITEM_RECOMMENDED),
		list("急救箱", 5, /obj/item/storage/firstaid/softpack/regular, null, VENDOR_ITEM_REGULAR),
		list("烧伤急救箱", 6, /obj/item/storage/firstaid/softpack/fire, null, VENDOR_ITEM_REGULAR),
		list("解毒急救箱", 6, /obj/item/storage/firstaid/softpack/toxin, null, VENDOR_ITEM_REGULAR),
		list("缺氧急救箱", 6, /obj/item/storage/firstaid/softpack/o2, null, VENDOR_ITEM_REGULAR),
		list("辐射急救箱", 6, /obj/item/storage/firstaid/softpack/rad, null, VENDOR_ITEM_REGULAR),

		list("自动注射器", 0, null, null, null),
		list("自动注射器 (比卡定)", 1, /obj/item/reagent_container/hypospray/autoinjector/bicaridine, null, VENDOR_ITEM_REGULAR),
		list("自动注射器 (强化右氧林)", 1, /obj/item/reagent_container/hypospray/autoinjector/dexalinp, null, VENDOR_ITEM_REGULAR),
		list("自动注射器 (因纳普罗伐林)", 1, /obj/item/reagent_container/hypospray/autoinjector/inaprovaline, null, VENDOR_ITEM_REGULAR),
		list("自动注射器 (克洛坦)", 1, /obj/item/reagent_container/hypospray/autoinjector/kelotane, null, VENDOR_ITEM_REGULAR),
		list("自动注射器 (羟考酮)", 2, /obj/item/reagent_container/hypospray/autoinjector/oxycodone, null, VENDOR_ITEM_REGULAR),
		list("自动注射器 (曲马多)", 1, /obj/item/reagent_container/hypospray/autoinjector/tramadol, null, VENDOR_ITEM_REGULAR),
		list("自动注射器 (广效康复嗪)", 1, /obj/item/reagent_container/hypospray/autoinjector/tricord, null, VENDOR_ITEM_REGULAR),

		list("药瓶", 0, null, null, null),
		list("药瓶 (比卡定)", 5, /obj/item/storage/pill_bottle/bicaridine, null, VENDOR_ITEM_RECOMMENDED),
		list("药瓶 (右氧林)", 5, /obj/item/storage/pill_bottle/dexalin, null, VENDOR_ITEM_REGULAR),
		list("药瓶 (迪洛文)", 5, /obj/item/storage/pill_bottle/antitox, null, VENDOR_ITEM_REGULAR),
		list("药瓶 (因纳普罗伐林)", 5, /obj/item/storage/pill_bottle/inaprovaline, null, VENDOR_ITEM_REGULAR),
		list("药瓶 (克洛坦)", 5, /obj/item/storage/pill_bottle/kelotane, null, VENDOR_ITEM_RECOMMENDED),
		list("药瓶 (佩里达酮)", 5, /obj/item/storage/pill_bottle/peridaxon, null, VENDOR_ITEM_REGULAR),
		list("药瓶 (曲马多)", 5, /obj/item/storage/pill_bottle/tramadol, null, VENDOR_ITEM_RECOMMENDED),

		list("医疗器具", 0, null, null, null),
		list("健康诊断设备", 4, /obj/item/device/healthanalyzer/soul, null, VENDOR_ITEM_REGULAR),
		list("轮式担架床", 4, /obj/item/roller, null, VENDOR_ITEM_REGULAR),
		list("加压药剂罐袋 (空)", 3, /obj/item/storage/pouch/pressurized_reagent_canister, null, VENDOR_ITEM_REGULAR),
		list("G8-A 通用杂物袋", 15, /obj/item/storage/backpack/general_belt, null, VENDOR_ITEM_REGULAR),
		list("MS-11 智能补充罐", 6, /obj/item/reagent_container/glass/minitank, null, VENDOR_ITEM_REGULAR),

		list("爆炸物", 0, null, null, null),
		list("M40 HEDP 高爆包 (x3 手榴弹)", 18, /obj/item/storage/box/packet/high_explosive, null, VENDOR_ITEM_REGULAR),
		list("M40 HIDP 燃烧弹包 (x3 手榴弹)", 18, /obj/item/storage/box/packet/incendiary, null, VENDOR_ITEM_REGULAR),
		list("M40 WPDP 白磷包 (x3 手榴弹)", 18, /obj/item/storage/box/packet/phosphorus, null, VENDOR_ITEM_REGULAR),
		list("M40 HSDP 烟幕包 (x3 手榴弹)", 9, /obj/item/storage/box/packet/smoke, null, VENDOR_ITEM_REGULAR),
		list("M20 地雷盒 (x5 地雷)", 20, /obj/item/storage/box/explosive_mines, null, VENDOR_ITEM_REGULAR),
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

		list("服装", 0, null, null, null),
		list("砍刀鞘 (满装)", 6, /obj/item/storage/large_holster/machete/full, null, VENDOR_ITEM_REGULAR),
		list("砍刀袋 (满装)", 8, /obj/item/storage/pouch/machete/full, null, VENDOR_ITEM_REGULAR),
		list("USCM 无线电话背包", 15, /obj/item/storage/backpack/marine/satchel/rto, null, VENDOR_ITEM_REGULAR),
		list("燃料罐绑带袋", 4, /obj/item/storage/pouch/flamertank, null, VENDOR_ITEM_REGULAR),
		list("焊接护目镜", 3, /obj/item/clothing/glasses/welding, null, VENDOR_ITEM_REGULAR),

		list("勤务服", 0, null, null, null),
		list("灭火器 (便携式)", 3, /obj/item/tool/extinguisher/mini, null, VENDOR_ITEM_REGULAR),
		list("运动探测器", 8, /obj/item/device/motiondetector, null, VENDOR_ITEM_REGULAR),
		list("哨子", 3, /obj/item/device/whistle, null, VENDOR_ITEM_REGULAR),

		list("双筒望远镜", 0, null, null, null),
		list("双筒望远镜", 5, /obj/item/device/binoculars, null, VENDOR_ITEM_REGULAR),
		list("测距仪", 10, /obj/item/device/binoculars/range, null, VENDOR_ITEM_REGULAR),
		list("激光目标指示器", 15, /obj/item/device/binoculars/range/designator, null, VENDOR_ITEM_REGULAR),

		list("头盔光学设备", 0, null, null, null),
		list("焊接面罩", 5, /obj/item/device/helmet_visor/welding_visor, null, VENDOR_ITEM_REGULAR),

		list("技能指导手册", 0, null, null, null),
		list("JTAC 技能指导手册", 15, /obj/item/pamphlet/skill/jtac, null, VENDOR_ITEM_REGULAR),
		list("工程技能指导手册", 15, /obj/item/pamphlet/skill/engineer, null, VENDOR_ITEM_REGULAR),

		list("无线电密钥", 0, null, null, null),
		list("工程无线电加密密钥", 3, /obj/item/device/encryptionkey/engi, null, VENDOR_ITEM_REGULAR),
		list("情报无线电加密密钥", 3, /obj/item/device/encryptionkey/intel, null, VENDOR_ITEM_REGULAR),
		list("JTAC 无线电加密密钥", 3, /obj/item/device/encryptionkey/jtac, null, VENDOR_ITEM_REGULAR),
		list("补给无线电加密密钥", 3, /obj/item/device/encryptionkey/req, null, VENDOR_ITEM_REGULAR),
	))

/obj/structure/machinery/cm_vending/gear/medic
	name = "ColMarTech小队医疗用品架"
	desc = "供医疗兵使用的自动装备架。"
	icon_state = "med_gear"
	show_points = TRUE
	vendor_role = list(JOB_SQUAD_MEDIC)
	req_access = list(ACCESS_MARINE_MEDPREP)

/obj/structure/machinery/cm_vending/gear/medic/get_listed_products(mob/user)
	return GLOB.cm_vending_gear_medic

//------------CLOTHING VENDOR---------------

GLOBAL_LIST_INIT(cm_vending_clothing_medic, list(

		list("护甲涂装 (任选一件)", 0, null, null, null),
		list("红十字涂装", 0, /obj/item/clothing/accessory/paint/medic, MARINE_CAN_BUY_PAINT, VENDOR_ITEM_RECOMMENDED),

		list("头盔 (任选一件)", 0, null, null, null),
		list("M10 头盔 (红十字)", 0, /obj/item/clothing/head/helmet/marine/medic, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_RECOMMENDED),
		list("M10 头盔 (无标记)", 0, /obj/item/clothing/head/helmet/marine/medic/plain, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_RECOMMENDED),

		list("战场监控与抬头显示装备 (任选一件)", 0, null, null, null),
		list("2 型战地医疗瞄准镜", 0, /obj/item/clothing/glasses/night/medhud/no_nvg, MARINE_CAN_BUY_GLASSES, VENDOR_ITEM_REGULAR),

		list("背包 (任选一件)", 0, null, null, null),
		list("医疗背包", 0, /obj/item/storage/backpack/marine/medic, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_REGULAR),
		list("医疗挎包", 0, /obj/item/storage/backpack/marine/satchel/medic, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_RECOMMENDED),

		list("腰带 (任选一件)", 0, null, null, null),
		list("M276 救生医疗包 (满装)", 0, /obj/item/storage/belt/medical/lifesaver/full, MARINE_CAN_BUY_BELT, VENDOR_ITEM_RECOMMENDED),
		list("M276 医疗携行挂具 (满装)", 0, /obj/item/storage/belt/medical/full, MARINE_CAN_BUY_BELT, VENDOR_ITEM_RECOMMENDED),

		list("收纳袋 (任选两件)", 0, null, null, null),
		list("自动注射器收纳袋", 0, /obj/item/storage/pouch/autoinjector, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("医疗套件袋", 0, /obj/item/storage/pouch/medkit, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("加压药剂罐袋 (比卡定)", 0, /obj/item/storage/pouch/pressurized_reagent_canister/bicaridine, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("加压药剂罐袋 (克洛坦)", 0, /obj/item/storage/pouch/pressurized_reagent_canister/kelotane, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("加压药剂罐袋 (广效康复嗪)", 0, /obj/item/storage/pouch/pressurized_reagent_canister/tricordrazine, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("试管袋 (满装)", 0, /obj/item/storage/pouch/vials/full, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),

		list("饰品 (任选一件)", 0, null, null, null),
		list("M3 式携行带", 0, /obj/item/clothing/accessory/storage/webbing/m3, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("M3 式弹匣携行带", 0, /obj/item/clothing/accessory/storage/webbing/m3/mag, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("M3 式霰弹携行带", 0, /obj/item/clothing/accessory/storage/webbing/m3/shotgun, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("M3 式 M40 携行带", 0, /obj/item/clothing/accessory/storage/webbing/m3/m40, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("M3 式小型收纳袋携行带", 0, /obj/item/clothing/accessory/storage/webbing/m3/small, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_RECOMMENDED),
		list("肩部枪套", 0, /obj/item/clothing/accessory/storage/holster, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("挂袋", 0, /obj/item/clothing/accessory/storage/droppouch, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
	))

/obj/structure/machinery/cm_vending/clothing/medic
	name = "ColMarTech小队医疗装备架"
	desc = "连接着巨型医疗兵制式装备仓库的自动装备架。"
	req_access = list(ACCESS_MARINE_MEDPREP)
	vendor_role = list(JOB_SQUAD_MEDIC)

/obj/structure/machinery/cm_vending/clothing/medic/get_listed_products(mob/user)
	return GLOB.cm_vending_clothing_medic

/obj/structure/machinery/cm_vending/clothing/medic/alpha
	squad_tag = SQUAD_MARINE_1
	req_access = list(ACCESS_MARINE_MEDPREP, ACCESS_MARINE_ALPHA)
	headset_type = /obj/item/device/radio/headset/almayer/marine/alpha/med

/obj/structure/machinery/cm_vending/clothing/medic/bravo
	squad_tag = SQUAD_MARINE_2
	req_access = list(ACCESS_MARINE_MEDPREP, ACCESS_MARINE_BRAVO)
	headset_type = /obj/item/device/radio/headset/almayer/marine/bravo/med

/obj/structure/machinery/cm_vending/clothing/medic/charlie
	squad_tag = SQUAD_MARINE_3
	req_access = list(ACCESS_MARINE_MEDPREP, ACCESS_MARINE_CHARLIE)
	headset_type = /obj/item/device/radio/headset/almayer/marine/charlie/med

/obj/structure/machinery/cm_vending/clothing/medic/delta
	squad_tag = SQUAD_MARINE_4
	req_access = list(ACCESS_MARINE_MEDPREP, ACCESS_MARINE_DELTA)
	headset_type = /obj/item/device/radio/headset/almayer/marine/delta/med

//------------ESSENTIAL SETS---------------

/obj/effect/essentials_set/medic
	spawned_gear_list = list(
		/obj/item/storage/firstaid/softpack/adv,
		/obj/item/storage/firstaid/softpack/adv,
		/obj/item/device/healthanalyzer/soul,
		/obj/item/roller,
		/obj/item/tool/surgery/surgical_line,
		/obj/item/tool/surgery/synthgraft,
		/obj/item/storage/surgical_case/regular,
		/obj/item/device/flashlight/pen,
		/obj/item/reagent_container/hypospray/autoinjector/adrenaline_concentrated,
		/obj/item/reagent_container/hypospray/autoinjector/adrenaline_concentrated,
	)

GLOBAL_LIST_INIT(cm_vending_clothing_upp_medic, list(
		list("医疗套装 (必选)", 0, null, null, null),
		list("必备医疗套装", 0, /obj/effect/essentials_set/medic, MARINE_CAN_BUY_ESSENTIALS, VENDOR_ITEM_MANDATORY),

		list("背包 (任选一件)", 0, null, null, null),
		list("医疗背包", 0, /obj/item/storage/backpack/marine/medic/upp, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_REGULAR),
		list("医疗挎包", 0, /obj/item/storage/backpack/lightpack/upp, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_RECOMMENDED),

		list("腰带 (任选一件)", 0, null, null, null),
		list("41 式弹药携行挂具", 0, /obj/item/storage/belt/marine/upp, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("47 式通用手枪枪套挂具", 0, /obj/item/storage/belt/gun/type47, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("41 式救生医疗包 (满装)", 0, /obj/item/storage/belt/medical/lifesaver/upp/full, MARINE_CAN_BUY_BELT, VENDOR_ITEM_RECOMMENDED),
		list("41 式医疗携行挂具 (满装)", 0, /obj/item/storage/belt/medical/upp/full, MARINE_CAN_BUY_BELT, VENDOR_ITEM_RECOMMENDED),

		list("收纳袋 (任选两件)", 0, null, null, null),
		list("自动注射器收纳袋", 0, /obj/item/storage/pouch/autoinjector, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("医疗套件袋", 0, /obj/item/storage/pouch/medkit, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("加压药剂罐袋 (比卡定)", 0, /obj/item/storage/pouch/pressurized_reagent_canister/bicaridine, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("加压药剂罐袋 (克洛坦)", 0, /obj/item/storage/pouch/pressurized_reagent_canister/kelotane, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("加压药剂罐袋 (广效康复嗪)", 0, /obj/item/storage/pouch/pressurized_reagent_canister/tricordrazine, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("试管袋 (满装)", 0, /obj/item/storage/pouch/vials/full, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),

		list("饰品 (任选一件)", 0, null, null, null),
		list("棕色携行背心", 0, /obj/item/clothing/accessory/storage/black_vest/brown_vest, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_RECOMMENDED),
		list("黑色携行背心", 0, /obj/item/clothing/accessory/storage/black_vest, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("肩部枪套", 0, /obj/item/clothing/accessory/storage/holster, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("携行带", 0, /obj/item/clothing/accessory/storage/webbing, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("挂袋", 0, /obj/item/clothing/accessory/storage/droppouch, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
	))

/obj/structure/machinery/cm_vending/clothing/medic/upp
	name = "联盟科技小队医疗装备架"
	desc = "连接着巨型医疗兵制式装备仓库的自动装备架。"
	icon_state = "upp_gear"
	req_access = list(ACCESS_UPP_MEDPREP)
	vendor_role = list(JOB_SQUAD_MEDIC)
	vendor_theme = VENDOR_THEME_UPP

/obj/structure/machinery/cm_vending/clothing/medic/upp/get_listed_products(mob/user)
	return GLOB.cm_vending_clothing_upp_medic

GLOBAL_LIST_INIT(cm_vending_clothing_forecon_medic, list(
		list("护甲涂装 (任选一件)", 0, null, null, null),
		list("红十字涂装", 0, /obj/item/clothing/accessory/paint/medic, MARINE_CAN_BUY_PAINT, VENDOR_ITEM_RECOMMENDED),

		list("战场监控与抬头显示装备 (任选一件)", 0, null, null, null),
		list("2 型战地医疗瞄准镜", 0, /obj/item/clothing/glasses/night/medhud/no_nvg, MARINE_CAN_BUY_GLASSES, VENDOR_ITEM_REGULAR),

		list("护甲 (任选一件)", 0, null, null, null),
		list("M3-R 护甲", 0, /obj/item/clothing/suit/marine/rto/forecon, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_RECOMMENDED),

		list("背包 (任选一件)", 0, null, null, null),
		list("医疗背包", 0, /obj/item/storage/backpack/marine/medic/standard, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_REGULAR),
		list("医疗挎包", 0, /obj/item/storage/backpack/marine/satchel/medic/standard, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_RECOMMENDED),

		list("腰带 (任选一件)", 0, null, null, null),
		list("M276 救生医疗包 (满装)", 0, /obj/item/storage/belt/medical/lifesaver/standard/full, MARINE_CAN_BUY_BELT, VENDOR_ITEM_RECOMMENDED),
		list("M276 医疗携行挂具 (满装)", 0, /obj/item/storage/belt/medical/full, MARINE_CAN_BUY_BELT, VENDOR_ITEM_RECOMMENDED),

		list("收纳袋 (任选两件)", 0, null, null, null),
		list("自动注射器收纳袋", 0, /obj/item/storage/pouch/autoinjector, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("医疗套件袋", 0, /obj/item/storage/pouch/medkit, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("加压药剂罐袋 (比卡定)", 0, /obj/item/storage/pouch/pressurized_reagent_canister/bicaridine, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("加压药剂罐袋 (克洛坦)", 0, /obj/item/storage/pouch/pressurized_reagent_canister/kelotane, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("加压药剂罐袋 (广效康复嗪)", 0, /obj/item/storage/pouch/pressurized_reagent_canister/tricordrazine, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("试管袋 (满装)", 0, /obj/item/storage/pouch/vials/full, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),

		list("饰品 (任选一件)", 0, null, null, null),
		list("M3-R 式携行带", 0, /obj/item/clothing/accessory/storage/webbing/m3/recon, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("M3-R 式霰弹携行带", 0, /obj/item/clothing/accessory/storage/webbing/m3/recon/shotgun, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("M3-R 式 M40 携行带", 0, /obj/item/clothing/accessory/storage/webbing/m3/recon/m40, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("M3-R 式医疗兵携行带", 0, /obj/item/clothing/accessory/storage/webbing/m3/recon/medic, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_RECOMMENDED),
		list("挂袋", 0, /obj/item/clothing/accessory/storage/droppouch, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("肩部枪套", 0, /obj/item/clothing/accessory/storage/holster, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
	))

/obj/structure/machinery/cm_vending/clothing/medic/forecon
	name = "ColMarTech武装侦察医疗用品架"

/obj/structure/machinery/cm_vending/clothing/medic/forecon/get_listed_products(mob/user)
	return GLOB.cm_vending_clothing_forecon_medic

GLOBAL_LIST_INIT(cm_vending_clothing_pmc_medic, list(

		list("腰带 (任选一件)", 0, null, null, null),
		list("M276 救生医疗包 (满装)", 0, /obj/item/storage/belt/medical/lifesaver/standard/full, MARINE_CAN_BUY_BELT, VENDOR_ITEM_RECOMMENDED),
		list("M276 医疗携行挂具 (满装)", 0, /obj/item/storage/belt/medical/full, MARINE_CAN_BUY_BELT, VENDOR_ITEM_RECOMMENDED),

		list("收纳袋 (任选两件)", 0, null, null, null),
		list("自动注射器收纳袋", 0, /obj/item/storage/pouch/autoinjector, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("医疗套件袋", 0, /obj/item/storage/pouch/medkit, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("加压药剂罐袋 (比卡定)", 0, /obj/item/storage/pouch/pressurized_reagent_canister/bicaridine, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("加压药剂罐袋 (克洛坦)", 0, /obj/item/storage/pouch/pressurized_reagent_canister/kelotane, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("加压药剂罐袋 (广效康复嗪)", 0, /obj/item/storage/pouch/pressurized_reagent_canister/tricordrazine, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("试管袋 (满装)", 0, /obj/item/storage/pouch/vials/full, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),

		list("饰品 (任选一件)", 0, null, null, null),
		list("棕色携行背心", 0, /obj/item/clothing/accessory/storage/black_vest/brown_vest, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_RECOMMENDED),
		list("黑色携行背心", 0, /obj/item/clothing/accessory/storage/black_vest, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("肩部枪套", 0, /obj/item/clothing/accessory/storage/holster, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("携行带", 0, /obj/item/clothing/accessory/storage/webbing, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("挂袋", 0, /obj/item/clothing/accessory/storage/droppouch, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
	))

/obj/structure/machinery/cm_vending/clothing/medic/pmc
	name = "PMC 医疗用品架"
	icon_state = "pmc_gear"
	vendor_theme = VENDOR_THEME_COMPANY

/obj/structure/machinery/cm_vending/clothing/medic/pmc/get_listed_products(mob/user)
	return GLOB.cm_vending_clothing_pmc_medic

// RMC med-vendor

/obj/effect/essentials_set/rmcmedic
	spawned_gear_list = list(
		/obj/item/storage/surgical_case/rmc_surgical_case/full,
		/obj/item/device/healthanalyzer/soul,
		/obj/item/tool/surgery/synthgraft,
		/obj/item/device/flashlight/pen,
		/obj/item/clothing/accessory/stethoscope,
	)

GLOBAL_LIST_INIT(cm_vending_clothing_rmc_medic, list(
		list("医疗套装 (必选)", 0, null, null, null),
		list("必备医疗套装", 0, /obj/effect/essentials_set/rmcmedic, MARINE_CAN_BUY_ESSENTIALS, VENDOR_ITEM_MANDATORY),

		list("背包 (任选一件)", 0, null, null, null),
		list("重型医疗背包", 0, /obj/item/storage/backpack/rmc/medic, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_RECOMMENDED),

		list("腰带 (任选一件)", 0, null, null, null),
		list("L75 式医疗携行挂具 (空)", 0, /obj/item/storage/belt/medical/rmc, MARINE_CAN_BUY_BELT, VENDOR_ITEM_RECOMMENDED),
		list("L26 式通用杂物腰带", 0, /obj/item/storage/backpack/general_belt/rmc, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),

		list("收纳袋 (任选两件)", 0, null, null, null),
		list("自动注射器收纳袋", 0, /obj/item/storage/pouch/autoinjector, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("医疗套件袋", 0, /obj/item/storage/pouch/medkit, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("加压药剂罐袋 (比卡定)", 0, /obj/item/storage/pouch/pressurized_reagent_canister/bicaridine, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("加压药剂罐袋 (克洛坦)", 0, /obj/item/storage/pouch/pressurized_reagent_canister/kelotane, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("加压药剂罐袋 (广效康复嗪)", 0, /obj/item/storage/pouch/pressurized_reagent_canister/tricordrazine, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("试管袋 (满装)", 0, /obj/item/storage/pouch/vials/full, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),

		list("饰品 (任选一件)", 0, null, null, null),
		list("挂袋", 0, /obj/item/clothing/accessory/storage/droppouch/rmc, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_RECOMMENDED),
		list("小型收纳袋", 0, /obj/item/clothing/accessory/storage/smallpouch/rmc, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("腰部枪套", 0, /obj/item/clothing/accessory/storage/holster/waist, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
	))

/obj/structure/machinery/cm_vending/clothing/medic/rmc
	name = "维兰科技班组医疗装备架"
	desc = "连接着巨型制式医疗装备仓库的自动装备架。"
	icon_state = "rmc_gear"
	req_access = list(ACCESS_TWE_MEDPREP)
	vendor_role = list(JOB_TWE_RMC_MEDIC)
	vendor_theme = VENDOR_THEME_COMPANY

/obj/structure/machinery/cm_vending/clothing/medic/rmc/get_listed_products(mob/user)
	return GLOB.cm_vending_clothing_rmc_medic

// Chemical vendor

GLOBAL_LIST_INIT(cm_vending_chemical_medic, list(

		list("必备药品 (任选一件)", 0, null, null, null),
		list("药瓶 (咪唑啉-神经修复素)", 0, /obj/item/storage/pill_bottle/imialk, MARINE_CAN_BUY_SHOES, VENDOR_ITEM_RECOMMENDED),
		list("药液瓶 (咪唑啉-神经修复素)", 0, /obj/item/reagent_container/glass/bottle/imialk, MARINE_CAN_BUY_SHOES, VENDOR_ITEM_RECOMMENDED),

		list("药瓶", 0, null, null, null),
		list("药瓶 (美拉林-比卡定)", 60, /obj/item/storage/pill_bottle/merabica, null, VENDOR_ITEM_REGULAR),
		list("药瓶 (克洛坦-德玛林)", 60, /obj/item/storage/pill_bottle/keloderm, null, VENDOR_ITEM_REGULAR),
		list("药瓶 (氮-水)", 30, /obj/item/storage/pill_bottle/nitrogenwater, null, VENDOR_ITEM_REGULAR),
		list("药瓶 (强化右氧林)", 30, /obj/item/storage/pill_bottle/dexalinplus, null, VENDOR_ITEM_REGULAR),
		list("药瓶 (铁)", 30, /obj/item/storage/pill_bottle/iron, null, VENDOR_ITEM_REGULAR),

		list("药液瓶", 0, null, null, null),
		list("药液瓶 (美拉林-比卡定)", 40, /obj/item/reagent_container/glass/bottle/merabica, null, VENDOR_ITEM_REGULAR),
		list("药液瓶 (克洛坦-德玛林)", 40, /obj/item/reagent_container/glass/bottle/keloderm, null, VENDOR_ITEM_REGULAR),
		list("药液瓶 (强化右氧林)", 30, /obj/item/reagent_container/glass/bottle/dexalinplus, null, VENDOR_ITEM_REGULAR),

		list("注射器", 0, null, null, null),
		list("智能补充罐", 40, /obj/item/reagent_container/glass/minitank, null, VENDOR_ITEM_REGULAR),
	))

/obj/structure/machinery/cm_vending/gear/medic_chemical
	name = "ColMarTech小队医疗药剂架"
	desc = "供医疗兵领取专用药剂的自动装备架。"
	icon_state = "med_chem"
	show_points = TRUE
	use_snowflake_points = TRUE
	vendor_role = list(JOB_SQUAD_MEDIC)
	req_access = list(ACCESS_MARINE_MEDPREP)

/obj/structure/machinery/cm_vending/gear/medic_chemical/get_listed_products(mob/user)
	return GLOB.cm_vending_chemical_medic

/obj/structure/machinery/cm_vending/gear/medic_chemical/upp
	name = "联盟科技小队医疗药剂架"
	req_access = list(ACCESS_UPP_MEDPREP)
	vendor_theme = VENDOR_THEME_UPP

/obj/structure/machinery/cm_vending/gear/medic_chemical/rmc
	name = "维兰科技班组医疗药剂架"
	req_access = list(ACCESS_TWE_MEDPREP)
	vendor_theme = VENDOR_THEME_COMPANY
	vendor_role = list(JOB_TWE_RMC_MEDIC)
