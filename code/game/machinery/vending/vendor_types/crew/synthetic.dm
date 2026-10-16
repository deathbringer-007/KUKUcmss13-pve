//------------GEAR VENDOR---------------

/obj/structure/machinery/cm_vending/gear/synth
	name = "ColMarTech合成人辅助装备架"
	desc = "连接着巨型医疗与工程用品仓库的自动装备架。仅限合成人单位使用。"
	icon_state = "gear"
	req_access = list(ACCESS_MARINE_SYNTH)
	vendor_role = list(JOB_SYNTH, JOB_SYNTH_SURVIVOR, JOB_UPP_SUPPORT_SYNTH, JOB_CMB_SYN, JOB_PMC_SYNTH)

	listed_products = list(
		list("工兵用品", 0, null, null, null),
		list("气闸门电路板", 1, /obj/item/circuitboard/airlock, null, VENDOR_ITEM_REGULAR),
		list("区域电力控制器电路板", 1, /obj/item/circuitboard/apc, null, VENDOR_ITEM_REGULAR),
		list("工兵铲", 2, /obj/item/tool/shovel/etool, null, VENDOR_ITEM_REGULAR),
		list("高容量电池", 2, /obj/item/cell/high, null, VENDOR_ITEM_REGULAR),
		list("金属 x10", 5, /obj/item/stack/sheet/metal/small_stack, null, VENDOR_ITEM_REGULAR),
		list("塑钢 x10", 7, /obj/item/stack/sheet/plasteel/small_stack, null, VENDOR_ITEM_REGULAR),
		list("沙袋 x25", 5, /obj/item/stack/sandbags_empty/half, null, VENDOR_ITEM_REGULAR),
		list("塑性炸药", 3, /obj/item/explosive/plastic, null, VENDOR_ITEM_REGULAR),
		list("ES-11 移动燃料罐", 4, /obj/item/tool/weldpack/minitank, null, VENDOR_ITEM_REGULAR),
		list("工兵工具包", 1, /obj/item/storage/toolkit/empty, null, VENDOR_ITEM_REGULAR),
		list("战术撬杠", 5, /obj/item/tool/crowbar/tactical, null, VENDOR_ITEM_REGULAR),

		list("急救箱", 0, null, null, null),
		list("高级急救箱", 12, /obj/item/storage/firstaid/softpack/adv, null, VENDOR_ITEM_REGULAR),
		list("急救箱", 5, /obj/item/storage/firstaid/softpack/regular, null, VENDOR_ITEM_REGULAR),
		list("烧伤急救箱", 6, /obj/item/storage/firstaid/softpack/fire, null, VENDOR_ITEM_REGULAR),
		list("解毒急救箱", 6, /obj/item/storage/firstaid/softpack/toxin, null, VENDOR_ITEM_REGULAR),
		list("缺氧急救箱", 6, /obj/item/storage/firstaid/softpack/o2, null, VENDOR_ITEM_REGULAR),
		list("辐射急救箱", 6, /obj/item/storage/firstaid/softpack/rad, null, VENDOR_ITEM_REGULAR),

		list("医疗用品", 0, null, null, null),
		list("烧伤治疗包", 2, /obj/item/stack/medical/advanced/ointment, null, VENDOR_ITEM_REGULAR),
		list("创伤治疗包", 2, /obj/item/stack/medical/advanced/bruise_pack, null, VENDOR_ITEM_REGULAR),
		list("医用夹板", 1, /obj/item/stack/medical/splint, null, VENDOR_ITEM_REGULAR),
		list("轮式担架床", 3, /obj/item/roller, null, VENDOR_ITEM_REGULAR),
		list("MS-11 智能补充罐", 4, /obj/item/reagent_container/glass/minitank, null, VENDOR_ITEM_REGULAR),

		list("药瓶 (比卡定)", 5, /obj/item/storage/pill_bottle/bicaridine, null, VENDOR_ITEM_REGULAR),
		list("药瓶 (右氧林)", 5, /obj/item/storage/pill_bottle/dexalin, null, VENDOR_ITEM_REGULAR),
		list("药瓶 (迪洛文)", 5, /obj/item/storage/pill_bottle/antitox, null, VENDOR_ITEM_REGULAR),
		list("药瓶 (因纳普罗伐林)", 5, /obj/item/storage/pill_bottle/inaprovaline, null, VENDOR_ITEM_REGULAR),
		list("药瓶 (克洛坦)", 5, /obj/item/storage/pill_bottle/kelotane, null, VENDOR_ITEM_REGULAR),
		list("药瓶 (佩里达酮)", 5, /obj/item/storage/pill_bottle/peridaxon, null, VENDOR_ITEM_REGULAR),
		list("药瓶 (曲马多)", 5, /obj/item/storage/pill_bottle/tramadol, null, VENDOR_ITEM_REGULAR),
		list("药瓶 (咪唑啉-神经修复素)", 10, /obj/item/storage/pill_bottle/imialk, null, VENDOR_ITEM_RECOMMENDED),

		list("注射器 (比卡定)", 1, /obj/item/reagent_container/hypospray/autoinjector/bicaridine, null, VENDOR_ITEM_REGULAR),
		list("注射器 (强化右氧林)", 1, /obj/item/reagent_container/hypospray/autoinjector/dexalinp, null, VENDOR_ITEM_REGULAR),
		list("注射器 (因纳普罗伐林)", 1, /obj/item/reagent_container/hypospray/autoinjector/inaprovaline, null, VENDOR_ITEM_REGULAR),
		list("注射器 (克洛坦)", 1, /obj/item/reagent_container/hypospray/autoinjector/kelotane, null, VENDOR_ITEM_REGULAR),
		list("注射器 (羟考酮)", 2, /obj/item/reagent_container/hypospray/autoinjector/oxycodone, null, VENDOR_ITEM_REGULAR),
		list("注射器 (曲马多)", 1, /obj/item/reagent_container/hypospray/autoinjector/tramadol, null, VENDOR_ITEM_REGULAR),
		list("注射器 (广效康复嗪)", 1, /obj/item/reagent_container/hypospray/autoinjector/tricord, null, VENDOR_ITEM_REGULAR),

		list("健康诊断设备", 2, /obj/item/device/healthanalyzer/soul, null, VENDOR_ITEM_REGULAR),
		list("手术缝合线", 3, /obj/item/tool/surgery/surgical_line, null, VENDOR_ITEM_REGULAR),
		list("合成皮肤移植剂", 3, /obj/item/tool/surgery/synthgraft, null, VENDOR_ITEM_REGULAR),

		list("其他用品", 0, null, null, null),
		list("双筒望远镜", 5,/obj/item/device/binoculars, null, VENDOR_ITEM_REGULAR),
		list("测距仪", 8, /obj/item/device/binoculars/range, null,  VENDOR_ITEM_REGULAR),
		list("激光目标指示器", 12, /obj/item/device/binoculars/range/designator, null, VENDOR_ITEM_RECOMMENDED),
		list("手电筒", 1, /obj/item/device/flashlight, null, VENDOR_ITEM_RECOMMENDED),
		list("运动探测器", 3, /obj/item/device/motiondetector, null, VENDOR_ITEM_REGULAR),
		list("太空清洁剂", 1, /obj/item/reagent_container/spray/cleaner, null, VENDOR_ITEM_REGULAR),
		list("哨子", 2, /obj/item/device/whistle, null, VENDOR_ITEM_REGULAR),
		list("砍刀鞘 (满装)", 2, /obj/item/storage/large_holster/machete/full, null, VENDOR_ITEM_REGULAR)

	)

//------------CLOTHING VENDOR---------------

GLOBAL_LIST_INIT(cm_vending_clothing_synth, list(
		list("实验装备 (任选一件)", 0, null, null, null),
		list("破障锤", 0, /obj/item/weapon/twohanded/breacher/synth, MARINE_CAN_BUY_ESSENTIALS, VENDOR_ITEM_REGULAR),
		list("紧凑型射钉枪套件", 0, /obj/effect/essentials_set/cnailgun, MARINE_CAN_BUY_ESSENTIALS, VENDOR_ITEM_REGULAR),
		list("人员监测仪", 0, /obj/item/tool/crew_monitor, MARINE_CAN_BUY_ESSENTIALS, VENDOR_ITEM_REGULAR),
		list("维护撬杠", 0, /obj/item/maintenance_jack, MARINE_CAN_BUY_ESSENTIALS, VENDOR_ITEM_RECOMMENDED),
		list("便携式透析机", 0, /obj/item/tool/portadialysis, MARINE_CAN_BUY_ESSENTIALS, VENDOR_ITEM_REGULAR),
		list("伸缩警棍", 0, /obj/item/weapon/telebaton, MARINE_CAN_BUY_ESSENTIALS, VENDOR_ITEM_REGULAR),

		list("无线电 (全部领取)", 0, null, null, null),
		list("耳机", 0, /obj/item/device/radio/headset/almayer/mcom/synth, MARINE_CAN_BUY_EAR, VENDOR_ITEM_MANDATORY),

		list("制服 (任选一件)", 0, null, null, null),
		list("制服, 老式合成人", 0, /obj/item/clothing/under/rank/synthetic/old, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),
		list("制服, 标准合成人", 0, /obj/item/clothing/under/rank/synthetic, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_MANDATORY),
		list("USCM 标准制服", 0, /obj/item/clothing/under/marine, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),
		list("USCM 医疗制服", 0, /obj/item/clothing/under/marine/medic, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),

		list("携行带 (任选一件)", 0, null, null, null),
		list("黑色携行背心", 0, /obj/item/clothing/accessory/storage/black_vest, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("棕色携行背心", 0, /obj/item/clothing/accessory/storage/black_vest/brown_vest, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_RECOMMENDED),
		list("携行带", 0, /obj/item/clothing/accessory/storage/webbing, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("手术器械携行背心", 0, /obj/item/clothing/accessory/storage/surg_vest, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("手术器械携行背心 (蓝色)", 0, /obj/item/clothing/accessory/storage/surg_vest/blue, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("手术器械挂袋", 0, /obj/item/clothing/accessory/storage/surg_vest/drop_green, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("手术器械挂袋 (蓝色)", 0, /obj/item/clothing/accessory/storage/surg_vest/drop_blue, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("手术器械挂袋 (黑色)", 0, /obj/item/clothing/accessory/storage/surg_vest/drop_black, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("工具携行带", 0, /obj/item/clothing/accessory/storage/tool_webbing/equipped, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("挂袋", 0, /obj/item/clothing/accessory/storage/droppouch, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),

		list("鞋子 (任选一件)", 0, null, null, null),
		list("靴子", 0, /obj/item/clothing/shoes/marine/knife, MARINE_CAN_BUY_SHOES, VENDOR_ITEM_REGULAR),
		list("鞋子, 白色", 0, /obj/item/clothing/shoes/white, MARINE_CAN_BUY_SHOES, VENDOR_ITEM_RECOMMENDED),

		list("头盔 (任选一件)", 0, null, null, null),
		list("远征帽", 0, /obj/item/clothing/head/cmcap/flap, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),
		list("安全帽, 橙色", 0, /obj/item/clothing/head/hardhat/orange, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),
		list("焊接头盔", 0, /obj/item/clothing/head/welding, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),

		list("外套 (任选一件)", 0, null, null, null),
		list("M3-VL 式防破片背心", 0, /obj/item/clothing/suit/storage/marine/light/vest/dcc, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_RECOMMENDED),
		list("M3-VL 式防弹背心", 0, /obj/item/clothing/suit/storage/marine/light/vest, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_REGULAR),
		list("M70 防破片夹克", 0, /obj/item/clothing/suit/armor/vest/pilot, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_REGULAR),
		list("肩灯挂具", 0, /obj/item/clothing/suit/marine/lamp, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_REGULAR),

		list("手套 (任选一件)", 0, null, null, null),
		list("绝缘手套", 0, /obj/item/clothing/gloves/yellow, MARINE_CAN_BUY_GLOVES, VENDOR_ITEM_RECOMMENDED),
		list("黑色手套", 0, /obj/item/clothing/gloves/black, MARINE_CAN_BUY_GLOVES, VENDOR_ITEM_REGULAR),
		list("乳胶手套", 0, /obj/item/clothing/gloves/latex, MARINE_CAN_BUY_GLOVES, VENDOR_ITEM_REGULAR),

		list("背包 (任选一件)", 0, null, null, null),
		list("战术 IMP 行军背包", 0, /obj/item/storage/backpack/marine/marsoc, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_REGULAR),
		list("后勤 IMP 背包", 0, /obj/item/storage/backpack/marine/satchel/big, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_REGULAR),
		list("远征胸挂", 0, /obj/item/storage/backpack/marine/satchel/intel/chestrig, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_REGULAR),

		list("腰带 (任选一件)", 0, null, null, null),
		list("G8-A 通用杂物袋", 0, /obj/item/storage/backpack/general_belt, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 救生医疗包", 0, /obj/item/storage/belt/medical/lifesaver/full, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 医疗携行腰带", 0, /obj/item/storage/belt/medical/full, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 工具携行腰带 (满装)", 0, /obj/item/storage/belt/utility/full, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),

		list("收纳袋 (任选两件)", 0, null, null, null),
		list("自动注射器收纳袋", 0, /obj/item/storage/pouch/autoinjector, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("建材袋", 0, /obj/item/storage/pouch/construction, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("电子器材袋 (满装)", 0, /obj/item/storage/pouch/electronics/full, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("急救袋 (可补充注射器)", 0, /obj/item/storage/pouch/firstaid/full, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("急救袋 (夹板, 医用纱布, 烧伤药膏)", 0, /obj/item/storage/pouch/firstaid/full/alternate, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("急救袋 (药片包)", 0, /obj/item/storage/pouch/firstaid/full/pills, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("急救响应袋", 0, /obj/item/storage/pouch/first_responder, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("照明弹袋 (满装)", 0, /obj/item/storage/pouch/flare/full, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("大型杂物袋", 0, /obj/item/storage/pouch/general/large, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("枪带袋", 0, /obj/item/storage/pouch/sling, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("医疗收纳袋", 0, /obj/item/storage/pouch/medical, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("医疗套件袋", 0, /obj/item/storage/pouch/medkit, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("加压药剂罐袋 (比卡定)", 0, /obj/item/storage/pouch/pressurized_reagent_canister/bicaridine, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("加压药剂罐袋 (克洛坦)", 0, /obj/item/storage/pouch/pressurized_reagent_canister/kelotane, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("加压药剂罐袋 (广效康复嗪)", 0, /obj/item/storage/pouch/pressurized_reagent_canister/tricordrazine, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("工具袋 (满装)", 0, /obj/item/storage/pouch/tools/full, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("砍刀袋 (满装)", 0, /obj/item/storage/pouch/machete/full, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),

		list("面罩", 0, null, null, null),
		list("无菌口罩", 0, /obj/item/clothing/mask/surgical, MARINE_CAN_BUY_MASK, VENDOR_ITEM_REGULAR)
	))

/obj/structure/machinery/cm_vending/clothing/synth
	name = "ColMarTech合成人装备架"
	desc = "连接着巨型综合装备仓库的自动装备架。仅限合成人单位使用。"
	req_access = list(ACCESS_MARINE_SYNTH)
	vendor_role = list(JOB_SYNTH, JOB_SYNTH_SURVIVOR, JOB_UPP_SUPPORT_SYNTH, JOB_CMB_SYN, JOB_PMC_SYNTH)

/obj/structure/machinery/cm_vending/clothing/synth/get_listed_products(mob/user)
	return GLOB.cm_vending_clothing_synth

//------------SNOWFLAKE VENDOR---------------

GLOBAL_LIST_INIT(cm_vending_clothing_synth_snowflake, list(
	list("USCM 制服", 0, null, null, null),
	list("医用刷手服, 蓝色", 12, /obj/item/clothing/under/rank/medical/blue, null, VENDOR_ITEM_REGULAR),
	list("医用刷手服, 浅蓝色", 12, /obj/item/clothing/under/rank/medical/lightblue, null, VENDOR_ITEM_REGULAR),
	list("医用刷手服, 绿色", 12, /obj/item/clothing/under/rank/medical/green, null, VENDOR_ITEM_REGULAR),
	list("医用刷手服, 紫色", 12, /obj/item/clothing/under/rank/medical/purple, null, VENDOR_ITEM_REGULAR),
	list("医用刷手服, 橄榄绿", 12, /obj/item/clothing/under/rank/medical/olive, null, VENDOR_ITEM_REGULAR),
	list("医用刷手服, 灰色", 12, /obj/item/clothing/under/rank/medical/grey, null, VENDOR_ITEM_REGULAR),
	list("医用刷手服, 白色", 12, /obj/item/clothing/under/rank/medical, null, VENDOR_ITEM_REGULAR),
	list("USCM 常服, 棕褐色", 12, /obj/item/clothing/under/marine/officer/bridge, null, VENDOR_ITEM_REGULAR),
	list("USCM 常服, 白色", 12, /obj/item/clothing/under/marine/dress, null, VENDOR_ITEM_REGULAR),
	list("USCM 飞行服", 12, /obj/item/clothing/under/rank/synthetic/flight, null, VENDOR_ITEM_REGULAR),
	list("USCM 载具乘员制服", 12, /obj/item/clothing/under/marine/officer/tanker, null, VENDOR_ITEM_REGULAR),
	list("USCM 工兵制服", 12, /obj/item/clothing/under/marine/engineer/standard, null, VENDOR_ITEM_REGULAR),
	list("USCM 工兵制服 (深色)", 12, /obj/item/clothing/under/marine/engineer/darker, null, VENDOR_ITEM_REGULAR),
	list("USCM 工程军官制服", 12, /obj/item/clothing/under/marine/officer/engi, null, VENDOR_ITEM_REGULAR),
	list("USCM 宪兵制服", 12, /obj/item/clothing/under/marine/mp/standard, null, VENDOR_ITEM_REGULAR),
	list("USCM 宪兵制服 (深色)", 12, /obj/item/clothing/under/marine/mp/darker, null, VENDOR_ITEM_REGULAR),

	list("非制式制服", 0, null, null, null),
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
	list("健康伙伴抬头显示器", 12, /obj/item/clothing/glasses/hud/health, null, VENDOR_ITEM_REGULAR),
	list("陆战队军用配发眼镜", 12, /obj/item/clothing/glasses/regular, null, VENDOR_ITEM_REGULAR),
	list("光学介子扫描镜", 12, /obj/item/clothing/glasses/meson, null, VENDOR_ITEM_REGULAR),
	list("巡逻伙伴抬头显示器", 12, /obj/item/clothing/glasses/hud/security, null, VENDOR_ITEM_REGULAR),
	list("安保抬头显示眼镜", 12, /obj/item/clothing/glasses/sunglasses/sechud, null, VENDOR_ITEM_REGULAR),
	list("太阳镜", 12, /obj/item/clothing/glasses/sunglasses, null, VENDOR_ITEM_REGULAR),
	list("焊接护目镜", 12, /obj/item/clothing/glasses/welding, null, VENDOR_ITEM_REGULAR),

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
	list("鞋子, 西格森", 24, /obj/item/clothing/shoes/laceup, null, VENDOR_ITEM_REGULAR),

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
	list("手术帽, 蓝色", 12, /obj/item/clothing/head/surgery/blue, null, VENDOR_ITEM_REGULAR),
	list("手术帽, 蓝色", 12, /obj/item/clothing/head/surgery/purple, null, VENDOR_ITEM_REGULAR),
	list("手术帽, 绿色", 12, /obj/item/clothing/head/surgery/green, null, VENDOR_ITEM_REGULAR),
	list("护耳毛帽", 12, /obj/item/clothing/head/ushanka, null, VENDOR_ITEM_REGULAR),
	list("帽", 12, /obj/item/clothing/head/cmcap, null, VENDOR_ITEM_REGULAR),
	list("MP 帽", 12, /obj/item/clothing/head/beret/marine/mp/mpcap, null, VENDOR_ITEM_REGULAR),
	list("军需帽", 12, /obj/item/clothing/head/cmcap/khaki, null, VENDOR_ITEM_REGULAR),
	list("军官帽", 12, /obj/item/clothing/head/cmcap/bridge, null, VENDOR_ITEM_REGULAR),
	list("生化防护头罩", 12, /obj/item/clothing/head/bio_hood/synth, null, VENDOR_ITEM_REGULAR),
	list("软呢帽", 12, /obj/item/clothing/head/fedora, null, VENDOR_ITEM_REGULAR),

	list("头盔", 0, null, null, null),
	list("陆战队头盔 (任务适配迷彩)", 12, /obj/item/clothing/head/helmet/marine, null, VENDOR_ITEM_REGULAR),
	list("陆战队头盔 (灰色)", 12, /obj/item/clothing/head/helmet/marine/grey, null, VENDOR_ITEM_REGULAR),
	list("陆战队头盔 (丛林)", 12, /obj/item/clothing/head/helmet/marine/jungle, null, VENDOR_ITEM_REGULAR),
	list("陆战队头盔 (雪地)", 12, /obj/item/clothing/head/helmet/marine/snow, null, VENDOR_ITEM_REGULAR),
	list("陆战队头盔 (沙漠)", 12, /obj/item/clothing/head/helmet/marine/desert, null, VENDOR_ITEM_REGULAR),
	list("技术员头盔", 12, /obj/item/clothing/head/helmet/marine/tech, null, VENDOR_ITEM_REGULAR),
	list("飞行员头盔", 12, /obj/item/clothing/head/helmet/upp/marinepilot, null, VENDOR_ITEM_REGULAR),
	list("乘员头盔", 12, /obj/item/clothing/head/helmet/marine/tech/tanker, null, VENDOR_ITEM_REGULAR),
	list("医疗兵头盔", 12, /obj/item/clothing/head/helmet/marine/medic, null, VENDOR_ITEM_REGULAR),
	list("白色医疗兵头盔", 12, /obj/item/clothing/head/helmet/marine/medic/white, null, VENDOR_ITEM_REGULAR),
	list("可装卸头盔面盾", 12, /obj/item/prop/helmetgarb/riot_shield, null, VENDOR_ITEM_REGULAR),

	list("面罩", 0, null, null, null),
	list("外科口罩", 12, /obj/item/clothing/mask/surgical, null, VENDOR_ITEM_REGULAR),
	list("呼吸调温器", 12, /obj/item/clothing/mask/rebreather, null, VENDOR_ITEM_REGULAR),
	list("骷髅巴拉克拉法帽, 蓝色", 12, /obj/item/clothing/mask/rebreather/skull, null, VENDOR_ITEM_REGULAR),
	list("骷髅巴拉克拉法帽, 黑色", 12, /obj/item/clothing/mask/rebreather/skull/black, null, VENDOR_ITEM_REGULAR),
	list("巴拉克拉法帽", 12, /obj/item/clothing/mask/rebreather/scarf, null, VENDOR_ITEM_REGULAR),
	list("巴拉克拉法帽 (绿色)", 12, /obj/item/clothing/mask/rebreather/scarf/green, null, VENDOR_ITEM_REGULAR),
	list("巴拉克拉法帽 (棕褐色)", 12, /obj/item/clothing/mask/rebreather/scarf/tan, null, VENDOR_ITEM_REGULAR),
	list("巴拉克拉法帽 (灰色)", 12, /obj/item/clothing/mask/rebreather/scarf/gray, null, VENDOR_ITEM_REGULAR),
	list("面巾 (灰色)", 12, /obj/item/clothing/mask/rebreather/scarf/tacticalmask, null, VENDOR_ITEM_REGULAR),
	list("面巾 (红色)", 12, /obj/item/clothing/mask/rebreather/scarf/tacticalmask/red, null, VENDOR_ITEM_REGULAR),
	list("面巾 (绿色)", 12, /obj/item/clothing/mask/rebreather/scarf/tacticalmask/green, null, VENDOR_ITEM_REGULAR),
	list("面巾 (棕褐色)", 12, /obj/item/clothing/mask/rebreather/scarf/tacticalmask/tan, null, VENDOR_ITEM_REGULAR),
	list("面巾 (黑色)", 12, /obj/item/clothing/mask/rebreather/scarf/tacticalmask/black, null, VENDOR_ITEM_REGULAR),
	list("围巾", 12, /obj/item/clothing/mask/tornscarf, null, VENDOR_ITEM_REGULAR),
	list("围巾 (绿色)", 12, /obj/item/clothing/mask/tornscarf/green, null, VENDOR_ITEM_REGULAR),
	list("围巾 (雪地)", 12, /obj/item/clothing/mask/tornscarf/snow, null, VENDOR_ITEM_REGULAR),
	list("围巾 (沙漠)", 12, /obj/item/clothing/mask/tornscarf/desert, null, VENDOR_ITEM_REGULAR),
	list("围巾 (城市)", 12, /obj/item/clothing/mask/tornscarf/urban, null, VENDOR_ITEM_REGULAR),
	list("围巾 (黑色)", 12, /obj/item/clothing/mask/tornscarf/black, null, VENDOR_ITEM_REGULAR),

	list("外套", 0, null, null, null),
	list("飞行夹克, 棕色", 12, /obj/item/clothing/suit/storage/bomber, null, VENDOR_ITEM_REGULAR),
	list("飞行夹克, 黑色", 12, /obj/item/clothing/suit/storage/bomber/alt, null, VENDOR_ITEM_REGULAR),
	list("外挂携行带", 12, /obj/item/clothing/suit/storage/webbing, null, VENDOR_ITEM_REGULAR),
	list("多用途背心", 12, /obj/item/clothing/suit/storage/utility_vest, null, VENDOR_ITEM_REGULAR),
	list("反光背心(橙色)", 12, /obj/item/clothing/suit/storage/hazardvest, null, VENDOR_ITEM_REGULAR),
	list("反光背心(蓝色)", 12, /obj/item/clothing/suit/storage/hazardvest/blue, null, VENDOR_ITEM_REGULAR),
	list("反光背心(黄色)", 12, /obj/item/clothing/suit/storage/hazardvest/yellow, null, VENDOR_ITEM_REGULAR),
	list("反光背心(黑色)", 12, /obj/item/clothing/suit/storage/hazardvest/black, null, VENDOR_ITEM_REGULAR),
	list("合成人防寒服", 12, /obj/item/clothing/suit/storage/snow_suit/synth, null, VENDOR_ITEM_REGULAR),
	list("USCM 常服外套", 12, /obj/item/clothing/suit/storage/jacket/marine/service, null, VENDOR_ITEM_REGULAR),
	list("USCM MP 常服外套", 12, /obj/item/clothing/suit/storage/jacket/marine/service/mp, null, VENDOR_ITEM_REGULAR),
	list("USCM 轻型防破片夹克", 12, /obj/item/clothing/suit/storage/jacket/marine/pilot, null, VENDOR_ITEM_REGULAR),
	list("USCM 载具乘员夹克", 12, /obj/item/clothing/suit/storage/jacket/marine/service/tanker, null, VENDOR_ITEM_REGULAR),
	list("防风夹克, 棕色", 12, /obj/item/clothing/suit/storage/windbreaker/windbreaker_brown, null, VENDOR_ITEM_REGULAR),
	list("防风夹克, 灰色", 12, /obj/item/clothing/suit/storage/windbreaker/windbreaker_gray, null, VENDOR_ITEM_REGULAR),
	list("防风夹克, 绿色", 12, /obj/item/clothing/suit/storage/windbreaker/windbreaker_green, null, VENDOR_ITEM_REGULAR),
	list("防风夹克, 急救响应员", 12, /obj/item/clothing/suit/storage/windbreaker/windbreaker_fr, null, VENDOR_ITEM_REGULAR),
	list("防风夹克, 探险", 12, /obj/item/clothing/suit/storage/windbreaker/windbreaker_covenant, null, VENDOR_ITEM_REGULAR),
	list("白大褂", 12, /obj/item/clothing/suit/storage/labcoat, null, VENDOR_ITEM_REGULAR),
	list("白大褂, 研究员", 12, /obj/item/clothing/suit/storage/labcoat/researcher, null, VENDOR_ITEM_REGULAR),
	list("军需官夹克", 12, /obj/item/clothing/suit/storage/jacket/marine/RO, null, VENDOR_ITEM_REGULAR),
	list("生化防护服", 12, /obj/item/clothing/suit/storage/synthbio, null, VENDOR_ITEM_REGULAR),
	list("黑色西装外套", 12, /obj/item/clothing/suit/storage/jacket/marine/corporate/black, null, VENDOR_ITEM_REGULAR),
	list("棕色西装外套", 12, /obj/item/clothing/suit/storage/jacket/marine/corporate/brown, null, VENDOR_ITEM_REGULAR),
	list("蓝色西装外套", 12, /obj/item/clothing/suit/storage/jacket/marine/corporate/blue, null, VENDOR_ITEM_REGULAR),
	list("棕色背心", 12, /obj/item/clothing/suit/storage/jacket/marine/vest, null, VENDOR_ITEM_REGULAR),
	list("棕褐色背心", 12, /obj/item/clothing/suit/storage/jacket/marine/vest/tan, null, VENDOR_ITEM_REGULAR),
	list("灰色背心", 12, /obj/item/clothing/suit/storage/jacket/marine/vest/grey, null, VENDOR_ITEM_REGULAR),
	list("USCM 雨披 (任务适配迷彩)", 12, /obj/item/clothing/accessory/poncho, null, VENDOR_ITEM_REGULAR),
	list("USCM 雨披 (绿色)", 12, /obj/item/clothing/accessory/poncho/green, null, VENDOR_ITEM_REGULAR),
	list("USCM 雨披 (棕色)", 12, /obj/item/clothing/accessory/poncho/brown, null, VENDOR_ITEM_REGULAR),
	list("USCM 雨披 (黑色)", 12, /obj/item/clothing/accessory/poncho/black, null, VENDOR_ITEM_REGULAR),
	list("USCM 雨披 (蓝色)", 12, /obj/item/clothing/accessory/poncho/blue, null, VENDOR_ITEM_REGULAR),
	list("USCM 雨披 (紫色)", 12, /obj/item/clothing/accessory/poncho/purple, null, VENDOR_ITEM_REGULAR),


	list("背包", 0, null, null, null),
	list("背包, 工业", 12, /obj/item/storage/backpack/industrial, null, VENDOR_ITEM_REGULAR),
	list("背包, USCM 医疗", 12, /obj/item/storage/backpack/marine/medic, null, VENDOR_ITEM_REGULAR),
	list("胸挂, 技术员", 12, /obj/item/storage/backpack/marine/satchel/tech, null, VENDOR_ITEM_REGULAR),
	list("挎包, USCM", 12, /obj/item/storage/backpack/marine/satchel, null, VENDOR_ITEM_REGULAR),
	list("挎包, 皮革", 12, /obj/item/storage/backpack/satchel, null, VENDOR_ITEM_REGULAR),
	list("挎包, 医疗", 12, /obj/item/storage/backpack/satchel/med, null, VENDOR_ITEM_REGULAR),
	list("USCM 无线电话员背包", 12, /obj/item/storage/backpack/marine/satchel/rto, null, VENDOR_ITEM_REGULAR),
	list("USCM 焊接背包", 12, /obj/item/storage/backpack/marine/engineerpack, null, VENDOR_ITEM_REGULAR),
	list("USCM 焊接挎包", 12, /obj/item/storage/backpack/marine/engineerpack/satchel, null, VENDOR_ITEM_REGULAR),
	list("USCM 焊接胸挂", 12, /obj/item/storage/backpack/marine/engineerpack/welder_chestrig, null, VENDOR_ITEM_REGULAR),

	list("其他", 0, null, null, null),
	list("红色臂带", 6, /obj/item/clothing/accessory/armband, null, VENDOR_ITEM_REGULAR),
	list("紫色臂带", 6, /obj/item/clothing/accessory/armband/science, null, VENDOR_ITEM_REGULAR),
	list("黄色臂带", 6, /obj/item/clothing/accessory/armband/engine, null, VENDOR_ITEM_REGULAR),
	list("绿色臂带", 6, /obj/item/clothing/accessory/armband/medgreen, null, VENDOR_ITEM_REGULAR),
	list("蓝色领带", 6, /obj/item/clothing/accessory/blue, null, VENDOR_ITEM_REGULAR),
	list("绿色领带", 6, /obj/item/clothing/accessory/green, null, VENDOR_ITEM_REGULAR),
	list("黑色领带", 6, /obj/item/clothing/accessory/black, null, VENDOR_ITEM_REGULAR),
	list("金色领带", 6, /obj/item/clothing/accessory/gold, null, VENDOR_ITEM_REGULAR),
	list("红色领带", 6, /obj/item/clothing/accessory/red, null, VENDOR_ITEM_REGULAR),
	list("紫色领带", 6, /obj/item/clothing/accessory/purple, null, VENDOR_ITEM_REGULAR),
	list("听诊器", 6, /obj/item/clothing/accessory/stethoscope, null, VENDOR_ITEM_REGULAR),
	list("礼服手套", 6, /obj/item/clothing/gloves/marine/dress, null, VENDOR_ITEM_REGULAR),

))

/obj/structure/machinery/cm_vending/clothing/synth/snowflake
	name = "W-Y 合成人标准化装置"
	desc = "印有巨大雪花图案的售货机。由维兰德-汤谷时装部门(TM)提供。"
	icon_state = "snowflake"
	show_points = TRUE
	use_snowflake_points = TRUE
	vendor_theme = VENDOR_THEME_COMPANY
	req_access = list(ACCESS_MARINE_SYNTH)
	vendor_role = list(JOB_SYNTH, JOB_SYNTH_SURVIVOR, JOB_WORKING_JOE, JOB_UPP_SUPPORT_SYNTH, JOB_CMB_SYN, JOB_PMC_SYNTH)

	vend_delay = 1 SECONDS

/obj/structure/machinery/cm_vending/clothing/synth/snowflake/get_listed_products(mob/user)
	return GLOB.cm_vending_clothing_synth_snowflake


//------------EXPERIMENTAL TOOLS---------------
/obj/structure/machinery/cm_vending/own_points/experimental_tools
	name = "W-Y 实验工具售货机"
	desc = "较小的售货机，连接着维兰德-汤谷研发部门(TM)特别配发的实验工具与装备储备。请小心使用。"
	icon_state = "robotics"
	available_points = 0
	available_points_to_display = 0
	vendor_theme = VENDOR_THEME_COMPANY
	req_access = list(ACCESS_MARINE_SYNTH)
	vendor_role = list(JOB_SYNTH)

/obj/structure/machinery/cm_vending/own_points/experimental_tools/redeem_token(obj/item/coin/marine/token, mob/user)
	if(token.token_type == VEND_TOKEN_SYNTH)
		if(user.drop_inv_item_to_loc(token, src))
			available_points = 30
			available_points_to_display = available_points
			to_chat(user, SPAN_NOTICE("你将[token]插入[src]。"))
			return TRUE
	return ..()

/obj/structure/machinery/cm_vending/own_points/experimental_tools/get_listed_products(mob/user)
	return GLOB.cm_vending_synth_tools

GLOBAL_LIST_INIT(cm_vending_synth_tools, list(
	list("自动胸外按压器", 15, /obj/item/clothing/suit/auto_cpr, null, VENDOR_ITEM_REGULAR),
	list("背负式消防水箱", 15, /obj/item/reagent_container/glass/watertank/atmos, null, VENDOR_ITEM_REGULAR),
	list("破障锤", 15, /obj/item/weapon/twohanded/breacher/synth, null, VENDOR_ITEM_REGULAR),
	list("紧凑型射钉枪套件", 15, /obj/effect/essentials_set/cnailgun, null, VENDOR_ITEM_REGULAR),
	list("人员监测仪", 15, /obj/item/tool/crew_monitor, null, VENDOR_ITEM_REGULAR),
	list("实验型介子护目镜", 15, /obj/item/clothing/glasses/night/experimental_mesons, null, VENDOR_ITEM_REGULAR),
	list("维护撬杠", 15, /obj/item/maintenance_jack, null, VENDOR_ITEM_REGULAR),
	list("便携式透析机", 15, /obj/item/tool/portadialysis, null, VENDOR_ITEM_REGULAR),
	list("伸缩警棍", 15, /obj/item/weapon/telebaton, null, VENDOR_ITEM_REGULAR),
))

//------------EXPERIMENTAL TOOL KITS---------------
/obj/effect/essentials_set/cnailgun
	spawned_gear_list = list(
		/obj/item/weapon/gun/smg/nailgun/compact,
		/obj/item/ammo_magazine/smg/nailgun,
		/obj/item/ammo_magazine/smg/nailgun,
		/obj/item/storage/belt/gun/m4a3/nailgun,
	)
